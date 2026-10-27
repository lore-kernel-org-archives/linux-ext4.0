Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138589;
	b=uah9I3dEXdAOiG/yE2NbNarCsi0Ld4absOVjk7Pmpx+91HW4qhWRaBxGVd3PlGq8sjP2
	 D8BDzNZFEG7TVb8TxwR/kYKUYGi5jSEydmR5G+RcGTc4d1R5/IVdVEbdAf4ECOkioDT3p
	 XuXKKiQqLM4oZNTIJKdygZm58tw2j1X/+LfnsIEIVbRtYZRX9/1VD4tbdGidHT2PXvrZO
	 Kv4Zhcl7Ka2EV7cjBk0p2v3xVJNM1o7UZwVcbXk4vi9t6/BgXRggAjyDe6kCHP7X56eYJ
	 bAm6CobI7o/BQajSyMc5RSd2MwF81a8nxLkZ8rAhxlVsS2vWASeqeRgtoxZaBl/jWCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138589;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a1koljsuyeIYC5QZUY5DeyJtcGmG0Lys9kALTveSDaY=;
	b=BsomtMJDUKpszV3sSEyRqRoNIeOkIBd5zwrrw+ZDZU0/B2te9otFC6EabumaxIIZacfW
	 Ex2QiGwao+/xYv1g8uqzifjg8TD6wxcHX2fyhUMB9vNL5eO6mihN+eImTWfZfMj5K8tCy
	 O7WkjZGMZ9Kltgp+Vdn93i4Z9JXEdDpVXHpvAWzGYLPPjcPd6e9F8ivm4nX8m59AANd1T
	 uYKUHDjDRDh5f2+Qp+AuomfIAqBv2Snqc09tSVsk6BjkedRDbpaMj3/TvZ0OAmo8/IJ0L
	 pap7BsIXuyAuj0TB2LiW9sGc5xcYENu2pZfwFG9GqJGnS5HrAm6hIeYdx96YkzHcJUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDHHVDMm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811C3606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 22:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDHHVDMm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53061F01828;
	Tue, 27 Oct 2026 22:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793138589;
	bh=a1koljsuyeIYC5QZUY5DeyJtcGmG0Lys9kALTveSDaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YDHHVDMmDnlKLylHn9i3z/k6aO9sYoxwKdb1CCFl6gzHqFgfm++RNViWczqjfcQeY
	 M4QT/XAKAH1L0vHgQzMBPX4pqSii6X25u1esMv2oO7+Mf0m3JcUiNust/xOh1UDJpW
	 pUYpwI1/WgSlICBs02HzRbxzEQsSK1p7QcpXFquTJold8Bmp6QQorUo/i/udi+PVfm
	 8Mk13PEXbYlneWI9QZUmXNRtpJnBu/ak0RWr7P7EjYux4sPAtbVsJgHxtT6M/ZMo39
	 MTg4woGoJWWYquTRjXDIQgX41ZBHlhO327vpXzEKktfg71D6t47o7F+TWKPMTYkJ3f
	 oFMQ69DFsAQgw==
Message-ID: <sashiko-outbox-187140@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] nilfs2: convert iomap ops to ->iomap_next()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027215326.2693300-2-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
 <20261027215326.2693300-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 22:03:08 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Convert nilfs2 iomap_ops to the new ->iomap_next() callback. The callback
> is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
> iomap_iter_next() helper to finish the previous mapping if needed and
> produce the next one. No functional changes are intended.
>=20
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027215326.2693=
300-1-joannelkoong@gmail.com?part=3D1

