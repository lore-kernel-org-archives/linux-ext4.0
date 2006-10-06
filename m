From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [PATCH] Get rid of extents mount option - try 2
Date: Fri, 06 Oct 2006 16:21:40 -0500
Message-ID: <1160169700.8658.56.camel@kleikamp.austin.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	 <20061005205526.7fe744f5.akpm@osdl.org>  <20061006122105.GA21816@thunk.org>
	 <1160169015.8658.50.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:3272 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1422976AbWJFVVp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 17:21:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k96LLhFX024830
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 17:21:43 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k96LLgbq114228
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 17:21:42 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k96LLgY8001895
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 17:21:42 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <1160169015.8658.50.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I rushed that out too quick.  This one cleans up the header files too.

EXT4: Get rid of extents mount option

Enabling an ext4 file system to use extents should be done with
'tune2fs -O extents' or 'mke2fs -O extents', not with a mount option

Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

diff -Nurp linux-orig/fs/ext4/extents.c linux/fs/ext4/extents.c
--- linux-orig/fs/ext4/extents.c	2006-10-05 07:39:08.000000000 -0500
+++ linux/fs/ext4/extents.c	2006-10-06 15:45:59.000000000 -0500
@@ -1875,7 +1875,7 @@ void ext4_ext_init(struct super_block *s
 	 * possible initialization would be here
 	 */
 
-	if (test_opt(sb, EXTENTS)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		printk("EXT4-fs: file extents enabled");
 #ifdef AGRESSIVE_TEST
 		printk(", agressive tests");
@@ -1900,7 +1900,7 @@ void ext4_ext_init(struct super_block *s
  */
 void ext4_ext_release(struct super_block *sb)
 {
-	if (!test_opt(sb, EXTENTS))
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
 		return;
 
 #ifdef EXTENTS_STATS
diff -Nurp linux-orig/fs/ext4/ialloc.c linux/fs/ext4/ialloc.c
--- linux-orig/fs/ext4/ialloc.c	2006-10-05 07:39:08.000000000 -0500
+++ linux/fs/ext4/ialloc.c	2006-10-06 15:37:36.000000000 -0500
@@ -618,16 +618,9 @@ got:
 		ext4_std_error(sb, err);
 		goto fail_free_drop;
 	}
-	if (test_opt(sb, EXTENTS)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
 		ext4_ext_tree_init(handle, inode);
-		if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
-			err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
-			if (err) goto fail;
-			EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS);
-			BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "call ext4_journal_dirty_metadata");
-			err = ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
-		}
 	}
 
 	ext4_debug("allocating inode %lu\n", inode->i_ino);
diff -Nurp linux-orig/fs/ext4/super.c linux/fs/ext4/super.c
--- linux-orig/fs/ext4/super.c	2006-10-05 07:39:08.000000000 -0500
+++ linux/fs/ext4/super.c	2006-10-06 15:47:47.000000000 -0500
@@ -728,7 +728,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota, Opt_extents,
+	Opt_grpquota,
 };
 
 static match_table_t tokens = {
@@ -778,7 +778,6 @@ static match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
-	{Opt_extents, "extents"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1111,9 +1110,6 @@ clear_qf_name:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
-		case Opt_extents:
-			set_opt (sbi->s_mount_opt, EXTENTS);
-			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "
diff -Nurp linux-orig/include/linux/ext4_fs.h linux/include/linux/ext4_fs.h
--- linux-orig/include/linux/ext4_fs.h	2006-10-05 07:39:08.000000000 -0500
+++ linux/include/linux/ext4_fs.h	2006-10-06 16:13:07.000000000 -0500
@@ -399,7 +399,6 @@ struct ext4_inode {
 #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
-#define EXT4_MOUNT_EXTENTS		0x400000 /* Extents support */
 
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
diff -Nurp linux-orig/include/linux/ext4_jbd2.h linux/include/linux/ext4_jbd2.h
--- linux-orig/include/linux/ext4_jbd2.h	2006-10-05 07:39:08.000000000 -0500
+++ linux/include/linux/ext4_jbd2.h	2006-10-06 16:17:20.000000000 -0500
@@ -33,7 +33,7 @@
 
 #define EXT4_SINGLEDATA_TRANS_BLOCKS(sb)				\
 	(EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)	\
-		|| test_opt(sb, EXTENTS) ? 27U : 8U)
+		? 27U : 8U)
 
 /* Extended attribute operations touch at most two data buffers,
  * two bitmap buffers, and two group summaries, in addition to the inode

-- 
David Kleikamp
IBM Linux Technology Center

