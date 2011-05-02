From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard
 failure? [was: Re: dm snapshot: ignore discards issued to the
 snapshot-origin target]
Date: Mon, 2 May 2011 04:19:25 -0400
Message-ID: <20110502081925.GA11312@infradead.org>
References: <20110413224025.GA18589@redhat.com>
 <20110413234854.GA19793@redhat.com>
 <20110426173213.GA19604@redhat.com>
 <20110428001912.GA14659@redhat.com>
 <20110428075355.GA2190@infradead.org>
 <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
 <20110429122454.GL32370@agk-dp.fab.redhat.com>
 <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
 <20110502081308.GC8642@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Dark
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1EBITb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 04:19:31 -0400
Content-Disposition: inline
In-Reply-To: <20110502081308.GC8642@agk-dp.fab.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 09:13:08AM +0100, Alasdair G Kergon wrote:
> On Mon, May 02, 2011 at 09:16:21AM +0200, Lukas Czerner wrote:
> > However when we have dm device where part of the device supports
> > discard due to underlying hardware capability we just can not return
> > EOPNOTSUPP from blkdev_issue_discard, because it is just not true! 
> 
> EOPNOTSUPP from dm means the operation was not supported on that *one* bio.
> It does *not* tell you anything in general about the device, or whether
> you'd get the same error from different bios in future.

Exactly.  We already have the information in the queue limits to tell
the filesystem if discard is supported at all or not.

