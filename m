From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Tue, 8 May 2012 00:24:53 +0200
Message-ID: <201205080024.54183.Martin@lichtvoll.de>
References: <4FA7A83E.6010801@pocock.com.au> <201205072059.10256.Martin@lichtvoll.de> <4FA836FD.2070506@pocock.com.au> (sfid-20120507_234440_614296_65A27F34)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51645 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2EGWY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 18:24:56 -0400
In-Reply-To: <4FA836FD.2070506@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> On 07/05/12 20:59, Martin Steigerwald wrote:
> > Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> >>> Possibly the older disk is lying about doing cache flushes.  The
> >>> wonderful disk manufacturers do that with commodity drives to mak=
e
> >>> their benchmark numbers look better.  If you run some random IOPS
> >>> test against this disk, and it has performance much over 100 IOPS
> >>> then it is definitely not doing real cache flushes.
> >=20
> > [=E2=80=A6]
> >=20
> > I think an IOPS benchmark would be better. I.e. something like:
> >=20
> > /usr/share/doc/fio/examples/ssd-test
> >=20
> > (from flexible I/O tester debian package, also included in upstream
> > tarball of course)
> >=20
> > adapted to your needs.
> >=20
> > Maybe with different iodepth or numjobs (to simulate several thread=
s
> > generating higher iodepths). With iodepth=3D1 I have seen 54 IOPS o=
n a
> > Hitachi 5400 rpm harddisk connected via eSATA.
> >=20
> > Important is direct=3D1 to bypass the pagecache.
>=20
> Thanks for suggesting this tool, I've run it against the USB disk and
> an LV on my AHCI/SATA/md array
>=20
> Incidentally, I upgraded the Seagate firmware (model 7200.12 from CC3=
4
> to CC49) and one of the disks went offline shortly after I brought th=
e
> system back up.  To avoid the risk that a bad drive might interfere
> with the SATA performance, I completely removed it before running any
> tests. Tomorrow I'm out to buy some enterprise grade drives, I'm
> thinking about Seagate Constellation SATA or even SAS.
>=20
> Anyway, onto the test results:
>=20
> USB disk (Seagate  9SD2A3-500 320GB):
>=20
> rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D22519
>   write: io=3D46680KB, bw=3D796512B/s, iops=3D194, runt=3D 60012msec
>     slat (usec): min=3D13, max=3D25264, avg=3D106.02, stdev=3D525.18
>     clat (usec): min=3D993, max=3D103568, avg=3D20444.19, stdev=3D116=
22.11
>     bw (KB/s) : min=3D  521, max=3D 1224, per=3D100.06%, avg=3D777.48=
,
> stdev=3D97.07 cpu          : usr=3D0.73%, sys=3D2.33%, ctx=3D12024, m=
ajf=3D0,
> minf=3D20 IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=
=3D0.0%,
> 32=3D0.0%,

Please repeat the test with iodepth=3D1.

194 IOPS appears to be highly unrealistic unless NCQ or something like=20
that is in use. At least if thats a 5400/7200 RPM sata drive (didn=C2=B4=
t check=20
vendor information).

iodepth=3D1 should give you what the hardware is capable without reques=
t=20
queueing and reordering involved.

> The IOPS scores look similar, but I checked carefully and I'm fairly
> certain the disks were mounted correctly when the tests ran.
>=20
> Should I run this tool over NFS, will the results be meaningful?
>=20
> Given the need to replace a drive anyway, I'm really thinking about o=
ne
> of the following approaches:
> - same controller, upgrade to enterprise SATA drives
> - buy a dedicated SAS/SATA controller, upgrade to enterprise SATA
> drives
> - buy a dedicated SAS/SATA controller, upgrade to SAS drives
>=20
> My HP N36L is quite small, one PCIe x16 slot, the internal drive cage
> has an SFF-8087 (mini SAS) plug, so I'm thinking I can grab something
> small like the Adaptec 1405 - will any of these solutions offer a
> definite win with my NFS issues though?

=46irst I would like to understand more closely what your NFS issues ar=
e.=20
Before throwing money at the problem its important to understand what t=
he=20
problem actually is.

Anyway, 15000 RPM SAS drives should give you more IOPS than 7200 RPM SA=
TA=20
drives, but SATA drives are cheaper and thus you could - depending on R=
AID=20
level - increase IOPS by just using more drives.

But still first I=C2=B4d like to understand *why* its slow.

What does

iostat -x -d -m 5
vmstat 5

say when excersing the slow (and probably a faster) setup? See [1].

[1]=20
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_w=
hen_reporting_a_problem.3F

(quite some of this should be relevant when reporting with ext4 as well=
)

As for testing with NFS: I except the values to drop. NFS has quite som=
e=20
protocol overhead due to network roundtrips. On my nasic tests NFSv4 ev=
en=20
more so than NFSv3. As for NFS I suggest trying nfsiostat python script=
=20
from newer nfs-utils. It also shows latencies.=20

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
