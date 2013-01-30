From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH, RFC V2] mke2fs: wipe out old btrfs superblocks
Date: Wed, 30 Jan 2013 10:50:14 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1301301036280.2669@dhcp-1-104.brq.redhat.com>
References: <510800B6.4090505@redhat.com> <51080299.9040507@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Karel Zak <kzak@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3A3Juf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 04:50:35 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0U9oTFJ022315
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2013 04:50:35 -0500
In-Reply-To: <51080299.9040507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 29 Jan 2013, Eric Sandeen wrote:

> Date: Tue, 29 Jan 2013 11:10:49 -0600
> From: Eric Sandeen <sandeen@redhat.com>
> To: ext4 development <linux-ext4@vger.kernel.org>
> Subject: [PATCH, RFC V2] mke2fs: wipe out old btrfs superblocks
> 
> btrfs sticks superblocks at 64k, 64M, and 256G.  If we don't
> overwrite those, libblkid may accidentally identify an ext*
> filesystem with old btrfs superblocks as btrfs, and we'll
> be sad.
> 
> libblkid provides a blkid_wipe_fs() functionality to zero
> all existing signatures, but that'd break our handy-dandy
> undo capability, I think.  So I'm not sure we have any
> other choice but to do it ourselves.
> 
> There is a slight error here in that if the mkfs
> does not span the entire device, we won't overwrite
> signatures past the end of the filesystem, but that case
> should be pretty rare.  (The same slight error in logic
> applies to the existing "wipe old MD superblock" path).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com
> Resolves-RHBZ: 902512
> ---

Hi Eric,

right we really need this functionality, but I think that we should
rather use blkid to wipe all the signatures.

Unfortunately as you already mentioned we have "undo" functionality
which makes things a little bit more complicated, because we can not
let blkid just wipe it for us. It should rather provide us the information
about the position of the signatures so we can wipe it of ourselves.

After the discussion with Karel Zak I think that the best approach
would be to blkid export blkid_probe_postwipe_reset() for us, so we
can walk the "chain" provided by blkid and do the actual wipe.

However it might be worth having this patch anyway since it solves
the situation right away without waiting for newer version of blkid
library.

btw. I have one comment bellow.

Thanks!
-Lukas

> 
> v2: skip this on "noaction"
> 
> I decided not to be tricky about previous zero-returning
> discards, there seems to be little point to that, we're
> just doing 3 IOs post discard, at worst.
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index bbf477a..0c67134 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2307,6 +2307,32 @@ static int mke2fs_discard_device(ext2_filsys fs)
>  	return retval;
>  }
>  
> +static int mke2fs_wipe_btrfs(ext2_filsys fs)
> +{
> +	int blocks;	/* nr of blocks to zero */
> +	blk64_t start;	/* location to zero out */
> +	int retval = 0; /* accumulate any failures */
> +
> +	blocks = 1;
> +	if (fs->blocksize < 4096)
> +		blocks = 4096 / fs->blocksize;
> +	/*
> +	 * Wipe out any old btrfs superblocks, at
> +	 * 64k, 64M, and 256G.
> +	 */
> +	start = 64ULL * 1024 / fs->blocksize;
> +	retval += ext2fs_zero_blocks2(fs, start, blocks, NULL, NULL);
> +	start = 64ULL * 1024 * 1024 / fs->blocksize;
> +	if (start + blocks <= ext2fs_blocks_count(fs->super))
> +		retval += ext2fs_zero_blocks2(fs, start, blocks, NULL, NULL);
> +	start = 256ULL * 1024 * 1024 * 1024 / fs->blocksize;
> +	if (start + blocks <= ext2fs_blocks_count(fs->super))
> +		retval += ext2fs_zero_blocks2(fs, start, blocks, NULL, NULL);
> +	/* free the static zeroing buffer */
> +	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
> +	return retval;
> +}
> +
>  static void fix_cluster_bg_counts(ext2_filsys fs)
>  {
>  	blk64_t	cluster, num_clusters, tot_free;
> @@ -2440,6 +2466,12 @@ int main (int argc, char *argv[])
>  		}
>  	}
>  
> +	if (!noaction) {
> +		retval = mke2fs_wipe_btrfs(fs);
> +		if (retval)
> +			printf(_("Failed to wipe old btrfs super locations\n"));
> +	}
> +

We might want to move the wipe after io_channel_set_options(). I am
not sure whether it will have any impact but since we'll be using
the io_channel I think it should be already set up.

>  	sprintf(tdb_string, "tdb_data_size=%d", fs->blocksize <= 4096 ?
>  		32768 : fs->blocksize * 8);
>  	io_channel_set_options(fs->io, tdb_string);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
