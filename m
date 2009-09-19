From: Will Drewry <redpig@dataspill.org>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Sat, 19 Sep 2009 07:19:09 -0500
Message-ID: <20090919121909.GA1077@freezingfog.local>
References: <20090916162457.GA84213@freezingfog.local> <20090916190831.GH2537@webber.adilger.int> <20090916204225.GB84213@freezingfog.local> <20090916212250.GL2537@webber.adilger.int> <20090916231131.GC84213@freezingfog.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:44640 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZISMTQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Sep 2009 08:19:16 -0400
Received: by yxe37 with SMTP id 37so1753082yxe.33
        for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2009 05:19:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20090916231131.GC84213@freezingfog.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 16, 2009 at 06:11:31PM -0500, Will Drewry wrote:
> On Wed, Sep 16, 2009 at 03:22:50PM -0600, Andreas Dilger wrote:
> > On Sep 16, 2009  15:42 -0500, Will Drewry wrote:
[snip]
> > It might make sense to avoid requiring the user to specify this,
> > rather remembering the option supplied at mke2fs time?  There is
> > the COMPAT_LAZY_BG superblock flag that might be usable for this,
> > though Ted might have some comments about any potential compatibility
> > issues.
> 
> Cool - yeah I'd love to make use of the COMPAT_LAZY_BG flag since it
> seems that all (but e2p/features.c) references to it seem to be gone
> from the e2fsprogs source and the kernel.  I'm happy to rewrite it to do
> so and update mke2fs to set LAZY_BG when lazy_itable_init=1 is set.
> 
> > Other than that, the patch looks reasonable at first glance.
> 
> Thanks!  If Ted has any feedback on the use of COMPAT_LAZY_BG, I'll
> rewrite it using that (or not).  Using COMPAT_LAZY_BG would also be nice
> because it would make it easier to decide when it's okay to online resize
> without initializing itables too (and would fit its initial purpose
> of being useful for sparse files)!


Here's the same patch for offline resizing based on LAZY_BG. I only have
a less-than-stable kernel patch at present, but I figured I wouldn't push
on that until I have a bit more time.

This change adds support for offline resize2fs to use lazy inode
table initialization if the superblock is marked with LAZY_BG and
GDT_CSUM.  This speeds up offline resizing dramatically and doesn't
undermine the speed gains of e2fsck on the first run after resizing.

Thanks!
will

Signed-off-by: Will Drewry <redpig <at> dataspill.org>
---

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 5c3d17f..45fab3e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -508,6 +508,7 @@ typedef struct ext2_icount *ext2_icount_t;
                                         EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
                                         EXT2_FEATURE_COMPAT_RESIZE_INODE|\
                                         EXT2_FEATURE_COMPAT_DIR_INDEX|\
+                                        EXT2_FEATURE_COMPAT_LAZY_BG|\
                                         EXT2_FEATURE_COMPAT_EXT_ATTR)
 
 /* This #ifdef is temporary until compression is fully supported */
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 84c4361..28880a9 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1687,6 +1687,12 @@ got_size:
 		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
 	}
 
+	/* Mark the filesystem as friendly to uninit_bg during later resizing. */
+	if (lazy_itable_init &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
+	                               EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		fs_param.s_feature_compat |= EXT2_FEATURE_COMPAT_LAZY_BG;
+
 	if (inode_size && fs_param.s_rev_level >= EXT2_DYNAMIC_REV) {
 		if (inode_size < EXT2_GOOD_OLD_INODE_SIZE ||
 		    inode_size > EXT2_BLOCK_SIZE(&fs_param) ||
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1a5d910..12003e4 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -302,7 +302,7 @@ errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
 	int		adj, old_numblocks, numblocks, adjblocks;
 	unsigned long	i, j, old_desc_blocks, max_group;
 	unsigned int	meta_bg, meta_bg_size;
-	int		has_super, csum_flag;
+	int		has_super, csum_flag, lazy_flag;
 	unsigned long long new_inodes;	/* u64 to check for overflow */
 	double		percent;
 
@@ -482,6 +482,8 @@ retry:
 
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					       EXT2_FEATURE_COMPAT_LAZY_BG);
 	adj = old_fs->group_desc_count;
 	max_group = fs->group_desc_count - adj;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
@@ -496,9 +498,12 @@ retry:
 		adjblocks = 0;
 
 		fs->group_desc[i].bg_flags = 0;
-		if (csum_flag)
-			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT |
-				EXT2_BG_INODE_ZEROED;
+		if (csum_flag) {
+			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT;
+			if (!lazy_flag) {
+				fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
+			}
+		}
 		if (i == fs->group_desc_count-1) {
 			numblocks = (fs->super->s_blocks_count -
 				     fs->super->s_first_data_block) %
@@ -568,7 +573,7 @@ errout:
 static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
 {
 	ext2_filsys fs;
-	int		adj = 0;
+	int		adj = 0, csum_flag = 0, lazy_flag = 0, num = 0;
 	errcode_t	retval;
 	blk_t		group_block;
 	unsigned long	i;
@@ -624,6 +629,11 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
 				&rfs->itable_buf);
 	if (retval)
 		goto errout;
+	/* Track if we can get by with a lazy init */
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					       EXT2_FEATURE_COMPAT_LAZY_BG);
 
 	memset(rfs->itable_buf, 0, fs->blocksize * fs->inode_blocks_per_group);
 	group_block = fs->super->s_first_data_block +
@@ -642,10 +652,21 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
 		/*
 		 * Write out the new inode table
 		 */
+		if (csum_flag && lazy_flag) {
+			/* These are _new_ inode tables. No inodes should be in use. */
+			fs->group_desc[i].bg_itable_unused = fs->super->s_inodes_per_group;
+			num = ((((fs->super->s_inodes_per_group -
+				  fs->group_desc[i].bg_itable_unused) *
+				 EXT2_INODE_SIZE(fs->super)) +
+				EXT2_BLOCK_SIZE(fs->super) - 1) /
+			       EXT2_BLOCK_SIZE(fs->super));
+		} else {
+			num = fs->inode_blocks_per_group;
+		}
 		retval = io_channel_write_blk(fs->io,
-					      fs->group_desc[i].bg_inode_table,
-					      fs->inode_blocks_per_group,
-					      rfs->itable_buf);
+					      fs->group_desc[i].bg_inode_table, /* blk */
+					      num,  /* count */
+					      rfs->itable_buf);  /* contents */
 		if (retval) goto errout;
 
 		io_channel_flush(fs->io);
