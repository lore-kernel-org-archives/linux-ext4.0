From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Fri, 14 Nov 2014 14:34:34 +0300
Message-ID: <87h9y2t3qt.fsf@openvz.org>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu> <87vbmkpm2p.fsf@openvz.org> <20141113160710.GE5235@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61718 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbaKNLev (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 06:34:51 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so1097638wgh.23
        for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2014 03:34:49 -0800 (PST)
In-Reply-To: <20141113160710.GE5235@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
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
>
>> > +	if (flags & S_VERSION)
>> > +		inode_inc_iversion(inode);
> 	  ....
>> Since we want update all in-memory data we also have to explicitly updat=
e inode->i_version
>> Which was previously updated implicitly here:
>> mark_inode_dirty_sync()
>> ->__mark_inode_dirty
>>   ->ext4_dirty_inode
>>     ->ext4_mark_inode_dirty
>>       ->ext4_mark_iloc_dirty
>>         ->inode_inc_iversion(inode);
>
> It's not necessary to add a anothre call to inode_inc_version() since
> we already incremented the i_version if S_VERSION is set, and
> S_VERSIOn gets set when it's necessary to handle incrementing
> i_Version.
>
> The inode_inc_iversion() in mark4_ext4_iloc_dirty() is probably not
> necessary, since we already should be incrementing i_version whenever
> ctime and mtime gets updated.  The inode_inc_iversion() there is more
> of a "belt and suspenders" safety thing, on the theory that the extra
> bump in i_version won't hurt anything.
>
> Cheers,
>
> 					- Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUZejKAAoJELhyPTmIL6kB0iEH/AnMs4D6IsCYYV7zViBH+CQs
G9G22fjSbhjg11yoO3YwGNoIYMdOqfHnb8MPokfOuL4QRgKqeyCxXBa+54f6hd9r
utEvqpa8lZ09BvW9qup2QgYiea49YIbU09COMPDskIK8G4i8Y48tSWHfR2VRk9RT
s2RCdWm4lGrzYQxCLveyfHo9e6+uamUSTqA+Ly6X7ulW1lmvcjncxeq6A5tYOkNv
ZbEOSGleY1Tjag/syy1M0rCf+XcBHCgHBcAbp0E9IhKOBgh1IWW/GPU+RE+lmfUK
rf6fkGE+0kZvpu2jba31DjxTbaLmjJzUDMiv4mZra23oXNjDdSBBy/u+PXajKv4=
=y6v9
-----END PGP SIGNATURE-----
--=-=-=--
