From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Always verify extent tree blocks
Date: Thu, 11 Aug 2011 15:33:38 -0600
Message-ID: <68C5518D-9B6A-4C63-A044-0248736708FB@dilger.ca>
References: <20110811211348.GK20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 List <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3185 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1HKVdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 17:33:39 -0400
In-Reply-To: <20110811211348.GK20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-11, at 3:13 PM, Darrick J. Wong wrote:
> It turns out that ext4_ext_check only verifies the validity of the extent block
> it's processing if the block has to be read in from the disk.  Unfortunately,
> this means that the check is NOT done if the block is already in memory, which
> means that if a file has a corrupted extent block, then the first IO peformed
> on the file will find the corrupt block and fail, but a second IO will see that
> the extent block is in memory, bypass the corruption check, and use garbage
> data as if they were extent data.

It looks like ext4_ext_check() is fairly heavyweight, so calling it on every
extent access may affect performance.  What about marking the extent or buffer
bad in some way so that it always gets checked?  In the ext2 directory code
it marks a directory page with PG_checked to indicate that it was validated
on read, but there could be a number of different mechanisms to do this
(including setting a bit in the magic so that ext4_ext_check() is aborted
very quickly, possibly without any additional error on the console since
one would already have been printed).

> A simple testcase is to allocate a file with enough extents to overflow the
> inode i_block, umount, overwrite the extent block magic with garbage, then
> mount the filesystem and try to access the file.  The first access causes the
> kernel to spit out an error, but subsequent accesses seem to succeed.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
> fs/ext4/extents.c |    6 +-----
> 1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ee4b391..bb07b79 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -744,8 +744,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
> 	i = depth;
> 	/* walk through the tree */
> 	while (i) {
> -		int need_to_validate = 0;
> -
> 		ext_debug("depth %d: num %d, max %d\n",
> 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
> 
> @@ -764,8 +762,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
> 				put_bh(bh);
> 				goto err;
> 			}
> -			/* validate the extent entries */
> -			need_to_validate = 1;
> 		}
> 		eh = ext_block_hdr(bh);
> 		ppos++;
> @@ -779,7 +775,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
> 		path[ppos].p_hdr = eh;
> 		i--;
> 
> -		if (need_to_validate && ext4_ext_check(inode, eh, i))
> +		if (ext4_ext_check(inode, eh, i))
> 			goto err;
> 	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





