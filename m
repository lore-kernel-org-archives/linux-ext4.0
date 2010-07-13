From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext3
Date: Tue, 13 Jul 2010 17:55:33 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007131752130.3648@localhost>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <1278508727-29135-3-git-send-email-lczerner@redhat.com> <20100712152825.GB19433@atrey.karlin.mff.cuni.cz> <alpine.LFD.2.00.1007121735210.2733@localhost>
 <20100712195708.GH3356@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0GMPzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jul 2010 11:55:39 -0400
In-Reply-To: <20100712195708.GH3356@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 Jul 2010, Jan Kara wrote:

> On Mon 12-07-10 17:58:46, Lukas Czerner wrote:
> > On Mon, 12 Jul 2010, Jan Kara wrote:
> > 
> > > > Walk through each allocation group and trim all free extents. It can be
> > > > invoked through TRIM ioctl on the file system. The main idea is to
> > > > provide a way to trim the whole file system if needed, since some SSD's
> > > > may suffer from performance loss after the whole device was filled (it
> > > > does not mean that fs is full!).
> > > > 
> > > > It search for free extents in each allocation group. When the free
> > > > extent is found, blocks are marked as used and then trimmed. Afterwards
> > > > these blocks are marked as free in per-group bitmap.
> > > > 
> > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > ---
> > > >  fs/ext3/balloc.c        |  145 +++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/ext3/super.c         |    1 +
> > > >  include/linux/ext3_fs.h |    1 +
> > > >  3 files changed, 147 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > > > index a177122..bcee525 100644
> > > > --- a/fs/ext3/balloc.c
> > > > +++ b/fs/ext3/balloc.c
> > > ...
> > > > +		/**
> > > > +		 * Allocate contiguous free extents by setting bits in the
> > > > +		 * block bitmap
> > > > +		 */
> > > > +		while (next < max
> > > > +			&& !ext3_set_bit_atomic(sb_bgl_lock(sbi, group),
> > > > +					next, bh->b_data)) {
> > > > +			next++;
> > > > +		}
> > >   This is actually wrong. You completely ignore journalling here. You can't
> > > just go and modify metadata buffer - other process can be modifying it as well
> > > and writing it to disk and thus your changes will also get written. And if
> > > a crash happens afterwards before the bitmap is written again, you'll get an
> > > inconsistent filesystem.
> > >   Also you have to check whether the block isn't actually still used by a
> > > running/committing transaction - look at fs/ext3/balloc.c:claim_block() to see
> > > how you have to allocate free blocks.
> > 
> > I may be wrong, but I thought that since the trim command ensures that
> > every operation in queue completes before the trim proceed, I do not
> > need to care much about the journaling and running transaction. But I
> > will took at it once more..
>   Consider just a simple race:
> 
>   thread A:			thread B:
> 
>   allocate blocks in group G
>   				set bits for free blocks in group G
>   transaction with allocation
>     commits - bitmap has bits
>     from thread B set
> ----------------------------------------------- crash
>   After a journal replay we have just leaked blocks set in the bitmap
> by thread B...
>   And there are probably races with worse consequences. This is just the
> simplest one.
> 
> 								Honza
> 

Ok, I was terribly wrong! I am going to fix it, as well as ext4 patch.

Thanks for clarifying that!

-Lukas
