From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Wed, 03 Mar 2010 16:47:28 +0900
Message-ID: <4B8E1410.1010107@rs.jp.nec.com>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu> <1267553925-6308-12-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Leonard Michlmayr <leonard.michlmayr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39424 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0CCHsF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 02:48:05 -0500
In-Reply-To: <1267553925-6308-12-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

 > From: Leonard Michlmayr<leonard.michlmayr@gmail.com>
 >
 > ext4_fiemap() rounds the length of the requested range down to
 > blocksize, which is is not the true number of blocks that cover the
 > requested region.  This problem is especially impressive if the user
 > requests only the first byte of a file: not a single extent will be
 > reported.

<snip>

 >   		start_blk = start>>  inode->i_sb->s_blocksize_bits;
 > -		len_blks = len>>  inode->i_sb->s_blocksize_bits;
 > +		last_blk = (start + len - 1)>>  inode->i_sb->s_blocksize_bits;
 > +		len_blks = last_blk - start_blk + 1;

In 1KB block size, the overflow occurs at above line.
Since last_blk is set 0xffffffff when len is equal to s_maxbytes.
Therefore ext4_fiemap() can not get correct extent information
with 0 length.  How about adding this change?

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
  extents.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)
--- linux-2.6.33-rc8-a/fs/ext4/extents.c        2010-03-03 14:53:49.000000000 +0900
+++ linux-2.6.33-rc8-b/fs/ext4/extents.c        2010-03-03 15:31:57.000000000 +0900
@@ -3912,7 +3912,8 @@ int ext4_fiemap(struct inode *inode, str

                 start_blk = start >> inode->i_sb->s_blocksize_bits;
                 last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
-               len_blks = last_blk - start_blk + 1;
+               len_blks = (loff_t)last_blk - start_blk + 1 < EXT_MAX_BLOCK ?
+                               last_blk - start_blk + 1 : EXT_MAX_BLOCK;

                 /*
                  * Walk the extent tree gathering extent information.


(2010/03/03 3:18), Theodore Ts'o wrote:
> From: Leonard Michlmayr<leonard.michlmayr@gmail.com>
>
> ext4_fiemap() rounds the length of the requested range down to
> blocksize, which is is not the true number of blocks that cover the
> requested region.  This problem is especially impressive if the user
> requests only the first byte of a file: not a single extent will be
> reported.
>
> We fix this by calculating the last block of the region and then
> subtract to find the number of blocks in the extents.
>
> Signed-off-by: Leonard Michlmayr<leonard.michlmayr@gmail.com>
> Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> ---
>   fs/ext4/extents.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bd80891..bc9860f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3768,7 +3768,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>   		__u64 start, __u64 len)
>   {
>   	ext4_lblk_t start_blk;
> -	ext4_lblk_t len_blks;
>   	int error = 0;
>
>   	/* fallback to generic here if not in extents fmt */
> @@ -3782,8 +3781,11 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>   	if (fieinfo->fi_flags&  FIEMAP_FLAG_XATTR) {
>   		error = ext4_xattr_fiemap(inode, fieinfo);
>   	} else {
> +		ext4_lblk_t last_blk, len_blks;
> +
>   		start_blk = start>>  inode->i_sb->s_blocksize_bits;
> -		len_blks = len>>  inode->i_sb->s_blocksize_bits;
> +		last_blk = (start + len - 1)>>  inode->i_sb->s_blocksize_bits;
> +		len_blks = last_blk - start_blk + 1;
>
>   		/*
>   		 * Walk the extent tree gathering extent information.

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Software Development Division,
NEC Software Tohoku, Ltd.

--Separator@a-fujita@rs.jp.nec.com:
