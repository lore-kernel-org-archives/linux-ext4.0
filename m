From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 08:43:04 +0200
Message-ID: <20170725064304.GA11723@amd>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
To: Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46449 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdGYGnG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jul 2017 02:43:06 -0400
Content-Disposition: inline
In-Reply-To: <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-07-25 00:51:56, Theodore Ts'o wrote:
> On Mon, Jul 24, 2017 at 10:04:51PM +0200, Pavel Machek wrote:
> > Question for you was... Is the first 1KiB of each ext4 filesystem still
> > free and "reserved for a bootloader"?
>=20
> Yes.

Thanks.

> > If I needed more for bcache superblock (8KiB, IIRC), would that be
> > easy to accomplish on existing filesystem?
>=20
> Huh?  Why would the bcache superblock matter when you're talking about
> the ext4 layout?  The bcache superblock will be on the bcache
> device/partition, and the ext4 superblock will be on the ext4
> device/partition.

I'd like to enable bcache on already existing ext4 partition. AFAICT
normal situation, even on the backing device, is:

| 8KiB bcache superblock | 1KiB reserved | ext4 superblock | 400GB data |

Unfortunately, that would mean shifting 400GB data 8KB forward, and
compatibility problems. So I'd prefer adding bcache superblock into
the reserved space, so I can have caching _and_ compatibility with
grub2 etc (and avoid 400GB move):

| 1KiB (modified) bcache superblock | ext4 superblock | 400GB data |

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll26HgACgkQMOfwapXb+vKPFQCfXSMMm45Xc4MyB3XktnTPl6cs
Zv4Anj4AP7It52Ut270Q0/EmqYcN4ral
=3CPG
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
