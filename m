From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was: Re:
 dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Mon, 2 May 2011 10:58:11 -0400
Message-ID: <20110502145807.GA32155@redhat.com>
References: <20110428075355.GA2190@infradead.org>
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
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285Ab1EBO6X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 10:58:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02 2011 at 10:39am -0400,
Lukas Czerner <lczerner@redhat.com> wrote:

> On Mon, 2 May 2011, Martin K. Petersen wrote:
>=20
> > >>>>> "Lukas" =3D=3D Lukas Czerner <lczerner@redhat.com> writes:
> >=20
> > Lukas> So I gave it a try. First of all the device composed of SSD =
and
> > Lukas> spinning disk does export discard_support information proper=
ly,
> > Lukas> however it also advertise discard_zeroes_data which is wrong=
 and
> > Lukas> possibly dangerous and should be fixed!
> >=20
> > I can't reproduce this here. If I mix discard and non-discard devic=
es
> > things work correctly. discard_zeroes_data also gets cleared if I m=
ix
> > discard-capable drives where one zeroes and one doesn't.
> >=20
> >=20
>=20
> [root@trim ~]# hdparm -I /dev/sdb | grep -i trim
> [root@trim ~]# cat /sys/block/sdb/queue/discard_zeroes_data
> 0
> [root@trim ~]# hdparm -I /dev/sdd | grep -i trim
>            *    Data Set Management TRIM supported
>            *    Deterministic read after TRIM
> [root@trim ~]# cat /sys/block/sdd/queue/discard_zeroes_data=20
> 1
> [root@trim ~]# pvcreate /dev/sdd1=20
>   Physical volume "/dev/sdd1" successfully created
> [root@trim ~]# pvcreate /dev/sdb3=20
>   Physical volume "/dev/sdb3" successfully created
> [root@trim ~]# vgcreate vg_test /dev/sdd1 /dev/sdb3=20
>   Volume group "vg_test" successfully created
> [root@trim ~]# lvcreate -L 3500M vg_test
>   Logical volume "lvol0" created
> [root@trim ~]# ls -lah /dev/mapper/vg_test-lvol0=20
> lrwxrwxrwx. 1 root root 7  2.=C2=A0kv=C4=9B 10.30 /dev/mapper/vg_test=
-lvol0 -> ../dm-0
> [root@trim ~]# cat /sys/block/dm-0/queue/discard_zeroes_data=20
> 1

Hmm, Strange considering DM just uses blk_stack_limits().

As Martin said, current blk_stack_limits() code is fine:
t->discard_zeroes_data &=3D b->discard_zeroes_data;

> So I assume it got fixes just recently ?. I'll give it a try with the
> up-to-date kernel.

Hasn't changed at all since it was introduced:
98262f2 v2.6.33-rc1 block: Allow devices to indicate whether discarded =
blocks are zeroed
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
