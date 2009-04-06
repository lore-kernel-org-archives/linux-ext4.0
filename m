From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] [PATCH] ext4: Add inode to the orphan list during
	block allocation failure
Date: Mon, 6 Apr 2009 12:05:09 +0200
Message-ID: <20090406100509.GB31189@duck.suse.cz>
References: <20090331044544.GB5979@skywalker> <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090405031116.GG7553@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbZDFKFR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 06:05:17 -0400
Content-Disposition: inline
In-Reply-To: <20090405031116.GG7553@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Sat 04-04-09 23:11:16, Theodore Tso wrote:
> On Tue, Mar 31, 2009 at 02:59:25PM +0530, Aneesh Kumar K.V wrote:
> > We should add inode to the orphan list in the same transaction
> > as block allocation. This ensures that if we crash after a failed
> > block allocation and before we do a vmtruncate we don't leak block
> > (ie block marked as used in bitmap but not claimed by the inode).
> 
> How likely is this going to happen?  If it's a failure in the block
> allocation, we will have really end up with blocks outside i_size?
> And in that case, I'm missing how this ends up being a leaked block,
> since presumably the block is still being referenced by the inode.  Am
> I missing something here?
  Aneesh's changelog was not completely precise here. First note that some
problems (namely those in ext4_write_begin()) can happen only if blocksize
< pagesize - there we can succeed in allocating some blocks for the page
but not all of them. Since we then decide to redo the whole write, we have
to truncate blocks we have already allocated.
  The problem in ext4_..._write_end() is different (and rather easy to hit
under heavy memory pressure) - the problem is that generic_perform_write()
fails to copy data into our kernel page because the user page from which
we should copy the data has been paged-out. In this situation we again
decide to redo the write and so we should truncate the already allocated
blocks since i_size is still set to the value before write. Otherwise
we'd have blocks allocated beyond i_size and so a crash before we
successfully redo the write would "leak" blocks (you're right the inode
would be still referencing them but they'll be above i_size and I guess
it could confuse some code).

> I guess it can happen if do_journal_get_write_access() returns an
> error, which could potentially happen if there is a ENOMEM error
> coming from the jbd2 layer.  But that brings up another potential
> problem.  It's possible for vmtruncate() to fail; if ext4_truncate()
> fails too early (particularly in ext4_ext_truncate, due to a memory
> error in a jbd2 routines), it's possible for it to return without
> calling ext4_orphan_del() --- and stray inodes on the orphan list will
> cause the kernel to panic on umount.
> 
> I think this can be fixed by making sure that ext4_truncate() and
> ext4_ext_truncate() calls ext4_orphan_del() in *all* of their error
> paths.  That *should* the problem, since at the moment, it doesn't
> look vmtruncate() will return without calling inode->i_op->truncate().
> But could you double check this carefully?
  Ah, OK, that should be fixed. But note that current ext4_setattr()
does exactly the same thing on standard truncates - it adds inode to
orphan list and calls inode_setattr() which end's up calling vmtruncate().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
