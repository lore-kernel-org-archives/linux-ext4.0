From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Subject: Re: [EXTERNAL]Re: [EXTERNAL]Re: ext4 build errors
Date: Mon, 2 Oct 2017 20:12:58 +0000
Message-ID: <1506975177.24473.15.camel@infinera.com>
References: <1506954181.985.9.camel@infinera.com>
         <20171002145517.652p7p7q4vv5rqcc@thunk.org>
         <1506957332.985.22.camel@infinera.com>
         <20171002165408.fhgsykuwautesn4v@thunk.org>
         <1506965229.24473.9.camel@infinera.com>
         <20171002184035.hwbkntpuup7ikqyv@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-co1nam03on0072.outbound.protection.outlook.com ([104.47.40.72]:27520
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751062AbdJBUNE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 2 Oct 2017 16:13:04 -0400
In-Reply-To: <20171002184035.hwbkntpuup7ikqyv@thunk.org>
Content-Language: en-US
Content-ID: <6A7AE3550F42ED4AAAB47F2A1934A75A@infinera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2017-10-02 at 14:40 -0400, Theodore Ts'o wrote:
> On Mon, Oct 02, 2017 at 05:27:12PM +0000, Joakim Tjernlund wrote:
> > > This is why void * is the right thing --- it's not a u32 or a long.
> > > It's a bit array.  And in the case of the mb buddy bitmap, it's not
> > > necessarily going to start on a a byte boundary which is a multiple o=
f
> > > 4 or 8.
> >=20
> > For ext4 it might be right but I was using "you" in a wider scope,
> > the rest of kernel src.
>=20
> So let's take this up to a high level of the problem.  For the bitops
> functions, there are two sorts of users.  Those that want to operate
> on an integer type (either a u32 or a long), and those that operate on
> bitarrays.  Most of the integer users are using the bitops for
> in-memory state flags.  Most of the bitarray use cases are for things
> like ext4's allocation bitmaps, where the on-disk format needs to be
> portable across architectures --- and that's where bitops_le tends to
> be used.
>=20
> Taking a quick look at the output of "git grep set_bit_le", most of
> the users are just like ext4, where it's being used for a bitarray.
> So my argument I think *does* apply much more widely.

OK, I can see that. It is just that __set_bit_le is impl. using=20
__set_bit(long nr, volatile unsigned long *addr) and that implies, to me,
that the memory should be long aligned.=20

 Jocke=
