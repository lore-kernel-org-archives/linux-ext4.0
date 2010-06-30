From: tytso@mit.edu
Subject: Re: lifetime_write_kbytes isn't preserved during unclean shutdown
Date: Wed, 30 Jun 2010 09:31:08 -0400
Message-ID: <20100630133108.GD1333@thunk.org>
References: <4C2782A7.7040301@gmail.com>
 <20100628195739.GB6094@thunk.org>
 <519E1F03-CD95-41F4-B2EE-93983A4CC08A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nebojsa Trpkovic <trx.lists@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33206 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0F3NbM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 09:31:12 -0400
Content-Disposition: inline
In-Reply-To: <519E1F03-CD95-41F4-B2EE-93983A4CC08A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 29, 2010 at 11:46:57PM -0600, Andreas Dilger wrote:
> On 2010-06-28, at 13:57, tytso@mit.edu wrote:
> > On Sun, Jun 27, 2010 at 06:56:07PM +0200, Nebojsa Trpkovic wrote:
> >> I've noticed that lifetime_write_kbytes isn't preserved during unclean
> >> shutdown.
> > 
> > Yes, right now we are only updating the superblock's lifetime write
> > kbytes at unmount time.  It should be possible to do a better job; but
> > I don't want to increase writes to the disk just to keep the
> > s_lifetime value up-to-date.  So what we should probably do is update
> > it when we are going to be updating the superblock anyway (i.e., when
> > we update the orphaned inode linked list)
> 
> Could we also update the superblock blocks/inodes free counters at
> that time as well?

Remind me again why you wanted it.  You had some use case where you
wanted to be able to read the file system's block device directly and
have vaguely correct free inode/block numbers in the superblock?

> I don't think that is the right thing to do, unless the filesystem
> is still active for other reasons.  We don't necessarily want to
> spin up the disks every hour if the filesystem is inactive, I'd
> rather write out the superblock for an existing transaction while it
> is still active than generate a new transaction for no particular
> reason.
> 
> One way to do this would be to have a JBD transaction pre-commit
> callback, and if the superblock has not been written in N seconds
> then it can be added as part of that transaction (if it will fit).
> If it is already in the transaction it can be updated via the
> existing bh callbacks that OCFS2 is using.

That seems reasonable way of doing things.  I think N seconds should
be in the region of every 5-60 minutes, though.  And yes, absolutely
we wouldn't want to spin up the disk if there was no other activity.

   	    	    	    	- Ted
