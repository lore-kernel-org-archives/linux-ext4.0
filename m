Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104688;
	b=RKiY96FQbJt0rlSBHi1JOMLjhZXygZKH26ennW+057uETfUYoOyxGPj2OrzZEpHYlfwB
	 Hp3quWOblHuUUVBq6PE9rBqYLdchj7Fcy651Sa3kSUUav6dmS7gslHul/sGOfA5RzxKBA
	 olmAGdNd3NM6d4znM53G9uAUEy0dwaB2wMdHZ1BXw0NsvLqbdsn488ZO6ZVsrGtteC5ms
	 RxLasAYqNM89jjGXf3lxJFeXzvcEE69B1RFanrP10qWz2LWFcBZCIZMLkTEtWB92aMVTw
	 LbpsUc+6Ng1Q787lVOrRdFpC5GKuLtNyBzC93NgOh9U6cSiHl+wGDjaLe0iXiidjktQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104688;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ii6g89IVuHR0NqMR9tqR7NXVa07w8OmRXcYYFhkBAjs=;
	b=bQv0Ipt8eVkx5L4W4RGAOqMp7pvkMJ/Oq1z6pKXLCjMKuppfksuMWPB+wkXu3fKf81aU
	 IMyuFxszkozFfbJcyulG040vfqC44xS+XaUkQdYw8CZKkJsVK1xUp2rDtlQKgyvaJE9W6
	 jySA7xVKtgrZujKyN8XbIX9q3RDLD/pjU3gUETrryuPYqLKgPwFlyj8XBub0oqWJnlhVU
	 rELndecc4bSRsjDwQJHvM9PTz0lcsFETfjKh0wUwsyHLU00+9XQ6Tjs45LrgTscwvVwpH
	 eoUavWh5Pc3DuUP7Pw65KCxTAMHIlVXWENzfNtsZ2CEV821nw4f/oxcYzk2ovfTWERQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gh/akZ+8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF5606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gh/akZ+8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B6D1F000C6;
	Thu, 19 Nov 2026 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104688;
	bh=ii6g89IVuHR0NqMR9tqR7NXVa07w8OmRXcYYFhkBAjs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=gh/akZ+8mXciPTo4OeX3DOmX1HdRHhxLvxd1y5PBZmupsCjVcZB+3rUrtm3GydePM
	 qL2VyNzaSJDK7MsfaIgU/EpefZjTfXB71gfTOh8wBbu+ar9UfpYKn+LVk8IxcEpQwe
	 EhBY/a6eIMi5lue1zznm/PIjDLC3ljcMDbzZRoBxxehKV/OjK7BeVrR9JJGT4Ro82z
	 QN4Y+A/Di1xo1tzQTJcmRioUpqNQBlXJMtzryp6Hoz9BZrXUfWqf9+LScs/HCYtQOb
	 BKYehjDIxJOI7DbyVR+VO5fu11QSRfll9hJSVfN1Mn+pHIpFM1goB26nfzX3KIdUV6
	 5GMgR94wfPvYQ==
Message-ID: <sashiko-outbox-223482@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 03/26] ext4: add KUnit tests for fs/ext4/xattr.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-4-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-4-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:11:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the ext4_xattr_test KUnit test suite in fs/ext4/xattr-test.c to
> exercise the core extended attribute operations in fs/ext4/xattr.c
> without requiring a mounted block device:
>=20
> - Entry/value sizing macros (EXT4_XATTR_LEN, EXT4_XATTR_SIZE,
>   EXT4_XATTR_MIN_LARGE_EA_SIZE), EXT4_INODE_HAS_XATTR_SPACE boundary
>   checks, and xattr_sem locking helpers (ext4_write_lock_xattr,
>   ext4_write_trylock_xattr, ext4_write_unlock_xattr) preserving
>   EXT4_STATE_NO_EXPAND.
> - In-inode xattr validation (xattr_check_inode / __xattr_check_inode)
>   across 11 parameterized valid and corrupted on-disk layouts (bad
>   magic, truncated headers, out-of-bounds names, unterminated entry
>   lists, non-zero offset on EA inode entries, and overlapping or
>   out-of-bounds value ranges).
> - In-inode (ibody) get/set operations (ext4_xattr_get,
> [ ... ]
> and add KUNIT_STATIC_STUB_REDIRECT hooks for ext4_xattr_getblk,
> ext4_sb_bread, ext4_map_blocks, ext4_getblk, ext4_get_inode_loc,
> ext4_mark_iloc_dirty, __ext4_iget, and __ext4_new_inode.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D3

