Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5446F3EB10C
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846982; cv=none; b=Z6LNxuwPsDQrkFKqP51OBhe8YCaD7AegCzTu8xIzDr1CBwZFVcSbcOWFUsp3iU3xQsZzB/44g/YOqNJ9QsrVbTGK9QJnrO0oO6+lH6e/pXn+ZJrypWMqanXiYyogyyNfgu1g6uN9tohrzFevxyaIeVgg3ZnGUHjmkjJ/vFk5cyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846982; c=relaxed/simple;
	bh=UcwBHXGnA9HqpcRZ6wZst9J+p2iruYLogcNVS3KHpEI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fIOT/13iUYm/9H6OLqsOf6hf8FG3OAkpEAd74rkPaMr4i81HgyKj/KjJnL+UdlRDmlNQNYszHYjPDZ7olwR+z6DgXNVYnxaXE9WpIhEbLn992s2+8B1hi17ViwIuIB4cH2MBzEGqCdgUfxQ21ZiE0UdKJb76bO6iMXKyr75cL/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1/TLytV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1/TLytV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC561F008A2;
	Mon, 12 Oct 2026 23:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846977;
	bh=UcwBHXGnA9HqpcRZ6wZst9J+p2iruYLogcNVS3KHpEI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=o1/TLytV3nqO9HaAZiQTCfK16ejMRw2FVR/bnZkhrxyYINQHW+050KBylATSMCKrN
	 TqN5rQrzpdWr0bZi5qGQre+e/gS+7COkznDGbiKV+2cHT2Ww5kGTmMOBDCkxr7zVrI
	 3s5lYllxtgFO6lbj0u0NWruLWBEnZfcAFE2vzxx5+Hphi4Sg7+s4DAxknQ1Wqn5f7R
	 aMfkkHff7xnkl06SRWS3lWae/Zq5CsC2RpaEK0SJRW5juzHV2P6cVN4HnuPqUAwUyk
	 4xCfVknR24+f7Ptujshc9FOc+gjbA2LPEe3hHDxKtqF5JzdU4CcQTjqnxWircCQMAP
	 63H7J+Hx27ZwA==
Message-ID: <sashiko-outbox-168710@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] ext4: Give the extents KUnit cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013-kunit-param-names-v1-3-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-3-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:16:17 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D3

