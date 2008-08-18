From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] ext4: add EXT4_IOC_GETCRTIME ioctl
Date: Mon, 18 Aug 2008 18:03:50 +0800
Message-ID: <48A94906.8030505@cn.fujitsu.com>
References: <48996A33.3010507@cn.fujitsu.com> <20080810022643.GC14756@mit.edu> <48A8D98B.9020701@cn.fujitsu.com> <20080818023656.GA20338@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54063 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbYHRKFY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Aug 2008 06:05:24 -0400
In-Reply-To: <20080818023656.GA20338@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Aug 18, 2008 at 10:08:11AM +0800, Li Zefan wrote:
>>> I'm worried about writing a struct timespec directly to user space,
>>> because the kernel's idea of what is struct timespec might not be the
>>> same as the userspace's understanding of struct timespec ---
>> We have system call nanosleep(), which copies a struct timespec directly
>> from user space.
> 
> The difference is that for system calls, we have a glue layer (glibc)
> whose duties include translating between the kernel data structures
> and the userpsace data structures --- and for various architectures
> there are ***no*** guarantees that the interfaces shipped by glibc in
> /usr/include match up with the data structures used by the kernel in
> /usr/src/linux/include/linux.
> 
> When you use an ioctl, you bypass the glibc translation layer, so life
> can get iffy here.  And given that struct timespec contains time_t,
> which *can* differ from architecture to architecure in in terms of
> being either 32 bits or 64 bits, and what is in the kernel might be
> different from what is in the user space /usr/include, I get doubly
> nervous.
> 

I got the point, thanks. :)

>>> I think we would be better off explicitly defining a structure, or
>>> just returning the seconds and nanoseconds in explicit primitive
>>> types.
> 
> That's the quick and dirty fast answer, yes.  The long-term (but one
> which involves much more work) is to define a new struct
> kernel<->glibc stat interface (we already have 5 or so :-) to extend
> it include st_crtime, and then try to get glibc to use the magic of
> ELF symbol versioning so there is a new struct stat as defined in
> /usr/include, and a new stat(2) call defined in glibc, which returns
> the new struct stat which include st_crtime.  This also means we have
> to define proper semantics for what happens if a filesystem doesn't
> support st_crtime.
> 

Yes, my first thought was if stat can report crtime.

So, for now I think we can use timespec_to_ns() to convert the time to
a s64 value and return it to the userspace.

