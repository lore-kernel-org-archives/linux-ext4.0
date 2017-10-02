From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Subject: Re: [EXTERNAL]Re: ext4 build errors
Date: Mon, 2 Oct 2017 17:27:12 +0000
Message-ID: <1506965229.24473.9.camel@infinera.com>
References: <1506954181.985.9.camel@infinera.com>
         <20171002145517.652p7p7q4vv5rqcc@thunk.org>
         <1506957332.985.22.camel@infinera.com>
         <20171002165408.fhgsykuwautesn4v@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-co1nam03on0046.outbound.protection.outlook.com ([104.47.40.46]:6580
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751085AbdJBR1Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 2 Oct 2017 13:27:16 -0400
In-Reply-To: <20171002165408.fhgsykuwautesn4v@thunk.org>
Content-Language: en-US
Content-ID: <F6729A626BD3B243B925D3C3BFD8CA2D@infinera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2017-10-02 at 12:54 -0400, Theodore Ts'o wrote:
> On Mon, Oct 02, 2017 at 03:15:33PM +0000, Joakim Tjernlund wrote:
> > > I believe the reason why the standard bitop functions are made long *
> > > aligned is that on some BE architectures --- I suspect it was PowerPC
> > > but I'm not 100% sure about that --- the native bitop functions
> > > required a long * alignment.  Fortunately all of the little endian
> > > architectures didn't have these alignment restrictions, so we could
> > > keep the __set_bit_le functions to not have any long alignment
> > > restrictions.
> >=20
> > If this is a special case for ext4, can you not just do an explicit
> > type cast in ext4 code?
>=20
> Sure, it would be safe *today*, but then in the future someone might
> change an implementation of the bitop_le* functions for some
> architecture which would not tolerate unaligned pointers (since using
> a long * would imply this is allowed), and then things would break.

I guess I am missing something, the __set_bit_le calls __set_bit(nr ^ BITOP=
_LE_SWIZZLE, addr):
static inline void __set_bit_le(int nr, void *addr)
{
	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
}

and __set_bit assumes it is working on a long, why is is safe in __set_bit_=
le to cast
the void * into a long * but not in ext4 code?

>=20
> > > The fact that bitop and the bitop_le functions are not the same
> > > is... inelegant, but if it represents a practical optimization that i=
s
> > > possible on LE systems but not on BE systems (where bitop_le gets ope=
n
> > > coded in C, in an inefficient way, but oh, well, BE systems aren't fo=
r
> > > the cool kids anyway :-), I have to ask whether it's really worth it
> > > to do the cleanup.
> >=20
> > I see, but by using void * you also loose type checking w.r.t size so
> > if you by mistake use an u32, you will not notice.
>=20
> Um, we're never using a u32.  We're using a pointer into a bit array
> which is often far larger than 32 or 64 bits.  For example, when we
> use a 4k block size, then bh->b_data is a bit array which is 4096*8 =3D=
=3D
> 32,768 bits.
>=20
> This is why void * is the right thing --- it's not a u32 or a long.
> It's a bit array.  And in the case of the mb buddy bitmap, it's not
> necessarily going to start on a a byte boundary which is a multiple of
> 4 or 8.

For ext4 it might be right but I was using "you" in a wider scope,
the rest of kernel src.

 Jocke=
