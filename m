From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Sun, 1 Aug 2010 09:17:32 -0400
Message-ID: <20100801091732.25023580@corrin.poochiereds.net>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
	<E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
	<E1Obxpd-00CRIo-SF@intern.SerNet.DE>
	<AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
	<20100722162712.GB10352@jeremy-laptop>
	<AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	<1279817930.3621.14.camel@heimdal.trondhjem.org>
	<20100722180204.GA32008@samba1>
	<E1Oc08W-00CZuz-Ns@intern.SerNet.DE>
	<1279825160.3621.71.camel@heimdal.trondhjem.org>
	<4C5311F4.2050100@psu.edu>
	<1280513506.12852.22.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Phil Pishioneri <pgp-8DAjSxpRXgY@public.gmane.org>, Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280513506.12852.22.camel-rJ7iovZKK19ZJLDQqaL3InhyD016LWXt@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 30 Jul 2010 14:11:46 -0400
Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org> wrote:

> On Fri, 2010-07-30 at 13:55 -0400, Phil Pishioneri wrote:
> > On 7/22/10 2:59 PM, Trond Myklebust wrote:
> > > The fact remains that most of us would be hard pressed to name an
> > > application
> > 
> > Microsoft Office?
> > 
> > > that requires you to share the same dataset to both
> > > Windows/CIFS and posix NFS clients.
> > 
> > NFS client: Mac OS X (NFSv3, since v4 on it is still alpha *cough*).
> > 
> > > tends to discourage mixing the two environments.
> > 
> > Or is "discourage" not strong enough term to describe that we shouldn't 
> > be doing this?
> > 
> > -Phil
> 
> Your Mac has a perfectly functional CIFS client, as do your Linux boxes.
> They both interoperate just fine with Samba, and would presumably
> continue to do so if someone were to decide to reuse the ctime field on
> your Samba box as storage for a create time.
> 
>   Trond
> 

It's not so much particular applications that require access to the
same data via NFS and CIFS. There is, however a common desire to share
the same data to different client OS'.

All of the unix CIFS clients that I know of (including Linux's) trail
NFS in several areas. For instance, if you need to have the same data
accessible by multiple users using their own credentials then you need
multiple mounts.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
