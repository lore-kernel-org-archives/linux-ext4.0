From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure? [was: Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Mon, 02 May 2011 12:58:34 -0400
Message-ID: <yq1tydd2g5h.fsf@sermon.lab.mkp.net>
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
Received: from rcsinet10.oracle.com ([148.87.113.121]:62672 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1EBQ6u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 12:58:50 -0400
In-Reply-To: <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Mon, 2 May 2011 16:39:31 +0200 (CEST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:

Lukas,

Lukas> [root@trim ~]# lvcreate -L 3500M vg_test
Lukas>   Logical volume "lvol0" created

Ok, so here's what I think is going on. You're creating a linear target
which happens to fit inside the first PV.

Here's two devices. One that supports discard_zeroes_data=1 (8:17) and
one that doesn't (8:49).

# dmsetup table 
foo-bar: 0 1032192 striped 2 32 8:17 384 8:49 384
foo-baz: 0 106496 linear 8:17 516480

# grep . /sys/block/d*/queue/discard_z*
/sys/block/dm-0/queue/discard_zeroes_data:0
/sys/block/dm-1/queue/discard_zeroes_data:1

LV foo/bar (dm-0) is striped, straddling two devices with incompatible
values. Hence 0.

LV foo/baz (dm-1) is linear and fits inside the first PV. Thus it has
discard_zeroes_data=1.

-- 
Martin K. Petersen	Oracle Linux Engineering
