From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Mon, 11 Jun 2012 14:41:31 +0300
Message-ID: <1339414891.2401.12.camel@sauron.fi.intel.com>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
	 <1339411562-17100-2-git-send-email-saugata.das@stericsson.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DxL3rsG/llSyPQYw6hpH"
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	Saugata Das <saugata.das@linaro.org>
To: Saugata Das <saugata.das@stericsson.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17558 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab2FKLho (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jun 2012 07:37:44 -0400
In-Reply-To: <1339411562-17100-2-git-send-email-saugata.das@stericsson.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-DxL3rsG/llSyPQYw6hpH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-11 at 16:16 +0530, Saugata Das wrote:
> +/* Get the context of the buffer within the underlying storage device */
> +static int ext4_get_context(struct page *page)
> +{
> +	if (page && page->mapping && page->mapping->host)
> +		return page->mapping->host->i_ino;
> +	else
> +		return 0;
> +}

Word "context" is very generic and it is widely used various things, and
I believe we should try to avoid overloading this term and obfuscating
the I/O stack with various functions and other identifiers like
"get_context()". This would hurt readability. It is fine to use it
withing the UFS-specific code, but not globally withing the kernel code.

I do not really have good name candidates, but even "ufscontext" is
already better than just "context". Or "iocontext" ? Or just "ufsdata" ?

--=20
Best Regards,
Artem Bityutskiy

--=-DxL3rsG/llSyPQYw6hpH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP1dlrAAoJECmIfjd9wqK0OrYP/RAZPz7knC0MnIatbM8yeiFF
OstklmN/o9JM/2jUSLzRVXKaYNGdQ2W5ZPyc452c7uXbPmvSjy1Yxr/els55Yg3l
hMs7gYvlJC5ptSzLYQFjx57RyXc7/bIrVp+Vz7soqFyIYyED5BF4SUQIzFZhjGs3
hfphdkGEQ3aiijn5JqYXvtSaUcDrrb5Ea/uJ39f8MpTUoDbkh6KbimMokuZsB6H1
RDhN/nJxJ53HLSIA4WsiCOkCopaUVcBNwT4jiftqJp+mcUtrl8/RHWN8cBlIsCVU
rpjJCg8jz3UjHam3W0VfcDCwZEfqszOYzuvqTeGCBxEn+gjQnmXwiD2n3oUTSmWg
5kskT9ipFo/5Im4bsnwAjBBiCdsyjW0gWBWlbwqwn6ccQbb/EmV/4fdo5s6jLBBg
l04x0SMUy6OEtqQISpdlGITp4sYX2L35CgtU4gnCzoSFKprtrp6HZgbGlcMoX7T7
X9Z+C487fbakq/X0Qcc5ouebxcYLdB+F9iJ+EG3Ys/uB8oD2XJqIttqXVDxVO59T
YM34Uu4TgCM2ScNQ2lHQakGt3+UX8xulR97mnQi8T6drUVgFZVZwHTs1NhpMRVOZ
+MSnUMswBYvRLmKBrehkZcR/0Z+VbKzhWSaAu7vsK/kggKIERH8bz80Fhbjs+oVF
QHzxgqIsiV1S4fLcuM1B
=4Fv5
-----END PGP SIGNATURE-----

--=-DxL3rsG/llSyPQYw6hpH--

