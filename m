Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943240;
	b=Zzncmwx8QIq2/hIkHdagZoI40GsHyqNX+iY5ZP6Ihy2v2mUny2bD9sTaeLgzwG+DsRZ8
	 cb04aSFaSrLPL6wxGuj3E2T1V+6h9V9dGhYGY7u743UXdz5lrJvwCwLjAri4m3WrEUEo5
	 9W3+JwzCoeSwhIwA79Z2QbaeK3vZDr4vKElfJZ2YjgyjjOg+ETuj7S1csgEA2+hWn+YjI
	 vuSVX9LCx/yCZQNcMEHSmfmkuJxLKMCLXKz/vN3+WTPbFgd7h1KG/EEl1YgGw+aMQT57h
	 3SkuPXyeo4/Yula8mGXzDc/CyUDWvYocB6Udaad1q9dR01Q0QCWleizDgpBCvGEuTgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943240;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jzPK9bdbm6FlV48KF2VGpBfLTjD/grtu+CW2pmsPE84=;
	b=Ao4OHXR4B8sAd04y1bwTZkVOcMV3xncjRJJ+gYSsJgzo5v+iZJ/gy/uQIom+7rMQZTyO
	 qyI+vEHrkvYgcdIgo9Mg6fw+pOltaXW/agYl9lQWLbZiJGjnOVJBQgboAUMEcG6cP2H8Z
	 wPguaDXHH52ust5zzhr0ROX5cgEjbsccqWrRjY017F+Prmq6VoeE+QbDOFJpB/+L/hFWT
	 yAgkbznVa7L9yYj0sl7O6VA3thytXlns9tifCwXtv0+rLpX3++ioRvRPrVS5u6dfNprP4
	 9v7YZSaxjw8rRreAw9Ey/U1rubBaNjwrafd5b6b4p27gkT8RPtMSXz2NlTqQN/LZ+aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHN4SRrp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C1606A328
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHN4SRrp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC7E1F008A1;
	Fri,  6 Nov 2026 05:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943240;
	bh=jzPK9bdbm6FlV48KF2VGpBfLTjD/grtu+CW2pmsPE84=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jHN4SRrpQxjhhKAzn2kQ/HFRroM0+LupFJScZ/fFnIjB416Nbf9Fd4jPg0gutyEay
	 de9tFhafMyMtxv22P/KtcJ9FiBDXPnByjDZR1YtTAMFAn4gu5CoruI4mpZreSjjskV
	 hAMhw260Y33ec9fZfzN/vtWihlLS4KmMHntSK6ACEXVvx6Tl86Xq2GsPnaI4Ss+ZS3
	 kKaFGu6B+qZPhBVEJqhpPlsNjH+9CnWrUyRFtx9HB0Ac3eh42nunCawLX0t8xVDyeS
	 GlXipeG0XhLzwhcYCKccplIKSHchpYZl2B1rxC08dd7CyyTNfIjl3PaW9p0JHektMy
	 0HjuqD3uMe/nQ==
Message-ID: <sashiko-outbox-200829@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/9] firmware: cs_dsp: Give the control read/write
 KUnit cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-4-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-4-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:33:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

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
> Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D4

