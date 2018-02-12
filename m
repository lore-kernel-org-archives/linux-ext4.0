From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: avoid inode number error with large FS
Date: Mon, 12 Feb 2018 16:45:53 +0100
Message-ID: <20180212154553.g3jfjdmta7uw7n4s@rh_laptop>
References: <20180212111419.25036-1-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932173AbeBLPp4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Feb 2018 10:45:56 -0500
Content-Disposition: inline
In-Reply-To: <20180212111419.25036-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 12, 2018 at 02:14:19PM +0300, Artem Blagodarenko wrote:
> From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
> 
> Sometimes during system deployment customers are faced with system
> formating problem for given inodes/bytes rate. User need to recalucate
> this rate and start formating again.
> 
> This patch adds code that limit inodes count instead of error return,
> to use all inodes in the filesystem.

Hi,

in this case then you do not have byte-per-inode ratio you've
specified. So why to specify it in the first place ?

Maybe I am missing something but I would think that if you specify -i
then you know what you want and if it's not possible then I would not
expect the mke2fs to just succeed regardless. I guess it's confusing.

Also the man page says:

"This value generally shouldn't be smaller than the blocksize of the
filesystem, since in that case more inodes would be made than can ever
be used."

But in your case you're using "-i 1024" on what I assume is a 4k bs file
system ?

-Lukas

> 
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-9501
> Cray-bug-id: LUS-5250
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@gmail.com>
> ---
>  misc/mke2fs.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index cfb10bc4..6fb0a717 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2457,14 +2457,11 @@ profile_error:
>  		unsigned long long n;
>  		n = ext2fs_blocks_count(&fs_param) * blocksize / inode_ratio;
>  		if (n > MAX_32_NUM) {
> -			if (ext2fs_has_feature_64bit(&fs_param))
> -				num_inodes = MAX_32_NUM;
> -			else {
> +			num_inodes = MAX_32_NUM;
> +			if (!ext2fs_has_feature_64bit(&fs_param))
>  				com_err(program_name, 0,
> -					_("too many inodes (%llu), raise "
> -					  "inode ratio?"), n);
> -				exit(1);
> -			}
> +					_("too many inodes (%llu), reduced to "
> +					  "%llu"), n, MAX_32_NUM);
>  		}
>  	} else if (num_inodes > MAX_32_NUM) {
>  		com_err(program_name, 0,
> -- 
> 2.14.3 (Apple Git-98)
> 
