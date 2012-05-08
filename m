From: Martin Steigerwald <ms@teamix.de>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Tue, 8 May 2012 16:55:37 +0200
Message-ID: <201205081655.38146.ms@teamix.de>
References: <4FA7A83E.6010801@pocock.com.au> <201205080024.54183.Martin@lichtvoll.de> <4FA85960.6040703@pocock.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:48459 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755445Ab2EHPCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2012 11:02:53 -0400
In-Reply-To: <4FA85960.6040703@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Dienstag, 8. Mai 2012 schrieb Daniel Pocock:
> On 08/05/12 00:24, Martin Steigerwald wrote:
> > Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> >> On 07/05/12 20:59, Martin Steigerwald wrote:
> >>> Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
> >>>>> Possibly the older disk is lying about doing cache flushes.  Th=
e
> >>>>> wonderful disk manufacturers do that with commodity drives to m=
ake
> >>>>> their benchmark numbers look better.  If you run some random IO=
PS
> >>>>> test against this disk, and it has performance much over 100 IO=
PS
> >>>>> then it is definitely not doing real cache flushes.
> >>>=20
> >>> [=E2=80=A6]
> >>>=20
> >>> I think an IOPS benchmark would be better. I.e. something like:
> >>>=20
> >>> /usr/share/doc/fio/examples/ssd-test
> >>>=20
> >>> (from flexible I/O tester debian package, also included in upstre=
am
> >>> tarball of course)
> >>>=20
> >>> adapted to your needs.
> >>>=20
> >>> Maybe with different iodepth or numjobs (to simulate several thre=
ads
> >>> generating higher iodepths). With iodepth=3D1 I have seen 54 IOPS=
 on a
> >>> Hitachi 5400 rpm harddisk connected via eSATA.
> >>>=20
> >>> Important is direct=3D1 to bypass the pagecache.
> >>=20
> >> Thanks for suggesting this tool, I've run it against the USB disk =
and
> >> an LV on my AHCI/SATA/md array
> >>=20
> >> Incidentally, I upgraded the Seagate firmware (model 7200.12 from =
CC34
> >> to CC49) and one of the disks went offline shortly after I brought=
 the
> >> system back up.  To avoid the risk that a bad drive might interfer=
e
> >> with the SATA performance, I completely removed it before running =
any
> >> tests. Tomorrow I'm out to buy some enterprise grade drives, I'm
> >> thinking about Seagate Constellation SATA or even SAS.
> >>=20
> >> Anyway, onto the test results:
> >>=20
> >> USB disk (Seagate  9SD2A3-500 320GB):
> >>=20
> >> rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D22519
> >>=20
> >>   write: io=3D46680KB, bw=3D796512B/s, iops=3D194, runt=3D 60012ms=
ec
> >>  =20
> >>     slat (usec): min=3D13, max=3D25264, avg=3D106.02, stdev=3D525.=
18
> >>     clat (usec): min=3D993, max=3D103568, avg=3D20444.19, stdev=3D=
11622.11
> >>     bw (KB/s) : min=3D  521, max=3D 1224, per=3D100.06%, avg=3D777=
=2E48,
> >>=20
> >> stdev=3D97.07 cpu          : usr=3D0.73%, sys=3D2.33%, ctx=3D12024=
, majf=3D0,
> >> minf=3D20 IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%,=
 16=3D0.0%,
> >> 32=3D0.0%,
> >=20
> > Please repeat the test with iodepth=3D1.
>=20
> For the USB device:
>=20
> rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D11855
>   write: io=3D49320KB, bw=3D841713B/s, iops=3D205, runt=3D 60001msec
>     slat (usec): min=3D67, max=3D6234, avg=3D112.62, stdev=3D136.92
>     clat (usec): min=3D684, max=3D97358, avg=3D4737.20, stdev=3D4824.=
08
>     bw (KB/s) : min=3D  588, max=3D 1029, per=3D100.46%, avg=3D824.74=
, stdev=3D84.47
>   cpu          : usr=3D0.64%, sys=3D2.89%, ctx=3D12751, majf=3D0, min=
f=3D21
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%,=
 32=3D0.0%,
>=20
> >=3D64=3D0.0%
>=20
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%,
>=20
> >=3D64=3D0.0%
>=20
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%,
>=20
> >=3D64=3D0.0%
>=20
>      issued r/w: total=3D0/12330, short=3D0/0
>      lat (usec): 750=3D0.02%, 1000=3D0.48%
>      lat (msec): 2=3D1.05%, 4=3D66.65%, 10=3D26.32%, 20=3D1.46%, 50=3D=
3.99%
>      lat (msec): 100=3D0.03%
>=20
> and for the SATA disk:
>=20
> rand-write: (groupid=3D3, jobs=3D1): err=3D 0: pid=3D12256
>   write: io=3D28020KB, bw=3D478168B/s, iops=3D116, runt=3D 60005msec
>     slat (usec): min=3D58, max=3D132637, avg=3D110.51, stdev=3D1623.8=
0
>     clat (msec): min=3D2, max=3D206, avg=3D 8.44, stdev=3D 7.10
>     bw (KB/s) : min=3D   95, max=3D  566, per=3D100.24%, avg=3D467.11=
, stdev=3D97.64
>   cpu          : usr=3D0.36%, sys=3D1.17%, ctx=3D7196, majf=3D0, minf=
=3D21
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%,=
 32=3D0.0%,
[=E2=80=A6]
>      issued r/w: total=3D0/7005, short=3D0/0
>=20
>      lat (msec): 4=3D6.31%, 10=3D69.54%, 20=3D22.68%, 50=3D0.63%, 100=
=3D0.76%
>      lat (msec): 250=3D0.09%
>=20
> > 194 IOPS appears to be highly unrealistic unless NCQ or something l=
ike
> > that is in use. At least if thats a 5400/7200 RPM sata drive (didn=C2=
=B4t
> > check vendor information).
>=20
> The SATA disk does have NCQ
>=20
> USB disk is supposed to be 5400RPM, USB2, but reporting iops=3D205
>=20
> SATA disk is 7200 RPM, 3 Gigabit SATA, but reporting iops=3D116
>=20
> Does this suggest that the USB disk is caching data but telling Linux
> the data is on disk?

Looks like it.

Some older values for a 1.5 TB WD Green Disk:

mango:~# fio -readonly -name iops -rw=3Drandread -bs=3D512  -runtime=3D=
100 -iodepth 1=20
-filename /dev/sda -ioengine  libaio -direct=3D1
[...] iops: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D9939
  read : io=3D1,859KB, bw=3D19,031B/s, iops=3D37, runt=3D100024msec [..=
=2E]</pre>


mango:~# fio -readonly -name iops -rw=3Drandread -bs=3D512  -runtime=3D=
100 -iodepth=20
32 -filename /dev/sda -ioengine  libaio -direct=3D1
iops: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10304
  read : io=3D2,726KB, bw=3D27,842B/s, iops=3D54, runt=3D100257msec

mango:~# hdparm -I /dev/sda | grep -i queue
        Queue depth: 32
           *    Native Command Queueing (NCQ)

- 1,5 TB Western Digital, WDC WD15EADS-00P8B0
- Pentium 4 mit 2,80 GHz
- 4 GB RAM, 32-Bit Linux
- Linux Kernel 2.6.36
- fio 1.38-1

> >> The IOPS scores look similar, but I checked carefully and I'm fair=
ly
> >> certain the disks were mounted correctly when the tests ran.
> >>=20
> >> Should I run this tool over NFS, will the results be meaningful?
> >>=20
> >> Given the need to replace a drive anyway, I'm really thinking abou=
t one
> >> of the following approaches:
> >> - same controller, upgrade to enterprise SATA drives
> >> - buy a dedicated SAS/SATA controller, upgrade to enterprise SATA
> >> drives
> >> - buy a dedicated SAS/SATA controller, upgrade to SAS drives
> >>=20
> >> My HP N36L is quite small, one PCIe x16 slot, the internal drive c=
age
> >> has an SFF-8087 (mini SAS) plug, so I'm thinking I can grab someth=
ing
> >> small like the Adaptec 1405 - will any of these solutions offer a
> >> definite win with my NFS issues though?
> >=20
> > First I would like to understand more closely what your NFS issues =
are.
> > Before throwing money at the problem its important to understand wh=
at the
> > problem actually is.
>=20
> When I do things like unpacking a large source tarball, iostat report=
s
> throughput to the drive between 500-1000kBytes/second
>=20
> When I do the same operation onto the USB drive over NFS, I see over
> 5000kBytes/second - but it appears from the iops test figures that th=
e
> USB drive is cheating, so we'll ignore that.
>=20
> - if I just dd to the SATA drive over NFS (with conv=3Dfsync), I see =
much
> faster speeds

Easy. Less roundtrips.

Just watch nfsstat -3 while untarring a tarball over NFS to see what I =
mean.

> - if I'm logged in to the server, and I unpack the same tarball onto =
the
> same LV, the operation completes at 30MBytes/sec

No network.

Thats the LV on the internal disk?

> It is a gigabit network and I think that the performance of the dd
> command proves it is not something silly like a cable fault (I have c=
ome
> across such faults elsewhere though)

What is the latency?

> > Anyway, 15000 RPM SAS drives should give you more IOPS than 7200 RP=
M SATA
> > drives, but SATA drives are cheaper and thus you could - depending =
on
> > RAID level - increase IOPS by just using more drives.
>=20
> I was thinking about the large (2TB or 3TB) 7200 RPM SAS or SATA driv=
es
> in the Seagate `Constellation' enterprise drive range.  I need more
> space anyway, and I need to replace the drive that failed, so I have =
to
> spend some money anyway - I just want to throw it in the right direct=
ion
> (e.g. buying a drive, or if the cheap on-board SATA controller is a
> bottleneck or just extremely unsophisticated, I don't mind getting a
> dedicated controller)
>=20
> For example, if I knew that the controller is simply not suitable wit=
h
> barriers, NFS, etc and that a $200 RAID card or even a $500 RAID card
> will guarantee better performance with my current kernel, I would buy
> that.  (However, I do want to use md RAID rather than a proprietary
> format, so any RAID card would be in JBOD mode)

They point is: How much of the performance will arrive at NFS? I can't =
say=20
yet.

> > But still first I=C2=B4d like to understand *why* its slow.
> >=20
> > What does
> >=20
> > iostat -x -d -m 5
> > vmstat 5
> >=20
> > say when excersing the slow (and probably a faster) setup? See [1].
>=20
> All the iostat output is typically like this:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> dm-23             0.00     0.00    0.20  187.60     0.00     0.81
> 8.89     2.02   10.79   5.07  95.20
> dm-23             0.00     0.00    0.20  189.80     0.00     0.91
> 9.84     1.95   10.29   4.97  94.48
> dm-23             0.00     0.00    0.20  228.60     0.00     1.00
> 8.92     1.97    8.58   4.10  93.92
> dm-23             0.00     0.00    0.20  231.80     0.00     0.98
> 8.70     1.96    8.49   4.06  94.16
> dm-23             0.00     0.00    0.20  229.20     0.00     0.94
> 8.40     1.92    8.39   4.10  94.08

Hmmm, disk looks quite utilitzed. Are there other I/O workloads on the=20
machine?

> and vmstat:
>=20
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us =
sy
> id wa
> ...
>  0  1      0 6881772 118660 576712    0    0     1  1033  720 1553  0=
  2
> 60 38
>  0  1      0 6879068 120220 577892    0    0     1   918  793 1595  0=
  2
> 56 41
>  0  1      0 6876208 122200 578684    0    0     1  1055  767 1731  0=
  2
> 67 31
>  1  1      0 6873356 124176 579392    0    0     1  1014  742 1688  0=
  2
> 66 32
>  0  1      0 6870628 126132 579904    0    0     1  1007  753 1683  0=
  2
> 66 32

And wait I/O is quite high.

Thus it seems this workload can be faster with faster / more disks or a=
 RAID=20
controller with battery (and disabling barriers / cache flushes).

> and nfsstat -s -o all -l -Z5
>=20
> nfs v3 server        total:      319
> ------------- ------------- --------
> nfs v3 server      getattr:        1
> nfs v3 server      setattr:      126
> nfs v3 server       access:        6
> nfs v3 server        write:       61
> nfs v3 server       create:       61
> nfs v3 server        mkdir:        3
> nfs v3 server       commit:       61

I would like to see nfsiostat from newer nfs-utils, cause it includes=20
latencies.

> > [1]
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_inclu=
de_whe
> > n_reporting_a_problem.3F
>=20
> I've also tested onto btrfs and the performance was equally bad, so i=
t
> may not be an ext4 issue
>=20
> The environment is:
> Linux srv1 3.2.0-0.bpo.2-amd64 #1 SMP Mon Apr 23 08:38:01 UTC 2012
> x86_64 GNU/Linux
> (Debian squeeze)
> Kernel NFS v3
> HP N36L server, onboard AHCI
>  md RAID1 as a 1TB device (/dev/md2)
> /dev/md2 is a PV for LVM - no other devices attached
>=20
> As mentioned before, I've tried with and without write cache.
> dmesg reports that ext4 (and btrfs) seem to be happy to accept the
> barrier=3D1 or barrier=3D0 setting with the drives.

3.2 doesn't report failure on barriers anymore. Barriers have been swit=
ched to=20
cache flush requests and these will not report back failure. So you hav=
e to=20
make sure cache flushes work in other ways.

> dmesg and hdparm also appear to report accurate information about wri=
te
> cache status.
>=20
> > (quite some of this should be relevant when reporting with ext4 as =
well)
> >=20
> > As for testing with NFS: I except the values to drop. NFS has quite=
 some
> > protocol overhead due to network roundtrips. On my nasic tests NFSv=
4 even
> > more so than NFSv3. As for NFS I suggest trying nfsiostat python sc=
ript
> > from newer nfs-utils. It also shows latencies.
>=20
> I agree - but 500kBytes/sec is just so much slower than anything I've
> seen with any IO device in recent years.  I don't expect to get 90% o=
f
> the performance of a local disk, but is getting 30-50% reasonable?

Depends on the workload.

You might consider using FS-Cache with cachefilesd for local client sid=
e=20
caching.

Ciao,
--=20
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
