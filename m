From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Mon, 07 May 2012 19:28:31 +0200
Message-ID: <4FA8063F.5080505@pocock.com.au>
References: <4FA7A83E.6010801@pocock.com.au> (sfid-20120507_134208_021321_D3F6CC37) <201205071825.38415.Martin@lichtvoll.de> <4FA7FBDB.7070205@pocock.com.au> <E19B872E-1392-4B1E-8093-E1A666ECEA36@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:59450 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2EGR2q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 13:28:46 -0400
In-Reply-To: <E19B872E-1392-4B1E-8093-E1A666ECEA36@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/05/12 18:54, Andreas Dilger wrote:
> On 2012-05-07, at 10:44 AM, Daniel Pocock wrote:
>  =20
>> On 07/05/12 18:25, Martin Steigerwald wrote:
>>    =20
>>> Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
>>>      =20
>>>> 2x SATA drive (NCQ, 32MB cache, no hardware RAID)
>>>> md RAID1
>>>> LVM
>>>> ext4
>>>>
>>>> a) If I use data=3Dordered,barrier=3D1 and `hdparm -W 1' on the dr=
ive,
>>>>    I observe write performance over NFS of 1MB/sec (unpacking a
>>>>    big source tarball)
>>>>
>>>> b) If I use data=3Dwriteback,barrier=3D0 and `hdparm -W 1' on the =
drive,
>>>>    I observe write performance over NFS of 10MB/sec
>>>>
>>>> c) If I just use the async option on NFS, I observe up to 30MB/sec
>>>>        =20
> The only proper way to isolate the cause of performance problems is t=
o test each layer separately.
>
> What is the performance running this workload against the same ext4
> filesystem locally (i.e. without NFS)?  How big are the files?  If
> you run some kind of low-level benchmark against the underlying MD
> RAID array, with synchronous IOPS of the average file size, what is
> the performance?
>
>  =20
- the test file is 5MB compressed, over 100MB uncompressed, many C++
files of varying sizes

- testing it locally is definitely faster - but local disk writes can b=
e
cached more aggressively than writes from an NFS client, so it is not
strictly comparable

> Do you have something like the MD RAID resync bitmaps enabled?  That
> can kill performance, though it improves the rebuild time after a
> crash.  Putting these bitmaps onto a small SSH, or e.g. a separate
> boot disk (if you have one) can improve performance significantly.
>
>  =20
I've checked /proc/mdstat, it doesn't report any bitmap at all


>>> c) won=B4t harm local filesystem consistency, but should the nfs se=
rver break down all data that the NFS clients sent to the server for
>>> writing which is not written yet is gone.
>>>      =20
>> Most of the access is from NFS, so (c) is not a good solution either=
=2E
>>    =20
> Well, this behaviour is not significantly worse than applications
> writing to a local filesystem, and the node crashing and losing the
> dirty data in memory that has not been written to disk.
>
>  =20
A lot of the documents I've seen about NFS performance suggest it is
slightly worse though, because the applications on the client have
received positive responses from fsync()

>>>> - or must I just use option (b) but make it safer with battery-bac=
ked
>>>> write cache?
>>>>        =20
>>> If you want performance and safety that is the best option from the
>>> ones you mentioned, if the workload is really I/O bound on the loca=
l filesystem.=20
>>>
>>> Of course you can try the usual tricks like noatime, remove rsize a=
nd=20
>>> wsize options on the NFS client if they have a new enough kernel (t=
hey=20
>>> autotune to much higher than the often recommended 8192 or 32768 by=
tes,=20
>>> look at /proc/mounts), put ext4 journal onto an extra disk to reduc=
e head seeks, check whether enough NFS server threads are running, try =
a
>>> different filesystem and so on.
>>>      =20
>> One further discovery I made: I decided to eliminate md and LVM.  I =
had
>> enough space to create a 256MB partition on one of the disks, and fo=
rmat
>> it directly with ext4
>>
>> Writing to that partition from the NFS3 client:
>> - less than 500kBytes/sec (for unpacking a tarball of source code)
>> - around 50MB/sec (dd if=3D/dev/zero conv=3Dfsync bs=3D65536)
>>
>> and I then connected an old 5400rpm USB disk to the machine, ran the
>> same test from the NFS client:
>> - 5MBytes/sec (for unpacking a tarball of source code) - 10x faster =
than
>> the 72k SATA disk
>>    =20
> Possibly the older disk is lying about doing cache flushes.  The
> wonderful disk manufacturers do that with commodity drives to make
> their benchmark numbers look better.  If you run some random IOPS
> test against this disk, and it has performance much over 100 IOPS
> then it is definitely not doing real cache flushes.
>
>  =20

I would agree that is possible - I actually tried using hdparm and
sdparm to check cache status, but they don't work with the USB drive

I've tried the following directly onto the raw device:

dd if=3D/dev/zero of=3D/dev/sdc1 bs=3D4096 count=3D65536 conv=3Dfsync
29.2MB/s

and iostat reported avg 250 write/sec, avgrq-sz =3D 237, wkB/s =3D 30MB=
/sec

I tried a smaller write as well (just count=3D1024, total 4MB of data) =
and
it also reported a slower speed, which suggests that it really is
writing the data out to disk and not just caching.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
