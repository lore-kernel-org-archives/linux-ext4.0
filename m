Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795125352;
	b=JpLrD8h0mbtdYHbAptqHEaeKUkIklAE84keMOCiiRxLqSTi2NXmHAsQB8v14pARmVyI6
	 zm9ZZlmaN90EsTnZr/78LaCktqMrFYxSByNH9Zse+wp12vGPGBk2pQOTdt8H4oKXxfpy2
	 vKGv1L2+79u+a+sV1HUyMIbYazT7HInCTim/Nbw02hEsMA4gmKP47U0B6xEOCh/fIH1S5
	 Zmtxlepp4Xwxc940hMH/z7vCq0wgP2rF5S4KkvcELQ197Y4IO0ErSfH50nK6BdT0mjiAN
	 Yr6L8ki0LRNDWNuMuKa7PLgXBAGAnVBlViewJP+2J5O5T+rXeEhlKHspA3kwXN0zKFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795125352;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9KKEimDi0vLrmC7or1zb/M893GwrLfDEa14PTJ3wnjY=;
	b=tgWmHzXNTlANpy/7jiBOfmOTk+quyneIFIqNtcopLc5tKYJTSODPmc2JJwIYKdfjJXhj
	 5W5TjuajlkasdKcn/N9MT+ROnunPVavOBO68bICPfSd9+Zrg8Oe7jYq/CYo+wcZD45f1l
	 gfpJ8FA7K/djrI0kw3IDsfN3S7U8DSPZGxz6K6E3pkuUar8iE+t9G5s3YFpNNkHl8O0lp
	 d1GsO7y+L1qcN0s0PllZBjLKs05usf7Z5+a7uDs+63K+C7AtRMRNCcVdoiEpDpwscimzm
	 K7XXxdD5IIx2zVPoNG/jsAE6Fi5LVbI0JUOcCSVKQcwLqchQYAH1bWZxoJFqmNtwx1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nRWpNmuo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC01B606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nRWpNmuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CDF1F000C0;
	Thu, 19 Nov 2026 21:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795125352;
	bh=9KKEimDi0vLrmC7or1zb/M893GwrLfDEa14PTJ3wnjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nRWpNmuovbYFKCQDiGSvRhswq4+kGuM/2gJsJw9WBzkAbf7rTH7RpS1VwkQ106dWy
	 QAh2H67yBOEQQ5p2Qbe6weXwdSEO/mauPMZFRcfbUCloZQZWt6ErgOS6+OblNBioKK
	 RCJGJ0nqaoIDszOxVBiV8NGtFBNWoVXUXNEwzNbiYAWyYOcNcciYHzA6rNGGSb8aj0
	 dyK9AzE0guG2ED+cZc2duPmBmgpIZ0u8s0M97laNOv/n+X39hYYABv4mvuhG/UYDSB
	 CL5gRlz1k65jT7H7jySVjAD/j1gpR+Uaad7av76rfPvhyLG9B31gV0K6mUDi9dvBK3
	 6X2Tgw8eZrwjA==
Message-ID: <sashiko-outbox-224113@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] ext4: reject casefolded names that fold to ".",
 "..", or empty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti" <sarthakkukreti@google.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261119214944.1480596-3-sarthakkukreti@google.com>
References: <20261119214944.1480596-1-sarthakkukreti@google.com>
 <20261119214944.1480596-3-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 21:55:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Filenames consisting solely of ignorable Unicode characters fold to
> empty strings (causing the first such file to be created on disk and
> subsequent distinct ignorable-only names to collide with it), while
> names with leading dots and ignorable characters fold to "." or "..",
> colliding with on-disk "." and ".." entries and triggering
> EXT4_ERROR_INODE in ext4_lookup().
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119214944.1480=
596-1-sarthakkukreti@google.com?part=3D2

