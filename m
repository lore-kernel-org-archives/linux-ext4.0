From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard
	failure? [was: Re: dm snapshot: ignore discards issued to the
	snapshot-origin target]
Date: Fri, 29 Apr 2011 13:24:54 +0100
Message-ID: <20110429122454.GL32370@agk-dp.fab.redhat.com>
References: <20110412234706.GA11244@redhat.com> <20cf301cbef67d323104a0c2ff52@google.com> <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com> <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@redhat.com>, sandeen@redhat.com,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1D2MZG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Apr 2011 08:25:06 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 29, 2011 at 11:30:47AM +0200, Lukas Czerner wrote:
> 1. We need to honor all the "discard limits" so the discard bios does
> not actually fail.
> 2. If the device is composed of various other devices, we should return
> -EOPNOTSUPP is none of the devices support discard.
> 3. We should succeed, if at least one of the devices support discard and
> it does not fail for any reason.
> 4. We should not advertise discard_zeroes_data if any of the devices
> does not zero data or does not support discard.
> I am not sure how "hard" is to assure those conditions in DM. If those
> conditions are met, we can rely on consistent information in the layers
> above.
 
Remember that -EOPNOTSUPP return applies only to that one *specific*
discard.  It does not tell you for sure whether or not another future
discard to the device will succeed.  (It's a property of offset - if
there are several devices underneath - and of time - if the device or
one below it gets reconfigured.)

The core issue here is whether a filesytem should decide that the
receipt of a single -EOPNOTSUPP is a reason never to send any more,
whether a more sophisticated algorithm should be used (considering 
the proportion/offsets of them over given periods of time and retrying
later), or whether more comprehensive information about the discard
capabilities of the device should be presented - and whether this should
be handled automatically or whether it should be under userspace control
(i.e. the sysadmin can instruct the filesystem what to do).

dm's role is simply to handle a discard if it can, and report back
if it couldn't.  Additionally it could provide more comprehensive
information about the discard capabilities of the device, but my sense
is that most consider this unnecessary as normally dm devices will have
a coherent behaviour throughout.

Alasdair

