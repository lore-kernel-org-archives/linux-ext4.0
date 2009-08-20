From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Compile error in pu branch of e2fsprogs.
Date: Thu, 20 Aug 2009 12:04:58 -0400
Message-ID: <8693.1250784298@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:32640 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZHTQE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 12:04:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I got this error when trying to build the pu branch of e2fsprogs:

,----
|         ...
| 	CC ../../misc/e4defrag.c
| ../../misc/e4defrag.c:326:2: warning: #warning Using locally defined =
fallocate syscall interface.
| ../../misc/e4defrag.c: In function =E2=80=98file_frag_count=E2=80=99:
| ../../misc/e4defrag.c:627: error: =E2=80=98FS_IOC_FIEMAP=E2=80=99 und=
eclared (first use in this function)
| ../../misc/e4defrag.c:627: error: (Each undeclared identifier is repo=
rted only once
| ../../misc/e4defrag.c:627: error: for each function it appears in.)
| ../../misc/e4defrag.c: In function =E2=80=98get_file_extents=E2=80=99=
:
| ../../misc/e4defrag.c:940: error: =E2=80=98FS_IOC_FIEMAP=E2=80=99 und=
eclared (first use in this function)
| make[2]: *** [e4defrag.o] Error 1
| make[2]: Leaving directory `/home/nick/src/e2fsprogs/build/misc'
| make[1]: *** [all-progs-recursive] Error 1
| make[1]: Leaving directory `/home/nick/src/e2fsprogs/build'
| make: *** [all] Error 2
| nick@shifter:~/src/e2fsprogs/build$ uname -r
| 2.6.31-rc6
`----

Currently, the #define is in filefrag.c:

,----
| nick@shifter:~/src/e2fsprogs$ find . -type f | xargs grep FS_IOC
| ./misc/filefrag.c:#define FS_IOC_FIEMAP	_IOWR('f', 11, struct fiemap)
| ./misc/filefrag.c:		rc =3D ioctl(fd, FS_IOC_FIEMAP, (unsigned long) f=
iemap);
| ./misc/e4defrag.c:/* The following macro is used for ioctl FS_IOC_FIE=
MAP
| ./misc/e4defrag.c:	ret =3D ioctl(fd, FS_IOC_FIEMAP, &fiemap_buf);
| ./misc/e4defrag.c:		ret =3D ioctl(fd, FS_IOC_FIEMAP, fiemap_buf);
| ./lib/ext2fs/fiemap.h: * FS_IOC_FIEMAP ioctl infrastructure.
`----

I moved it from there to lib/ext2fs/fiemap.h and that fixes it.

Thanks,
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
