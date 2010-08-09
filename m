From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 update for 2.6.36
Date: Mon, 9 Aug 2010 17:48:52 -0400
Message-ID: <20100809214852.GK3635@thunk.org>
References: <E1OhETF-0005P6-7v@tytso-glaptop>
 <AANLkTinJQ7DQK8_0ngHrbZugFBCgyM5ETUPhcDSmYGP6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40433 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0HIVtB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Aug 2010 17:49:01 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinJQ7DQK8_0ngHrbZugFBCgyM5ETUPhcDSmYGP6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 07, 2010 at 01:17:46PM -0700, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 9:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > Which is hopefully what you want. =C2=A0If you want exactly what is=
 shown
> > below, you can also pull the "next" branch, which omits the merge, =
and
> > then you can deal with the merge conflict by hand. =C2=A0The result=
s should
> > be the same either way.
>=20
> I did that just to see what it looked like.
>=20
> One annoyance: I now get
>=20
>   fs/jbd2/transaction.c: In function =E2=80=98start_this_handle=E2=80=
=99:
>   fs/jbd2/transaction.c:98: warning: unused variable =E2=80=98ts=E2=80=
=99
>=20
> due to that 'ts' thing only being used for the CONFIG_JBD2_DEBUG case=
=2E
> Please fix. I'd suggest putting that CONFIG_JBD2_DEBUG code in a
> helper function of its own, and declaring 'ts' there instead.
> Suggested patch (but with a horrible helper function name) attached.

This is what I have in the ext4 tree.  I'll be sending a pull request
in a day or two with this and maybe one or two other fixups if they
arise.  So far the post-integration testing I've done looks good,
though.

						- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
