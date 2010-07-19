From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Mon, 19 Jul 2010 18:26:40 +0100
Message-ID: <11817.1279560400@redhat.com>
References: <AANLkTinVns77R7yCCh-lydd0eQufdAF9O2OaWmCL7uSn@mail.gmail.com> <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <AANLkTikuzYqYpGHcubb7QVciZW0dNFjOG82qIwy5M4gO@mail.gmail.com> <10783.1279556132@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinVns77R7yCCh-lydd0eQufdAF9O2OaWmCL7uSn-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> > The new information is useful for some cases. =A0Samba for example.=
 =A0At
> > least two of the fields I'm adding are also made available through =
BSD's
> > stat() call, and will automatically be used for some things by auto=
conf
> > magic if they become available.
>=20
> .. that' a pointless argument. If the only way something gets used is
> through autoconf, then clearly nobody cares.

That's not what I meant at all.  I meant there may be things out there =
that
will just use st_btime and st_gen as soon as they appear without anythi=
ng
having to be done to them because these fields already exist in the BSD=
 stat
struct.

Samba is such an example as this.  It will use st_btime immediately if =
it
exists as the SMB protocol wants to pass the creation time around.

> Yeah, maybe it adds a flag to "ls", but let's face is - that isn't ac=
tually
> _buying_ anything.

Not having ls cause a mass automount just because you did an ls of a di=
rectory
full of automount points would be very nice.

> So the only thing that matters for new system calls is who actually
> really seriously wants to use the information, even if it's not there
> by default. Is it _anybody_ else than samba?

Perhaps.  As previously mentioned, BSD (and other unices) already make =
some of
these fields available (notably st_btime and st_gen).  We could also ma=
ke a
BSD-compatible st_flags available.

> In other words, in the absense of some seriously generic users, it
> sounds more like an ioctl to me to ask for something like "creation
> time" or "inode version", when not all filesystems support anything
> like that.

I initially did them by getxattr(), but that didn't go down too well.

> Ask your samba people, for example, if they'd _ever_ do just a "xstat=
()"?

I suspect they would, though maybe they can say otherwise.  What about =
SMB
directory enumeration?  I believe that is effectively getdents-with-sta=
t.
Having to do open+stat for each file for that would be painful.

David
