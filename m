Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104059;
	b=NaLt6qIQA4MDwRQd2kJNk9frgymjCzKyQjuRFwkBOjYyp0I1NARd2uKwHsU23SDlKSMH
	 6aspDMIuu56Q/Z07A2AFC/giJmtS0u8HzH+ZN8S6FcKzvUBs4sC2okcXTxfS4UuMyqSEE
	 X83Zrgk5Hy1fcb4FhUFKZ1qz/5nTgbpqz3zebWOpRX/KDX2y9CaDGOH1u5gpBcQ1TnIBY
	 MRJR0x34B+W7G9wucgjJYedLQJj5u/X5W3XkibNl4c3oxCJOfBn4kHRnItT8Lb5jZ/Oyh
	 otl0PMgCqPDGbKHJE9Z1K6gxKklxDCUqokhjJHLx3fyeDnt2s4p8Xz7I/DhFu+aLM7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104059;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N809CNAKswmgQquhFgqM7aslG3Ci0bGbb9V6Nom7KDQ=;
	b=Rb6CnwQMfOAS7BuNzxa9RZL1NulfsAVqrCLlND+8DnB6S7nWkGWWw5xWNZ3PbYqkdGBN
	 m2+dLN08DC97BJnLF4v2MUMgidSmco7QE1IP5Tn4UCtHAfCrn0uz/RWRzSnN9LYiP5tAG
	 WakS2vNXQfA8iY8efgHjoEK1A4J66a1S+1vdsHw3xpvjvqammgH75CCy4Dzg7h0BnDmDg
	 dhgeNsC8ErFXyiOFq23VeEAYbZPVdFKNi8ZOJaPxg2+md5K64GjkV++TfjwAdv9l9I6D6
	 cAJZ4ifWn0A/ljmjKulxRoB11hHsOE/gWO5Awy0vqjyNnrxQoebc6PgmO/cHngffnlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFcXbg1Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516DD606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFcXbg1Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67471F000C5;
	Thu, 19 Nov 2026 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104058;
	bh=N809CNAKswmgQquhFgqM7aslG3Ci0bGbb9V6Nom7KDQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=HFcXbg1Z+3QZBxvK/aX1vTaAGtMFgLpJewMRLgA84mE2l8da1+uVHACO4G4B3+n8E
	 0SAKFsH0pOlSrK2hbKhO6ti33E+WxlUsmaDx7jYD4Ra8hkZbUzIT4rGjI0XD2slprW
	 CYMc5GekyOGf9/E3hGnS0Llg781Rpc/1TcjrBQAdCPJQtwH5waHp5ZUPEBv5IiJl+p
	 WV5POVWELWp5ebpRWakvnQ/OH10ICGWXXdwewvwvofKxN2irPWgye8bgKR9SXoBnNG
	 hkt+NcyYUh3pGgtUzfOfErLVUuJNygIK/oufDkvVvNNLMT88H4IHD7gb4e8PDXJEA7
	 RjR1O/O0LFvuw==
Message-ID: <sashiko-outbox-223456@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 13/26] ext4: check multi-block overlap on left
 traversal in add_system_zone()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-14-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-14-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:00:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When walking system_blks->root to insert [start_blk, start_blk + count),
> add_system_zone() takes the left branch whenever start_blk <
> entry->start_blk instead of checking that the entire range ends at or
> before entry->start_blk (unlike ext4_sb_block_valid(), which checks
> start_blk + count - 1 < entry->start_blk).
>=20
> As a result, a corrupt multi-block metadata range (such as a group's
> inode table or a reserved journal inode extent mapped in
> ext4_protect_reserved_inode() before sbi->s_system_blks is published)
> that starts strictly before an existing system zone and extends into or
> across it traverses rb_left instead of returning -EFSCORRUPTED. This
> inserts overlapping intervals into system_blks->root and breaks the
> disjoint-interval invariant relied upon by ext4_sb_block_valid() (for
> example, a lookup on blocks past entry->start_blk + entry->count
> branches right and misses the overlapping zone stored in rb_left). A
> corrupt 64-bit start_blk whose start_blk + count wraps around u64 can
> similarly corrupt the rbtree ordering.
>=20
> Reject zero-length or u64-wrapping ranges up front and require
> start_blk + count <=3D entry->start_blk before taking rb_left in
> add_system_zone(). Add KUnit regression tests in
> fs/ext4/block_validity-test.c covering group metadata and journal
> extents that partially overlap from the left, completely enclose an
> existing system zone, or wrap 64-bit block numbers.
>=20
> Fixes: bf9a379d0980 ("ext4: don't allow overlapping system zones")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D13

