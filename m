Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC37C282CC
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 22:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E63262175B
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 22:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfBEWxU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 17:53:20 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37198 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726742AbfBEWxU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2019 17:53:20 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 06 Feb 2019 09:23:16 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gr9ad-0001xB-AZ; Wed, 06 Feb 2019 09:53:15 +1100
Date:   Wed, 6 Feb 2019 09:53:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <keith.busch@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "prakash.v@samsung.com" <prakash.v@samsung.com>,
        Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
Message-ID: <20190205225315.GY6173@dastard>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
 <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
 <20190125162353.GA11210@localhost.localdomain>
 <20190128124709.GB27972@quack2.suse.cz>
 <20190128232423.GD15302@localhost.localdomain>
 <20190129100702.GA29981@quack2.suse.cz>
 <20190130001349.GT6173@dastard>
 <0ab2f0e1-27f2-7ab4-1772-f96c1430ea3b@samsung.com>
 <20190205115048.GC3872@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205115048.GC3872@quack2.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 05, 2019 at 12:50:48PM +0100, Jan Kara wrote:
> On Wed 30-01-19 19:24:39, Kanchan Joshi wrote:
> > 
> > On Wednesday 30 January 2019 05:43 AM, Dave Chinner wrote:
> > > On Tue, Jan 29, 2019 at 11:07:02AM +0100, Jan Kara wrote:
> > > > On Mon 28-01-19 16:24:24, Keith Busch wrote:
> > > > > On Mon, Jan 28, 2019 at 04:47:09AM -0800, Jan Kara wrote:
> > > > > > On Fri 25-01-19 09:23:53, Keith Busch wrote:
> > > > > > > On Wed, Jan 09, 2019 at 09:00:57PM +0530, Kanchan Joshi wrote:
> > > > > > > > Towards supporing write-hints/streams for filesystem journal.
> > > > > > > > Here is the v1 patch for background -
> > > > > > > > https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2
> > > > > > > > Changes since v1:
> > > > > > > > - introduce four more hints for in-kernel use, as recommended by Dave chinner
> > > > > > > >    & Jens axboe. This isolates kernel-mode hints from user-mode ones.
> > > > > > > 
> > > > > > > The nvme driver disables streams if the controller doesn't support
> > > > > > > BLK_MAX_WRITE_HINT number of streams, so this series breaks the feature
> > > > > > > for controllers that only support up to 4.
> > > > > > 
> > > > > > Right. Do you know if there are such controllers? Or are you just afraid
> > > > > > that there could be?
> > > > > 
> > > > > I've asked around, and the concensus I received is all currently support
> > > > > at least 8, but they couldn't say if that would be true for potential
> > > > > lower budget products. Can we implement a reasonable fallback to use
> > > > > what's available?
> > > > 
> > > > OK, thanks for input. So probably we should just map kernel stream IDs to 0
> > > > if the device doesn't support them. But that probably means we need to
> > > > propagate number of available streams up from NVME into the block layer so
> > > > that this can be handled reasonably seamlessly. Jens, Kanchan?
> > > 
> > > Yeah, that's basically what I said we needed to do when this was
> > > last discussed. i.e. that the block layer needed to know how many
> > > streams the hardware had and map the 4 "kernel internal" hints
> > > appropriately to what he device supports.
> > > 
> > > e.g. if the device only supports 4 hints, then it needs to map the
> > > kernel hints either to zero. If it supports less than 8 streams,
> > > then they need otbe mapped into the hints above index 5. If there
> > > are N streams, then they need to be mapped to the hints {N-3,N}
> > > 
> > > And, to top it all off, there needs to be guards so that if we want
> > > to grow the userspace hints to more than 4 hints, they don't crash
> > > into ranges the kernel is already reserving because of limited
> > > device range support.
> > > 
> > > Nothing is ever simple....
> > > 
> > Thanks all for feedback.
> > user-hints, when they reach to kernel via fcntl path, are sanity-checked
> > (rw_hint_valid function).
> > Currently streams are enabled when nvme driver is made to run with "streams
> > =1" option, while stream users always pass some write-hint, without
> > bothering whether streams (and how many of those) are operational or not.
> > This keeps configuration simple for stream users. Second, block layer does
> > not translate write-hint to stream-number, rather it is done inside nvme
> > driver. I suppose I should keep both these properties intact.
> > And considering all the suggestions, this is the plan for V3 -
> > 
> > [In block layer]
> > 1. Introduce one macro "KERN_WRITE_HINT_MIN" which will take the value
> > "user_hint_cnt + 1".
> > FS code will use this value (onwards) to define their own streams.
> > 
> > 2. Introduce another macro "BLK_MAX_KERNEL_WRITE_HINTS" which will be set to
> > 4 for now.
> > 
> > [In nvme driver]
> > 1. Continue working as before if device supports just 4 streams. All these
> > streams are used by user-hints, and kernel-hints are translated to 0.
> > 
> > 2. If device supports any more than 4 streams, those will be mapped to serve
> > kernel-hints, starting from KERN_WRITE_HINT_MIN onwards.
> > For example, if device has 6 streams, four streams (numbers = 1,2,3,4) will
> > be used to serve user-hints and two streams ( numbers = 65535, 65534) will
> > be used to serve first two kernel hints. Other kernel-hints get mapped to 0.
> > OTOH, if device has 10 streams, first four kernel-hints will be mapped to
> > non-zero values (65535 to 65532) and anything else would get turned to 0.
> 
> Well, I'm not sure if the mapping should happen in the NVME driver. In
> future, there will be potentially more drivers supporting write hints and
> we probably don't want each of them to replicate the mapping behavior. So
> IMO the mapping should rather belong to the block layer...

*nod*

That's what I was suggesting. All the driver does is supply the
block layer with the number of hints it supports, and the block
layer does the rest. After all, this has to work with DM, MD, etc
so it really does need to bubble up from the driver to the block
layer so it can be handled appropriately by multi-device block
drivers. e.g. md raid might want to reserve a kernel channel for
itself (e.g. internal metadata) and so only present 7 channels to
the next layer up (4 user and 3 kernel)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
