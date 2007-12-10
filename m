From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH] 64 bit blocks support for e2fsprogs
Date: Mon, 10 Dec 2007 10:14:16 -0700
Message-ID: <20071210171416.GL3214@webber.adilger.int>
References: <20071207161445.GB27749@dhcp243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:57784 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXLJROT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2007 12:14:19 -0500
Content-Disposition: inline
In-Reply-To: <20071207161445.GB27749@dhcp243-37.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 07, 2007  11:14 -0500, Josef Bacik wrote:
> At this point I've only added the helper functions and converted mke2fs
> (sloppily for now) to use the helper functions.  I know we want to make this
> as painless as possible to go between ext2/3/4 so what I plan on doing is
> leave everything as it is and only allow large disks to be formatted if
> EXT4_FEATURE_INCOMPAT_64BIT is set.  Any feedback would be awesome, and if
> somebody is already working on this please let me know so I'm not duplicating
> work.  Thanks much,

> +_INLINE_ void ext2fs_blocks_count_set(struct ext2_super_block *super,
> +				      blk64_t blk)
> +{
> +	super->s_blocks_count = ext2fs_cpu_to_le32((__u32)blk);
> +	super->s_blocks_count_hi = ext2fs_cpu_to_le32(blk >> 32);
> +}

I'm undecided of whether there should be checking of whether INCOMPAT_64BIT
set in the superblock before using the s_blocks*_hi fields.  In one sense
these fields are only valid when the INCOMPAT_64BIT flag is set, but
there is also a concern that the 64BIT flag might be incorrectly unset...

Given that these are the ext2fs_* interfaces, and e2fsck should probably
be doing its own validation of the 64BIT flag, along with the size of the
physical device and the s_blocks*_hi fields I think the ext2fs_* functions
SHOULD check for INCOMPAT_64BIT being set before using the _hi fields.

> @@ -191,9 +192,9 @@ static void test_disk(ext2_filsys fs, badblocks_list *bb_list)
> -	sprintf(buf, "badblocks -b %d -X %s%s%s %u", fs->blocksize,
> +	sprintf(buf, "badblocks -b %d -X %s%s%s %lu", fs->blocksize,
>  		quiet ? "" : "-s ", (cflag > 1) ? "-w " : "",
> -		fs->device_name, fs->super->s_blocks_count-1);
> +		fs->device_name, ext2fs_blocks64_count(fs)-1);

"%lu" is not correct for a 64-bit field, which will be long long on 32-bit
systems.  Instead I'd suggest using %llu and casting the return of
ext2fs_blocks64_count() to (unsigned long long).

> -	retval = zero_blocks(fs, 0, fs->super->s_blocks_count,
> +	retval = zero_blocks(fs, 0, ext2fs_blocks64_count(fs),
>  			     &progress, &blk, &count);

Since zero_blocks() only takes a blk_t as a parameter I think this is
incorrect.  However, given it is a static internal function we can also
change the prototype to fix it.

> @@ -686,9 +690,10 @@ static void show_stats(ext2_filsys fs)
> +	if (ext2fs_blocks_count(fs_param.super) != ext2fs_blocks_count(s))
>  		fprintf(stderr, _("warning: %u blocks unused.\n\n"),
> -		       fs_param.s_blocks_count - s->s_blocks_count);
> +		       ext2fs_blocks_count(fs_param.super) - 
> +		       ext2fs_blocks_count(s));

Need to cast the difference to (unsigned).  The difference will never need
to be a 64-bit value, but the returned type will be blk64_t.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
