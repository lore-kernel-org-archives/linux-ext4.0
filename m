From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Fri, 22 Jun 2007 20:36:47 -0400
Message-ID: <20070623003646.GD22889@thunk.org>
References: <1182331988.9772.7.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59383 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbXFWAgv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 20:36:51 -0400
Content-Disposition: inline
In-Reply-To: <1182331988.9772.7.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 20, 2007 at 03:03:08PM +0530, Kalpak Shah wrote:
> In ext2fs_swap_inode_full() only the first (GOOD_OLD_INODE_SIZE +
> i_extra_isize)bytes are copied into inode. The rest of the inode is
> not zeroed. So memset the inode to zero if swapfs is enabled. 

This was due to the bug where we weren't dealing with the i_extra_size
correctly, right?  ext2fs_swap_inode_full *should* be swapping the
extra fields and copying it into the inode.  If not, that's should be
the real bug, and adding the memset(inode, 0, bufset) doesn't seem to
be useful.

Am I missing something?

						- Ted
