Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943584;
	b=SeZ8+5Rfm+R9oPiqrIVQOMYmXRr84DBq9tb5cGUXx+gps0RoBPr2kgIe8U5aWAd7quDp
	 90PDfn7QIhdqRQj8WpM2s2a6Mw2KH7b0TH+bHjfb3jXZ4Cv5/uOTecnDuZBW+HQ1fFowB
	 wEUK3qLfIe4j4d8KZltfaDmpBYb+ZiVyOfw8pMNF+DftlHiaUB7aFvnlvQVzWr6O6p++U
	 f93FQZFoy6I+zMzDKK1t/dAmI99cZ9C+cHFxzh0oxW2NjuA/4XVuxQt7GHcnGNnmTVRRC
	 6aDLW9HGLNfzqxcyIux0GUYmsEWCeBeG6BzwajbO5oYZwktORD7EjEUV45NkgjZB1tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943584;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FohCxHc6Lo3FbzIGfxK0+88SKoG4NZeA7LIFeNP1/qc=;
	b=EtXpzBeKFvfgfxbL6IMgj4JJxqKEQkSiae6OXoBhk8KtfsD1R3gq/nXeRzuIwaXbGLFQ
	 LWCKRYWDvvEgAzEthCBV/H8soyh+2cz+UB4IKhWkCDNw27x2teqyUyXfXu1FFGj/5v1lN
	 41HTGkRBbwRKAYLgn/NaTcsZWZT3nrzPp1UKNMFLv7tYrxuqoUQYuoeqsxP7q7j0drE12
	 DYwzar4toZvp+LkZjyzRqFwoN/MMVwcI25Opks5yRUImirFEnwnnm4uOnXzdKstLTdNA0
	 3Z/h2Rcj0QyRh40RO8Sf7HhXMT1glC7CWHxsypZWLU8CP0loEbS+tNgFF6jc+1Y5TQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRciXxMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF453606D80F
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRciXxMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A651F008A5;
	Fri,  6 Nov 2026 05:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943583;
	bh=FohCxHc6Lo3FbzIGfxK0+88SKoG4NZeA7LIFeNP1/qc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fRciXxMkaLdB6OI+K0Ac4eiy1kGz7i2kbuidjNwGoc5dceNdruJQYpUq8KjMLCmT9
	 wEIjTMxeTF7OmFANPZv7EGjDCV/JlKAcRE4GF4Hb4HeyORShMyhTH1iuVGECN+WhDW
	 qfyadW5YLZ/vRS4a45cvk14LScWE06qGbcz2DilR2tTN/DNJU5DwYtUPw6DLInfWyH
	 1EuVLjq/FRZFXVYPCqnNpEnvnkdCb3M6F3qexWc5VFLl35xPY7YBi4h1EEDWWIClN6
	 kORFQHUqWAzqYgSsgIpY/ZZrBGMbRLkFd1GlnzC2tWQUX9Xl0V5U2FiIOeUN+z4+Vd
	 WSfJmM3AtuNcg==
Message-ID: <sashiko-outbox-200842@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/9] firmware: cs_dsp: Give the bin file KUnit cases
 distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-7-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-7-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:39:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The cs_dsp_bin suites run many of their test functions against more
> than one set of parameters, listing the function once per set with
> KUNIT_CASE_PARAM(), which names the case after the function:
>=20
>  - the ADSP2 suites run the XM/YM tests again for ZM,
>  - the WMDR v3 suite runs the whole set again with long offset blocks,
>  - the multiple memory tests are run varying the offset and the
>    algorithm.
>=20
> The resulting cases share a name, so they cannot be told apart in the
> results.
>=20
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> bin_patch_one_word-x_or_y_and_offset_gen_params and
> bin_patch_one_word-z_and_offset_gen_params.
>=20
> Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D7

