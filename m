From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] [PATCH] ext4: Add inode to the orphan list during
	block allocation failure
Date: Sat, 4 Apr 2009 23:11:16 -0400
Message-ID: <20090405031116.GG7553@mit.edu>
References: <20090331044544.GB5979@skywalker> <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54145 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817AbZDEEJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Apr 2009 00:09:40 -0400
Content-Disposition: inline
In-Reply-To: <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 31, 2009 at 02:59:25PM +0530, Aneesh Kumar K.V wrote:
> We should add inode to the orphan list in the same transaction
> as block allocation. This ensures that if we crash after a failed
> block allocation and before we do a vmtruncate we don't leak block
> (ie block marked as used in bitmap but not claimed by the inode).

How likely is this going to happen?  If it's a failure in the block
allocation, we will have really end up with blocks outside i_size?
And in that case, I'm missing how this ends up being a leaked block,
since presumably the block is still being referenced by the inode.  Am
I missing something here?

I guess it can happen if do_journal_get_write_access() returns an
error, which could potentially happen if there is a ENOMEM error
coming from the jbd2 layer.  But that brings up another potential
problem.  It's possible for vmtruncate() to fail; if ext4_truncate()
fails too early (particularly in ext4_ext_truncate, due to a memory
error in a jbd2 routines), it's possible for it to return without
calling ext4_orphan_del() --- and stray inodes on the orphan list will
cause the kernel to panic on umount.

I think this can be fixed by making sure that ext4_truncate() and
ext4_ext_truncate() calls ext4_orphan_del() in *all* of their error
paths.  That *should* the problem, since at the moment, it doesn't
look vmtruncate() will return without calling inode->i_op->truncate().
But could you double check this carefully?

Thanks,

						- Ted
