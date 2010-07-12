From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Add batched discard support for ext3
Date: Mon, 12 Jul 2010 21:57:09 +0200
Message-ID: <20100712195708.GH3356@quack.suse.cz>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
 <1278508727-29135-3-git-send-email-lczerner@redhat.com>
 <20100712152825.GB19433@atrey.karlin.mff.cuni.cz>
 <alpine.LFD.2.00.1007121735210.2733@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab0GLT5c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 15:57:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007121735210.2733@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-07-10 17:58:46, Lukas Czerner wrote:
> On Mon, 12 Jul 2010, Jan Kara wrote:
> 
> > > Walk through each allocation group and trim all free extents. It can be
> > > invoked through TRIM ioctl on the file system. The main idea is to
> > > provide a way to trim the whole file system if needed, since some SSD's
> > > may suffer from performance loss after the whole device was filled (it
> > > does not mean that fs is full!).
> > > 
> > > It search for free extents in each allocation group. When the free
> > > extent is found, blocks are marked as used and then trimmed. Afterwards
> > > these blocks are marked as free in per-group bitmap.
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > ---
> > >  fs/ext3/balloc.c        |  145 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/ext3/super.c         |    1 +
> > >  include/linux/ext3_fs.h |    1 +
> > >  3 files changed, 147 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > > index a177122..bcee525 100644
> > > --- a/fs/ext3/balloc.c
> > > +++ b/fs/ext3/balloc.c
> > ...
> > > +		/**
> > > +		 * Allocate contiguous free extents by setting bits in the
> > > +		 * block bitmap
> > > +		 */
> > > +		while (next < max
> > > +			&& !ext3_set_bit_atomic(sb_bgl_lock(sbi, group),
> > > +					next, bh->b_data)) {
> > > +			next++;
> > > +		}
> >   This is actually wrong. You completely ignore journalling here. You can't
> > just go and modify metadata buffer - other process can be modifying it as well
> > and writing it to disk and thus your changes will also get written. And if
> > a crash happens afterwards before the bitmap is written again, you'll get an
> > inconsistent filesystem.
> >   Also you have to check whether the block isn't actually still used by a
> > running/committing transaction - look at fs/ext3/balloc.c:claim_block() to see
> > how you have to allocate free blocks.
> 
> I may be wrong, but I thought that since the trim command ensures that
> every operation in queue completes before the trim proceed, I do not
> need to care much about the journaling and running transaction. But I
> will took at it once more..
  Consider just a simple race:

  thread A:			thread B:

  allocate blocks in group G
  				set bits for free blocks in group G
  transaction with allocation
    commits - bitmap has bits
    from thread B set
----------------------------------------------- crash
  After a journal replay we have just leaked blocks set in the bitmap
by thread B...
  And there are probably races with worse consequences. This is just the
simplest one.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
