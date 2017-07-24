From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Mon, 24 Jul 2017 22:04:51 +0200
Message-ID: <20170724200451.GA4318@amd>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
To: Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35377 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751832AbdGXUEx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jul 2017 16:04:53 -0400
Content-Disposition: inline
In-Reply-To: <20170724192718.t7n5zgualz5lillg@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon 2017-07-24 15:27:18, Theodore Ts'o wrote:
> On Mon, Jul 24, 2017 at 09:15:48PM +0200, Pavel Machek wrote:
> > >=20
> > > Am 24.07.2017 um 20:57 schrieb Pavel Machek:
> > > >Would it be feasible to run bcache (write-through) with existing ext4
> > > >filesystem?
> > > >
> > > >I have 400GB of data I'd rather not move, and SSD I could use for
> > > >caching. Ok, SSD is connecte over USB2, but I guess it is still way
> > > >faster then seeking harddrive on random access
> > >=20
> > > i doubt that seriously - USB2 has a terrible latency
> >=20
> > Well.. if that's too slow, I can get SSD M.2; plus bcache docs says
> > that combination works.
> >=20
> > And... if you ever tried to do git diff while git checkout is running
> > on spinning rust... spinning rust has awful parameters when idle, and
> > it only gets worse when loaded :-(.
>=20
> So some hard numbers.  Max throughput of USB 2.0 is 53 MiB/s[1].  In
> actual practice the max throughput you will see out of the USB 2.0
> interface is 30-40 MiB/s.  In contrast, a HDD doing sequential reads
> can easily do much more than that.
>=20
> [1] https://superuser.com/questions/317217/whats-the-maximum-typical-spee=
d-possible-with-a-usb2-0-drive
>=20
> So a lot is going to depend on how bcache works.  If you can get large
> sequential reads and writes to *bypass* the cache device, then I think
> there's a good cache that bcache on a USB 2.0 device won't hurt.  It
> might not help as much as you like, but that's a function of the
> overhead of populating the cache and whether the cache can keep the
> useful bits in the cache device.

Another useful number is that spinning rust does less than 3MB/sec on
common operations done by git. (Yes, probably because a lot of
seeking). So... USB device  should be able to help.

Question for you was... Is the first 1KiB of each ext4 filesystem still
free and "reserved for a bootloader"?

If I needed more for bcache superblock (8KiB, IIRC), would that be
easy to accomplish on existing filesystem?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll2UuMACgkQMOfwapXb+vI5lwCgjszj+JiMle7mjiWW0cWVb3R4
Ia0Aniv7C/D8Xjcl01gA1cq9z93K2l34
=jCGG
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
