From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Fri, 05 Mar 2010 14:57:49 +0900
Message-ID: <4B909D5D.5070402@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43704 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0CEF6g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2010 00:58:36 -0500
Received: from mailgate3.nec.co.jp ([10.7.69.160])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id o255wZiF004146
	for <linux-ext4@vger.kernel.org>; Fri, 5 Mar 2010 14:58:35 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id o255wZM16063 for linux-ext4@vger.kernel.org; Fri, 5 Mar 2010 14:58:35 +0900 (JST)
Received: from mail03.kamome.nec.co.jp (mail03.kamome.nec.co.jp [10.25.43.7])
	by mailsv4.nec.co.jp (8.13.8/8.13.4) with ESMTP id o255wYR6009974
	for <linux-ext4@vger.kernel.org>; Fri, 5 Mar 2010 14:58:34 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

> commit aca92ff6f57c000d1b4523e383c8bd6b8269b8b1
> Author: Leonard Michlmayr<leonard.michlmayr@gmail.com>
> Date:   Thu Mar 4 17:07:28 2010 -0500
>
>      ext4: correctly calculate number of blocks for fiemap
>
>      ext4_fiemap() rounds the length of the requested range down to
>      blocksize, which is is not the true number of blocks that cover the
>      requested region.  This problem is especially impressive if the user
>      requests only the first byte of a file: not a single extent will be
>      reported.
>
>      We fix this by calculating the last block of the region and then
>      subtract to find the number of blocks in the extents.
>
>      Signed-off-by: Leonard Michlmayr<leonard.michlmayr@gmail.com>
>      Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bd80891..7d54850 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3768,7 +3768,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>           __u64 start, __u64 len)
>   {
>       ext4_lblk_t start_blk;
> -    ext4_lblk_t len_blks;
>       int error = 0;
>
>       /* fallback to generic here if not in extents fmt */
> @@ -3782,8 +3781,14 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>       if (fieinfo->fi_flags&  FIEMAP_FLAG_XATTR) {
>           error = ext4_xattr_fiemap(inode, fieinfo);
>       } else {
> +        ext4_lblk_t len_blks;
> +        __u64 last_blk;
> +
>           start_blk = start>>  inode->i_sb->s_blocksize_bits;
> -        len_blks = len>>  inode->i_sb->s_blocksize_bits;
> +        last_blk = (start + len - 1)>>  inode->i_sb->s_blocksize_bits;
> +        if (last_blk>= EXT_MAX_BLOCK)
> +            last_blk = EXT_MAX_BLOCK-1;

               last_blk = EXT_MAX_BLOCK - 1;

You seem to have already pushed this patch to Linus, though.
There is a coding style thing.
Anyway, the patch works fine for me.
Thanks for your work.  :-)

Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Regards,
Akira Fujita

> +        len_blks = ((ext4_lblk_t) last_blk) - start_blk + 1;
>
>           /*
>            * Walk the extent tree gathering extent information.
>
