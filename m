From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended  file stats available [ver #6]
Date: Mon, 2 Aug 2010 10:42:00 -0400
Message-ID: <20100802104200.2f058428@corrin.poochiereds.net>
References: <20100728111525.355a2bd3@notabene>
	<alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
	<E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
	<E1Obxpd-00CRIo-SF@intern.SerNet.DE>
	<AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
	<20100722162712.GB10352@jeremy-laptop>
	<AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	<alpine.LSU.2.01.1007221859180.27496@obet.zrqbmnf.qr>
	<AANLkTilmVdyVdO4EmVtTYi_cvMmPqNEPEnzUkJdk1XyR@mail.gmail.com>
	<13591.1280338082@redhat.com>
	<20100729090401.4b0a21f8@notabene>
	<20100801094018.522e2f53@corrin.poochiereds.net>
	<AANLkTi=JvwrwpmteFcXW1f5s95+_w_iCT+04Sy7bbTtR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Freemyer <greg.freemyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=JvwrwpmteFcXW1f5s95+_w_iCT+04Sy7bbTtR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2 Aug 2010 10:09:49 -0400
Greg Freemyer <greg.freemyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> > Furthermore, I'll go ahead and propose the following (simple) semantics:
> >
> > 1) birthtime is initialized to the current time when a new inode is
> > created
> >
> > 2) it's settable via the xattr to an arbitrary value
> >
> > Either way, the xattr for this ought to be named the same on all
> > filesystems. Samba shouldn't need to know or care what the underlying
> > filesystem is, as long as it presents the correct xattr.
> >
> > That should make samba happy, and be reasonably simple to implement.
> 
> Is there any reason to allow birthtime to be set in advance of the
> current birthtime?
> 
> ie restore / copy tools clearly need to backdate it, but I'd prefer to
> see it not advance-able.
> 
> Greg

Why not? Is there a good argument for prohibiting it? We allow people
to set mtime in the future. Why not allow the same semantics here?

We also have to consider that this may eventually be settable by via
networked filesystem interfaces. If the client and server don't have
synchronized clocks you may end up with the client getting an error
back in some cases if you don't allow it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
