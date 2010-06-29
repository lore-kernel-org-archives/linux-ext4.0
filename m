From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file
	stats available
Date: Tue, 29 Jun 2010 17:33:56 -0500
Message-ID: <AANLkTimieV9ybz2XrD29tvz1mogdMA5VHH4lNSwPovoE@mail.gmail.com>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
	<20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
	<AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 29, 2010 at 5:13 PM, Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> On Tue, Jun 29, 2010 at 13:03, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> Add a pair of system calls to make extended file stats available, in=
cluding
>> file creation time, inode version and data version where available t=
hrough the
>> underlying filesystem:
>
> If you add something like this you might want to integrate another
> extension. =A0This has been discussed a long time ago. =A0In almost n=
o
> situation all the information is needed. =A0Some of the pieces of
> information returned by the syscall might be harder to collect than
> other. =A0It makes sense in such a situation to allow the caller to
> specify what she is interested in. =A0A bitmask of some sort. =A0This=
 was
> brought up by the HPC people with gigantic filesystems.
>
> For this the syscall interface should have a parameter to specify wha=
t
> is requested and the stat-like structure should have a field
> specifying what is actually present. =A0The latter bitmask must be a
> superset of the former.
>
> Previous discussions centered around reusing the stat data structure
> and somehow make it work. =A0But no clean solution was found. =A0If a=
 new
> structure is added anyway this could solve the issue.

That makes sense, especially for network file systems.  NFSv4
protocol spec anticipates that:

"With the NFS version 4 protocol, the client is able query what attribu=
tes
   the server supports and construct requests with only those supported
   attributes (or a subset thereof)."

and we were talking about something similar for SMB2 Unix Extensions
(posix extensions) at the last plugfest (for SMB2 kernel
client to Samba)
and testing events.
--=20
Thanks,

Steve
