From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Mon, 2 Jul 2012 09:00:34 -0400
Message-ID: <20120702130034.GA785@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
 <20120619015745.GJ25389@dastard>
 <4FE1BDF3.4080702@shiftmail.org>
 <20120620225327.GL30705@dastard>
 <20120621174742.GA27837@redhat.com>
 <4FF06480.6030109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
	hch@infradead.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2GBNA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 09:00:58 -0400
Content-Disposition: inline
In-Reply-To: <4FF06480.6030109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 01 2012 at 10:53am -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 21/06/2012 19:47, Mike Snitzer ha scritto:
> > Paolo Bonzini fixed blkdev_issue_discard to properly align some time
> > ago; unfortunately the patches slipped through the cracks (cc'ing Paolo,
> > Jens, and Christoph).
> > 
> > Here are references to Paolo's patches:
> > 0/2 https://lkml.org/lkml/2012/3/14/323
> > 1/2 https://lkml.org/lkml/2012/3/14/324
> > 2/2 https://lkml.org/lkml/2012/3/14/325
> > 
> > Patch 2/2 specifically addresses the case where:
> >  discard_max_bytes == discard_granularity 
> > 
> > Paolo, any chance you could resend to Jens (maybe with hch's comments on
> > patch#2 accounted for)?  Also, please add hch's Reviewed-by when
> > reposting.
> 
> Sure, I'll do it this week.  I just need to retest.

Great, thanks.

(cc'ing mkp)

One thing that seemed odd was your adjustment for discard_alignment (in
patch 1/2).

I need to better understand how discard_alignment (an offset despite the
name not saying as much) relates to alignment_offset.

Could just be that once a partition tool, or lvm, etc account for
alignment_offset (which they do now) that discard_alignment is
automagically accounted for as a side-effect?

(I haven't actually seen discard_alignment != 0 in the wild)

Mike
