From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] debugfs: fix two warning messages when compiling with
 LLVM (Re: compile warning on master)
Date: Tue, 27 May 2014 18:56:33 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405271854320.2055@localhost.localdomain>
References: <CFA1367A.A6C68%andreas.dilger@intel.com> <65EABAA6-4117-4059-B04D-0E0D77D698CE@dilger.ca> <20140526065508.GA4591@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaE0Q4m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 12:56:42 -0400
In-Reply-To: <20140526065508.GA4591@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 26 May 2014, Zheng Liu wrote:

> Date: Mon, 26 May 2014 14:55:08 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Andreas Dilger <adilger@dilger.ca>
> Cc: Zheng Liu <wenqing.lz@taobao.com>,
>     Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: [PATCH] debugfs: fix two warning messages when compiling with LLVM
>     (Re: compile warning on master)
> 
> On Tue, May 20, 2014 at 05:14:34PM -0600, Andreas Dilger wrote:
> > 
> > When compiling with LLVM, it generates the following warning in
> > debugfs::do_lsdel():
> > 
> > 367 debugfs/lsdel.c:155 col 23: warning: '&&' within '||'
> > [-Wlogical-op-parentheses]
> > 368:                if (lsd.free_blocks && !lsd.bad_blocks ||
> > 369:                    ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~ ~~
> > 370 debugfs/lsdel.c:155 col 23: note: place parentheses around the '&&'
> > expression to silence this warning
> > 371:                if (lsd.free_blocks && !lsd.bad_blocks ||
> > 372:                                    ^
> > 373:                    (                                 )
> > 
> > 
> > Unfortunately, even looking at this code and the patch that changed it,
> > I can't figure out what the correct parenthesis is for it.
> > 
> > Zheng, could you please send a patch to fix this?
> 
> Thanks for reporting this.  Could you please try the following patch?
> 
> Regards,
>                                                 - Zheng
> 
> Subject: [PATCH] debugfs: fix two warning messages when compiling with LLVM
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit fixes two warning messages when compiling with LLVM.

make sense. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>


> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Reported-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  debugfs/lsdel.c          |    2 +-
>  lib/ext2fs/inline_data.c |    3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
> index 5276014..a7c30b3 100644
> --- a/debugfs/lsdel.c
> +++ b/debugfs/lsdel.c
> @@ -152,7 +152,7 @@ void do_lsdel(int argc, char **argv)
>  				goto next;
>  			}
>  		}
> -		if (lsd.free_blocks && !lsd.bad_blocks ||
> +		if ((lsd.free_blocks && !lsd.bad_blocks) ||
>  		    inode.i_flags & EXT4_INLINE_DATA_FL) {
>  			if (num_delarray >= max_delarray) {
>  				max_delarray += 50;
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 7a81da0..f318b41 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -280,10 +280,9 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
>  	struct ext2_dir_entry *dir, *dir2;
>  	struct ext2_dir_entry_tail *t;
>  	errcode_t retval;
> -	unsigned int offset;
> +	unsigned int offset, rec_len;
>  	int csum_size = 0;
>  	int filetype = 0;
> -	int rec_len;
>  
>  	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
>  				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> 
