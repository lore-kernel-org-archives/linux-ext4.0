Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FBC32E6BC
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791847162; cv=none; b=rMIm3VIknTJbcItYelD4rUxiBOrDckkqRVUdmNo3mg/g9KOW9ROEam0jWcaiO/63YecoD00IhSjtm+EoxbJ8mf2F7CcuT+VYPlxGlPrbNx31szK/lC+MzfAyrNy9IIumE3flwD+YYZwnWp6NogRtqjFKkMrfJKbaDPWFbthD5fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791847162; c=relaxed/simple;
	bh=cGXTC7mFf5sKYJXH13SQJIKF66xisRZ8T9AaFtH5GDQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KQrOLJmEM8No1kFFZuuj1oTG+eiRumBboH0+6wcPFzig0VTwwdQjPmDqlE2WPJiZuYZFmspzdSaDgvKLwd/vwX5nURhrEDaYZKuUJdTmD+J14zFznTU+b7FVN14t85tTzSy0uvKVm8n/A6x5lD8/XLRc1tJz/cQ+VE1wsQik7oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpGu1sWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpGu1sWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67351F0089B;
	Mon, 12 Oct 2026 23:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791847161;
	bh=cGXTC7mFf5sKYJXH13SQJIKF66xisRZ8T9AaFtH5GDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YpGu1sWQuGe2gHBCsA5CBPZnJYK0fLlsMTEnrYfZnQNwNNzyi+94jt/3Ziy9RW8iO
	 WkMHgOH8HOpkvwIw/sSDAcBCA4a4lHmzYhpGAKUVOlTEFNFB4qq8JfRoHL7IhAbRyA
	 Oy1ZN24nHENxPd4jpVwToMOp7TYBvFeMca4NWnhB+WahcPs38xuPqA/Jr3wBoglNcS
	 5s9HqQjjmNB5q5iS0oXFJwVxYjdgcd+gtA102XxRByXG/I25Z2pKyU6OKcMf7TdctW
	 V6Qg91HfC+AWH8RVWFKJc+7MrmuLB3bc9hBwV5VW9s5dpfbaVih2ljg7sierMoBkUo
	 kfCOVNMJsetFA==
Message-ID: <sashiko-outbox-168713@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] firmware: cs_dsp: Give the wmfw block error KUnit
 cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013-kunit-param-names-v1-6-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-6-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:19:20 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

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
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D6

