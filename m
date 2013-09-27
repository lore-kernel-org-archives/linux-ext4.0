From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] e2image: Print a warning if running over a mounted
 filesystem
Date: Fri, 27 Sep 2013 11:37:55 -0500
Message-ID: <5245B463.90209@redhat.com>
References: <1380296025-28937-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab3I0Qh4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Sep 2013 12:37:56 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8RGbswu026051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Sep 2013 12:37:55 -0400
In-Reply-To: <1380296025-28937-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/27/13 10:33 AM, Carlos Maiolino wrote:
> Several users use to run e2image over a mounted RW filesystem, providing
> inconsistent, useless e2images for debugging purposes.
> This patch adds a warning in such cases, notifying the user and also adds a
> force option making e2image able to run in such cases.
> Also print a warning when not using qcow or raw formats but allows image
> creation to proceed, since, such images might be used for metadata backup
> purposes.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

manpage updates, please :)

My only other nitpick would be that a comment somewhere before:

+		if (img_type && !ignore_rw_mount) {
+			fprintf(stderr, "Use -f option if you really want to "
+					"do that.\n");

to explain why that condition requires -f, but the other (!img_type)
does not, would be helpful to future code-readers.

Thanks,
-Eric

> ---
>  misc/e2image.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 885a794..248399d 100644
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
> @@ -1305,6 +1310,21 @@ int main (int argc, char ** argv)
>  	device_name = argv[optind];
>  	image_fn = argv[optind+1];
>  
> +	ext2fs_check_if_mounted(device_name, &mount_flags);
> +
> +	if ((mount_flags & EXT2_MF_MOUNTED) &&
> +	   !(mount_flags & EXT2_MF_READONLY)) {
> +		fprintf(stderr, "\nWarning: Running e2image on a mounted "
> +				"RW filesystem can result in an inconsistent "
> +				"image which will not be useful for "
> +				"debugging purposes.\n");
> +		if (img_type && !ignore_rw_mount) {
> +			fprintf(stderr, "Use -f option if you really want to "
> +					"do that.\n");
> +			exit(1);
> +		}
> +	}
> +
>  	if (flags & E2IMAGE_INSTALL_FLAG) {
>  		install_image(device_name, image_fn, img_type);
>  		exit (0);
> 

