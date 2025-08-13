/*
 Navicat Premium Dump SQL

 Source Server         : 123
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : 192.168.107.171:3306
 Source Schema         : Ruyu-Blog

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 17/06/2025 15:19:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for QRTZ_JOB_DETAILS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_DURABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------
-- This record is from your original dump, keeping its 0x format for JOB_DATA
INSERT INTO `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `JOB_CLASS_NAME`, `IS_DURABLE`, `IS_NONCONCURRENT`, `IS_UPDATE_DATA`, `REQUESTS_RECOVERY`, `JOB_DATA`) VALUES ('quartzScheduler', 'refreshTheCache', 'DEFAULT', '任务描述：用于每五分钟刷新一次常用数据缓存', 'xyz.kuailemao.quartz.RefreshTheCache', '1', '0', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F40000000000010770800000010000000007800);
INSERT INTO `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `JOB_CLASS_NAME`, `IS_DURABLE`, `IS_NONCONCURRENT`, `IS_UPDATE_DATA`, `REQUESTS_RECOVERY`, `JOB_DATA`) VALUES ('quartzScheduler', 'sampleJob1', 'SAMPLE_GROUP', 'A sample job for testing', 'com.example.SampleJobClass', '0', '0', '0', '0', NULL);
INSERT INTO `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `JOB_CLASS_NAME`, `IS_DURABLE`, `IS_NONCONCURRENT`, `IS_UPDATE_DATA`, `REQUESTS_RECOVERY`, `JOB_DATA`) VALUES ('quartzScheduler', 'sampleJob2', 'SAMPLE_GROUP', 'Another sample job', 'com.example.AnotherJobClass', '1', '1', '0', '1', X'DEADBEEF');

-- ----------------------------
-- Table structure for QRTZ_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PREV_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PRIORITY` int NULL DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `START_TIME` bigint NOT NULL,
  `END_TIME` bigint NULL DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `MISFIRE_INSTR` smallint NULL DEFAULT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `SCHED_NAME`(`SCHED_NAME` ASC, `JOB_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `NEXT_FIRE_TIME`, `PREV_FIRE_TIME`, `PRIORITY`, `TRIGGER_STATE`, `TRIGGER_TYPE`, `START_TIME`, `END_TIME`, `CALENDAR_NAME`, `MISFIRE_INSTR`, `JOB_DATA`) VALUES ('quartzScheduler', '6da64b5bd2ee-161d3704-6bee-45a1-8732-ed05422f5c61', 'DEFAULT', 'refreshTheCache', 'DEFAULT', NULL, 1750145074460, 1750144774460, 5, 'WAITING', 'SIMPLE', 1704198574460, 0, NULL, 0, X''); -- Empty string for JOB_DATA often represented as X'' or NULL
INSERT INTO `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `NEXT_FIRE_TIME`, `PREV_FIRE_TIME`, `PRIORITY`, `TRIGGER_STATE`, `TRIGGER_TYPE`, `START_TIME`, `END_TIME`, `CALENDAR_NAME`, `MISFIRE_INSTR`, `JOB_DATA`) VALUES ('quartzScheduler', 'sampleCronTrigger1', 'SAMPLE_GROUP', 'sampleJob1', 'SAMPLE_GROUP', 'A sample cron trigger', UNIX_TIMESTAMP() * 1000 + 60000, -1, 5, 'WAITING', 'CRON', UNIX_TIMESTAMP() * 1000, 0, NULL, 0, NULL);
INSERT INTO `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `NEXT_FIRE_TIME`, `PREV_FIRE_TIME`, `PRIORITY`, `TRIGGER_STATE`, `TRIGGER_TYPE`, `START_TIME`, `END_TIME`, `CALENDAR_NAME`, `MISFIRE_INSTR`, `JOB_DATA`) VALUES ('quartzScheduler', 'sampleSimpleTrigger1', 'SAMPLE_GROUP', 'sampleJob2', 'SAMPLE_GROUP', 'A sample simple trigger', UNIX_TIMESTAMP() * 1000 + 120000, -1, 5, 'WAITING', 'SIMPLE', UNIX_TIMESTAMP() * 1000, 0, NULL, 0, NULL);
INSERT INTO `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `NEXT_FIRE_TIME`, `PREV_FIRE_TIME`, `PRIORITY`, `TRIGGER_STATE`, `TRIGGER_TYPE`, `START_TIME`, `END_TIME`, `CALENDAR_NAME`, `MISFIRE_INSTR`, `JOB_DATA`) VALUES ('quartzScheduler', 'sampleBlobTrigger1', 'SAMPLE_GROUP', 'sampleJob1', 'SAMPLE_GROUP', 'A sample blob trigger', UNIX_TIMESTAMP() * 1000 + 180000, -1, 5, 'WAITING', 'BLOB', UNIX_TIMESTAMP() * 1000, 0, NULL, 0, NULL);


-- ----------------------------
-- Table structure for QRTZ_BLOB_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `BLOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_BLOB_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `BLOB_DATA`) VALUES ('quartzScheduler', 'sampleBlobTrigger1', 'SAMPLE_GROUP', X'CAFEBABE');

-- ----------------------------
-- Table structure for QRTZ_CALENDARS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CALENDAR_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------
INSERT INTO `QRTZ_CALENDARS` (`SCHED_NAME`, `CALENDAR_NAME`, `CALENDAR`) VALUES ('quartzScheduler', 'HolidayCalendar', X'ACED0005737200236F72672E71756172747A2E696D706C2E63616C656E6461722E486F6C6964617943616C656E6461720000000000000001020000787200276F72672E71756172747A2E696D706C2E63616C656E6461722E4261736543616C656E64617200000000000000010200024C000863616C656E64617274001A4C6F72672F71756172747A2F43616C656E6461723B4C000B6465736372697074696F6E7400124C6A6176612F6C616E672F537472696E673B787070740016US_Official_Holidays737200196A6176612E7574696C2E5472656553657457A1FA3FF3295901020000787077040000000078');
INSERT INTO `QRTZ_CALENDARS` (`SCHED_NAME`, `CALENDAR_NAME`, `CALENDAR`) VALUES ('quartzScheduler', 'WorkdayCalendar', X'ACED0005737200236F72672E71756172747A2E696D706C2E63616C656E6461722E486F6C6964617943616C656E6461720000000000000001020000787200276F72672E71756172747A2E696D706C2E63616C656E6461722E4261736543616C656E64617200000000000000010200024C000863616C656E64617274001A4C6F72672F71756172747A2F43616C656E6461723B4C000B6465736372697074696F6E7400124C6A6176612F6C616E672F537472696E673B78707074000FMyWorkdayConfig737200196A6176612E7574696C2E5472656553657457A1FA3FF3295901020000787077040000000078');

-- ----------------------------
-- Table structure for QRTZ_CRON_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CRON_EXPRESSION` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_CRON_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `CRON_EXPRESSION`, `TIME_ZONE_ID`) VALUES ('quartzScheduler', 'sampleCronTrigger1', 'SAMPLE_GROUP', '0 0/15 * * * ?', 'UTC');

-- ----------------------------
-- Table structure for QRTZ_FIRED_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ENTRY_ID` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `FIRED_TIME` bigint NOT NULL,
  `SCHED_TIME` bigint NOT NULL,
  `PRIORITY` int NOT NULL,
  `STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `ENTRY_ID`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_FIRED_TRIGGERS` (`SCHED_NAME`, `ENTRY_ID`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `INSTANCE_NAME`, `FIRED_TIME`, `SCHED_TIME`, `PRIORITY`, `STATE`, `JOB_NAME`, `JOB_GROUP`, `IS_NONCONCURRENT`, `REQUESTS_RECOVERY`) VALUES ('quartzScheduler', 'entry1_1234567890', 'sampleCronTrigger1', 'SAMPLE_GROUP', 'myInstance1', UNIX_TIMESTAMP()*1000 - 5000, UNIX_TIMESTAMP()*1000, 5, 'EXECUTING', 'sampleJob1', 'SAMPLE_GROUP', '0', '0');
INSERT INTO `QRTZ_FIRED_TRIGGERS` (`SCHED_NAME`, `ENTRY_ID`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `INSTANCE_NAME`, `FIRED_TIME`, `SCHED_TIME`, `PRIORITY`, `STATE`, `JOB_NAME`, `JOB_GROUP`, `IS_NONCONCURRENT`, `REQUESTS_RECOVERY`) VALUES ('quartzScheduler', 'entry2_1234567891', '6da64b5bd2ee-161d3704-6bee-45a1-8732-ed05422f5c61', 'DEFAULT', 'myInstance1', 1750144774460, 1750144774460, 5, 'ACQUIRED', 'refreshTheCache', 'DEFAULT', '0', '0');


-- ----------------------------
-- Table structure for QRTZ_LOCKS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `LOCK_NAME` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------
INSERT INTO `QRTZ_LOCKS` (`SCHED_NAME`, `LOCK_NAME`) VALUES ('quartzScheduler', 'TRIGGER_ACCESS');
INSERT INTO `QRTZ_LOCKS` (`SCHED_NAME`, `LOCK_NAME`) VALUES ('quartzScheduler', 'JOB_ACCESS');
INSERT INTO `QRTZ_LOCKS` (`SCHED_NAME`, `LOCK_NAME`) VALUES ('quartzScheduler', 'CALENDAR_ACCESS');
INSERT INTO `QRTZ_LOCKS` (`SCHED_NAME`, `LOCK_NAME`) VALUES ('quartzScheduler', 'STATE_ACCESS');
INSERT INTO `QRTZ_LOCKS` (`SCHED_NAME`, `LOCK_NAME`) VALUES ('quartzScheduler', 'MISFIRE_ACCESS');

-- ----------------------------
-- Table structure for QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
INSERT INTO `QRTZ_PAUSED_TRIGGER_GRPS` (`SCHED_NAME`, `TRIGGER_GROUP`) VALUES ('quartzScheduler', 'PAUSED_GROUP_1');
INSERT INTO `QRTZ_PAUSED_TRIGGER_GRPS` (`SCHED_NAME`, `TRIGGER_GROUP`) VALUES ('quartzScheduler', 'PAUSED_GROUP_2');

-- ----------------------------
-- Table structure for QRTZ_SCHEDULER_STATE
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint NOT NULL,
  `CHECKIN_INTERVAL` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------
INSERT INTO `QRTZ_SCHEDULER_STATE` (`SCHED_NAME`, `INSTANCE_NAME`, `LAST_CHECKIN_TIME`, `CHECKIN_INTERVAL`) VALUES ('quartzScheduler', 'myInstance1', UNIX_TIMESTAMP() * 1000, 15000);
INSERT INTO `QRTZ_SCHEDULER_STATE` (`SCHED_NAME`, `INSTANCE_NAME`, `LAST_CHECKIN_TIME`, `CHECKIN_INTERVAL`) VALUES ('quartzScheduler', 'myInstance2', UNIX_TIMESTAMP() * 1000 - 20000, 15000);

-- ----------------------------
-- Table structure for QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `REPEAT_COUNT` bigint NOT NULL,
  `REPEAT_INTERVAL` bigint NOT NULL,
  `TIMES_TRIGGERED` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_SIMPLE_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `REPEAT_COUNT`, `REPEAT_INTERVAL`, `TIMES_TRIGGERED`) VALUES ('quartzScheduler', '6da64b5bd2ee-161d3704-6bee-45a1-8732-ed05422f5c61', 'DEFAULT', -1, 300000, 153197);
INSERT INTO `QRTZ_SIMPLE_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `REPEAT_COUNT`, `REPEAT_INTERVAL`, `TIMES_TRIGGERED`) VALUES ('quartzScheduler', 'sampleSimpleTrigger1', 'SAMPLE_GROUP', 10, 60000, 0);


-- ----------------------------
-- Table structure for QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `STR_PROP_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `STR_PROP_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `STR_PROP_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `INT_PROP_1` int NULL DEFAULT NULL,
  `INT_PROP_2` int NULL DEFAULT NULL,
  `LONG_PROP_1` bigint NULL DEFAULT NULL,
  `LONG_PROP_2` bigint NULL DEFAULT NULL,
  `DEC_PROP_1` decimal(13, 4) NULL DEFAULT NULL,
  `DEC_PROP_2` decimal(13, 4) NULL DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_SIMPROP_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `STR_PROP_1`, `STR_PROP_2`, `STR_PROP_3`, `INT_PROP_1`, `INT_PROP_2`, `LONG_PROP_1`, `LONG_PROP_2`, `DEC_PROP_1`, `DEC_PROP_2`, `BOOL_PROP_1`, `BOOL_PROP_2`) VALUES ('quartzScheduler', 'sampleSimpleTrigger1', 'SAMPLE_GROUP', 'stringPropValue1', 'stringPropValue2', NULL, 123, 456, 1000, 2000, 123.4500, 678.9000, '1', '0');


-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模块名称',
  `operation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作人员',
  `ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'ip地址',
  `address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作地点',
  `state` tinyint(1) NOT NULL COMMENT '操作状态(0：成功，1：失败，2：异常)',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作方法',
  `req_parameter` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求参数',
  `req_mapping` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求方式',
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '异常信息',
  `return_parameter` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '返回参数',
  `req_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求地址',
  `time` bigint NOT NULL COMMENT '消耗时间(ms)',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '接口描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11556 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_log
-- ----------------------------
INSERT INTO `sys_log` VALUES (11545, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 33, '前台获取所有前台首页Banner图片', '2025-06-17 13:49:18', '2025-06-17 13:49:18', 0);
INSERT INTO `sys_log` VALUES (11546, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 253, '前台获取所有前台首页Banner图片', '2025-06-17 14:08:34', '2025-06-17 14:08:35', 0);
INSERT INTO `sys_log` VALUES (11547, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 9, '前台获取所有前台首页Banner图片', '2025-06-17 14:10:55', '2025-06-17 14:10:55', 0);
INSERT INTO `sys_log` VALUES (11548, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 2754, '前台获取所有前台首页Banner图片', '2025-06-17 15:09:52', '2025-06-17 15:09:52', 0);
INSERT INTO `sys_log` VALUES (11549, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 73, '前台获取所有前台首页Banner图片', '2025-06-17 15:10:41', '2025-06-17 15:10:41', 0);
INSERT INTO `sys_log` VALUES (11550, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 167, '前台获取所有前台首页Banner图片', '2025-06-17 15:12:54', '2025-06-17 15:12:54', 0);
INSERT INTO `sys_log` VALUES (11551, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 30, '前台获取所有前台首页Banner图片', '2025-06-17 15:14:07', '2025-06-17 15:14:07', 0);
INSERT INTO `sys_log` VALUES (11552, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 7094, '前台获取所有前台首页Banner图片', '2025-06-17 15:15:15', '2025-06-17 15:15:15', 0);
INSERT INTO `sys_log` VALUES (11553, '信息管理', '获取', 'unknown-1702606997', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.BannersController.getBanners()', '[]', 'GET', NULL, '{\"code\":200,\"data\":[],\"msg\":\"success\"}', '/banners/list', 30, '前台获取所有前台首页Banner图片', '2025-06-17 15:16:57', '2025-06-17 15:16:57', 0);
INSERT INTO `sys_log` (`module`, `operation`, `user_name`, `ip`, `address`, `state`, `method`, `req_parameter`, `req_mapping`, `exception`, `return_parameter`, `req_address`, `time`, `description`, `create_time`, `update_time`, `is_deleted`) VALUES ('用户模块', '登录', 'Admin', '127.0.0.1', '内网IP', 0, 'xyz.kuailemao.controller.AuthController.login()', '{\"username\":\"Admin\",\"password\":\"******\"}', 'POST', NULL, '{\"code\":200,\"data\":{...},\"msg\":\"success\"}', '/auth/login', 150, '用户登录', NOW(), NOW(), 0);
INSERT INTO `sys_log` (`module`, `operation`, `user_name`, `ip`, `address`, `state`, `method`, `req_parameter`, `req_mapping`, `exception`, `return_parameter`, `req_address`, `time`, `description`, `create_time`, `update_time`, `is_deleted`) VALUES ('文章模块', '发布', 'Ynchen', '192.168.1.101', '广东省深圳市', 0, 'xyz.kuailemao.controller.ArticleController.publishArticle()', '{\"title\":\"New Article\",\"content\":\"...\"}', 'POST', NULL, '{\"code\":200,\"data\":{...},\"msg\":\"success\"}', '/article/publish', 250, '发布新文章', NOW(), NOW(), 0);


-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名称',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录ip',
  `address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录地址',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '浏览器',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作系统',
  `type` tinyint(1) NOT NULL COMMENT '登录类型(0：前台，1：后台，2：非法登录)',
  `state` tinyint(1) NOT NULL COMMENT '登录状态(0：成功，1：失败)',
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录信息',
  `create_time` datetime NOT NULL COMMENT '用户创建时间',
  `update_time` datetime NOT NULL COMMENT '用户更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2277 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_login_log
-- ----------------------------
INSERT INTO `sys_login_log` (`user_name`, `ip`, `address`, `browser`, `os`, `type`, `state`, `message`, `create_time`, `update_time`, `is_deleted`) VALUES ('Admin', '127.0.0.1', '内网IP', 'Chrome 100', 'Windows 10', 1, 0, '登录成功', '2025-06-17 10:00:00', '2025-06-17 10:00:00', 0);
INSERT INTO `sys_login_log` (`user_name`, `ip`, `address`, `browser`, `os`, `type`, `state`, `message`, `create_time`, `update_time`, `is_deleted`) VALUES ('Test', '192.168.0.101', '局域网', 'Firefox 99', 'MacOS Ventura', 0, 1, '密码错误', '2025-06-17 10:05:00', '2025-06-17 10:05:00', 0);
INSERT INTO `sys_login_log` (`user_name`, `ip`, `address`, `browser`, `os`, `type`, `state`, `message`, `create_time`, `update_time`, `is_deleted`) VALUES ('ynchen', '192.168.107.240', '广东省深圳市', 'Edge 101', 'Windows 11', 0, 0, 'Gitee登录成功', NOW(), NOW(), 0);


-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '绑定的哪个组件，默认自带的组件类型分别是：Iframe、RouteView和ComponentError',
  `redirect` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '父菜单重定向地址(默认第一个子菜单)',
  `affix` tinyint NOT NULL DEFAULT 0 COMMENT '是否是固定页签(0否 1是)',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父级菜单的id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '同路由中的name，主要是用于保活的左右',
  `hide_in_menu` tinyint NOT NULL DEFAULT 0 COMMENT '是否隐藏当前菜单(0否 1是)',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '如果当前是iframe的模式，需要有一个跳转的url支撑，其不能和path重复，path还是为路由',
  `hide_in_breadcrumb` tinyint NOT NULL DEFAULT 1 COMMENT '是否存在于面包屑(0否 1是)',
  `hide_children_in_menu` tinyint NOT NULL DEFAULT 1 COMMENT '是否不需要显示所有的子菜单(0否 1是)',
  `keep_alive` tinyint NOT NULL DEFAULT 1 COMMENT '是否保活(0否 1是)',
  `target` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '全连接跳转模式(\'_blank\' | \'_self\' | \'_parent\')',
  `is_disable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 (0否 1是)',
  `order_num` int NOT NULL DEFAULT 1 COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 'SettingTwoTone', '/system', 'RouteView', '/system/menu', 0, NULL, 'System', 0, NULL, 1, 0, 1, NULL, 0, 2, '2023-11-17 14:49:02', '2023-11-29 17:33:13', 0);
INSERT INTO `sys_menu` VALUES (2, '菜单管理', 'MenuOutlined', '/system/menu', '/system/menu', '', 0, 1, 'Menu', 0, NULL, 1, 0, 1, NULL, 0, 1, '2023-11-17 14:49:02', '2023-11-28 17:27:43', 0);
INSERT INTO `sys_menu` VALUES (3, '用户管理', 'UserOutlined', '/system/user', '/system/user', '', 0, 1, 'User', 0, NULL, 1, 0, 1, NULL, 0, 0, '2023-11-17 14:49:02', '2023-11-29 14:46:27', 0);
INSERT INTO `sys_menu` VALUES (21, '首页', 'HomeTwoTone', '/welcome', '/welcome', NULL, 0, NULL, NULL, 0, NULL, 1, 1, 1, '', 0, 0, '2023-11-28 16:36:33', '2024-07-13 21:56:58', 0);
INSERT INTO `sys_menu` VALUES (23, '角色管理', 'TeamOutlined', '/system/role', '/system/role', NULL, 0, 1, NULL, 0, NULL, 1, 1, 1, '', 0, 3, '2023-11-29 15:41:30', '2023-12-04 12:16:00', 0);
INSERT INTO `sys_menu` VALUES (24, '权限管理', 'UnlockOutlined', '/system/permission', '/system/permission', '', 0, 1, NULL, 0, NULL, 1, 1, 1, '', 0, 4, '2023-11-29 17:13:50', '2023-11-29 17:14:10', 0);
INSERT INTO `sys_menu` VALUES (25, '日志管理', 'HighlightOutlined', '/log', 'RouteView', '/log/operate', 0, 1, NULL, 0, '', 1, 1, 1, '', 0, 5, '2023-11-29 17:17:29', '2023-11-29 17:17:29', 0);
INSERT INTO `sys_menu` VALUES (26, '操作日志', 'FileProtectOutlined', '/log/operate', '/system/log/operate', '', 0, 25, NULL, 0, NULL, 1, 1, 1, '', 0, 0, '2023-11-29 17:20:28', '2023-11-29 17:29:20', 0);
INSERT INTO `sys_menu` VALUES (27, '登录日志', 'SolutionOutlined', '/log/login', '/system/log/login', '', 0, 25, NULL, 0, '', 1, 1, 1, '', 0, 1, '2023-11-29 17:29:02', '2023-11-29 17:29:02', 0);
INSERT INTO `sys_menu` VALUES (28, '网站管理', 'AppstoreTwoTone', '/blog', 'RouteView', NULL, 0, NULL, NULL, 0, NULL, 1, 1, 1, '', 0, 1, '2023-11-29 17:34:17', '2024-07-30 03:28:43', 0);
INSERT INTO `sys_menu` VALUES (29, '信息管理', 'ReadOutlined', '/blog/info', '/blog/info', '', 0, 28, NULL, 0, NULL, 1, 1, 1, '', 0, 0, '2023-11-29 20:05:20', '2023-11-29 20:09:38', 0);
INSERT INTO `sys_menu` VALUES (30, '文章管理', 'FormOutlined', '/blog/essay', '', NULL, 0, 28, NULL, 0, NULL, 1, 1, 1, '', 0, 0, '2023-11-29 20:11:25', '2023-12-26 11:16:20', 0);
INSERT INTO `sys_menu` VALUES (31, '发布文章', 'SendOutlined', '/blog/essay/publish', '/blog/essay/publish', '', 0, 30, NULL, 0, '', 1, 1, 1, '', 0, 0, '2023-11-29 20:13:00', '2023-11-29 20:13:00', 0);
INSERT INTO `sys_menu` VALUES (32, '文章列表', 'OrderedListOutlined', '/blog/essay/list', '/blog/essay/list', '', 0, 30, NULL, 0, '', 1, 1, 1, '', 0, 0, '2023-11-29 20:14:13', '2023-11-29 20:14:13', 0);
INSERT INTO `sys_menu` VALUES (33, '标签管理', 'TagsOutlined', '/blog/tag', '/blog/tag', '', 0, 28, NULL, 0, NULL, 1, 1, 1, '', 0, 2, '2023-11-29 20:15:13', '2023-11-29 20:20:28', 0);
INSERT INTO `sys_menu` VALUES (34, '分类管理', 'ContainerOutlined', '/blog/category', '/blog/category', '', 0, 28, NULL, 0, '', 1, 1, 1, '', 0, 3, '2023-11-29 20:19:09', '2023-11-29 20:19:09', 0);
INSERT INTO `sys_menu` VALUES (35, '评论管理', 'CommentOutlined', '/blog/comment', '/blog/comment', '', 0, 28, NULL, 0, NULL, 1, 1, 1, '', 0, 4, '2023-11-29 20:21:48', '2023-11-29 20:22:06', 0);
INSERT INTO `sys_menu` VALUES (36, '留言管理', 'ScheduleOutlined', '/blog/message', '/blog/message', NULL, 0, 28, NULL, 0, NULL, 1, 1, 1, '', 0, 1, '2023-11-29 20:23:19', '2023-12-26 11:16:24', 0);
INSERT INTO `sys_menu` VALUES (37, '树洞管理', 'BulbOutlined', '/blog/tree-hole', '/blog/tree-hole', '', 0, 28, NULL, 0, '', 1, 1, 1, '', 0, 5, '2023-11-29 20:27:40', '2023-11-29 20:27:40', 0);
INSERT INTO `sys_menu` VALUES (39, '友链管理', 'NodeIndexOutlined', '/blog/link', '/blog/link', NULL, 0, 28, NULL, 0, NULL, 1, 1, 1, '', 0, 6, '2023-11-29 20:31:25', '2024-01-22 20:27:26', 0);
INSERT INTO `sys_menu` VALUES (42, '数据大屏', 'PieChartTwoTone', '/data-screen', '/data-screen', NULL, 0, NULL, NULL, 1, NULL, 1, 1, 1, '', 0, 4, '2023-11-29 20:51:14', '2024-01-22 22:07:04', 0);
INSERT INTO `sys_menu` VALUES (43, '收藏管理', 'InboxOutlined', '/blog/collect', '/blog/collect', NULL, 0, 28, NULL, 0, NULL, 1, 1, 1, '', 0, 3, '2023-11-29 20:54:15', '2023-11-29 20:54:47', 0);
INSERT INTO `sys_menu` VALUES (44, '服务监控', 'AlertOutlined', '/system/server-monitoring', '/system/server-monitoring', NULL, 0, 1, NULL, 0, NULL, 1, 1, 1, '', 0, 6, '2023-11-29 21:01:24', '2023-12-14 15:26:34', 0);
INSERT INTO `sys_menu` VALUES (64, '角色授权', '', '/role/authorization', '/system/role/user-role', NULL, 0, 1, NULL, 1, NULL, 1, 1, 1, '', 0, 0, '2023-12-04 12:07:00', '2023-12-05 09:57:09', 0);
INSERT INTO `sys_menu` VALUES (65, '权限授权', '', '/permission/authorization', '/system/permission/role-permission', NULL, 0, 1, NULL, 1, NULL, 1, 1, 1, '', 0, 0, '2023-12-07 14:38:45', '2024-03-01 11:17:44', 0);
INSERT INTO `sys_menu` VALUES (68, '用户授权', '', '/user/role', '/system/user/role-user', NULL, 0, 1, NULL, 1, NULL, 1, 1, 1, '', 0, 0, '2023-12-19 10:37:05', '2024-03-01 11:17:01', 0);
INSERT INTO `sys_menu` VALUES (69, '接口文档', 'FileTextTwoTone', 'http://kuailemao.xyz:8088/doc.html#/home', NULL, NULL, 0, NULL, NULL, 0, 'http://127.0.0.1:8088/doc.html#/home', 1, 1, 1, '_blank', 0, 5, '2024-01-22 20:32:18', '2024-04-29 11:57:32', 0);
INSERT INTO `sys_menu` VALUES (70, '跳转前台', 'TabletTwoTone', 'http://kuailemao.xyz', NULL, NULL, 0, NULL, NULL, 0, '', 1, 1, 1, '_blank', 0, 6, '2024-01-22 20:38:54', '2024-04-29 11:55:51', 0);
INSERT INTO `sys_menu` VALUES (71, '黑名单管理', 'AuditOutlined', '/blog/blackList', '/blog/black-list', '', 0, 28, NULL, 0, '', 1, 1, 1, '', 0, 7, '2024-10-11 17:40:15', '2024-10-11 17:40:15', 0);
INSERT INTO `sys_menu` (`title`, `icon`, `path`, `component`, `redirect`, `affix`, `parent_id`, `name`, `hide_in_menu`, `url`, `hide_in_breadcrumb`, `hide_children_in_menu`, `keep_alive`, `target`, `is_disable`, `order_num`, `create_time`, `update_time`, `is_deleted`) VALUES ('相册管理', 'CameraOutlined', '/blog/photo', '/blog/photo', NULL, 0, 28, 'PhotoManagement', 0, NULL, 1, 1, 1, NULL, 0, 8, NOW(), NOW(), 0);

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '权限表id',
  `permission_desc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '描述',
  `permission_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限字符',
  `menu_id` bigint NOT NULL COMMENT '菜单id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 162 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (5, '获取菜单', 'system:menu:list', 2, '2023-12-06 08:41:49', '2023-12-14 17:21:57', 0);
INSERT INTO `sys_permission` VALUES (6, '查询菜单', 'system:menu:select', 2, '2023-12-05 08:41:54', '2023-12-07 12:02:31', 0);
INSERT INTO `sys_permission` VALUES (7, '修改菜单', 'system:menu:update', 2, '2023-12-04 08:41:54', '2023-12-12 20:36:49', 0);
INSERT INTO `sys_permission` VALUES (8, '删除菜单', 'system:menu:delete', 2, '2023-12-04 08:41:54', '2023-12-11 21:03:10', 0);
INSERT INTO `sys_permission` VALUES (9, '添加菜单', 'system:menu:add', 2, '2023-12-02 08:41:54', '2023-12-04 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (10, '修改菜单角色列表', 'system:menu:role:list', 2, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (11, '获取所有角色', 'system:role:list', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (12, '更新角色状态', 'system:role:status:update', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (13, '获取对应角色信息', 'system:role:get', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (14, '修改角色信息', 'system:role:update', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (15, '根据id删除角色', 'system:role:delete', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (16, '根据条件搜索角色', 'system:role:search', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (17, '查询拥有角色的用户列表', 'system:user:role:list', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (18, '查询未拥有角色的用户列表', 'system:not:role:user:list', 23, '2023-12-02 08:41:54', '2023-12-06 10:43:49', 0);
INSERT INTO `sys_permission` VALUES (19, '添加用户角色关系', 'system:user:role:add', 23, '2023-12-05 08:41:54', '2023-12-11 21:02:51', 0);
INSERT INTO `sys_permission` VALUES (20, '删除用户角色关系', 'system:user:role:delete', 23, '2023-12-02 08:41:54', '2023-12-02 08:41:54', 0);
INSERT INTO `sys_permission` VALUES (21, '所有权限', 'system:permission:list', 24, '2023-12-06 10:34:21', '2023-12-06 10:34:24', 0);
INSERT INTO `sys_permission` VALUES (22, '查询所有权限所在菜单', 'system:permission:menu:list', 24, '2023-12-06 14:26:28', '2023-12-06 14:26:31', 0);
INSERT INTO `sys_permission` VALUES (23, '搜索权限', 'system:permission:search', 24, '2023-12-06 15:18:29', '2023-12-06 15:18:33', 0);
INSERT INTO `sys_permission` VALUES (24, '添加权限', 'system:permission:add', 24, '2023-12-06 19:12:47', '2023-12-06 19:12:50', 0);
INSERT INTO `sys_permission` VALUES (27, '获取要修改的权限信息', 'system:permission:get', 24, '2023-12-06 20:48:33', '2023-12-06 20:48:33', 0);
INSERT INTO `sys_permission` VALUES (28, '修改权限字符信息', 'system:permission:update', 24, '2023-12-07 12:01:34', '2023-12-07 12:01:36', 0);
INSERT INTO `sys_permission` VALUES (30, '删除权限', 'system:permission:delete', 24, '2023-12-07 12:14:14', '2023-12-07 12:14:14', 0);
INSERT INTO `sys_permission` VALUES (31, '查询权限的角色列表', 'system:permission:role:list', 65, '2023-12-07 15:02:03', '2023-12-07 15:02:03', 0);
INSERT INTO `sys_permission` VALUES (33, '查询没有该权限的角色列表', 'system:permission:role:not:list', 65, '2023-12-07 17:41:38', '2023-12-07 17:41:38', 0);
INSERT INTO `sys_permission` VALUES (34, '单个/批量添加角色权限关系', 'system:permission:role:add', 65, '2023-12-07 20:53:14', '2023-12-08 10:51:10', 0);
INSERT INTO `sys_permission` VALUES (35, '删除角色权限关系', 'system:permission:role:delete', 65, '2023-12-07 21:00:55', '2023-12-07 21:00:55', 0);
INSERT INTO `sys_permission` VALUES (36, '显示所有登录日志', 'system:log:login:list', 27, '2023-12-11 16:20:00', '2023-12-14 17:48:07', 0);
INSERT INTO `sys_permission` VALUES (37, '登录日志搜索', 'system:log:login:search', 27, '2023-12-11 19:51:27', '2023-12-11 19:51:27', 0);
INSERT INTO `sys_permission` VALUES (38, '删除/清空登录日志', 'system:log:login:delete', 27, '2023-12-11 20:19:08', '2023-12-11 20:19:08', 0);
INSERT INTO `sys_permission` VALUES (45, '显示所有操作日志', 'system:log:list', 26, '2023-12-13 16:13:41', '2023-12-13 16:13:41', 0);
INSERT INTO `sys_permission` VALUES (87, '添加角色信息', 'system:role:add', 23, '2023-12-13 17:23:42', '2023-12-13 17:23:42', 0);
INSERT INTO `sys_permission` VALUES (91, '搜索操作日志', 'system:log:search', 26, '2023-12-13 20:43:04', '2023-12-13 20:43:04', 0);
INSERT INTO `sys_permission` VALUES (92, '删除/清空操作日志', 'system:log:delete', 26, '2023-12-14 08:45:38', '2023-12-14 08:45:38', 0);
INSERT INTO `sys_permission` VALUES (93, 'id查询操作日志', 'system:log:select:id', 26, '2023-12-14 09:00:53', '2023-12-14 09:00:53', 0);
INSERT INTO `sys_permission` VALUES (94, '获取服务监控数据', 'monitor:server:list', 44, '2023-12-14 15:21:21', '2023-12-14 15:21:21', 0);
INSERT INTO `sys_permission` VALUES (97, '获取用户列表', 'system:user:list', 3, '2023-12-18 12:07:00', '2023-12-18 12:07:00', 0);
INSERT INTO `sys_permission` VALUES (98, '搜索用户列表', 'system:user:search', 3, '2023-12-18 14:15:46', '2023-12-18 14:15:46', 0);
INSERT INTO `sys_permission` VALUES (99, '更新用户状态', 'system:user:status:update', 3, '2023-12-18 15:11:34', '2023-12-18 15:11:34', 0);
INSERT INTO `sys_permission` VALUES (100, '获取用户详细信息', 'system:user:details', 3, '2023-12-18 16:40:52', '2023-12-18 16:40:52', 0);
INSERT INTO `sys_permission` VALUES (101, '删除用户&用户角色关系', 'system:user:delete', 3, '2023-12-19 10:11:46', '2023-12-19 10:12:15', 0);
INSERT INTO `sys_permission` VALUES (102, '查询没有该用户的角色列表', 'system:user:role:not:list', 23, '2023-12-19 11:10:11', '2023-12-19 11:10:11', 0);
INSERT INTO `sys_permission` VALUES (103, '查询拥有用户的角色列表', 'system:role:user:list', 23, '2023-12-19 11:17:55', '2023-12-19 11:17:55', 0);
INSERT INTO `sys_permission` VALUES (104, '搜索管理菜单列表', 'system:search:menu:list', 2, '2023-12-25 11:48:02', '2023-12-25 11:48:02', 0);
INSERT INTO `sys_permission` VALUES (105, '添加或修改站长信息', 'blog:update:websiteInfo', 29, '2023-12-27 16:19:23', '2024-01-04 10:49:12', 0);
INSERT INTO `sys_permission` VALUES (106, '查看网站信息-后台', 'blog:get:websiteInfo', 29, '2023-12-29 08:52:51', '2024-01-22 22:18:56', 0);
INSERT INTO `sys_permission` VALUES (107, '新增标签', 'blog:tag:add', 33, '2024-01-04 10:55:39', '2024-01-04 10:55:39', 0);
INSERT INTO `sys_permission` VALUES (108, '新增分类', 'blog:category:add', 34, '2024-01-04 11:17:12', '2024-01-04 11:17:12', 0);
INSERT INTO `sys_permission` VALUES (109, '发布文章相关', 'blog:publish:article', 31, '2024-01-05 15:01:54', '2024-01-05 15:01:54', 0);
INSERT INTO `sys_permission` VALUES (110, '获取文章列表', 'blog:article:list', 32, '2024-01-07 11:28:14', '2024-01-07 11:28:14', 0);
INSERT INTO `sys_permission` VALUES (111, '搜索文章', 'blog:article:search', 32, '2024-01-07 19:30:10', '2024-01-07 19:30:10', 0);
INSERT INTO `sys_permission` VALUES (112, '修改文章', 'blog:article:update', 32, '2024-01-07 19:56:37', '2024-01-07 19:56:37', 0);
INSERT INTO `sys_permission` VALUES (113, '回显文章数据', 'blog:article:echo', 31, '2024-01-08 09:24:01', '2024-01-08 09:24:01', 0);
INSERT INTO `sys_permission` VALUES (114, '删除文章', 'blog:article:delete', 30, '2024-01-08 11:29:23', '2024-01-08 11:29:23', 0);
INSERT INTO `sys_permission` VALUES (115, '后台留言列表', 'blog:leaveword:list', 36, '2024-01-12 21:14:18', '2024-01-12 21:14:18', 0);
INSERT INTO `sys_permission` VALUES (116, '搜索后台留言列表', 'blog:leaveword:search', 36, '2024-01-16 08:50:46', '2024-01-16 08:50:46', 0);
INSERT INTO `sys_permission` VALUES (117, '修改留言是否通过', 'blog:leaveword:isCheck', 36, '2024-01-16 10:02:20', '2024-01-16 10:02:20', 0);
INSERT INTO `sys_permission` VALUES (118, '删除留言', 'blog:leaveword:delete', 36, '2024-01-16 11:11:59', '2024-01-16 11:11:59', 0);
INSERT INTO `sys_permission` VALUES (119, '获取标签列表', 'blog:tag:list', 33, '2024-01-18 14:30:10', '2024-01-18 14:30:10', 0);
INSERT INTO `sys_permission` VALUES (120, '搜索标签列表', 'blog:tag:search', 33, '2024-01-18 14:47:10', '2024-01-18 14:47:10', 0);
INSERT INTO `sys_permission` VALUES (121, '修改标签', 'blog:tag:update', 33, '2024-01-18 15:56:45', '2024-01-18 15:56:45', 0);
INSERT INTO `sys_permission` VALUES (122, '删除标签', 'blog:tag:delete', 33, '2024-01-18 16:16:41', '2024-01-18 16:16:41', 0);
INSERT INTO `sys_permission` VALUES (123, '获取分类列表', 'blog:category:list', 34, '2024-01-18 22:42:29', '2024-01-18 22:43:28', 0);
INSERT INTO `sys_permission` VALUES (124, '搜索分类列表', 'blog:category:search', 34, '2024-01-18 22:43:06', '2024-01-18 22:43:06', 0);
INSERT INTO `sys_permission` VALUES (125, '修改分类', 'blog:category:update', 34, '2024-01-18 22:44:21', '2024-01-18 22:44:21', 0);
INSERT INTO `sys_permission` VALUES (126, '删除分类', 'blog:category:delete', 34, '2024-01-18 22:44:51', '2024-01-18 22:44:51', 0);
INSERT INTO `sys_permission` VALUES (127, '后台树洞列表', 'blog:treeHole:list', 37, '2024-01-19 21:25:39', '2024-01-19 21:25:39', 0);
INSERT INTO `sys_permission` VALUES (128, '搜索后台树洞列表', 'blog:treeHole:search', 37, '2024-01-19 21:26:03', '2024-01-19 21:26:03', 0);
INSERT INTO `sys_permission` VALUES (129, '修改树洞是否通过', 'blog:treeHole:isCheck', 37, '2024-01-19 21:26:28', '2024-01-19 21:26:28', 0);
INSERT INTO `sys_permission` VALUES (130, '删除树洞', 'blog:treeHole:delete', 37, '2024-01-19 21:27:20', '2024-01-19 21:27:20', 0);
INSERT INTO `sys_permission` VALUES (131, '搜索后台收藏列表', 'blog:favorite:search', 43, '2024-01-21 09:36:25', '2024-01-21 09:36:25', 0);
INSERT INTO `sys_permission` VALUES (132, '修改收藏是否通过', 'blog:favorite:isCheck', 43, '2024-01-21 09:36:47', '2024-01-21 09:36:47', 0);
INSERT INTO `sys_permission` VALUES (133, '删除收藏', 'blog:favorite:delete', 43, '2024-01-21 09:37:11', '2024-01-21 09:37:11', 0);
INSERT INTO `sys_permission` VALUES (134, '后台收藏列表', 'blog:favorite:list', 43, '2024-01-21 09:39:35', '2024-01-21 09:39:35', 0);
INSERT INTO `sys_permission` VALUES (140, '后台评论列表', 'blog:comment:list', 35, '2024-01-22 09:40:40', '2024-01-22 09:40:40', 0);
INSERT INTO `sys_permission` VALUES (141, '搜索后台评论列表', 'blog:comment:search', 35, '2024-01-22 11:02:58', '2024-01-22 11:02:58', 0);
INSERT INTO `sys_permission` VALUES (142, '修改评论是否通过', 'blog:comment:isCheck', 35, '2024-01-22 20:01:50', '2024-01-22 20:01:50', 0);
INSERT INTO `sys_permission` VALUES (143, '删除评论', 'blog:comment:delete', 35, '2024-01-22 20:02:20', '2024-01-22 20:02:20', 0);
INSERT INTO `sys_permission` VALUES (144, '后台友链列表', 'blog:link:list', 39, '2024-01-22 21:03:24', '2024-01-22 21:03:24', 0);
INSERT INTO `sys_permission` VALUES (145, '搜索后台友链列表', 'blog:link:search', 39, '2024-01-22 21:03:46', '2024-01-22 21:03:46', 0);
INSERT INTO `sys_permission` VALUES (146, '修改友链是否通过', 'blog:link:isCheck', 39, '2024-01-22 21:04:18', '2024-01-22 21:04:18', 0);
INSERT INTO `sys_permission` VALUES (147, '删除友链', 'blog:link:delete', 39, '2024-01-22 21:04:46', '2024-01-22 21:04:46', 0);
INSERT INTO `sys_permission` VALUES (150, '后台获取所有前台首页Banner图片', 'blog:banner:list', 29, '2024-09-02 11:44:19', '2024-09-02 11:44:19', 0);
INSERT INTO `sys_permission` VALUES (151, '删除前台首页Banner图片', 'blog:banner:delete', 29, '2024-09-02 11:44:34', '2024-09-02 11:44:34', 0);
INSERT INTO `sys_permission` VALUES (152, '添加前台首页Banner图片', 'blog:banner:add', 29, '2024-09-02 11:44:50', '2024-09-02 11:44:50', 0);
INSERT INTO `sys_permission` VALUES (153, '更新前台首页Banner图片顺序', 'blog:banner:update', 29, '2024-09-02 11:45:07', '2024-09-02 11:45:07', 0);
INSERT INTO `sys_permission` VALUES (154, '添加黑名单', 'blog:black:add', 71, '2024-10-11 17:41:07', '2024-10-11 17:41:07', 0);
INSERT INTO `sys_permission` VALUES (155, '修改黑名单', 'blog:black:update', 71, '2024-10-11 17:41:21', '2024-10-11 17:41:21', 0);
INSERT INTO `sys_permission` VALUES (156, '查询黑名单', 'blog:black:select', 71, '2024-10-11 17:41:35', '2024-10-11 17:41:35', 0);
INSERT INTO `sys_permission` VALUES (157, '删除黑名单', 'blog:black:delete', 71, '2024-10-11 17:41:47', '2024-10-11 17:41:47', 0);
INSERT INTO `sys_permission` (`permission_desc`, `permission_key`, `menu_id`, `create_time`, `update_time`, `is_deleted`) VALUES ('相册管理-查看', 'blog:photo:list', 72, NOW(), NOW(), 0);
INSERT INTO `sys_permission` (`permission_desc`, `permission_key`, `menu_id`, `create_time`, `update_time`, `is_deleted`) VALUES ('相册管理-新增', 'blog:photo:add', 72, NOW(), NOW(), 0);
INSERT INTO `sys_permission` (`permission_desc`, `permission_key`, `menu_id`, `create_time`, `update_time`, `is_deleted`) VALUES ('相册管理-修改', 'blog:photo:update', 72, NOW(), NOW(), 0);
INSERT INTO `sys_permission` (`permission_desc`, `permission_key`, `menu_id`, `create_time`, `update_time`, `is_deleted`) VALUES ('相册管理-删除', 'blog:photo:delete', 72, NOW(), NOW(), 0);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色字符',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态（0：正常，1：停用）',
  `order_num` bigint NOT NULL COMMENT '排序',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'ADMIN', 0, 0, '最高管理者', '2023-11-17 15:19:01', '2023-12-14 16:47:07', 0);
INSERT INTO `sys_role` VALUES (2, '测试角色', 'Test', 0, 1, '测试的用户，没有任何操作权限', '2023-11-17 15:19:06', '2024-07-31 08:41:49', 0);
INSERT INTO `sys_role` VALUES (3, '普通用户', 'USER', 0, 3, '前台普通用户（前台用户默认角色）', '2023-12-03 21:12:24', '2023-12-14 17:15:52', 0);
INSERT INTO `sys_role` (`role_name`, `role_key`, `status`, `order_num`, `remark`, `create_time`, `update_time`, `is_deleted`) VALUES ('内容编辑', 'EDITOR', 0, 2, '负责网站内容编辑和管理', NOW(), NOW(), 0);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint NOT NULL COMMENT '角色id',
  `menu_id` bigint NOT NULL COMMENT '菜单id',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1436 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1292, 1, 29, 0);
INSERT INTO `sys_role_menu` VALUES (1295, 1, 31, 0);
INSERT INTO `sys_role_menu` VALUES (1296, 1, 32, 0);
INSERT INTO `sys_role_menu` VALUES (1297, 1, 33, 0);
INSERT INTO `sys_role_menu` VALUES (1298, 1, 34, 0);
INSERT INTO `sys_role_menu` VALUES (1299, 1, 43, 0);
INSERT INTO `sys_role_menu` VALUES (1300, 1, 35, 0);
INSERT INTO `sys_role_menu` VALUES (1301, 1, 37, 0);
INSERT INTO `sys_role_menu` VALUES (1306, 1, 1, 0);
INSERT INTO `sys_role_menu` VALUES (1307, 1, 3, 0);
INSERT INTO `sys_role_menu` VALUES (1308, 1, 64, 0);
INSERT INTO `sys_role_menu` VALUES (1310, 1, 2, 0);
INSERT INTO `sys_role_menu` VALUES (1311, 1, 23, 0);
INSERT INTO `sys_role_menu` VALUES (1312, 1, 24, 0);
INSERT INTO `sys_role_menu` VALUES (1313, 1, 25, 0);
INSERT INTO `sys_role_menu` VALUES (1314, 1, 26, 0);
INSERT INTO `sys_role_menu` VALUES (1315, 1, 27, 0);
INSERT INTO `sys_role_menu` VALUES (1316, 1, 44, 0);
INSERT INTO `sys_role_menu` VALUES (1382, 1, 30, 0);
INSERT INTO `sys_role_menu` VALUES (1384, 1, 36, 0);
INSERT INTO `sys_role_menu` VALUES (1386, 1, 39, 0);
INSERT INTO `sys_role_menu` VALUES (1392, 1, 42, 0);
INSERT INTO `sys_role_menu` VALUES (1396, 1, 68, 0);
INSERT INTO `sys_role_menu` VALUES (1398, 1, 65, 0);
INSERT INTO `sys_role_menu` VALUES (1401, 2, 29, 0);
INSERT INTO `sys_role_menu` VALUES (1402, 2, 31, 0);
INSERT INTO `sys_role_menu` VALUES (1403, 2, 32, 0);
INSERT INTO `sys_role_menu` VALUES (1404, 2, 33, 0);
INSERT INTO `sys_role_menu` VALUES (1405, 2, 34, 0);
INSERT INTO `sys_role_menu` VALUES (1406, 2, 43, 0);
INSERT INTO `sys_role_menu` VALUES (1407, 2, 35, 0);
INSERT INTO `sys_role_menu` VALUES (1408, 2, 37, 0);
INSERT INTO `sys_role_menu` VALUES (1410, 2, 1, 0);
INSERT INTO `sys_role_menu` VALUES (1411, 2, 3, 0);
INSERT INTO `sys_role_menu` VALUES (1412, 2, 64, 0);
INSERT INTO `sys_role_menu` VALUES (1413, 2, 2, 0);
INSERT INTO `sys_role_menu` VALUES (1414, 2, 23, 0);
INSERT INTO `sys_role_menu` VALUES (1415, 2, 24, 0);
INSERT INTO `sys_role_menu` VALUES (1416, 2, 25, 0);
INSERT INTO `sys_role_menu` VALUES (1417, 2, 27, 0);
INSERT INTO `sys_role_menu` VALUES (1418, 2, 44, 0);
INSERT INTO `sys_role_menu` VALUES (1420, 2, 30, 0);
INSERT INTO `sys_role_menu` VALUES (1421, 2, 36, 0);
INSERT INTO `sys_role_menu` VALUES (1422, 2, 39, 0);
INSERT INTO `sys_role_menu` VALUES (1423, 2, 42, 0);
INSERT INTO `sys_role_menu` VALUES (1424, 2, 68, 0);
INSERT INTO `sys_role_menu` VALUES (1425, 2, 65, 0);
INSERT INTO `sys_role_menu` VALUES (1427, 1, 21, 0);
INSERT INTO `sys_role_menu` VALUES (1428, 2, 21, 0);
INSERT INTO `sys_role_menu` VALUES (1429, 1, 28, 0);
INSERT INTO `sys_role_menu` VALUES (1430, 2, 28, 0);
INSERT INTO `sys_role_menu` VALUES (1431, 1, 71, 0); 
INSERT INTO `sys_role_menu` VALUES (1432, 1, 72, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 21, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 28, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 30, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 31, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 32, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 33, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 34, 0); 
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`, `is_deleted`) VALUES (45, 72, 0); 

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系表id',
  `role_id` bigint NOT NULL COMMENT '角色id',
  `permission_id` bigint NOT NULL COMMENT '权限id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 338 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
INSERT INTO `sys_role_permission` VALUES (162, 1, 7);
INSERT INTO `sys_role_permission` VALUES (163, 1, 8);
INSERT INTO `sys_role_permission` VALUES (164, 1, 9);
INSERT INTO `sys_role_permission` VALUES (165, 1, 10);
INSERT INTO `sys_role_permission` VALUES (166, 1, 11);
INSERT INTO `sys_role_permission` VALUES (167, 1, 12);
INSERT INTO `sys_role_permission` VALUES (168, 1, 13);
INSERT INTO `sys_role_permission` VALUES (170, 1, 15);
INSERT INTO `sys_role_permission` VALUES (171, 1, 16);
INSERT INTO `sys_role_permission` VALUES (172, 1, 17);
INSERT INTO `sys_role_permission` VALUES (173, 1, 18);
INSERT INTO `sys_role_permission` VALUES (174, 1, 19);
INSERT INTO `sys_role_permission` VALUES (175, 1, 20);
INSERT INTO `sys_role_permission` VALUES (176, 1, 21);
INSERT INTO `sys_role_permission` VALUES (177, 1, 22);
INSERT INTO `sys_role_permission` VALUES (178, 1, 23);
INSERT INTO `sys_role_permission` VALUES (179, 1, 24);
INSERT INTO `sys_role_permission` VALUES (180, 1, 27);
INSERT INTO `sys_role_permission` VALUES (181, 1, 28);
INSERT INTO `sys_role_permission` VALUES (182, 1, 30);
INSERT INTO `sys_role_permission` VALUES (183, 1, 31);
INSERT INTO `sys_role_permission` VALUES (184, 1, 33);
INSERT INTO `sys_role_permission` VALUES (185, 1, 34);
INSERT INTO `sys_role_permission` VALUES (186, 1, 35);
INSERT INTO `sys_role_permission` VALUES (192, 1, 5);
INSERT INTO `sys_role_permission` VALUES (193, 1, 6);
INSERT INTO `sys_role_permission` VALUES (198, 1, 36);
INSERT INTO `sys_role_permission` VALUES (199, 1, 37);
INSERT INTO `sys_role_permission` VALUES (200, 1, 38);
INSERT INTO `sys_role_permission` VALUES (201, 1, 14);
INSERT INTO `sys_role_permission` VALUES (211, 1, 87);
INSERT INTO `sys_role_permission` VALUES (212, 1, 45);
INSERT INTO `sys_role_permission` VALUES (213, 1, 91);
INSERT INTO `sys_role_permission` VALUES (214, 1, 92);
INSERT INTO `sys_role_permission` VALUES (215, 1, 93);
INSERT INTO `sys_role_permission` VALUES (216, 1, 94);
INSERT INTO `sys_role_permission` VALUES (217, 1, 97);
INSERT INTO `sys_role_permission` VALUES (218, 1, 98);
INSERT INTO `sys_role_permission` VALUES (219, 1, 99);
INSERT INTO `sys_role_permission` VALUES (220, 1, 100);
INSERT INTO `sys_role_permission` VALUES (223, 1, 101);
INSERT INTO `sys_role_permission` VALUES (224, 1, 103);
INSERT INTO `sys_role_permission` VALUES (225, 1, 102);
INSERT INTO `sys_role_permission` VALUES (226, 1, 104);
INSERT INTO `sys_role_permission` VALUES (227, 1, 105);
INSERT INTO `sys_role_permission` VALUES (228, 1, 106);
INSERT INTO `sys_role_permission` VALUES (229, 1, 107);
INSERT INTO `sys_role_permission` VALUES (230, 1, 108);
INSERT INTO `sys_role_permission` VALUES (231, 1, 109);
INSERT INTO `sys_role_permission` VALUES (232, 1, 110);
INSERT INTO `sys_role_permission` VALUES (233, 1, 111);
INSERT INTO `sys_role_permission` VALUES (234, 1, 112);
INSERT INTO `sys_role_permission` VALUES (235, 1, 113);
INSERT INTO `sys_role_permission` VALUES (236, 1, 114);
INSERT INTO `sys_role_permission` VALUES (237, 1, 115);
INSERT INTO `sys_role_permission` VALUES (238, 1, 116);
INSERT INTO `sys_role_permission` VALUES (239, 1, 117);
INSERT INTO `sys_role_permission` VALUES (240, 1, 118);
INSERT INTO `sys_role_permission` VALUES (241, 1, 119);
INSERT INTO `sys_role_permission` VALUES (242, 1, 120);
INSERT INTO `sys_role_permission` VALUES (243, 1, 121);
INSERT INTO `sys_role_permission` VALUES (244, 1, 122);
INSERT INTO `sys_role_permission` VALUES (245, 1, 123);
INSERT INTO `sys_role_permission` VALUES (246, 1, 124);
INSERT INTO `sys_role_permission` VALUES (247, 1, 125);
INSERT INTO `sys_role_permission` VALUES (248, 1, 126);
INSERT INTO `sys_role_permission` VALUES (249, 1, 127);
INSERT INTO `sys_role_permission` VALUES (250, 1, 128);
INSERT INTO `sys_role_permission` VALUES (251, 1, 129);
INSERT INTO `sys_role_permission` VALUES (252, 1, 130);
INSERT INTO `sys_role_permission` VALUES (253, 1, 131);
INSERT INTO `sys_role_permission` VALUES (254, 1, 132);
INSERT INTO `sys_role_permission` VALUES (255, 1, 133);
INSERT INTO `sys_role_permission` VALUES (256, 1, 134);
INSERT INTO `sys_role_permission` VALUES (261, 1, 140);
INSERT INTO `sys_role_permission` VALUES (262, 1, 141);
INSERT INTO `sys_role_permission` VALUES (263, 1, 142);
INSERT INTO `sys_role_permission` VALUES (264, 1, 143);
INSERT INTO `sys_role_permission` VALUES (265, 1, 144);
INSERT INTO `sys_role_permission` VALUES (266, 1, 145);
INSERT INTO `sys_role_permission` VALUES (268, 1, 146);
INSERT INTO `sys_role_permission` VALUES (269, 1, 147);
INSERT INTO `sys_role_permission` VALUES (271, 2, 5);
INSERT INTO `sys_role_permission` VALUES (272, 2, 6);
INSERT INTO `sys_role_permission` VALUES (273, 2, 11);
INSERT INTO `sys_role_permission` VALUES (274, 2, 13);
INSERT INTO `sys_role_permission` VALUES (275, 2, 16);
INSERT INTO `sys_role_permission` VALUES (276, 2, 17);
INSERT INTO `sys_role_permission` VALUES (277, 2, 18);
INSERT INTO `sys_role_permission` VALUES (278, 2, 21);
INSERT INTO `sys_role_permission` VALUES (279, 2, 22);
INSERT INTO `sys_role_permission` VALUES (280, 2, 23);
INSERT INTO `sys_role_permission` VALUES (281, 2, 27);
INSERT INTO `sys_role_permission` VALUES (282, 2, 31);
INSERT INTO `sys_role_permission` VALUES (283, 2, 33);
INSERT INTO `sys_role_permission` VALUES (284, 2, 36);
INSERT INTO `sys_role_permission` VALUES (285, 2, 37);
INSERT INTO `sys_role_permission` VALUES (286, 2, 45);
INSERT INTO `sys_role_permission` VALUES (287, 2, 91);
INSERT INTO `sys_role_permission` VALUES (288, 2, 93);
INSERT INTO `sys_role_permission` VALUES (289, 2, 94);
INSERT INTO `sys_role_permission` VALUES (290, 2, 97);
INSERT INTO `sys_role_permission` VALUES (291, 2, 98);
INSERT INTO `sys_role_permission` VALUES (292, 2, 100);
INSERT INTO `sys_role_permission` VALUES (293, 2, 102);
INSERT INTO `sys_role_permission` VALUES (294, 2, 103);
INSERT INTO `sys_role_permission` VALUES (295, 2, 104);
INSERT INTO `sys_role_permission` VALUES (296, 2, 106);
INSERT INTO `sys_role_permission` VALUES (297, 2, 110);
INSERT INTO `sys_role_permission` VALUES (298, 2, 111);
INSERT INTO `sys_role_permission` VALUES (299, 2, 113);
INSERT INTO `sys_role_permission` VALUES (300, 2, 115);
INSERT INTO `sys_role_permission` VALUES (301, 2, 116);
INSERT INTO `sys_role_permission` VALUES (302, 2, 119);
INSERT INTO `sys_role_permission` VALUES (303, 2, 120);
INSERT INTO `sys_role_permission` VALUES (304, 2, 123);
INSERT INTO `sys_role_permission` VALUES (305, 2, 124);
INSERT INTO `sys_role_permission` VALUES (306, 2, 127);
INSERT INTO `sys_role_permission` VALUES (307, 2, 128);
INSERT INTO `sys_role_permission` VALUES (308, 2, 131);
INSERT INTO `sys_role_permission` VALUES (309, 2, 134);
INSERT INTO `sys_role_permission` VALUES (312, 2, 140);
INSERT INTO `sys_role_permission` VALUES (313, 2, 141);
INSERT INTO `sys_role_permission` VALUES (314, 2, 144);
INSERT INTO `sys_role_permission` VALUES (315, 2, 145);
INSERT INTO `sys_role_permission` VALUES (317, 1, 150);
INSERT INTO `sys_role_permission` VALUES (318, 1, 151);
INSERT INTO `sys_role_permission` VALUES (319, 1, 152);
INSERT INTO `sys_role_permission` VALUES (320, 1, 153);
INSERT INTO `sys_role_permission` VALUES (321, 2, 150);
INSERT INTO `sys_role_permission` VALUES (322, 1, 154);
INSERT INTO `sys_role_permission` VALUES (323, 1, 155);
INSERT INTO `sys_role_permission` VALUES (324, 1, 156);
INSERT INTO `sys_role_permission` VALUES (325, 1, 157);
INSERT INTO `sys_role_permission` VALUES (326, 2, 156);
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 158); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 159); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 160); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (1, 161); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 109); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 110); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 111); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 112); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 113); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 114); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 107); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 119); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 108); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 123); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 158); 
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES (45, 159); 

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `gender` tinyint(1) NOT NULL DEFAULT 0 COMMENT '用户性别(0,未定义,1,男,2女)',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户密码',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户头像',
  `intro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '个人简介',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户邮箱',
  `register_ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '注册ip',
  `register_type` tinyint NOT NULL COMMENT '注册方式(0邮箱/姓名 1Gitee 2Github)',
  `register_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '注册地址',
  `login_ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最近登录ip',
  `login_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最近登录地址',
  `login_type` tinyint NULL DEFAULT NULL COMMENT '最近登录类型(0邮箱/姓名 1Gitee 2Github)',
  `login_time` datetime NOT NULL COMMENT '用户最近登录时间',
  `is_disable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 (0否 1是)',
  `create_time` datetime NOT NULL COMMENT '用户创建时间',
  `update_time` datetime NOT NULL COMMENT '用户更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 88066038 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'Admin', 'Admin', 0, '$2a$10$VyFtQ3T943p3NY5R0IxzIONjdqABmuCSGiHe5uV8d1ujLGYuS2KZe', 'https://image.kuailemao.xyz/blog/user/avatar/ce7998d8-43b5-4457-bc5c-4fa849160b3c.jpg', '我是一个伟大的站主~~', 'ruyusan@qq.com', '127.0.0.1', 0, '内网IP', '127.0.0.1', 'XX XX', 0, '2024-10-21 08:52:51', 0, '2023-10-13 15:16:01', '2024-10-21 08:52:51', 0);
INSERT INTO `sys_user` VALUES (88065990, '测试用户', 'Test', 0, '$2a$10$VyFtQ3T943p3NY5R0IxzIONjdqABmuCSGiHe5uV8d1ujLGYuS2KZe', 'https://image.kuailemao.xyz/blog/user/avatar/ce7998d8-43b5-4457-bc5c-4fa849160b3c.jpg', '这是测试用户', NULL, '127.0.0.1', 0, '未知', '127.0.0.1', '未知', 0, '2024-10-21 16:29:53', 0, '2024-03-01 11:10:31', '2024-10-21 16:29:53', 0);
INSERT INTO `sys_user` VALUES (88066036, 'Ynchen', 'ynchen', 1, '$2a$10$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTU.example.hash', 'https://example.com/avatars/ynchen.jpg', 'ynchen', 'ynchen@example.com', '192.168.107.240', 1, '', NULL, NULL, NULL, '2025-06-13 16:23:39', 0, '2025-06-13 16:23:39', '2025-06-13 16:23:39', 0);
INSERT INTO `sys_user` (`nickname`, `username`, `gender`, `password`, `avatar`, `intro`, `email`, `register_ip`, `register_type`, `register_address`, `login_ip`, `login_address`, `login_type`, `login_time`, `is_disable`, `create_time`, `update_time`, `is_deleted`) VALUES ('编辑小张', 'editor_zhang', 2, '$2a$10$anothersecurepasswordhashvaluegeneratedhere.example.hash', 'https://image.kuailemao.xyz/blog/user/avatar/default_editor.jpg', '热爱写作的内容编辑', 'editor.zhang@example.com', '192.168.1.102', 0, '北京市', '192.168.1.102', '北京市', 0, NOW(), 0, NOW(), NOW(), 0);


-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int NOT NULL COMMENT '用户id',
  `role_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1, '1');
INSERT INTO `sys_user_role` VALUES (44, 88065990, '2');
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (88066036, '3'); 
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (88066037, '45'); 


-- ----------------------------
-- Table structure for sys_website_info
-- ----------------------------
DROP TABLE IF EXISTS `sys_website_info`;
CREATE TABLE `sys_website_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `webmaster_avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '站长头像',
  `webmaster_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '站长名称',
  `webmaster_copy` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '站长文案',
  `webmaster_profile_background` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '站长资料卡背景图',
  `gitee_link` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'gitee链接',
  `github_link` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'github链接',
  `website_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网站名称',
  `header_notification` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头部通知',
  `sidebar_announcement` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '侧面公告',
  `record_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备案信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始运行时间',
  `create_time` datetime NOT NULL COMMENT '用户创建时间',
  `update_time` datetime NOT NULL COMMENT '用户更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_website_info
-- ----------------------------
INSERT INTO `sys_website_info` VALUES (1, 'https://image.kuailemao.xyz/blog/websiteInfo/avatar/95924d04-f0c5-4560-a369-645f3c9080bf.webp', 'Ruyu', '生活想要活埋了我，不料我是一粒种子', 'https://image.kuailemao.xyz/blog/websiteInfo/background/8337f2ae-c573-4719-a734-901b3d6859bc.webp', 'https://gitee.com/kuailemao', 'https://github.com/kuailemao', 'Ruyu-快乐猫', '禁止发无关评论，违者永久封禁！！！', '本项目github & gitee 开源地址：\nhttps://github.com/kuailemao/Ruyu-Blog\nhttps://gitee.com/kuailemao/ruyu-blog\n项目部署文档：https://kuailemao.xyz/article/48\n文档独立站点：http://docs.kuailemao.xyz/\nqq交流群：635887836\n欢迎指出网站的不足，给我提供意见。', '备案号', '2024-03-03 03:30:30', '2023-12-27 14:28:10', '2024-10-15 18:23:08', 0);

-- ----------------------------
-- Table structure for t_category
-- ----------------------------
DROP TABLE IF EXISTS `t_category`;
CREATE TABLE `t_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `category_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_category
-- ----------------------------
INSERT INTO `t_category` (`category_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('技术分享', NOW(), NOW(), 0);
INSERT INTO `t_category` (`category_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('生活感悟', NOW(), NOW(), 0);
INSERT INTO `t_category` (`category_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('学习笔记', NOW(), NOW(), 0);
INSERT INTO `t_category` VALUES (14, '未分类', '2024-01-08 11:29:23', '2024-01-08 11:29:23', 0);
INSERT INTO `t_category` (`category_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('项目教程', NOW(), NOW(), 0);


-- ----------------------------
-- Table structure for t_article
-- ----------------------------
DROP TABLE IF EXISTS `t_article`;
CREATE TABLE `t_article`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文章id',
  `user_id` bigint NOT NULL COMMENT '作者id',
  `category_id` bigint NOT NULL COMMENT '分类id',
  `article_cover` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文章缩略图',
  `article_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文章标题',
  `article_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文章内容',
  `article_type` tinyint NOT NULL COMMENT '类型 (1原创 2转载 3翻译)',
  `is_top` tinyint NOT NULL COMMENT '是否置顶 (0否 1是）',
  `status` tinyint NOT NULL COMMENT '文章状态 (1公开 2私密 3草稿)',
  `visit_count` bigint NOT NULL DEFAULT 0 COMMENT '访问量',
  `create_time` datetime NOT NULL COMMENT '文章创建时间',
  `update_time` datetime NOT NULL COMMENT '文章更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_article
-- ----------------------------
INSERT INTO `t_article` (`user_id`, `category_id`, `article_cover`, `article_title`, `article_content`, `article_type`, `is_top`, `status`, `visit_count`, `create_time`, `update_time`, `is_deleted`) VALUES (1, 1, 'https://picsum.photos/seed/tech/400/300', '我的第一篇技术博客', '# Hello World\n\n这是我的第一篇技术博客内容。主要分享关于 **Markdown** 的使用。', 1, 1, 1, 105, '2025-01-15 10:00:00', '2025-01-15 10:00:00', 0);
INSERT INTO `t_article` (`user_id`, `category_id`, `article_cover`, `article_title`, `article_content`, `article_type`, `is_top`, `status`, `visit_count`, `create_time`, `update_time`, `is_deleted`) VALUES (88066036, 2, 'https://picsum.photos/seed/life/400/300', '周末的阳光', '周末阳光明媚，心情也格外舒畅。记录下这美好的瞬间。', 1, 0, 1, 55, '2025-02-20 14:30:00', '2025-02-20 14:30:00', 0);
INSERT INTO `t_article` (`user_id`, `category_id`, `article_cover`, `article_title`, `article_content`, `article_type`, `is_top`, `status`, `visit_count`, `create_time`, `update_time`, `is_deleted`) VALUES (1, 3, 'https://picsum.photos/seed/study/400/300', 'MySQL学习心得', '## MySQL 优化\n\n1. 索引优化\n2. 查询优化', 1, 0, 2, 25, '2025-03-10 09:00:00', '2025-03-10 09:00:00', 0); 
INSERT INTO `t_article` (`user_id`, `category_id`, `article_cover`, `article_title`, `article_content`, `article_type`, `is_top`, `status`, `visit_count`, `create_time`, `update_time`, `is_deleted`) VALUES (88066037, 15, 'https://picsum.photos/seed/project/400/300', 'Ruyu-Blog 部署教程', '详细介绍了 Ruyu-Blog 项目的部署步骤...', 1, 0, 1, 120, NOW(), NOW(), 0);

-- ----------------------------
-- Table structure for t_tag
-- ----------------------------
DROP TABLE IF EXISTS `t_tag`;
CREATE TABLE `t_tag`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `tag_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名称',
  `create_time` datetime NOT NULL COMMENT '标签创建时间',
  `update_time` datetime NOT NULL COMMENT '标签更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_tag
-- ----------------------------
INSERT INTO `t_tag` (`tag_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('Java', NOW(), NOW(), 0);
INSERT INTO `t_tag` (`tag_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('MySQL', NOW(), NOW(), 0);
INSERT INTO `t_tag` (`tag_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('随笔', NOW(), NOW(), 0);
INSERT INTO `t_tag` (`tag_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('Spring Boot', NOW(), NOW(), 0);
INSERT INTO `t_tag` VALUES (14, 'Vue.js', '2024-01-18 16:16:41', '2024-01-18 16:16:41', 0);
INSERT INTO `t_tag` (`tag_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('部署', NOW(), NOW(), 0);
INSERT INTO `t_tag` (`tag_name`, `create_time`, `update_time`, `is_deleted`) VALUES ('教程', NOW(), NOW(), 0);


-- ----------------------------
-- Table structure for t_article_tag
-- ----------------------------
DROP TABLE IF EXISTS `t_article_tag`;
CREATE TABLE `t_article_tag`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '关系表id',
  `article_id` bigint UNSIGNED NOT NULL COMMENT '文章id',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 191 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_article_tag
-- ----------------------------
-- Note: Replace 53, 54, 55, 56 with actual IDs of articles inserted above if auto_increment starts differently.
-- Assuming articles start at ID 53 for this example.
INSERT INTO `t_article_tag` (`article_id`, `tag_id`, `create_time`, `is_deleted`) VALUES (53, 1, NOW(), 0); 
INSERT INTO `t_article_tag` (`article_id`, `tag_id`, `create_time`, `is_deleted`) VALUES (53, 4, NOW(), 0); 
INSERT INTO `t_article_tag` (`article_id`, `tag_id`, `create_time`, `is_deleted`) VALUES (54, 3, NOW(), 0); 
INSERT INTO `t_article_tag` (`article_id`, `tag_id`, `create_time`, `is_deleted`) VALUES (55, 2, NOW(), 0); 
INSERT INTO `t_article_tag` (`article_id`, `tag_id`, `create_time`, `is_deleted`) VALUES (56, 15, NOW(), 0); 
INSERT INTO `t_article_tag` (`article_id`, `tag_id`, `create_time`, `is_deleted`) VALUES (56, 16, NOW(), 0); 

-- ----------------------------
-- Table structure for t_banners
-- ----------------------------
DROP TABLE IF EXISTS `t_banners`;
CREATE TABLE `t_banners`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片路径',
  `size` bigint NOT NULL COMMENT '图片大小 (字节)',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片类型 (MIME)',
  `user_id` bigint NOT NULL COMMENT '上传人id',
  `sort_order` int NOT NULL COMMENT '图片顺序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_banners
-- ----------------------------
INSERT INTO `t_banners` (`path`, `size`, `type`, `user_id`, `sort_order`, `create_time`) VALUES ('https://image.kuailemao.xyz/blog/banners/banner1.jpg', 102400, 'image/jpeg', 1, 1, NOW());
INSERT INTO `t_banners` (`path`, `size`, `type`, `user_id`, `sort_order`, `create_time`) VALUES ('https://image.kuailemao.xyz/blog/banners/banner2.png', 204800, 'image/png', 1, 2, NOW());
INSERT INTO `t_banners` (`path`, `size`, `type`, `user_id`, `sort_order`, `create_time`) VALUES ('https://picsum.photos/seed/banner3/1920/400', 153600, 'image/jpeg', 1, 3, NOW());


-- ----------------------------
-- Table structure for t_black_list
-- ----------------------------
DROP TABLE IF EXISTS `t_black_list`;
CREATE TABLE `t_black_list`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '表id',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '封禁理由',
  `banned_time` datetime NOT NULL COMMENT '封禁时间',
  `expires_time` datetime NOT NULL COMMENT '到期时间',
  `type` tinyint NOT NULL COMMENT '类型（1：用户，2：路人/攻击者）',
  `ip_info` json NULL COMMENT '如果type=2，则需要有ip信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 259 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_black_list
-- ----------------------------
INSERT INTO `t_black_list` (`user_id`, `reason`, `banned_time`, `expires_time`, `type`, `ip_info`, `create_time`, `update_time`, `is_deleted`) VALUES (88065990, '恶意灌水', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 1, NULL, NOW(), NOW(), 0);
INSERT INTO `t_black_list` (`user_id`, `reason`, `banned_time`, `expires_time`, `type`, `ip_info`, `create_time`, `update_time`, `is_deleted`) VALUES (NULL, '尝试SQL注入攻击', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 2, '{\"ip\":\"10.0.0.5\", \"userAgent\":\"EvilBot/1.0\"}', NOW(), NOW(), 0);


-- ----------------------------
-- Table structure for t_comment
-- ----------------------------
DROP TABLE IF EXISTS `t_comment`;
CREATE TABLE `t_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论id',
  `type` tinyint(1) NOT NULL COMMENT '评论类型 (1文章 2留言板)',
  `type_id` bigint NOT NULL COMMENT '类型id',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父评论id',
  `reply_id` bigint NULL DEFAULT NULL COMMENT '回复评论id',
  `comment_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论的内容',
  `comment_user_id` bigint NOT NULL COMMENT '评论用户的id',
  `reply_user_id` bigint NULL DEFAULT NULL COMMENT '回复用户的id',
  `is_check` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否通过 (0否 1是)',
  `create_time` datetime NOT NULL COMMENT '评论时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 133 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_comment
-- ----------------------------
-- Note: Replace 53 and 131 with actual IDs if they differ after inserts.
INSERT INTO `t_comment` (`type`, `type_id`, `parent_id`, `reply_id`, `comment_content`, `comment_user_id`, `reply_user_id`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (1, 53, NULL, NULL, '写得很棒！学习了！', 88066036, NULL, 1, NOW(), NOW(), 0);
INSERT INTO `t_comment` (`type`, `type_id`, `parent_id`, `reply_id`, `comment_content`, `comment_user_id`, `reply_user_id`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (1, 53, 131, 131, '谢谢你的支持！', 1, 88066036, 1, DATE_ADD(NOW(), INTERVAL 1 HOUR), DATE_ADD(NOW(), INTERVAL 1 HOUR), 0); 
INSERT INTO `t_comment` (`type`, `type_id`, `parent_id`, `reply_id`, `comment_content`, `comment_user_id`, `reply_user_id`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (2, 1, NULL, NULL, '博主网站很漂亮！', 88065990, NULL, 0, NOW(), NOW(), 0);

-- ----------------------------
-- Table structure for t_favorite
-- ----------------------------
DROP TABLE IF EXISTS `t_favorite`;
CREATE TABLE `t_favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏id',
  `user_id` bigint NOT NULL COMMENT '收藏的用户id',
  `type` tinyint NOT NULL COMMENT '收藏类型(1,文章 2,留言板)',
  `type_id` bigint NOT NULL COMMENT '类型id',
  `is_check` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否有效 (0否 1是)',
  `create_time` datetime NOT NULL COMMENT '收藏时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 191 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_favorite
-- ----------------------------
INSERT INTO `t_favorite` (`user_id`, `type`, `type_id`, `is_check`, `create_time`, `is_deleted`) VALUES (88066036, 1, 53, 1, NOW(), 0); 
INSERT INTO `t_favorite` (`user_id`, `type`, `type_id`, `is_check`, `create_time`, `is_deleted`) VALUES (1, 1, 54, 1, NOW(), 0); 

-- ----------------------------
-- Table structure for t_leave_word
-- ----------------------------
DROP TABLE IF EXISTS `t_leave_word`;
CREATE TABLE `t_leave_word`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint NOT NULL COMMENT '留言用户id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '留言内容',
  `is_check` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否通过 (0否 1是)',
  `create_time` datetime NOT NULL COMMENT '留言时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_leave_word
-- ----------------------------
INSERT INTO `t_leave_word` (`user_id`, `content`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (88066036, '博主你好，非常喜欢你的博客风格！', 1, NOW(), NOW(), 0);
INSERT INTO `t_leave_word` (`user_id`, `content`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (1, '欢迎大家常来访问！', 1, DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), 0);
INSERT INTO `t_leave_word` (`user_id`, `content`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (88065990, '这个留言需要审核。', 0, NOW(), NOW(), 0);

-- ----------------------------
-- Table structure for t_like
-- ----------------------------
DROP TABLE IF EXISTS `t_like`;
CREATE TABLE `t_like`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞表id',
  `user_id` bigint NOT NULL COMMENT '点赞的用户id',
  `type` tinyint NOT NULL COMMENT '点赞类型(1,文章,2,评论,3留言板)',
  `type_id` bigint NOT NULL COMMENT '点赞的文章id',
  `create_time` datetime NOT NULL COMMENT '点赞时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 366 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_like
-- ----------------------------
INSERT INTO `t_like` (`user_id`, `type`, `type_id`, `create_time`, `update_time`) VALUES (88066036, 1, 53, NOW(), NOW()); 
INSERT INTO `t_like` (`user_id`, `type`, `type_id`, `create_time`, `update_time`) VALUES (1, 2, 131, NOW(), NOW()); 
INSERT INTO `t_like` (`user_id`, `type`, `type_id`, `create_time`, `update_time`) VALUES (88065990, 3, 37, NOW(), NOW()); 


-- ----------------------------
-- Table structure for t_link
-- ----------------------------
DROP TABLE IF EXISTS `t_link`;
CREATE TABLE `t_link`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '友链表id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站名称',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站地址',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站描述',
  `background` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站背景',
  `is_check` tinyint NOT NULL DEFAULT 0 COMMENT '审核状态（0：未通过，1：已通过）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮箱地址', -- Increased length from 20 to 50
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_link
-- ----------------------------
INSERT INTO `t_link` (`user_id`, `name`, `url`, `description`, `background`, `is_check`, `email`, `create_time`, `update_time`, `is_deleted`) VALUES (1, 'Google', 'https://www.google.com', '全球最大的搜索引擎', 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png', 1, 'contact@google.com', NOW(), NOW(), 0);
INSERT INTO `t_link` (`user_id`, `name`, `url`, `description`, `background`, `is_check`, `email`, `create_time`, `update_time`, `is_deleted`) VALUES (88066036, 'My Personal Blog', 'https://example-blog.com', '一个分享生活和技术的博客', 'https://picsum.photos/seed/mylink/200/100', 0, 'me@example-blog.com', NOW(), NOW(), 0);

-- ----------------------------
-- Table structure for t_photo
-- ----------------------------
DROP TABLE IF EXISTS `t_photo`;
CREATE TABLE `t_photo`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` bigint NOT NULL COMMENT '创建者id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `type` tinyint(1) NOT NULL COMMENT '类型（1：相册 2：照片）',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父相册id',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片地址',
  `is_check` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否通过 (0否 1是)',
  `size` double NULL DEFAULT NULL COMMENT '照片体积大小(kb)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 155 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_photo
-- ----------------------------
-- Note: parent_id for photos will depend on the auto-incremented ID of the album.
-- Insert albums first
INSERT INTO `t_photo` (`user_id`, `name`, `description`, `type`, `parent_id`, `url`, `is_check`, `size`, `create_time`, `update_time`, `is_deleted`) VALUES (1, '风景', '记录美丽的风景', 1, NULL, NULL, 1, NULL, NOW(), NOW(), 0);
SET @album1_id = LAST_INSERT_ID();
INSERT INTO `t_photo` (`user_id`, `name`, `description`, `type`, `parent_id`, `url`, `is_check`, `size`, `create_time`, `update_time`, `is_deleted`) VALUES (88066036, '我的宠物', '可爱的猫咪们', 1, NULL, NULL, 1, NULL, NOW(), NOW(), 0); 
SET @album2_id = LAST_INSERT_ID();

-- Insert photos into albums
INSERT INTO `t_photo` (`user_id`, `name`, `description`, `type`, `parent_id`, `url`, `is_check`, `size`, `create_time`, `update_time`, `is_deleted`) VALUES (1, '黄山日出', '黄山顶峰的日出景象', 2, @album1_id, 'https://picsum.photos/seed/huangshan/800/600', 1, 350.5, DATE_ADD(NOW(), INTERVAL 1 MINUTE), DATE_ADD(NOW(), INTERVAL 1 MINUTE), 0); 
INSERT INTO `t_photo` (`user_id`, `name`, `description`, `type`, `parent_id`, `url`, `is_check`, `size`, `create_time`, `update_time`, `is_deleted`) VALUES (88066036, '咪咪', '我家的小橘猫', 2, @album2_id, 'https://picsum.photos/seed/cat/800/600', 1, 280.0, DATE_ADD(NOW(), INTERVAL 1 MINUTE), DATE_ADD(NOW(), INTERVAL 1 MINUTE), 0); 

-- ----------------------------
-- Table structure for t_tag - Already exists, records added earlier
-- ----------------------------

-- ----------------------------
-- Table structure for t_tree_hole
-- ----------------------------
DROP TABLE IF EXISTS `t_tree_hole`;
CREATE TABLE `t_tree_hole`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '树洞表id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容',
  `is_check` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否通过 (0否 1是)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_tree_hole
-- ----------------------------
INSERT INTO `t_tree_hole` (`user_id`, `content`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (88066036, '今天天气真好，希望明天也是！', 1, NOW(), NOW(), 0);
INSERT INTO `t_tree_hole` (`user_id`, `content`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (1, '工作有点累，但是要坚持下去。', 1, DATE_ADD(NOW(), INTERVAL -1 DAY), DATE_ADD(NOW(), INTERVAL -1 DAY), 0);
INSERT INTO `t_tree_hole` (`user_id`, `content`, `is_check`, `create_time`, `update_time`, `is_deleted`) VALUES (88065990, '这个秘密只有树洞知道。', 0, NOW(), NOW(), 0); 


SET FOREIGN_KEY_CHECKS = 1;