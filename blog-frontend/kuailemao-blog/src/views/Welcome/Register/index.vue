<script setup lang="ts">
import {computed, reactive, ref} from "vue";
import {useRouter} from "vue-router";
import {EditPen, Lock, Message, User} from "@element-plus/icons-vue";
import {ElMessage} from "element-plus";
import {sendEmail} from "@/apis/email";
import {register} from "@/apis/user";

const coldTime = ref(0);
const formRef = ref();

const router = useRouter();

const form = reactive({
  username: '',
  password: '',
  password_repeat: '',
  email: '',
  code: ''
});

// 新增类型定义
interface ApiResponse<T = any> {
  code: number;
  msg: string;
  data: T;
}

const validateUsername = (_rule: any, value: string, callback: any) => {
  if (!value) {
    callback(new Error('请输入用户名'));
  } else if (!/^[a-zA-Z0-9\u4e00-\u9fa5]+$/.test(value)) {
    callback(new Error('用户名不能包含特殊字符，只能是中/英文'));
  } else {
    callback();
  }
};

const validatePasswordRepeat = (_rule: any, value: string, callback: any) => {
  if (!value) {
    callback(new Error('请再次输入密码'));
  } else if (value !== form.password) {
    callback(new Error('两次输入的密码不一致'));
  } else {
    callback();
  }
};

const rules = {
  username: [
    {validator: validateUsername, trigger: ['blur', 'change']}
  ],
  password: [
    {required: true, message: '请输入密码', trigger: 'blur'},
    {min: 6, max: 20, message: '密码的长度必须在 6-20 个字符之间', trigger: ['blur', 'change']}
  ],
  password_repeat: [
    {validator: validatePasswordRepeat, trigger: ['blur', 'change']}
  ],
  email: [
    {required: true, message: '请输入邮件地址', trigger: 'blur'},
    {type: 'email', message: '请输入合法的电子邮件地址', trigger: ['blur', 'change']}
  ],
  code: [
    {required: true, message: '请从你的 垃圾邮箱 获取验证码', trigger: 'blur'}
  ]
};

const askCode = () => {
  if (!isEmailValid.value) {
    ElMessage.warning('请输入正确的电子邮件');
    return;
  }
  coldTime.value = 60;
  sendEmail(form.email, 'register').then((res: ApiResponse) => {
    if (res.code === 200) {
      ElMessage.success(`验证码已发送到邮箱：${form.email}，请注意查收`);
      const intervalId = setInterval(() => {
        if (coldTime.value <= 0) {
          clearInterval(intervalId);
        } else {
          coldTime.value--;
        }
      }, 1000);
    } else {
      ElMessage.warning(res.msg);
      coldTime.value = 0;
    }
  });
};

const isEmailValid = computed(() =>
    /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(form.email)
);

const registerBtn = () => {
  formRef.value.validate((valid: boolean) => {
    if (valid) {
      register(form).then((res: ApiResponse) => {
        if (res.code === 200) {
          ElMessage.success('注册成功，欢迎加入我们');
          router.replace('/login');
        } else {
          ElMessage.warning(res.msg);
        }
      });
    } else {
      ElMessage.warning('请完整填写注册表单内容');
    }
  });
};
</script>

<template>
  <div style="text-align: center;margin: 0 20px">
    <div style="margin-top: 100px">
      <div style="font-size: 25px;font-weight: bold">注册新用户</div>
      <div style="font-size: 14px;color: grey;margin-top: 1rem">
        欢迎注册我们的学习平台，请在下方填写相关信息
      </div>
    </div>

    <div style="margin-top: 50px">
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item prop="username">
          <el-input v-model.trim="form.username" maxlength="10" placeholder="用户名">
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input v-model.trim="form.password" type="password" maxlength="20" placeholder="密码">
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="password_repeat">
          <el-input v-model.trim="form.password_repeat" type="password" maxlength="20" placeholder="重复密码">
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="email">
          <el-input v-model.trim="form.email" type="email" placeholder="电子邮件地址">
            <template #prefix>
              <el-icon><Message /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="code">
          <el-row :gutter="10" style="width: 100%">
            <el-col :span="17">
              <el-input v-model.trim="form.code" maxlength="6" placeholder="请输入验证码">
                <template #prefix>
                  <el-icon><EditPen /></el-icon>
                </template>
              </el-input>
            </el-col>
            <el-col :span="5">
              <el-button
                  type="success"
                  @click="askCode"
                  :disabled="!isEmailValid || coldTime !== 0"
              >
                {{ coldTime > 0 ? `请稍后 ${coldTime} 秒` : '获取验证码' }}
              </el-button>
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
    </div>

    <div style="margin-top: 80px">
      <el-button type="warning" style="width: 270px" plain @click="registerBtn">
        立即注册
      </el-button>
    </div>

    <div style="margin-top: 20px">
      <span style="font-size: 14px;color: grey">已有账号?</span>
      <el-link style="translate: 0 -1px" @click="$router.replace('/login')">
        立即登录
      </el-link>
    </div>
  </div>
</template>

<style scoped></style>