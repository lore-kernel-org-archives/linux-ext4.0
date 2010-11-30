From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 03/15] mke2fs: simplify inode table block counting
Date: Tue, 30 Nov 2010 13:01:31 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011301250470.3004@dhcp-lab-213.englab.brq.redhat.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com> <1291020917-8671-4-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0K3MBj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 07:01:39 -0500
In-Reply-To: <1291020917-8671-4-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 29 Nov 2010, Namhyung Kim wrote:

> Simplify counting of inode table blocks in a block group using
> local variable 'ipb'. Otherwise the variable could be removed
> because there was no user of it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  misc/mke2fs.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 0980045..9fb5d5f 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -320,11 +320,8 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
>  
>  		if (lazy_flag) {
>  			ipb = fs->blocksize / EXT2_INODE_SIZE(fs->super);
> -			num = ((((fs->super->s_inodes_per_group -
> -				  ext2fs_bg_itable_unused(fs, i)) *
> -				 EXT2_INODE_SIZE(fs->super)) +
> -				EXT2_BLOCK_SIZE(fs->super) - 1) /
> -			       EXT2_BLOCK_SIZE(fs->super));
> +			num = (fs->super->s_inodes_per_group -
> +			       ext2fs_bg_itable_unused(fs, i) + ipb - 1) / ipb;
>  		}
>  		if (!lazy_flag || itable_zeroed) {
>  			/* The kernel doesn't need to zero the itable blocks */
> 

Hi,

I would rather add this macro into header file (lib/ext2fs/ext2fs.h
maybe?)

#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

remoevd ipb variable because it is rather useless. And do something like
this ?

num = DIV_ROUND_UP((fs->super->s_inodes_per_group -
		    ext2fs_bg_itable_unused(fs, i)) *
		   EXT2_INODE_SIZE(fs->super), 
		   EXT2_BLOCK_SIZE(fs->super));

IMO it improves readability a lot and I am sure that there are other
places which may take advantage of the DIV_ROUND_UP macro.

Thanks!

-Lukas
