From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 17:42:26 -0400
Message-ID: <200907011742.28028.vapier@gentoo.org>
References: <20090628133430.GA3594@mit.edu> <605694f0db343657e47df0d3e82e0bc9@quantum.linuxfromscratch.org> <20090701212844.GC17054@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1418416.i6Lp5WsWgs";
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
In-Reply-To: <20090701212844.GC17054-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

--nextPart1418416.i6Lp5WsWgs
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 July 2009 17:28:44 Theodore Tso wrote:
> On Wed, Jul 01, 2009 at 03:04:43PM -0600, Matthew Burgess wrote:
> > On Sun, 28 Jun 2009 09:34:30 -0400, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> > > I'll have a corrected patch checked into e2fsprogs.
> >
> > I get the following output when trying to compile e2fsprogs-1.41.7
> > against util-linux-ng-2.16-rc1's installed versions of libuuid &
> > libblkid
>
> Thanks for pointing that out.  Apparently GNU make wasn't failing when
> "-luuid" was in the dependency, which is why I didn't notice this
> earlier.  I'm not sure why it complains with "-L/tools/lib", but not
> with "-luuid", but whatever.  I've checked the following into the
> e2fsprogs maint branch.

that's because -lfoo is an extension that GNU make supports (albeit, kind o=
f a=20
lame one).  com_err has a similar problem:
http://sourceforge.net/tracker/?func=3Ddetail&aid=3D2813809&group_id=3D2406=
&atid=3D302406
=2Dmike

--nextPart1418416.i6Lp5WsWgs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKS9hDAAoJEEFjO5/oN/WBFx4QAJdw0Ek+JiM8xVA50qUbD6WT
07uzHfuIFHMWUHS/yxraIUXpgAoH7BxUVneYXgumXZz6Y4vn3CKMQwf+7B2RHpFt
cocclxNeiXYNuNe9yZE+3+Ye8fcygsZIR6ostv/k6LgHF4e+5CSkljz7WZeCoZ3u
psb3Tf4yA47n68AONxb6qsOgUyPw90VXlSuA5j1jAMGaIe9ivFddB2ANwf88cP1F
YldB/rA3OheVc9BMJT0vR0PzdgoWeUmZ3n3+AfB5rZJDMn4yfgPl/Yau+gIQrFhg
Up4ZTg6RXPFCY1zUPouC11e1id7vSjbMhUVCjaJ1upWQeDX51iVmNwiuhn1PeRKW
gWyIS0wijYnz6Gi0wzoZdrmXvvd1SrQ6DOO8op1B3AyjXOjkwSF8VMu/n2/oET7y
nYiyL49ld4kQZKs2Nq5UZyhHHuw38aGuYW2m08JyXQ7oIBkpY8eOZo0zqYH94m+N
ekCzNLRtShvyOUdzkR5ZyjctXuwpDOIRShOvEVp4DHYdR2HKts62/9mPsFodws7A
guXriykkGJCoIrkTO65AG5Xqud+9/DfQ22rysNW+mh0LtCDpK6MELmgn4IaN95Yd
v1PUNL8yP235RYVtsHJvTR4/hVbrKxQx776BnBqBeU1r56hoEUNaGX8hQZGspGkG
GQZhV3DY5pJS2TADEKF6
=Q1AI
-----END PGP SIGNATURE-----

--nextPart1418416.i6Lp5WsWgs--
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
