From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 22:41:06 -0400
Message-ID: <200907012241.08962.vapier@gentoo.org>
References: <20090628133430.GA3594@mit.edu> <200907011742.28028.vapier@gentoo.org> <20090702022652.GI17054@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1286545.QFHZBE93RJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Matthew Burgess <matthew-Ugr1wgFcK0zneqvOfBTmdWD2FQJk+8+b@public.gmane.org>,
	Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090702022652.GI17054-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

--nextPart1286545.QFHZBE93RJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 July 2009 22:26:52 Theodore Tso wrote:
> On Wed, Jul 01, 2009 at 05:42:26PM -0400, Mike Frysinger wrote:
> > that's because -lfoo is an extension that GNU make supports (albeit, ki=
nd
> > of a lame one).  com_err has a similar problem:
> > http://sourceforge.net/tracker/?func=3Ddetail&aid=3D2813809&group_id=3D=
2406&ati
> >d=3D302406
>
> I've checked in a fix for this in the maint branch of e2fsprogs.

is the tracker the best place to submit bugs/patches ?  or should i send th=
em=20
elsewhere ?
=2Dmike

--nextPart1286545.QFHZBE93RJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKTB5EAAoJEEFjO5/oN/WBJgEQAMpwcjjoqVKADB972toDKOWb
Gunc0+HGDmYWgggVAAZQun3H+qf1TJl2YtLxYzVBX6/4tnQtIMwBJdtFMQvjSlRA
ZXQDTpxqkpz4RSdMq/lv0sJwZbvIDF3MI+EdJhcNBjAuSPTyl9Ta/Vn3pG9EWrSA
W+FfjFAxs4PwyL4CMdAbDDq3r0sWinAWVxiTKHuozB3f0ZYGr8L1zQkhadiXj+tA
I7WjKgLTAKPRfRlKxRJ9bHzDlNGYCpkAfmCBvSNBoZm5czUJtabsd02Il2OkxgOr
QgI4mUgylb3H8tmBeUfs15HisM5yEK3q7q5Paw55kvT3Ua+CsQwfWGnFvfTzIrmx
OTLnHzAXiGawSP67hXWlsilkRDj1A0cmBb8tmkUuB0odbgJlZTUf6MPCImT4/l0Y
8oTwhLm2FcP9V9tfJmkY101h51VRuSfsQ06Bc7/ZLfnCUM2gndGoHZdVhOCkVjvs
bu6VToTG1g0ADQ/BFxHqH3smmqEOF5mJxO4+jSg21cQXIGUBWVbIb2gBTpxLG6HN
Mjrqh1oWsRFSwazfqvh48DHtRHJEwUeZKF/jWtLc2X5m+QU0h3BcRaL1g1du30OM
Y6SgqEXxffMRMqVZiTLmJgezr2+3hfJWFl4f3zQsc/fGjxs7zDDT09aTmV/4cTKu
nbea4tl/kQ1fqkRsAHXE
=5JUR
-----END PGP SIGNATURE-----

--nextPart1286545.QFHZBE93RJ--
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
