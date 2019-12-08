/*
 Navicat Premium Data Transfer

 Source Server         : 本地mysql
 Source Server Type    : MySQL
 Source Server Version : 50723
 Source Host           : localhost:3306
 Source Schema         : blog

 Target Server Type    : MySQL
 Target Server Version : 50723
 File Encoding         : 65001

 Date: 08/12/2019 16:04:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_blog
-- ----------------------------
DROP TABLE IF EXISTS `t_blog`;
CREATE TABLE `t_blog` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `title` varchar(60) DEFAULT NULL COMMENT '博客标题',
  `author` varchar(60) DEFAULT NULL COMMENT '博客作者',
  `content` mediumtext COMMENT '博客内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of t_blog
-- ----------------------------
BEGIN;
INSERT INTO `t_blog` VALUES (1, 'Springboot 为什么这', 'bywind', '没错 Springboot ', '2019-12-08 01:44:29', '2019-12-08 01:44:34');
INSERT INTO `t_blog` VALUES (3, 'Springboot 中 Redis', 'bywind', 'Spring Boot中除了对常用的关系型数据库提供了优秀的自动化支持之外，对于很多NoSQL数据库一样提供了自动化配置的支持，包括：Redis, MongoDB, Elasticsearch, Solr和Cassandra。\n\n使用Redis\nRedis是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库。\n\nRedis官网\nRedis中文社区\n引入依赖\nSpring Boot提供的数据访问框架Spring Data Redis基于Jedis。可以通过引入spring-boot-starter-redis来配置依赖关系。\n\n<dependency>\n    <groupId>org.springframework.boot</groupId>\n    <artifactId>spring-boot-starter-redis</artifactId>\n</dependency>\n注意不同版本的spring boot下，redis的starter依赖名略有不同，如果上面的不行，可以尝试spring-boot-starter-data-redis\n\n参数配置\n按照惯例在application.properties中加入Redis服务端的相关配置，具体说明如下：\n\n# REDIS (RedisProperties)\n# Redis数据库索引（默认为0）\nspring.redis.database=0\n# Redis服务器地址\nspring.redis.host=localhost\n# Redis服务器连接端口\nspring.redis.port=6379\n# Redis服务器连接密码（默认为空）\nspring.redis.password=\n# 连接池最大连接数（使用负值表示没有限制）\nspring.redis.pool.max-active=8\n# 连接池最大阻塞等待时间（使用负值表示没有限制）\nspring.redis.pool.max-wait=-1\n# 连接池中的最大空闲连接\nspring.redis.pool.max-idle=8\n# 连接池中的最小空闲连接\nspring.redis.pool.min-idle=0\n# 连接超时时间（毫秒）\nspring.redis.timeout=0\n其中spring.redis.database的配置通常使用0即可，Redis在配置的时候可以设置数据库数量，默认为16，可以理解为数据库的schema\n\n测试访问\n通过编写测试用例，举例说明如何访问Redis。\n\n@RunWith(SpringJUnit4ClassRunner.class)\n@SpringApplicationConfiguration(Application.class)\npublic class ApplicationTests {\n\n	@Autowired\n	private StringRedisTemplate stringRedisTemplate;\n\n	@Test\n	public void test() throws Exception {\n\n		// 保存字符串\n		stringRedisTemplate.opsForValue().set(\"aaa\", \"111\");\n		Assert.assertEquals(\"111\", stringRedisTemplate.opsForValue().get(\"aaa\"));\n\n    }\n\n}\n通过上面这段极为简单的测试案例演示了如何通过自动配置的StringRedisTemplate对象进行Redis的读写操作，该对象从命名中就可注意到支持的是String类型。如果有使用过spring-data-redis的开发者一定熟悉RedisTemplate<K, V>接口，StringRedisTemplate就相当于RedisTemplate<String, String>的实现。\n\n除了String类型，实战中我们还经常会在Redis中存储对象，这时候我们就会想是否可以使用类似RedisTemplate<String, User>来初始化并进行操作。但是Spring Boot并不支持直接使用，需要我们自己实现RedisSerializer<T>接口来对传入对象进行序列化和反序列化，下面我们通过一个实例来完成对象的读写操作。\n\n创建要存储的对象：User\npublic class User implements Serializable {\n\n    private static final long serialVersionUID = -1L;\n\n    private String username;\n    private Integer age;\n\n    public User(String username, Integer age) {\n        this.username = username;\n        this.age = age;\n    }\n\n    // 省略getter和setter\n\n}\n实现对象的序列化接口\n\npublic class RedisObjectSerializer implements RedisSerializer<Object> {\n\n  private Converter<Object, byte[]> serializer = new SerializingConverter();\n  private Converter<byte[], Object> deserializer = new DeserializingConverter();\n\n  static final byte[] EMPTY_ARRAY = new byte[0];\n\n  public Object deserialize(byte[] bytes) {\n    if (isEmpty(bytes)) {\n      return null;\n    }\n\n    try {\n      return deserializer.convert(bytes);\n    } catch (Exception ex) {\n      throw new SerializationException(\"Cannot deserialize\", ex);\n    }\n  }\n\n  public byte[] serialize(Object object) {\n    if (object == null) {\n      return EMPTY_ARRAY;\n    }\n\n    try {\n      return serializer.convert(object);\n    } catch (Exception ex) {\n      return EMPTY_ARRAY;\n    }\n  }\n\n  private boolean isEmpty(byte[] data) {\n    return (data == null || data.length == 0);\n  }\n}\n配置针对User的RedisTemplate实例\n\n@Configuration\npublic class RedisConfig {\n\n    @Bean\n    JedisConnectionFactory jedisConnectionFactory() {\n        return new JedisConnectionFactory();\n    }\n\n    @Bean\n    public RedisTemplate<String, User> redisTemplate(RedisConnectionFactory factory) {\n        RedisTemplate<String, User> template = new RedisTemplate<String, User>();\n        template.setConnectionFactory(jedisConnectionFactory());\n        template.setKeySerializer(new StringRedisSerializer());\n        template.setValueSerializer(new RedisObjectSerializer());\n        return template;\n    }\n\n\n}\n完成了配置工作后，编写测试用例实验效果\n\n@RunWith(SpringJUnit4ClassRunner.class)\n@SpringApplicationConfiguration(Application.class)\npublic class ApplicationTests {\n\n	@Autowired\n	private RedisTemplate<String, User> redisTemplate;\n\n	@Test\n	public void test() throws Exception {\n\n		// 保存对象\n		User user = new User(\"超人\", 20);\n		redisTemplate.opsForValue().set(user.getUsername(), user);\n\n		user = new User(\"蝙蝠侠\", 30);\n		redisTemplate.opsForValue().set(user.getUsername(), user);\n\n		user = new User(\"蜘蛛侠\", 40);\n		redisTemplate.opsForValue().set(user.getUsername(), user);\n\n		Assert.assertEquals(20, redisTemplate.opsForValue().get(\"超人\").getAge().longValue());\n		Assert.assertEquals(30, redisTemplate.opsForValue().get(\"蝙蝠侠\").getAge().longValue());\n		Assert.assertEquals(40, redisTemplate.opsForValue().get(\"蜘蛛侠\").getAge().longValue());\n\n	}\n\n}\n当然spring-data-redis中提供的数据操作远不止这些，本文仅作为在Spring Boot中使用redis时的配置参考，更多对于redis的操作使用，请参考Spring-data-redis Reference。\n\n代码示例\n本文的相关例子可以查看下面仓库中的chapter3-2-5目录：\n\nGithub：https://github.com/dyc87112/SpringBoot-Learning\nGitee：https://gitee.com/didispace/SpringBoot-Learning\n如果您觉得本文不错，欢迎Star支持，您的关注是我坚持的动力！', '2019-12-08 01:44:29', '2019-12-08 01:44:56');
INSERT INTO `t_blog` VALUES (4, 'Springboot 中如何优化', 'bywind', '没错 Springboot ', '2019-12-08 01:44:29', '2019-12-08 01:44:56');
INSERT INTO `t_blog` VALUES (5, 'Springboot 消息队列', 'bywind', '没错 Springboot ', '2019-12-08 01:44:29', '2019-12-08 01:44:56');
INSERT INTO `t_blog` VALUES (6, 'Docker Compose + Springboot', 'bywind', '没错 Springboot ', '2019-12-08 01:44:29', '2019-12-08 01:44:56');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
