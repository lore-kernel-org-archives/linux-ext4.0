From: Martin Steigerwald <ms@teamix.de>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Wed, 9 May 2012 09:30:02 +0200
Message-ID: <201205090930.02731.ms@teamix.de>
References: <4FA7A83E.6010801@pocock.com.au> <201205081655.38146.ms@teamix.de> <4FA93BB2.9050509@pocock.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:58815 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592Ab2EIHaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2012 03:30:06 -0400
In-Reply-To: <4FA93BB2.9050509@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Dienstag, 8. Mai 2012 schrieb Daniel Pocock:
> On 08/05/12 14:55, Martin Steigerwald wrote:
> > Am Dienstag, 8. Mai 2012 schrieb Daniel Pocock:
> >> On 08/05/12 00:24, Martin Steigerwald wrote:
> >>> Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> >>>> On 07/05/12 20:59, Martin Steigerwald wrote:
> >>>>> Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> >>>>>>> Possibly the older disk is lying about doing cache flushes.  =
The
> >>>>>>> wonderful disk manufacturers do that with commodity drives to=
 make
> >>>>>>> their benchmark numbers look better.  If you run some random =
IOPS
> >>>>>>> test against this disk, and it has performance much over 100 =
IOPS
> >>>>>>> then it is definitely not doing real cache flushes.
> >>>>>=20
> >>>>> [=E2=80=A6]
> >>>>>=20
> >>>>> I think an IOPS benchmark would be better. I.e. something like:
> >>>>>=20
> >>>>> /usr/share/doc/fio/examples/ssd-test
> >>>>>=20
> >>>>> (from flexible I/O tester debian package, also included in upst=
ream
> >>>>> tarball of course)
> >>>>>=20
> >>>>> adapted to your needs.
> >>>>>=20
> >>>>> Maybe with different iodepth or numjobs (to simulate several th=
reads
> >>>>> generating higher iodepths). With iodepth=3D1 I have seen 54 IO=
PS on a
> >>>>> Hitachi 5400 rpm harddisk connected via eSATA.
> >>>>>=20
> >>>>> Important is direct=3D1 to bypass the pagecache.
> >>>>=20
> >>>> Thanks for suggesting this tool, I've run it against the USB dis=
k and
> >>>> an LV on my AHCI/SATA/md array
> >>>>=20
> >>>> Incidentally, I upgraded the Seagate firmware (model 7200.12 fro=
m CC34
> >>>> to CC49) and one of the disks went offline shortly after I broug=
ht the
> >>>> system back up.  To avoid the risk that a bad drive might interf=
ere
> >>>> with the SATA performance, I completely removed it before runnin=
g any
> >>>> tests. Tomorrow I'm out to buy some enterprise grade drives, I'm
> >>>> thinking about Seagate Constellation SATA or even SAS.
> >>>>=20
> >>>> Anyway, onto the test results:
> >>>>=20
> >>>> USB disk (Seagate  9SD2A3-500 320GB):
> >>>>=20
> >>>> rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D22519
> >>>>=20
> >>>>   write: io=3D46680KB, bw=3D796512B/s, iops=3D194, runt=3D 60012=
msec
[=E2=80=A6]
> >>> Please repeat the test with iodepth=3D1.
> >>=20
> >> For the USB device:
> >>=20
> >> rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D11855
> >>=20
> >>   write: io=3D49320KB, bw=3D841713B/s, iops=3D205, runt=3D 60001ms=
ec
[=E2=80=A6]
> >> and for the SATA disk:
> >>=20
> >> rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D12256
> >>=20
> >>   write: io=3D28020KB, bw=3D478168B/s, iops=3D116, runt=3D 60005ms=
ec
[=E2=80=A6]
> > [=E2=80=A6]
> >=20
> >>      issued r/w: total=3D0/7005, short=3D0/0
> >>     =20
> >>      lat (msec): 4=3D6.31%, 10=3D69.54%, 20=3D22.68%, 50=3D0.63%, =
100=3D0.76%
> >>      lat (msec): 250=3D0.09%
> >>>=20
> >>> 194 IOPS appears to be highly unrealistic unless NCQ or something=
 like
> >>> that is in use. At least if thats a 5400/7200 RPM sata drive (did=
n=C2=B4t
> >>> check vendor information).
> >>=20
> >> The SATA disk does have NCQ
> >>=20
> >> USB disk is supposed to be 5400RPM, USB2, but reporting iops=3D205
> >>=20
> >> SATA disk is 7200 RPM, 3 Gigabit SATA, but reporting iops=3D116
> >>=20
> >> Does this suggest that the USB disk is caching data but telling Li=
nux
> >> the data is on disk?
> >=20
> > Looks like it.
> >=20
> > Some older values for a 1.5 TB WD Green Disk:
> >=20
> > mango:~# fio -readonly -name iops -rw=3Drandread -bs=3D512  -runtim=
e=3D100
> > -iodepth 1 -filename /dev/sda -ioengine  libaio -direct=3D1
> > [...] iops: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D9939
> >=20
> >   read : io=3D1,859KB, bw=3D19,031B/s, iops=3D37, runt=3D100024msec=
 [...]</pre>
> >=20
> > mango:~# fio -readonly -name iops -rw=3Drandread -bs=3D512  -runtim=
e=3D100
> > -iodepth 32 -filename /dev/sda -ioengine  libaio -direct=3D1
> > iops: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10304
> >=20
> >   read : io=3D2,726KB, bw=3D27,842B/s, iops=3D54, runt=3D100257msec
> >=20
> > mango:~# hdparm -I /dev/sda | grep -i queue
> >=20
> >         Queue depth: 32
> >        =20
> >            *    Native Command Queueing (NCQ)
> >=20
> > - 1,5 TB Western Digital, WDC WD15EADS-00P8B0
> > - Pentium 4 mit 2,80 GHz
> > - 4 GB RAM, 32-Bit Linux
> > - Linux Kernel 2.6.36
> > - fio 1.38-1
[=E2=80=A6]
> >> It is a gigabit network and I think that the performance of the dd
> >> command proves it is not something silly like a cable fault (I hav=
e come
> >> across such faults elsewhere though)
> >=20
> > What is the latency?
>=20
> $ ping -s 1000 192.168.1.2
> PING 192.168.1.2 (192.168.1.2) 1000(1028) bytes of data.
> 1008 bytes from 192.168.1.2: icmp_req=3D1 ttl=3D64 time=3D0.307 ms
> 1008 bytes from 192.168.1.2: icmp_req=3D2 ttl=3D64 time=3D0.341 ms
> 1008 bytes from 192.168.1.2: icmp_req=3D3 ttl=3D64 time=3D0.336 ms

Seems to be fine.

> >>> Anyway, 15000 RPM SAS drives should give you more IOPS than 7200 =
RPM
> >>> SATA drives, but SATA drives are cheaper and thus you could -
> >>> depending on RAID level - increase IOPS by just using more drives=
=2E
> >>=20
> >> I was thinking about the large (2TB or 3TB) 7200 RPM SAS or SATA d=
rives
> >> in the Seagate `Constellation' enterprise drive range.  I need mor=
e
> >> space anyway, and I need to replace the drive that failed, so I ha=
ve to
> >> spend some money anyway - I just want to throw it in the right dir=
ection
> >> (e.g. buying a drive, or if the cheap on-board SATA controller is =
a
> >> bottleneck or just extremely unsophisticated, I don't mind getting=
 a
> >> dedicated controller)
> >>=20
> >> For example, if I knew that the controller is simply not suitable =
with
> >> barriers, NFS, etc and that a $200 RAID card or even a $500 RAID c=
ard
> >> will guarantee better performance with my current kernel, I would =
buy
> >> that.  (However, I do want to use md RAID rather than a proprietar=
y
> >> format, so any RAID card would be in JBOD mode)
> >=20
> > They point is: How much of the performance will arrive at NFS? I ca=
n't
> > say yet.
>=20
> My impression is that the faster performance of the USB disk was a re=
d
> herring, and the problem really is just the nature of the NFS protoco=
l
> and the way it is stricter about server-side caching (when sync is
> enabled) and consequently it needs more iops.

Yes, that seems to be the case here. It seems to be a small blocksize r=
andom=20
I/O workload with heavy fsync() usage.

You could adapt to /usr/share/doc/fio/examples/iometer-file-access-serv=
er to=20
benchmark such a scenario. Also fsmark simulates such a heavy fsync() b=
ased=20
quite well. I have packaged it for Debian, but its still in NEW queue. =
You can=20
grab it from

http://people.teamix.net/~ms/debian/sid/

(32-Bit build, but easily buildable for amd64 as well)

> I've turned two more machines (a HP Z800 with SATA disk and a Lenovo
> X220 with SSD disk) into NFSv3 servers, repeated the same tests, and
> found similar performance on the Z800, but 20x faster on the SSD (whi=
ch
> can support more IOPS)

Okay, then you want more IOPS.

> > And wait I/O is quite high.
> >=20
> > Thus it seems this workload can be faster with faster / more disks =
or a
> > RAID controller with battery (and disabling barriers / cache flushe=
s).
>=20
> You mean barrier=3D0,data=3Dwriteback?  Or just barrier=3D0,data=3Dor=
dered?

I meant data=3Dordered. As mentioned by Andreas data=3Djournal could yi=
eld a=20
improvement. I'd suggest trying to but the journal onto a different dis=
k then=20
in order to avoid head seeks during writeout of journal data to its fin=
al=20
location.

> In theory that sounds good, but in practice I understand it creates s=
ome
> different problems, eg:
>=20
> - monitoring the battery, replacing it periodically
>=20
> - batteries only hold the charge for a few hours, so if there is a po=
wer
> outage on a Sunday, someone tries to turn on the server on  Monday
> morning and the battery has died, cache is empty and disk is corrupt

Hmmm, from what I know there are NVRAM based controllers that can hold =
the=20
cached data for several days.

> - some RAID controllers (e.g. HP SmartArray) insist on writing their
> metadata to all volumes - so you become locked in to the RAID vendor.=
  I
> prefer to just use RAID1 or RAID10 with Linux md onto the raw disks. =
 On
> some Adaptec controllers, `JBOD' mode allows md to access the disks
> directly, although I haven't verified that yet.

I see no reason why SoftRAID cannot be used with a NVRAM based controll=
er.
=20
> I'm tempted to just put a UPS on the server and enable NFS `async' mo=
de,
> and avoid running anything on the server that may cause a crash.

A UPS on the server won't make "async" safe. If the server crashes you =
still=20
can loose data.

Ciao,
--=20
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
