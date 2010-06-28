From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and
	i_generation available by xattrs
Date: Mon, 28 Jun 2010 10:14:44 -0700
Message-ID: <20100628171444.GB9979@samba1>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com> <20100628164854.GA9979@samba1> <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 28, 2010 at 12:04:09PM -0500, Steve French wrote:
> On Mon, Jun 28, 2010 at 11:48 AM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Mon, Jun 28, 2010 at 11:33:10AM -0500, Steve French wrote:
> >>
> >> It would be easy enough to do something similar for crtime for cif=
s
> >> (it may also be possible to do something similar to
> >> i_generation and i_version at least for smb2 but haven't
> >> experimented to see which servers could return something
> >> similar to version and generation). =A0I did have a request for
> >> someone doing a backup application over cifs to return creation
> >> time so at least this would make sense.
> >
> > We already have code in Samba to detect "birthtime"
> > (st_btime) as a returned member of a stat struct.
> >
> > This already works on many other platforms, so I'd
> > rather just have Linux stat fixed to work with
> > btime.
>=20
> That sounds better but it hits the fs, vfs and libc
> and seems like libc is near impossible to get changes into.

It's a software project, it gets new features. This
is a new feature that is necessary to support new
file system features.

> Seems like in the short term adding xattrs is harmless, and
> doesn't hurt in the longrun

Yes it does. It's trying to do an end-run around
adding this into the entire stack where it'll be
useful for all applications. Samba releases live
forever. Do you want to be still maintaining the
"btime as xattr" stuff in 20 years ?

=46ix it once, fix it right.

Jeremy.
