Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943138;
	b=HSi669J8/9JOXXTy3fCyxju+o6gchXBzgXfGRrXqkSKhmUc/oRTb3G1n86+GcW6E+niL
	 KyiMaHLiOqY42h2GJ3O4eEuIOq/DlLiOTLCQAQoiQEBZVTbOTwS6w1X30u7+VOXkYz6Qu
	 JhlghS3p7NnJud6MNt0hNApwqfw8AqMOaR0Y0o60cUv94sxhDgXsc0Zi1zPlQ5Wj1fD+A
	 OE02rQEYFZUY4DSbOV4X5uHIfQ1jxqn2ckpl225QQcTmGiY8a6N4aiOIbk6tGUqhpNDrm
	 zofORKjWcjWKhWvsttFbCYWp89ig3pc22410JaXOh8HVos4ImUX6FJNngoqQPkaIRxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943138;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KYphfZbLOr55GK7hzMKHtgjVpANk3GdTGUfQvKtSB/Y=;
	b=EwSJWtnYBaszi3k0YJyoyNJg+LXj0Iv6r59CZ0vzlY/ZHJWSgQCBMhuOrCujU5gBJDRk
	 z3fBR3TjR0hk0dyichEFj/qPBeyhViqIUJq6GUPSsqCOl5SlBwYxfUwiQrH5Us115Lx23
	 KglNDcFtO7suLsGy8IrDB7wfuTTenXa40OLeftO1smsnGmvBgQX2FUOgvZ+CiPa53BDGt
	 m+B7VaGO4w6/lhsLa6TRppyb85XIMdXV2yK9LGKyrkLZGsJ7PUrF/RMl+atNhTNbbenmH
	 M79eAQSZt2FysOwocKQVfxO4FYTPUyUeXEXBUxS4S9MDgwq4esgyRZF/940lsqqmHug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gOV5qH+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811C9606A326
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gOV5qH+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064D11F0089F;
	Fri,  6 Nov 2026 05:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943138;
	bh=KYphfZbLOr55GK7hzMKHtgjVpANk3GdTGUfQvKtSB/Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gOV5qH+JQ+TZPJPBz39zqdnSz/sJjCW/60evmRtgJN5OF2tVQYoSLeXMgP5W5nfhB
	 H+iY7Zlp4mGi8V1e59b65/Rn+j+Wn7NxEj78hDbDFRbPdBPXetWEW9s17q4LZUr0ur
	 h+JReNFL1PO5J+VEr3Hjx9a5khVGTwt7dRw2Z4iOlPwlZBEovLp3A+wNPEIH69uOm2
	 hBvABSJ+9Mq1l46HIcL2tdDkQbbu9TEuRTJzFN1egaJg9URpf0WOSjMvsCy0V4un6n
	 BudREK3ryfgVjCfvx0CqxXrHoq4sw1oMPWB2UuAwJkeehG1JSSnH2qvL0BLPeQHqCU
	 7CYISgvkYP82A==
Message-ID: <sashiko-outbox-200827@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/9] ext4: Give the extents KUnit cases distinct
 names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-3-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-3-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:32:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The ext4_extents_test suite runs test_split_convert() against three
> different parameter arrays by listing it three times with
> KUNIT_CASE_PARAM_WITH_INIT(), which names each case after the function.
> All three cases are therefore called test_split_convert, so they cannot
> be told apart in the results.
>=20
> Use KUNIT_CASE_PARAM_WITH_INIT_UNIQUE() for these entries so that each
> case is also named for the param_init() function which registers its
> parameter array, for example
> test_split_convert-test_convert_initialized_param_init.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D3

