From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 2/7]ext4: Add EXT4_IOC_CLR_GLOBAL_ALLOC_RULE clears block
 allocation restriction
Date: Tue, 23 Jun 2009 17:25:21 +0900
Message-ID: <4A409171.3090202@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38452 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbZFWI05 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2009 04:26:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Add EXT4_IOC_CLR_GLOBAL_ALLOC_RULE clears block allocation restriction

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Block allocation restriction is cleared with this ioctl or umount filesystem.

  #define EXT4_IOC_CLR_GLOBAL_ALLOC_RULE _IOW('f', 17, struct ext4_alloc_rule);

  struct ext4_alloc_rule {
        __u64 start;            /* start physical offset to clear rule */
        __u64 len;              /* number of blocks to be clear */
        __u32 alloc_flag;       /* not used, should be zero */
  };

For example, block allocation restriction (1) has been already set on FS,
and call EXT4_IOC_CLR_GLOBAL_ALLOC_RULE (2),
As a result, block allocation restriction is divided into two.

(1) start:5000, len:1000, flag:0
(2) start:5500, len:100
(3) start:5000, len:500, flag:0
(4) start:5600, len:400, flag:0

  <Before>
  BG#0 |-------------------------------|
       0       |***********|           32767
            5000    (1)    5999

  <After>
  BG#0 |-------------------------------|
       0       |****|  |***|         32767
            5000  5499 5600 5999
                 (3)    (4)


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/ext4.h    |    3 +
 fs/ext4/ioctl.c   |   16 +++++
 fs/ext4/mballoc.c |  186 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1d2d550..d2cac27 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -357,6 +357,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 #define EXT4_IOC_ADD_GLOBAL_ALLOC_RULE	_IOW('f', 16, struct ext4_alloc_rule)
+#define EXT4_IOC_CLR_GLOBAL_ALLOC_RULE	_IOW('f', 17, struct ext4_alloc_rule)

 /*
  * ioctl commands in 32 bit emulation
@@ -1386,6 +1387,8 @@ extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
 extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 						ext4_group_t, int);
 extern int ext4_mb_add_global_arule(struct inode *, struct ext4_alloc_rule *);
+extern int ext4_mb_del_global_arule(struct inode *, struct ext4_alloc_rule *);
+extern void ext4_mb_release_arule_list(struct ext4_sb_info *);

 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 8505e3a..955bb08 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -276,6 +276,22 @@ setversion_out:
 		return err;
 	}

+	case EXT4_IOC_CLR_GLOBAL_ALLOC_RULE: {
+		struct ext4_alloc_rule arule;
+		int err;
+
+		if (copy_from_user(&arule,
+				(struct ext4_alloc_rule __user *)arg,
+				sizeof(arule)))
+			return -EFAULT;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		err = ext4_mb_del_global_arule(inode, &arule);
+		return err;
+	}
+
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0719900..29a25d6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2928,6 +2928,7 @@ int ext4_mb_release(struct super_block *sb)

 	free_percpu(sbi->s_locality_groups);
 	ext4_mb_history_release(sb);
+	ext4_mb_release_arule_list(sbi);

 	return 0;
 }
@@ -5036,6 +5037,28 @@ static void ext4_mb_release_tmp_list(struct list_head *list,
 	return;
 }

+void ext4_mb_release_arule_list(struct ext4_sb_info *sbi)
+{
+	struct ext4_bg_alloc_rule_list *bg_arule_list, *tmp_arule_list;
+	struct ext4_bg_alloc_rule *bg_arule, *tmp_arule;
+
+	list_for_each_entry_safe(bg_arule_list, tmp_arule_list,
+				&sbi->s_bg_arule_list, bg_arule_list){
+		list_for_each_entry_safe(bg_arule, tmp_arule,
+				&bg_arule_list->arule_list, arule_list) {
+			list_del(&bg_arule->arule_list);
+			kfree(bg_arule);
+			bg_arule = NULL;
+		}
+
+		list_del(&bg_arule_list->bg_arule_list);
+		kfree(bg_arule_list);
+		bg_arule_list = NULL;
+	}
+
+	return;
+}
+
 static int ext4_mb_check_arule(struct inode *inode,
 						struct ext4_alloc_rule *arule)
 {
@@ -5296,3 +5319,166 @@ out:
 	write_unlock(&sbi->s_bg_arule_lock);
 	return 0;
 }
+
+static int ext4_mb_del_bg_arule(struct super_block *sb,
+				struct ext4_bg_alloc_rule_list *bg_arule_list,
+				struct ext4_bg_alloc_rule *del_arule)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_bg_alloc_rule *bg_arule, *tmp_arule, *add_arule = NULL;
+	struct ext4_buddy e4b;
+	void *bd_bitmap;
+	ext4_grpblk_t freed_blocks = 0;
+	ext4_group_t group_no = bg_arule_list->bg_num;
+	int err;
+
+	err = ext4_mb_load_buddy(sb, group_no, &e4b);
+	if (err)
+		return err;
+
+	ext4_lock_group(sb, group_no);
+	bd_bitmap = e4b.bd_bitmap;
+
+	list_for_each_entry_safe(bg_arule, tmp_arule,
+				&bg_arule_list->arule_list, arule_list) {
+		/*
+		 * bg_arule     |-----|
+		 * del_arule  |---------|
+		 */
+		if (del_arule->start <= bg_arule->start &&
+				del_arule->end >= bg_arule->end) {
+			freed_blocks = ext4_mb_count_unused_blocks(bd_bitmap,
+						bg_arule->start, bg_arule->end);
+			ext4_mb_calc_restricted(sbi, &bg_arule_list,
+						bg_arule->alloc_flag,
+						-freed_blocks);
+			list_del(&bg_arule->arule_list);
+			kfree(bg_arule);
+			bg_arule = NULL;
+		/*
+		 * bg_arule     |-----|
+		 * del_arule  |---|
+		 */
+		} else if (del_arule->start <= bg_arule->start &&
+				del_arule->end >= bg_arule->start) {
+			freed_blocks = ext4_mb_count_unused_blocks(bd_bitmap,
+					bg_arule->start, del_arule->end);
+			ext4_mb_calc_restricted(sbi, &bg_arule_list,
+						bg_arule->alloc_flag,
+						-freed_blocks);
+			bg_arule->start = del_arule->end + 1;
+		/*
+		 * bg_arule     |-----|
+		 * del_arule        |---|
+		 */
+		} else if (del_arule->start <= bg_arule->end &&
+				del_arule->end >= bg_arule->end) {
+			freed_blocks = ext4_mb_count_unused_blocks(bd_bitmap,
+					del_arule->start, bg_arule->end);
+			ext4_mb_calc_restricted(sbi, &bg_arule_list,
+						bg_arule->alloc_flag,
+						-freed_blocks);
+			bg_arule->end = del_arule->start - 1;
+		/*
+		 * bg_arule     |-----|
+		 * del_arule     |---|
+		 */
+		} else if (del_arule->start > bg_arule->start &&
+				del_arule->end < bg_arule->end) {
+			add_arule = kmalloc(sizeof(struct ext4_bg_alloc_rule),
+								GFP_KERNEL);
+			if (add_arule == NULL) {
+				ext4_unlock_group(sb, group_no);
+				ext4_mb_release_desc(&e4b);
+				return -ENOMEM;
+			}
+			freed_blocks = ext4_mb_count_unused_blocks(bd_bitmap,
+					del_arule->start, del_arule->end);
+			ext4_mb_calc_restricted(sbi, &bg_arule_list,
+						bg_arule->alloc_flag,
+						-freed_blocks);
+
+			INIT_LIST_HEAD(&add_arule->arule_list);
+			INIT_LIST_HEAD(&add_arule->tmp_list);
+			add_arule->start = del_arule->end + 1;
+			add_arule->end = bg_arule->end;
+			add_arule->alloc_flag = bg_arule->alloc_flag;
+			list_add(&add_arule->arule_list,
+					&bg_arule->arule_list);
+			/* fix existed alloc rule */
+			bg_arule->end = del_arule->start - 1;
+		} else if (del_arule->end < bg_arule->start)
+			break;
+	}
+
+	if (list_empty(&bg_arule_list->arule_list))
+		list_del(&bg_arule_list->bg_arule_list);
+
+	ext4_unlock_group(sb, group_no);
+	ext4_mb_release_desc(&e4b);
+
+	return 0;
+}
+
+int ext4_mb_del_global_arule(struct inode *inode,
+					struct ext4_alloc_rule *arule)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_bg_alloc_rule_list *bg_arule_list, *tmp_arule_list;
+	struct ext4_bg_alloc_rule del_arule;
+	ext4_fsblk_t start, end;
+	ext4_group_t start_bgnum, end_bgnum;
+	int ret, del_flag = 0;
+	unsigned long bg_size = EXT4_BLOCKS_PER_GROUP(sb);
+
+	ret = ext4_mb_check_arule(inode, arule);
+	if (ret < 0)
+		return ret;
+
+	start = arule->start;
+	end = arule->start + arule->len - 1;
+
+	ext4_get_group_no_and_offset(sb, start, &start_bgnum, NULL);
+	ext4_get_group_no_and_offset(sb, end, &end_bgnum, NULL);
+
+	write_lock(&sbi->s_bg_arule_lock);
+	while (start <= end) {
+		INIT_LIST_HEAD(&del_arule.arule_list);
+		INIT_LIST_HEAD(&del_arule.tmp_list);
+		ext4_get_group_no_and_offset(sb, start, NULL, &del_arule.start);
+		del_arule.alloc_flag = arule->alloc_flag;
+		/* if end is out of bg in start, fix it */
+		if (end_bgnum > start_bgnum)
+			del_arule.end = (ext4_grpblk_t)(bg_size - 1);
+		else
+			ext4_get_group_no_and_offset(sb, end, NULL,
+							&del_arule.end);
+
+		list_for_each_entry_safe(bg_arule_list, tmp_arule_list,
+					&sbi->s_bg_arule_list, bg_arule_list) {
+			if (bg_arule_list->bg_num != start_bgnum)
+				continue;
+
+			ret = ext4_mb_del_bg_arule(sb, bg_arule_list,
+						   &del_arule);
+			if (ret < 0)
+				goto out;
+
+			del_flag = 1;
+			break;
+		}
+
+		start_bgnum++;
+		start = ext4_group_first_block_no(sb, start_bgnum);
+	}
+
+	if (!del_flag)
+		ext4_debug("There is no alloc rule: start=%llu len=%llu\n",
+						(ext4_fsblk_t)arule->start,
+						(ext4_fsblk_t)arule->len);
+
+out:
+	write_unlock(&sbi->s_bg_arule_lock);
+	return ret;
+}
