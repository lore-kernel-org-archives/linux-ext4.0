From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 9866] New: chattr sticky behaviour and Orlov block
 allocator
Date: Fri, 1 Feb 2008 10:28:04 -0800
Message-ID: <20080201102804.38f61075.akpm@linux-foundation.org>
References: <bug-9866-27@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bugme-daemon@bugzilla.kernel.org, Joerg-Cyril.Hoehle@T-Systems.com
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbYBAS2T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2008 13:28:19 -0500
In-Reply-To: <bug-9866-27@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  1 Feb 2008 07:25:09 -0800 (PST) bugme-daemon@bugzilla.kernel.o=
rg wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D9866
>=20
>            Summary: chattr sticky behaviour and Orlov block allocator
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.22
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: Joerg-Cyril.Hoehle@T-Systems.com
>=20
>=20
> Latest working kernel version: 2.6.22
> Earliest failing kernel version: 2.6.18 (oldest tested)
> Distribution: Ubuntu Gutsy
> Hardware Environment: Fujitsu Siemens C1110 laptop
> Software Environment: chattr 1.40.2 (12-Jul-2007), mke2fs 1.40.2 (12-=
Jul-2007)
> Problem Description:
> Some file attributes have sticky behaviour in ext2/3 whereas I believ=
e
> it should not. Namely, a directory marked with chattr +T serves "to b=
e
> the top of directory hierarchies for the purposes of the Orlov block
> allocator", as the manpage says.
>=20
> It seems wrong that subdirectories stickily inherit the +T flag: they
> are obviously not top-level! Even files get the T attribute this way,
> even though the chattr manpages only documents it for directories.
>=20
> References:
> http://lwn.net/Articles/14633/
> http://lwn.net/Articles/14447/ Theodore Ts'o ext3 patch
> http://en.wikipedia.org/wiki/Orlov_block_allocator
>=20
>=20
> Steps to reproduce:
> The following shows the sticky behaviour:
> $ mkdir tests
> chattr -V +T tests
> chattr 1.40.2 (12-Jul-2007)
> Flags von tests wie folgt gesetzt: ----------------T-
> $ mkdir tests/src
> $ cp -dp /etc/fstab tests/src
> $ lsattr . tests tests/src
> ----------------T- ./tests
> ----------------T- tests/src
> ----------------T- tests/src/fstab
>=20
> I verified (using cp -dpr and ls -lifR) that indeed, the inherited T
> attribute causes all subdirectories to be created in inodes far apart
> (like with mount -o remount,oldalloc), whereas the Orlov allocator
> normally would put the directories next to each other.  My expectatio=
n
> is that only e.g. /home/user{1,2,3,4,5,6} should be created spread
> out, whereas each user home's contents would be next each other
> (/home/user1/{foo,bar,etc}).
>=20
> The effect of this bug makes chattr +T unusable, because Orlov
> optimization is de facto eliminated.
>=20
> Regards,
>  J=F6rg H=F6hle
>=20
>=20
> --=20
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Dema=
il
> ------- You are receiving this mail because: -------
> You are the assignee for the bug, or are watching the assignee.
