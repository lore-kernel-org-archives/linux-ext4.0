From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Fri, 14 Nov 2014 14:35:41 +0300
Message-ID: <87fvdmt3oy.fsf@openvz.org>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu> <87vbmkpm2p.fsf@openvz.org> <20141113160710.GE5235@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47825 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934095AbaKNLgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 06:36:00 -0500
Received: by mail-wi0-f181.google.com with SMTP id n3so2350541wiv.14
        for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2014 03:35:58 -0800 (PST)
In-Reply-To: <20141113160710.GE5235@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Wed, Nov 12, 2014 at 04:47:42PM +0300, Dmitry Monakhov wrote:
>> Also sync mtime updates is a great pain for AIO submitter
>> because AIO submission may be blocked for a seconds (up to 5 second in m=
y case)
>> if inode is part of current committing transaction see: do_get_write_acc=
ess
>
> 5 seconds?!?  So you're seeing cases where the jbd2 layer is taking
> that long to close a commit?  It might be worth looking at that so we
> can understand why that is happening, and to see if there's anything
> we might do to improve things on that front.  Even if we can get rid
> of most of the mtime updates, there will be other cases where a commit
> that takes a long time to complete will cause all sorts of other very
> nasty latencies on the entire system.
Our chunk server workload is quite generic
submit_task: performs aio-dio requests in to multiple chunk files from
             several threads, this task should not block for too long.
sync_task: performs fsync/fdatasync on demand for modified chunk files befo=
re
           we can ACK write-op to user, this task may block


Here is chunk server simulation load:
#TEST_CASE assumes that target fs is mounted to /mnt
# Performs random  aio-dio write  bsz:64k to preallocated files (size:128M)=
 threads:32
# and performs fdatasync each 32'th write operation
$ fio ./aio-dio.fio
# Measure AIO-DIO write submission latency=20
$ dd if=3D/dev/zero of=3D/mnt/f bs=3D1M count=3D1
$ ioping -A  -C -D  -WWW /mnt/f
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D1 time=
=3D410 us
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D2 time=
=3D430 us
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D3 time=
=3D370 us
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D4 time=
=3D400 us
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D5 time=
=3D1.9 s
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D6 time=
=3D4.2 s=20
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D7 time=
=3D3.8 s
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D8 time=
=3D3.7 s
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D9 time=
=3D4.1 s
4.0 KiB from /mnt/f (ext4 /dev/mapper/vzvg-scratch_dev): request=3D10 time=
=3D1.9 s
>
>> Yeah we also has ticket for that :)
>> https://jira.sw.ru/browse/PSBM-20411
>
> Is this supposed to be a URL to publically visible web page?
>
> 	Host jira.sw.ru not found: 3(NXDOMAIN)
Ohh, unfortunetly this host is not visiable from outside.



--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUZekNAAoJELhyPTmIL6kBgQ0IAK2bE8wLmnGYS5TYOVPTj2IV
TuIi38Rar4pPw/tKDH6LbdCczOanTYLmtV3reRGQmcPcg6zrv+w2DdJOrv3ktzUw
mmEif/clibrWUgAHM8n0B+IfY3jTgjEguOXMyFd8ius6Uz59GmVmZMo3jynRcDZy
QEAFrv5ZEB+LRCJqzKTnuNH+rhCkMiaL5Brj2DEvklo4UScfb6oIHsYfLCeTUNSe
GH88s2mitxh1hMtKunUuBYd6laHDix7Dbf17xqvkWvSOZzrXBDcC0qWwdbVyezrP
hre3oCxY/L7fBtAkTntj3Bozb3VkH1grN2w3Tg/kJ8zZ9azcJMbpROzHTPrI47s=
=wwgh
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=aio-dio.fio

# Chunk server simupation workload

[global]
ioengine=libaio
rw=randwrite
bs=128k
size=128m
directory=/mnt/

[aio-dio-write]
ioengine=libaio
iodepth=32
numjobs=32
verify=0
direct=1
#buffered=1
bs=64k
rw=randwrite
fdatasync=32
runtime=300
time_based
--=-=-=--
