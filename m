From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.2-rc2
Date: Sat, 11 Jul 2015 17:06:59 -0400
Message-ID: <20150711210659.GB11033@thunk.org>
References: <20150705215312.GE8628@thunk.org>
 <55A106EE.3050204@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52794 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbbGKVHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jul 2015 17:07:31 -0400
Content-Disposition: inline
In-Reply-To: <55A106EE.3050204@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 11, 2015 at 02:07:10PM +0200, J=F6rg-Volker Peetz wrote:
>=20
> Hi Ted,
>=20
> I'm testing this patch and "ext4: set lazytime on remount if MS_LAZYT=
IME is set
> by mount" on top of stable kernel 4.1.2.
>=20
> So far no problems with lazytime enabled. Thanks for that :-)
>=20
> But remounting with mount version 2.26.2 sucks. As promised, lazytime=
 can be
> enabled. But disabling it or trying to switch between atime, relatime=
, and
> noatime doesn't work.

I knew about the fact that you couldn't disable lazytime.  The issue
is that nolazytime is getting intercepted by the 2.26.2 version of
mount, so ext4 never sees it.  But if we interpret the lack of the
lazytime flag in the mount flags passed in from the system call, then
we would *always* disable the lazytime flag if the file system is
remounted using a pre-2.26.2 version of mount.  Since a huge number of
Ubuntu LTS and Debian stable users (and probably a bunch of older
=46edora users as well) will be using an older version of mount, I
decided that best compromise is was to allow lazytime to be enabled
using a 2.26.2+ version of mount via remount, but not to allow
lazytime to be disabled.  With a pre-2.26.2 version of mount, you'll
be able to enable or disable lazytime.

As far as switching atime modes using remount, this is working for me.
I'm testing with both a 2.25.2 version of mount as found in Debian
Jessie, as well as 2.26.2 version of mount using Debian Stretch. =20


The issue not being able to change the atime, relatime, and noatime
flags is a similar issue.  In pre-2.26.2 versions of mount, the atime,
relatime, and noatime strings were passed to the kernel, which would
then interpret the strings and the manipulate the=20


> # strace -o /tmp/st mount -o remount,relatime /home
> # grep ^mount /tmp/st
> mount("/dev/sda2", "/home", 0x1543780, MS_REMOUNT|MS_RELATIME|MS_NOAT=
IME,
> "nobarrier,errors=3Dremount-ro") =3D 0

"MS_REMOUNT|MS_RELATIME|MS_NOATIME" looks wrong.  Here's what I'm
seeing on my system:

# strace -o /tmp/st mount -o remount,relatime /dev/sda3
# grep sda3 /proc/mounts
/dev/sda3 / ext4 rw,lazytime,relatime,errors=3Dremount-ro,data=3Dordere=
d 0 0
# grep MS_REMOUNT /tmp/st
mount("/dev/sda3", "/", 0x1148230, MS_REMOUNT|MS_RELATIME|0x2000000, "e=
rrors=3Dremount-ro") =3D 0
# strace -o /tmp/st mount -o remount,noatime /dev/sda3
# grep sda3 /proc/mounts
/dev/sda3 / ext4 rw,lazytime,noatime,errors=3Dremount-ro,data=3Dordered=
 0 0
# grep MS_REMOUNT /tmp/st
mount("/dev/sda3", "/", 0x1458230, MS_REMOUNT|MS_NOATIME|0x2000000, "er=
rors=3Dremount-ro") =3D 0
# mount --version
mount from util-linux 2.26.2 (libmount 2.26.0: selinux, assert, debug)
# dpkg -l mount
Desired=3DUnknown/Install/Remove/Purge/Hold
| Status=3DNot/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/=
Trig-pend
|/ Err?=3D(none)/Reinst-required (Status,Err: uppercase=3Dbad)
||/ Name                Version        Architecture   Description
+++-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D-=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ii  mount               2.26.2-6       amd64          Tools for mountin=
g and manipulating filesys

    				       		      - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
