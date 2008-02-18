From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH][7/28] e2fsprogs-extents.patch
Date: Mon, 18 Feb 2008 11:56:53 -0600
Message-ID: <47B9C6E5.2010304@redhat.com>
References: <20080202075943.GB23836@webber.adilger.int> <20080202082559.GG31694@webber.adilger.int> <20080202082701.GH31694@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYBRR5Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 12:57:16 -0500
In-Reply-To: <20080202082701.GH31694@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> Support for checking 32-bit extents format inodes and the INCOMPAT_EXTENTS
> feature.
> 
> Clear the high 16 bits of extents and index entries, since the
> extents patches did not do this explicitly.  Some parts of this
> code need fixing for checking > 32-bit block filesystems (when
> INCOMPAT_64BIT support is added), marked "FIXME: 48-bit support".
> 
> Verify extent headers in blocks, logical ordering of extents,
> logical ordering of indexes.
> 
> Add explicit checking of {d,t,}indirect and index blocks to detect
> corruption instead of implicitly doing this by checking the referred
> blocks and only block-at-a-time correctness.  This avoids incorrectly
> invoking the very lengthy duplicate blocks pass for bad indirect/index
> blocks.  We may want to tune the "threshold" for how many errors make
> a "bad" indirect/index block.
> 
> Add ability to split or remove extents in order to allow extent
> reallocation during the duplicate blocks pass.
> 
...


> @@ -904,21 +910,75 @@ void e2fsck_pass1(e2fsck_t ctx)
>  			ctx->fs_sockets_count++;
>  		} else
>  			mark_inode_bad(ctx, ino);
> -		if (inode->i_block[EXT2_IND_BLOCK])
> -			ctx->fs_ind_count++;
> -		if (inode->i_block[EXT2_DIND_BLOCK])
> -			ctx->fs_dind_count++;
> -		if (inode->i_block[EXT2_TIND_BLOCK])
> -			ctx->fs_tind_count++;
> -		if (inode->i_block[EXT2_IND_BLOCK] ||
> -		    inode->i_block[EXT2_DIND_BLOCK] ||
> -		    inode->i_block[EXT2_TIND_BLOCK] ||
> -		    inode->i_file_acl) {
> -			inodes_to_process[process_inode_count].ino = ino;
> -			inodes_to_process[process_inode_count].inode = *inode;
> -			process_inode_count++;
> -		} else
> -			check_blocks(ctx, &pctx, block_buf);
> +
> +		eh = (struct ext3_extent_header *)inode->i_block;
> +		if ((inode->i_flags & EXT4_EXTENTS_FL)) {
> +			if ((LINUX_S_ISREG(inode->i_mode) ||
> +			     LINUX_S_ISDIR(inode->i_mode)) &&

So this trips up on things like sockets, fifos, and block & char nodes.

Also this is unhappy:

> @@ -137,7 +141,7 @@ int e2fsck_pass1_check_device_inode(ext2
>  	 * If the index flag is set, then this is a bogus
>  	 * device/fifo/socket
>  	 */
> -	if (inode->i_flags & EXT2_INDEX_FL)
> +	if (inode->i_flags & (EXT2_INDEX_FL | EXT4_EXTENTS_FL))
>  		return 0;

Do we really care if these have the extents flag set?  IOW should we
make sure the kernel doesn't set the flag, or should we make e2fsck not
care...

There are enough checks in e2fsck to show the intent was that these
files should not have the extents flag set, but I'm not sure why it
matters enough that the kernel needs to run around being sure to clear
it....

Or... (rambling on now) it seems odd to me that zero-length files have
the extents flag set at all; should we only set extents when we actually
get a block allocated to the file?  That would also take care of this
from the kernel side I think.

-Eric
