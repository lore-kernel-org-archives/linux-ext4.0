Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587809;
	b=sk53NouBDtsV4cnDnBPkcE3UIvMet8gua68JE7MWHWHlLIOSGTXWicNyBtsS3JXHPOcQ
	 eOf5TeATTOPjAsNUFItAKYCx2XTBzjgKS9MNUz46ZJ1tc0Y2jKob9X+vxVcsdar6sPrn+
	 kPdvS+G28R/r5y5lUE8y0k+5203C1tuEdpvnkfc7GXdGBE+xIjv3D47w+Vubi/TUjNxfZ
	 SS5Uzd+Z2wkjR/BV54soMHkpDT0Y3O32xkAtH5OX8y2aQ+SgNE3J/HbY6QDiQOFKoHqwL
	 hvI+KP0fqJt7WlgdSBdJsX3pfUMyyvDvbQ46a2dqzaSgetRkEuISfW3RxIm47LKWdIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587809;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0LYcTI56KBAptz1U0IfnmBE67WCWwMndw3ncchElZtc=;
	b=xebHYrkyJLsoCTLmBQ4bt7m6G/wCNBuwJA56EAWca1ZTwqk1iPvhmpF0wMmh9NUZfTVq
	 NPyxRsoEgB7y0BaHZzT78/26gMl2rf8Bu+SbLRoq7g5BmrmMMfK8ALDy5gpxX+kcw/b2F
	 qSh5MJci4xhMppRvoH5E030wF70LTJkBcF0HW6ekAlOfkOJtxOmjDmgXYYCNwvubdBuZr
	 LynLfyVHVf6wmwktPO80diDaujxP3Xg/6s3FWqVx+FBCZU7wOjxB/of9XEUIELisBoOLB
	 l4xk3k6xxeI8rS3sHZitIwo3/6bvTBZBsQhPNmLOh8JndE3CzYTlIciyyDiTeLLc5BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxwerzUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877E606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 06:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxwerzUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498FB1F000C4;
	Wed, 25 Nov 2026 06:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795587808;
	bh=0LYcTI56KBAptz1U0IfnmBE67WCWwMndw3ncchElZtc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nxwerzUGB9+XVv+M/O6TqI7Nbp7pveGge/YaujmnlD+edtPBkQLSKGF3fwp8CEy2R
	 cswc+gzOfF4o2d8f1Q0Ap8TukOexmpRqJtVmsiuxbfNStjP7eVR0YYm7mPrnd1gAXK
	 bmL+MTffm7CAwig0gRXPR637cQdGRzPY59c4DuLyVtIoH2rBFXB5HTtTrrD1tdbNNT
	 6WXGAbR0Grpvi9hHbn9hwmhq2eoB5/NvcTYH3vtuG+lJSnslVOpxubGMYvr0KIRdJ3
	 G5TD47KJjFJhpmrw6BgC4nn4jy7JZRcQm9vruSAfSaJkKY9pb4o0vFXo1io9h7Ne3U
	 +rPfmj0sBm/2g==
Message-ID: <sashiko-outbox-232680@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125060131.10328-1-arzuagapozosergio@gmail.com>
References: <20261125051909.61227-1-arzuagapozosergio@gmail.com>
 <20261125060131.10328-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:23:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] selftests/ext4: shared_block_reuses_same_ea_inode stores
  xattr in ibody
--

commit 7a62229bf92048e6830756e7f4a7119dee79e887
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

ext4: bound xattr journal credits to transaction limit

This commit drops obsolete ea_inode release credits from the xattr credit
estimate, bounds the estimate against the journal transaction limit, drops
provisional ea_inode references when reusing a cached xattr block, and adds
an ext4 selftest.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cre=
dits.c
> new file mode 100644
> index 0000000000000..4cf51eed24ade
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.c

[ ... ]

> +TEST_F(ext4_xattr_journal_credits, shared_block_reuses_same_ea_inode)
> +{
> +	create_test_file(_metadata, self->shared_a);
> +	create_test_file(_metadata, self->shared_b);
> +	memset(self->value, 0x7e, LARGE_VALUE_SIZE);
> +	self->value[0] =3D 0x42;
> +
> +	ASSERT_EQ(0, setxattr(self->shared_a, large_name, self->value,
> +			      LARGE_VALUE_SIZE, XATTR_CREATE));
> +	ASSERT_EQ(0, setxattr(self->shared_b, large_name, self->value,
> +			      LARGE_VALUE_SIZE, XATTR_CREATE));
> +	check_xattr_value(_metadata, self->shared_a, large_name, self->value,
> +			  LARGE_VALUE_SIZE, self->readback);
> +	check_xattr_value(_metadata, self->shared_b, large_name, self->value,
> +			  LARGE_VALUE_SIZE, self->readback);
> +
> +	/* Clone the shared block, then deduplicate back to the original block.=
 */
> +	ASSERT_EQ(0, setxattr(self->shared_a, large_name, self->value,
> +			      LARGE_VALUE_SIZE, XATTR_REPLACE));

[Severity: Medium]
Does shared_block_reuses_same_ea_inode actually allocate or share an
external xattr block?

Because the value is stored in an ea_inode (i.in_inode =3D 1), only the
36-byte xattr entry is placed in the xattr table.  Since
ext4_xattr_journal_credits.sh formats the filesystem with -I 256 (leaving
88 bytes of in-inode ibody space) and both test files have empty ibodies,
ext4_xattr_ibody_set() succeeds on both XATTR_CREATE calls and the
XATTR_REPLACE call without ever reaching ext4_xattr_block_set().  Filling
the in-inode xattr space on both files first (or formatting with -I 128)
would force large_name into a shared external xattr block so the
provisional ea_inode reference-drop path in ext4_xattr_block_set() is
exercised.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125060131.1032=
8-1-arzuagapozosergio@gmail.com?part=3D1
