From: Andreas Dilger <adilger@sun.com>
Subject: Re: >16TB issues
Date: Tue, 21 Jul 2009 10:10:18 -0600
Message-ID: <20090721161018.GH4231@webber.adilger.int>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
 <20090703143729.GJ20343@webber.adilger.int>
 <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47501 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZGUQK7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 12:10:59 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6LGAq3A002003
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 09:10:52 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN500B00379HB00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 21 Jul 2009 09:10:52 -0700 (PDT)
In-reply-to: <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 16, 2009  11:04 -0700, Justin Maggard wrote:
> On Fri, Jul 3, 2009 at 7:38 AM, Andreas Dilger<adilger@sun.com> wrote=
:
> >> - =A0Immediately running e2fsck on the volume before ever mounting=
 it
> >> will not complete, and results in the following:
> >> # e2fsck -n /dev/md2
> >> e2fsck 1.41.7 (29-June-2009)
> >> Error reading block 2435874816 (Attempt to read block from filesys=
tem
> >> resulted in short read). =A0Ignore error? no
>=20
> Error reading block 576192512 (Attempt to read block from filesystem
> resulted in short read) while reading inode and block bitmaps.  Ignor=
e
> error? no
>=20
> e2fsck: Can't read an block bitmap while retrying to read bitmaps for=
 /dev/md2
> e2fsck: aborted

What is very strange here is that the block numbers being reported as
having read errors are not even beyond the 16TB limit.  Assuming 4kB bl=
ocks:

576192512 * 4kB =3D 2304770048kB =3D 2198GB

Are there error messages in syslog/dmesg when this happens?

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
