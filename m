From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_fallocate
Date: Mon, 25 Jun 2012 15:17:44 -0400
Message-ID: <20120625191744.GB9688@thunk.org>
References: <4FE8086F.4070506@zoho.com>
 <20120625085159.GA18931@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52607 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2FYTRu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 15:17:50 -0400
Content-Disposition: inline
In-Reply-To: <20120625085159.GA18931@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 25, 2012 at 04:51:59PM +0800, Zheng Liu wrote:
> 
> Actually I want to send a url for you from linux mailing list archive but
> I cannot find it.  After applying this patch, you can call ioctl(2) to
> enable expose_stale_data flag, and then when you call fallocate(2), ext4
> create initialized extents for you.  This patch cannot be merged into
> upstream kernel because it brings a huge security hole.

This is what we're using internally inside Google.... this allows the
security exposure to be restricted to those programs running with a
specific group id (which is better than giving programs access to
CAP_SYS_RAWIO).  We also require the use of a specific fallocate flag
so that programs have to explicitly ask for this feature.

Also note that I restrict the combination of NO_HIDE_STALE &&
KEEP_SIZE since it causes e2fsck to complain --- and if you're trying
to avoid fs metadata I/O, you want to avoid the extra i_size update
anyway, so it's not worth trying to make this work w/o causing e2fsck
complaints.

This patch is versus the v3.3 kernel (as it happens, I was just in the
middle of rebasing this patch from 2.6.34 :-)

					- Ted

P.S.  It just occurred to me that there are some patches being
discussed that assign new fallocate flags for volatile data handling.
So it would probably be a good idea to move the fallocate flag
codepoint assignment up out of the way to avoid future conflicts.

commit 5f12f1bc2b0fb0866d52763a611b022780780f05
Author: Theodore Ts'o <tytso@google.com>
Date:   Fri Jun 22 17:19:53 2012 -0400

    ext4: add an fallocate flag to mark newly allocated extents initialized
    
    This commit adds a new flag to ext4's fallocate that allows new,
    uninitialized extents to be marked as initialized. This flag,
    FALLOC_FL_NO_HIDE_STALE requires that the nohide_stale_gid=<gid> mount
    option be used when the file system is mounted, and that the user is
    in the group <gid>.
    
    The benefit is to a program fallocates a larger space, but then writes
    to that space in small increments.  This option prevents ext4 from
    having to split the unallocated extent and merge the newly initialized
    extent with the extent to its left.  Even though this usually happens
    in-memory, this option is useful for tight memory situations and for
    ext4 on flash.  Note: This allows an application in ths hohide_stale
    group to see stale data on the filesystem.
    
    Tested: Updated xfstests g002 to test a case where
      fallocate:no-hide-stale is not allowed.  The existing tests now pass
      because I added a remount with a group that user root is in.
    Rebase-Tested-v3.3: same
    
    Effort: fs/nohide-stale
    Origin-2.6.34-SHA1: c3099bf61be1baf94bc91c481995bb0d77f05786
    Origin-2.6.34-SHA1: 004dd33b9ebc5d860781c3435526658cc8aa8ccb
    Change-Id: I0d2a7f2a4cf34443269acbcedb7b7074e0055e69

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aaaece6..ac7aa42 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1240,6 +1240,9 @@ struct ext4_sb_info {
 	unsigned long s_mb_last_group;
 	unsigned long s_mb_last_start;
 
+	/* gid that's allowed to see stale data via falloc flag. */
+	gid_t no_hide_stale_gid;
+
 	/* stats for buddy allocator */
 	atomic_t s_bal_reqs;	/* number of reqs with len > 1 */
 	atomic_t s_bal_success;	/* we found long enough chunks */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cb99346..cc57c85 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4375,6 +4375,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	int retries = 0;
 	int flags;
 	struct ext4_map_blocks map;
+	struct ext4_sb_info *sbi;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
 	/*
@@ -4385,12 +4386,28 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_NO_HIDE_STALE))
+		return -EOPNOTSUPP;
+
+	/* The combination of NO_HIDE_STALE and KEEP_SIZE is not supported */
+	if ((mode & FALLOC_FL_NO_HIDE_STALE) &&
+	    (mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(file, offset, len);
 
+	sbi = EXT4_SB(inode->i_sb);
+	/* Must have RAWIO to see stale data. */
+	if ((mode & FALLOC_FL_NO_HIDE_STALE) &&
+	    !in_egroup_p(sbi->no_hide_stale_gid))
+		return -EACCES;
+
+	/* preallocation to directories is currently not supported */
+	if (S_ISDIR(inode->i_mode))
+		return -ENODEV;
+
 	trace_ext4_fallocate_enter(inode, offset, len, mode);
 	map.m_lblk = offset >> blkbits;
 	/*
@@ -4429,6 +4446,8 @@ retry:
 			ret = PTR_ERR(handle);
 			break;
 		}
+		if (mode & FALLOC_FL_NO_HIDE_STALE)
+			flags &= ~EXT4_GET_BLOCKS_UNINIT_EXT;
 		ret = ext4_map_blocks(handle, inode, &map, flags);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5b443a8..d976ec1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1175,6 +1175,8 @@ static int ext4_show_options(struct seq_file *seq, struct dentry *root)
 	if (test_opt2(sb, BIG_EXT))
 		seq_puts(seq, ",big_extent");
 #endif
+	if (sbi->no_hide_stale_gid != -1)
+		seq_printf(seq, ",nohide_stale_gid=%u", sbi->no_hide_stale_gid);
 
 	ext4_show_quota_options(seq, sb);
 
@@ -1353,6 +1355,7 @@ enum {
 #ifdef CONFIG_EXT4_BIG_EXTENT
 	Opt_big_extent, Opt_nobig_extent,
 #endif
+	Opt_nohide_stale_gid,
 };
 
 static const match_table_t tokens = {
@@ -1432,6 +1435,7 @@ static const match_table_t tokens = {
 	{Opt_big_extent, "big_extent"},
 	{Opt_nobig_extent, "nobig_extent"},
 #endif
+	{Opt_nohide_stale_gid, "nohide_stale_gid=%u"},
 	{Opt_err, NULL},
 };
 
@@ -1931,6 +1935,12 @@ set_qf_format:
 				return 0;
 			sbi->s_li_wait_mult = option;
 			break;
+		case Opt_nohide_stale_gid:
+			if (match_int(&args[0], &option))
+				return 0;
+			/* -1 for disabled, otherwise it's valid. */
+			sbi->no_hide_stale_gid = option;
+			break;
 		case Opt_noinit_itable:
 			clear_opt(sb, INIT_INODE_TABLE);
 			break;
@@ -3274,6 +3284,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_EXT4_BIG_EXTENT
 	sbi->s_min_big_ext_size = EXT4_DEFAULT_MIN_BIG_EXT_SIZE;
 #endif
+	/* Default to having no-hide-stale disabled. */
+	sbi->no_hide_stale_gid = -1;
 
 	if ((def_mount_opts & EXT4_DEFM_NOBARRIER) == 0)
 		set_opt(sb, BARRIER);
diff --git a/fs/open.c b/fs/open.c
index 201431a..4edc0cd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -224,7 +224,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE |
+		     FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_NO_HIDE_STALE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 73e0b62..a2489ac 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -3,6 +3,7 @@
 
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
+#define FALLOC_FL_NO_HIDE_STALE	0x04 /* default is hide stale data */
 
 #ifdef __KERNEL__
 
