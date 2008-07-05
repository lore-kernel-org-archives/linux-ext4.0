From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 04/52] ext4: switch to seq_files
Date: Sat,  5 Jul 2008 13:35:30 -0400
Message-ID: <1215279378-30504-5-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33035 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754329AbYGERg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:29 -0400
In-Reply-To: <1215279378-30504-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext4/mballoc.c |   68 ++++++++++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e4b1ea3..7897193 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2577,25 +2577,24 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 
 
 
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
@@ -2607,31 +2606,32 @@ static int ext4_mb_write_##name(struct file *file,		\
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
1.5.6.rc3.1.g36b7.dirty

