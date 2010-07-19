From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
	file stats available [ver #6]
Date: Mon, 19 Jul 2010 08:17:14 -0700
Message-ID: <AANLkTikuzYqYpGHcubb7QVciZW0dNFjOG82qIwy5M4gO@mail.gmail.com>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 14, 2010 at 7:17 PM, David Howells <dhowells@redhat.com> wr=
ote:
>
> =A0 =A0 =A0 =A0ssize_t ret =3D xstat(int dfd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *fi=
lename,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned flags=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct x=
stat_parameters *params,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat *=
buffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t buflen)=
;

Ugh. So I think this is pretty disgusting. For a few reasons:

 - that whole xstat buffer handling is just a mess. I think you
already fixed the "xstat_parameters" crud and just made it a simple
unsigned long and a direct argument, but the "buffer+buflen" thing is
still disgusting.

   Why not just leave a few empty fields at the end, and make the rule
be: "We don't just add random crap, so don't expect it to grow widely
in the future".

 - you use "long long" all over the place. Don't do that. If you want
a fixed size, say so, and use "u64/s64". That's the _real_ fixed size,
and "long long" just _happens_ to be the same size on all current
architectures.

   Put another way: "long" just _happened_ to be 32 bits way back when
on pretty much all targets. That's where all the 64-bit compatibility
mess came from. Don't make the same mistake. Besides, if the point is
to make things be the same, _document_ that point by using a type that
is explicitly sized.

 - why create that new kind of xstat() that realistically absolutely
nobody will use outside of some very special cases, and that has no
real advantages for 99.9% of all people?

   You could make it a "atomic stat+open" by replacing the useless
"size" return value with a "fd" return value, add a flag saying "we're
also interested in opening it" (in the same result set flags), and
instead of that stupid "buflen" input, give the "mode" input that open
needs.

   Tadaa! You now have something that more people might be interested
in, if only because it avoids a system call and might be a performance
win. Who knows. Ask the Wine people what strange
open-function-from-hell they are interested in.

> =A0 =A0 =A0 =A0ssize_t ret =3D fxstat(unsigned fd,

Quite frankly, my gut feel is that once you do "xstat(dfd, filename,
=2E..)" then it's damn stupid to do a separate "fxstat()", when you
might as well say that "xtstat(dfd, NULL, ...)" is the same as
"fxstat(fd, ...)"

Now, the difference between adding one or two system calls may not be
huge, but just from a cleanliness angle, I really don't see the point
of having another fstat variant when the extended xstat() already very
naturally supports the thing. And let's face it, using a NULL path
pointer just makes sense if you don't have a path. You already passed
it a target file descriptor in the dfd.

Anyway, I didn't look at whether the new xstat fields made any sense,
but I hated the interface enough that I can't be bothered to. Don't
make up baroque new things that will never be used. Make a better
argument for why anybody would use them despite the lack of
standardization etc. And make sure they are as simple as possible
(which is why I hate that "buflen" thing etc).

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
