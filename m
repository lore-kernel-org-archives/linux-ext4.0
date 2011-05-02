From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure?
 [was: Re: dm snapshot: ignore discards issued to the snapshot-origin
 target]
Date: Mon, 2 May 2011 12:24:33 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
References: <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com>
 <20110502081925.GA11312@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1EBKYs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 06:24:48 -0400
In-Reply-To: <20110502081925.GA11312@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2 May 2011, Christoph Hellwig wrote:

> On Mon, May 02, 2011 at 09:13:08AM +0100, Alasdair G Kergon wrote:
> > On Mon, May 02, 2011 at 09:16:21AM +0200, Lukas Czerner wrote:
> > > However when we have dm device where part of the device supports
> > > discard due to underlying hardware capability we just can not return
> > > EOPNOTSUPP from blkdev_issue_discard, because it is just not true! 
> > 
> > EOPNOTSUPP from dm means the operation was not supported on that *one* bio.
> > It does *not* tell you anything in general about the device, or whether
> > you'd get the same error from different bios in future.
> 
> Exactly.  We already have the information in the queue limits to tell
> the filesystem if discard is supported at all or not.
> 

So I gave it a try. First of all the device composed of SSD and spinning
disk does export discard_support information properly, however it also
advertise discard_zeroes_data which is wrong and possibly dangerous and
should be fixed!

And second of all, strictly speaking if EOPNOTSUPP from dm means that
operation was not supported on that *one* bio, blkdev_issue_discard()
should handle that and do not return EOPNOTSUPP further if queue limits
tells that device has discard support. Is this acceptable solution for
you guys ? I can make that change since I am changing blkdev_issue_discard()
anyway. Or, we can make that change in filesystem where we disable
discard on mount time, when we notice that discard mount option was
specified, but the device does not support it (we should probably do
this regardless on blkdev_issue_discard() change).

Thanks!
-Lukas
