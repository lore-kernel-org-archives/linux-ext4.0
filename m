Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943013;
	b=T8TMRiuRtF0GTuMxlhXf8iO2DmdXxVdFEWaQescbjTOQgbrqPBmQmg2CCGCnV4x38eV1
	 a6gHfBz+iWGOA1zm/UQ+189LJ2JMVp/v7furDO8ycVkvysTf8WB4xn7/dPsvxYoPa3E1t
	 ikS067MSG9qhRETVszjE1gbgwj8gscX0DMpn8z3VOQuk6ps48OTvXGIeO/LSDvMWvnIor
	 AxsfL0XquC/gHClkmatlKMrDaITqSn5a9oOBGvmhWD5ayXDJxi/SAPw58fJE6f5V+3JQm
	 MQy1d3mlemwmr5q8dko7BJ2HzBBDsGIcSbGGyoZ+l5D+EACCdKnFQoYfgjDpqbK20ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943013;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=B7NyCndFHk9n2v6VGvXqhSk7fmYuaECUWoKQlQlnr/M=;
	b=olQ4KcFTaqK8uO3ICKfWIRSZp8MCDFBiVeAzgUUUf2iuYUdZRby/NIVvw562IE95cZde
	 xARvG2/AcaP2tknmxVmPhBrHfDWl/khpQzj2A9P2ZoFX6UP5W8iMy6WMrtgvJ2Rp8ZWsh
	 3n5ag5M6bKbiODwt06gx1tes8CErdDkONjklqrpLvfnu4bOjPJ/zPEuvTdibr6vQukZQ3
	 Y00AkC2OH+mI9jj1kOvi+j4WUsaHUyh1xpnBOrqV+9NC07y1LG9kNpaWp4OJ/5iqOF1oN
	 wGiNoqD31JhX/J0TF5r2APIl9bOn6q++AvQO55my5THL2O94i5LHvMkMDZpE/Nu0q3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OsOI18tl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973A3606A328
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OsOI18tl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146741F0089F;
	Fri,  6 Nov 2026 05:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943013;
	bh=B7NyCndFHk9n2v6VGvXqhSk7fmYuaECUWoKQlQlnr/M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OsOI18tl7LgsA0URBWDh3wD+qEwRitiEDv4IKSQOE6uC/dxYS2wW5mwKLTD2tFv6q
	 CYgz49dJTMGXp78+AioZqBbu8vVS9WIQB21k18nPqQ2d/C4OsdjiVTzgdIUKgVMvVS
	 MWyt5EFWytK4qh588XfucjwY8YGaLzrNMRe/qvCprfFBLKd+kjEX7IQFxI1VMCBpAH
	 rc8KqO4oEUPhZVvlfg/aEXxVsnUf9kaHHhnPrGXrqi+K9uudd8zjy8SS4hNhf00Gvm
	 m5hQpNW6DfX3uoBqK2hdSszTXGB0TyE0kadusJbSY95lh79fcGktWMe74IB4W9ZVj3
	 w4OgEpC6bfM4w==
Message-ID: <sashiko-outbox-200817@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/9] kunit: Add KUNIT_CASE_PARAM_UNIQUE() and
 KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-2-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-2-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:30:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D2

