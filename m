Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032BBC282D0
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 00:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9712184D
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 00:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfA3AN4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 19:13:56 -0500
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:43283 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727079AbfA3AN4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 19:13:56 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl2.internode.on.net with ESMTP; 30 Jan 2019 10:43:52 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1godVl-0000N1-Fw; Wed, 30 Jan 2019 11:13:49 +1100
Date:   Wed, 30 Jan 2019 11:13:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Keith Busch <keith.busch@intel.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "prakash.v@samsung.com" <prakash.v@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
Message-ID: <20190130001349.GT6173@dastard>
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
 <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
 <20190125162353.GA11210@localhost.localdomain>
 <20190128124709.GB27972@quack2.suse.cz>
 <20190128232423.GD15302@localhost.localdomain>
 <20190129100702.GA29981@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129100702.GA29981@quack2.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 29, 2019 at 11:07:02AM +0100, Jan Kara wrote:
> On Mon 28-01-19 16:24:24, Keith Busch wrote:
> > On Mon, Jan 28, 2019 at 04:47:09AM -0800, Jan Kara wrote:
> > > On Fri 25-01-19 09:23:53, Keith Busch wrote:
> > > > On Wed, Jan 09, 2019 at 09:00:57PM +0530, Kanchan Joshi wrote:
> > > > > Towards supporing write-hints/streams for filesystem journal.                   
> > > > >                                                                                 
> > > > > Here is the v1 patch for background -                                           
> > > > > https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2                        
> > > > >                                                                                 
> > > > > Changes since v1:                                                               
> > > > > - introduce four more hints for in-kernel use, as recommended by Dave chinner   
> > > > >   & Jens axboe. This isolates kernel-mode hints from user-mode ones.            
> > > > 
> > > > The nvme driver disables streams if the controller doesn't support
> > > > BLK_MAX_WRITE_HINT number of streams, so this series breaks the feature
> > > > for controllers that only support up to 4.
> > > 
> > > Right. Do you know if there are such controllers? Or are you just afraid
> > > that there could be?
> > 
> > I've asked around, and the concensus I received is all currently support
> > at least 8, but they couldn't say if that would be true for potential
> > lower budget products. Can we implement a reasonable fallback to use
> > what's available?
> 
> OK, thanks for input. So probably we should just map kernel stream IDs to 0
> if the device doesn't support them. But that probably means we need to
> propagate number of available streams up from NVME into the block layer so
> that this can be handled reasonably seamlessly. Jens, Kanchan?

Yeah, that's basically what I said we needed to do when this was
last discussed. i.e. that the block layer needed to know how many
streams the hardware had and map the 4 "kernel internal" hints
appropriately to what he device supports.

e.g. if the device only supports 4 hints, then it needs to map the
kernel hints either to zero. If it supports less than 8 streams,
then they need otbe mapped into the hints above index 5. If there
are N streams, then they need to be mapped to the hints {N-3,N}

And, to top it all off, there needs to be guards so that if we want
to grow the userspace hints to more than 4 hints, they don't crash
into ranges the kernel is already reserving because of limited
device range support.

Nothing is ever simple....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
