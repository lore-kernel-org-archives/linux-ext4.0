From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Thu, 22 Jul 2010 11:07:09 -0700
Message-ID: <20100722180709.GB32008@samba1>
References: <30448.1279800887@redhat.com>
 <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
 <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
 <E1Obxpd-00CRIo-SF@intern.SerNet.DE>
 <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
 <20100722162712.GB10352@jeremy-laptop>
 <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
 <1279817930.3621.14.camel@heimdal.trondhjem.org>
 <20100722180204.GA32008@samba1>
 <alpine.LSU.2.01.1007222004430.4215@obet.zrqbmnf.qr>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1007222004430.4215-SHaQjdQMGhDmsUXKMKRlFA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 22, 2010 at 08:05:00PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2010-07-22 20:02, Jeremy Allison wrote:
> >On Thu, Jul 22, 2010 at 12:58:50PM -0400, Trond Myklebust wrote:
> >> 
> >> That would make it impossible to export the filesystem with NFSv2 and
> >> v3. They do rely on ctime checking for certain operations (e.g. deciding
> >> when to invalidate access and acl caches). NFSv4 needs this too if the
> >> filesystem has no dedicated change attribute.
> >> 
> >> Still, I suppose the market for exporting the same filesystem with both
> >> NFS and Samba is limited...
> >
> >Ask NetApp about that :-). They have built a rather large
> >business on just that fact :-).
> 
> What would ZFS do? :p

Get sued out of existence by software patent trolls who have lost
the ability to write code, apparently :-).
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
