From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ext4: switch to seq_files
Date: Fri, 9 May 2008 20:20:44 +0400
Message-ID: <20080509162044.GA8802@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: akpm@osdl.org, sct@redhat.com, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:29501 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYEIPZV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 11:25:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so680963nfc.21
        for <linux-ext4@vger.kernel.org>; Fri, 09 May 2008 08:25:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/ext4/mballoc.c |   68 +++++++++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

>From 92f42e16a7b8816fdd5f643aeed6bc259c9ac821 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 9 May 2008 15:31:41 +0400
Subject: [PATCH 5/7] proc: seq_file ext4

---
 fs/ext4/mballoc.c |   68 ++++++++++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2575,25 +2575,24 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 
 
 
-#define MB_PROC_VALUE_READ(name)				\
-static int ext4_mb_read_##name(char *page, char **start,	\
-		off_t off, int count, int *eof, void *data)	\
+#define MB_PROC_FOPS(name)					\
+static int ext4_mb_##name##_proc_show(struct seq_file *m, void *v)	\
 {								\
-	struct ext4_sb_info *sbi = data;			\
-	int len;						\
-	*eof = 1;						\
-	if (off != 0)						\
-		return 0;					\
-	len = sprintf(page, "%ld\n", sbi->s_mb_##name);		\
-	*start = page;						\
-	return len;						\
-}
-
-#define MB_PROC_VALUE_WRITE(name)				\
-static int ext4_mb_write_##name(struct file *file,		\
-		const char __user *buf, unsigned long cnt, void *data)	\
+	struct ext4_sb_info *sbi = m->private;			\
+								\
+	seq_printf(m, "%ld\n", sbi->s_mb_##name);		\
+	return 0;						\
+}								\
+								\
+static int ext4_mb_##name##_proc_open(struct inode *inode, struct file *file)\
+{								\
+	return single_open(file, ext4_mb_##name##_proc_show, PDE(inode)->data);\
+}								\
+								\
+static ssize_t ext4_mb_##name##_proc_write(struct file *file,	\
+		const char __user *buf, size_t cnt, loff_t *ppos)	\
 {								\
-	struct ext4_sb_info *sbi = data;			\
+	struct ext4_sb_info *sbi = PDE(file->f_path.dentry->d_inode)->data;\
 	char str[32];						\
 	long value;						\
 	if (cnt >= sizeof(str))					\
@@ -2605,31 +2604,32 @@ static int ext4_mb_write_##name(struct file *file,		\
 		return -ERANGE;					\
 	sbi->s_mb_##name = value;				\
 	return cnt;						\
-}
+}								\
+								\
+static const struct file_operations ext4_mb_##name##_proc_fops = {	\
+	.owner		= THIS_MODULE,				\
+	.open		= ext4_mb_##name##_proc_open,		\
+	.read		= seq_read,				\
+	.llseek		= seq_lseek,				\
+	.release	= single_release,			\
+	.write		= ext4_mb_##name##_proc_write,		\
+};
 
-MB_PROC_VALUE_READ(stats);
-MB_PROC_VALUE_WRITE(stats);
-MB_PROC_VALUE_READ(max_to_scan);
-MB_PROC_VALUE_WRITE(max_to_scan);
-MB_PROC_VALUE_READ(min_to_scan);
-MB_PROC_VALUE_WRITE(min_to_scan);
-MB_PROC_VALUE_READ(order2_reqs);
-MB_PROC_VALUE_WRITE(order2_reqs);
-MB_PROC_VALUE_READ(stream_request);
-MB_PROC_VALUE_WRITE(stream_request);
-MB_PROC_VALUE_READ(group_prealloc);
-MB_PROC_VALUE_WRITE(group_prealloc);
+MB_PROC_FOPS(stats);
+MB_PROC_FOPS(max_to_scan);
+MB_PROC_FOPS(min_to_scan);
+MB_PROC_FOPS(order2_reqs);
+MB_PROC_FOPS(stream_request);
+MB_PROC_FOPS(group_prealloc);
 
 #define	MB_PROC_HANDLER(name, var)					\
 do {									\
-	proc = create_proc_entry(name, mode, sbi->s_mb_proc);		\
+	proc = proc_create_data(name, mode, sbi->s_mb_proc,		\
+				&ext4_mb_##var##_proc_fops, sbi);	\
 	if (proc == NULL) {						\
 		printk(KERN_ERR "EXT4-fs: can't to create %s\n", name);	\
 		goto err_out;						\
 	}								\
-	proc->data = sbi;						\
-	proc->read_proc  = ext4_mb_read_##var ;				\
-	proc->write_proc = ext4_mb_write_##var;				\
 } while (0)
 
 static int ext4_mb_init_per_dev_proc(struct super_block *sb)
-- 
1.5.3.7


