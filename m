From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Thu, 11 Sep 2014 15:50:22 -0700
Message-ID: <20140911225022.GA10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911223347.GH17990@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29341 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbaIKWu1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 18:50:27 -0400
Content-Disposition: inline
In-Reply-To: <20140911223347.GH17990@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 06:33:47PM -0400, Theodore Ts'o wrote:
> ... and I've pushed out the next branch with all but 23-26 applied.
>=20
> Darrick, can you take a look and see if everything landed as you
> expect?
>=20
> 23-25 is a new feature (pending comments on 23, and I remember wantin=
g
> to take a much closer look at 24 and 25 from a month or two ago), and
> 26 is pending some comments I had vis-a-vis ext2fs_new_block() vs
> ext2fs_get_block(), so if you want to send out patchbomb part 6 with
> what's left of part 5, that might be appropriate.
>=20
> Thanks for all of your work on e2fsprogs!

Looks like most everything landed ok except for:

Yikes, make check explodes:

make[1]: Entering directory `/storage/home/djwong/cdev/work/e2fsprogs-c=
sum/lib/ext2fs'
        SUBST ../../lib/dirpaths.h
        SUBST ext2_err.et
        CC ../../debugfs/journal.c
In file included from ./kernel-jbd.h:23:0,
                 from ./jfs_user.h:6,
                 from ../../debugfs/journal.c:26:
=2E/jfs_compat.h:33:1: error: unknown type name =E2=80=98__u64=E2=80=99
 typedef __u64 u64;
 ^
=2E/jfs_compat.h:39:1: error: unknown type name =E2=80=98__u32=E2=80=99
 static inline __u32 jbd2_chksum(journal_t *j, __u32 crc, const void *a=
ddress,
 ^
=2E/jfs_compat.h:39:47: error: unknown type name =E2=80=98__u32=E2=80=99
 static inline __u32 jbd2_chksum(journal_t *j, __u32 crc, const void *a=
ddress,
                                               ^
=2E/jfs_compat.h:77:2: error: unknown type name =E2=80=98__u8=E2=80=99
  __u8   j_uuid[16];
  ^
=2E/jfs_compat.h:81:2: error: unknown type name =E2=80=98__u32=E2=80=99
<continues on for 1000 more lines>

--D

>=20
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
