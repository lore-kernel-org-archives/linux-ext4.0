From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Sun, 01 Jul 2012 16:53:52 +0200
Message-ID: <4FF06480.6030109@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard> <4FE1BDF3.4080702@shiftmail.org> <20120620225327.GL30705@dastard> <20120621174742.GA27837@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
	hch@infradead.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab2GAOyR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2012 10:54:17 -0400
In-Reply-To: <20120621174742.GA27837@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Il 21/06/2012 19:47, Mike Snitzer ha scritto:
> Paolo Bonzini fixed blkdev_issue_discard to properly align some time
> ago; unfortunately the patches slipped through the cracks (cc'ing Paolo,
> Jens, and Christoph).
> 
> Here are references to Paolo's patches:
> 0/2 https://lkml.org/lkml/2012/3/14/323
> 1/2 https://lkml.org/lkml/2012/3/14/324
> 2/2 https://lkml.org/lkml/2012/3/14/325
> 
> Patch 2/2 specifically addresses the case where:
>  discard_max_bytes == discard_granularity 
> 
> Paolo, any chance you could resend to Jens (maybe with hch's comments on
> patch#2 accounted for)?  Also, please add hch's Reviewed-by when
> reposting.

Sure, I'll do it this week.  I just need to retest.

Paolo

