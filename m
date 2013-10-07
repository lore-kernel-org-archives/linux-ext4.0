From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/31] e2p: Fix f[gs]etflags argument size mismatch
Date: Mon, 7 Oct 2013 13:40:55 -0700
Message-ID: <20131007204055.GF6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012721.28415.97544.stgit@birch.djwong.org>
 <20131007133304.GE4540@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3JGUlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Oct 2013 16:41:04 -0400
Content-Disposition: inline
In-Reply-To: <20131007133304.GE4540@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 09:33:04AM -0400, Theodore Ts'o wrote:
> On Mon, Sep 30, 2013 at 06:27:21PM -0700, Darrick J. Wong wrote:
> 
> > The EXT2_IOC_[GS]ETFLAGS ioctls take longs as arguments, however
> > this code only reserves enough storage for an int.  The kernel
> > drivers (so far) don't transfer more than an int but FUSE sees the
> > long and assumes that it's ok to write the full size of the long,
> > which crashes if sizeof(long) > sizeof(int).
> 
> All of the kernel code I was able to audit is treating the
> EXT2_IOC_[SG]ETFLAGS ioctls as taking an int, not a long.  So the
> defacto definition of [SG]ETFLAGS is that that they take ints, not
> longs.  If we make this change which you are proposing, it will cause
> problems on big-endian systems where sizeof(long) > sizeof(int) ---
> for example, as would be the case on the ppc64 architecture.
> 
> I'm not sure what the FUSE problem is?  Can you say more?  Is there
> some other way we can work around the problem you are trying to solve?

If I mount a FUSE fs (specifically the fuse2fs thing in the last patch) and try
to run 'chattr +i /mnt/foo', chattr segfaults.  valgrind had this[1] to offer.
It seems that FUSE's ioctl implementation depends on the 'size' argument to
_IOR (in the EXT2_IOC_[SG]ETFLAGS definition) to figure out how much data to
transfer in or out of userspace.  Unfortunately for fgetflags, it passes in a
pointer to an int, and fuse seems to smash up the stack trying to write back a
long.  Valgrind and gdb show that the lower 32-bits of name get overwritten,
which causes the segfault.

Unfortunately, this is a bit of a heisenbug; if I build with -O0 (gcc 4.6.3,
Ubuntu 12.04, libfuse 2.9.2 backport) it goes away.  The stack corruption also
seems to go away if I print the address of f, though save_errno gets
overwritten with some suspicious looking 32695 value.

I'll keep poking at what's going on here, though I'll try to come up with a
clever solution for BE machines.

--D

[1] Valgrind messsage:
==3512== Memcheck, a memory error detector
==3512== Copyright (C) 2002-2011, and GNU GPL'd, by Julian Seward et al.
==3512== Using Valgrind-3.7.0 and LibVEX; rerun with -h for copyright info
==3512== Command: chattr +i /mnt/foo
==3512== 
==3512== Syscall param lstat(file_name) points to unaddressable byte(s)
==3512==    at 0x53232B5: _lxstat (lxstat.c:38)
==3512==    by 0x4E34610: fsetflags (in /lib/x86_64-linux-gnu/libe2p.so.2.3)
==3512==    by 0x401350: ??? (in /usr/bin/chattr)
==3512==    by 0x4010A0: ??? (in /usr/bin/chattr)
==3512==    by 0x525E76C: (below main) (libc-start.c:226)
==3512==  Address 0x700007fb7 is not stack'd, malloc'd or (recently) free'd
==3512== 
==3512== Syscall param open(filename) points to unaddressable byte(s)
==3512==    at 0x53236C0: __open_nocancel (syscall-template.S:82)
==3512==    by 0x4E3463E: fsetflags (in /lib/x86_64-linux-gnu/libe2p.so.2.3)
==3512==    by 0x401350: ??? (in /usr/bin/chattr)
==3512==    by 0x4010A0: ??? (in /usr/bin/chattr)
==3512==    by 0x525E76C: (below main) (libc-start.c:226)
==3512==  Address 0x700007fb7 is not stack'd, malloc'd or (recently) free'd
==3512== 
chattr: Bad address ==3512== Invalid read of size 1
==3512==    at 0x52883B1: vfprintf (vfprintf.c:1630)
==3512==    by 0x528B1A3: buffered_vfprintf (vfprintf.c:2313)
==3512==    by 0x5285BDD: vfprintf (vfprintf.c:1316)
==3512==    by 0x53463D7: __vfprintf_chk (vfprintf_chk.c:35)
==3512==    by 0x503ABA8: ??? (in /lib/x86_64-linux-gnu/libcom_err.so.2.1)
==3512==    by 0x503AD1E: com_err (in /lib/x86_64-linux-gnu/libcom_err.so.2.1)
==3512==    by 0x401435: ??? (in /usr/bin/chattr)
==3512==    by 0x4010A0: ??? (in /usr/bin/chattr)
==3512==    by 0x525E76C: (below main) (libc-start.c:226)
==3512==  Address 0x700007fb7 is not stack'd, malloc'd or (recently) free'd
==3512== 
==3512== 
==3512== Process terminating with default action of signal 11 (SIGSEGV)
==3512==  Access not within mapped region at address 0x700007FB7
==3512==    at 0x52883B1: vfprintf (vfprintf.c:1630)
==3512==    by 0x528B1A3: buffered_vfprintf (vfprintf.c:2313)
==3512==    by 0x5285BDD: vfprintf (vfprintf.c:1316)
==3512==    by 0x53463D7: __vfprintf_chk (vfprintf_chk.c:35)
==3512==    by 0x503ABA8: ??? (in /lib/x86_64-linux-gnu/libcom_err.so.2.1)
==3512==    by 0x503AD1E: com_err (in /lib/x86_64-linux-gnu/libcom_err.so.2.1)
==3512==    by 0x401435: ??? (in /usr/bin/chattr)
==3512==    by 0x4010A0: ??? (in /usr/bin/chattr)
==3512==    by 0x525E76C: (below main) (libc-start.c:226)
==3512==  If you believe this happened as a result of a stack
==3512==  overflow in your program's main thread (unlikely but
==3512==  possible), you can try to increase the size of the
==3512==  main thread stack using the --main-stacksize= flag.
==3512==  The main thread stack size used in this run was 8388608.
==3512== 
==3512== HEAP SUMMARY:
==3512==     in use at exit: 0 bytes in 0 blocks
==3512==   total heap usage: 247 allocs, 247 frees, 22,481 bytes allocated
==3512== 
==3512== All heap blocks were freed -- no leaks are possible
==3512== 
==3512== For counts of detected and suppressed errors, rerun with: -v
==3512== ERROR SUMMARY: 3 errors from 3 contexts (suppressed: 2 from 2)
Segmentation fault
