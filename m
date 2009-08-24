From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Mon, 24 Aug 2009 20:44:21 +0200
Message-ID: <20090824184421.GC28403@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753318AbZHXSo2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


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
>=20
> And if not can the above text be changed to reflect raid 4/5 with a
> single disk failure and raid 6 with a double disk failure are the
> modes that have atomicity problems.

I don't know enough about raid-6, but... I said "degraded mode" above,
and you can read it as double failure in raid-6 case ;-). I'll prefer
to avoid too many details here.

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
