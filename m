From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext3
Date: Mon, 12 Jul 2010 17:58:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007121735210.2733@localhost>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <1278508727-29135-3-git-send-email-lczerner@redhat.com> <20100712152825.GB19433@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab0GLP6w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 11:58:52 -0400
In-Reply-To: <20100712152825.GB19433@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 Jul 2010, Jan Kara wrote:

> > Walk through each allocation group and trim all free extents. It can be
> > invoked through TRIM ioctl on the file system. The main idea is to
> > provide a way to trim the whole file system if needed, since some SSD's
> > may suffer from performance loss after the whole device was filled (it
> > does not mean that fs is full!).
> > 
> > It search for free extents in each allocation group. When the free
> > extent is found, blocks are marked as used and then trimmed. Afterwards
> > these blocks are marked as free in per-group bitmap.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext3/balloc.c        |  145 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ext3/super.c         |    1 +
> >  include/linux/ext3_fs.h |    1 +
> >  3 files changed, 147 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > index a177122..bcee525 100644
> > --- a/fs/ext3/balloc.c
> > +++ b/fs/ext3/balloc.c
> ...
> > +		/**
> > +		 * Allocate contiguous free extents by setting bits in the
> > +		 * block bitmap
> > +		 */
> > +		while (next < max
> > +			&& !ext3_set_bit_atomic(sb_bgl_lock(sbi, group),
> > +					next, bh->b_data)) {
> > +			next++;
> > +		}
>   This is actually wrong. You completely ignore journalling here. You can't
> just go and modify metadata buffer - other process can be modifying it as well
> and writing it to disk and thus your changes will also get written. And if
> a crash happens afterwards before the bitmap is written again, you'll get an
> inconsistent filesystem.
>   Also you have to check whether the block isn't actually still used by a
> running/committing transaction - look at fs/ext3/balloc.c:claim_block() to see
> how you have to allocate free blocks.

I may be wrong, but I thought that since the trim command ensures that
every operation in queue completes before the trim proceed, I do not
need to care much about the journaling and running transaction. But I
will took at it once more..

>   All-in-all won't it be good enough to just freeze the fs, do the trimming,
> and unfreeze it?
> 
> 									Honza
> 

Yes, it can be done that way. But it is king of rough solution.

Thank.
-Lukas
