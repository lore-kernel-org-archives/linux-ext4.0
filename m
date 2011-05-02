From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard
	failure? [was: Re: dm snapshot: ignore discards issued to the
	snapshot-origin target]
Date: Mon, 2 May 2011 09:13:08 +0100
Message-ID: <20110502081308.GC8642@agk-dp.fab.redhat.com>
References: <20cf301cbef67d323104a0c2ff52@google.com> <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com> <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1EBINX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 04:13:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 09:16:21AM +0200, Lukas Czerner wrote:
> However when we have dm device where part of the device supports
> discard due to underlying hardware capability we just can not return
> EOPNOTSUPP from blkdev_issue_discard, because it is just not true! 

EOPNOTSUPP from dm means the operation was not supported on that *one* bio.
It does *not* tell you anything in general about the device, or whether
you'd get the same error from different bios in future.

Alasdair

