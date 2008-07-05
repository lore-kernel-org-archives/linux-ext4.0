From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 50/52] ext4: Enable delalloc by default.
Date: Sat,  5 Jul 2008 13:36:16 -0400
Message-ID: <1215279378-30504-51-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
 <1215279378-30504-37-git-send-email-tytso@mit.edu>
 <1215279378-30504-38-git-send-email-tytso@mit.edu>
 <1215279378-30504-39-git-send-email-tytso@mit.edu>
 <1215279378-30504-40-git-send-email-tytso@mit.edu>
 <1215279378-30504-41-git-send-email-tytso@mit.edu>
 <1215279378-30504-42-git-send-email-tytso@mit.edu>
 <1215279378-30504-43-git-send-email-tytso@mit.edu>
 <1215279378-30504-44-git-send-email-tytso@mit.edu>
 <1215279378-30504-45-git-send-email-tytso@mit.edu>
 <1215279378-30504-46-git-send-email-tytso@mit.edu>
 <1215279378-30504-47-git-send-email-tytso@mit.edu>
 <1215279378-30504-48-git-send-email-tytso@mit.edu>
 <1215279378-30504-49-git-send-email-tytso@mit.edu>
 <1215279378-30504-50-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33053 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754867AbYGERga (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:30 -0400
In-Reply-To: <1215279378-30504-50-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Enable delalloc by default to ensure it gets sufficient testing and
because it makes the filesystem much more efficient.  Add a nodealalloc
option to disable delayed allocation, and update ext4_show_options to
show delayed allocation off if it is disabled.

If the data=journal mount option is used, disable delayed allocation
since the delalloc code doesn't support data=journal yet.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/super.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 25e2f24..4e104dd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -756,6 +756,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",nomballoc");
 	if (test_opt(sb, I_VERSION))
 		seq_puts(seq, ",i_version");
+	if (!test_opt(sb, DELALLOC))
+		seq_puts(seq, ",nodelalloc");
+
 
 	if (sbi->s_stripe)
 		seq_printf(seq, ",stripe=%lu", sbi->s_stripe);
@@ -903,7 +906,7 @@ enum {
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents, Opt_i_version,
-	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_delalloc,
+	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 };
 
 static match_table_t tokens = {
@@ -963,6 +966,7 @@ static match_table_t tokens = {
 	{Opt_stripe, "stripe=%u"},
 	{Opt_resize, "resize"},
 	{Opt_delalloc, "delalloc"},
+	{Opt_nodelalloc, "nodelalloc"},
 	{Opt_err, NULL},
 };
 
@@ -1328,6 +1332,9 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt, I_VERSION);
 			sb->s_flags |= MS_I_VERSION;
 			break;
+		case Opt_nodelalloc:
+			clear_opt(sbi->s_mount_opt, DELALLOC);
+			break;
 		case Opt_mballoc:
 			set_opt(sbi->s_mount_opt, MBALLOC);
 			break;
@@ -1984,6 +1991,13 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 */
 	set_opt(sbi->s_mount_opt, MBALLOC);
 
+	/*
+	 * enable delayed allocation by default
+	 * Use -o nodelalloc to turn it off
+	 */
+	set_opt(sbi->s_mount_opt, DELALLOC);
+
+
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
 		goto failed_mount;
@@ -2422,6 +2436,13 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		test_opt(sb,DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
+				"requested data journaling mode\n");
+		clear_opt(sbi->s_mount_opt, DELALLOC);
+	} else if (test_opt(sb, DELALLOC))
+		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
+
 	ext4_ext_init(sb);
 	ext4_mb_init(sb, needs_recovery);
 
-- 
1.5.6.rc3.1.g36b7.dirty

