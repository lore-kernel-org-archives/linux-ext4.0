Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793943763;
	b=WxjhXy7hXYfhAZdYQRkjVRFMA8QJmXC7Yk5KloedZCHtw3AZqLJrArKzRUTOm7H6517A
	 /YXTUycH6/RwooW+8Egifkvm3dxQgDmeYfLmshOjfYnEPs0eal0+wTKEjsqVhHUc05W51
	 h0ZucXeB8MI0s7NTR1sBUbNriMA5cC+p2+ipj6++wPmEL2E13SS8Zgw6jKmMOsQutNy0S
	 s0vT3PE7FuR7MvL6xFZRofJBPeeSL6INrp+xhVSIxlA97+x0p4m0yfc39viLGewcZu5Ex
	 crVX3tCcAuV5szZcthj+xwKZKhsPW8PWo0YnfPHoEhPxFeyQvczL2cQfpbgyN7Gbg9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793943763;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eOdARrRNWczBbM4NpcYPooPrhZ5rIQACfIOwqlmtCkw=;
	b=cLkO8Lr+ZEpvayr25s2FOpOgL/5Q5sL83vTBtoPL9wIrzjGP6fTn/n++at/OSJ9RqHXn
	 BygnEm9fnnCv2MV1gh2EwjSQ4E5EmcpT2grU8hEE5UHu+Yeq7vqeIlDijAZqeCGirwdBp
	 OYKNx7I3A6v7tewch+LvAhN95xgBWsNxdKPKnhHmqdwjQDO2XMYW/DiQQChGiX9m6nyOV
	 mufWi6dXbk7yS2C0TYfEscVow5/jFb5hch8tFekujAaXV4G+1KwI4NsdxnHr1BBel2498
	 5rqwxbiTIXvudBecv7o/C6HSh5zmXXPReuL0+tCSxIw+w8N9nGnVGeZLdHCe0utpm/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTFOIu3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97438606D80A
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTFOIu3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137381F0089F;
	Fri,  6 Nov 2026 05:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793943763;
	bh=eOdARrRNWczBbM4NpcYPooPrhZ5rIQACfIOwqlmtCkw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NTFOIu3u55s6OW/p2bmg6GWMbgVYqgQZt9O2xcKbY2qMXWe2CayAjoHanB3u9Selt
	 7Vtl7ob7hIWizooZfIkuXGErfDm767H7VIH9gqtG8V06ci+l2mV9+kH+pgAbRbaqfj
	 Jn3DgDkZUEajEJIpO0B75qCtHczBNKbTJG3A1N91OXXypQqWBZFRTjPxF6dpigNEBc
	 788cjuA/FSxnS9aDXcU/I/vOhCuLjcuULfgI8dUgN5lgdNbbeKfZ9pAAvESR5UTotw
	 Hvx89/ViSbNnOretslfykN2Cdkn6LZcsTYomGrP7mlJhnkiqZey+qSRc2ygsvSVJqq
	 d5rYEkuyAJECw==
Message-ID: <sashiko-outbox-200847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 9/9] ASoC: wm_adsp: Give the firmware search order
 KUnit cases distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-9-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-9-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:42:42 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

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
> Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D9

