From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure?
 [was: Re: dm snapshot: ignore discards issued to the snapshot-origin
 target]
Date: Tue, 3 May 2011 10:57:19 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com>
References: <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com> <20110502081925.GA11312@infradead.org>
 <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com> <yq1bozl420p.fsf@sermon.lab.mkp.net> <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com> <yq1tydd2g5h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1329580424-1304413043=:4250"
Cc: Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab1ECI5g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 04:57:36 -0400
In-Reply-To: <yq1tydd2g5h.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1329580424-1304413043=:4250
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Mon, 2 May 2011, Martin K. Petersen wrote:

> >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> 
> Lukas,
> 
> Lukas> [root@trim ~]# lvcreate -L 3500M vg_test
> Lukas>   Logical volume "lvol0" created
> 
> Ok, so here's what I think is going on. You're creating a linear target
> which happens to fit inside the first PV.
> 
> Here's two devices. One that supports discard_zeroes_data=1 (8:17) and
> one that doesn't (8:49).
> 
> # dmsetup table 
> foo-bar: 0 1032192 striped 2 32 8:17 384 8:49 384
> foo-baz: 0 106496 linear 8:17 516480
> 
> # grep . /sys/block/d*/queue/discard_z*
> /sys/block/dm-0/queue/discard_zeroes_data:0
> /sys/block/dm-1/queue/discard_zeroes_data:1
> 
> LV foo/bar (dm-0) is striped, straddling two devices with incompatible
> values. Hence 0.
> 
> LV foo/baz (dm-1) is linear and fits inside the first PV. Thus it has
> discard_zeroes_data=1.

Well that's why I have included /proc/partition, so you can see that
this is not happening, because both partitions are 1.86GB long and the LV I
am creating from those is 3.42GB long.

[root@trim ~]# dmsetup table
vg_test-lvol0: 0 3899392 linear 8:49 2048
vg_test-lvol0: 3899392 3268608 linear 8:19 2048


Nevertheless there is something weird going on, because even when I
create striped volume I get this:


[root@trim ~]# dmsetup table
vg_test-lvol0: 0 7176192 striped 2 16 8:49 2048 8:19 2048
[root@trim ~]# ls -lah /dev/mapper/vg_test-lvol0 
lrwxrwxrwx. 1 root root 7  3. kvì 04.42 /dev/mapper/vg_test-lvol0 ->
../dm-0
[root@trim ~]# grep . /sys/block/dm-0/queue/discard_*
/sys/block/dm-0/queue/discard_granularity:512
/sys/block/dm-0/queue/discard_max_bytes:4294966784
/sys/block/dm-0/queue/discard_zeroes_data:1


And of course (8:49) is a partition on the SSD which does zero data and
(8:19) is a partition on the spinning device which does not zero data,
nor does it support discard. And this is on yesterdays kernel.

[root@trim ~]# uname -r
2.6.39-rc5+

So assuming that you're trying recent kernel as well, someone is doing
something different :)

Thanks!
-Lukas
--8323328-1329580424-1304413043=:4250--
