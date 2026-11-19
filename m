Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104767;
	b=mkmbiBg3iZz5EAXpCSmP4eugVC1e/O9Zyzu0t6OMfEScNk4tC/1UOIUAc7BIQxypukO/
	 1EaztgF/QTFiqGS0Qb39tyRG0szkcFXOW5Bc9sx3X+Yfjc5LQmYkELxB9aqjv9ze0DfmY
	 1D7YYhXXO61LvLWKVm656B1nszkP2P+rtU7zmnddUf4VMP4/qoWAbktszoHqUCAnkcBRW
	 61u+H37kbUa209UBmIg3kvtCQA2V3ivPL1WnHpGEFFgkfZic+IscgLO6Ff4m3L7OVU6kJ
	 /pwsQco8wOmUJbOsScpeB91QdzHNB4QBMTOYatT84Ae1/haQr17BzrS9fx5tLztSj3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104767;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=atCFJvYtCSPXezQayUoecBxZxiOObavk5t985duU3ro=;
	b=vHDr9W23CwiExNMrO3cR2XXE9Dnzko8c1Jql1BhhBkmgi0tjhypYerwaqhRUihSib5AV
	 CxGDCN54Mx7HimoQLkCPcSa0UuGnXWReuGZHAYKdquBHCZ8fiyQOHCE7tilkbeL+2Z8ou
	 J2nHQ7rmdQyEC8nzo/FSH0P8i0GiBY48PY/8aZqXNslPydVKUSz+Z6ECxEtGltoLScZuv
	 rotzXKvKcFO75mk9WKX8SyZWQ6DZIHAl3W/b0OGG6tlzuT+81hyt+/K7wrG6Q6HSxWoo2
	 Fcch8xEy690hp5OInBsurxzP3DhJtIYbODv1mvR3ITSzYvrcP8VHsIg6XHh7kKCZJWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IomNEI0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E36606A334
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IomNEI0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FBD1F000C6;
	Thu, 19 Nov 2026 16:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104767;
	bh=atCFJvYtCSPXezQayUoecBxZxiOObavk5t985duU3ro=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IomNEI0bGFww+hPp3l2AiAROaevRHMKlKVG8Qby/5RDff+6JN+j9JvTlrAgbO4j1i
	 prbdXZ/34Jkdirsa4hwV2fDw+YcL5zxDu+VzG7CXnh54ylHEhJZH1G5AmztbL3G4/F
	 D6slGhZHG4y2ehHCntgYMZ/hf/ZN8KKnD3pHE6MU8T8YodldNhwoDqr7xip4nJRc1f
	 ZDSvjMqq2wUqndlmtAwq6LBcT9Jjpi7g7fE2R6FXH+ZYlWRVBjJQB2t/sPz7r0aVnk
	 DAPkzz6zta/Dvlm6kGH2VzKYDwkNBKvZfErAulA/RoF5Sb3r3ViCq/rHN5jZ1L1sNp
	 t+h5Mg8lxXdYA==
Message-ID: <sashiko-outbox-223489@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 14/26] ext4: enable full feature coverage in
 fs/ext4/.kunitconfig
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-15-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-15-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:12:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Enable CONFIG_EXT4_FS_POSIX_ACL, CONFIG_EXT4_FS_SECURITY,
> CONFIG_FS_VERITY, CONFIG_FS_ENCRYPTION, CONFIG_QUOTA, CONFIG_QFMT_V2,
> and CONFIG_UNICODE in fs/ext4/.kunitconfig so conditional ext4 source
> files and feature-gated code paths (POSIX ACLs, security xattrs,
> fs-verity, fscrypt, quota accounting, and UTF-8 casefolding) are
> compiled and exercised during KUnit runs.
>=20
> Fix mock superblock and test setup bugs in existing KUnit suites exposed
> by enabling these Kconfig options:
>=20
> - Provide .get_dquots callbacks in mock super_operations under
>   CONFIG_QUOTA in block_validity-test.c, extents-test.c,
>   fast_commit-test.c, inline-test.c, inode-test.c, mballoc-test.c,
>   namei-test.c, and xattr-test.c so dquot_drop() does not dereference a
>   NULL callback during ext4_clear_inode().
> - Populate sb->s_cop =3D &ext4_cryptops under CONFIG_FS_ENCRYPTION in
>   balloc-test.c, extents-test.c, fast_commit-test.c, inline-test.c,
>   inode-test.c, mballoc-test.c, and xattr-test.c so
>   fscrypt_put_encryption_info() can resolve inode_info_offs safely on
>   eviction.
> - Fix test_namei_casefold_lookup_and_strict() under CONFIG_UNICODE in
>   namei-test.c to propagate EXT4_INODE_CASEFOLD to S_CASEFOLD on the VFS
>   directory inode via ext4_set_inode_flags().
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D14

