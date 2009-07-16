From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] configure: Disable fsck wrapper on Linux by default
Date: Thu, 16 Jul 2009 15:17:09 -0400
Message-ID: <200907161517.10883.vapier@gentoo.org>
References: <E1MRWBp-0000yS-Dx@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9694232.9lOm6HqCut";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1MRWBp-0000yS-Dx-eEhpo0tUqaMrEHDPZeG1zdBPR1lH4CV8@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

--nextPart9694232.9lOm6HqCut
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 16 July 2009 14:50:15 Scott James Remnant wrote:
>  [case "$host_os" in
> -  gnu*)
> +  gnu*|linux-gnu)

please use "*linux*"
-mike

--nextPart9694232.9lOm6HqCut
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKX3y2AAoJEEFjO5/oN/WBbNwQAI8hdW8kbP/VkTBOiKZvK+MC
FN5ZBXBQqM1Vtk7/D2jMIQ4CkfpLRMWzauhI7YmtaghKQYiUYE7vqkwPxLqSJTm7
UYC5TjYOL1FLj1ygu+Vtavdz7jrpOrNs6tPgRdJh5DsXPDq0SUo5McuEyXvSj4fa
x5VPnjq9eLtiO6Bpm9gdIxl3TXpc1H2YkMVjtNUtYWIl0PYwFxzcy3vuPJpnI4qr
SAJnTMr+XpPztC9c6vWcgMLr6ezQ7Z0Kfd+zOitbDeHxwoSJtpA0vRlvpUjrtRHL
c9BLd03XoQwgzKvIypddK05mBLenKRprH4bDEuVcShrGxeOeKVjH4d1Kfk/hJGj0
u+4RkLiivTHhhn70Olzq4Y4nEkl24UZoXvMP9QhKRJdEqLlr/Ljw9S6jqRW9DlP/
WYj6cKsoBsU1/El3EbceDkPx8/4JqxplbEG308Hkx5pQ2EKh/Wqd412FEhX6bmRx
kzc/kXySPAnSnUCg/Bg+Es1DptylaY8i4BILxNL6u5LC53aQnvjxK+//7RdvBZCt
XXwG3LsEW8gSv1ASwP94+5zcZ+82AOaP54oTK1nAsYttFHJjMzIWoS4TNrrZJYvB
4IFSv1PHbhPlI1EdKIgax4ldPPANPdNgDMCcbvAFlKKkV/14yQzO0cBAnvdIfX5N
pyTyM6gHidJ/T4IFAEkV
=NUbZ
-----END PGP SIGNATURE-----

--nextPart9694232.9lOm6HqCut--
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
