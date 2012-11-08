From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Automatic setting of {INODE,BLOCK}_UNINIT flags
Date: Thu, 8 Nov 2012 12:48:59 -0500
Message-ID: <20121108174859.GE19977@thunk.org>
References: <1351149943-4827-1-git-send-email-tracek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Tomas Racek <tracek@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60103 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab2KHWVC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:02 -0500
Content-Disposition: inline
In-Reply-To: <1351149943-4827-1-git-send-email-tracek@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 25, 2012 at 09:25:43AM +0200, Tomas Racek wrote:
> When last inode from bg is freed, set the INODE_UNINIT flag, similarly
> when last block is freed, set BLOCK_UNINIT flag. This can speed up
> subsequent fsck run.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

Could you make the following enhancements to your patch?

1)  Only do this if ext4_has_group_desc_csum(sb) is true

2)  Check to make sure the inode bitmap has only one bit set (the inode
    to be freed).  Basically, I don't want to set the BLOCK/INODE_UNINIT
    based just on the block group descriptor count, in case it got corrupted
     --- what, me paranoid?

    If there is other inodes set, then we need to call ext4_error()
    since we know the file system has gotten corrupted.

3)  If we can set BLOCK/INODE_UNINIT, we can skip modifying the bitmap
    block (since we won't consult the bitmap block if uninit is set).
    So that means we can skip calling get_write_access(), modifying
    the bitmap, updating the checksum, and then calling
    handle_dirty_metadata.  In fact, we can call ext4_forget(), so we
    can drop it from the buffer cache, and if it had been modified during
    the current transaction --- as part of an rm -rf, for example ---
    we don't need to include the bitmap block in the transaction.

(2) makes this patch much safer, and (3) should more than make up for
the overhead of scanning the the bitmap.

Thanks!!!

						- Ted

P.S.  Although the block bitmap is metadata, you can pass 0 for
is_metadata, since we don't need to revoke the block --- that's only
needed for extent tree blocks, indirect blocks, or directory blocks,
which could potentially get reused as a data block.  This isn't an
issue for the bitmap blocks, so we don't need to include a revoke
record in the journal.

