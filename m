Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3623B9610
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791847020; cv=none; b=H+zQhUB5j2mesIYzc6NcXlHB2PKXCbSki5FkDjpg6xaJYtWHJaXIZU0ikKcS1VncJJ8zO/6+B+JVQsQmhPP7vF5UaHb2QsGcLyN9epXnKZO8rPJn1YFEM/eI2jVAFSnU4W0UJWz2RWI2Y24OP2jLUguW0yfyevbu3PxUy8Hm5KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791847020; c=relaxed/simple;
	bh=eD6VxM2+M8KitH3epDbRZqwfyjHQBR0VOQ70pb83FME=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=lqA2vt4KRLXLe4UGPgVWR+0Vlync5XUkglWkrbtwnWfsJxEcaLd0aMpaSTmFzFCMbqtEJjdHMZyt7qS5Sl1eAbxQeCMF3/kXKD2njt4yU2nN6e2Mv+TDAkmXmBMkXDnyIYLCYztfi6+OuHfMUwTUoo2b6aiD7mtRgVE0AeZWelY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCF4SubB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCF4SubB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9091F0089B;
	Mon, 12 Oct 2026 23:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791847019;
	bh=eD6VxM2+M8KitH3epDbRZqwfyjHQBR0VOQ70pb83FME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kCF4SubBImyYzEJk3isXqKmt7o+Pm3cPDWD1C/Ja3KfCe8y2frzyzyNQ3yxqiowQy
	 wL0ornFXyS7wPizEmkcDnx+1coKThq4BV1qcVtNdMGODeC23Z+NA0D3ywfhoUuO6Ut
	 v11WowIPMyZnt8aKZd5SLXy8EnRHHut/r7ISKoWGOkH0sXTp52xzrcDrZ8nlAIvnrE
	 QI5MJB8sDkkEMt6dJszfYTxChLWEyN9+MUPyd9uNGFVbhL2N9OGXSUEdRxn5d5gVhs
	 K9Iq8IOCGSGKOY6GJ5bEwcRpddW9zQhB+YgCuvrtY5YOYhY9sqM1TKf11sRQzSHJQZ
	 mDC0nWwLp1zLQ==
Message-ID: <sashiko-outbox-168712@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] kunit: Add KUNIT_CASE_PARAM_UNIQUE() and
 KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261013-kunit-param-names-v1-2-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-2-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:16:58 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> KUNIT_CASE_PARAM() and KUNIT_CASE_PARAM_WITH_INIT() name the test case
> after the test function. Several suites reuse one test function with
> more than one parameter generator or param_init() function, listing it
> once per set of parameters, which leads to multiple tests being created
> with the same name. Same-named cases cannot be told apart in the results
> and cannot be selected individually with kunit.filter_glob=3D, so kunit.py
> --run_isolated=3Dtest boots a kernel for every entry and each kernel runs
> all of the same-named cases.
>=20
> We could fix this by having the KUNIT_CASE_PARAM() macros always include
> the parameter name but this would not only rename all existing users but
> also result in some awkwardly named tests. Instead introduce some new
> macros for use in cases where we need to disambiguate.
>=20
> Add KUNIT_CASE_PARAM_UNIQUE() and KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
> which behave identically to the existing macros but include the name of
> the parameter generator or the param_init() function in the name of
> the case, giving names such as sha1_test-sha1_gen_params. The
> param_init() function is used for the WITH_INIT variant since currently
> all the tests which register parameter arrays from param_init() all
> share the generic kunit_array_gen_params() generator.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D2

