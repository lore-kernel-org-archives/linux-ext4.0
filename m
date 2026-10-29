Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280743;
	b=UfSUvNY5tFA3vRGo7wpoXtD+KRRpZBAq41ZUzILWxMrRuBuSKHXe2IlPHiU+v2CcdWUh
	 qzbX06X/HIiiz/k0ZfS0XU20IF+zpZQdytN/5HuO7ACmpnjlMe1/Epz90NQSPm13EJ7US
	 aeUk0G/sceMgLEmjxKHmKW0ssc9S6pC8p29/oAQkKZjoBp20H5srOIJxGZIbtdFi6PNLC
	 nylHYK4YGX8PPCnhW3ppZk+hhkEfLjROs7q/gtgPTLRh838Dtt323t2is31xwmWfbB8B0
	 iScNLiEyE+9rAgv7hjGAbvULbAqLtdHKAqOVtykWNXdljMEcRgwRCbyHYLcqY1P8VLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280743;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DZ9PY9VIIOC8SaZwg41jGjw4H3JJJ6qcGQJmt93YvPQ=;
	b=Gyy+UJnzWtk35Tw+1SKqKmFMVP5Zn/S4QdizC4UopLx+2vCtCbO68OKfZgQ+2ggmnttW
	 OHC2vOaHVg1hqLG3g7xT9UVyEtULsD+X5333Ir78I/ugoZMekR7whC2g13e5BACfxuIvR
	 darRlnCG3vtU9CSwVlMxnfN4VilGS7Rn/apTC/FApMcI3Lnb2z1V2Mc/eW/17Akhb0cKa
	 L+Jk6ut3rmXxvWwd3HK62F75G3zY4QIdP8v2o2f6ZjuoZVxYQfpSrjteb7ZcqQ/YeJdWn
	 4CKEgebItSJUwTUgXbCpp+bUFfyTI7jc/iU5Fp4qklzp39hkUWvqj6cXNkQtBnHAy1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLLp06Fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B810606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLLp06Fm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192761F01825;
	Thu, 29 Oct 2026 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280743;
	bh=DZ9PY9VIIOC8SaZwg41jGjw4H3JJJ6qcGQJmt93YvPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iLLp06FmuQ6Uo63f/qsoQiukDa9oZKe2JJEnkKuUbztToRfWl0Do4xvbvtQSn7RFV
	 8cN6rZHE3hDAbdibeqDglqbI/T9+0a5sK53paK9NqJh9FsLTbzNIu0ieyzYjyR5QGo
	 Bp32bprjvZE42MErMrFhWFkSylSHptakKPkO3Xr2AF4pFm5C1/bWqX9sOLFYY2prf4
	 pl6jWOcr4I97E2F1f3gFjAgcLdW4BcDqrgN+Fo6t20TOyljIAExvW73/ckKqw6w7bo
	 CD9/wx72OFYAAN0wwuisapD0ULxbL9X0IwF6AjsCCnUKGFpt8czfGo4tNNIGFNm+Ql
	 9obevTjCCWihw==
Message-ID: <sashiko-outbox-189386@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 6/9] minix: don't read the inode block in
 minix_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-6-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-6-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:32:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> minix_sync_inode_metadata() looks up the inode block with
> minix_V1_raw_inode() or minix_V2_raw_inode() which read it from disk if
> it isn't cached. But a block that isn't in the buffer cache is neither
> dirty nor under writeback. So there's nothing to write or to wait for
> and reading it in is pointless.
>=20
> It's also not something we can afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D6

