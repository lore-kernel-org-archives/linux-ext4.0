From: Karel Zak <kzak@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard
	failure? [was: Re: dm snapshot: ignore discards issued to the
	snapshot-origin target]
Date: Thu, 5 May 2011 10:33:44 +0200
Message-ID: <20110505083344.GA1114@nb.net.home>
References: <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com> <20110502081925.GA11312@infradead.org> <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com> <yq1bozl420p.fsf@sermon.lab.mkp.net> <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com> <yq1tydd2g5h.fsf@sermon.lab.mkp.net> <alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com> <yq1sjsuzebu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab1EEIeC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 04:34:02 -0400
Content-Disposition: inline
In-Reply-To: <yq1sjsuzebu.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 04, 2011 at 11:16:05AM -0400, Martin K. Petersen wrote:
> >>>>> "Lukas" =3D=3D Lukas Czerner <lczerner@redhat.com> writes:
>=20
> I got tired of poking around in sysfs to find the discard topology.
> Here's a patch against lsblk that adds a -D option to present this
> information in a human-readable form:

Applied, thanks.

> # lsblk -D
> NAME                  DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
> sda                          0        0B       0B         0
> =E2=94=94=E2=94=80sda1                       0        0B       0B    =
     0
> sdb                          0      512B       2G         1
> =E2=94=94=E2=94=80sdb1                       0      512B       2G    =
     1

I have a question, 2.6.35 on my ThinkPad, non-SSD disk:

NAME                   DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
sda                           0        0B       0B         0
=E2=94=9C=E2=94=80sda1               4294935040        0B       0B     =
    0
=E2=94=9C=E2=94=80sda2               4188038656        0B       0B     =
    0
=E2=94=9C=E2=94=80sda3               1346205184        0B       0B     =
    0
=E2=94=9C=E2=94=80sda4               3231165440        0B       0B     =
    0
=E2=94=9C=E2=94=80sda5               4188006400        0B       0B     =
    0
=E2=94=82 =E2=94=94=E2=94=80kzak-home (dm-0)          0        0B      =
 0B         0
=E2=94=94=E2=94=80sda6               2035725312        0B       0B     =
    0


Does is make sense? The DISC-ALN is non-zero but DISC-GRAN is zero.

Note that cat /sys/block/sda/sda*/discard_alignment returns the same
numbers.

    Karel

--=20
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
