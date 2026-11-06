Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943445;
	b=IY2ylKyq8PJ+p1qRcSchGmjuYpl+jUUuxdeNwR4uqfmwVHCNlWUlXURPRPlNGSWVeRN7
	 coD+UF8UT5QZiA1KQk6dvKcek+0PtyXXQ5QBTJVXTr9+l3iRwvCdkLFP20ABgiZ65eP10
	 lljonnQmKRAFFgsVV2f0BFYC94mN6fivdG6u3jFLzOnIeO1+26C5wjsLG3aVVHq2Hz7Ce
	 Vd2ppSolNAjce8QQMNETg1L4y9cRKyS0/PNs1KlK6EZgrdT8baLBrF34uBEQIa+kh7wPQ
	 BkFsNtcKM89AvKq2nIYqSzwEfdT/a3qG7Zg8J4W0QopTiSfHNRuISVJiN5AsXAMMO7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943445;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=j7vK60dtPZqX5bSywwBihlKDJYuLchAJpD1Qb3L3/Sw=;
	b=YsSJZ+X8NDkqv48dAfAaIGJDh+tvaXlV8BtrnrKR8WYjxqZx2mMVgFHd5g0mEZAUFAXT
	 UVQ/uvc6c4lTWPxHD6DOt0TlVeWpQYQpaA9BzEb6JXXW86nyi6xgjSEbu7HNodaygqjw+
	 eCFdCvi9E9kkQTvzHvCFr9+I6qu1XeySk7jgiJrWOD5MVDrI4noiozlbAQd3Ua/0Y+Wl0
	 BLHIJTAEztrHD28ZsZbYmGEGFXersyaQH9r+W1UNzHn8AH/JVPqeOt8mBaQR286LC2UEv
	 mQbbCJqev1lfDuHo2Z2IHLSceuNtdHHx0C80uUQOAe9EyjsAxc30peholuckbva35mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MwzMsmsv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1478606A326
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MwzMsmsv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674A91F0089F;
	Fri,  6 Nov 2026 05:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943444;
	bh=j7vK60dtPZqX5bSywwBihlKDJYuLchAJpD1Qb3L3/Sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MwzMsmsvLQ5F+OzZnaVAgBQdjb/iCnUyiYlhRiU1dHeLgp11rVIj98E5//AkVWozV
	 Plaf6SHJ8lIFWSu+AjzTY2bubsw+DNiMAO8gUXHcSBKCu8iWCtAbADgTnGeun8jpdl
	 JO/Cn0aLJSBYsbkuk4u/jHcOdAK+joY467FLpU4lGk4C3hhCBuuoKZ8gUIK7Htu0vV
	 O4ZZD1/b1pyiE9PZjFqLljDw+cC05cHxB1xkAvM7AQkIFP5zxgYj6iPLkiBAEMdJRm
	 6SrJbQ3zGRqf/P4/M60tWGDGVNOIt6FVSklKid2wbhJxGqBN6J16FvWfEuLpMbt3Cw
	 UMorXvGpk3RKQ==
Message-ID: <sashiko-outbox-200837@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/9] firmware: cs_dsp: Give the control cache KUnit
 cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-5-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-5-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:37:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

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
> Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D5

