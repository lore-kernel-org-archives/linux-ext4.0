From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Fri, 25 Sep 2009 01:35:46 -0600
Message-ID: <20090925073546.GJ10562@webber.adilger.int>
References: <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
 <20090828221432.GS4197@webber.adilger.int>
 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
 <20090830025250.GA25768@mit.edu>
 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
 <20090831215612.GG4197@webber.adilger.int>
 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
 <20090902084134.GO4197@webber.adilger.int>
 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
 <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59458 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZIYHfu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Sep 2009 03:35:50 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8P7Zqx9016127
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 00:35:52 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQI00H00NK2O100@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 25 Sep 2009 00:35:52 -0700 (PDT)
In-reply-to: <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 23, 2009  22:27 -0700, Jiaying Zhang wrote:
> Sorry for taking so long to finish this. Here is the new patch based =
on
> Andreas's suggestions. Now the patch clears the EXT4_EOFBLOCKS_FL
> flag when we allocate beyond the maximum allocated block. I also
> made the EOFBLOCKS flag user visible and added the handling
> in ext4_ioctl as Andrea suggested.
>=20
> Index: linux-2.6.30.5/include/linux/fs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +#define FS_EOFBLOCKS_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x00200000 /* B=
locks allocated beyond EOF */

Can you please use 0x00400000 here.  I've already asked Ted to reserve
the 0x0020000 inode flag for use by large extended attributes.

> =A0#define FS_RESERVED_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x80000000 /* =
reserved for ext2 lib */
>=20
> -#define FS_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x0003DFFF /* User vis=
ible flags */
> +#define FS_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x0023DFFF /* User vis=
ible flags */

This would need to be changed to 0x0043DFFF to match.

Sorry, I haven't looked at the rest of the patch yet, just thought I'd
mention this early on.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
