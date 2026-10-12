Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FC43E120C
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846911; cv=none; b=P4jqxROKyHq2Rb9jls/kqjl0YOpb89KpL9EvNhKR8J6TW9eOJ8nEctPLG8zo9fmI7zDvj2a+8dQE6iwkCb5RUJvUKPPCpKH253kxqv3lZDyNl+LBlEsKJfT/NpsB6lr23SihdY5Vybva5GTlnRKqdTWIlCQBpyRjNMCgZzfeRjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846911; c=relaxed/simple;
	bh=wpxuD374TXidR0jRk349TE12kpHpU88kjj8SyVXSrlE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UnsjKVGmDYyysNuNxPj4CrVymESJ0bCNpktBUZ5H+h7nTjgTeZyBn2dAUGgn/ykEXKStmW9dcEC2NRMMuxAcdAw88Sm8EWnAIpnROdvUXaOSwVL13KMjf4Ma1xQYcQtzdscKCeIsFSf8KHtPZT4bGXkKQupmKZBdRuzCK1FEZ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Djn+JkkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Djn+JkkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C2D1F008A2;
	Mon, 12 Oct 2026 23:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846909;
	bh=wpxuD374TXidR0jRk349TE12kpHpU88kjj8SyVXSrlE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Djn+JkkM9i8spS2gD1v8wdrI2zHDy6IDeG0MIpvgXi9thqOrFbFW6LzWW938Uf1ZU
	 0luPBL4iu6OQODyXfHUiOu0I0pi62q0JTsY6lvLRTa1W5+kv5T7PtwZJVnucbUUHQQ
	 tmCQ4rs1NLme7Yk5wDAV9dpOP9KSrUQ/LFUcMAPYdW5isyb0J0Gu/2lrvCQXuokzOs
	 yKeiajBG4olXTnbuk0QlFgoXpfLBkRO4YUM+1awZt2D+Ktv77CwQlcZpEhdpykuSTv
	 VZhh8dA9g59QAlLbKLgcYuTui06DCM0F17HjtkUos+WXKuf02+BKe/MgYRQcOhqP8y
	 zU2tXJOLuudVA==
Message-ID: <sashiko-outbox-168704@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/9] ASoC: cs35l56: Give the speaker ID pad config KUnit
 cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013-kunit-param-names-v1-8-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-8-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:15:09 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The cs35l56 shared test suites run
> cs35l56_shared_test_onchip_speaker_id_pad_config() both with and
> without pulls configured on the speaker ID pins by listing it twice
> with KUNIT_CASE_PARAM(), which names the case after the function. Both
> cases share a name, so they cannot be told apart in the results.
>=20
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, giving
> cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onch=
ip_spkid_gen_params
> and
> cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onch=
ip_spkid_pull_gen_params.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D8

