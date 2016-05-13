From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info available
Date: Fri, 13 May 2016 17:28:11 +0200
Message-ID: <3204439.9qcmCY96fi@wuerfel>
References: <20160510070421.GB30896@infradead.org> <6897.1462868755@warthog.procyon.org.uk> <20160512091141.GA22420@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512091141.GA22420-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 12 May 2016 02:11:41 Christoph Hellwig wrote:
> On Tue, May 10, 2016 at 09:25:55AM +0100, David Howells wrote:
> > Because it's not necessarily a perfectly working version of it.  See the Y2037
> > problem for example.
> > 
> > I was assuming that C libraries might want to update the struct stat and the
> > stat call() to provide fields that aren't currently there in Linux but are in
> > other OS's.  We could even dispense with older stat syscalls on new arches.
> 
> Please stop this whole let's get rid of old syscalls on new
> architectures stuff.  This just means we have to do the translation
> multiple, and the one in userspace is more costly as we it needs to be
> in every copy of the library.  And times where we had a single libc
> instance (nevermind implementation) are long over if we ever actually
> had them.

I'm trying to understand what that means for the 64-bit time_t syscalls.

The patch series I did last year had a replacement 'sys_newfstatat()'
syscall but IIRC no other stat variant, the idea being that we would
only need to provide this one to the libc and have user space emulate
the stat/fstat/lstat/fstatat variants based on that.
With the statx introduction, I was hoping to no longer have to add
that syscall but instead have libc do everything on top of sys_statx().

Do you think that is reasonable, given that we won't be allowed to
call any of the existing stat() variants for a y2038-safe libc build[1],
or should we plan to keep needing replacement fstatat (and possibly
stat/lstat/fstat) syscalls with 64-bit time_t even after statx() support
is merged into the kernel.

	Arnd

[1] the glibc developers plan to allow compatibility for 32-bit time_t
    and 64-bit time_t in the same binary, but any user space code built
    with 64-bit time_t must never call into kernel interfaces that use
    a 32-bit time_t.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
