Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457463;
	b=G8ZgDfIAQkUNxT8egtqckRyZ9LjHZbJ1itQGmMUxEBqrqZqVGL24/Gy0L7S/nV2/QHMu
	 t95YzMj+vEzOOZU6JYjXqNQBLPIBNsFuDUZYFTz600zWA8kjLI/8QrpceuJVAWdrcy17Z
	 QA83PpWgqFz9Uv4gKuXYMIJQiU/yYJNnwtdQhqyfKJM9+mPdIB3AE2HqqZs2ndc5kWPbW
	 sA3WA9Q6QkDNiTo7qI8FnBvnFJlVt1oqrVwpnFTJc72301HYWBT6twtyG2MC1KLaaPgbN
	 SFCH3El3OoTQ4mRGcMBiUIkBdvPMZJ7cV5YM3nrLX9mJkK0Thq2Aweb4B2dI8eFMfzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457463;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=td+Orbl4wH+DBTOkZbQaQ+MQlcUNoLmDS1ONONFwwuE=;
	b=edQwG0m01bDE51Nu/XbpJKa6IkL+8iuchYNO1ieoQU46fk56QPFnZoJSgZHllZ2Yfhkr
	 9OsdKhyPwNQTZBd4oSrPafp1WdIzyc5t67vzT4gfW+l8rs0x3jlPC7VVq4l3LENovJLlg
	 uMWYmETW8S6O8y2ynqzxZP5dOH2+6/dhw7Im3PdPEgjy1+SAr+1+uTnhlvcPDgRHLBKkY
	 7vQsUI6BUr8+AHnI6PDHi4+QV+OBNM9E/zAhoUmIvP1lw1M5K4C8c3u6v2LmsQnnDToM0
	 YM1GXpKumDJrGTdw7BNWY3OiI3ZwEEVbLM97WXRXSr/bhbyEV6JwbpByqNcKAMC5RRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8M1F7us;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE00606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8M1F7us
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D731F00A05;
	Thu, 12 Nov 2026 04:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457463;
	bh=td+Orbl4wH+DBTOkZbQaQ+MQlcUNoLmDS1ONONFwwuE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=m8M1F7us1okJrD2JrJwUobl0e9vs4v/98yPMSJbJf5QQKOo5zetnbz0dADcodP7Jf
	 xsDu9aWnZ26xqikJo+JGL/5mB+LX+0Wb9nK1LoKGQx9Am2Ezl9PRsXc8RaVpmzFP4w
	 myBHN/ACQWmRZY//JqQ7DwW8kOaRuzNSIpxgFzaz/GoA3W4+3rnjSRfMLOvHI1L4rX
	 3BgkNai0plpjxf5TiOV+/0M6QGvugvLKb9nQVZiNXF9f8DJXQzP/lFKApjcA0A20Ty
	 RnHqycw8MbhuKpNL378a9UR/iL3Ws+wCALkV244m28NU5nnF+t41rQRCGWMBc6fpNP
	 l9+5SXcUD7qGg==
Message-ID: <sashiko-outbox-210332@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/27] ext4: enable full feature coverage in
 fs/ext4/.kunitconfig
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-17-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-17-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:24:22 +0000
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
>   namei-test.c to use SB_ENC_STRICT_MODE_FL (instead of undeclared
>   SB_STRICT_ENCODING) and propagate EXT4_INODE_CASEFOLD to S_CASEFOLD on
>   the VFS directory inode via ext4_set_inode_flags().
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D16

