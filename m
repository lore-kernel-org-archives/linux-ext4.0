From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Mon, 19 Jul 2010 17:15:32 +0100
Message-ID: <10783.1279556132@redhat.com>
References: <AANLkTikuzYqYpGHcubb7QVciZW0dNFjOG82qIwy5M4gO@mail.gmail.com> <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikuzYqYpGHcubb7QVciZW0dNFjOG82qIwy5M4gO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

>  - that whole xstat buffer handling is just a mess. I think you
> already fixed the "xstat_parameters" crud and just made it a simple
> unsigned long and a direct argument,

I was thinking more of an unsigned int argument, since it can't have mo=
re than
32 flags in it if it is also to work on 32-bit arches.

> but the "buffer+buflen" thing is still disgusting.
>
>    Why not just leave a few empty fields at the end, and make the rul=
e
> be: "We don't just add random crap, so don't expect it to grow widely
> in the future".

Because it gets allocated on the kernel stack.  It's already 160 bytes,=
 and
expanding it will eat more kernel stack space.  Now, I can offset that =
by: (a)
embedding it in struct kstat so that we allocate less stack space in xs=
tat()
overall, and (b) allocating kstat/xstat structs with kmalloc() rather t=
han on
the stack in all the stat syscalls.

>  - you use "long long" all over the place. Don't do that. If you want
> a fixed size, say so, and use "u64/s64". That's the _real_ fixed size=
,
> and "long long" just _happens_ to be the same size on all current
> architectures.

I was following struct stat/stat64 in arch/x86/include/asm/stat.h which=
 do the
same.  Also, if this is going to be seen by userspace, isn't it better =
to use
uint32_t and suchlike?

>  - why create that new kind of xstat() that realistically absolutely
> nobody will use outside of some very special cases, and that has no
> real advantages for 99.9% of all people?

The new information is useful for some cases.  Samba for example.  At l=
east
two of the fields I'm adding are also made available through BSD's stat=
()
call, and will automatically be used for some things by autoconf magic =
if they
become available.

I'm still trying to get a handle on what people think will be truly use=
ful.  I
can see things *could* be useful, particularly to GUI file managers and=
 ls,
but not everyone is of the same opinion.

Perhaps you or others can offer answers to the following questions as t=
hese
might help:

 (1) Should I offer information that's effectively free to come by, but=
 could
     be got through:

     (a) An extra statfs() call - such as whether a file is remote, whe=
ther
     	 it's some kernel special file?  Or what the volume label is for =
this
     	 file?

     (b) An extra getxattr() call - such as a file's security label.

     (c) An extra ioctl() call - such as FS_IOC_GETFLAGS.

 (2) Should I offer information that's appropriate to non-UNIX filesyst=
ems
     such as FAT, NTFS or CIFS.  Some of this may map onto other fields=
, such
     as FS_IOC_GETFLAGS.

 (3) Should I offer information about which results that I've returned =
are
     actually useful, as opposed to being fabricated on the spot?  Such=
 as
     UID/GID in FAT or blocks in UBIFS.  This may be of use to df or a =
GUI.
     For instance, a GUI, seeing that UID/GID aren't useful, could ask =
the
     filesystem to provide information about what it considers to be va=
lid
     ownership information.

>    You could make it a "atomic stat+open" by replacing the useless
> "size" return value with a "fd" return value, add a flag saying "we'r=
e
> also interested in opening it" (in the same result set flags), and
> instead of that stupid "buflen" input, give the "mode" input that ope=
n
> needs.

Which would be used by even fewer people, I suspect.  However, it's cer=
tainly
an interesting idea.  I suspect it doesn't gain much over open()+fstat(=
)
though, given that you'd still have to do most of the work of fstat() a=
fter
doing the open() thing anyway.

Also, I'm not sure how much use the atomicity is, given that the file m=
ay have
changed state between the gathering of the stat data and userspace gett=
ing to
do anything with it.

> > =A0 =A0 =A0 =A0ssize_t ret =3D fxstat(unsigned fd,
>=20
> Quite frankly, my gut feel is that once you do "xstat(dfd, filename,
> ...)" then it's damn stupid to do a separate "fxstat()", when you
> might as well say that "xtstat(dfd, NULL, ...)" is the same as
> "fxstat(fd, ...)"

This has been suggested and denounced as stupid already.  That said, I =
agree
with you.

> Now, the difference between adding one or two system calls may not be
> huge, but just from a cleanliness angle, I really don't see the point
> of having another fstat variant when the extended xstat() already ver=
y
> naturally supports the thing. And let's face it, using a NULL path
> pointer just makes sense if you don't have a path. You already passed
> it a target file descriptor in the dfd.

Agreed.

David
