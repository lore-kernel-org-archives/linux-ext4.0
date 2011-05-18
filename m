From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Wed, 18 May 2011 13:42:34 -0700
Message-ID: <BANLkTi=UzYsLOj8jbfp_wq-r_rFaTU3AAg@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
	<4DD33AA9.9060104@redhat.com>
	<20110518061356.GY19446@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1ERUmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 16:42:38 -0400
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id p4IKgasC027297
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:42:37 -0700
Received: from gxk10 (gxk10.prod.google.com [10.202.11.10])
	by hpaq6.eem.corp.google.com with ESMTP id p4IKeg23026852
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:42:35 -0700
Received: by gxk10 with SMTP id 10so952930gxk.11
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:42:35 -0700 (PDT)
In-Reply-To: <20110518061356.GY19446@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 11:13 PM, Dave Chinner <david@fromorbit.com> wr=
ote:
> On Tue, May 17, 2011 at 10:19:05PM -0500, Eric Sandeen wrote:
>> On 5/17/11 5:59 PM, Jiaying Zhang wrote:
>> > There is a bug in commit c8d46e41 "ext4: Add flag to files with bl=
ocks
>> > intentionally past EOF" that if we fallocate a file with FALLOC_FL=
_KEEP_SIZE
>> > flag and then ftruncate the file to a size larger than the file's =
i_size,
>> > any allocated but unwritten blocks will be freed but the file size=
 is set
>> > to the size that ftruncate specifies.
>> >
>> > Here is a simple test to reproduce the problem:
>> > =A0 1. fallocate a 12k size file with KEEP_SIZE flag
>> > =A0 2. write the first 4k
>> > =A0 3. ftruncate the file to 8k
>> > Then 'ls -l' shows that the i_size of the file becomes 8k but debu=
gfs
>> > shows the file has only the first written block left.
>>
>> To be honest I'm not 100% certain what the fiesystem -should- do in =
this case.
>>
>> If I go through that same sequence on xfs, I get 4k written / 8k unw=
ritten:
>>
>> # xfs_bmap -vp testfile
>> testfile:
>> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =A0 =A0AG=
 AG-OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0TOTAL FLAGS
>> =A0 =A00: [0..7]: =A0 =A0 =A0 =A0 =A02648750760..2648750767 =A03 (35=
6066400..356066407) =A0 =A0 8 00000
>> =A0 =A01: [8..23]: =A0 =A0 =A0 =A0 2648750768..2648750783 =A03 (3560=
66408..356066423) =A0 =A016 10000
>
> Ok, so that's the case for a _truncate up_ from 4k to 8k:
>
> $ rm /mnt/test/foo
> $ xfs_io -f -c "resvsp 0 12k" -c stat -c "bmap -vp" -c "pwrite 0 4k" =
-c "fsync" -c "bmap -vp" -c "t 8k" -c "bmap -vp" -c stat /mnt/test/foo
> fd.path =3D "/mnt/test/foo"
> fd.flags =3D non-sync,non-direct,read-write
> stat.ino =3D 71
> stat.type =3D regular file
> stat.size =3D 0
> stat.blocks =3D 24
> fsxattr.xflags =3D 0x2 [-p------------]
> fsxattr.projid =3D 0
> fsxattr.extsize =3D 0
> fsxattr.nextents =3D 1
> fsxattr.naextents =3D 0
> dioattr.mem =3D 0x200
> dioattr.miniosz =3D 512
> dioattr.maxiosz =3D 2147483136
> /mnt/test/foo:
> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0AG AG-OFFSET =A0=
 =A0 =A0 =A0TOTAL FLAGS
> =A0 0: [0..23]: =A0 =A0 =A0 =A0 9712..9735 =A0 =A0 =A0 =A00 (9712..97=
35) =A0 =A0 =A0 =A024 10000
> wrote 4096/4096 bytes at offset 0
> 4 KiB, 1 ops; 0.0000 sec (156 MiB/sec and 40000.0000 ops/sec)
> /mnt/test/foo:
> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0AG AG-OFFSET =A0=
 =A0 =A0 =A0TOTAL FLAGS
> =A0 0: [0..7]: =A0 =A0 =A0 =A0 =A09712..9719 =A0 =A0 =A0 =A00 (9712..=
9719) =A0 =A0 =A0 =A0 8 00000
> =A0 1: [8..23]: =A0 =A0 =A0 =A0 9720..9735 =A0 =A0 =A0 =A00 (9720..97=
35) =A0 =A0 =A0 =A016 10000
> /mnt/test/foo:
> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0AG AG-OFFSET =A0=
 =A0 =A0 =A0TOTAL FLAGS
> =A0 0: [0..7]: =A0 =A0 =A0 =A0 =A09712..9719 =A0 =A0 =A0 =A00 (9712..=
9719) =A0 =A0 =A0 =A0 8 00000
> =A0 1: [8..23]: =A0 =A0 =A0 =A0 9720..9735 =A0 =A0 =A0 =A00 (9720..97=
35) =A0 =A0 =A0 =A016 10000
> fd.path =3D "/mnt/test/foo"
> fd.flags =3D non-sync,non-direct,read-write
> stat.ino =3D 71
> stat.type =3D regular file
> stat.size =3D 8192
> stat.blocks =3D 24
> fsxattr.xflags =3D 0x2 [-p------------]
> fsxattr.projid =3D 0
> fsxattr.extsize =3D 0
> fsxattr.nextents =3D 2
> fsxattr.naextents =3D 0
> dioattr.mem =3D 0x200
> dioattr.miniosz =3D 512
> dioattr.maxiosz =3D 2147483136
>
> But you get a different result on truncate down:
>
> $rm /mnt/test/foo
> $ xfs_io -f -c "truncate 12k" -c "resvsp 0 12k" -c stat -c "bmap -vp"=
 -c "pwrite 0 4k" -c "fsync" -c "bmap -vp" -c "t 8k" -c "bmap -vp" -c s=
tat /mnt/test/foo
> fd.path =3D "/mnt/test/foo"
> fd.flags =3D non-sync,non-direct,read-write
> stat.ino =3D 71
> stat.type =3D regular file
> stat.size =3D 12288
> stat.blocks =3D 24
> fsxattr.xflags =3D 0x2 [-p------------]
> fsxattr.projid =3D 0
> fsxattr.extsize =3D 0
> fsxattr.nextents =3D 1
> fsxattr.naextents =3D 0
> dioattr.mem =3D 0x200
> dioattr.miniosz =3D 512
> dioattr.maxiosz =3D 2147483136
> /mnt/test/foo:
> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0AG AG-OFFSET =A0=
 =A0 =A0 =A0TOTAL FLAGS
> =A0 0: [0..23]: =A0 =A0 =A0 =A0 9584..9607 =A0 =A0 =A0 =A00 (9584..96=
07) =A0 =A0 =A0 =A024 10000
> wrote 4096/4096 bytes at offset 0
> 4 KiB, 1 ops; 0.0000 sec (217.014 MiB/sec and 55555.5556 ops/sec)
> /mnt/test/foo:
> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0AG AG-OFFSET =A0=
 =A0 =A0 =A0TOTAL FLAGS
> =A0 0: [0..7]: =A0 =A0 =A0 =A0 =A09584..9591 =A0 =A0 =A0 =A00 (9584..=
9591) =A0 =A0 =A0 =A0 8 00000
> =A0 1: [8..23]: =A0 =A0 =A0 =A0 9592..9607 =A0 =A0 =A0 =A00 (9592..96=
07) =A0 =A0 =A0 =A016 10000
> /mnt/test/foo:
> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0AG AG-OFFSET =A0=
 =A0 =A0 =A0TOTAL FLAGS
> =A0 0: [0..7]: =A0 =A0 =A0 =A0 =A09584..9591 =A0 =A0 =A0 =A00 (9584..=
9591) =A0 =A0 =A0 =A0 8 00000
> =A0 1: [8..15]: =A0 =A0 =A0 =A0 9592..9599 =A0 =A0 =A0 =A00 (9592..95=
99) =A0 =A0 =A0 =A0 8 10000
> fd.path =3D "/mnt/test/foo"
> fd.flags =3D non-sync,non-direct,read-write
> stat.ino =3D 71
> stat.type =3D regular file
> stat.size =3D 8192
> stat.blocks =3D 16
> fsxattr.xflags =3D 0x2 [-p------------]
> fsxattr.projid =3D 0
> fsxattr.extsize =3D 0
> fsxattr.nextents =3D 2
> fsxattr.naextents =3D 0
> dioattr.mem =3D 0x200
> dioattr.miniosz =3D 512
> dioattr.maxiosz =3D 2147483136
>
> IOWs, on XFS a truncate up does not change the preallocation at all,
> while a truncate down will _always_ remove preallocation beyond the
> new EOF. =A0It's always had this behaviour w.r.t. to truncate(2) and
> preallocation beyond EOF.
>
>> I think this is a different result from ext4, either with or without=
 your patch.
>>
>> On ext4 I get size 8k, but only the first 4k mapped, as you say.
>>
>> I don't recall when truncate is supposed to free fallocated blocks, =
and from what point?
>
> It's entirely up to the filesystem how it treats blocks beyond EOF
> during truncation. XFS frees them on truncate down, because it is
> much safer to just truncate away everything beyond the new EOF than
> to leave written extents beyond EOF as potential landmines.
>
> Indeed, that's why calling vmtruncate() as a bad fix. If you have:
>
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NUUUUUUUUUUWWWWWWWWWOUUUUUUUUU
> =A0 =A0 =A0 ....----+----------+--------+--------+
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 A =A0 =A0 =A0 =A0 =A0B =A0 =A0 =A0 =A0C =A0=
 =A0 =A0 =A0D
>
> Where =A0 A =3D new EOF (N)
> =A0 =A0 =A0 =A0A->B =3D unwritten (U)
> =A0 =A0 =A0 =A0B->C =3D written (W)
> =A0 =A0 =A0 =A0C =3D old EOF (O)
> =A0 =A0 =A0 =A0C->D =3D unwritten (U)
>
> Then just calling vmtruncate() will leave the blocks in the range
> B->C as written blocks. Hence then doing an extending truncate back
> out to D will expose stale data rather than zeros in the range
> B->C....
Sorry I am a little confused. If I understand correctly, in the situati=
on
you described, we call a truncate that causes EOF to change from
C to A. On ext4, we should free all of blocks after A. And when we
do an extending truncate to D, any blocks beyond A should be treated
as unwritten blocks so we should not expose any stale data, right?

Jiaying
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
