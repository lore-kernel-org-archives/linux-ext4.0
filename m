From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.2-rc2
Date: Sun, 12 Jul 2015 10:20:56 +0200
Message-ID: <55A22368.8010204@web.de>
References: <20150705215312.GE8628@thunk.org> <55A106EE.3050204@web.de> <20150711210659.GB11033@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:37815 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbbGLIVA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Jul 2015 04:21:00 -0400
In-Reply-To: <20150711210659.GB11033@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 07/11/2015 23:06:
> On Sat, Jul 11, 2015 at 02:07:10PM +0200, J=F6rg-Volker Peetz wrote:
<snip>
> I knew about the fact that you couldn't disable lazytime.  The issue
> is that nolazytime is getting intercepted by the 2.26.2 version of
> mount, so ext4 never sees it.  But if we interpret the lack of the
> lazytime flag in the mount flags passed in from the system call, then
> we would *always* disable the lazytime flag if the file system is
> remounted using a pre-2.26.2 version of mount.  Since a huge number o=
f
> Ubuntu LTS and Debian stable users (and probably a bunch of older
> Fedora users as well) will be using an older version of mount, I
> decided that best compromise is was to allow lazytime to be enabled
> using a 2.26.2+ version of mount via remount, but not to allow
> lazytime to be disabled.  With a pre-2.26.2 version of mount, you'll
> be able to enable or disable lazytime.
>=20
O.k. Thanks for the explanation.

> As far as switching atime modes using remount, this is working for me=
=2E
> I'm testing with both a 2.25.2 version of mount as found in Debian
> Jessie, as well as 2.26.2 version of mount using Debian Stretch. =20
>=20
>=20
> The issue not being able to change the atime, relatime, and noatime
> flags is a similar issue.  In pre-2.26.2 versions of mount, the atime=
,
> relatime, and noatime strings were passed to the kernel, which would
> then interpret the strings and the manipulate the=20
>=20
>=20
>> # strace -o /tmp/st mount -o remount,relatime /home
>> # grep ^mount /tmp/st
>> mount("/dev/sda2", "/home", 0x1543780, MS_REMOUNT|MS_RELATIME|MS_NOA=
TIME,
>> "nobarrier,errors=3Dremount-ro") =3D 0
>=20
> "MS_REMOUNT|MS_RELATIME|MS_NOATIME" looks wrong.  Here's what I'm
> seeing on my system:
>=20
> # strace -o /tmp/st mount -o remount,relatime /dev/sda3
> # grep sda3 /proc/mounts
> /dev/sda3 / ext4 rw,lazytime,relatime,errors=3Dremount-ro,data=3Dorde=
red 0 0
> # grep MS_REMOUNT /tmp/st
> mount("/dev/sda3", "/", 0x1148230, MS_REMOUNT|MS_RELATIME|0x2000000, =
"errors=3Dremount-ro") =3D 0
> # strace -o /tmp/st mount -o remount,noatime /dev/sda3
> # grep sda3 /proc/mounts
> /dev/sda3 / ext4 rw,lazytime,noatime,errors=3Dremount-ro,data=3Dorder=
ed 0 0
> # grep MS_REMOUNT /tmp/st
> mount("/dev/sda3", "/", 0x1458230, MS_REMOUNT|MS_NOATIME|0x2000000, "=
errors=3Dremount-ro") =3D 0
> # mount --version
> mount from util-linux 2.26.2 (libmount 2.26.0: selinux, assert, debug=
)
> # dpkg -l mount
> Desired=3DUnknown/Install/Remove/Purge/Hold
> | Status=3DNot/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWai=
t/Trig-pend
> |/ Err?=3D(none)/Reinst-required (Status,Err: uppercase=3Dbad)
> ||/ Name                Version        Architecture   Description
> +++-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D-=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> ii  mount               2.26.2-6       amd64          Tools for mount=
ing and manipulating filesys
>=20
>     				       		      - Ted
On my Debian stretch/sid systems there is:

# mount --version
mount from util-linux 2.26.2 (libmount 2.26.0: selinux, assert, debug)

# dpkg -l mount libmount1 libblkid1 libc6 libselinux1
Desired=3DUnknown/Install/Remove/Purge/Hold
| Status=3DNot/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/=
Trig-pend
|/ Err?=3D(none)/Reinst-required (Status,Err: uppercase=3Dbad)
||/ Name           Version      Architecture Description
+++-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D-=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D-=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
ii  libblkid1:amd6 2.26.2-6     amd64        block device id library
ii  libc6:amd64    2.19-18      amd64        GNU C Library: Shared libr=
aries
ii  libmount1:amd6 2.26.2-6     amd64        device mounting library
ii  libselinux1:am 2.3-2+b1     amd64        SELinux runtime shared lib=
raries
ii  mount          2.26.2-6     amd64        Tools for mounting and man=
ipulati

I'm using kernel 4.1.2 plus two of your patches, but get the same outpu=
t on a
system with a standard Debian kernel linux-image-4.0.0-2-amd64.
--=20
Regards,
J=F6rg.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
