From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Mon, 07 May 2012 22:56:29 +0200
Message-ID: <4FA836FD.2070506@pocock.com.au>
References: <4FA7A83E.6010801@pocock.com.au> <E19B872E-1392-4B1E-8093-E1A666ECEA36@dilger.ca> <4FA8063F.5080505@pocock.com.au> (sfid-20120507_203813_468045_38032D95) <201205072059.10256.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:33772 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab2EGU4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 16:56:34 -0400
In-Reply-To: <201205072059.10256.Martin@lichtvoll.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/05/12 20:59, Martin Steigerwald wrote:
> Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
>  =20
>>> Possibly the older disk is lying about doing cache flushes.  The
>>> wonderful disk manufacturers do that with commodity drives to make
>>> their benchmark numbers look better.  If you run some random IOPS
>>> test against this disk, and it has performance much over 100 IOPS
>>> then it is definitely not doing real cache flushes.
>>>      =20
> [=E2=80=A6]
>  =20
> I think an IOPS benchmark would be better. I.e. something like:
>
> /usr/share/doc/fio/examples/ssd-test
>
> (from flexible I/O tester debian package, also included in upstream t=
arball=20
> of course)
>
> adapted to your needs.
>
> Maybe with different iodepth or numjobs (to simulate several threads=20
> generating higher iodepths). With iodepth=3D1 I have seen 54 IOPS on =
a=20
> Hitachi 5400 rpm harddisk connected via eSATA.
>
> Important is direct=3D1 to bypass the pagecache.
>
>  =20
Thanks for suggesting this tool, I've run it against the USB disk and a=
n
LV on my AHCI/SATA/md array

Incidentally, I upgraded the Seagate firmware (model 7200.12 from CC34
to CC49) and one of the disks went offline shortly after I brought the
system back up.  To avoid the risk that a bad drive might interfere wit=
h
the SATA performance, I completely removed it before running any tests.=
=20
Tomorrow I'm out to buy some enterprise grade drives, I'm thinking abou=
t
Seagate Constellation SATA or even SAS.

Anyway, onto the test results:

USB disk (Seagate  9SD2A3-500 320GB):

rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D22519
  write: io=3D46680KB, bw=3D796512B/s, iops=3D194, runt=3D 60012msec
    slat (usec): min=3D13, max=3D25264, avg=3D106.02, stdev=3D525.18
    clat (usec): min=3D993, max=3D103568, avg=3D20444.19, stdev=3D11622=
=2E11
    bw (KB/s) : min=3D  521, max=3D 1224, per=3D100.06%, avg=3D777.48, =
stdev=3D97.07
  cpu          : usr=3D0.73%, sys=3D2.33%, ctx=3D12024, majf=3D0, minf=3D=
20
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%,
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%,
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%,
>=3D64=3D0.0%
     issued r/w: total=3D0/11670, short=3D0/0
     lat (usec): 1000=3D0.01%
     lat (msec): 2=3D0.01%, 4=3D0.24%, 10=3D2.75%, 20=3D64.64%, 50=3D29=
=2E97%
     lat (msec): 100=3D2.31%, 250=3D0.08%



and from the SATA disk on the AHCI controller
- Barracuda 7200.12  ST31000528AS connected to
- AMD RS785E/SB820M chipset, (lspci reports SB700/SB800 AHCI mode)

rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D23038
  write: io=3D46512KB, bw=3D793566B/s, iops=3D193, runt=3D 60018msec
    slat (usec): min=3D13, max=3D35317, avg=3D97.09, stdev=3D541.14
    clat (msec): min=3D2, max=3D214, avg=3D20.53, stdev=3D18.56
    bw (KB/s) : min=3D    0, max=3D  882, per=3D98.54%, avg=3D762.72, s=
tdev=3D114.51
  cpu          : usr=3D0.85%, sys=3D2.27%, ctx=3D11972, majf=3D0, minf=3D=
21
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%,
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%,
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%,
>=3D64=3D0.0%
     issued r/w: total=3D0/11628, short=3D0/0

     lat (msec): 4=3D1.81%, 10=3D32.65%, 20=3D31.30%, 50=3D26.82%, 100=3D=
6.71%
     lat (msec): 250=3D0.71%




The IOPS scores look similar, but I checked carefully and I'm fairly
certain the disks were mounted correctly when the tests ran.

Should I run this tool over NFS, will the results be meaningful?

Given the need to replace a drive anyway, I'm really thinking about one
of the following approaches:
- same controller, upgrade to enterprise SATA drives
- buy a dedicated SAS/SATA controller, upgrade to enterprise SATA drive=
s
- buy a dedicated SAS/SATA controller, upgrade to SAS drives

My HP N36L is quite small, one PCIe x16 slot, the internal drive cage
has an SFF-8087 (mini SAS) plug, so I'm thinking I can grab something
small like the Adaptec 1405 - will any of these solutions offer a
definite win with my NFS issues though?

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
