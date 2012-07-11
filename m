From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Some warnings
Date: Wed, 11 Jul 2012 12:58:37 +0300
Message-ID: <1342000717.2963.147.camel@sauron>
References: <1342000571.2963.145.camel@sauron>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-nAfYqz+bO2RuK+H1Hyjc"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2GKJyW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 05:54:22 -0400
In-Reply-To: <1342000571.2963.145.camel@sauron>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-nAfYqz+bO2RuK+H1Hyjc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-11 at 12:56 +0300, Artem Bityutskiy wrote:
> In short, aiaia is a script which builds the kernel before patching (and
> uses sparse/smatch/coccinelle/cppplus while building) and after patching
> and compares to build logs in a smart way, and then tells you about new
> warnings/complaints from gcc/sparse/smatch/coccinelle. It also checks
> bisectability and reports about failures. I find it very useful for
> verifying incoming patches.

Oh, and the important point is that you may use parallel build, so if
you have a relatively fast machine, you do not have to wait too long. I
use -j18, for example.

--=20
Best Regards,
Artem Bityutskiy

--=-nAfYqz+bO2RuK+H1Hyjc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/U5NAAoJECmIfjd9wqK0+XQP/2m3+eGnLoaaNW8jQGPytSMB
BJ3XvoiGx9eWZcbqeWdjVeMVMX0Ef0wfdgfjxJnkqX1qJEfm3ssu2TlvFZxjTK9u
ratiCffa38CK8XOfKvtpJxvTd1YrVdiMXxrrlYObTC89G6A9dXQlh/Y/AJkggqzT
OgZC/MKtwTi0ba36jzOegvdR2HtbuzUfQf/rwm8EgDX0t54GIXu/5Ln8kae62wPJ
cbWetQ9HP/UoQsl2KdQQHm1vnukFMLbnIbaVSWQt9OP52lWLWvVKB9VpXJxAALP8
LUfLFj2wPYhhW1har4c0XW4b8AgPG24LE+BexvkdysCtEgfVAfnn2bO31ftnrO+t
3sa1NuHYrnRN+LalhdPP/O4UMJUPfZpzUPIAA6MX5hjbczoocV7qoOwl92go/Ss9
xuVKYLMNgpqnqhFX56JuwwtU3a1FqSvYEJsOGfbfdKoCz9t1deAUXinR2/aOdodI
F+R4JHAosDkOdw0DXJUkmfzeltEZ6D50t6AggkEjkkNAofyXCxHHxSqtrwUwL4WA
5gYJxqo0CAisTYIAlJMhQYo6KQl9VrtCLEqMM5TdAXspfNimJ/zTuO8WNzcpXItO
FT+qy2BQEvtxfpsQu2nrD8b/Aut4AJp+TJhOXk8Jzw0399PLDHYDlCU4eiUMuHbB
cpJiSnfYe90wLXytf1Zn
=aWNb
-----END PGP SIGNATURE-----

--=-nAfYqz+bO2RuK+H1Hyjc--

