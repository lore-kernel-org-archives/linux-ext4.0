Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63143E2769
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846916; cv=none; b=LCzYvPGFdjPd4749KgVJPYvSC7OaMphyCY3HkzMVBur6hZBrp/Y79ih78jFYPdhVsAfGfM4kHjQQwhB9s7MpOnb2hGz4zApua/P73DL5WJ3rHGSITF6JPqVpmSbMG+xAJvYQvBpFS7noGEwqPhM4e3VGwRH0Q69XBlWCX/+mi/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846916; c=relaxed/simple;
	bh=P7zULdPFDrcB0xs/a52ncq8xjfeq8KxSom+CifIEKeI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YzoB+XvXTvvWgKm+1GWDHq3jCSyEc/RzwCP564o7l8hkDDTDVMp4mMmCqpU8FaAtQ9Sxfacq4f3wHRqJvSB2JeK5XkohFsZr2NDu8tZda/a9Qt9/3f0a2texD0450LT3nZatFYUaV5MtYmWaVbXgMfZ4fIBNQjmCxL79n0RtfRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JaT6bdz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JaT6bdz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7071B1F008A1;
	Mon, 12 Oct 2026 23:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846915;
	bh=P7zULdPFDrcB0xs/a52ncq8xjfeq8KxSom+CifIEKeI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JaT6bdz3uS9wKEg3uZc/h+0Rg9jcCnJ74fzpJdg14DOOZ0yDKhjeM+S/SS8YMlj/3
	 jYXM1uXqo5Ia2oZOC/XTQ7hbBv0nRfUAfk6NcmDp3WXvITz4yCHVBAQrkhydhBkq8a
	 kTrDP/JZ12K2ylYGIq6uxsY61qcRk5LDYrtsjna0pMVpDIo1v7bxVDOI0DfIdJHjN6
	 w/czW/Wll5h6MTUahDllJD1gfdBneTjfnd+CGOmFOIg2LDUPyoLJinHce5SSgV01Bn
	 6Bktu4JPEFV2A6k0cX0CrBVsVDogQveUwZzBCWbJIBynTC6ktH2c2CzIwec8rmLhqU
	 sw2QUWf9FhGQA==
Message-ID: <sashiko-outbox-168705@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] firmware: cs_dsp: Give the control cache KUnit
 cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261013-kunit-param-names-v1-5-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-5-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:15:15 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The cs_dsp_ctl_cache suites run cs_dsp_ctl_cache_init(),
> cs_dsp_ctl_cache_writethrough() and
> cs_dsp_ctl_cache_writethrough_unchanged() against several sets of
> parameters by listing each function several times with
> KUNIT_CASE_PARAM(), which names the case after the function. The
> resulting cases all share a name, so they cannot be told apart in the
> results.
>=20
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> cs_dsp_ctl_cache_init-all_pop_varying_len_gen_params.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D5

