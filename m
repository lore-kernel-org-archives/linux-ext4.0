From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 03/12] statx: Add a system call to make enhanced file
 info available
Date: Fri, 4 Dec 2015 13:06:33 +0100
Message-ID: <20151204120633.GI14427@amd>
References: <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
 <20151120145457.18930.79678.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arnd-r2nGTMty4D4@public.gmane.org, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151120145457.18930.79678.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> ===============
> NEW SYSTEM CALL
> ===============
> 
> The new system call is:
> 
> 	int ret = statx(int dfd,
> 			const char *filename,
> 			unsigned int flags,
> 			unsigned int mask,
> 			struct statx *buffer);

Should this be called stat5, so that when new, even more improved stat
comes, it does not have to be called statxx?

> The dfd, filename and flags parameters indicate the file to query.  There
> is no equivalent of lstat() as that can be emulated with statx() by passing
> AT_SYMLINK_NOFOLLOW in flags.  There is also no equivalent of fstat() as
> that can be emulated by passing a NULL filename to statx() with the fd of
> interest in dfd.

Dunno. Of course you can multiplex everything.

But fstat() is really different operation to stat() -- tell me about
my file descriptor vs. tell me about this filename, and ptrace (and
some "security" solutions) might want to allow one but disallow the
second. I'd not group them together..

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
