Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795126245;
	b=QBj8GZlKlAJLGO6ZRYJrJaHwRgMQ4wPjbUCHYF1RMet130HpNlk/l2IdZpqXmtz8MLbi
	 YBXhYhjLfo5rPo3Z48AhvFj/7io2sN1e5i/fQJZKnQi1r8HadzprkXxiFsdHvEKTod9fN
	 5C1m2G5YdnY+gZpq7b+9Kdr8VxaLQJQLlHVkFroSVeyElQdUTQKAbUAQWkYM0rGr/JW0J
	 w88Z1DIjwNhPXzbj9D5sgLSNwtUS95+7UN1RS4/HB47CXyYKiSwC/ZV5bJwLAMdXzNncL
	 y6En4ps2K5gbA2U8+d71cz9d3owrpvoLvPX5NqyZZjHICvabgJrQlsj1Etz4cQEJFqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795126245;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2893f17q7j2y4ovFQG0JLrEzRR5Vk7OnicXJj+XMXps=;
	b=pt/Ad4xN8GOTpcubLi/8WoLORmAxpZyYNTe9AuEO5oobFlV1sXOtNZhmoEcj2EPPSote
	 UEWDqHFDLH5aFMti47H0WAHLFbP786AOIA8W0mhuecnwod8E3fOYew3uXjlUOz/1kcfp2
	 l2YMSZ7QDj35ZkDEOz4pIN0iIIokxGRs0RpaDbjorFBijjSjsc3lAw9otwTunX8dnCEW2
	 S5kChiU9nD/IMh3rN4CGU5cdtLai+slK/jHmNaWm8QBJkDk+JUFLpgTtmoOVvqXeb+ayQ
	 6lX56g+Csrb+Sj9wWaON2CgEvfcGPcFzKFunXvw8JhBwT0OrVl5B2la3IHZ/Inti5sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PODESZ7W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6D60A2600
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 22:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PODESZ7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B1E1F000C0;
	Thu, 19 Nov 2026 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795126244;
	bh=2893f17q7j2y4ovFQG0JLrEzRR5Vk7OnicXJj+XMXps=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PODESZ7WTk6nIUdgV2PuXAr04of3KU2UOzqd6edjHtQ61qInYO+QNsFsj+Q1ytRY6
	 RCw28uLHBCQON1HLIrO1FzNS+dxHWwpOop1gA+pCvEc72Dh+QI+0ibOi5QWgeP5jwn
	 L0yGkM/NiHedYASO6Ucv1oLwuYn5Cgki7pvS4JcXmMJKSDjVGo/wtSYSukHVd1EAaU
	 0SO0WszS1IwwQApI+XjVdgeN/M1lvreS3WhdRwCDMDjfDypkkOXL2ILt6YKBdGSIOI
	 MZjGb7muGwYsLtRi8he6UJF9bLAKiYT0q14gKJrqjQkVOVl6oBWgo7QnTgNlsh7CW7
	 1T97befAFl1xw==
Message-ID: <sashiko-outbox-224119@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v2 1/3] libfs: reject casefolded names that
 fold to ".", "..", or empty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261119214944.1480596-2-sarthakkukreti@google.com>
References: <20261119214944.1480596-1-sarthakkukreti@google.com>
 <20261119214944.1480596-2-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 22:10:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Unicode normalization and casefolding (utf8_casefold()) strips code
> points with the Default_Ignorable_Code_Point property. As a result:
>=20
> 1. A filename consisting of "." or ".." followed by ignorable characters
>    (e.g. ".\xe2\x80\xae" or "..\xe2\x80\xae") bypasses VFS special-entry
>    handling during path walk, but casefolds to "." or "..".
> 2. A filename consisting solely of ignorable characters (e.g.
>    "\xe2\x80\xae") casefolds to the empty string "" (length 0), causing
>    any two distinct ignorable-only filenames to compare and hash as
>    equal.
>=20
> Update generic_ci_d_hash(), generic_ci_match(), and
> generic_ci_validate_strict_name() to reject case-insensitive hashing,
> matching, and creation of filenames that casefold to "", ".", or "..",
> while preserving exact byte-equality matches (such as NFS export lookups
> of literal ".."). Using a 3-byte stack buffer with utf8_casefold()
> detects all three cases in O(1) space without heap allocations.
>=20
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
> Fixes: c843843e714c ("fs: Add standard casefolding support")
> Co-developed-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119214944.1480=
596-1-sarthakkukreti@google.com?part=3D1

