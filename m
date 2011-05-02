From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was:
 Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Mon, 2 May 2011 16:58:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105021654190.6828@dhcp-27-109.brq.redhat.com>
References: <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com> <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com>
 <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com> <20110502081925.GA11312@infradead.org> <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com> <20110502124803.GA31034@redhat.com>
 <alpine.LFD.2.00.1105021458480.3778@dhcp-27-109.brq.redhat.com> <4DBEC3F4.3050804@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285Ab1EBO6f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 10:58:35 -0400
In-Reply-To: <4DBEC3F4.3050804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2 May 2011, Eric Sandeen wrote:

> On 5/2/11 8:05 AM, Lukas Czerner wrote:
> > On Mon, 2 May 2011, Mike Snitzer wrote:
> 
> ...
> 
> >> The blkdev_issue_discard() change you propose could be fine (mask
> >> EOPNOTSUPP return if device advertises support for discards) -- though
> >> Eric said we shouldn't ever say we did something when we didn't.
> > 
> > Exactly, so we should not say that it is not supported when it is, but
> > we just hit the "wrong" part of the device:) I would just very much like
> > to keep the abstraction of having one consistent device underneath the
> > file system and not deal with several devices, or regions with different
> > behaviour in the file system itself (let the pixies underneath deal with
> > that, after all not all of us are btrfs:))
> 
> I still think we need to stick with the simple rule: "EOPNOTSUPP returned for a particular bio means that it is not supported for that particular bio" - I don't know what else we can do, without creating an ambiguity...

I agree, but we do not care about bios in file system. We need to know
whether the device itself supports it or not. Also consider BLKDISCARD
ioctl(), now as it is it's completely broken on such dm devices, because
you are not able to use it due to -EOPNOTSUPP first time you hit the
device which does not support it, but it can very well be just a small
part of dm device.

Again, it does not make sense to return -EOPNOTSUPP from
blkdev_issue_discard() when the device actually supports it.

-Lukas

> 
> This does, however, suck for the layer calling in to a complex device.
> 
> What is the overhead for sending discard bios down to a device that does not support it?
> 
> -Eric
> 

-- 
