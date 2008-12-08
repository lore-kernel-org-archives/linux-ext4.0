From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 08 Dec 2008 09:55:23 -0800
Message-ID: <1228758923.7096.10.camel@mingming-laptop>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081207204222.d811c00b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-ext4@vger.kernel.org, stable@kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:34910 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYLHRz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 12:55:29 -0500
In-Reply-To: <20081207204222.d811c00b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E5=9C=A8 2008-12-07=E6=97=A5=E7=9A=84 20:42 -0800=EF=BC=8CAndrew Morto=
n=E5=86=99=E9=81=93=EF=BC=9A
> (cc stable)
>=20
> On Sun, 7 Dec 2008 10:28:21 -0500 Theodore Tso <tytso@mit.edu> wrote:
>=20
> > On Sat, Dec 06, 2008 at 08:22:33PM -0800, Andrew Morton wrote:
> > >=20
> > > I suggest that what we do is to revert both those changes.  We ca=
n
> > > worry about the possibly-unneeded spin_lock later, in a separate =
patch.
> > >=20
> > > It should have been a separate patch anyway.  It's conceptually
> > > unrelated and is not a bugfix, but it was mixed in with a bugfix.
> > >=20
> > > Mingming, this needs urgent consideration, please.  Note that I h=
ad to
> > > make additional changes to ext4 due to the subsequent introductio=
n of
> > > the dirty_blocks counter.
> >=20
> > I've looked the two patches which you've queued in the -mm branch, =
and
> > they look correct to me.
> >=20
> > The bugs fixed by these patches can potentially lead to filesystem
> > corruption, since we ultimately use these fields to set the superbl=
ock
> > values.  This in my mind makes them stable candidates at the very
> > least, and if we weren't so late in the 2.6.28 cycle, I'd be strong=
ly
> > tempted to push them to Linus as a bugfix before the merge window.
> >=20
> > Andrew, any strong objections for me to grab them for the ext4 tree=
?
> > Or would you rather carry them?  I would prefer that they get pushe=
d
> > to Linus as soon as the merge window opens, which is one reason why
> > I'd prefer carry them, but we can do this either way.
> >=20
>=20
> I'm planning on sending them off to Linus for 2.6.28 this week,
> assuming nobody can think of a plausible reason to not do that.
>=20
> Now I didn't look _very_ closely at the chronology, but I think that
> revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch rever=
ts
> a post-2.6.27 change, and is not needed in stable.
>=20
> revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> however reverts a pre-2.6.27 change, and should be merged into 2.6.27=
=2E=20
> This patch reverts the addition and use of
> percpu_counter_sum_and_set(), which is racy and can corrupt the
> counters.
>=20
> However
> revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> won't apply to 2.6.27 because the dirty_blocks stuff was added and
> generates rejects.
>=20
> So if all the above is correct, I'd propose that if and when
> revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> hits mainline, we should ask the -stable guys to directly revert=20
>=20

Agreed.

I checked 2.6.27.8, above are correct, the
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch is not
needed for 2.6.27.x stable tree.

Thanks again.

Mingming
>     commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e
>     Author: Mingming Cao <cmm@us.ibm.com>
>     Date:   Fri Jul 11 19:27:31 2008 -0400
>=20
>         percpu_counter: new function percpu_counter_sum_and_set
>=20
> which should be all that 2.6.27.x needs.
>=20
> Agree?  If so, can you please take care of getting that patch over to
> stable@kernel.org?  (I added the cc:stable to the diff, so there's
> probably nothing which you need to do..)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
