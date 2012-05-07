From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Mon, 7 May 2012 18:25:38 +0200
Message-ID: <201205071825.38415.Martin@lichtvoll.de>
References: <4FA7A83E.6010801@pocock.com.au> (sfid-20120507_134208_021321_D3F6CC37)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45057 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab2EGQZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 12:25:42 -0400
In-Reply-To: <4FA7A83E.6010801@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> I've been having some NFS performance issues, and have been
> experimenting with the server filesystem (ext4) to see if that is a
> factor.

Which NFS version is this?
=20
> The setup is like this:
>=20
> (Debian 6, kernel 2.6.39)
> 2x SATA drive (NCQ, 32MB cache, no hardware RAID)
> md RAID1
> LVM
> ext4
>=20
> a) If I use data=3Dordered,barrier=3D1 and `hdparm -W 1' on the drive=
, I
> observe write performance over NFS of 1MB/sec (unpacking a big source
> tarball)

Is this a realistic workload scenario for production use?

> b) If I use data=3Dwriteback,barrier=3D0 and `hdparm -W 1' on the dri=
ve, I
> observe write performance over NFS of 10MB/sec
>=20
> c) If I just use the async option on NFS, I observe up to 30MB/sec
>=20
> I believe (b) and (c) are not considered safe against filesystem
> corruption, so I can't use them in practice.

Partly.

b) can harm filesystem consistency unless you disable write cache on th=
e=20
disks

c) won=B4t harm local filesystem consistency, but should the nfs server=
 break=20
down all data that the NFS clients sent to the server for writing which=
 is=20
not written yet is gone.

> - or must I just use option (b) but make it safer with battery-backed
> write cache?

If you want performance and safety that is the best option from the one=
s=20
you mentioned, if the workload is really I/O bound on the local filesys=
tem.=20

Of course you can try the usual tricks like noatime, remove rsize and=20
wsize options on the NFS client if they have a new enough kernel (they=20
autotune to much higher than the often recommended 8192 or 32768 bytes,=
=20
look at /proc/mounts), put ext4 journal onto an extra disk to reduce he=
ad=20
seeks, check whether enough NFS server threads are running, try a diffe=
rent=20
filesystem and so on.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
