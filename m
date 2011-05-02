From: Christoph Hellwig <hch@infradead.org>
Subject: Re: do not disable ext4 discards on first discard failure? [was: Re:
 dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Mon, 2 May 2011 10:48:23 -0400
Message-ID: <20110502144823.GA14393@infradead.org>
References: <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
 <20110429122454.GL32370@agk-dp.fab.redhat.com>
 <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
 <20110502081308.GC8642@agk-dp.fab.redhat.com>
 <20110502081925.GA11312@infradead.org>
 <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
 <20110502124803.GA31034@redhat.com>
 <alpine.LFD.2.00.1105021458480.3778@dhcp-27-109.brq.redhat.com>
 <4DBEC3F4.3050804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab1EBOsY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 10:48:24 -0400
Content-Disposition: inline
In-Reply-To: <4DBEC3F4.3050804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 09:47:16AM -0500, Eric Sandeen wrote:
> I still think we need to stick with the simple rule: "EOPNOTSUPP returned for a particular bio means that it is not supported for that particular bio" - I don't know what else we can do, without creating an ambiguity...
> 
> This does, however, suck for the layer calling in to a complex device.
> 
> What is the overhead for sending discard bios down to a device that does not support it?

For a DM-like device there is very little overhead.  The bio gets
dispatched to make_request and failed in there almost immediately.

