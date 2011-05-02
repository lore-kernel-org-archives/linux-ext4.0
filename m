From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure?
 [was: Re: dm snapshot: ignore discards issued to the snapshot-origin
 target]
Date: Mon, 2 May 2011 16:39:31 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com>
References: <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com> <20110502081925.GA11312@infradead.org>
 <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com> <yq1bozl420p.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-872738970-1304347175=:3778"
Cc: Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440Ab1EBOkB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 10:40:01 -0400
In-Reply-To: <yq1bozl420p.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-872738970-1304347175=:3778
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Mon, 2 May 2011, Martin K. Petersen wrote:

> >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> 
> Lukas> So I gave it a try. First of all the device composed of SSD and
> Lukas> spinning disk does export discard_support information properly,
> Lukas> however it also advertise discard_zeroes_data which is wrong and
> Lukas> possibly dangerous and should be fixed!
> 
> I can't reproduce this here. If I mix discard and non-discard devices
> things work correctly. discard_zeroes_data also gets cleared if I mix
> discard-capable drives where one zeroes and one doesn't.
> 
> 

[root@trim ~]# hdparm -I /dev/sdb | grep -i trim
[root@trim ~]# cat /sys/block/sdb/queue/discard_zeroes_data
0
[root@trim ~]# hdparm -I /dev/sdd | grep -i trim
           *    Data Set Management TRIM supported
           *    Deterministic read after TRIM
[root@trim ~]# cat /sys/block/sdd/queue/discard_zeroes_data 
1
[root@trim ~]# pvcreate /dev/sdd1 
  Physical volume "/dev/sdd1" successfully created
[root@trim ~]# pvcreate /dev/sdb3 
  Physical volume "/dev/sdb3" successfully created
[root@trim ~]# vgcreate vg_test /dev/sdd1 /dev/sdb3 
  Volume group "vg_test" successfully created
[root@trim ~]# lvcreate -L 3500M vg_test
  Logical volume "lvol0" created
[root@trim ~]# ls -lah /dev/mapper/vg_test-lvol0 
lrwxrwxrwx. 1 root root 7  2. kvì 10.30 /dev/mapper/vg_test-lvol0 -> ../dm-0
[root@trim ~]# cat /sys/block/dm-0/queue/discard_zeroes_data 
1
[root@trim ~]# uname -r
2.6.39-rc5-blkdev+
[root@trim ~]# cat /proc/partitions
   8       19    1951897 sdb3
   8       49    1951866 sdd1
 253        0    3584000 dm-0



So I assume it got fixes just recently ?. I'll give it a try with the
up-to-date kernel.

Thanks!
-Lukas
--8323328-872738970-1304347175=:3778--
