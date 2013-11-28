From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Thu, 28 Nov 2013 13:07:24 +0000
Message-ID: <14955.1385644044@warthog.procyon.org.uk>
References: <20131126104034.GA4854@quack.suse.cz> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131126104034.GA4854-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:

> > 		unsigned long long	st_blocks;
>   When we are doing this, can we please also change 'st_blocks' to
> 'st_bytes'? We track space usage in kernel in bytes for a long time so it
> would be nice to propagate it to userspace via stat instead of a special
> ioctl (at least quotacheck(8) needs to know the exact value).

Ummm...  I'm not sure about that.  Ideally, every field that is provided in
the current stat() buffer must still be there.  On the other hand, since
they're going to be moved around, presumably there will be a userspace
translation layer.

David
