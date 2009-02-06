From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Date: Fri, 6 Feb 2009 13:37:01 -0800
Message-ID: <20090206213701.GN10918@linux.vnet.ibm.com>
References: <20090205180132.GJ6915@linux.vnet.ibm.com> <20090205183158.GA1969@Krystal> <20090205184456.GK6915@linux.vnet.ibm.com> <20090205202249.GA26964@Krystal> <20090205210415.GM6915@linux.vnet.ibm.com> <20090205210627.GA1313@Krystal> <20090206003308.GO6915@linux.vnet.ibm.com> <20090206020005.GA8560@Krystal> <20090206134833.GC10918@linux.vnet.ibm.com> <20090206200329.GA1824@Krystal>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Trilok Soni <soni.trilok@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52604 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZBFVhD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Feb 2009 16:37:03 -0500
Content-Disposition: inline
In-Reply-To: <20090206200329.GA1824@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 06, 2009 at 03:03:29PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Feb 05, 2009 at 09:00:05PM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Thu, Feb 05, 2009 at 04:06:27PM -0500, Mathieu Desnoyers wro=
te:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Thu, Feb 05, 2009 at 03:22:49PM -0500, Mathieu Desnoyers=
 wrote:
> > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > > On Thu, Feb 05, 2009 at 01:31:59PM -0500, Mathieu Desno=
yers wrote:
> > > > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote=
:
> > > > > > > > > > On Thu, Feb 05, 2009 at 09:52:16PM +0530, Trilok So=
ni wrote:
> > > > > > > > > > > Hi Paul,
> > > > > > > > > > >=20
> > > > > > > > > > > On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
> > > > > > > > > > > <paulmck@linux.vnet.ibm.com> wrote:
> > > > > > > > > > > >>
> > > > > > > > > > > >> Are you using quilt to apply the patchset seri=
es file in the right order ?
> > > > > > > > > > > >
> > > > > > > > > > > > Ummm...  No.  I never have used quilt.
> > > > > > > > > > > >
> > > > > > > > > > > > Ah, there is a series file.  I guess it would n=
ot be too hard to make
> > > > > > > > > > > > an appropriate "sh" command:
> > > > > > > > > > >=20
> > > > > > > > > > > How about trying?
> > > > > > > > > > >=20
> > > > > > > > > > > #quilt push -a
> > > > > > > > > >=20
> > > > > > > > > > Is the appropriate incantation as follows?
> > > > > > > > > >=20
> > > > > > > > > > 	cd <top of git tree>
> > > > > > > > > > 	mkdir patches
> > > > > > > > > > 	cp /tmp/patch-2.6.29-rc3-lttng-0.92/* patches
> > > > > > > > > > 	quilt push -a
> > > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > Yes, exactly.
> > > > > > > >=20
> > > > > > > > Whew!  ;-)
> > > > > > > >=20
> > > > > > > > > And from there you can follow the LTTng manual here :
> > > > > > > > >=20
> > > > > > > > > http://ltt.polymtl.ca/svn/trunk/lttv/LTTngManual.html
> > > > > > > >=20
> > > > > > > > I get some fuzz and the following:
> > > > > > > >=20
> > > > > > > > 	patching file kernel/trace/trace-clock-32-to-64.c
> > > > > > > > 	Patch attempted to create file kernel/trace/trace-cloc=
k-32-to-64.c,
> > > > > > > > 	which already exists.
> > > > > > > > 	Hunk #1 FAILED at 1.
> > > > > > > > 	1 out of 1 hunk FAILED -- rejects in file
> > > > > > > > 	kernel/trace/trace-clock-32-to-64.c
> > > > > > > >=20
> > > > > > > > Should I be starting from somewhere other than v2.6.29-=
rc3?
> > > > > > > >=20
> > > > > > >=20
> > > > > > > Let's see it step by step, that should get us there.
> > > > > > >=20
> > > > > > > With patches :
> > > > > > >=20
> > > > > > > mkdir ~/lttng
> > > > > > > cd ~/lttng
> > > > > > > wget http://www.kernel.org/pub/linux/kernel/v2.6/testing/=
linux-2.6.29-rc3.tar.bz2
> > > > > > > wget http://lttng.org/files/lttng/patch-2.6.29-rc3-lttng-=
0.92.tar.bz2
> > > > > > > bzip2 -cd linux-2.6.29-rc3.tar.bz2 |tar xvof -
> > > > > > > bzip2 -cd patch-2.6.29-rc3-lttng-0.92.tar.bz2  |tar xvof =
-
> > > > > > > cd linux-2.6.29-rc3
> > > > > > > mkdir patches
> > > > > > > ln -s ../patch-2.6.29-rc3-lttng-0.92 patches
> > > > > > > quilt push -a
> > > > > > >=20
> > > > > > > Does this work ?
> > > > > >=20
> > > > > > Leaving out the "mkdir", yes.
> > > > >=20
> > > > > Ah, yes, my mistake.
> > > > >=20
> > > > > > My apologies -- I was forgetting that
> > > > > > "git reset --hard" doesn't get rid of untracked files.  I d=
o see fuzz
> > > > > > in a few places, but hopefully this is non-fatal.  And in a=
ny case, I
> > > > > > can now make the patch required to actually try this out.  =
;-)
> > > > > >=20
> > > > >=20
> > > > > Great !
> > > > >=20
> > > > > Don't hesitate to ask if you have any question.
> > > > >=20
> > > > > Mathieu
> > > >=20
> > > > Fails to build on Power, so trying x86...  (Stock 2.6.29-rc3 do=
es
> > > > build and boot, FWIW.)
> > > >=20
> > > > Looks like misplaced file.
> > > >=20
> > > > 							Thanx, Paul
> > > >=20
> > > > ---------------------------------------------------------------=
---------
> > > >=20
> > > >   CHK     include/linux/version.h
> > > >   UPD     include/linux/version.h
> > > >   CHK     include/linux/utsrelease.h
> > > >   UPD     include/linux/utsrelease.h
> > > >   SYMLINK include/asm -> include/asm-powerpc
> > > >   HOSTCC  scripts/ihex2fw
> > > >   HOSTCC  scripts/kallsyms
> > > >   HOSTCC  scripts/pnmtologo
> > > >   HOSTCC  scripts/genksyms/genksyms.o
> > > >   HOSTCC  scripts/conmakehash
> > > >   HOSTCC  scripts/bin2c
> > > >   CC      scripts/mod/empty.o
> > > >   HOSTCC  scripts/mod/mk_elfconfig
> > > >   SHIPPED scripts/genksyms/lex.c
> > > >   SHIPPED scripts/genksyms/parse.h
> > > >   SHIPPED scripts/genksyms/keywords.c
> > > >   SHIPPED scripts/genksyms/parse.c
> > > >   HOSTCC  scripts/genksyms/parse.o
> > > >   HOSTCC  scripts/genksyms/lex.o
> > > >   MKELF   scripts/mod/elfconfig.h
> > > >   HOSTCC  scripts/mod/file2alias.o
> > > >   HOSTCC  scripts/mod/modpost.o
> > > >   HOSTCC  scripts/mod/sumversion.o
> > > >   HOSTLD  scripts/genksyms/genksyms
> > > >   HOSTLD  scripts/mod/modpost
> > > >   CC      kernel/bounds.s
> > > >   GEN     include/linux/bounds.h
> > > >   CC      arch/powerpc/kernel/asm-offsets.s
> > > > In file included from include/linux/module.h:18,
> > > >                  from include/linux/sysdev.h:25,
> > > >                  from include/linux/node.h:22,
> > > >                  from include/linux/swap.h:10,
> > > >                  from include/linux/suspend.h:7,
> > > >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > > > include/linux/immediate.h:15:27: error: asm/immediate.h: No suc=
h file or directory
> > > > In file included from include/linux/module.h:18,
> > > >                  from include/linux/sysdev.h:25,
> > > >                  from include/linux/node.h:22,
> > > >                  from include/linux/swap.h:10,
> > > >                  from include/linux/suspend.h:7,
> > > >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > > > include/linux/immediate.h:37: warning: =C3=A2=E2=82=AC=CB=9Cstr=
uct __imv=C3=A2=E2=82=AC=E2=84=A2 declared
> > > > inside parameter list
> > > > include/linux/immediate.h:37: warning: its scope is only this d=
efinition
> > > > or declaration, which is probably not what you want
> > > > include/linux/immediate.h:40: warning: =C3=A2=E2=82=AC=CB=9Cstr=
uct __imv=C3=A2=E2=82=AC=E2=84=A2 declared
> > > > inside parameter list
> > > > make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
> > > > make: *** [prepare0] Error 2
> > > > 02/05/2009-17:57:41 Build the kernel. Failed rc =3D 2
> > > > 02/05/2009-17:57:41 build: Building kernel... Failed rc =3D 1
> > > >=20
> > >=20
> > > Hrm, does the file
> > >=20
> > > arch/powerpc/include/asm/immediate.h exist in your tree ?
> > >=20
> > > Here, with the setup done following the commands I gave you (minu=
s the
> > > mkdir patch), I get :
> > >=20
> > >=20
> > > compudj@ok:~$ head testpaulmck/linux-2.6.29-rc3/arch/powerpc/incl=
ude/asm/immediate.h=20
> > > #ifndef _ASM_POWERPC_IMMEDIATE_H
> > > #define _ASM_POWERPC_IMMEDIATE_H
> > >=20
> > > /*
> > >  * Immediate values. PowerPC architecture optimizations.
> > >  *
> > >  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymt=
l.ca>
> > >  *
> > >  * This file is released under the GPLv2.
> > >  * See the file COPYING for more details.
> > >=20
> > > ....
> > >=20
> > > Which defines struct __imv. So hrm, normally the header should be=
 there.
> > > (/me still confused) :)
> >=20
> > It does indeed, see the patch I generated against 2.6.29-rc3:
> >=20
> > 	http://www.rdrop.com/users/paulmck/patches/2.6.29-rc3-ltt-1.patch
> >=20
> > I get a similar failure on x86 -- perhaps my tools or build environ=
ment
> > does not match yours?
> >=20
>=20
> Maybe. If you want a quick and dirty solution, try :
>=20
> CONFIG_IMMEDIATE=3Dn
>=20
> Immediate values are just an optimization, not necessary anyway.

K -- kicking it off.

						Thanx, Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
