Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942876;
	b=QAsXCmPz0iMLVoJR3RIxokYxfH1zf9PnqKiQJku+bzrXdGQzhN6w2gMO6tk1/7inp3Ev
	 K6nT2XHW3rD/bmZ4myGzWR/VfLpFZc4jYH7sXPYVPukMQMUw3yoF3mrXY1KhamGkZmw9e
	 iEqWj4jyXUaYKEt6vmTtqDS9tHgB2NUQ71sZ2iXAF0o1tf/gGJtwzrWIknZoRCfVDUdem
	 PuRvdB0gNlxG78NkNjL73djVFS65xSkiMXTlxs+xx25RW3Bx443lQmaDANTbhvgXTDJDa
	 9/QT1IuNajgMv4AsFh1G1L7fbJhYtw0YyYu9z3ERwUXlRUo27OHEGA+1nwvz8az0i4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942876;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Bi0jhVjjDH+vAFlHDyGAmDUpo0QbtYhCHX4yXC41yAk=;
	b=Nhx5chuFui4HCJnM1CpqsIPBczfAuNmAa5uBDRcWhXVG0OZEUhezYU7ZokFH0ZvcY0aY
	 mjuDfbSv3eysCiHuGHMy84o3AsV/WEIu+bCfK0F+DSGTkoieybZfxKGi/rjccvd7TgyOs
	 u6ulPj6Jfu9go6i/DuXw0kc5gum8H9QSdO4c855YzFZbOZhvQLgE2KMSVFd/EOtRj2usz
	 PWQ0H6Z5VHH2nCa9gvtBPzwXuYIM237O/euz2BmKxVdqSbq3VK8LMHkk9qpr1DhVD+DKo
	 qvUAFURZUa/KS4sY3gI4k8K24DGgtDFRq613z77I5NZsDe9OyKwqNnm9XqkoU+LulaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=btOi5fpN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2573606A31B
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 05:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=btOi5fpN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0D71F0089F;
	Fri,  6 Nov 2026 05:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793942876;
	bh=Bi0jhVjjDH+vAFlHDyGAmDUpo0QbtYhCHX4yXC41yAk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=btOi5fpNcJdMmOIfkUQ1J9n42z/sFKWFCergQtAwxJR01xBJ7OmOwTY90dR0fKfAX
	 1XhKqRI035KSNkyJCVXBfk+s/GwPudXRNI2DMmEtdwxVn0mea1deUuxgAvR2+6XwV1
	 Vchp/OuK3tmkljLZv+zQOF+5tJJLVCvp0qtJzRDaOGr/oewOo3z96q9Bflq603en/b
	 K+FBx1Swp6acnCgoODHS35JVHI58TTJlSzSpUWKOrFA0wOASfpL4Fxayj3JfW2QUtw
	 ENmygoix4Mg4Jk1eCnoLIGmJATa6xlOILaAkmS/kek3SusNaauWMxfqoeWwSEw1dMK
	 30ocvorTbx6Ig==
Message-ID: <sashiko-outbox-200812@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/9] firmware: cs_dsp: Run the wmfw payload error
 tests with invalid block types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kunit-param-names-v2-1-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-1-765b3d5275d2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 05:27:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Each of the wmfw error suites lists the truncated block header, truncated
> block payload and garbage payload length tests twice, once with valid
> block types and once with invalid block types. For the payload and
> garbage length tests the second entry names wmfw_too_short_for_block_head=
er
> rather than the test on the preceding line, so the block header test is
> run four times with invalid block types while the other two are only ever
> run with valid ones.
>=20
> Point the second entries at the intended tests so that
> wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
> are also run with invalid block types, as the header test already is.
>=20
> Fixes: feb5fb0615f3 ("firmware: cs_dsp: Add KUnit testing of wmfw error c=
ases")
> Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kunit-para=
m-names-v2-0-765b3d5275d2@kernel.org?part=3D1

