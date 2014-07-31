From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/4 v3] tune2fs: update journal super block when changing
 UUID for fs.
Date: Thu, 31 Jul 2014 10:16:44 -0500
Message-ID: <53DA5DDC.1020703@redhat.com>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com> <1406533405-6899-4-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, darrick.wong@oracle.com, adilger@dilger.ca
To: Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbaGaPQu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 11:16:50 -0400
In-Reply-To: <1406533405-6899-4-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/28/14, 2:43 AM, Azat Khuzhin wrote:
> Using -U option you can change the UUID for fs, however it will not work
> for journal device, since it have a copy of this UUID inside jsb (i.e.
> journal super block). So copy UUID on change into that block.
> 
> Here is the initial thread:
> http://comments.gmane.org/gmane.comp.file-systems.ext4/44532
> 
> You can reproduce this by executing following commands:
> $ fallocate -l100M /tmp/dev
> $ fallocate -l100M /tmp/journal
> $ sudo /sbin/losetup /dev/loop1 /tmp/dev
> $ sudo /sbin/losetup /dev/loop0 /tmp/journal
> $ mke2fs -O journal_dev /tmp/journal
> $ tune2fs -U da1f2ed0-60f6-aaaa-92fd-738701418523 /tmp/journal
> $ sudo mke2fs -t ext4 -J device=/dev/loop0 /dev/loop1
> $ dumpe2fs -h /tmp/dev | fgrep UUID
> dumpe2fs 1.43-WIP (18-May-2014)
> Filesystem UUID:          8a776be9-12eb-411f-8e88-b873575ecfb6
> Journal UUID:             e3d02151-e776-4865-af25-aecb7291e8e5
> $ sudo e2fsck /dev/vdc
> e2fsck 1.43-WIP (18-May-2014)
> External journal does not support this filesystem
> 
> /dev/loop1: ********** WARNING: Filesystem still has errors **********
> 
> Reported-by: Chin Tzung Cheng <chintzung@gmail.com>
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> ---
>  misc/tune2fs.c | 74 ++++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 56 insertions(+), 18 deletions(-)
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 1df655a..74e57ae 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -175,6 +175,38 @@ static __u32 clear_ok_features[3] = {
>  		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
>  };
>  
> +/**
> + * Try to get journal super block if any
> + */
> +static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
> +{
> +	int retval;
> +	int start;
> +	journal_superblock_t *jsb;
> +
> +	if (!(jfs->super->s_feature_incompat &
> +	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
> +		return EXT2_ET_UNSUPP_FEATURE;
> +	}
> +
> +	/* Get the journal superblock */
> +	if ((retval = io_channel_read_blk64(jfs->io,
> +	    ext2fs_journal_sb_start(jfs->blocksize), -SUPERBLOCK_SIZE, buf))) {
> +		com_err(program_name, retval, "%s",
> +		_("while reading journal superblock"));
> +		return retval;
> +	}
> +
> +	jsb = (journal_superblock_t *) buf;
> +	if ((jsb->s_header.h_magic != (unsigned)ntohl(JFS_MAGIC_NUMBER)) ||
> +	    (jsb->s_header.h_blocktype != (unsigned)ntohl(JFS_SUPERBLOCK_V2))) {
> +		fputs(_("Journal superblock not found!\n"), stderr);
> +		return EXT2_ET_BAD_MAGIC;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Remove an external journal from the filesystem
>   */
> @@ -218,29 +250,15 @@ static int remove_journal_device(ext2_filsys fs)
>  			_("while trying to open external journal"));
>  		goto no_valid_journal;
>  	}
> -	if (!(jfs->super->s_feature_incompat &
> -	      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
> -		fprintf(stderr, _("%s is not a journal device.\n"),
> -			journal_path);
> -		goto no_valid_journal;
> -	}
>  
> -	start = ext2fs_journal_sb_start(fs->blocksize);

This is already committed (which is why Coverity whined about it), but:
removing this assignment causes an uninitialized use of "start" later
in this function:

        /* Write back the journal superblock */
        if ((retval = io_channel_write_blk64(jfs->io, start,
            -SUPERBLOCK_SIZE, buf)))

-Eric

