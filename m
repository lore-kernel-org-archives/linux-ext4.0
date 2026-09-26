Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8905B7478
	for <linux-ext4@vger.kernel.org>; Sat, 26 Sep 2026 08:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790412680; cv=none; b=i/ytJwCbj33Fm58/f4Fwn7YyCnTa7svBUeK93drvqU7fbMwmGMGCqlsnALyHU5JDo37KjuvoiNSrQI92WoGJHGPITgCTCw2K5+dfB+IwMZ7Wa+XMor4tDeWnvJmcO3Gs5LdY/AS7FJh6OKzwbKIp9mT9e+8j4NVv2PqUuksSqfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790412680; c=relaxed/simple;
	bh=0IblYqtCVTK8cpOmhy/HXVJQLJIGXaVBHpZNo8UJvdo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Kd2Khm/TC2OIDYNKNFtfByXCF2HedzQ4g79bCanPT0qOsJs5jT5Um7StGv4KnLAQoXXtrB42h7wpsBV4wieq7Q2EHJRMCciY4Zo18cFDHnUlyGQpyufXO2lzGmP3C8C0XXnpwrkLWScuszKRdL2boQoeIQXZkGpfuB/rgO++l8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40] (unknown [IPv6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 57B7E3F11B
	for <linux-ext4@vger.kernel.org>; Sat, 26 Sep 2026 10:41:59 +0200 (CEST)
Message-ID: <3e5c9a29-03a3-47d5-9e85-e4ffaebc51d8@hogyros.de>
Date: Sat, 26 Sep 2026 17:41:44 +0900
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-ext4@vger.kernel.org
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
Subject: data=journal and the j attribute
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ocmIZx20LJRu2YRdTZBN1mP3"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ocmIZx20LJRu2YRdTZBN1mP3
Content-Type: multipart/mixed; boundary="------------dVCa0j0FlkLHtPaKpJ8im5kI";
 protected-headers="v1"
From: Simon Richter <Simon.Richter@hogyros.de>
To: linux-ext4@vger.kernel.org
Message-ID: <3e5c9a29-03a3-47d5-9e85-e4ffaebc51d8@hogyros.de>
Subject: data=journal and the j attribute

--------------dVCa0j0FlkLHtPaKpJ8im5kI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQoNCmlmICJkYXRhPWpvdXJuYWwiIGlzIGRlcHJlY2F0ZWQsIGRvZXMgdGhhdCBhbHNv
IGRlcHJlY2F0ZSB0aGUgImoiIA0KYXR0cmlidXRlPyAoaS5lLiBkb2VzIHRoYXQgZG9jdW1l
bnRhdGlvbiBhbHNvIG5lZWQgdG8gYmUgdXBkYXRlZD8pDQoNCiAgICBTaW1vbg0K

--------------dVCa0j0FlkLHtPaKpJ8im5kI--

--------------ocmIZx20LJRu2YRdTZBN1mP3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEtjuqOJSXmNjSiX3Tfr04e7CZCBEFAmq3hVMACgkQfr04e7CZ
CBFmMQf+MeCtNBdy4+sIA3KV9xyiXl5Jn650XTBi/tdD1VkuZT7q+Sis/s1Tuoph
4+2twCT3JROsjP6wom/cuJPi/mwidmafFQbugfVoq+QmloKO35ezGl4XXvU/x5AQ
SZ1w9nIZR1CKg5twN1G8UZ2PKBeYUX+31/dOyB01p1MI8vYEY55Ynp9i0oF6tdgP
ycNEvUDQ9etreIcV2ZpeRBG/vg0js3BitM1xLkKZRhMqDYGAlZC+ggyN6nXf3B6T
714YXzDgtqIQVydImgyhlylwmimYCK+uJPV3hjeBuJ3Ie7wrCVQCq6cDCfUF/pkQ
LXX4kngjfwKVevWOtZlQX55F76bfbA==
=Hhwz
-----END PGP SIGNATURE-----

--------------ocmIZx20LJRu2YRdTZBN1mP3--
