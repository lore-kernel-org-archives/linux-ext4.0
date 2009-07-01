From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 19:04:17 -0400
Message-ID: <200907011904.19243.vapier@gentoo.org>
References: <200905311113.23004.arvidjaar@mail.ru> <200907011835.08501.vapier@gentoo.org> <ac3eb2510907011539k3e2fb664g59ec4dc6f1ae5e0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3130802.m0z2iRq2Fe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ac3eb2510907011539k3e2fb664g59ec4dc6f1ae5e0a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

--nextPart3130802.m0z2iRq2Fe
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 July 2009 18:39:23 Kay Sievers wrote:
> On Thu, Jul 2, 2009 at 00:35, Mike Frysinger<vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
> >> In older udev releases, before we switched to automake, I had
> >> something like this, which behaves a bit like the Linux kernel build,
> >> and V=3D1 switches off the silent mode:
> >
> > why not just use automake-1.11's silent-rules option.  then you dont ha=
ve
> > to waste time reinventing the wheel.
>
> I do. :) But e2fsprogs don't use automake, only autoconf.

ah you're right of course.  i keep forgetting i have to send patches to fix=
 up=20
e2fsprogs Makefile.in's ... :/
=2Dmike

--nextPart3130802.m0z2iRq2Fe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKS+tzAAoJEEFjO5/oN/WBFuMP/A+YxNZxnc2xF12+7jz/fdmG
TKRYoS+BRGmQ0s0olI3R8zjF7YW2vnhSeadN8F9klK3dcimJ0TGXXiN4kEyclNTy
kZAwYDa0haCou8/BgpocrHSL4uCMqgumD5DQ6hkQNopHeD5SqkMouHqff50Tt8tF
/e0V7A7aIUh0LjWqphEnr45UvkbjtJRpLD7aeAFdL/h5ZHAEYDDfqK9KWRo9i3U5
89DCR5O6i9R3jC1etsmCBad1vi1hxXaKebqB7kxm9PPtHR6b31NUwWjcB51/c3kh
8a1Z76NgHV0yrJkXOQehWMG42pWf98iQ46Uc/EvlXQOdwfnZCwf1KQQ8RWGE+6Lk
yg/bFD9qEHS4/eMhyMCOmnny05VOgYMt+CLkwpeJq8uNCH36V5jcMnb5wI6OwbZD
WzUFJ6nAfyqOdLWvMKGp+2f2AW3j2pKV2D9HrCD+9PDvgD+GapBhRhkuD7e+W5Y+
z3s1Wot/ZSjnJSRF52sIOQ2fr7gyk5loi2NptQCPbvTkrGHhUailaxlPCqc1C795
coKurXl2IaLP6nQfBEEF4RKQFO5s/uN8zx6Y8yCN603911ACU/2T/fe5pIELY/5F
boN9IXTKJNBZ4YtcI0e9aQ1kmcQM/UTietiA3BH0z8FtW5uxXoEIyeL2zxBGbMgX
frzoqL+alfTzze9Nt7Nw
=3sTm
-----END PGP SIGNATURE-----

--nextPart3130802.m0z2iRq2Fe--
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
