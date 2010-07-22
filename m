From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Thu, 22 Jul 2010 13:25:31 +0100
Message-ID: <30638.1279801531@redhat.com>
References: <alpine.LSU.2.01.1007221248050.9353@obet.zrqbmnf.qr> <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <20100718084824.GA27794@infradead.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
To: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.01.1007221248050.9353-SHaQjdQMGhDmsUXKMKRlFA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org> wrote:

> >> (8) Allow the filesystem to indicate what it can/cannot provide: A
> >>     filesystem can now say it doesn't support a standard stat feature if
> >>     that isn't available.
> >
> >What for?
> 
> Given xstat.otime=0, how would you determine whether the file is really 
> tagged with a date of 1970, or whether it's just the fs which didnot 
> store this kind of information.

I was thinking more of stuff that's already in the Linux stat struct, some of
which is fabricated because the underlying fs doesn't support it.

Take RomFS for example: it fabricates all of st_mtime, st_atime, st_ctime,
st_nlinks, st_blocks, st_uid and st_gid because none of them are stored in the
medium

Similarly, UbiFS fabricates st_blocks and complains in a comment that it makes
no sense for that type of filesystem.

There are other examples.

David
