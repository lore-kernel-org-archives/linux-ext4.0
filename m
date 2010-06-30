From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Thu, 01 Jul 2010 00:15:13 +0100
Message-ID: <30875.1277939713@redhat.com>
References: <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca> <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <26505.1277899544@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FB78A152-53D3-4000-ABDB-9D6051ECB887-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> For the cost of those extra bytes it would definitely save a lot of extra
> complexity in every application packing and unpacking the struct.  At a
> minimum put a 32-bit padding that is zero-filled for now.

Blech.  I'd prefer to just expand the fields to 64-bits.

Note that you can't just arbitrarily pass a raw 64-bit UID, say, back to
vfs_getattr() and expect it to be coped with.  Those stat syscalls that return
32-bit (or even 16-bit) would have to do something with it, and glibc would
have to do something with it.

I think we'd need extra request bits to ask for the longer UID/GID - at which
point the extra result data can be appended and extra capacity in the basic
part of the struct is not required.

> > so perhaps something like:
> > 
> > 	struct xstat_u128 { unsigned long long lsw, msw; };
> > 
> > however, I suspect the kernel will require a bit of reengineering to handle
> > a pgoff_t and loff_t of 128-bits.
>
> Well, not any different from having 32-bit platforms work with two 32-bit
> values for 64-bit offsets today, except that we would be doing this with two
> 64-bit values.

gcc for 32-bit platforms can handle 64-bit numbers.  gcc doesn't handle 128-bit
numbers.

This can be handled as suggested above by allocating extra result bits to get
the upper halves of longer fields:

	XSTAT_REQUEST_SIZE__MSW
	XSTAT_REQUEST_BLOCKS__MSW

for example.

> > Passing -1 (or ULONGLONG_MAX) to get everything would be reasonable.
> 
> NOOOO.  That is exactly what we _don't_ want, since it makes it impossible
> for the kernel to actually understand which fields the application is ready
> to handle.  If the application always uses XSTAT_QUERY_ALL, instead of "-1",
> then the kernel can easily tell which fields are present in the userspace
> structure, and what it should avoid touching.
> 
> If applications start using "-1" to mean "all fields", then it will work so
> long as the kernel and userspace agree on the size of struct xstat, but as
> soon as the kernel understands some new field, but userspace does not, the
> application will segfault or clobber random memory because the kernel thinks
> it is asking for XSTAT_QUERY_NEXT_NEW_FIELD|... when it really isn't asking
> for that at all.

As long as the field bits allocated in order and the extra results are tacked
on in bit number order, will it actually be a problem?  Userspace must know how
to deal with all the bits up to the last one it knows about; anything beyond
that is irrelevant.

What would you have me do?  Return an error if a request is made that the
kernel doesn't support?  That's bad too.  This can be handled simply by
clearing the result bit for any unsupported field.

David
