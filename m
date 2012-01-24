From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] xfs: Move ilock before transaction start in
 xfs_setattr_size()
Date: Tue, 24 Jan 2012 12:52:34 +0100
Message-ID: <20120124115234.GD15974@quack.suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
 <1327091686-23177-5-git-send-email-jack@suse.cz>
 <20120124065945.GL15102@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Ben Myers <bpm@sgi.com>,
	Alex Elder <elder@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab2AXLwg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jan 2012 06:52:36 -0500
Content-Disposition: inline
In-Reply-To: <20120124065945.GL15102@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-01-12 17:59:45, Dave Chinner wrote:
> On Fri, Jan 20, 2012 at 09:34:42PM +0100, Jan Kara wrote:
> > In xfs we first take ilock and start transaction afterwards.
> 
> The correct order is to allocate the transaction, reserve the space
> for it and then take the ilock.  We cannot hold the ilock over the
> transaction reservation because that can deadlock the journal.
>
> That is, to make space for the new transaction reservation, we may
> need to take the ilock to flush the inode and allow the journal tail
> to move forwards to make space for the new transaction.  If we
> already hold the ilock, then it can't be flushed, we can't make
> space available in the journal and hence deadlock.
  Thanks for clarification!

> Maybe you confused the ilock vs the iolock.  We can hold the iolock
> over the trans alloc/reserve because that lock is not required to
> move the tail of the journal, so the deadlock doesn't exist.
  Ups! I now had a look at what xfs_rw_ilock() does. I always thought it's
just a plain rw semaphore and now I see it takes several locks depending on
the argument. Ugh, a bit surprising for XFS newcomer as me ;) But now
things become clearer so I fix my patches with this new knowledge in mind.
So just disregard my locking comments. They were likely bogus.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
