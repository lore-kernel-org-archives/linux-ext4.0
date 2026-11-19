Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104773;
	b=NWJ8tEka3Bzd8yt84MxcyWoDEKCpN+lWrrpCRHMrHmB0etCtYSgd+E8eRac+9nSZpWqP
	 97jGDL3bqGQ33u6JrSbl69CcBAxa2XFUVxmf2vWAMytAiQPWFw6Ei+Fx3o0NT/xHZS7W1
	 k94161la1TzNlMEjYKL+P8NaWQUTDA/N9iUcOgoDXwS6Swr7cE38PhlO4PjGNT7qAI+0R
	 KwLIWDtoCdWHO7gtza8KGO14aG3HwulD0oHGTHp6/j/bm/uIpLRpFUOcTq0XavtbgsUgk
	 x9w0/YgfHh230zAJM8qxsesp4PdANPipCXjUgAoS1CKIXJt6Uh57iEmGAXnzuomoW7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104773;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Z6TCsvjq6qGOq4hZ5t/e1Gs2lUMoZM6mreBfOd5dqy0=;
	b=WRkv6D/C/VAt0smsAAkq3duGCKdkb5ez8bjIR+9Gs6mUmGml7wupHUllov79mWCeSzti
	 QpYadM4PTxLnVN8ROdZvsINC0ojCo9Fh9Ock7hwu0SfkDGnN6kS0h49JkvcN6N7xrFqPh
	 /F7Qgo/qoLcrMMGIb92J1bFpHSIzSu3j/kTzOUeJCayyRFkmJlI1DA3S3AcWi0bv1loxi
	 1635lNu56Duv8/yk25W4OKpnASjEJiUasYpE4SNvYKqyTnI/L9jxrpuQR3Ase4SLVzxOH
	 zQXyCb3lRGgcExVhOso0v4joNVIGAE2JBjSU5q3BX+Xu9KLWoS9RWZjiAT8Df+OaJUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8m2f4MS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD34460A2609
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8m2f4MS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4456A1F000C5;
	Thu, 19 Nov 2026 16:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104773;
	bh=Z6TCsvjq6qGOq4hZ5t/e1Gs2lUMoZM6mreBfOd5dqy0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=m8m2f4MS6bHf5NfjIQoMEkCx9qbS89xJzpalsSMkCaDksS3hx5qXhbxC8ZJV2usqk
	 K7smIFjokGbGFDR87vNUv1c06D9iygGFZ0Y3JpXMGm5h71+qtoTplgfWWmlHJTqTlS
	 Go9DBUULUwvmpUC5Vf1El1UxFbihWMwWo0Cxl+DUPgNZXY3eONU63n8VFQhn4/3hgP
	 q0hcRjuEe/QjZwglqGlTtE9iJkIhikcnrDUJ7pxHDurZLK3Qj0Rl0Ly5kUCU3n7zab
	 6O3yUkDQmV6YKHXdo4JioHAEJF116UrPRrH7fVWfk33pX5Zx+83Isd1Mnn0fcRuuOw
	 RbSZIqjK80iQg==
Message-ID: <sashiko-outbox-223491@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 24/26] ext4: add KUnit tests for fs/ext4/mmp.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-25-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-25-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:12:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test suite (ext4_mmp_test) covering multi-mount protection
> checksums, block I/O validation, and mount state transitions in
> fs/ext4/mmp.c:
>=20
> - CRC32C generation and verification in ext4_mmp_csum_set() and
>   ext4_mmp_csum_verify() with and without METADATA_CSUM
> - Block read/write error handling, magic validation (-EFSCORRUPTED),
>   CRC mismatch handling (-EFSBADCRC), and buffer cleanup in
>   read_mmp_block() and write_mmp_block()
> - ext4_multi_mount_protect() validation of out-of-range MMP blocks,
>   EXT4_MMP_SEQ_FSCK rejection (-EBUSY), EXT4_MMP_SEQ_CLEAN claim and
>   ext4_stop_mmpd() teardown, active/racing node sequence conflicts,
>   check_interval clamping, interrupted waits (-ETIMEDOUT), and kthread
>   startup failure
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D24

