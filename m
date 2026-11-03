Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793720523;
	b=PCNw9exuwYBFjuhdQLnCG5qswXZIr4CejXnGcMGPKDxBF+u+0xjTHAbK54e9AWOb1vev
	 sVodmngOn7qopJlLsZUgfqBxQ7r1lybQ9JfDu8MJokIqEZQLad9kOpjm9nRNBPcUwUcfp
	 ageVOGXyetL9BaemwrVe16bvOHFZy90nAhGlOZwlXVIojz+cIETBIfdphDgkgE9l19Z0s
	 k6WR9ZGc6dxm4QDA1GoodPSqS5qHsFgHd57hSv010z3Eb1zAnNozjRXldBTdOmCtzDQLy
	 7r3w7OIW8Q7y+tKM47UQ5Heq4N8wblBnn9IZRYFa0EKenxdVJIyM7zD62BQYFFVuxjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720523;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1el8YBtFBVkTpCAdLgy8nr3n8v4Hm0XsWJESt6BUCQA=;
	b=rbdzY6Ft7hUVcvI7j++JRTM4TApFmJPqZxBu8AzHgwppb1NxrTI2WHhttK5jpJZHx1fR
	 YGR87ik0qyPgwraO4OGMEQpGyalnGu4NdDXqUSF7szS49QA3K2HlJz34IG988FvlWFuy6
	 Q0SqS+rissxJw6YU90fuyS+f/MBNpwH8YPyUm83hqz4A4jkYtrzEF8jHGHaVK2ZfGa95j
	 IDxuWJfCzohwQzow9qs2DEQPfNGmQElm3ym7Nwvx49uK2GRJqODd3RR8YpJJqZHgoRbPo
	 Jic7Ark5usZ45U3eAIyZfIs+vlpEFuDjdt45cavaqiad0iFpxJLLEso9wl4b+UIxvqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CAFb5SVS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A5A606D806
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CAFb5SVS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074FE1F00919;
	Tue,  3 Nov 2026 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793720523;
	bh=1el8YBtFBVkTpCAdLgy8nr3n8v4Hm0XsWJESt6BUCQA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CAFb5SVSYrul2xQB/Rz4OCYatY9Ptj1BRp0Q4vhi76EXBkbh9D6K2QOPYS3tlTu/0
	 +qBaL+snOCp+Qg6vhHV84qb5mrqGPXmGKYgfqECjt4TL5VLYfIK+oPnxwqHPBBYAXm
	 kAcWb2MmKlVAZAX7bEZVtLlEB0owR/PNR/1tAQkSCTRYoOuITANH3LQnznAuzqJIEK
	 EjjQgIH3noAevjBv4ng2unON8LJPTfLa6U3m2Zx/e3Jviry4waRK9aaiWbjP9DKUpd
	 2KENWFXBp7y8RdiFcQUy263kIZ7INWMcxLslrIPcS1OqED82cVgXeTGvKRX/FzfpM3
	 PXaMSj7TNEIyQ==
Message-ID: <sashiko-outbox-195636@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] ext4: allow large folios and bs > ps encryption
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baokun Li" <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261103153132.4154855-5-libaokun@linux.alibaba.com>
References: <20261103153132.4154855-1-libaokun@linux.alibaba.com>
 <20261103153132.4154855-5-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:42:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4 refuses encryption when the block size exceeds the page size
> in three places: at mount time (ext4_check_large_folio()),
> in ext4_set_context(), and in __ext4_iget().
>=20
> Sub-block data units are now enabled by default, so encryption
> works on a filesystem whose block size exceeds the page size.
> Remove the three checks; stable trees should keep them and
> not backport this feature.
>=20
> ext4_set_max_mapping_order() now runs on every mount, and
> the preceding patch routes a folio that crosses a DUN wraparound
> to the buffer_head path. Encrypted files therefore get the same
> large folio orders as unencrypted files, including when block size
> is larger than page size.
>=20
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103153132.4154=
855-1-libaokun@linux.alibaba.com?part=3D4

