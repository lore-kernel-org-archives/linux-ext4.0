From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Thu, 11 Dec 2008 08:32:26 -0800
Message-ID: <20081211163226.GA15057@kroah.com>
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081207204222.d811c00b.akpm@linux-foundation.org> <1228758923.7096.10.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@kernel.org,
	linux kernel <linux-kernel@vger.kernel.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-ext4@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757366AbYLKRoY@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1228758923.7096.10.camel@mingming-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 08, 2008 at 09:55:23AM -0800, Mingming Cao wrote:
> =E5=9C=A8 2008-12-07=E6=97=A5=E7=9A=84 20:42 -0800=EF=BC=8CAndrew Mor=
ton=E5=86=99=E9=81=93=EF=BC=9A
> > (cc stable)
> >=20
> > On Sun, 7 Dec 2008 10:28:21 -0500 Theodore Tso <tytso@mit.edu> wrot=
e:
> >=20
> > > On Sat, Dec 06, 2008 at 08:22:33PM -0800, Andrew Morton wrote:
> > > >=20
> > > > I suggest that what we do is to revert both those changes.  We =
can
> > > > worry about the possibly-unneeded spin_lock later, in a separat=
e patch.
> > > >=20
> > > > It should have been a separate patch anyway.  It's conceptually
> > > > unrelated and is not a bugfix, but it was mixed in with a bugfi=
x.
> > > >=20
> > > > Mingming, this needs urgent consideration, please.  Note that I=
 had to
> > > > make additional changes to ext4 due to the subsequent introduct=
ion of
> > > > the dirty_blocks counter.
> > >=20
> > > I've looked the two patches which you've queued in the -mm branch=
, and
> > > they look correct to me.
> > >=20
> > > The bugs fixed by these patches can potentially lead to filesyste=
m
> > > corruption, since we ultimately use these fields to set the super=
block
> > > values.  This in my mind makes them stable candidates at the very
> > > least, and if we weren't so late in the 2.6.28 cycle, I'd be stro=
ngly
> > > tempted to push them to Linus as a bugfix before the merge window=
=2E
> > >=20
> > > Andrew, any strong objections for me to grab them for the ext4 tr=
ee?
> > > Or would you rather carry them?  I would prefer that they get pus=
hed
> > > to Linus as soon as the merge window opens, which is one reason w=
hy
> > > I'd prefer carry them, but we can do this either way.
> > >=20
> >=20
> > I'm planning on sending them off to Linus for 2.6.28 this week,
> > assuming nobody can think of a plausible reason to not do that.
> >=20
> > Now I didn't look _very_ closely at the chronology, but I think tha=
t
> > revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch rev=
erts
> > a post-2.6.27 change, and is not needed in stable.
> >=20
> > revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> > however reverts a pre-2.6.27 change, and should be merged into 2.6.=
27.=20
> > This patch reverts the addition and use of
> > percpu_counter_sum_and_set(), which is racy and can corrupt the
> > counters.
> >=20
> > However
> > revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> > won't apply to 2.6.27 because the dirty_blocks stuff was added and
> > generates rejects.
> >=20
> > So if all the above is correct, I'd propose that if and when
> > revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> > hits mainline, we should ask the -stable guys to directly revert=20
> >=20
>=20
> Agreed.
>=20
> I checked 2.6.27.8, above are correct, the
> revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch is no=
t
> needed for 2.6.27.x stable tree.

Thanks for letting me know, I'll not include it in the 2.6.27-stable
tree then.

greg k-h
