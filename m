Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943689;
	b=iV36tRzwlv+t3K/qypgGApg6T05OBp9Dp6OqMuEYLTyKrVtTj4IULyxiuZPprCkPWM0P
	 63jT7ilUSLmlHSOEsligvIQPLrxRPCCCqBd0syzTovLF6ZEuaD764fii6ICgATXa+zwQc
	 U6KIX4uTWiHBqrc+PBI0kZSB3Hec7ShPVHsd5IwrRyIYLQfUwjOTfx8jhmpCHZDCssv4o
	 qN9b2kB151464FSQ0HZF8sLT8/cJYB2gy1e2KA5P1ndpRkjfGjFk9+W86Uh39dBqL7mzr
	 jfIENIOwBWJdN9QF5SGrIaw43goj8xpJJSaM4EIzPI8BUfi8sXFq8yj10hgXCjoTWMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943689;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=abYkBipqSFPm++Z+2ry8cIXwVcMevP2cpkjKXdXbGm4=;
	b=TSBJLNgQ1tdSa+54jyFo8kEOOaUd/+/VotGkGvjEMfRQ6NuvKSrSWl3P5RXgqmARI233
	 G+N0TUkut+4qdBoU3PptYJTTIKGUT/NrTsFYxFl7oJalMtnqq3Q+0HBHd/5MYT/2y7VLf
	 uIvLFSwKuxMP4GNymZMoH2Df5seYbRP+hi7dzvS1aMRmaMQr5m9vNhisWDIKe8lxYADkB
	 K8OjVJSRlsBGVwbK0MlNRSONW4vz5H5x6zrlz/Lry6fBbQSaUUpGnz1cJ2Pcbkka15fKf
	 pKOCp+bOvG/NGeaCSjUccqHsaqAYbqi2jLJqsPEWzoUqycdkw6dH7Y8b/N7/hKOTSpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnRoIk7F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B0C606A331
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnRoIk7F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B91E1F0089F;
	Fri,  6 Nov 2026 05:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943689;
	bh=abYkBipqSFPm++Z+2ry8cIXwVcMevP2cpkjKXdXbGm4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BnRoIk7FCfiDsFp+Jug9PIJwBtwb+uZopECNUg1EGMYnfmALWTNDdle5pTExB0cZB
	 plV7nLr0VsBELHuGGzpfUjCHB2XO+rrcYH1LqeCUhMdFSuRT76A/soi1XvBYOa9NoR
	 pfC0XNkgGY1z9iFLuM91+CfK5Wg+OHewuAcfdiueBh1YHd/W/CNagHWlYNrjeuQVr5
	 /Tmj+UUAEXLKiJ/JkdXZXKBZufAHCFa0pXwnlcdFlShbAN1agJXu6obAHmrl7HAf/b
	 SAlkKB4iUB3S2rE9En/m+9Cy+Wn9UDWyh00Tq62No2YUBVtBfTezzBSIyJCq4Y0zFR
	 ZJrUhC520SY6A==
Message-ID: <sashiko-outbox-200845@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 8/9] ASoC: cs35l56: Give the speaker ID pad config
 KUnit cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-8-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-8-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:41:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

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
> Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D8

