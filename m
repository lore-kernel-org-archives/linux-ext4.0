From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] e2image: Add image consistency information and -f option
 to manpage
Date: Mon, 14 Oct 2013 10:08:02 -0300
Message-ID: <20131014130801.GA19467@orion.maiolino.org>
References: <1380575965-9668-1-git-send-email-cmaiolino@redhat.com>
 <20131012024905.GA30680@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955Ab3JNNIH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Oct 2013 09:08:07 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9ED86OS012443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Oct 2013 09:08:07 -0400
Received: from orion.maiolino.org (ovpn-113-114.phx2.redhat.com [10.3.113.114])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9ED83CG011917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Oct 2013 09:08:05 -0400
Content-Disposition: inline
In-Reply-To: <20131012024905.GA30680@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Ted :-)

On Fri, Oct 11, 2013 at 10:49:05PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 30, 2013 at 06:19:25PM -0300, Carlos Maiolino wrote:
> > Adds information regarding image consistency when using e2image on a read-write
> > filesystem and about -f option used now to force the image creation of a
> > read-write filesystem
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Here is the combined commit which I've just added to my tree in the
> maint branch.  It includes the man page with some clarifications in
> the wording.  Also I've changed things so that we only print the error
> message for e2image -r and e2image -Q.
> 
> 						- Ted
> 
> commit 6c327e9ca47fa4e51efe3a6601ad661b8c1a3964
> Author: Carlos Maiolino <cmaiolino@redhat.com>
> Date:   Fri Oct 11 21:38:53 2013 -0400
> 
>     e2image: complain if running e2image -r or -Q on a mounted filesystem
>     
>     Several users have used e2image on a mounted RW filesystem, resulting in
>     inconsistent, useless e2images for debugging purposes.
>     
>     This commit will forbid this and print an error message, although the
>     user can override this using a new force option.
>     
>     Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/misc/e2image.8.in b/misc/e2image.8.in
> index 84b9729..78f0682 100644
> --- a/misc/e2image.8.in
> +++ b/misc/e2image.8.in
> @@ -30,6 +30,16 @@ recovering catastrophically corrupted filesystems.  In the future,
>  e2fsck will be enhanced to be able to use the image file to help
>  recover a badly damaged filesystem.
>  .PP
> +When saving an e2image for debugging purposes, using either the
> +.B \-r
> +or
> +.B \-Q
> +options, the filesystem must be unmounted or be mounted read/only, in order
> +for the image file to be in a consistent state.  This requirement can be
> +overriden using the
> +.B -f
> +option, but the resulting image file is very likely not going to be useful.
> +.PP
>  If
>  .I image-file
>  is \-, then the output of
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 885a794..4a5bb22 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -87,7 +87,7 @@ static int get_bits_from_size(size_t size)
>  
>  static void usage(void)
>  {
> -	fprintf(stderr, _("Usage: %s [-rsIQa] device image_file\n"),
> +	fprintf(stderr, _("Usage: %s [-rsIQaf] device image_file\n"),
>  		program_name);
>  	exit (1);
>  }
> @@ -1252,9 +1252,11 @@ int main (int argc, char ** argv)
>  	int open_flag = EXT2_FLAG_64BITS;
>  	int img_type = 0;
>  	int flags = 0;
> +	int mount_flags = 0;
>  	int qcow2_fd = 0;
>  	int fd = 0;
>  	int ret = 0;
> +	int ignore_rw_mount = 0;
>  	struct stat st;
>  
>  #ifdef ENABLE_NLS
> @@ -1269,7 +1271,7 @@ int main (int argc, char ** argv)
>  	if (argc && *argv)
>  		program_name = *argv;
>  	add_error_table(&et_ext2_error_table);
> -	while ((c = getopt(argc, argv, "rsIQa")) != EOF)
> +	while ((c = getopt(argc, argv, "rsIQaf")) != EOF)
>  		switch (c) {
>  		case 'I':
>  			flags |= E2IMAGE_INSTALL_FLAG;
> @@ -1290,6 +1292,9 @@ int main (int argc, char ** argv)
>  		case 'a':
>  			all_data = 1;
>  			break;
> +		case 'f':
> +			ignore_rw_mount = 1;
> +			break;
>  		default:
>  			usage();
>  		}
> @@ -1305,6 +1310,19 @@ int main (int argc, char ** argv)
>  	device_name = argv[optind];
>  	image_fn = argv[optind+1];
>  
> +	ext2fs_check_if_mounted(device_name, &mount_flags);
> +
> +	if (img_type && !ignore_rw_mount &&
> +	    (mount_flags & EXT2_MF_MOUNTED) &&
> +	   !(mount_flags & EXT2_MF_READONLY)) {
> +		fprintf(stderr, "\nRunning e2image on a R/W mounted "
> +			"filesystem can result in an\n"
> +			"inconsistent image which will not be useful "
> +			"for debugging purposes.\n"
> +			"Use -f option if you really want to do that.\n");
> +		exit(1);
> +	}
> +
>  	if (flags & E2IMAGE_INSTALL_FLAG) {
>  		install_image(device_name, image_fn, img_type);
>  		exit (0);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
