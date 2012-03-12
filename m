From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] ext4: check for zero length extent
Date: Sun, 11 Mar 2012 20:00:58 -0600
Message-ID: <84C5A1E3-0ACA-465E-9768-FEAC7BC5044A@gmail.com>
References: <1331498791-2455-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"merll@web.de" <merll@web.de>, Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34728 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2CLCA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Mar 2012 22:00:27 -0400
Received: by iagz16 with SMTP id z16so6129943iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 11 Mar 2012 19:00:27 -0700 (PDT)
In-Reply-To: <1331498791-2455-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-11, at 14:46, Theodore Ts'o <tytso@mit.edu> wrote:
> Explicitly test for an extent whose length is zero, and flag that as a
> corrupted extent.

Two minor nits in the patch:

> This avoids a kernel BUG_ON assertion failure.
> 
> Tested: Without this patch, the file system image found in
> tests/f_ext_zero_len/image.gz in the latest e2fsprogs sources causes a
> kernel panic.  With this patch, an ext4 file systmem error is noted

(typo) s/systmem/system/

> instead, and the file system is marked as being corrupted.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=42859
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> fs/ext4/extents.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 74f23c2..203885c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -300,6 +300,8 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
>    ext4_fsblk_t block = ext4_ext_pblock(ext);
>    int len = ext4_ext_get_actual_len(ext);
> 
> +    if (!len)

I'd prefer:

        if (len == 0)

Since len is not a Boolean. 

> +        return 0;
>    return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
> }
> 
> -- 
> 1.7.9.107.g97f9a
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
