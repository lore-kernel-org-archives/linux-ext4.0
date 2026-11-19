Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104785;
	b=2xsz4rQYVhCXo40vzNfEdlSiZDf+9K6ZwDixc9/6s56mzScrjkj6IXDAnCRoXflRX4AW
	 FgrS24zslaWOQAtR9ZF0RGTbccF3/Btg8662qQfAAwLuoD4YJrN7j4uD4I+bzWmJdUe61
	 mwbKUBr4CG0FvLjgstfuKK2irTn8ew7Tk4ze/kVuE0aA4ZlL4rfqv8pF215uaQ3Fqu9be
	 sgdzJNmeZeN8RRTjhZN/LngJww8c6FNyOfmvD8WZaPVOC1HQV/NoVxzqgUww5Z8iUt4b2
	 qYBpoprsGAoRJbIYhR+NsMrsSP8XLF1KQpyBOXusGupnjUVKuLjiiR8NzRbC23cTAiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104785;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vyOD2qxx1D2fSsxRZEz7+Q7kUfnS7fyS4rsDS2uGxPY=;
	b=ZNhJHhOJbMuyGIEiHIgwAy/PsyoUxvbYR6HZGqmk3/XZ0WiNBNbZ0dbUAyn31PXF1ZqW
	 Lj1/lL+T1xKnJWmS86fK0YKY+rRU+yzPErcJQyACiO0gpTJ9g7ldnNVFr/DiWXrbxXGnc
	 ADYBxn4JVbOoXzkfsrtbxqbRO/Wp6Gw0XYNG+A89rZPsMg/2gXfuBLrLF2vT9x6VQIBKL
	 Xv4JVdJUo9EUrc9UqLnBeuvh0h3MGGP0V1kR0W2LeqvWn0W1k/kIuQfO05+Dm0d4e20Kl
	 r0qoR/sPxVdq8xolgDM3EtSmdDiuMcU0fKErPOxAnZ+3zL0sHdVmU4j12Jwk0B8sbPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L4GNcRzq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBAA606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L4GNcRzq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B58D1F000C5;
	Thu, 19 Nov 2026 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104784;
	bh=vyOD2qxx1D2fSsxRZEz7+Q7kUfnS7fyS4rsDS2uGxPY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=L4GNcRzqm221OvNe8mqgoTMaP5B3wWXJle82OWCT7IFVCs2QPbBofHfsEX7jSj7a2
	 4D7uPrycCWnyED0YeICErj0ugQw9igNn0UqWta2SWCYC9KYqaKm7DLpAcHHdvmZVti
	 wUzhSECPnlj4Sd6LVUlmh6l7/93R0iRgVnRerI6JM803m1ZgNp7TkDizwb+vEbp+5E
	 b9RgX1PS/lpWj4qTTPDN/AyNZSxP743gmnYTEfx9OfQpbHEmSezxWVD6JlHhtnBd2o
	 BgyCG4GTscTzGmjqIwDwIapdG8/waKJNESs1+ac3oYA6ebLylxbrZyHqUpEWJt0S50
	 2d5KO3mJ7OBCA==
Message-ID: <sashiko-outbox-223493@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 22/26] ext4: add KUnit tests for fs/ext4/fsmap.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-23-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-23-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:13:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add KUnit test suite ext4_fsmap_test in fs/ext4/fsmap-test.c covering
> FS_IOC_GETFSMAP reverse-mapping queries in fs/ext4/fsmap.c:
>=20
> - ext4_fsmap_from_internal() and ext4_fsmap_to_internal() block/byte
>   conversions across 1K, 4K, and 64K block sizes
> - ext4_getfsmap() validation of flags, device IDs, inverted keys,
>   out-of-range physical offsets, and missing group descriptors
> - fixed per-group metadata synthesis (superblock, GDT, reserved GDT,
>   block bitmap, inode bitmap, inode table), free extents, and
>   EXT4_FMR_OWN_UNKNOWN gaps in the middle and at EOFS
> - flex_bg adjacent fixed-metadata merging and cross-group free-extent
>   coalescing via gfi_lastfree
> - 1K s_first_data_block offset handling, bigalloc cluster scaling, and
>   META_BG reserved-GDT suppression
> - count-only queries, bounded continuation-key pagination, formatter
>   abort propagation, and external journal device reporting
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D22

