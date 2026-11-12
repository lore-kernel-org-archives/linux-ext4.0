Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456640;
	b=A7IqRBCilcsi5FL3lPb0W2/LOLrTmvNhxf3qIZwrBDmtytyESt3tJFr8V0gJRAbtnxus
	 FUWfyKNFmXWlX8jRwinYZfnPUseI/iwI6eqY970KLiP7md2cEbpe1UfWvMM4tb6hjhv/E
	 KbqpFRVFo69veFPmjGo9ks0PsRbxEldabRzrA/C5oOlZsRmHOM3MpWMtsmdlifVZNzti7
	 V645TMCd/CspH8XD7L+IDZOPTZ4aBZeE/z0XKvyJww06WR10jJrcYboBMLfKewLiSW/jK
	 BTr3IP3e609ESAPO1xcLj4Qsen8pRnjexg5hBDREXlblXDXriPpEr693P/7drgKEaRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456640;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/ZcoQN7nEKQc6E/viTZtJUGRJIqH+ydcn9V0Z49TmQw=;
	b=AzlTYtYytU0W0I7VXtcew4di3HmbPDMSM9YDl1k+6Y3es7AhAEypLy2afb08Sa6Lnh0t
	 6xX3IJniavw6mXkmeuIaPzWWwIQXaxWj11D2KXVboDpt6XM7qdmFfQkfjBfIgkiML+hCx
	 RyBNc3FuA3ZLieeU13+SoB4XTwBPMq6hcKEBb7PKYs7P82lqEGhMMyFz80bAiSLdg+FKj
	 Jh7wCNvUfTJtqR/lmeesr9c7vzZpw8/tjw5mU80KfMR5jGQYes/I429ZSiEax1U/4pKNj
	 Pz/9cQ9ZP/xjP5bwI3us7EFucBfxPCMZBoEzcLSJbL6gwhBMqbIkbExsYJCZAGQIlAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lG6lPYt0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2408E606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lG6lPYt0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7751F00A05;
	Thu, 12 Nov 2026 04:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794456639;
	bh=/ZcoQN7nEKQc6E/viTZtJUGRJIqH+ydcn9V0Z49TmQw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=lG6lPYt0i3sGIy5fhI7GzlHz7LocrnvMf09QC3ukG+2X5qDGP4/nGdgpFs8orLH3C
	 c7uojMSJRxYHufpwkCzXkz2wcCKK3IksuPDy1BWpnWtx7+xr8PWv6onCHwdfe7PdZe
	 RtjS1ZsBZZ07sD3bzUwfkcIX/hwNghXA7kxZ5vZj1R0bj337qLk2LEdYssf0s1878l
	 luu8YHO+uHpf+MJO+djj61/Cc0js3pO+KOumEq7V+Oy2mhrBsEL3A/YmYM9/6+JBzM
	 cr/d9G599UugE7zUu55NwBmXlknEPHfy25+gqWpXp/J/RmE8ck+JL0kiP5bR707gb1
	 +HXfK6OwFHHRQ==
Message-ID: <sashiko-outbox-210313@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/27] ext4: check multi-block overlap on left traversal
 in add_system_zone()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-16-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-16-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:10:39 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D15

