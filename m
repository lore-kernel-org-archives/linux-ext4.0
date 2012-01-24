From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: Move ilock before transaction start in
 xfs_setattr_size()
Date: Tue, 24 Jan 2012 17:59:45 +1100
Message-ID: <20120124065945.GL15102@dastard>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
 <1327091686-23177-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Ben Myers <bpm@sgi.com>,
	Alex Elder <elder@kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20032 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab2AXG7t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jan 2012 01:59:49 -0500
Content-Disposition: inline
In-Reply-To: <1327091686-23177-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 20, 2012 at 09:34:42PM +0100, Jan Kara wrote:
> In xfs we first take ilock and start transaction afterwards.

The correct order is to allocate the transaction, reserve the space
for it and then take the ilock.  We cannot hold the ilock over the
transaction reservation because that can deadlock the journal.

That is, to make space for the new transaction reservation, we may
need to take the ilock to flush the inode and allow the journal tail
to move forwards to make space for the new transaction.  If we
already hold the ilock, then it can't be flushed, we can't make
space available in the journal and hence deadlock.

Maybe you confused the ilock vs the iolock.  We can hold the iolock
over the trans alloc/reserve because that lock is not required to
move the tail of the journal, so the deadlock doesn't exist.

> We should obey
> this order in all places because otherwise we can create the following deadlock
> with filesystem freezing: One process holds ilock and blocks on s_frozen ==
> SB_FREEZE_TRANS in xfs_trans_alloc(), another process has a transaction started
> (thus blocking freezing) and blocks on ilock. So we have to take ilock earlier
> in xfs_setattr_size().

Where are we taking the ilock and then calling xfs_trans_alloc()?
That's the caller needs to be fixed, not the 40-odd that do the
right thing by taking the ilock -after- the trans alloc/reserve
calls.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
