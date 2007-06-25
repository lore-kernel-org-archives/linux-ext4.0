From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Mon, 25 Jun 2007 13:43:59 +0530
Message-ID: <1182759239.6016.8.camel@garfield>
References: <1182331988.9772.7.camel@garfield>
	 <20070623003646.GD22889@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:60581 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbXFYINc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2007 04:13:32 -0400
In-Reply-To: <20070623003646.GD22889@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-06-22 at 20:36 -0400, Theodore Tso wrote:
> On Wed, Jun 20, 2007 at 03:03:08PM +0530, Kalpak Shah wrote:
> > In ext2fs_swap_inode_full() only the first (GOOD_OLD_INODE_SIZE +
> > i_extra_isize)bytes are copied into inode. The rest of the inode is
> > not zeroed. So memset the inode to zero if swapfs is enabled. 
> 
> This was due to the bug where we weren't dealing with the i_extra_size
> correctly, right?  ext2fs_swap_inode_full *should* be swapping the
> extra fields and copying it into the inode.  If not, that's should be
> the real bug, and adding the memset(inode, 0, bufset) doesn't seem to
> be useful.
> 
> Am I missing something?

Hi Ted,

In e2fsck_pass1(), a buffer is allocated for the scratch inode,
inode = (struct ext2_inode *) e2fsck_allocate_memory(ctx, inode_size,   
						"scratch inode");

Now on big-endian systems, while swapping, ext2fs_swap_inode_full()
swaps only 128+extra_isize bytes and the EAs if they are present. Now if
inode N has EAs, (and this is the inode in the "scratch inode") then
inode N+1 also carries seems to have them since the "scratch inode" was
never zeroed. In ext2fs_swap_inode_full(), this occurs:

        if (ext2fs_swab32(*eaf) != EXT2_EXT_ATTR_MAGIC)
                return; /* it seems no magic here */

So as I said only the first 128+extra_isize bytes are actually copied
into the *to* inode.

Thanks,
Kalpak.

> 
> 						- Ted
