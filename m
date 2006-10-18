From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH/RFC] - make ext3 more robust in the face of filesystem corruption
Date: Wed, 18 Oct 2006 15:40:22 -0600
Message-ID: <20061018214022.GJ3509@schatzie.adilger.int>
References: <45369869.60400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:30854 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1423004AbWJRVk0
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 17:40:26 -0400
To: Eric Sandeen <sandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <45369869.60400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 18, 2006  16:11 -0500, Eric Sandeen wrote:
> First, we had a corrupted index directory that was never checked
> for consistency... it was corrupt, and pointed to another "entry"
> of length 0.  The for() loop looped forever, since the length
> of ext3_next_entry(de) was 0, and we kept looking at the same
> pointer over and over and over and over... I modeled this check
> and subsequent action on what is done for non-index directories
> in ext3_readdir... but I also see a few places where this check
> is deemed "too expensive" - any thoughts?

Hmm, in 2.6 ext2 this is handled somewhat differently - one of the main
places where ext2 and ext3 differ.  The directory leaf data is kept in
the page cache and there is a helper function ext2_check_page() to mark
the page "checked".  That means the page only needs to be checked once
after being read from disk, instead of each time through readdir.

That said, making ext3 run in that manner is major surgery, unlike your
fix.  I've seen such errors in production so it is worthwhile to fix this.
It might be possible to have a helper function similar to ext3_bread()
when reading directory leaf blocks that checks only if !buffer_uptodate()?

> Index: linux-2.6.18/fs/ext3/namei.c
> ===================================================================
> --- linux-2.6.18.orig/fs/ext3/namei.c
> +++ linux-2.6.18/fs/ext3/namei.c
> @@ -551,6 +551,15 @@ static int htree_dirblock_to_tree(struct
>  					   dir->i_sb->s_blocksize -
>  					   EXT3_DIR_REC_LEN(0));
>  	for (; de < top; de = ext3_next_entry(de)) {
> +		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
> +					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
> +						+((char *)de - bh->b_data))) {
> +			/* On error, skip the f_pos to the next block. */
> +			dir_file->f_pos = (dir_file->f_pos | 
> +					(dir_file->i_sb->s_blocksize - 1)) + 1;
> +			brelse (bh);
> +			return count;
> +		}
>  		ext3fs_dirhash(de->name, de->name_len, hinfo);
>  		if ((hinfo->hash < start_hash) ||
>  		    ((hinfo->hash == start_hash) &&
> 
> Next we had a root directory inode which had a corrupted size, claimed
> to be > 200M on a 4M filesystem.  ext3_get_blocks_handle() was returning 0,
> meaning that lookup failed.  (there was only really 1 block in the directory, 
> but because the size was so large, readdir kept coming back for more...)
>
> instead of catching the no-block-at-this-offset error, we fell into the
> !bh case, which assumed that there had been an IO error, and kept on trying
> 200M+ of blocks that didn't exist.  I -think- it makes more sense to realize
> that if ext3_get_blocks_handle returns 0, there is a hole at this location,
> (as described by the on-disk metadata) and something has gone wrong.
> 
> Index: linux-2.6.18/fs/ext3/dir.c
> ===================================================================
> --- linux-2.6.18.orig/fs/ext3/dir.c
> +++ linux-2.6.18/fs/ext3/dir.c
> @@ -141,6 +141,11 @@ static int ext3_readdir(struct file * fi
>  					(PAGE_CACHE_SHIFT - inode->i_blkbits),
>  				1);
>  			bh = ext3_bread(NULL, inode, blk, 0, &err);
> +		} else {
> +			ext3_error(sb, "ext3_readdir",
> +			 "directory #%lu block %lu lookup failed, corrupt dir",
> +			 	inode->i_ino, blk);
> +                        return -EINVAL;
>  		}
>  
>  		/*
> 
> I'm not so sure about this one, though - seems like maybe also it should test
> for an actual error case (< 0) from ext3_get_blocks_handle as well.

I'm not sure whether this is a win or not.  It means that if there is ever
a directory with a bad leaf block any entries beyond that block are not
accessible anymore.  The existing !bh case already marks the filesystem in
error.  Maybe as a special case we can check in "if (!bh)" if i_size and
i_blocks make sense.  Something like:

		if (!bh) {
			:
			:
+			if (filp->f_pos > inode->i_blocks << 9) {
+				break;
			filp->f_pos += sb->s_blocksize - offset;
			continue;
		}

This obviously won't help if the whole inode is bogus, but then nothing
will catch all errors.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
