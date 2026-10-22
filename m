Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682362;
	b=Zesi4vjHvBXn0L35D7/+Fzq5gnW9Ar2tMkgizMNTE8ec6Fw4LzoBLSN/hyUh2mVQSxXJ
	 2LGjtEsDy2swXPGUgSjxIBv/VJPaK4OkbQrae1jAvRO8yUo+R5EOH2ggT1dnpjtW+UyO5
	 yRnM96OVbEX0zZtORsymo/xlBYhOF3KzdXn0NtrjUkVbfpaOiipY84yfmdAQWFXHqy80i
	 QFkrdeNjZAbuKSQpNw88mZWB5drP+7/L1qb6JuK+3iEtmUJgNIreF25bG9EQO2We1QnnL
	 NnVlWxBv+GuATyklX/hnNKhEStsbSdVhYf8yhpwX55zhMNABMDnfV66Z5wQLVZ/wDCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682362;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+Pa8Vo3h8aCrE+Loa/rhYUOnjkisybihZOsKwDoEtJA=;
	b=HRsZQDQT6+n87AVQLVLAzsFkK0DREiNIpu3ORlwxpju7ytksQr+HI+a/7Ho+b5uIi98M
	 kgoJuA4qPGHrLeNnp+1SW9hsN86g/26FWPPiVwrUOE7uq5PVCg5g8kvqbUGBPCH7vXU+q
	 9MSYl4GyMszsndJiuSVBr64JAz58+p/r6atZma0XE+wf/z0cuIaI2Y9q4tAl+X82oE7Ot
	 RT/SryOjGT6P1I1lsOmmeyzWETGnQ5q7gMAHbClt7g9sdnh7Mh/rimLnh+fKnpdOQOUYy
	 MPKxV4KUko4VcQMpDc0RuuqeGUoFp0dkGbYhb8topPmGdu3jIf3afTsbMKYA0tlYCQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GHg00c7Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E726606CC5A
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GHg00c7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91D21F01140;
	Thu, 22 Oct 2026 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682362;
	bh=+Pa8Vo3h8aCrE+Loa/rhYUOnjkisybihZOsKwDoEtJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GHg00c7QvOkTg/lSnBa+IvN525Y2c/z+SD0ecDy3YoSqXt722CVk3PNiwhOIT3RI1
	 rhp7UWOpuJakVA+QUph90mHRAUeVy36n9vczifewv4X/hY4pQUM2vhVELZRkgX/JK9
	 1qi7OZo3wAZ5fjl2vqBktYwNCXgfmJ3fZKnhl2oJd+wRe3bCMPqhmLZwtx5V3kplNK
	 nM+JTcAfmMscuKKDh600vRPigOnHuDlLbH7LfgoMucgmVHqTpntdVbcUdl6pE3BdFw
	 NzVTJt8U+WyhDT5X2pO9G59ssdKuBo0KYZCEDHmnV1bbS4udizLsIGI82tdeBbYmeZ
	 Jetb3Q7PU+2hw==
Message-ID: <sashiko-outbox-181687@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/6] ext4: report unwritten extent conversion errors to
 fsync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022151239.2981745-1-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <20261022151239.2981745-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:19:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Buffered writeback can complete data I/O successfully but fail to convert
> unwritten extents, for example when allocating an extent path returns
> ENOMEM. ext4_end_io_end() logs the failure and returns an error, but the
> conversion worker discards that return value. As a result, fsync() can
> report success while the extents remain unwritten and direct reads return
> zeros instead of the data written.
>=20
> Record the error in the inode mapping before ext4_release_io_end() ends
> folio writeback. This lets fsync() observe the error after waiting for
> writeback.
>=20
> Fixes: b82e384c7bb9 ("ext4: optimize locking for end_io extent conversion=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145241.2950=
379-1-sunjunchao@bytedance.com?part=3D5

