Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714217;
	b=gXP1liIAuOgPXI8tpfGd/NfI8nsiTluj+3T/eeZO2JDDUaBWPkv2XEWQN45fHKwOX4BL
	 BnIuxs+Wvud2KtMLbPEUlT2Qt1R6RGVxsn8vFZjhqG64Rtz1aZlp6nvLnfr9a5a2JUGgr
	 G2wlSE3maaB0J4Mue0IlA0JwB8YK3OTjPMLIbpyom8NVxmXU+B7K2jmRF7qy7W4l69sCY
	 g6eANxvDVtx/V/7ZkFCvF9t3ADi24iOFdeMy21SK4+7+RZRkUMP+y+kQmGtweyTW3zi2V
	 Q6CfQoTIq6Ut09QgNL0kQamZZ6Nx3H3RZbpKwPsDI9CMFED2j2Lk0xlbGYSSs9KZWww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714217;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5XdxHQmj61CdkFGg3hL8Jd8Lh2vA9xn2XTxOhcTbeY8=;
	b=Cc2FBiHzS7ozMZ3Ph1IqI+epY2TLWcJEnN59QO7z5VgnIMnGkPeavxFXpdoTENP2JAmS
	 0w9uZipUHre7uOSzOVU+1ZlDLAO0wlmuVhiih6m1I/j7C+FnTxgI01U+6XeQJeHrdtQbO
	 me0D0yJ5Re8h4h8k9MHD2MpxmuwCKBblYiMb3rB7XDQrerwdPw/OcCkcG0uQT8Y0SOtXw
	 OnDXn4z5LCo4kRHYUg4jbCKMPIxyIo3nHtOwyR7HeVcK8l8m4kLySnbeFOitewlKM1Wtn
	 uslYdQxYO/cAILnItcxou0wUYj4AdALcgQMfvJq8j8W2O0lFSQG4HBnKv6YVXXQc66w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Kzmez/BA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC39606A324
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kzmez/BA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9681F000C1;
	Tue,  3 Nov 2026 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714216;
	bh=5XdxHQmj61CdkFGg3hL8Jd8Lh2vA9xn2XTxOhcTbeY8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kzmez/BA6u7Ko9qgmjj7mzkvIXCHV1/+VAOh3fURX8rDN+0LAPy6nspOtFM3KRelj
	 SPy+ld+PoSm0K63HwhjkCAoKpHiK6WoAXDArbqxhs2twChEbJ2CSQksfxB4ykIoLgj
	 2GBIOX7lTojputwmKhf5wtJRVoN+YMHEogv1CrUYCKefJWEVBH8jFxh3ivt/5ahNgX
	 tAjPcQz455J+djh6XCn+Zc3eEcEy2IQ+7OrQtkk8U8ExNnY8VjFyA3VfMlM7S9kgdt
	 xzGzYuQahcdrY7r1gHAUce0GJkdv/beggNIK6/NMHc07QDHnpC7i4Bo2nQVotUVweO
	 XCjRFe64nlzeg==
Message-ID: <sashiko-outbox-195405@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 05/12] ext4: add dirdata format definitions and
 access helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-6-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-6-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:56:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Define the on-disk format for ext4 directory entry extension data.
>=20
> The upper four bits of de->file_type indicate the presence of
> optional data stored after the filename NUL terminator.  This patch
> defines flags for LUFID, 64-bit inode numbers, and casefold hash
> data stored in that area.
>=20
> Add struct ext4_dirent_data_header to describe variable-length
> extension records and struct ext4_dirent_hash for hash storage used
> by casefold and fscrypt.
>=20
> Provide ext4_dirdata_next() to advance to the next extension record
> and ext4_dirent_get_data_len() to compute the total extension data
> length associated with a directory entry.
>=20
> No functional changes.
>=20
> Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D5

