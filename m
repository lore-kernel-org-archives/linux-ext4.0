From: tytso@mit.edu
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Fri, 12 Feb 2010 15:07:26 -0500
Message-ID: <20100212200726.GD5337@thunk.org>
References: <loom.20100204T064311-880@post.gmane.org>
 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
 <20100209174145.GU4494@thunk.org>
 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
 <20100211195624.GM739@thunk.org>
 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Jiaying Zhang <jiayingz@google.com>
To: Kailas Joshi <kailas.joshi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54233 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088Ab0BLUH3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Feb 2010 15:07:29 -0500
Content-Disposition: inline
In-Reply-To: <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 12, 2010 at 08:52:15AM +0530, Kailas Joshi wrote:
> Won't this get fixed by performing early reservations as mentioned in
> my scheme? We are reserving required credits in the path of write
> system call and these will be kept reserved until transaction commit.
> So, the journal space for allocation at commit will be guaranteed.

Yes, if you account for these separately.  One challenge is
over-estimating the needed credits will be tricky.  If we go down this
path, be sure that the bonnie style write(fd, &ch, 1) in a tight loop
doesn't end up reserving a separate set of credits for each write
system call to the same block.  (It can be done; if the DA block is
already instantiated, you can assume that credits have already been
reserved.)

> Sorry, I didn't understand why processes need to be suspended.
> In my scheme, I am issuing magic handle only after locking the current
> transaction.  AFAIK after the transaction is locked, it can receive the
> block journaling requests for already created handles(in our case, for
> already reserved journal space), and the new concurrent requests for
> journal_start() will go to the new current transaction. Since, the
> credits for locked transaction are fixed (by means of early
> reservations) we can know whether journal has enough space for the new
> journal_start(). So, as long as journal has enough space available,
> new processes need now be stalled.

But while you are modifying blocks that need to go into the journal
via the locked (old) transaction, it's not safe to start a new
transaction and start issuing handles against the new transaction.

Just to give one example, suppose we need to update the extent
allocation tree for an inode in the locked/committing transaction as
the delayed allocation blocks are being resolved --- and in another
process, that inode is getting truncated or unlinked, which also needs
to modify the extent allocation tree?  Hilarty ensues, unless you use
a block all attempts to create a new handle (practically speaking, by
blocking all attempts to start a new transaction), until this new
delayed allocation resolution phase which you have proposed is
complete.

							- Ted
