From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure? [was: Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Wed, 04 May 2011 13:32:14 -0400
Message-ID: <yq1boziz80x.fsf@sermon.lab.mkp.net>
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
	<20110502081925.GA11312@infradead.org>
	<alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
	<yq1bozl420p.fsf@sermon.lab.mkp.net>
	<alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com>
	<yq1tydd2g5h.fsf@sermon.lab.mkp.net>
	<alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com>
	<yq1wri6zel9.fsf@sermon.lab.mkp.net>
	<alpine.LFD.2.00.1105041825250.7938@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:41622 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1EDRcb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 May 2011 13:32:31 -0400
In-Reply-To: <alpine.LFD.2.00.1105041825250.7938@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Wed, 4 May 2011 19:10:11 +0200 (CEST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:

Lukas> Also I am not sure why this changed discard_max_bytes from
Lukas> 4294966784 to 2147450880 in my case, that does not seem
Lukas> right...lsblk in the first place apparently overflowed.

2G is correct. The relevant libata patch was missing from the series I
submitted during the merge window and I don't see it in the archives. It
was at the end of the stack so I guess I had an off-by-one in my commit
range...

-- 
Martin K. Petersen	Oracle Linux Engineering
