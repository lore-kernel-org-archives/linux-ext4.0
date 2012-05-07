From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Mon, 7 May 2012 20:59:10 +0200
Message-ID: <201205072059.10256.Martin@lichtvoll.de>
References: <4FA7A83E.6010801@pocock.com.au> <E19B872E-1392-4B1E-8093-E1A666ECEA36@dilger.ca> <4FA8063F.5080505@pocock.com.au> (sfid-20120507_203813_468045_38032D95)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35165 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab2EGS7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 14:59:45 -0400
In-Reply-To: <4FA8063F.5080505@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> > Possibly the older disk is lying about doing cache flushes.  The
> > wonderful disk manufacturers do that with commodity drives to make
> > their benchmark numbers look better.  If you run some random IOPS
> > test against this disk, and it has performance much over 100 IOPS
> > then it is definitely not doing real cache flushes.
[=E2=80=A6]
> I would agree that is possible - I actually tried using hdparm and
> sdparm to check cache status, but they don't work with the USB drive
>=20
> I've tried the following directly onto the raw device:
>=20
> dd if=3D/dev/zero of=3D/dev/sdc1 bs=3D4096 count=3D65536 conv=3Dfsync
> 29.2MB/s

Thats no random I/O IOPS benchmark,

> and iostat reported avg 250 write/sec, avgrq-sz =3D 237, wkB/s =3D 30=
MB/sec

but a sequential workload that gives the I/O scheduler oppurtunity to=20
combine write requests.

Also its using pagecache, as conv=3Dfsync only includes the fsync() at =
the=20
end of dd=C2=B4ing.
=20
> I tried a smaller write as well (just count=3D1024, total 4MB of data=
)
> and it also reported a slower speed, which suggests that it really is
> writing the data out to disk and not just caching.

I think an IOPS benchmark would be better. I.e. something like:

/usr/share/doc/fio/examples/ssd-test

(from flexible I/O tester debian package, also included in upstream tar=
ball=20
of course)

adapted to your needs.

Maybe with different iodepth or numjobs (to simulate several threads=20
generating higher iodepths). With iodepth=3D1 I have seen 54 IOPS on a=20
Hitachi 5400 rpm harddisk connected via eSATA.

Important is direct=3D1 to bypass the pagecache.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
