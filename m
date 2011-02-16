From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] e2fsprogs: turn off enforced fsck intervals by
 default
Date: Wed, 16 Feb 2011 19:24:51 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102161920590.3156@dhcp-27-109.brq.redhat.com>
References: <4D5C1380.2020602@redhat.com> <4D5C1409.1030203@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab1BPSYx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 13:24:53 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GIOr9K012216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 13:24:53 -0500
In-Reply-To: <4D5C1409.1030203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Feb 2011, Eric Sandeen wrote:

> The forced fsck often comes at unexpected and inopportune moments,
> and even enterprise customers are often caught by surprise when 
> this happens.  Because a filesystem with an error condition will 
> be marked as requiring fsck anyway, I submit that the time-based 
> and mount-based checks are not particularly useful, and that 
> administrators can schedule fscks on their own time, or tune2fs 
> the enforced intervals if they so choose.  Patch #1 disables the 
> intervals by default, and I've added a new mkfs option (-C) to 
> turn on the old behavior of random, unexpected, time-consuming
> fscks at boot time.  ;)

I completely agree with you and I like the idea.

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index a204eb7..37584aa 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -184,6 +184,7 @@ typedef struct ext2_file *ext2_file_t;
>  #define EXT2_FLAG_64BITS		0x20000
>  #define EXT2_FLAG_PRINT_PROGRESS	0x40000
>  #define EXT2_FLAG_DIRECT_IO		0x80000
> +#define EXT2_FLAG_MOUNT_FSCK_CHECK	0x100000
>  
>  /*
>   * Special flag in the ext2 inode i_flag field that means that this is
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 7c38975..ff63a92 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -155,7 +155,6 @@ errcode_t ext2fs_initialize(const char *name, int flags,
>  	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
>  	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
>  	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
> -	set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
>  	set_field(s_errors, EXT2_ERRORS_DEFAULT);
>  	set_field(s_feature_compat, 0);
>  	set_field(s_feature_incompat, 0);
> @@ -189,7 +188,10 @@ errcode_t ext2fs_initialize(const char *name, int flags,
>  		super->s_inode_size = EXT2_GOOD_OLD_INODE_SIZE;
>  	}
>  
> -	set_field(s_checkinterval, EXT2_DFL_CHECKINTERVAL);
> +	if (flags & EXT2_FLAG_MOUNT_FSCK_CHECK) {
> +		set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
> +		set_field(s_checkinterval, EXT2_DFL_CHECKINTERVAL);
> +	}
>  	super->s_mkfs_time = super->s_lastcheck = fs->now ? fs->now : time(NULL);
>  
>  	super->s_creator_os = CREATOR_OS;
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 2eead17..758307f 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -18,6 +18,9 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
>  .I block-size
>  ]
>  [
> +.B \-C
> +]
> +[
>  .B \-f
>  .I fragment-size
>  ]
> @@ -184,6 +187,10 @@ Check the device for bad blocks before creating the file system.  If
>  this option is specified twice, then a slower read-write
>  test is used instead of a fast read-only test.
>  .TP
> +.B \-C
> +Set maximum mount count and interval between checks, so that a full fsck
> +will be enforced when these counts are exceeded.
> +.TP
>  .BI \-E " extended-options"
>  Set extended options for the filesystem.  Extended options are comma
>  separated, and may take an argument using the equals ('=') sign.  The
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 0ba4a4c..fdeafe3 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -80,6 +80,7 @@ const char * device_name /* = NULL */;
>  
>  /* Command line options */
>  int	cflag;
> +int	Cflag;

Uff, this is not really an issue, however would it be possible to have
better name for Cflags :) ? it is just confusing.

>  int	verbose;
>  int	quiet;
>  int	super_only;
> @@ -1228,7 +1229,7 @@ profile_error:
>  	}
>  
>  	while ((c = getopt (argc, argv,
> -		    "b:cf:g:G:i:jl:m:no:qr:s:t:vE:FI:J:KL:M:N:O:R:ST:U:V")) != EOF) {
> +		    "b:cf:g:G:i:jl:m:no:qr:s:t:vCE:FI:J:KL:M:N:O:R:ST:U:V")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			blocksize = strtol(optarg, &tmp, 0);
> @@ -1251,6 +1252,9 @@ profile_error:
>  		case 'c':	/* Check for bad blocks */
>  			cflag++;
>  			break;
> +		case 'C':	/* Set default check/fsck intervals */
> +			Cflag++;
> +			break;
>  		case 'f':
>  			size = strtoul(optarg, &tmp, 0);
>  			if (size < EXT2_MIN_BLOCK_SIZE ||
> @@ -2030,6 +2034,8 @@ int main (int argc, char *argv[])
>  	 */
>  	if (!quiet)
>  		flags |= EXT2_FLAG_PRINT_PROGRESS;
> +	if (Cflag)
> +		flags |= EXT2_FLAG_MOUNT_FSCK_CHECK;
>  	retval = ext2fs_initialize(device_name, flags, &fs_param, io_ptr, &fs);
>  	if (retval) {
>  		com_err(device_name, retval, _("while setting up superblock"));
> @@ -2109,9 +2115,11 @@ int main (int argc, char *argv[])
>  	 * don't check all the filesystems at the same time.  We use a
>  	 * kludgy hack of using the UUID to derive a random jitter value.
>  	 */
> -	for (i = 0, val = 0 ; i < sizeof(fs->super->s_uuid); i++)
> -		val += fs->super->s_uuid[i];
> -	fs->super->s_max_mnt_count += val % EXT2_DFL_MAX_MNT_COUNT;
> +	if (Cflag) {
> +		for (i = 0, val = 0 ; i < sizeof(fs->super->s_uuid); i++)
> +			val += fs->super->s_uuid[i];
> +		fs->super->s_max_mnt_count += val % EXT2_DFL_MAX_MNT_COUNT;
> +	}
>  
>  	/*
>  	 * Override the creator OS, if applicable
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
