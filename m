From: Neil Brown <neilb@suse.de>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 09:28:50 +1000
Message-ID: <19092.29618.98997.854784@notabene.brown>
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<20090316122847.GI2405@elf.ucw.cz>
	<200903161426.24904.rob@landley.net>
	<20090323104525.GA17969@elf.ucw.cz>
	<87ljqn82zc.fsf@frosties.localdomain>
	<20090824093143.GD25591@elf.ucw.cz>
	<87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Machek <pavel@ucw.cz>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: message from Greg Freemyer on Monday August 24
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday August 24, greg.freemyer@gmail.com wrote:
> > +Don't damage the old data on a failed write (ATOMIC-WRITES)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Either whole sector is correctly written or nothing is written dur=
ing
> > +powerfail.
> > +
> > + =A0 =A0 =A0 Because RAM tends to fail faster than rest of system =
during
> > + =A0 =A0 =A0 powerfail, special hw killing DMA transfers may be ne=
cessary;
> > + =A0 =A0 =A0 otherwise, disks may write garbage during powerfail.
> > + =A0 =A0 =A0 This may be quite common on generic PC machines.
> > +
> > + =A0 =A0 =A0 Note that atomic write is very hard to guarantee for =
RAID-4/5/6,
> > + =A0 =A0 =A0 because it needs to write both changed data, and pari=
ty, to
> > + =A0 =A0 =A0 different disks. (But it will only really show up in =
degraded mode).
> > + =A0 =A0 =A0 UPS for RAID array should help.
>=20
> Can someone clarify if this is true in raid-6 with just a single disk
> failure?  I don't see why it would be.

It does affect raid6 with a single drive missing.

After an unclean shutdown you cannot trust any Parity block as it
is possible that some of the blocks in the stripe have been updated,
but others have not.  So you must assume that all parity blocks are
wrong and update them.  If you have a missing disk you cannot do that.

To take a more concrete example, imagine a 5 device RAID6 with
3 data blocks D0 D1 D2 as well a P and Q on some stripe.
Suppose that we crashed while updating D0, which would have involved
writing out D0, P and Q.
On restart, suppose D2 is missing. It is possible that 0, 1, 2, or 3
of D0, P and Q have been updated and the others not.
We can try to recompute D2 from D0 D1 and P, from
D0 P and Q or from D1, P and Q.

We could conceivably try each of those and if they all produce the
same result we might be confident of it.
If two produced the same result and the other was different we could
use a voting process to choose the 'best'.  And in this particular
case I think that would work.  If 0 or 3 had been updates, all would
be the same.  If only 1 was updated, then the combinations that
exclude it will match.  If 2 were updated, then the combinations that
exclude the non-updated block will match.

But if both D0 and D1 were being updated I think there would be too
many combinations and it would be very possibly that all three
computed values for D2 would be different.

So yes: a singly degraded RAID6 cannot promise no data corruption
after an unclean shutdown.  That is why "mdadm" will not assemble such
an array unless you use "--force" to acknowledge that there has been a
problem.=20

NeilBrown
