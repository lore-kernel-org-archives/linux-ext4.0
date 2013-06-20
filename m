From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR DISCUSSION] add delalloc debugging
Date: Thu, 20 Jun 2013 12:42:49 -0400
Message-ID: <20130620164249.GC4982@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59852 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965232Ab3FTQmw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 12:42:52 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been carrying a patch in the unstable portion of the patch series
for a while now to debug problems with delayed allocation.  This
allows us to observe the state of which inodes have inodes subject for
delayed allocation, and how many data/metadata blocks have been
reserved.

I've finally cleaned it up enough that it's something where I wouldn't
feel terrible dropping it into the mainline kernel.  (It's still a
little gross, but it's not truly horrifying any more.)  

What do people think?  Is this something that's worth having in the
kernel sources?  Or shall I continue carrying it as an out-of-tree
debugging patch?

(Note: we can use similar technique to gain visibility into the status
the extent status LRU list.)

      	          	       	      	  - Ted

>From f6417debc1c96a9dfa6b9f19da14eff35bf0f504 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 20 Jun 2013 12:35:39 -0400
Subject: [PATCH] ext4: add delalloc debugging

This adds a file in /proc/fs/ext4/<dev> which when opened for reading,
will trigger debugging code that dumps a lot of information about
inodes subject to delayed allocation to the console.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 85b3dd6..ecb8256 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1832,6 +1832,74 @@ static const struct file_operations ext4_seq_options_fops = {
 	.release = single_release,
 };
 
+#ifdef CONFIG_EXT4_DEBUG
+static void print_inode_delalloc_info(struct inode *inode)
+{
+	if (!EXT4_I(inode)->i_reserved_data_blocks ||
+	    !EXT4_I(inode)->i_reserved_meta_blocks)
+		return;
+
+	printk(KERN_DEBUG "ino %lu: %u %u\n", inode->i_ino,
+	       EXT4_I(inode)->i_reserved_data_blocks,
+	       EXT4_I(inode)->i_reserved_meta_blocks);
+}
+
+static int debug_delalloc_show(struct seq_file *seq, void *offset)
+{
+	return 0;
+}
+
+static int options_delalloc_debug_open_fs(struct inode *proc_inode,
+					  struct file *file)
+{
+	struct super_block *sb = PDE_DATA(proc_inode);
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode;
+	extern spinlock_t inode_sb_list_lock;
+
+	printk(KERN_DEBUG "EXT4-fs debug delalloc of %s\n", sb->s_id);
+	printk(KERN_DEBUG "EXT4-fs: dirty clusters %lld free clusters %lld\n",
+	       percpu_counter_sum(&sbi->s_dirtyclusters_counter),
+	       percpu_counter_sum(&sbi->s_freeclusters_counter));
+
+#ifndef MODULE
+	spin_lock(&inode_sb_list_lock);
+	if (!list_empty(&sb->s_bdi->wb.b_dirty)) {
+		printk(KERN_DEBUG "s_bdi->wb.b_dirty list:\n");
+		list_for_each_entry(inode, &sb->s_bdi->wb.b_dirty,
+				    i_wb_list) {
+			print_inode_delalloc_info(inode);
+		}
+	}
+	if (!list_empty(&sb->s_bdi->wb.b_io)) {
+		printk(KERN_DEBUG "s_bdi->wb.b_io list:\n");
+		list_for_each_entry(inode, &sb->s_bdi->wb.b_io,
+				    i_wb_list) {
+			print_inode_delalloc_info(inode);
+		}
+	}
+	if (!list_empty(&sb->s_bdi->wb.b_more_io)) {
+		printk(KERN_DEBUG "s_bdi->wb.b_more_io list:\n");
+		list_for_each_entry(inode, &sb->s_bdi->wb.b_more_io,
+				    i_wb_list) {
+			print_inode_delalloc_info(inode);
+		}
+	}
+	spin_unlock(&inode_sb_list_lock);
+	printk(KERN_DEBUG "ext4 debug delalloc done\n");
+#endif
+	return single_open(file, debug_delalloc_show, sb);
+}
+
+static const struct file_operations ext4_seq_delalloc_debug_fops = {
+	.owner = THIS_MODULE,
+	.open = options_delalloc_debug_open_fs,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+#endif
+
 static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 			    int read_only)
 {
@@ -3764,9 +3832,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (ext4_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
 
-	if (sbi->s_proc)
+	if (sbi->s_proc) {
 		proc_create_data("options", S_IRUGO, sbi->s_proc,
 				 &ext4_seq_options_fops, sb);
+#ifdef CONFIG_EXT4_DEBUG
+		proc_create_data("delalloc_debug", S_IRUSR, sbi->s_proc,
+				 &ext4_seq_delalloc_debug_fops, sb);
+#endif
+	}
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
@@ -4149,6 +4222,9 @@ failed_mount:
 		crypto_free_shash(sbi->s_chksum_driver);
 	if (sbi->s_proc) {
 		remove_proc_entry("options", sbi->s_proc);
+#ifdef CONFIG_EXT4_DEBUG
+		remove_proc_entry("delalloc_debug", sbi->s_proc);
+#endif
 		remove_proc_entry(sb->s_id, ext4_proc_root);
 	}
 #ifdef CONFIG_QUOTA
-- 
1.7.12.rc0.22.gcdd159b

