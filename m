Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AD93E172B
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846952; cv=none; b=CxY6VlOR0s7Upha1pxagptjhBJVPm40hKm0TyTtDL3VkU5D+Pi1kcwO2kaHUEbcQLjDOQpKv6rqP5COV4bxB63rUUayTurn64KH6yQ5SQHb0UWYCV1k1uGIfVeKvUGtHPxTGAZ6QIo1L56+y03pzqn/CDl/ZFX2qHAVRXF3PVjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846952; c=relaxed/simple;
	bh=LZTbMdOEYdTBKXV2EqQCDNWNiWBe+9yO9d28SK2rJBQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=O2AKkZu5OuhafAmYfjlfYSOsJLU9Rik9v7e7Nb2NuW6z8srMD3J4TCJMrJT4X9V3m9fe2hEXJUj38EgMR/aA7mPJGtjzzlzZZC0VjKFeo3WAr6dstNkSihWE+ezWaHyA7JZ9P1ZOf/1VfB1DM0QBUIpEHnqP9sQgHm5rQPrAz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwRiOaYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwRiOaYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3101F008A2;
	Mon, 12 Oct 2026 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846951;
	bh=LZTbMdOEYdTBKXV2EqQCDNWNiWBe+9yO9d28SK2rJBQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZwRiOaYOeSLRcoVADNZJ0qD8QB3TdkLvbUdut8WIC5Mw4IWOe63eyXcj8GFB9kkSD
	 ZtIIWgxbmjMaUw/rkhMjFcFdXOJqhIiW/8X+Dlu9iHvK1vQh7JELN1h8w4uTRaAN6h
	 n+XqpdnV1h0t89b4tDEP9W+6BkBBdyVSNi1Ge7JxQ1txYV+N6pdog7V63IIGKPFaKS
	 WYYrBul1zisCG/XOUxNt7XwlMp1IohtzCIWswzpX34GpX33oqKv6+aQVdFAdfSdMTy
	 Uy5RDk76uP94aeUkF347UqlimCOSfLGSOZElV9AZGZ5Pi/oZOt+fDyzQtt8o8sScYW
	 D3kkz7yfjTE/w==
Message-ID: <sashiko-outbox-168708@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] firmware: cs_dsp: Give the control read/write KUnit
 cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261013-kunit-param-names-v1-4-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-4-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:15:50 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The cs_dsp_ctl_rw suites run cs_dsp_ctl_write_running() and
> cs_dsp_ctl_read_volatile_running() against several sets of parameters
> by listing each function several times with KUNIT_CASE_PARAM(), which
> names the case after the function. The resulting cases all share a
> name, so they cannot be told apart in the results.
>=20
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> cs_dsp_ctl_write_running-all_pop_varying_len_gen_params.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D4

