From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: [PATCH 2/3] fs: Remove ext3 filesystem driver
Date: Tue, 28 Jul 2015 15:50:04 -0600
Message-ID: <20150728215004.GA15904@untroubled.org>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
 <1436955987-7305-3-git-send-email-jack@suse.com>
 <20150715095822.f994bc58.akpm@linux-foundation.org>
 <55A699CD.5090304@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from untroubled.org ([69.5.1.51]:44886 "HELO untroubled.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750791AbbG1V4s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jul 2015 17:56:48 -0400
Content-Disposition: inline
In-Reply-To: <55A699CD.5090304@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2015 at 01:35:09PM -0400, Austin S Hemmelgarn wrote:
> On 2015-07-15 12:58, Andrew Morton wrote:
> > Also, what's the status of ext4's data=3Djournal?  It's the hardest ext3
> > mode for the rest of the kernel to support and I suspect hardly anyone
> > uses it.
> I use it, as do some other people I know, but only for stuff that pretty=
=20
> much needs to be 100% guaranteed to be consistent after a power failure.=
=20
>   It is _very_ slow, but it does work correctly based on my recent=20
> experience.

It is also a benefit for workloads that are heavy on sync writes to
(relatively) small files, such as mail servers. At least, it used to be
considerably faster than data=3Dordered the last time I benchmarked it.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVt/kMAAoJEFFRvcnBTTxn09UP/3DwtnlZG/XzA3XSKkG71KQS
knvLya8EszhDWalHb9VASfx86Zigqmyt8bWfkwLTqg5YXj8Vldt9FW/jWu0d/LG6
RSIyktmusriL08qLuvFec2Q3HQtbFpW9rezhIndIdi/t1WhgM/LggHQoTsG/ooji
rTITBj9m2C6YvebaFbWHOfEkkVMXWcqG4qqLwmH99U3X8zmk/uloxBF+wT/RBa1e
KPVuS77nwlKoUBTshFG5kXF0hlOL1sPRVFMA5QzMbH+kauuC3TpX1tZmkL7Rl0/R
cev7dA1g1EnmLwQgnV0YNVfBjzIwSZwvsFZou3nGDRERVOXiuRxT8gl/YHtqwLef
T7tlDUHsRdOe8fTVUvNBK0lWiMeAz9Kez4eFMhEE6PYx8ieWmUyJeRl0RTvm0LIR
jwJ3oJJGC37GILkupiuv62LpQiqUagoIfyxD6C7hg4jhhFb9xpiVzWSGfF3eehAU
yhFCDQq/7jZDUWg3LLTPXwwg6K93d8KomiWnN/JKEAL+oOKgm9wm2EiN838V6qQB
xDv6piegWi0cXLqXL/cj/zw90ZuoQrpnctUHxVJaFaWGX8wqCgpptaV0lYMq09JS
ekxGtJ1KWXRsIC4lcK9mf1/IKWZWoHHt/JxbX7++kHtS+An0PkfjYEm8pjKKZWWu
K5l+sHyn4XY2zj68xye9
=t5gY
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
