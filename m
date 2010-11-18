From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Thu, 18 Nov 2010 18:35:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>  <20101118130630.GJ6178@parisc-linux.org>  <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>  <20101118141957.GK6178@parisc-linux.org>  <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: James Bottomley <James.Bottomley@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab0KRRfz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 12:35:55 -0500
In-Reply-To: <1290100750.3041.72.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 18 Nov 2010, James Bottomley wrote:

> On Thu, 2010-11-18 at 09:29 -0500, Christoph Hellwig wrote:
> > On Thu, Nov 18, 2010 at 07:19:58AM -0700, Matthew Wilcox wrote:
> > > I guess I was assuming that, on receiving a FALLOC_FL_PUNCH_HOLE, a
> > > filesystem that was TRIM-aware would pass that information down to the
> > > block device that it's mounted on.  I strongly feel that we shouldn't
> > > have two interfaces to do essentially the same thing.
> > > 
> > > I guess I'm saying that you're going to have to learn about TRIM :-)
> > 
> > Did you actually look Lukas FITRIM code (not the slight reordering here,
> > but the original one).  It's the ext4 version of the batched discard
> > model, that is a userspace ioctl to discard free space in the
> > filesystem.
> > 
> > hole punching will free the blocks into the free space pool.  If you do
> > online discard it will also get discarded, but a filesystem that has
> > online discard enabled doesn't need FITRIM.
> 
> Not stepping into the debate: I'm happy to see punch go to the mapping
> data and FITRIM pick it up later.
> 
> However, I think it's time to question whether we actually still want to
> allow online discard at all.  Most of the benchmarks show it to be a net
> lose to almost everything (either SSD or Thinly Provisioned arrays), so
> it's become an "enable this to degrade performance" option with no
> upside.
> 
> James
> 

This time began a long time ago :) that is why am I originally created
batched discard for ext4 (ext3) accessible through FITRIM ioctl. Ext4
performance with -o discard mount option goes down on the most of the
SSD's and every Thinly-provisioned storage I have a chance to benchmark.

But, for example SSD's are getting better and as time goes by we might
see devices that does not suffer terrible performance loss with discard
enabled (discard on unlink in ext4 etc...), so this "online" discard
probably still does make sense.

-Lukas
