Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714760;
	b=w2SxPfz1i0TbX6QcbStD+23XhOXtCIl7UJ9w4x2tKxBKPmE/h2MRmwBgYckX33OyWF6y
	 JMYXfU8bVeVP0pbPSn3FTNoPbdGtsA8NBMuL3k6HU+QPGyo0dx6LiksFUpPlUFlmIZ85d
	 LeMyJLpo7+WEqw6URDq3n0q8+q3rbLJw9vh6bpYN16iWTLUV4LQYeHkDQuFVNhCDXCsJH
	 1zmcGnv1JckikYK/NauCtw6JEI2yTFjm6Jc9a2RlWDYIw4xpGdYWcySVTv6waEDnaCTo2
	 43PCKYeWuaYJGXYP+3UysZ8+c5b4S3Kse/TEg9+4YbDNPRXhwA4WzwNZYPODutQGKiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714760;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jbIW66aFOrU4/OwLsajGlkdgNDTlsYGBFtGhweKFcGI=;
	b=2o+oab7znHutZHMr+UBI6f5r+cj4x2/JOMo0Wk9/ZjYDYRJtBoVWCX+TJVjjFKBFIsZc
	 TXGgF7yLludOuZcKm+ZkPNLYuombSOHEzbliYWxklIn+sRj3OM+Uar2j5Mm6SCM6Y9OAo
	 NYQcyREU7MDvAYjmDRM57Mbt5KrDBEfMbf6/W2gtz7WLc2r2rJrOPj6xgISXgseFI79Qj
	 nrEqz9pElhX5kEGp3BzwvfZ3j6A+/Ynvvz0TmGXYcITZtg1ivS27afVsLMMcmh1NoK6On
	 WXs9D1AwIBJzwWWmfMPRF6SJP7hBaGOcXFT0cdGeTo9v57J81eUw08lGLZqJev7GysA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZUYxj5Nx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B374606EE90
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZUYxj5Nx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0A11F00919;
	Tue,  3 Nov 2026 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714759;
	bh=jbIW66aFOrU4/OwLsajGlkdgNDTlsYGBFtGhweKFcGI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZUYxj5Nx3Z/LftgoPkb8qZ59YuDxS0mfz4bS4Qtnnbpfp/VeN8gmWPjwJ9DHcVN97
	 xKUtZ71bJv8wMHl0I9pDe6vNR02ZbPkMyxlMwttEN4mJqogNuRDIgxHwVOoDN/VjMU
	 P9LQxHAAbO2/Nzpwc1NoiurW1FGxWHSFDmZHFFr1HFRLjIG2jKbeOWkH4s0ep9nzJ+
	 1MPcZlJnXEYpiUTRFeaQ9eFUZfi0VQNebLFTS8bstsJKh43Ubp/XA1eufsBiDyEYrm
	 /LHu2/d0ilUszzfT75c7E3iw/YytIY8RB6CdFSsezsdtpgMwzqRRMicaYdxTQFm+eE
	 fiZpzjc31pxqg==
Message-ID: <sashiko-outbox-195417@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 03/12] ext4: replace ext4_dir_entry with
 ext4_dir_entry_2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-4-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-4-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:05:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>=20
> Replace remaining uses of struct ext4_dir_entry in namei.c
> with struct ext4_dir_entry_2.
>=20
> The code paths affected by this change already depend on the
> filetype feature, so using struct ext4_dir_entry_2 is
> appropriate and avoids mixing the two directory entry types
> unnecessarily.
>=20
> This change does not affect support for 16-bit rec_len.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D3

