From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Mon, 7 May 2012 10:54:45 -0600
Message-ID: <E19B872E-1392-4B1E-8093-E1A666ECEA36@dilger.ca>
References: <4FA7A83E.6010801@pocock.com.au> (sfid-20120507_134208_021321_D3F6CC37) <201205071825.38415.Martin@lichtvoll.de> <4FA7FBDB.7070205@pocock.com.au>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:42359 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab2EGQyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 12:54:47 -0400
In-Reply-To: <4FA7FBDB.7070205@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-07, at 10:44 AM, Daniel Pocock wrote:
> On 07/05/12 18:25, Martin Steigerwald wrote:
>> Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
>>> 2x SATA drive (NCQ, 32MB cache, no hardware RAID)
>>> md RAID1
>>> LVM
>>> ext4
>>>=20
>>> a) If I use data=3Dordered,barrier=3D1 and `hdparm -W 1' on the dri=
ve,
>>>    I observe write performance over NFS of 1MB/sec (unpacking a
>>>    big source tarball)
>>>=20
>>> b) If I use data=3Dwriteback,barrier=3D0 and `hdparm -W 1' on the d=
rive,
>>>    I observe write performance over NFS of 10MB/sec
>>>=20
>>> c) If I just use the async option on NFS, I observe up to 30MB/sec

The only proper way to isolate the cause of performance problems is to =
test each layer separately.

What is the performance running this workload against the same ext4
filesystem locally (i.e. without NFS)?  How big are the files?  If
you run some kind of low-level benchmark against the underlying MD
RAID array, with synchronous IOPS of the average file size, what is
the performance?

Do you have something like the MD RAID resync bitmaps enabled?  That
can kill performance, though it improves the rebuild time after a
crash.  Putting these bitmaps onto a small SSH, or e.g. a separate
boot disk (if you have one) can improve performance significantly.

>> c) won=B4t harm local filesystem consistency, but should the nfs ser=
ver break down all data that the NFS clients sent to the server for
>> writing which is not written yet is gone.
>=20
> Most of the access is from NFS, so (c) is not a good solution either.

Well, this behaviour is not significantly worse than applications
writing to a local filesystem, and the node crashing and losing the
dirty data in memory that has not been written to disk.

>>> - or must I just use option (b) but make it safer with battery-back=
ed
>>> write cache?
>>=20
>> If you want performance and safety that is the best option from the
>> ones you mentioned, if the workload is really I/O bound on the local=
 filesystem.=20
>>=20
>> Of course you can try the usual tricks like noatime, remove rsize an=
d=20
>> wsize options on the NFS client if they have a new enough kernel (th=
ey=20
>> autotune to much higher than the often recommended 8192 or 32768 byt=
es,=20
>> look at /proc/mounts), put ext4 journal onto an extra disk to reduce=
 head seeks, check whether enough NFS server threads are running, try a
>> different filesystem and so on.
>=20
> One further discovery I made: I decided to eliminate md and LVM.  I h=
ad
> enough space to create a 256MB partition on one of the disks, and for=
mat
> it directly with ext4
>=20
> Writing to that partition from the NFS3 client:
> - less than 500kBytes/sec (for unpacking a tarball of source code)
> - around 50MB/sec (dd if=3D/dev/zero conv=3Dfsync bs=3D65536)
>=20
> and I then connected an old 5400rpm USB disk to the machine, ran the
> same test from the NFS client:
> - 5MBytes/sec (for unpacking a tarball of source code) - 10x faster t=
han
> the 72k SATA disk

Possibly the older disk is lying about doing cache flushes.  The
wonderful disk manufacturers do that with commodity drives to make
their benchmark numbers look better.  If you run some random IOPS
test against this disk, and it has performance much over 100 IOPS
then it is definitely not doing real cache flushes.

> This last test (comparing my AHCI SATA disk to the USB disk, with no =
md
> or LVM) makes me think it is not an NFS problem, I feel it is some is=
sue
> with the barriers when used with this AHCI or SATA disk.


Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
