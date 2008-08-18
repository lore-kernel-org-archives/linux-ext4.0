From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: add EXT4_IOC_GETCRTIME ioctl
Date: Sun, 17 Aug 2008 22:36:56 -0400
Message-ID: <20080818023656.GA20338@mit.edu>
References: <48996A33.3010507@cn.fujitsu.com> <20080810022643.GC14756@mit.edu> <48A8D98B.9020701@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54872 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbYHRChI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Aug 2008 22:37:08 -0400
Content-Disposition: inline
In-Reply-To: <48A8D98B.9020701@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 18, 2008 at 10:08:11AM +0800, Li Zefan wrote:
> > 
> > I'm worried about writing a struct timespec directly to user space,
> > because the kernel's idea of what is struct timespec might not be the
> > same as the userspace's understanding of struct timespec ---
> 
> We have system call nanosleep(), which copies a struct timespec directly
> from user space.

The difference is that for system calls, we have a glue layer (glibc)
whose duties include translating between the kernel data structures
and the userpsace data structures --- and for various architectures
there are ***no*** guarantees that the interfaces shipped by glibc in
/usr/include match up with the data structures used by the kernel in
/usr/src/linux/include/linux.

When you use an ioctl, you bypass the glibc translation layer, so life
can get iffy here.  And given that struct timespec contains time_t,
which *can* differ from architecture to architecure in in terms of
being either 32 bits or 64 bits, and what is in the kernel might be
different from what is in the user space /usr/include, I get doubly
nervous.

> > I think we would be better off explicitly defining a structure, or
> > just returning the seconds and nanoseconds in explicit primitive
> > types.

That's the quick and dirty fast answer, yes.  The long-term (but one
which involves much more work) is to define a new struct
kernel<->glibc stat interface (we already have 5 or so :-) to extend
it include st_crtime, and then try to get glibc to use the magic of
ELF symbol versioning so there is a new struct stat as defined in
/usr/include, and a new stat(2) call defined in glibc, which returns
the new struct stat which include st_crtime.  This also means we have
to define proper semantics for what happens if a filesystem doesn't
support st_crtime.

						- Ted
