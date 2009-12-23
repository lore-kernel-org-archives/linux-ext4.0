From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: flush delalloc blocks when space is low
Date: Wed, 23 Dec 2009 08:01:20 -0500
Message-ID: <20091223130120.GG21594@thunk.org>
References: <4B22D098.3080600@redhat.com>
 <20091216204602.GC28425@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49945 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbZLWNB0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 08:01:26 -0500
Content-Disposition: inline
In-Reply-To: <20091216204602.GC28425@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 16, 2009 at 09:46:02PM +0100, Jan Kara wrote:
> > Creating many small files in rapid succession on a small
> > filesystem can lead to spurious ENOSPC; on a 104MB filesystem:
> > 
> > for i in `seq 1 22500`; do
> >     echo -n > $SCRATCH_MNT/$i
> >     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
> > done
> > 
> > leads to ENOSPC even though after a sync, 40% of the fs is free
> > again.
> > 
> > This is because we reserve worst-case metadata for delalloc writes,
> > and when data is allocated that worst-case reservation is not
> > usually needed.
> > 
> > When freespace is low, kicking off an async writeback will start
> > converting that worst-case space usage into something more realistic,
> > almost always freeing up space to continue.
> > 
> > This resolves the testcase for me, and survives all 4 generic
> > ENOSPC tests in xfstests.
> > 
> > We'll still need a hard synchronous sync to squeeze out the last bit,
> > but this fixes things up to a large degree.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the ext4 patch queue.

						- Ted
