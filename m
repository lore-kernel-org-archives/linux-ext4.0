From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 14/37] dumpe2fs: add switch to disable checksum
 verification
Date: Mon, 5 May 2014 19:20:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051919330.31228@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231354.31890.36717.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbaEERUj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 13:20:39 -0400
In-Reply-To: <20140501231354.31890.36717.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:13:54 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 14/37] dumpe2fs: add switch to disable checksum verification
> 
> Add a -n switch to turn off checksum verification.

Looks good. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>


> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/dumpe2fs.8.in |    3 +++
>  misc/dumpe2fs.c    |   10 +++++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
> index befaf94..51614db 100644
> --- a/misc/dumpe2fs.8.in
> +++ b/misc/dumpe2fs.8.in
> @@ -61,6 +61,9 @@ using
>  .I device
>  as the pathname to the image file.
>  .TP
> +.B \-n
> +Don't verify checksums when dumping the filesystem.
> +.TP
>  .B \-x
>  print the detailed group information block numbers in hexadecimal format
>  .TP
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index ae54f8a..3a3684b 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -52,7 +52,7 @@ static int blocks64 = 0;
>  
>  static void usage(void)
>  {
> -	fprintf (stderr, _("Usage: %s [-bfhixV] [-o superblock=<num>] "
> +	fprintf(stderr, _("Usage: %s [-bfhinxV] [-o superblock=<num>] "
>  		 "[-o blocksize=<num>] device\n"), program_name);
>  	exit (1);
>  }
> @@ -582,7 +582,9 @@ int main (int argc, char ** argv)
>  	if (argc && *argv)
>  		program_name = *argv;
>  
> -	while ((c = getopt (argc, argv, "bfhixVo:")) != EOF) {
> +	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES |
> +		EXT2_FLAG_64BITS;
> +	while ((c = getopt(argc, argv, "bfhixVo:n")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			print_badblocks++;
> @@ -608,6 +610,9 @@ int main (int argc, char ** argv)
>  		case 'x':
>  			hex_format++;
>  			break;
> +		case 'n':
> +			flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
> +			break;
>  		default:
>  			usage();
>  		}
> @@ -615,7 +620,6 @@ int main (int argc, char ** argv)
>  	if (optind > argc - 1)
>  		usage();
>  	device_name = argv[optind++];
> -	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
>  	if (force)
>  		flags |= EXT2_FLAG_FORCE;
>  	if (image_dump)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
