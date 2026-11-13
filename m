Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553457;
	b=a3VFyCa2oBB4e064NSO9LpWvnrC1jZGlnLXlPfvz1fa3cB8uNESva5EdrMWfHjgHUlnO
	 +1ujdSB9bnLO9uiFwBXk+uS0iiyN8F2gtwKU0Csnc4yt0VWL7yRGKch+S5B0BtU/5F0lc
	 XeX+1Ue7mvkp/EPrmzbtL5Sz9b5vep+qe43alJCwidiOF5TJ41QSJALoLtq16A+YHMvAz
	 Nqm3vr/cAPGHqC0kWoQdWZZcme0bFqlA3lNNl+nxpi01NkjowqnsJg9b2MMDjZ+ZXmfd4
	 4IfMFIcPSV8pPL0R9vHK2gYpeqG2pDDTz8KyaYIV2SA3lhWzdT8teZVPjsbh+SJvZAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553457;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Yua+RjYtmh9f6bWHfXo1cosKbaaf/xuIx4bHm1dxTCo=;
	b=oMBoVGR371pZXYcsLgrAKKxlEuiKUDSnHmT6z+Qyrv1Dw8uIxQxti13TPgWPkK+Z+b79
	 CR3e61MCLKKXIUq+V5/Tiqi3GWglq2kzCrzqeAkxpLpT1Gwpzmi/yz1JW0GAMYYUVWBK2
	 PDqHaZyRaxJsZC+BSg1B8Ly/SItP/BBqqJ0yU0GhFQE7DkjQTj6x1xt6agSGLIn90fNl5
	 +5ps+C5HCddKNwoZnbF/QHnMNTXicl5N1cpCcLBzmnw3Vu9DH1d5HB4Lu1xx2vH/1Q7bj
	 UXTm/80pctY+3X/5GRs01Fu7s5ODft0dfmym+OE+i4PlrnfHxKgP2ZoWdN5vWhrBr6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="BWW/0IR3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46AB606A321
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BWW/0IR3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7154B1F000C4;
	Fri, 13 Nov 2026 07:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794553457;
	bh=Yua+RjYtmh9f6bWHfXo1cosKbaaf/xuIx4bHm1dxTCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BWW/0IR3A3opXLCLfwbo0wsqlnjxoyNXTFi1HzWBLhFp2amhPoIXvuKTMn3rIxkkH
	 TnYeVWdy85q4/y3pi7DhhFD96/c4SeVgKBTWVL2M7v4SI1PzqYfMBeLeaDhZ1sMWm1
	 7MeZa0m6fm2j8Rj2ISujUwhZgiaVlTGjRWIbeeZDYr6iyf/lWNz0hvsQkpqXStH52n
	 6LjaEOIocp5xnXkMsXhT9K0IQ0PETb3hmJTTzfBGDlA2iQErl9CmJ9LMN1K7/8/6Pu
	 jm0cMN9hPAl9RT3JzxguYGbfo9AhHmBuA1sEvSKU/1MttmzZQMkl1J48etu2JcVVXp
	 4QlrM8/MJPJrg==
Message-ID: <sashiko-outbox-212311@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] ext4: reject casefolded names that fold to ".",
 "..", or empty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti" <sarthakkukreti@google.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113065332.929085-3-sarthakkukreti@google.com>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
 <20261113065332.929085-3-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:04:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Filenames consisting solely of ignorable Unicode characters fold to
> empty strings, while names with leading dots and ignorable characters
> fold to "." or "..". Allowing such names to be created or looked up in
> casefolded directories collides with on-disk "." and ".." entries (which
> triggers EXT4_ERROR_INODE in ext4_lookup()) and introduces duplicate
> entries that e2fsck flags as corruption.
>=20
> Skip casefolding when the lookup name is literally "." or "..", reject
> any non-dot names that fold to "", ".", or ".." in
> ext4_fname_setup_ci_filename(), and fall back to opaque byte hashing in
> ext4fs_dirhash() when utf8_casefold() yields "", ".", or "..".
>=20
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Co-developed-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113065332.9290=
85-1-sarthakkukreti@google.com?part=3D2

