From: tytso@mit.edu
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Thu, 4 Mar 2010 17:08:05 -0500
Message-ID: <20100304220805.GF15028@thunk.org>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
 <1267553925-6308-12-git-send-email-tytso@mit.edu>
 <4B8E1410.1010107@rs.jp.nec.com>
 <20100303175217.GA3530@thunk.org>
 <4B8F47C6.9060408@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Leonard Michlmayr <leonard.michlmayr@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40717 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0CDWIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 17:08:10 -0500
Content-Disposition: inline
In-Reply-To: <4B8F47C6.9060408@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 04, 2010 at 02:40:22PM +0900, Akira Fujita wrote:
> <user-space>
> filefrag:
> 	fiemap->fm_start(0) fiemap->fm_length(~0ULL)
> 
> <kernel-space>
> fs/ioctl.c ioctl_fimap():
> 
> filemap_check_ranges():
> 	len(~0ULL)
> 	new_len(4398046511103 = s_maxbytes)  <--- Because 'len > s_maxbytes'
> 
> fs/ext4/extents.c ext4_fiemap():
> 	last_blk = start(0) + len(4398046511103) - 1 >> s_blocksize_bits(11)
> 	         = 4294967295 (0xFFFFFFFF)
> 	len_blks = 4294967295 + 1 (0xFFFFFFFF + 0x00000001)
> 		 = 4294967296 (0x100000000)  <--- _OVERFLOW!!_
> 	
> ext4_ext_walk_space():
> 	num = 0
> 
> This overflow leads to incorrect output like the below,
> even though 2 extents exist.

Akira-san,

Thank you for your clear explanation; you're absolutely correct.  I've
replaced the patch with the following, which I think is a bit clearer.
I've tested to make sure it does the right thing, including a number
of corner cases.

Regards,

					- Ted

commit aca92ff6f57c000d1b4523e383c8bd6b8269b8b1
Author: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Date:   Thu Mar 4 17:07:28 2010 -0500

    ext4: correctly calculate number of blocks for fiemap
    
    ext4_fiemap() rounds the length of the requested range down to
    blocksize, which is is not the true number of blocks that cover the
    requested region.  This problem is especially impressive if the user
    requests only the first byte of a file: not a single extent will be
    reported.
    
    We fix this by calculating the last block of the region and then
    subtract to find the number of blocks in the extents.
    
    Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bd80891..7d54850 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3768,7 +3768,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
 	ext4_lblk_t start_blk;
-	ext4_lblk_t len_blks;
 	int error = 0;
 
 	/* fallback to generic here if not in extents fmt */
@@ -3782,8 +3781,14 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 		error = ext4_xattr_fiemap(inode, fieinfo);
 	} else {
+		ext4_lblk_t len_blks;
+		__u64 last_blk;
+
 		start_blk = start >> inode->i_sb->s_blocksize_bits;
-		len_blks = len >> inode->i_sb->s_blocksize_bits;
+		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
+		if (last_blk >= EXT_MAX_BLOCK)
+			last_blk = EXT_MAX_BLOCK-1;
+		len_blks = ((ext4_lblk_t) last_blk) - start_blk + 1;
 
 		/*
 		 * Walk the extent tree gathering extent information.
