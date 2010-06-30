From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 10:47:26 +0100
Message-ID: <29130.1277891246@redhat.com>
References: <CE3451EE-F8B2-47EF-AC1C-4EEEBE68B30F@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk> <1277862536.9326.3.camel@heimdal.trondhjem.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>,
	viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CE3451EE-F8B2-47EF-AC1C-4EEEBE68B30F-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> > Yes, but could we please also add a flag that allows you to specify that
> > the kernel _must_ provide up to date attributes.
> 
> To my reading, if the query_flags are set in the input buffer, then the
> attributes MUST be fetched.  If they are unset, then they MAY be fetched,
> and the corresponding query_flags will be set in the return buffer.  If the
> query_flags are not set in the return buffer then I assume the output values
> are undefined.

I think Trond may have a point, looking at nfs_getattr().

There can be three levels:

 (1) Don't check with the server, just go with what we've got in the cache if
     it's available.  Results returned may be approximate.

 (2) Check with the server if the cached attributes are out of date or if
     something is requested that we don't keep in RAM.

 (3) Check with the server anyway.

David
