From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix configure.in typo
Date: Wed, 21 Oct 2009 10:21:53 -0500
Message-ID: <4ADF2711.50405@redhat.com>
References: <4ADE8477.2070906@redhat.com> <20091021075232.GA9574@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbZJUPVu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Oct 2009 11:21:50 -0400
In-Reply-To: <20091021075232.GA9574@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

>> (note; with this, once I try to build w/ a new libblkid, I still
>> get a mkfs build error ... it's still picking up the in-tree blkid
>> headers)
>=20
> Hmmm... which in-tree header files is it picking up?  And what error
> are you seeing?
>=20
> There are a few header files that I can see that we should probably
> clean-up, but they don't look like they should be problematic.
>=20
> build.static/lib/blkid/blkid_types.h -- just simple type definitions
> lib/blkid/blkidP.h ---  only used by lib/blkid/*.c
> lib/blkid/list.h --- only used by lib/blkid/*.c
> lib/blkid/probe.h -- only used by lib/blkid/probe.c

making all in misc
make[2]: Entering directory `/src/git/e2fsprogs/misc'
gcc -c -I../lib -I../lib \
<snip> \
-g -O2 -I./../e2fsck -I.    mke2fs.c -o mke2fs.o
mke2fs.c: In function =91ext2fs_get_device_geometry=92:
mke2fs.c:1033: error: =91blkid_probe=92 undeclared (first use in this f=
unction)
mke2fs.c:1033: error: (Each undeclared identifier is reported only once
mke2fs.c:1033: error: for each function it appears in.)
mke2fs.c:1033: error: expected =91;=92 before =91pr=92
mke2fs.c:1034: error: =91blkid_topology=92 undeclared (first use in thi=
s
function)
mke2fs.c:1034: error: expected =91;=92 before =91tp=92
mke2fs.c:1038: error: =91pr=92 undeclared (first use in this function)
mke2fs.c:1042: error: =91tp=92 undeclared (first use in this function)
make[2]: *** [mke2fs.o] Error 1
make[2]: Leaving directory `/src/git/e2fsprogs/misc'
make[1]: *** [all-progs-recursive] Error 1
make[1]: Leaving directory `/src/git/e2fsprogs'
make: *** [all] Error 2

seems like it's not picking up the system /usr/include/blkid/blkid.h bu=
t
rather e2fsprogs/lib/blkid/blkid.h

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
