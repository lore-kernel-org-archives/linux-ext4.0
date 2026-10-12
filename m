Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE7C3E317B
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846981; cv=none; b=RQPzYAh3Tdgyhzm3hBdCPWSRfHrke+5c2c3cfLFGcDYadAcEYLP4tUpYc/3YEkNEZEWPg0ZYfjDavmh6txo3pu6EJdrhLvVq3iagopSOX/TtsdGvlNYbmzgCCiAHMnVXp0lZ4AFiTfoET5jpmKnxEsfYcPtnbt2w3lofwmr8Kds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846981; c=relaxed/simple;
	bh=IW1k7NCpCI1G3oMxktekck8tjM33+162XXaevMZ2lSA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XztLxDU58Rxq1uB8gDLsI8XJjIV9jATG/DcQkrD//kiVScESXGSRIBWw+732TqJz4LleVf+0zRuGeBYlqPZRvztZihRlTbmyzBVA0djlzLpsVRNUgC1xgZXXg+MYk+5WGD6CFPvujcQMQVXFJt8NqNc94fADZIXTsgV4W+thxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBAXkGa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBAXkGa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68361F008A1;
	Mon, 12 Oct 2026 23:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846976;
	bh=IW1k7NCpCI1G3oMxktekck8tjM33+162XXaevMZ2lSA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cBAXkGa7S5KpsGL0osCJ84bYafXjjlm8OhDx2JXkF4el586gfT2gzly6W2ozpu5k2
	 HQmpF094MNWf2bUacD0IYL42OXxBVXpwB/dr85PSdbbgm49a8F1isehehPPZKzYM0W
	 aMricDRLLDWkKgMHDsyxsOm3wLldZeN+UEK4SN5mbCWo1T70ofqQ0I8CN1NUVsQXLX
	 DmAhX0ZSyqUKyjaKVdGS1CmqUagKxKof4apNmzTEFpUiSJuEPAtjcQcW0e/rF360qj
	 WSoYoSpQV+SePZRxlOaTdwmgJv7ogNaK8/P6qJi8vaNRIL+0WBfHkOptDzCXC8yWVM
	 SYcF6DFAQgg0A==
Message-ID: <sashiko-outbox-168709@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] ASoC: wm_adsp: Give the firmware search order KUnit
 cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261013-kunit-param-names-v1-9-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-9-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:16:16 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The wm-adsp-fw-find suite runs wm_adsp_fw_find_test_search_order()
> against six different sets of parameters by listing it six times with
> KUNIT_CASE_PARAM(), which names each case after the function. All six
> cases are therefore called wm_adsp_fw_find_test_search_order, which
> makes the results ambiguous.
>=20
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> wm_adsp_fw_find_test_search_order-wm_adsp_fw_find_full_search_gen_params.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D9

