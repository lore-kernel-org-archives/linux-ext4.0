From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.2-rc2
Date: Sat, 11 Jul 2015 14:07:10 +0200
Message-ID: <55A106EE.3050204@web.de>
References: <20150705215312.GE8628@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47212 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbbGKMHS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jul 2015 08:07:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1ZDtYp-0001fH-Hl
	for linux-ext4@vger.kernel.org; Sat, 11 Jul 2015 14:07:15 +0200
Received: from p4fdf09f2.dip0.t-ipconnect.de ([79.223.9.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 11 Jul 2015 14:07:15 +0200
Received: from jvpeetz by p4fdf09f2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 11 Jul 2015 14:07:15 +0200
In-Reply-To: <20150705215312.GE8628@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 07/05/2015 23:53:
> The following changes since commit a2fd66d069d86d793e9d39d4079b96f46d=
13f237:
>=20
>   ext4: set lazytime on remount if MS_LAZYTIME is set by mount (2015-=
06-23 11:03:54 -0400)
>=20
<snip>

Hi Ted,

I'm testing this patch and "ext4: set lazytime on remount if MS_LAZYTIM=
E is set
by mount" on top of stable kernel 4.1.2.

So far no problems with lazytime enabled. Thanks for that :-)

But remounting with mount version 2.26.2 sucks. As promised, lazytime c=
an be
enabled. But disabling it or trying to switch between atime, relatime, =
and
noatime doesn't work.

Starting from

# grep sda /proc/mounts
/dev/sda2 /home ext4 rw,lazytime,noatime,nobarrier,errors=3Dremount-ro =
0 0

some strace output:

# strace -o /tmp/st mount -o remount,nolazytime /home
# grep ^mount /tmp/st
mount("/dev/sda2", "/home", 0x2152780, MS_MGC_VAL|MS_REMOUNT|MS_NOATIME=
,
"nobarrier,errors=3Dremount-ro") =3D 0

# strace -o /tmp/st mount -o remount,relatime /home
# grep ^mount /tmp/st
mount("/dev/sda2", "/home", 0x1543780, MS_REMOUNT|MS_RELATIME|MS_NOATIM=
E,
"nobarrier,errors=3Dremount-ro") =3D 0

# strace -o /tmp/st mount -o remount,atime /home
# grep ^mount /tmp/st
mount("/dev/sda2", "/home", 0x1534780, MS_MGC_VAL|MS_REMOUNT,
"nobarrier,errors=3Dremount-ro") =3D 0

The contents of /proc/mounts isn't changed by all this :-(

Or should I contact the util-linux developers?

--=20
Regards,
J=F6rg.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
