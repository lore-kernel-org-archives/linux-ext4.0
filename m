From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Subject: Re: ext4 build errors
Date: Mon, 2 Oct 2017 15:15:33 +0000
Message-ID: <1506957332.985.22.camel@infinera.com>
References: <1506954181.985.9.camel@infinera.com>
         <20171002145517.652p7p7q4vv5rqcc@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bn3nam01on0051.outbound.protection.outlook.com ([104.47.33.51]:56640
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751773AbdJBPPi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 2 Oct 2017 11:15:38 -0400
In-Reply-To: <20171002145517.652p7p7q4vv5rqcc@thunk.org>
Content-Language: en-US
Content-ID: <D1E8CE385DEF1340A98DB3CBE5EB800E@infinera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2017-10-02 at 10:55 -0400, Theodore Ts'o wrote:
> On Mon, Oct 02, 2017 at 02:23:02PM +0000, Joakim Tjernlund wrote:
> > Hi ext4 devs
> >=20
> > Adding the patch last in this mail cause lots of build errors in ext4, =
here is a few:
>=20
> Why did you need this patch to fix problems in VirtualBox?

Earlier VirtualBox had some c++ code that included kernel header and g++ is
much pickier about these things so I had to do some cleanups to build
some of the VirtualBox modules. I think it is better now but I haven't real=
ly checked.

>=20
> Cleaning this up is going to be a little tricky, because one of the
> implications the void * declaration in the __set_bit_le() declaration
> is that there isn't any particular alignment requirement with the __le
> functions.  But the long * declaration implies that the bitmaps have
> to be aligned to sizeof(long).
>=20
> For the ext4 bitmap, we use it on bh->b_data, for which we can safely
> assume is long-aligned.  But the mballoc buddy bitmaps use
> mb_set_bit() in ways that are _not_ guaranteed to be long aligned.
>=20
> So fixing this is going to be a bit painful, and will likely result in
> a performance regression for ext4.  We can make our own version that
> open codes it as C functions --- but then we lose all of the
> architecture optimized bitop functions.
>=20
> I believe the reason why the standard bitop functions are made long *
> aligned is that on some BE architectures --- I suspect it was PowerPC
> but I'm not 100% sure about that --- the native bitop functions
> required a long * alignment.  Fortunately all of the little endian
> architectures didn't have these alignment restrictions, so we could
> keep the __set_bit_le functions to not have any long alignment
> restrictions.

If this is a special case for ext4, can you not just do an explicit
type cast in ext4 code?=20

>=20
> The fact that bitop and the bitop_le functions are not the same
> is... inelegant, but if it represents a practical optimization that is
> possible on LE systems but not on BE systems (where bitop_le gets open
> coded in C, in an inefficient way, but oh, well, BE systems aren't for
> the cool kids anyway :-), I have to ask whether it's really worth it
> to do the cleanup.

I see, but by using void * you also loose type checking w.r.t size so
if you by mistake use an u32, you will not notice.

 Jocke=
