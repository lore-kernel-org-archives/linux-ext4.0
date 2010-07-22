From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Thu, 22 Jul 2010 11:15:49 -0700
Message-ID: <20100722181549.GD32008@samba1>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
 <30448.1279800887@redhat.com>
 <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
 <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
 <E1Obxpd-00CRIo-SF@intern.SerNet.DE>
 <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
 <20100722162712.GB10352@jeremy-laptop>
 <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
 <alpine.LSU.2.01.1007221859180.27496@obet.zrqbmnf.qr>
 <AANLkTilmVdyVdO4EmVtTYi_cvMmPqNEPEnzUkJdk1XyR@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTilmVdyVdO4EmVtTYi_cvMmPqNEPEnzUkJdk1XyR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 22, 2010 at 10:24:17AM -0700, Linus Torvalds wrote:
> 
> And yes, I am also sure that there are applications that do depend on
> ctime semantics. Trond mentioned NFS serving, and that's unfortunate.
> I bet there are others. That's inevitable when you have 40 years of
> history. So I'm not claiming that re-using ctime is painfree, but for
> somebody that cares about samba a lot, I bet it's a _lot_ better than
> adding a new time that almost nobody actually supports as things stand
> now.

Samba mostly ignores ctime, for just the reasons you mention.
But re-using ctime as create time will lead to more horrible
confusion (IMHO).

Easier to add a btime field to stat (or whatever you want to
call it), especially as some of the filesystems already support it,
the code for it exists inside Samba and is working on other UNIX-style
OS'es, and for filesystems that don't support it, just return
zero or -1 in that field (which we already ignore).

> Of people can just use xattrs and do it all entirely in user space. I
> assume that's what samba does now, even outside of birthtime.

Yep. We even have to do that on systems with an immutable
btime to get Windows semantics.

Jeremy.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
