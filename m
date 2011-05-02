From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was:
 Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Mon, 02 May 2011 09:47:16 -0500
Message-ID: <4DBEC3F4.3050804@redhat.com>
References: <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com> <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com> <20110502081925.GA11312@infradead.org> <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com> <20110502124803.GA31034@redhat.com> <alpine.LFD.2.00.1105021458480.3778@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812Ab1EBOr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 10:47:26 -0400
In-Reply-To: <alpine.LFD.2.00.1105021458480.3778@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/2/11 8:05 AM, Lukas Czerner wrote:
> On Mon, 2 May 2011, Mike Snitzer wrote:

...

>> The blkdev_issue_discard() change you propose could be fine (mask
>> EOPNOTSUPP return if device advertises support for discards) -- though
>> Eric said we shouldn't ever say we did something when we didn't.
> 
> Exactly, so we should not say that it is not supported when it is, but
> we just hit the "wrong" part of the device:) I would just very much like
> to keep the abstraction of having one consistent device underneath the
> file system and not deal with several devices, or regions with different
> behaviour in the file system itself (let the pixies underneath deal with
> that, after all not all of us are btrfs:))

I still think we need to stick with the simple rule: "EOPNOTSUPP returned for a particular bio means that it is not supported for that particular bio" - I don't know what else we can do, without creating an ambiguity...

This does, however, suck for the layer calling in to a complex device.

What is the overhead for sending discard bios down to a device that does not support it?

-Eric
