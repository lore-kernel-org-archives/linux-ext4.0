From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: further updates for mke2fs(8) man page
Date: Tue, 17 Dec 2013 15:22:15 -0700
Message-ID: <83B3938A-DEF8-4C05-9511-BA830DCCD692@dilger.ca>
References: <1387268271-8285-1-git-send-email-adilger@dilger.ca> <52B06996.5090005@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D978D374-905C-4D55-A0DE-48F73E21DBD1"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47365 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3LQWWV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Dec 2013 17:22:21 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so5030669pad.26
        for <linux-ext4@vger.kernel.org>; Tue, 17 Dec 2013 14:22:21 -0800 (PST)
In-Reply-To: <52B06996.5090005@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D978D374-905C-4D55-A0DE-48F73E21DBD1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Dec 17, 2013, at 8:11 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 12/17/13, 2:17 AM, Andreas Dilger wrote:
>> The mke2fs(8) man page was updated in 4727c67dc2, but needs some
>> more clear descriptions for extra_isize and metadta_csum features.
>> The uninit_bg feature is supported by all ext4-capable kernels,
>> and does have a slow e2fsck pass for newly-formatted filesystems,
>> so remove the caveat.
>=20
> Looks ok to me, but I think there's still one thing missing;
> it mentions metadata checksums but nothing in the manpage says
> how to turn those on, AFAICT:

Actually, the comments about metadata checksums is commented out in
the man page.  That isn't obvious at first glance.  I had just seen
it in the previous page, and the old description "a superset of the
uninit_bg feature" wasn't very useful.

As with anything, no complaints about the previous patch - it definitely
improved the old content, and there is much more that needs to be done
to document the metadata checksum feature (tune2fs, e2fsck, etc).
Every bit helps.

Cheers, Andreas

> $ grep -i2 "checksum\|csum\|crc" misc/mke2fs.8
> .B uninit_bg
> Create a filesystem without initializing all of the block groups.  =
This
> feature also enables checksums and highest-inode-used statistics in =
each
> blockgroup.  This feature can
> speed up filesystem creation time noticeably (if lazy_itable_init is
>=20
>=20
> (maybe I'm dense & missing it?)
>=20
> -Eric
>=20
>> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
>> ---
>> misc/mke2fs.8.in |   36 ++++++++++++++++++++++--------------
>> 1 files changed, 22 insertions(+), 14 deletions(-)
>>=20
>> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
>> index df244de..4486014 100644
>> --- a/misc/mke2fs.8.in
>> +++ b/misc/mke2fs.8.in
>> @@ -210,8 +210,8 @@ in earlier versions of
>> .BR mke2fs .
>> The
>> .B \-R
>> -option is still accepted for backwards compatibility.   The
>> -following extended options are supported:
>> +option is still accepted for backwards compatibility, but is =
deprecated.
>> +The following extended options are supported:
>> .RS 1.2i
>> .TP
>> .BI mmp_update_interval=3D interval
>> @@ -548,7 +548,7 @@ of e2fsprogs will not support file systems with =
this feature enabled.
>> .TP
>> .B bigalloc
>> .br
>> -This feature enables clustered allocation, so that the unit of
>> +This feature enables clustered block allocation, so that the unit of
>> allocation is a power of two number of blocks.  That is, each bit in =
the
>> what had traditionally been known as the block allocation bitmap now
>> indicates whether a cluster is in use or not, where a cluster is by
>> @@ -570,7 +570,7 @@ features be enabled.
>> .TP
>> .B dir_index
>> .br
>> -Use hashed b-trees to speed up lookups in large directories.
>> +Use hashed b-trees to speed up name lookups in large directories.
>> .TP
>> .B dir_nlink
>> .br
>> @@ -590,8 +590,15 @@ historical/backwards compatibility reasons.)
>> .TP
>> .B extra_isize
>> .br
>> -This feature enables storage of nanosecond timestamps and creation
>> -time, if the inode size is larger than 256 bytes or larger.
>> +This feature reserves a specific amount of space in each inode for
>> +extended metadata such as nanosecond timestamps and file creation =
time,
>> +even if the current kernel does not current need to reserve this =
much
>> +space.  Without this feature, the kernel will reserve the amount of
>> +space for features currently it currently needs, and the rest may be
>> +consumed by extended attributes.
>> +
>> +For this feature to be useful the inode size must be 256 bytes in =
size
>> +or larger.
>> .TP
>> .B ext_attr
>> .br
>> @@ -649,10 +656,16 @@ set this feature automatically when a file > =
2GiB is created.)
>> .\" .TP
>> .\" .B metadata_csum
>> .\" .br
>> -.\" Filesystem supports metadata checksumming.  This feature enables =
a
>> -.\" superset of the functionality of the
>> +.\" Filesystem supports metadata checksumming.  This feature stores
>> +.\" checksums for all of the filesystem metadata (superblock, group
>> +.\" descriptor blocks, inode and block bitmaps, directories, and
>> +.\" extent tree blocks).  The checksum algorithm used for the =
metadata
>> +.\" blocks is different than the one used for group descriptors with =
the
>> .\" .B uninit_bg
>> -.\" feature.
>> +.\" feature, these two features are incompatible and
>> +.\" .B metadata_csum
>> +.\" will be used preferentially instead of
>> +.\" .BR uninit_bg .
>> .\" .br
>> .\" .B Future feature, available in e2fsprogs 1.43-WIP
>> .TP
>> @@ -719,11 +732,6 @@ and keep a high watermark for the unused inodes =
in a filesystem, to reduce
>> .BR e2fsck (8)
>> time.  The result is that it can speed up filesystem creation time =
noticeably
>> (if lazy_itable_init is enabled).
>> -.IP
>> -This first e2fsck run after enabling this feature will take the
>> -full time, but subsequent e2fsck runs will take only a fraction of =
the
>> -original time, depending on how full the file system is.
>> -It is only supported by the ext4 filesystem in recent Linux kernels.
>> .RE
>> .TP
>> .B \-q
>>=20
>=20


Cheers, Andreas






--Apple-Mail=_D978D374-905C-4D55-A0DE-48F73E21DBD1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUrDOmHKl2rkXzB/gAQILIw//a8ASTETO+++Mfk5+RWBRX2nTlg5dxoJd
qmLT2rSQjDJxgtS0VkJnGqeXj1Pp7kKJaTMsESq4giu2G9cyB/PrsNZYWRoDf/H/
x2j6yczJz302F2VjQRMQA9NMr74qjIak7Vezq5zI7tXr9doTkfrMRXAjHeN5mvh2
hzLUseH21Vs9tHhuTbZvYcNVfGpUgdgTHDtVvZ0fYZWLLnJ/Lf5Wu7NYQfmJSClC
isPQmnT+7UOThGoNgVXWvvJWKo8Lp8jPO5p0DSBTM7k+UceIYct0vc0VkW2WxzNJ
7PdnmKNAnnQ6GpuhetPZr4u/l593Rw7S5wdnX6XfokiJ9Z9dnmBeSrsOVIgS2jjW
6v630po9kR2gepkfeh9zC7Tib34SNAPiuua/vXtex8udM9L+znzptJoA3SGrNdi8
E7TLaxeJglTiEzYB690gGJP/UO/tdMIVPtpUghrgvznkGnUH0CKsn4v+VXA6znVL
4fazbSvO+O+CFopftBoJFH3lla3xm5vfSGzyEE/xap1Nwv2kZmYpZQ4OWkoDuTls
InIgwgyYKalJpHNAvzK7AR7szVPyA+pS3adFyHdUybGAGCPS20BAJZAdUkeTFvix
P8k+bEvlQoj4jzT0WEzckJYKrw3/s0T9pC2ZwsgPCKTtpmY90UUjXsWp5F2UDYDY
QG0hYE728n4=
=tvtt
-----END PGP SIGNATURE-----

--Apple-Mail=_D978D374-905C-4D55-A0DE-48F73E21DBD1--
