From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [PATCH] Get rid of extents mount option
Date: Fri, 06 Oct 2006 16:10:14 -0500
Message-ID: <1160169015.8658.50.camel@kleikamp.austin.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	 <20061005205526.7fe744f5.akpm@osdl.org>  <20061006122105.GA21816@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:19354 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1422959AbWJFVKX
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Oct 2006 17:10:23 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k96LAKW1010826
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 17:10:20 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k96LAIDA523010
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 15:10:20 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k96LAHYE005045
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 15:10:18 -0600
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061006122105.GA21816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-10-06 at 08:21 -0400, Theodore Tso wrote:
> On Thu, Oct 05, 2006 at 08:55:26PM -0700, Andrew Morton wrote:
> > So let me see if I have this right.
> > 
> > You grab Alexandre's kit from http://www.bullopensource.org/ext4/20060926/
> > and a plain old `mke2fs -j' gives a filesystem which will mount as ext3 or
> > ext4.
> > 
> > If you then mount this filesystem with `-t ext4dev -o extents', it becomes
> > incompatible with the ext3 driver.  Yes?
> 
> I agree that's the wrong behaviour, and I've always hated the idea of
> using using mount -o options to enable ext3/4 features.  (When do it
> with EA's and acl's, sigh, and that's wrong too, but at least I was
> able to paper over that later by adding default mount option support
> into the superblock.)
> 
> The right way to do this is to only enable a feature like extents
> after using tune2fs -O extents, or creating a filesystem with mke2fs
> -O extents.
> 
> Can we change the patches to do this, please?

Something like this?

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

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

