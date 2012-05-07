From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Mon, 07 May 2012 18:44:11 +0200
Message-ID: <4FA7FBDB.7070205@pocock.com.au>
References: <4FA7A83E.6010801@pocock.com.au> (sfid-20120507_134208_021321_D3F6CC37) <201205071825.38415.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:58923 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab2EGQoY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 12:44:24 -0400
In-Reply-To: <201205071825.38415.Martin@lichtvoll.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/05/12 18:25, Martin Steigerwald wrote:
> Am Montag, 7. Mai 2012 schrieb Daniel Pocock:
>  =20
>> I've been having some NFS performance issues, and have been
>> experimenting with the server filesystem (ext4) to see if that is a
>> factor.
>>    =20
> Which NFS version is this?
>  =20
Normally I am using NFSv3.  I've also tried NFSv4 to see if that fixed
the problem, it made no difference.

> =20
>  =20
>> The setup is like this:
>>
>> (Debian 6, kernel 2.6.39)
>>    =20
I've just updated to 3.2 from squeeze-backports, it doesn't resolve the
issue either

>> 2x SATA drive (NCQ, 32MB cache, no hardware RAID)
>> md RAID1
>> LVM
>> ext4
>>
>> a) If I use data=3Dordered,barrier=3D1 and `hdparm -W 1' on the driv=
e, I
>> observe write performance over NFS of 1MB/sec (unpacking a big sourc=
e
>> tarball)
>>    =20
> Is this a realistic workload scenario for production use?
>
>  =20

Yes, it is a small server with few users, I keep some open source
projects on it, git repositories, compiling, etc.  So the usual workloa=
d
involves unpacking source code, git checkouts, compiles that generate
many object files.  All these operations are excruciatingly slow unless
I run NFS in `async' mode, which is not considered safe.

>> b) If I use data=3Dwriteback,barrier=3D0 and `hdparm -W 1' on the dr=
ive, I
>> observe write performance over NFS of 10MB/sec
>>
>> c) If I just use the async option on NFS, I observe up to 30MB/sec
>>
>> I believe (b) and (c) are not considered safe against filesystem
>> corruption, so I can't use them in practice.
>>    =20
> Partly.
>
> b) can harm filesystem consistency unless you disable write cache on =
the=20
> disks
>
>  =20

(b) only achieves any performance improvement if the write cache is
enabled - so it is not a production solution

> c) won=B4t harm local filesystem consistency, but should the nfs serv=
er break=20
> down all data that the NFS clients sent to the server for writing whi=
ch is=20
> not written yet is gone.
>
>  =20
Most of the access is from NFS, so (c) is not a good solution either.

>> - or must I just use option (b) but make it safer with battery-backe=
d
>> write cache?
>>    =20
> If you want performance and safety that is the best option from the o=
nes=20
> you mentioned, if the workload is really I/O bound on the local files=
ystem.=20
>
> Of course you can try the usual tricks like noatime, remove rsize and=
=20
> wsize options on the NFS client if they have a new enough kernel (the=
y=20
> autotune to much higher than the often recommended 8192 or 32768 byte=
s,=20
> look at /proc/mounts), put ext4 journal onto an extra disk to reduce =
head=20
> seeks, check whether enough NFS server threads are running, try a dif=
ferent=20
> filesystem and so on.
>
>  =20
One further discovery I made: I decided to eliminate md and LVM.  I had
enough space to create a 256MB partition on one of the disks, and forma=
t
it directly with ext4

Writing to that partition from the NFS3 client:
- less than 500kBytes/sec (for unpacking a tarball of source code)
- around 50MB/sec (dd if=3D/dev/zero conv=3Dfsync bs=3D65536)

and I then connected an old 5400rpm USB disk to the machine, ran the
same test from the NFS client:
- 5MBytes/sec (for unpacking a tarball of source code) - 10x faster tha=
n
the 72k SATA disk

This last test (comparing my AHCI SATA disk to the USB disk, with no md
or LVM) makes me think it is not an NFS problem, I feel it is some issu=
e
with the barriers when used with this AHCI or SATA disk.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
