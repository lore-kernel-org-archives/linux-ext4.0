From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/11][take 2] add new mkfs option to create ext4
 filesystems
Date: Mon, 25 Jun 2007 20:24:18 +0530
Message-ID: <467FD71A.7030003@linux.vnet.ibm.com>
References: <467A936F.7030502@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:64351 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbXFYOzJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2007 10:55:09 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5PEu83s6041764
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2007 00:56:08 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PEwF44212366
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2007 00:58:16 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PEshW6003491
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2007 00:54:43 +1000
In-Reply-To: <467A936F.7030502@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Valerie Clement wrote:
> This patch adds a new option '-D' to mkfs to allow creating ext4 
> filesystem.
> 
>  lib/ext2fs/ext2_fs.h    |    7 +++++++
>  lib/ext2fs/initialize.c |    1 +
>  misc/mke2fs.c           |   18 ++++++++++++++++--
>  3 files changed, 24 insertions(+), 2 deletions(-)
> 
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> Index: e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c
> ===================================================================
> --- e2fsprogs-1.39-tyt3-v7.orig/misc/mke2fs.c	2007-04-30 07:10:05.000000000 +0200
> +++ e2fsprogs-1.39-tyt3-v7/misc/mke2fs.c	2007-06-14 12:03:48.000000000 +0200
> @@ -96,7 +96,7 @@ static void usage(void)
>  {
>  	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
>  	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
> -	"[-j] [-J journal-options]\n"
> +	"[-D descriptor-size] [-j] [-J journal-options]\n"
>  	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
>  	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
>  	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
> @@ -899,6 +899,7 @@ static void PRS(int argc, char *argv[])
>  	int		blocksize = 0;
>  	int		inode_ratio = 0;
>  	int		inode_size = 0;
> +	int		desc_size = 0;
>  	double		reserved_ratio = 5.0;
>  	int		sector_size = 0;
>  	int		show_version_only = 0;
> @@ -977,7 +978,7 @@ static void PRS(int argc, char *argv[])
>  	}
> 
>  	while ((c = getopt (argc, argv,
> -		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
> +		    "b:cf:g:i:jl:m:no:qr:s:tvD:E:FI:J:L:M:N:O:R:ST:V")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			blocksize = strtol(optarg, &tmp, 0);
> @@ -1094,6 +1095,14 @@ static void PRS(int argc, char *argv[])
>  				exit(1);
>  			}
>  			break;
> +		case 'D':
> +			desc_size = strtoul(optarg, &tmp, 0);
> +			if (*tmp) {
> +				com_err(program_name, 0,
> +					_("invalid descriptor size - %s"), optarg);
> +				exit(1);
> +			}
> +			break;
>  		case 'v':
>  			verbose = 1;
>  			break;
> @@ -1422,6 +1431,11 @@ static void PRS(int argc, char *argv[])
>  		}
>  	}
> 
> +	if (desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
> +		fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
> +		fs_param.s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
> +	}
> +
>  	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
>

Why would one need variable descriptor size. Right now we have only two descriptor sizes right (32 and 64 ).  Can't we figure out
the descriptor size we should use by looking at the partition size ? What is that i am missing ?. 

-aneesh
