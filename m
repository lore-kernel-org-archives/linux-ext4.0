Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795125184;
	b=Tf3XxX0ZhMqzYG4o/fAF8E4HEXsGi/FCrpfBvwU8U6hVMnHaEZ9o3sSftkPZ95ZyZjf2
	 CxQdMVorREv9gASx8rltKmL62aMAVXOKFB7w/FOAXkj265ODVymFijZy6ZdXqK0uvkEfi
	 PiEKUv/t8jvvPf1Z4avUscJY/MQuDKsFkY/3PB2BPan0i+lz/PW81wCMyEQ7dwaf0y/8v
	 U/7pbEagFwLW8+ciyOg1LVUNHVPK0wnAFWKYtx97I6gx76m8jVDsMLj6D7nUh8BXQ/LJk
	 sfF1OfY8NWcUHNFNi/vHOHhkKz5+toGi3hEHCCmxwE4dtifnmoBLbQ7rfxAAS2cMtWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795125184;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xkKFdxlaBYT0rZguOxDE0+ba23COX0K4CyQmQ95PoCI=;
	b=cyHLFjMBOFCne3rdc/gfhnuCNRdaRK90rlkAKAt/dymma3I1W9juJj6x/TW8LenNeXB5
	 f0lRnQJrEZi0M312cUWR1yiezqSIls56ps7FkcgqycTYbkIIFEAgGY3z1b3mOnw4Oqc5e
	 Gg1nFHgY65qb7E/7mnyyAeoyU27zcVR+yIngLJX4Bkj+hdfXDCA8dTOmX5walMGeskgxi
	 m81ZZEio0wODaewdATAMuA7U343hKCXJXfhll0kxndzaOxMv7y9wY+ZIR2Hc8s5UfG7ra
	 OW68Vkh0qwswvJQkoubvBPswGzDcM+/6xACTLarY1h2Yu2cmIRSCnL8Ao7laLJNPnYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U4VHXmqA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB02606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U4VHXmqA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5991F000C6;
	Thu, 19 Nov 2026 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795125184;
	bh=xkKFdxlaBYT0rZguOxDE0+ba23COX0K4CyQmQ95PoCI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U4VHXmqAtHSFFbP1jFXGN02YbGT+fwhSz3uXvF7hzi2+cmkgsp4aws71yBjeeQzwf
	 efJvKLg7UeReGdPssoJ7I9i+eDomfYV9+y9d10rdfgpPRB5TsDRgfcHhCpuQhzE+CZ
	 8CPWq+NnEUp27NPKNluIcDKhwNpSThgEjduDXWRRyDjDKpSkYjlm/0CpRCJw/U0sYz
	 p1LM1rZ1nb10IBAFq5xofA6BOBSKo4ke7PFGGx3bU6ctCKzKZ+2C23rI+Bh9hNJHgp
	 nQtiFFrq8vrvjeIxEO3QQPIwOMRdxQE5P9hqcuMNP4FEMLuvcYvi9SHvrUMAumODQQ
	 TcgYhN3zKnSDw==
Message-ID: <sashiko-outbox-224110@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] f2fs: reject casefolded names that fold to ".",
 "..", or empty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti" <sarthakkukreti@google.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261119214944.1480596-4-sarthakkukreti@google.com>
References: <20261119214944.1480596-1-sarthakkukreti@google.com>
 <20261119214944.1480596-4-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 21:53:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Dmitry Torokhov <dtor@google.com>
>=20
> Filenames consisting only of ignorable Unicode characters fold to empty
> strings, and names with leading dots and ignorable characters can fold
> to "." or "..". Allowing such names in casefolded directories can corrupt
> directory structure or cause confusion with special entries.
>=20
> Reject any non-dot names that fold to empty, ".", or ".." during
> casefolded name setup, while still allowing invalid UTF-8 sequences to
> be handled as opaque byte sequences when strict mode is not enabled.
>=20
> Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119214944.1480=
596-1-sarthakkukreti@google.com?part=3D3

