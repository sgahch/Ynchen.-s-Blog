package xyz.kuailemao.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.concurrent.TimeUnit;

/**
 * 自定义注解，用于防止重复提交
 */
@Target(ElementType.METHOD) // 注解作用于方法上
@Retention(RetentionPolicy.RUNTIME) // 运行时有效
public @interface PreventDuplicateSubmit {

    /**
     * 防重操作限时（单位：秒）
     * 默认5秒内不允许重复提交
     */
    long expire() default 5;

    /**
     * 时间单位，默认为秒
     */
    TimeUnit timeUnit() default TimeUnit.SECONDS;

    /**
     * 提示消息
     */
    String message() default "操作过于频繁，请稍后再试";
}