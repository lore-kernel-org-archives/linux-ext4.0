From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 21:41:01 +0100
Message-ID: <23973.1277844061@redhat.com>
References: <AANLkTimIh9ZAasPnN5xxGxbupwkct7UihHcMe26r-MD7@mail.gmail.com> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimIh9ZAasPnN5xxGxbupwkct7UihHcMe26r-MD7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> How does a fs return an "unknown" value for one
> (e.g. version field) ... 0  or -1  or ...

Well, for the new creation time, inode version and data version fields,=
 the
query_flags field has a bit for each that's set if the field contains a=
 value,
and is clear if it doesn't.

See the test program on patch 3.

> One hole that this reminded me about is how to return the superblock
> time granularity (for NFSv4 this is attribute 51 "time_delta" which
> is called on a superblock not on a file).  We run into time rounding
> issues with Samba too.

That sounds like something that should be accessible through statfs.  B=
ut it
could be made accessible here too.  It would also apply to FAT, which I
believe has a 2s granularity.

> > =A0(4) Should the inode number and data version number fields be 12=
8-bit?
> This is tricky for SMB2, if you can also provide a device id (or an o=
bject
> id of some sort for the superblock) then 64 bit inode number is ok.

A remote device ID?  That would be possible.  That could be used by AFS=
 to
return the numeric volume ID (32 bits) and by NFS to return the FSID (1=
28
bits).  Would you be using the VolumeGUID (128 bits) for SMB2?


David
