Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104531;
	b=Cn7/lkxVf9moEI9mJSpIqQ6ZH/iXn9soCsLk/J5Vtm+N8P7wT2RZfm/uqDPdGABuYHP/
	 LTadyoecyx25B/Js3K05ggvK5oN7JnNv28Km9+C3+Mds9EptvzXKkGIh6MKEkf7Aio5tK
	 kZvP5WSgiRBxPFbLT+JkGCzgKByllNfOxv5TaBPAh6Jnqh/jFkGmZScpxpf3cCHjXBvTq
	 oAHSlXV+PRgmBY8Kr9R76tx59nhO7Of+0WUQBmM5oklSpxOmDwByYdCnVhfMdTo391czC
	 +zRpCjZEgnWyYfpvHcDabtxu05DZP3Zm4PKS3J5xt4c7IHVgKjfDbfr26PEEv757Y4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104531;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VGypSNPf3jey8XPTx1b2iPH4uxiXraxHnNjiOi51Ffo=;
	b=D+p0cG+U5gFoxkEEPKb0FYgkNJVobXk6St9QoUcmMIJu+m1wj6ErousnW/sbdm45fi44
	 7Qb2u71OfN9It7lUmmya5XfwvIZtuG0Nd+dWafjdSNCKf4CMVJxRe9QQww6B+JCyAg2PY
	 Tx92Mo2RmAbq7m2hrIAUSfl9DclbQc8nAUh+f5EUMFYPAaHNFjCXU/2OKUsct8Cc+Gk+W
	 ujAasflfxpZGwX16YOYJgIZSPFxGWI0Pvii6b1kIF+nhLEti7ALjlrnpZBnxrqvpn9xBI
	 unPG23O/nqXDsMN+WX43awZfwO1+0O8Lbr1J48laVezR5GG1cbAcplPqg/WKh4Fg+0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y/eRmKSz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1FD60A261C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y/eRmKSz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC84B1F000C6;
	Thu, 19 Nov 2026 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104531;
	bh=VGypSNPf3jey8XPTx1b2iPH4uxiXraxHnNjiOi51Ffo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Y/eRmKSzOEf6GsTFqa7Unq/QbzhMJYQef/tm1r5Fzx0GH+EKKKPI5Xz2SiQNsgoAg
	 hzuCJ4ZoRbnFJMnCGwKDUt4mB5cel/HXIBkWCpvnHTYGDGWC3AuNlR0OT+kdwzUHEm
	 OZkDhctXMOGl6A6Bv6T2JwwkNbzojMKeL5a4viWwX0RQaap7eVkNisw3GC6b06e23N
	 +vfhLcJID0sDpRzsefCArmf5YB3FRwiB70hQxUyislnIkU19hZ72hpYXE1tY4u3Dvu
	 aCYPcaXNgTPdnZc3mhVzbYDkg1XLOiNACLxQZqqVvFlz4ps+PvKmFyjA1R7Sez+9lh
	 tLNhgLpJOHWSw==
Message-ID: <sashiko-outbox-223479@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 05/26] ext4: expand KUnit tests for
 fs/ext4/mballoc.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-6-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-6-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:08:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Expand the ext4_mballoc_test KUnit test suite in fs/ext4/mballoc-test.c
> from 7 subtests (21 test cases) to 32 subtests (96 parameterized test
> cases across 1K, 4K, and 64K block sizes) to comprehensively exercise
> the multi-block allocator in fs/ext4/mballoc.c:
>=20
> - Low-level bitmap helpers (mb_set_bit, mb_clear_bit, mb_test_bit,
>   mb_find_next_zero_bit, mb_find_next_bit, mb_clear_bits, mb_set_bits,
>   and mb_test_and_clear_bits across clean, partially clear, and fully
>   clear ranges).
> - Buddy bitmap lookup and extent discovery (mb_find_buddy,
>   mb_find_order_for_block, mb_find_extent for free, used, and merged
>   power-of-two ranges, and mb_regenerate_buddy).
> - Corrupted block bitmap detection in ext4_mb_generate_buddy (setting
>   EXT4_GROUP_INFO_BBITMAP_CORRUPT when bitmap free count mismatches
>   grp->bb_free) and double-free / EXT4_STATE_FC_REPLAY handling in
> [ ... ]
>=20
> Export the tested functions with EXPORT_SYMBOL_FOR_EXT4_TEST and add a
> KUNIT_STATIC_STUB_REDIRECT hook to ext4_issue_discard.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D5

