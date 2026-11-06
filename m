Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943511;
	b=rCBUUkapFhPagqtWGcmBhLY4nrCX2gpsTCir7xEUw6rCBa+kqD3K4x1faSSdWxdh8q7T
	 ocH3sgM/PLkA6CCxhE8yKXfJumVJ4QarCWnT9NT9tHsNBKPwg8EYxz7zVzsZe/oq1l+MQ
	 VlfK5vN2Q+sVp5Jyhmr4HTrBLxqM11C/3LtIB/6DNLu9ioUi7eqfqZgpSEfojah/haQLr
	 JJt2GX8AAY+5w7YvFBRgy1zDCcckMJFU9tYMGqmXnCfamLsxJamF+b/vFMQQ47kqeHNbS
	 P6A6q1GaEhjqUgU1SrBWS8yObnkS7sXWZa6e8cW2fTqTzrEjzo2PqIsPzSHhMUW+uTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943511;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XN4OtaxWBD4tD0pPPT71oxG4uc5HJdVmHtJswhAGHvE=;
	b=wiYFPkBOrtbK932hGC00/Qky9vhk8Q8pKClp7BdqrM1h+j8ogbWrr6g7c8sZvsOXv/Jf
	 myNlEmEjXfxwjDnjlUWtkcjSq8DEzNlPGrsWCT0g1aSGdaH2Z7jF7n+FYSjYu4+IZZ4d2
	 pdkfc582yyfPQs7XBr823ALsQzYOS4hUvUKDuKQVVpkByTv5o223qniLJN8JEMKvhlMHK
	 bNqpZOw4ioWD1BL+WU0ADaaCkyeMAqMVMvCHpZZa6JlOQjIJoziiSY/6zEo5Gc+qumlIh
	 sXIUMZlgjyJ4sFII9z6KG+S4pJeVanWYf8NZUuF1DCg14cvT4IdaaqZeSLrkwHIUNBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QDkdFY7v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9690606A326
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QDkdFY7v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604BC1F0089F;
	Fri,  6 Nov 2026 05:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943510;
	bh=XN4OtaxWBD4tD0pPPT71oxG4uc5HJdVmHtJswhAGHvE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QDkdFY7v0zGy4fijjOP/nNAKdL9tAVGfCQjC7eHL49b1CRNMFtug9FWGGvroXUWrM
	 dJU5p57DRj1RohhCQVb2kA5GXXoN51ttvr7uo9Ao4pIjuygHfr6EjJxWy7oJf7G/p9
	 ow4hoDuuc4dxxtfVnGmkRZgDi7yRbJwq7ALH7+1xwsJUW2PMreRxteuojVcAORKS3M
	 KyERu+YY4kdr48pA+BixT93KZ/qdaAW4ZQRXk/dC7pCiXQqgPEOOE27RfqFCqnTlKr
	 ifhjsa3iV1zX+BFSdmqmehioB8CA0ViquvvUI6UVF35YCEeHiA8U1AbPwhCLg81GBc
	 6Ns6lcWrj3bow==
Message-ID: <sashiko-outbox-200838@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/9] firmware: cs_dsp: Give the wmfw block error
 KUnit cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-6-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-6-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:38:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The wmfw error suites run wmfw_too_short_for_block_header(),
> wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
> both with valid and with invalid block types by listing each twice with
> KUNIT_CASE_PARAM(), which names the case after the function. The two
> cases for each function share a name, so they cannot be told apart in
> the results.
>=20
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> wmfw_too_short_for_block_header-wmfw_invalid_block_types_gen_params.
>=20
> Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D6

