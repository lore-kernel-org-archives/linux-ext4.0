From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] mke2fs: wipe out old btrfs superblocks
Date: Tue, 29 Jan 2013 11:05:37 -0600
Message-ID: <51080161.7000903@redhat.com>
References: <510800B6.4090505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3A2RFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 12:05:39 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0TH5dKG026448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2013 12:05:39 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0TH5bMK026766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2013 12:05:38 -0500
In-Reply-To: <510800B6.4090505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/29/13 11:02 AM, Eric Sandeen wrote:
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

Sorry, sent the wrong version, this one does it unconditionally
and doesn't test !noaction.  I'll fix that & resend.

Feel free to comment on the general idea, though. :)

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com
> Resolves-RHBZ: 902512
> ---
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index bbf477a..e68c705 100644
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
> @@ -2439,6 +2465,9 @@ int main (int argc, char *argv[])
>  			itable_zeroed = 1;
>  		}
>  	}
> +		retval = mke2fs_wipe_btrfs(fs);
> +		if (retval)
> +			printf(_("Failed to wipe old btrfs super locations\n"));
>  
>  	sprintf(tdb_string, "tdb_data_size=%d", fs->blocksize <= 4096 ?
>  		32768 : fs->blocksize * 8);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

