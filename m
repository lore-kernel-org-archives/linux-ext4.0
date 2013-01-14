From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] resize2fs: add debug switch to use old online interface
Date: Mon, 14 Jan 2013 10:10:49 -0200
Message-ID: <20130114121049.GA3906@andromeda.usersys.redhat.com>
References: <50F05175.8060502@redhat.com>
 <20130112003027.GA9550@thunk.org>
 <50F0AF49.6010902@redhat.com>
 <20130112230427.GC19503@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3ANMK4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 07:10:56 -0500
Content-Disposition: inline
In-Reply-To: <20130112230427.GC19503@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 12, 2013 at 06:04:27PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 11, 2013 at 06:33:13PM -0600, Eric Sandeen wrote:
> > 
> > The mechanism doesn't matter to me, we just need to be able to test
> > it if the interface is in the kernel.  I had originally had an "-o"
> > option for "old interface" but that didn't seem great.
> 
> How about this instead?
> 
> 						- Ted
>
Hi,

the patch looks good, but I'm very concerned about how much problems this will
cause to stable releases and enterprise products which use to work with older
kernel versions but a lot of backports of new features/bug fixes. Probably
upstream stable releases will not be too much affected giving these features
(new resize interface) might never be ported to stable kernels, but how about
the backporters? This mightl cause a lot of confusion when changing the
major/minor versions needed here.

IMHO, the new resize interface looks much better than the old one, and just
developers and users which do not have new interface should make use of the old
one. For developers I believe a resize2fs option is good enough to be used as
debug, and for users, well, if they do not have the new resize2fs, we should do
noting, once they'll use the old one automatically :-)


> From d1d0b92a2e031b8962f7c3f4f97983db88c82969 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sat, 12 Jan 2013 17:33:44 -0500
> Subject: [PATCH] resize2fs: add debugging code to test the old online
>  resizing interfaces
> 
> The old online resize ioctl interfaces are still present in the
> kernel, and we want to make it easy to test both the kernel code for
> those older interfaces, and resize2fs's use of those interfaces in a
> relatively easy manner.
> 
> To do this, resize2fs will now check the environment variable
> RESIZE2FS_KERNEL_VERSION.  If the version given is less than 3.3, then
> do not try using the new resizing ioctl, but instead use the resizing
> ioctls that were used before Linux version 3.3.
> 
> If the version given is less than 3.7, then emulate sanity checks
> which get done to protect against the fact that the new resizing ioctl
> prior to 3.7 did not handle meta_bg resizing.  (This was previously
> tested via the presence of the RESIZE2FS_NO_META_BG_RESIZE environment
> variable.  But the new environment variable, RESIZE2FS_KERNEL_VERISON,
> is more general.)
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  resize/online.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/resize/online.c b/resize/online.c
> index d3d3546..2d34640 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -21,6 +21,33 @@ extern char *program_name;
>  
>  #define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
>  
> +#ifdef __linux__
> +static int parse_version_number(const char *s)
> +{
> +	int	major, minor, rev;
> +	char	*endptr;
> +	const char *cp = s;
> +
> +	if (!s)
> +		return 0;
> +	major = strtol(cp, &endptr, 10);
> +	if (cp == endptr || *endptr != '.')
> +		return 0;
> +	cp = endptr + 1;
> +	minor = strtol(cp, &endptr, 10);
> +	if (cp == endptr || *endptr != '.')
> +		return 0;
> +	cp = endptr + 1;
> +	rev = strtol(cp, &endptr, 10);
> +	if (cp == endptr)
> +		return 0;
> +	return ((((major * 256) + minor) * 256) + rev);
> +}
> +
> +#define VERSION_CODE(a,b,c) (((a) << 16) + ((b) << 8) + (c))
> +
> +#endif
> +
>  errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>  			   blk64_t *new_size, int flags EXT2FS_ATTR((unused)))
>  {
> @@ -36,6 +63,18 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>  	blk_t			size;
>  	int			fd, overhead;
>  	int			use_old_ioctl = 1;
> +	int			no_meta_bg_resize = 0;
> +	int			no_resize_ioctl = 0;
> +
> +	if (getenv("RESIZE2FS_KERNEL_VERSION")) {
> +		char *version_to_emulate = getenv("RESIZE2FS_KERNEL_VERSION");
> +		int kvers = parse_version_number(version_to_emulate);
> +
> +		if (kvers < VERSION_CODE(3, 7, 0))
> +			no_meta_bg_resize = 1;
> +		if (kvers < VERSION_CODE(3, 3, 0))
> +			no_resize_ioctl = 1;
> +	}
>  
>  	printf(_("Filesystem at %s is mounted on %s; "
>  		 "on-line resizing required\n"), fs->device_name, mtpt);
> @@ -61,7 +100,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>  	 * Do error checking to make sure the resize will be successful.
>  	 */
>  	if ((access("/sys/fs/ext4/features/meta_bg_resize", R_OK) != 0) ||
> -	    getenv("RESIZE2FS_NO_META_BG_RESIZE")) {
> +	    no_meta_bg_resize) {
>  		if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
>  					EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
>  		    (new_desc_blocks != fs->desc_blocks)) {
> @@ -94,7 +133,9 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>  		exit(1);
>  	}
>  
> -	if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
> +	if (no_resize_ioctl) {
> +		printf(_("Old resize interface requested.\n"));
> +	} else if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
>  		/*
>  		 * If kernel does not support EXT4_IOC_RESIZE_FS, use the
>  		 * old online resize. Note that the old approach does not
> -- 
> 1.7.12.rc0.22.gcdd159b
> 

-- 
Carlos
