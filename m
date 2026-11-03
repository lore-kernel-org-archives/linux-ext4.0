Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714196;
	b=EEX82Cy/Johxo9y5WzaE+vBRdlYPtgF0UOkV1lNlCm9O3ySlMKHqPD/WOQyttKlNpA0Z
	 1lBHr1bQJrOt8w/BCf3kzB8Wcjca3acVs3lv/RuOmQ1jlC59Zu57e+fhds1kNDDohogBw
	 izV2k97fDJ6FhtARBmJbNf0R7FRJA/gfvxrl6zE8JWqI2Vjn+tlwR1slYg0GAuyxHeeHz
	 OTpMyVgeVsym+2kJEsqRrEyebiQGPxjMX3gLdLTRy3wCA+TyHRrRVtlfhHuIjhZP7exzw
	 1f+jeSNafIUPKSAeQnDazBwaEvyj4u12/qAafzILTes5YqQVyN1xuvnTYpF2dweUKJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714196;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K3uJCHsS09WXu3MNMbbZ8/akJ2g4USfVzR0SyeUxNpg=;
	b=N5QClh6PtFoNp1KdR5iGbSLrJR49X1dJ6rDEAwTeRWmVJvP9fMtm6JKerK3S5lbq4ELt
	 QXbB2mUtur4s+UYU9k43l3ydNKl3lojE6eK2kE2gs/DTKakULsCKXnqinSkLIvZl2Q6F2
	 55eeiA4mDP0TxQJv/aZaA2O486tdfNBvtC5HKg0l8656MVR0SWZHrSXgn4nf3d+vlxmYM
	 T4UFWqUPmAEldy4T9v+4aaYgRTy7oduomSjp6u7OMx8jZFz3Q/83zytfgE3SN97TSLf9G
	 WvCxY0MSxT1NwCfgNa22Hn7Nyu5/5/aZN7xYjopImBTDQglTjoyGJLGCSKPyz9jj1NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kby7zCvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41111606D809
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kby7zCvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05A51F000C1;
	Tue,  3 Nov 2026 13:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714196;
	bh=K3uJCHsS09WXu3MNMbbZ8/akJ2g4USfVzR0SyeUxNpg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kby7zCvIoqaDx1+JnZNNQ2aN1C0K+WqUvQSNbeMhhFA6quDT4pRXLhGM+wBB9pTRi
	 nKxSMCr/Y+rP6H0hRiKRdm+iJ/nwMMFvixviWyfo86CVSsnmuD44Wt085ZbjAnJ94O
	 K7dlQ4mqh6ZmjaRCAqkcRFs5nHfYXAiJHwWqdepxFO6Y1zMZUXdV72tjgeq72uo4wK
	 6RTqqKlyO5NqO1FjrpjXGERfmA0UEoDvZnIWzLfMTHSGSWzoXK1UP2SX4AEYW1f56u
	 Mnq4/pWVja2n06SjDz8ubU8BpUSvfLQ/rHqo3N5LBeZ5/ZMBL0FdAgkyZbOcuZ+qdk
	 jZZjYy1snRChw==
Message-ID: <sashiko-outbox-195403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 02/12] ext4: use the e2fsck limit for htree index
 nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-3-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-3-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:56:35 +0000
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
> Since commit 471fbbea7ff7 ("ext4: handle casefolding with encryption"),
> dx_node_limit() passes the directory to ext4_dir_rec_len(), which for a
> casefolded+encrypted directory reserves 8 bytes for a hash in the fake
> dirent at the start of an index node.  That dirent never holds a name or
> a hash, and e2fsck computes the limit without it.  e2fsck also only
> treats a block as an index node when its limit has that value.
>=20
> As a result, on a casefolded+encrypted directory deep enough to have
> index nodes, e2fsck reports the index nodes the kernel wrote as corrupt
> leaf blocks ("directory corrupted"), and the kernel refuses the index
> nodes that e2fsck -D wrote ("dx entry: limit 510 !=3D node limit 509",
> 4k blocks with metadata_csum).
>=20
> Compute the limit without the hash, as e2fsck does, and keep accepting
> the old value so that directories written by older kernels can still be
> read.  Older kernels already reject index nodes written by e2fsck -D;
> they will reject those written by this kernel in the same way.
>=20
> Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D2

