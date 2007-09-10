From: Alex Tomas <alex@clusterfs.com>
Subject: Re: file fragmentation with mballoc+delalloc options
Date: Mon, 10 Sep 2007 18:51:51 +0400
Message-ID: <46E55A07.8060602@clusterfs.com>
References: <46E554B2.8060202@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.244.250]:35296 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbXIJOw1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2007 10:52:27 -0400
In-Reply-To: <46E554B2.8060202@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

thanks for the report.

couple things:
1) delalloc in the tree isn't integrated with mballoc yet
2) something went wrong with mballoc i'm going look at.

thanks, Alex

Valerie Clement wrote:
> There is another thing that looks strange to me.
> Files created on an ext4 filesystem mounted with the mballoc and=20
> delalloc options seem to be more fragmented than those created on a=20
> filesystem mounted with only the delalloc option or mounted with only=
=20
> the mballoc option. Removing large files in the first case takes more=
=20
> time than in the 2 last cases.
>=20
> Here are the small tests I did then (2.6.23-rc4 kernel + latest ext4 =
git=20
> patches):
> # mkfs.ext3 -I 256 /dev/sdc
> # mount -t ext4dev -o mballoc,delalloc,data=3Dwriteback /dev/sdc /mnt=
/test
> # dd if=3D/dev/zero of=3D/mnt/test/foo bs=3D1M count=3D128
> # sync
> # filefrag /mnt/test/foo
>   File is stored in extents format
>   /mnt/test/foo: 62 extents found
>=20
> # mkfs.ext3 -I 256 /dev/sdc
> # mount -t ext4dev -o delalloc,data=3Dwriteback /dev/sdc /mnt/test
> # dd if=3D/dev/zero of=3D/mnt/test/foo bs=3D1M count=3D128
> # sync
> # filefrag /mnt/test/foo
>   File is stored in extents format
>   /mnt/test/foo: 2 extents found
>=20
> # mkfs.ext3 -I 256 /dev/sdc
> # mount -t ext4dev -o mballoc,data=3Dwriteback /dev/sdc /mnt/test
> # dd if=3D/dev/zero of=3D/mnt/test/foo bs=3D1M count=3D128
> # sync
> # filefrag /mnt/test/foo
>   File is stored in extents format
>   /mnt/test/foo: 2 extents found
>=20
>=20
>=20
> Here is the output of "filefrag -v" when the filesystem is mounted wi=
th=20
> mballoc and delalloc options:
>=20
> # filefrag -v /mnt/test/foo
> Checking /mnt/test/foo
> Filesystem type is: ef53
> Filesystem cylinder groups is approximately 529
> File is stored in extents format
> Blocksize of file /mnt/test/foo is 4096
> File size of /mnt/test/foo is 134217728 (32768 blocks)
> First block: 37120
> Last block: 72191
> Discontinuity: Block 1024 is at 38400 (was 38143)
> Discontinuity: Block 1036 is at 57344 (was 38411)
> Discontinuity: Block 2048 is at 38412 (was 58355)
> Discontinuity: Block 2072 is at 61440 (was 38435)
> Discontinuity: Block 3072 is at 38436 (was 62439)
> Discontinuity: Block 3108 is at 62440 (was 38471)
> Discontinuity: Block 4096 is at 38472 (was 63427)
> Discontinuity: Block 4144 is at 63428 (was 38519)
> Discontinuity: Block 5120 is at 38520 (was 64403)
> Discontinuity: Block 5180 is at 64404 (was 38579)
> Discontinuity: Block 6144 is at 38580 (was 65367)
> Discontinuity: Block 6216 is at 59392 (was 38651)
> Discontinuity: Block 7168 is at 38652 (was 60343)
> Discontinuity: Block 7252 is at 60344 (was 38735)
> Discontinuity: Block 8192 is at 38736 (was 61283)
> Discontinuity: Block 8288 is at 65368 (was 38831)
> Discontinuity: Block 8448 is at 38144 (was 65527)
> Discontinuity: Block 8704 is at 58624 (was 38399)
> Discontinuity: Block 9216 is at 38912 (was 59135)
> Discontinuity: Block 9324 is at 61284 (was 39019)
> Discontinuity: Block 9472 is at 59136 (was 61431)
> Discontinuity: Block 9728 is at 39424 (was 59391)
> Discontinuity: Block 10240 is at 39020 (was 39935)
> Discontinuity: Block 10360 is at 58369 (was 39139)
> Discontinuity: Block 10496 is at 39936 (was 58504)
> Discontinuity: Block 11264 is at 39140 (was 40703)
> Discontinuity: Block 11396 is at 49152 (was 39271)
> Discontinuity: Block 12288 is at 39272 (was 50043)
> Discontinuity: Block 12432 is at 58505 (was 39415)
> Discontinuity: Block 12544 is at 40704 (was 58616)
> Discontinuity: Block 13468 is at 53248 (was 41627)
> Discontinuity: Block 14336 is at 41628 (was 54115)
> Discontinuity: Block 14504 is at 55296 (was 41795)
> Discontinuity: Block 15360 is at 41796 (was 56151)
> Discontinuity: Block 15540 is at 56152 (was 41975)
> Discontinuity: Block 16384 is at 41984 (was 56995)
> Discontinuity: Block 16576 is at 36928 (was 42175)
> Discontinuity: Block 16640 is at 57088 (was 36991)
> Discontinuity: Block 16896 is at 42496 (was 57343)
> Discontinuity: Block 17408 is at 42176 (was 43007)
> Discontinuity: Block 17612 is at 56996 (was 42379)
> Discontinuity: Block 17664 is at 50176 (was 57047)
> Discontinuity: Block 18432 is at 54272 (was 50943)
> Discontinuity: Block 18648 is at 57048 (was 54487)
> Discontinuity: Block 18688 is at 50944 (was 57087)
> Discontinuity: Block 19456 is at 54488 (was 51711)
> Discontinuity: Block 19684 is at 54116 (was 54715)
> Discontinuity: Block 19712 is at 51712 (was 54143)
> Discontinuity: Block 20480 is at 52736 (was 52479)
> Discontinuity: Block 20720 is at 36912 (was 52975)
> Discontinuity: Block 20736 is at 52480 (was 36927)
> Discontinuity: Block 20992 is at 54784 (was 52735)
> Discontinuity: Block 21504 is at 52976 (was 55295)
> Discontinuity: Block 21756 is at 36908 (was 53227)
> Discontinuity: Block 21760 is at 43008 (was 36911)
> Discontinuity: Block 22792 is at 45056 (was 44039)
> Discontinuity: Block 23808 is at 44040 (was 46071)
> Discontinuity: Block 23828 is at 47104 (was 44059)
> Discontinuity: Block 25856 is at 44544 (was 49131)
> Discontinuity: Block 26368 is at 46080 (was 45055)
> Discontinuity: Block 27392 is at 66816 (was 47103)
> /mnt/test/foo: 62 extents found
>=20
> What do you think about this?
>   Val=E9rie
>=20
