From: Curt Wohlgemuth <curtw@google.com>
Subject: PATCH: Making mb_history length a dynamic tunable
Date: Tue, 7 Apr 2009 10:20:52 -0700
Message-ID: <6601abe90904071020gdce65d2madc6df30c182c5cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:57506 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759294AbZDGRUz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 13:20:55 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id n37HKrmw023560
	for <linux-ext4@vger.kernel.org>; Tue, 7 Apr 2009 10:20:53 -0700
Received: from gxk10 (gxk10.prod.google.com [10.202.11.10])
	by wpaz24.hot.corp.google.com with ESMTP id n37HJQx2017540
	for <linux-ext4@vger.kernel.org>; Tue, 7 Apr 2009 10:20:52 -0700
Received: by gxk10 with SMTP id 10so6064187gxk.14
        for <linux-ext4@vger.kernel.org>; Tue, 07 Apr 2009 10:20:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi:

Since we frequently run in memory-constrained systems with many partitions,
the ~68K for each partition for the mb_history buffer can be excessive.  The
following creates a new proc file under /proc/fs/ext4/ to control the number
of entries at mount time.

If the notion of a history length tunable is okay, but the location should
be under /sys/fs/ext4/ instead of /proc/fs/ext4/, I can change this.  The
leftover files under /proc/fs/ext4/<partition>/ are a bit confusing to me.

Thanks,
Curt

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
--- ext4/fs/ext4/mballoc.c.orig	2009-04-07 09:13:12.000000000 -0700
+++ ext4/fs/ext4/mballoc.c	2009-04-07 10:08:05.000000000 -0700
@@ -334,6 +334,10 @@
 static struct kmem_cache *ext4_pspace_cachep;
 static struct kmem_cache *ext4_ac_cachep;
 static struct kmem_cache *ext4_free_ext_cachep;
+
+#define DEFAULT_HIST_SIZE 1000
+static int ext4_mbhist_size = DEFAULT_HIST_SIZE;
+
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
 static void ext4_mb_generate_from_freelist(struct super_block *sb,
void *bitmap,
@@ -2417,31 +2421,36 @@ static struct file_operations ext4_mb_se
 static void ext4_mb_history_release(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int delete_mbhist = sbi->s_mb_history_max != 0;

 	if (sbi->s_proc != NULL) {
 		remove_proc_entry("mb_groups", sbi->s_proc);
-		remove_proc_entry("mb_history", sbi->s_proc);
+		if (delete_mbhist)
+			remove_proc_entry("mb_history", sbi->s_proc);
 	}
-	kfree(sbi->s_mb_history);
+	if (delete_mbhist)
+		kfree(sbi->s_mb_history);
 }

 static void ext4_mb_history_init(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int i;
+	int create_mbhist = ext4_mbhist_size != 0;

 	if (sbi->s_proc != NULL) {
-		proc_create_data("mb_history", S_IRUGO, sbi->s_proc,
-				 &ext4_mb_seq_history_fops, sb);
+		if (create_mbhist)
+			proc_create_data("mb_history", S_IRUGO, sbi->s_proc,
+					 &ext4_mb_seq_history_fops, sb);
 		proc_create_data("mb_groups", S_IRUGO, sbi->s_proc,
 				 &ext4_mb_seq_groups_fops, sb);
 	}

-	sbi->s_mb_history_max = 1000;
+	sbi->s_mb_history_max = ext4_mbhist_size;
 	sbi->s_mb_history_cur = 0;
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
-	sbi->s_mb_history = kzalloc(i, GFP_KERNEL);
+	sbi->s_mb_history = create_mbhist ? kzalloc(i, GFP_KERNEL) : NULL;
 	/* if we can't allocate history, then we simple won't use it */
 }

@@ -2894,6 +2903,49 @@ static void release_blocks_on_commit(jou
 	mb_debug("freed %u blocks in %u structures\n", count, count2);
 }

+static ssize_t read_mb_hist_size(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char buffer[20];
+	size_t len;
+
+	len = snprintf(buffer, sizeof(buffer), "%i\n", ext4_mbhist_size);
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t write_mb_hist_size(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	/* This allows for 99999 entries, at 68 bytes each */
+#define MAX_BUFSIZE 6
+	char kbuf[MAX_BUFSIZE + 1];
+	int value;
+
+	if (count) {
+		if (count > MAX_BUFSIZE)
+			return -EINVAL;
+		if (copy_from_user(&kbuf, buf, count))
+			return -EFAULT;
+		kbuf[min(count, sizeof(kbuf))-1] = '\0';
+
+
+		value = simple_strtol(kbuf, NULL, 0);
+
+		if (value < 0)
+			return -EINVAL;
+
+		ext4_mbhist_size = value;
+	}
+	return count;
+#undef MAX_BUFSIZE
+}
+
+static struct file_operations ext4_mb_size_fops = {
+	.read		= read_mb_hist_size,
+	.write		= write_mb_hist_size,
+};
+
 int __init init_ext4_mballoc(void)
 {
 	ext4_pspace_cachep =
@@ -2912,6 +2964,9 @@ int __init init_ext4_mballoc(void)
 		return -ENOMEM;
 	}

+	proc_create("mb_hist_size", S_IRUGO | S_IWUGO, ext4_proc_root,
+			 &ext4_mb_size_fops);
+
 	ext4_free_ext_cachep =
 		kmem_cache_create("ext4_free_block_extents",
 				     sizeof(struct ext4_free_data),
