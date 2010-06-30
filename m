From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 11:22:17 +0100
Message-ID: <29802.1277893337@redhat.com>
References: <B82FC7EE-93D2-4D86-906D-5D6AFA502709@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B82FC7EE-93D2-4D86-906D-5D6AFA502709-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> Note that when ext4 is mounted with the "i_version" option that the
> i_version field is also updated on regular files, for use by NFSv4.  See,
> for example, ext4_mark_iloc_dirty().
> 
> I had a hard time finding this, even though I knew it was there somewhere,
> because it isn't modifying "i_version" directly, but rather calling a helper
> function inode_inc_iversion().

Ah, okay.  Thanks!

> It probably makes sense to always return i_version, unless it is 0.

I didn't want to return it if it wasn't supported on the nominated file as
that may give a false sense of coherency.

David
