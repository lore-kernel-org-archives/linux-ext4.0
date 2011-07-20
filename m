From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Date: Wed, 20 Jul 2011 17:33:20 -0400
Message-ID: <20110720213320.GA3304@thunk.org>
References: <20110720175918.GB17971@thunk.org>
 <4E271F30.6070102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57009 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1GTVdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 17:33:24 -0400
Content-Disposition: inline
In-Reply-To: <4E271F30.6070102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 20, 2011 at 01:32:16PM -0500, Eric Sandeen wrote:
> 
> How does it fail?  Works here(tm):

It doesn't find the autoconfig macros defined in the m4 directory:

<tytso@tytso-glaptop> {/kbuild/xfstests/xfsprogs-dev}  [master]
512% autoconf
autoconf: Undefined macros:
configure.in:100:AC_PACKAGE_NEED_PTHREADMUTEXINIT
configure.in:102:AC_HAVE_FADVISE
configure.in:103:AC_HAVE_MADVISE
configure.in:104:AC_HAVE_MINCORE
configure.in:105:AC_HAVE_SENDFILE
configure.in:106:AC_HAVE_GETMNTENT
configure.in:107:AC_HAVE_GETMNTINFO
configure.in:108:AC_HAVE_FALLOCATE
configure.in:109:AC_HAVE_FIEMAP
configure.in:110:AC_HAVE_BLKID_TOPO($enable_blkid)
configure.in:112:AC_TYPE_PSINT
configure.in:113:AC_TYPE_PSUNSIGNED
configure.in:114:AC_TYPE_U32
configure.in:115:AC_SIZEOF_POINTERS_AND_LONG
configure.in:116:AC_MANUAL_FORMAT
configure.in:3:AC_CONFIG_MACRO_DIR([m4])
configure.in:7:AC_PROG_LIBTOOL
configure.in:89:AC_PACKAGE_GLOBALS(xfsprogs)
configure.in:90:AC_PACKAGE_UTILITIES(xfsprogs)
configure.in:91:AC_MULTILIB($enable_lib64)
configure.in:93:AC_PACKAGE_NEED_AIO_H
configure.in:94:AC_PACKAGE_NEED_LIO_LISTIO
configure.in:96:AC_PACKAGE_NEED_UUID_H
configure.in:97:AC_PACKAGE_NEED_UUIDCOMPARE
configure.in:99:AC_PACKAGE_NEED_PTHREAD_H

Maybe you have all of these autoconf macros stuffed in some
distro-supplied global m4 directory?

> > b) By default xfsprogs builds with DEBUG, and this causes building
> > libxfs/xfs_ialloc.c to blow up since there a reference of
> > xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
> > fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
> > two figure this out....
> 
> Odd, libxfs/Makefile has:
> 
> DEBUG = -DNDEBUG

Yeah, but include/builddefs{.in}, DEBUG is defined to @debug_build@,
which is -DDEBUG, and then GCFLAGS is set to $(OPTIMIZER) $(DEBUG) ...,

and the override in libxfs/Makefile doesn't change the value of
GCFLAGS, at least not for gmake 3.81.

> But to be honest, the DEBUG stuff has been a thorn in my side for Fedora
> too, with the extra CFLAGS it sets, something gets goobered up by
> default, and I build with -DNDEBUG for those packages too.
> 
> I just haven't sorted it out yet ....
> 
> So things to look into, but can you also describe how building xfstests
> fails for you when you have all the ubuntu xfsprogs-related packages
> installed?

Yeah, working on it.  I'm starting from scratch so I can have a shell
script that can build all of this by hand, instead of manually fixing
these things one at a time as I've done in the past...

      	     	      	      	   	   - Ted
