From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Date: Thu, 5 Feb 2009 21:00:05 -0500
Message-ID: <20090206020005.GA8560@Krystal>
References: <20090205153825.GA30255@Krystal> <20090205155854.GG6915@linux.vnet.ibm.com> <5d5443650902050822r2e4d08ffg2322b45a5e009fb8@mail.gmail.com> <20090205180132.GJ6915@linux.vnet.ibm.com> <20090205183158.GA1969@Krystal> <20090205184456.GK6915@linux.vnet.ibm.com> <20090205202249.GA26964@Krystal> <20090205210415.GM6915@linux.vnet.ibm.com> <20090205210627.GA1313@Krystal> <20090206003308.GO6915@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Trilok Soni <soni.trilok@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts13.bellnexxia.net ([209.226.175.34]:46962 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbZBFCAK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 21:00:10 -0500
Content-Disposition: inline
In-Reply-To: <20090206003308.GO6915@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Feb 05, 2009 at 04:06:27PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Thu, Feb 05, 2009 at 03:22:49PM -0500, Mathieu Desnoyers wrote=
:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > On Thu, Feb 05, 2009 at 01:31:59PM -0500, Mathieu Desnoyers w=
rote:
> > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > On Thu, Feb 05, 2009 at 09:52:16PM +0530, Trilok Soni wro=
te:
> > > > > > > > Hi Paul,
> > > > > > > >=20
> > > > > > > > On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
> > > > > > > > <paulmck@linux.vnet.ibm.com> wrote:
> > > > > > > > >>
> > > > > > > > >> Are you using quilt to apply the patchset series fil=
e in the right order ?
> > > > > > > > >
> > > > > > > > > Ummm...  No.  I never have used quilt.
> > > > > > > > >
> > > > > > > > > Ah, there is a series file.  I guess it would not be =
too hard to make
> > > > > > > > > an appropriate "sh" command:
> > > > > > > >=20
> > > > > > > > How about trying?
> > > > > > > >=20
> > > > > > > > #quilt push -a
> > > > > > >=20
> > > > > > > Is the appropriate incantation as follows?
> > > > > > >=20
> > > > > > > 	cd <top of git tree>
> > > > > > > 	mkdir patches
> > > > > > > 	cp /tmp/patch-2.6.29-rc3-lttng-0.92/* patches
> > > > > > > 	quilt push -a
> > > > > > >=20
> > > > > >=20
> > > > > > Yes, exactly.
> > > > >=20
> > > > > Whew!  ;-)
> > > > >=20
> > > > > > And from there you can follow the LTTng manual here :
> > > > > >=20
> > > > > > http://ltt.polymtl.ca/svn/trunk/lttv/LTTngManual.html
> > > > >=20
> > > > > I get some fuzz and the following:
> > > > >=20
> > > > > 	patching file kernel/trace/trace-clock-32-to-64.c
> > > > > 	Patch attempted to create file kernel/trace/trace-clock-32-t=
o-64.c,
> > > > > 	which already exists.
> > > > > 	Hunk #1 FAILED at 1.
> > > > > 	1 out of 1 hunk FAILED -- rejects in file
> > > > > 	kernel/trace/trace-clock-32-to-64.c
> > > > >=20
> > > > > Should I be starting from somewhere other than v2.6.29-rc3?
> > > > >=20
> > > >=20
> > > > Let's see it step by step, that should get us there.
> > > >=20
> > > > With patches :
> > > >=20
> > > > mkdir ~/lttng
> > > > cd ~/lttng
> > > > wget http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-=
2.6.29-rc3.tar.bz2
> > > > wget http://lttng.org/files/lttng/patch-2.6.29-rc3-lttng-0.92.t=
ar.bz2
> > > > bzip2 -cd linux-2.6.29-rc3.tar.bz2 |tar xvof -
> > > > bzip2 -cd patch-2.6.29-rc3-lttng-0.92.tar.bz2  |tar xvof -
> > > > cd linux-2.6.29-rc3
> > > > mkdir patches
> > > > ln -s ../patch-2.6.29-rc3-lttng-0.92 patches
> > > > quilt push -a
> > > >=20
> > > > Does this work ?
> > >=20
> > > Leaving out the "mkdir", yes.
> >=20
> > Ah, yes, my mistake.
> >=20
> > > My apologies -- I was forgetting that
> > > "git reset --hard" doesn't get rid of untracked files.  I do see =
fuzz
> > > in a few places, but hopefully this is non-fatal.  And in any cas=
e, I
> > > can now make the patch required to actually try this out.  ;-)
> > >=20
> >=20
> > Great !
> >=20
> > Don't hesitate to ask if you have any question.
> >=20
> > Mathieu
>=20
> Fails to build on Power, so trying x86...  (Stock 2.6.29-rc3 does
> build and boot, FWIW.)
>=20
> Looks like misplaced file.
>=20
> 							Thanx, Paul
>=20
> ---------------------------------------------------------------------=
---
>=20
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-powerpc
>   HOSTCC  scripts/ihex2fw
>   HOSTCC  scripts/kallsyms
>   HOSTCC  scripts/pnmtologo
>   HOSTCC  scripts/genksyms/genksyms.o
>   HOSTCC  scripts/conmakehash
>   HOSTCC  scripts/bin2c
>   CC      scripts/mod/empty.o
>   HOSTCC  scripts/mod/mk_elfconfig
>   SHIPPED scripts/genksyms/lex.c
>   SHIPPED scripts/genksyms/parse.h
>   SHIPPED scripts/genksyms/keywords.c
>   SHIPPED scripts/genksyms/parse.c
>   HOSTCC  scripts/genksyms/parse.o
>   HOSTCC  scripts/genksyms/lex.o
>   MKELF   scripts/mod/elfconfig.h
>   HOSTCC  scripts/mod/file2alias.o
>   HOSTCC  scripts/mod/modpost.o
>   HOSTCC  scripts/mod/sumversion.o
>   HOSTLD  scripts/genksyms/genksyms
>   HOSTLD  scripts/mod/modpost
>   CC      kernel/bounds.s
>   GEN     include/linux/bounds.h
>   CC      arch/powerpc/kernel/asm-offsets.s
> In file included from include/linux/module.h:18,
>                  from include/linux/sysdev.h:25,
>                  from include/linux/node.h:22,
>                  from include/linux/swap.h:10,
>                  from include/linux/suspend.h:7,
>                  from arch/powerpc/kernel/asm-offsets.c:24:
> include/linux/immediate.h:15:27: error: asm/immediate.h: No such file=
 or directory
> In file included from include/linux/module.h:18,
>                  from include/linux/sysdev.h:25,
>                  from include/linux/node.h:22,
>                  from include/linux/swap.h:10,
>                  from include/linux/suspend.h:7,
>                  from arch/powerpc/kernel/asm-offsets.c:24:
> include/linux/immediate.h:37: warning: =C3=A2=E2=82=AC=CB=9Cstruct __=
imv=C3=A2=E2=82=AC=E2=84=A2 declared
> inside parameter list
> include/linux/immediate.h:37: warning: its scope is only this definit=
ion
> or declaration, which is probably not what you want
> include/linux/immediate.h:40: warning: =C3=A2=E2=82=AC=CB=9Cstruct __=
imv=C3=A2=E2=82=AC=E2=84=A2 declared
> inside parameter list
> make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 02/05/2009-17:57:41 Build the kernel. Failed rc =3D 2
> 02/05/2009-17:57:41 build: Building kernel... Failed rc =3D 1
>=20

Hrm, does the file

arch/powerpc/include/asm/immediate.h exist in your tree ?

Here, with the setup done following the commands I gave you (minus the
mkdir patch), I get :


compudj@ok:~$ head testpaulmck/linux-2.6.29-rc3/arch/powerpc/include/as=
m/immediate.h=20
#ifndef _ASM_POWERPC_IMMEDIATE_H
#define _ASM_POWERPC_IMMEDIATE_H

/*
 * Immediate values. PowerPC architecture optimizations.
 *
 * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
 *
 * This file is released under the GPLv2.
 * See the file COPYING for more details.

=2E...

Which defines struct __imv. So hrm, normally the header should be there=
=2E
(/me still confused) :)

Mathieu

--=20
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE =
9A68
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
