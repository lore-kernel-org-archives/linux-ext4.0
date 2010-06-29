From: Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file
	stats available
Date: Tue, 29 Jun 2010 15:13:04 -0700
Message-ID: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
	<20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100629200315.23196.68742.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 29, 2010 at 13:03, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem:

If you add something like this you might want to integrate another
extension.  This has been discussed a long time ago.  In almost no
situation all the information is needed.  Some of the pieces of
information returned by the syscall might be harder to collect than
other.  It makes sense in such a situation to allow the caller to
specify what she is interested in.  A bitmask of some sort.  This was
brought up by the HPC people with gigantic filesystems.

For this the syscall interface should have a parameter to specify what
is requested and the stat-like structure should have a field
specifying what is actually present.  The latter bitmask must be a
superset of the former.

Previous discussions centered around reusing the stat data structure
and somehow make it work.  But no clean solution was found.  If a new
structure is added anyway this could solve the issue.


And while you're at it, maybe some spare fields at the end are nice.
