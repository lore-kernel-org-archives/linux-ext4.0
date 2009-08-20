From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Compile error in pu branch of e2fsprogs.
Date: Thu, 20 Aug 2009 11:13:50 -0500
Message-ID: <4A8D763E.8040603@redhat.com>
References: <8693.1250784298@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbZHTQNx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Aug 2009 12:13:53 -0400
In-Reply-To: <8693.1250784298@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos wrote:
> Hi Ted,
>=20
> I got this error when trying to build the pu branch of e2fsprogs:
>=20
> ,----
> |         ...
> | 	CC ../../misc/e4defrag.c
> | ../../misc/e4defrag.c:326:2: warning: #warning Using locally define=
d fallocate syscall interface.
> | ../../misc/e4defrag.c: In function =E2=80=98file_frag_count=E2=80=99=
:
> | ../../misc/e4defrag.c:627: error: =E2=80=98FS_IOC_FIEMAP=E2=80=99 u=
ndeclared (first use in this function)
> | ../../misc/e4defrag.c:627: error: (Each undeclared identifier is re=
ported only once
> | ../../misc/e4defrag.c:627: error: for each function it appears in.)
> | ../../misc/e4defrag.c: In function =E2=80=98get_file_extents=E2=80=99=
:
> | ../../misc/e4defrag.c:940: error: =E2=80=98FS_IOC_FIEMAP=E2=80=99 u=
ndeclared (first use in this function)
> | make[2]: *** [e4defrag.o] Error 1
> | make[2]: Leaving directory `/home/nick/src/e2fsprogs/build/misc'
> | make[1]: *** [all-progs-recursive] Error 1
> | make[1]: Leaving directory `/home/nick/src/e2fsprogs/build'
> | make: *** [all] Error 2
> | nick@shifter:~/src/e2fsprogs/build$ uname -r
> | 2.6.31-rc6
> `----
>=20
> Currently, the #define is in filefrag.c:
>=20
> ,----
> | nick@shifter:~/src/e2fsprogs$ find . -type f | xargs grep FS_IOC
> | ./misc/filefrag.c:#define FS_IOC_FIEMAP	_IOWR('f', 11, struct fiema=
p)
> | ./misc/filefrag.c:		rc =3D ioctl(fd, FS_IOC_FIEMAP, (unsigned long)=
 fiemap);
> | ./misc/e4defrag.c:/* The following macro is used for ioctl FS_IOC_F=
IEMAP
> | ./misc/e4defrag.c:	ret =3D ioctl(fd, FS_IOC_FIEMAP, &fiemap_buf);
> | ./misc/e4defrag.c:		ret =3D ioctl(fd, FS_IOC_FIEMAP, fiemap_buf);
> | ./lib/ext2fs/fiemap.h: * FS_IOC_FIEMAP ioctl infrastructure.
> `----
>=20
> I moved it from there to lib/ext2fs/fiemap.h and that fixes it.

I guess that's my fault due to
http://git.kernel.org/?p=3Dfs/ext2/e2fsprogs.git;a=3Dcommitdiff;h=3D4f1=
d0e8608ddf488316dffbe4cd9993bf3b22084

Would it be better to move the ioctl definition into one place, maybe
our local copy of fiemap.h?

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
