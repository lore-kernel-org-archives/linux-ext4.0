Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138655;
	b=a9SKs0mfqXfUEUiyo8njKSqhI12aSPYDTFbgvLxEA50wRTVBra7Rh5nTB1U0dzVntDdJ
	 Z/1HxKsF0wSYb5bXGTmDeY+EPpiYEwcjd78qkP/8k4EWzJahHw1RhFJ9FnuvDAXmu1smY
	 AhdRcp61Qp3TNNLYBrJr/aZAmxRAu2DFj+S1FUDF1TsYS+SeRmA6hAo+MbC9BbGD5URGy
	 VNchXLopg46MbHBo7rotz2/kozZS/v1BDjX00ta7dEcDVMyaTvhYWagYOgiWeNfthh/E4
	 ODK+5FTBql3gzktgZ75lpvJOlEWcvzU1DBXObPtX+HVJT8lohLg7LQ2i9aX1bulEmEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138655;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i5KYtKKhX5i/bzbO0gotleSgSGQAYMBH7XSeubAfSGE=;
	b=pld7nhhETTyLCx+dgtltrFNCLiufJ1x2H+DpnopBKkAVbdcjux+zghImcUk+3KAHGM3z
	 SeRK1NNPsk+t/rU/yAiJWAm9/mloByx5JlKOvFph2DKTDG75+grZJv1Bi5324iXCMwroc
	 F9RICU32arWCGEtO1eUwcVHFPo7WGj956qbPwyf69KFmRCkmK4q2lJAqxOYMKASU/P8nG
	 NzQSIV1I/+wO4DjKES5rkgXGSpTmUCYMYuNlA0s/fQwvvpPaEhI1dxLaGMKIKPJ/KjfoU
	 7Cn6qucFrxucJvs/LSCbg4D+Mj6ESE/b7wX9mh2jDvafcsqO2tIvd1pdpfo+w/6ocrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtovqhZH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC85606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 22:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtovqhZH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2EF1F01825;
	Tue, 27 Oct 2026 22:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793138654;
	bh=i5KYtKKhX5i/bzbO0gotleSgSGQAYMBH7XSeubAfSGE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gtovqhZHP4WZRmWgY1XeKLDmC9n4okFiAPmpoOv7iTxaC3aEd2ymTYaxc+O0wEFbU
	 j7eA0lGQgz83C5Ddv820w4KRi9dKiwTg6hJIKhWXJTVLRwP/tvaqotClOMrqeOBtbz
	 QoNI/AOqfijnq+2aJ+w+HrqpbllrZaYQGAKTeD6rABhRzWqR87ueT4LNd+sU6lc5XK
	 ij1aMptPb/TJ2bNxTH+dRMAO32jS2rixe2T4xWEHxkcjvNjIcr3zqeKnhhlEuhuHzR
	 cjR5iYU2Pcej+yPL6fn7lCfUw4OSBQoLe0pxPfiV+/kzN3U5SW1k4APMWvuq0RKvfe
	 ze+PsIDZo6gJg==
Message-ID: <sashiko-outbox-187141@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] iomap: remove ->iomap_begin()/->iomap_end() legacy
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027215326.2693300-4-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
 <20261027215326.2693300-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 22:04:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With all in-tree filesystems implementing ->iomap_next(), drop the
> ->iomap_begin()/->iomap_end() path.
>=20
> Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027215326.2693=
300-1-joannelkoong@gmail.com?part=3D3

