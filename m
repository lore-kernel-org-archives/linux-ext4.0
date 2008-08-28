From: Theodore Tso <tytso@mit.edu>
Subject: Re: Online resize with flex bg
Date: Thu, 28 Aug 2008 13:36:52 -0400
Message-ID: <20080828173652.GL26987@mit.edu>
References: <1219934280.3591.121.camel@frecb007923.frec.bull.fr> <20080828171156.GK26987@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37707 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751432AbYH1Rgy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 13:36:54 -0400
Content-Disposition: inline
In-Reply-To: <20080828171156.GK26987@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

And here's the short-term fix.  With this patch, e2fsprogs will work
on ext4 filesystems with flex_bg.  Interested in working on the
long-term fix, where we put all or most of the resizing logic in the
kernel?  :-)

						- Ted

commit df3871a168c3f8308718d72a17062a20aa02cc01
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Aug 28 13:24:12 2008 -0400

    resize2fs: Allow (non-optimal) on-line resizing for ext4 filesystems
    
    The current method of adding one block group at a time to a mounted
    filesystem means it is impossible to accomodate the flex_bg allocation
    method of placing the metadata together in a single block group.  For
    now we "fix" this issue by using the traditional layout for new block
    groups, where each block group is self-contained and contains its own
    bitmap blocks and inode tables.  This means we don't get the layout
    advantages of flex_bg in the new block groups, but at least it allows
    on-line resizing to function.
    
    Long term, we will need to create a new ioctl which does much more of
    the resizing work in the kernel.
    
    We also fix a bug in the ext3/ext4 ioctl fallback code so we stop
    trying the ext3 ioctl for every single block group when resizing an
    ext4 filesystem.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/resize/online.c b/resize/online.c
index f4d24ce..d581553 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -93,6 +93,17 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	if (retval)
 		return retval;
 
+	/* The current method of adding one block group at a time to a
+	 * mounted filesystem means it is impossible to accomodate the
+	 * flex_bg allocation method of placing the metadata together
+	 * in a single block group.  For now we "fix" this issue by
+	 * using the traditional layout for new block groups, where
+	 * each block group is self-contained and contains its own
+	 * bitmap blocks and inode tables.  This means we don't get
+	 * the layout advantages of flex_bg in the new block groups,
+	 * but at least it allows on-line resizing to function.
+	 */
+	new_fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
 	retval = adjust_fs_info(new_fs, fs, *new_size);
 	if (retval)
 		return retval;
@@ -154,7 +165,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		    ioctl(fd, EXT2_IOC_GROUP_ADD, &input) == 0)
 			continue;
 		else
-			use_old_ioctl = 1;
+			use_old_ioctl = 0;
 
 		input64.group = input.group;
 		input64.block_bitmap = input.block_bitmap;
