From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] misc: fix create_inode warnings with LLVM
Date: Tue, 27 May 2014 18:34:52 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405271834430.2055@localhost.localdomain>
References: <1400627542-75060-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbaE0QfB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 12:35:01 -0400
In-Reply-To: <1400627542-75060-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 20 May 2014, Andreas Dilger wrote:

> Date: Tue, 20 May 2014 17:12:22 -0600
> From: Andreas Dilger <adilger@dilger.ca>
> To: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
> Subject: [PATCH] misc: fix create_inode warnings with LLVM
> 
> Fix name clash in do_mknod_internal() due to local variables named
> "major" and "minor" shadowing identical macro names.
> 
> Also, no need to set the major and minor device for a FIFO inode.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Looks good, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>


> ---
>  misc/create_inode.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 964c66a..1d666c7 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -96,9 +96,9 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
>  			    struct stat *st)
>  {
>  	ext2_ino_t		ino;
> -	errcode_t 		retval;
> +	errcode_t		retval;
>  	struct ext2_inode	inode;
> -	unsigned long		major, minor, mode;
> +	unsigned long		devmajor, devminor, mode;
>  	int			filetype;
>  
>  	switch(st->st_mode & S_IFMT) {
> @@ -153,16 +153,18 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
>  	inode.i_atime = inode.i_ctime = inode.i_mtime =
>  		fs->now ? fs->now : time(0);
>  
> -	major = major(st->st_rdev);
> -	minor = minor(st->st_rdev);
> -
> -	if ((major < 256) && (minor < 256)) {
> -		inode.i_block[0] = major * 256 + minor;
> -		inode.i_block[1] = 0;
> -	} else {
> -		inode.i_block[0] = 0;
> -		inode.i_block[1] = (minor & 0xff) | (major << 8) |
> -				   ((minor & ~0xff) << 12);
> +	if (filetype != S_IFIFO) {
> +		devmajor = major(st->st_rdev);
> +		devminor = minor(st->st_rdev);
> +
> +		if ((devmajor < 256) && (devminor < 256)) {
> +			inode.i_block[0] = devmajor * 256 + devminor;
> +			inode.i_block[1] = 0;
> +		} else {
> +			inode.i_block[0] = 0;
> +			inode.i_block[1] = (devminor & 0xff) | (devmajor << 8) |
> +					   ((devminor & ~0xff) << 12);
> +		}
>  	}
>  	inode.i_links_count = 1;
>  
> 
