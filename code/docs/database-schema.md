# 数据库表结构文档

## 1. users 表
存储用户信息

| 字段名 | 类型 | 长度 | 是否为主键 | 是否允许为空 | 描述 |
|-------|------|------|-----------|-------------|------|
| id | BIGINT | - | 是 | 否 | 用户ID，自增主键 |
| username | VARCHAR | 50 | 否 | 否 | 用户名，唯一 |
| email | VARCHAR | 100 | 否 | 否 | 邮箱地址，唯一 |
| password | VARCHAR | 255 | 否 | 否 | 加密后的密码 |
| nickname | VARCHAR | 50 | 否 | 是 | 昵称 |
| avatar_url | VARCHAR | 255 | 否 | 是 | 头像链接 |
| bio | TEXT | - | 否 | 是 | 个人简介 |
| status | TINYINT | - | 否 | 否 | 用户状态(0:禁用,1:启用) |
| created_at | TIMESTAMP | - | 否 | 否 | 创建时间 |
| updated_at | TIMESTAMP | - | 否 | 否 | 更新时间 |

## 2. articles 表
存储文章信息

| 字段名 | 类型 | 长度 | 是否为主键 | 是否允许为空 | 描述 |
|-------|------|------|-----------|-------------|------|
| id | BIGINT | - | 是 | 否 | 文章ID，自增主键 |
| title | VARCHAR | 200 | 否 | 否 | 文章标题 |
| content | LONGTEXT | - | 否 | 否 | 文章内容 |
| summary | VARCHAR | 500 | 否 | 是 | 文章摘要 |
| author_id | BIGINT | - | 否 | 否 | 作者ID，关联users表 |
| category_id | BIGINT | - | 否 | 是 | 分类ID，关联categories表 |
| view_count | INT | - | 否 | 否 | 浏览次数，默认为0 |
| like_count | INT | - | 否 | 否 | 点赞次数，默认为0 |
| comment_count | INT | - | 否 | 否 | 评论次数，默认为0 |
| status | TINYINT | - | 否 | 否 | 文章状态(0:草稿,1:发布,2:下架) |
| published_at | TIMESTAMP | - | 否 | 是 | 发布时间 |
| created_at | TIMESTAMP | - | 否 | 否 | 创建时间 |
| updated_at | TIMESTAMP | - | 否 | 否 | 更新时间 |

## 3. categories 表
存储文章分类信息

| 字段名 | 类型 | 长度 | 是否为主键 | 是否允许为空 | 描述 |
|-------|------|------|-----------|-------------|------|
| id | BIGINT | - | 是 | 否 | 分类ID，自增主键 |
| name | VARCHAR | 100 | 否 | 否 | 分类名称 |
| description | VARCHAR | 500 | 否 | 是 | 分类描述 |
| parent_id | BIGINT | - | 否 | 是 | 父分类ID，用于构建层级结构 |
| sort_order | INT | - | 否 | 否 | 排序权重，默认为0 |
| status | TINYINT | - | 否 | 否 | 分类状态(0:禁用,1:启用) |
| created_at | TIMESTAMP | - | 否 | 否 | 创建时间 |
| updated_at | TIMESTAMP | - | 否 | 否 | 更新时间 |

## 4. tags 表
存储标签信息

| 字段名 | 类型 | 长度 | 是否为主键 | 是否允许为空 | 描述 |
|-------|------|------|-----------|-------------|------|
| id | BIGINT | - | 是 | 否 | 标签ID，自增主键 |
| name | VARCHAR | 50 | 否 | 否 | 标签名 |
| color | VARCHAR | 7 | 否 | 是 | 标签颜色(HEX格式) |
| usage_count | INT | - | 否 | 否 | 使用次数，默认为0 |
| created_at | TIMESTAMP | - | 否 | 否 | 创建时间 |
| updated_at | TIMESTAMP | - | 否 | 否 | 更新时间 |

## 5. article_tags 表
文章与标签关联表

| 字段名 | 类型 | 长度 | 是否为主键 | 是否允许为空 | 描述 |
|-------|------|------|-----------|-------------|------|
| id | BIGINT | - | 是 | 否 | 关联ID，自增主键 |
| article_id | BIGINT | - | 否 | 否 | 文章ID，关联articles表 |
| tag_id | BIGINT | - | 否 | 否 | 标签ID，关联tags表 |
| created_at | TIMESTAMP | - | 否 | 否 | 创建时间 |

---
*文档最后更新时间: 2026-03-26*