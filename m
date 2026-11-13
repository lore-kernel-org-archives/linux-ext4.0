Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554855;
	b=SnpA1U6wbvNqV3aec41l8Lc0wls5rwbLrboO83yKQqbiHSNjnlrIfGNiEhgBcmns3EA9
	 H6msbQHk1caLnY2xDuleOroFEydp4nrR/P+lY67mHjG+5VRISnrMoxU2EeNxHaIl3oc79
	 UUr6N55SnlMYVhqFNu2CM0wFjeAR4HEOamqyEyeov3a26EpQKa4bNti/MHPp/0ismDcKb
	 69K1RuZYRqHHOlAtSRBY5ukgU4TLSVbiyfbXwr6sJy9+4d8jT4zB1YvEta6iGtWw5/ffZ
	 Rt1g145YDMF3AY6LkC4Rd0Sw+ZwNP78PcIsEeQ7aq1jAxsXUvYNNnbqfe1v6K9xpQ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554855;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=s7TY5wKuFz0pffBAJMdbPbg+Xa5yLuxe6GHqxDP3cCo=;
	b=J9WryxoHMRFElZqxTaLeiYGmm1kmsE4fQ91RVOktqav4cJ4+EgYbWrMZkLR/uU25bKWB
	 kpu6XUJKlDyb/+eMBNxPFhE8WKkYC6S+NTsf12IQw6adMVRwUvV8d+d0lQ/nmS4UIPc0I
	 NqhHoPlLYx+G/yGuZeGsF9j1UZ43prlQejzM83EondsFZau4G/W93ge2TrpCga+16QXWF
	 ENZgW+gAOaaTIPGUNYM1/Z3CHNZS00T0nTMnW+WncSck1ZSdhe2VDU2N3qgP7i1SuO8wp
	 MizurEESWcV9f55my/W+22lbmSPw970+7Gi/AXc8f2w0dCCPWkxFt/V5L5O3PgePMIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q36JbU+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAD1606A323
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q36JbU+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B371F000C4;
	Fri, 13 Nov 2026 07:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794554855;
	bh=s7TY5wKuFz0pffBAJMdbPbg+Xa5yLuxe6GHqxDP3cCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q36JbU+2pW7+P287G1OtB3Rp+nXJ6AXUX16lfBsYTCl0gm19oFQRAuM9LhjRnqWdW
	 4jwK6wPcuaEsx53bibw2zAMxE0GC5LKAWBp3IiQrOzrUsupgle0o8D+P6Cf/Tq828m
	 q1ZzjPW8k0JSfe9X1kTgn6yLQ17m4ix+hMqGSsVcYF8xAExJvGc9IV1UhnZ/Ppy7Hd
	 m50xn93LRMRmSiH1U7mHBEIGs3DCYBw6D7KLh/4AKCwfwDfijqXUKfYk11p5LUtwhc
	 euxWm1E1jc4eB0q4ezewRqk1dbkYg1Wvb7fIYpJdgsrR0Kv5J1TcwIY9RVfMduGIlZ
	 HtDCmUrAKP/Ng==
Message-ID: <sashiko-outbox-212348@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH 1/3] libfs: reject casefolded names that fold
 to ".", "..", or empty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113065332.929085-2-sarthakkukreti@google.com>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
 <20261113065332.929085-2-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:27:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Unicode normalization and casefolding (utf8_casefold()) strips code
> points with the Default_Ignorable_Code_Point property, such as U+202E
> (RIGHT-TO-LEFT OVERRIDE) or U+200B (ZERO WIDTH SPACE). As a result:
>=20
> 1. A filename consisting of "." or ".." followed by ignorable characters
>    (e.g. ".\xe2\x80\xae" or "..\xe2\x80\xae") bypasses VFS special-entry
>    handling during path walk, but casefolds to "." or "..".
> 2. A filename consisting solely of ignorable characters (e.g.
>    "\xe2\x80\xae") casefolds to the empty string "" (length 0), causing
>    any two distinct ignorable-only filenames to compare and hash as
>    equal.
>=20
> Update generic_ci_d_hash(), generic_ci_d_compare(), generic_ci_match(),
> and generic_ci_validate_strict_name() to reject case-insensitive
> hashing, matching, and creation of filenames that casefold to "", ".",
> or "..", while preserving exact byte-equality matches (such as NFS
> export lookups of literal ".."). Using a 3-byte stack buffer with
> utf8_casefold() detects all three cases in O(1) space without heap
> allocations.
>=20
> Fixes: c843843e714c ("fs: Add standard casefolding support")
> Co-developed-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113065332.9290=
85-1-sarthakkukreti@google.com?part=3D1

