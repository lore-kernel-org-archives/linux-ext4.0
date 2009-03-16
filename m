From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 16 Mar 2009 22:48:25 +0100
Message-ID: <20090316214825.GC12308@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <87f94c370903161245u727090a7m93735d1b57971d9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87f94c370903161245u727090a7m93735d1b57971d9f@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 2009-03-16 15:45:36, Greg Freemyer wrote:
> On Thu, Mar 12, 2009 at 5:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
> <snip>
> > +Sector writes are atomic (ATOMIC-SECTORS)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Either whole sector is correctly written or nothing is written dur=
ing
> > +powerfail.
> > +
> > + =A0 =A0 =A0 Unfortuantely, none of the cheap USB/SD flash cards I=
 seen do
> > + =A0 =A0 =A0 behave like this, and are unsuitable for all linux fi=
lesystems
> > + =A0 =A0 =A0 I know.
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 An inherent problem with using flash =
as a normal block
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 device is that the flash erase size i=
s bigger than
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 most filesystem sector sizes. =A0So w=
hen you request a
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 write, it may erase and rewrite the n=
ext 64k, 128k, or
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 even a couple megabytes on the really=
 _big_ ones.
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 If you lose power in the middle of th=
at, filesystem
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 won't notice that data in the "sector=
s" _around_ the
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 one your were trying to write to got =
trashed.
>=20
> I had *assumed* that SSDs worked like:
>=20
> 1) write request comes in
> 2) new unused erase block area marked to hold the new data
> 3) updated data written to the previously unused erase block
> 4) mapping updated to replace the old erase block with the new one
>=20
> If it were done that way, a failure in the middle would just leave th=
e
> SSD with the old data in it.

The really expensive ones (Intel SSD) apparently work like that, but I
never seen one of those. USB sticks and SD cards I tried behave like I
described above.
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
