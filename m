Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F434E745
	for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2026 21:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789851604; cv=none; b=me8URYYKjKImzY3RCubIuG7L8syRSxIbxzr5jEALUXOgr0fW3Esn6iOz2oxjj06bdH6CMce+OdZ+O5x8QlkmVR8riZIn7enmhgh9O+mM6MAi+xD9RvNfM2kpznZ2mP6ki0OR+XHfbB256b9BPJODalvgXI2ia5A3Wc7ugCcQa5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789851604; c=relaxed/simple;
	bh=PY73LVHOk9Sy8VeeWlasWXIlkAUS2gZVwb8h/pzEh2I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EcJ4Lr6MSXOniXO56yZCgVgt8xdp/oxTxalDoO4e5wsF/JY3gA4kz5UDy8+QjkT2fBL027VEptZLINpsASIRlrTZhbC9ebGkvhfoJ2Ql+KXbgIexCqvz3UjE1saAELK9lDPiWAMsegQPC+NAIOdjRj2WLby1zPrIN3OLqMnw/1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eg6dn5vs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eg6dn5vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228521F000FF;
	Sat, 19 Sep 2026 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789851603;
	bh=PY73LVHOk9Sy8VeeWlasWXIlkAUS2gZVwb8h/pzEh2I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eg6dn5vsR78c5BbuBMaUJTVQ9YGT+mrf4PusM6+HNaOdTHVNLlFirlZReiIo/i2md
	 rPpgcxtZi6eS5fFxbhytYDV31VukJQTnBBVEisM7lOYevVrsQsFarlJOqwM1taXIxM
	 RliEU3tnx+Edf9Sj9xjzS86woyJxbWtiF2h4LHBT2yS7vUgzey/iUcOYkEx38333q8
	 I5o7VU1Np4qcdZuk3lilHJrGfwqqHIqZN+2BkWJlfOlkyDML6hCzu7HWHnaFMxqiL5
	 5OkUQXf0XM2w9GYvSjtAzjYFmUS8LmeHQ38rVHmWTbsxMk+ycyOcLVHgZPDIMFpwnB
	 NM8dxY3tWdlFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: clear EXT4_STATE_MAY_INLINE_DATA in
 swap_inode_boot_loader()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hui Peng" <benquike@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260919204812.2814531-1-benquike@gmail.com>
References: <20260919204812.2814531-1-benquike@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 21:00:02 +0000
Message-Id: <20260919210003.228521F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> swap_inode_boot_loader() (EXT4_IOC_SWAP_BOOT) checks
> !ext4_has_inline_data(inode), but neither checks
> ext4_has_inline_data(inode_bl) nor clears EXT4_STATE_MAY_INLINE_DATA on
> inode and inode_bl after swapping their inode data.
>=20
> When a newly created empty file (which has EXT4_STATE_MAY_INLINE_DATA
> set in memory) is swapped with a non-empty EXT4_BOOT_LOADER_INO that
> already has extent blocks, the target inode retains
> EXT4_STATE_MAY_INLINE_DATA =3D=3D 1 alongside extent blocks. A subsequent
> ftruncate() + small pwrite() + fsync() dirties folio 0 while converting
> the inode to inline data, hitting
> BUG_ON(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in
> ext4_writepages().
>=20
> Reject inline data on inode_bl and clear EXT4_STATE_MAY_INLINE_DATA on
> both inodes in swap_inode_boot_loader().
>=20
> Fixes: 67a11611e1a5 ("ext4: fix check of inode in swap_inode_boot_loader")
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919204812.2814=
531-1-benquike@gmail.com?part=3D1

