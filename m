Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138564;
	b=Q8J3mIeql11VSwCX3rPrEf2rb0P6OqEq3xz4ToUf+2TsAaoVk6C0jbpNW8JeYo4O310Y
	 GTeIh9sq43kitQJpoH92ejbuURpvnCV1zicdwGZOzzUeaQlf5RcyMiCVpUn7MX3zuQvIo
	 F1QxU3rVRdOLJnK13dPWAhhSF09+MCiMqc9ngUI7Yaf2QsKR9Q7XYlAs5Z1k3iGB38Smp
	 Xiq3f58wxFrMcFPlnto+rI4ImVd9yOsqFz52Oe2OSJif8xxsiUEhJtwmYEX+QF0RJidbp
	 c5IxIEaK2qNk25XEILLYCiUTyjR5Q4Yo+I1sNMOGNUUmdoGFfMQVjnmr+ZAJmZRlbPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138564;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JDn/1xZ1AyKaD1sIdhjxT/eCjhnwzz2pctodffVy1Iw=;
	b=uZub4BGwZc8L2DYCmuDWWndiwbwqU6tn91gbNB2bHrtRMF6aGiYaGIb8IK80lvFeU6rz
	 zrcHIaV++IdBH0WjOI7zCUQmEMJkBZ7rXd72avt/kmKMV434moMx1gIjyYsem7ANmfWFG
	 92Xz1CJzN27p/G3EYLHI8QDiN9PMGZHmAA5E9OvtSk5fj00/pTk1WRP3Nl8wR8Noa7B5d
	 r3uFhD9i4gKwWKvSRbxBGvFDmfvjAdgLL8J8qGjgwrIbEd6mm7R1xaW5iJ72BBsEuDke6
	 ooLx4RHXjK1cqb6d1J2l1UTUsmRj7X5I7e+z3eLIb9ezCiB8FtuvmslLFoVDtllInnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OkTMsirG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F9E606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 22:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OkTMsirG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD811F01825;
	Tue, 27 Oct 2026 22:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793138563;
	bh=JDn/1xZ1AyKaD1sIdhjxT/eCjhnwzz2pctodffVy1Iw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OkTMsirGOuHp+2CmMhxmL2TUS45aqNNiIGDuHXJ+tZKPS4ec7LnpfptUc4G2dYDdU
	 WJ1o/zoVrUSx2iJExDdLV7p17QacENqJfgAX4vxoDxo+s42MC2BXPaNBU/xJwf/nnF
	 JWm5eCE3XQUlQTmGUupR111bfFiiwWGm+1D2B9YC3BebGX7CumJpp9UXB7L7RBp6Ut
	 DB7u/ps8ZV5+RcKLPxTPCEyi/liJcpLYDGG2ydqBR3AmEGYd9i/mcEgDr7gY71Lufh
	 QYrLBmhqLQbtDQd/W4jQWHN1O4x7ErmTYjKZA2CNmvHxMPM+xf81bbbGTDCAa3Xw61
	 nczUfmnHrx7Fw==
Message-ID: <sashiko-outbox-187139@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] fuse: convert ext_map iomap ops to ->iomap_next()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027215326.2693300-3-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
 <20261027215326.2693300-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 22:02:42 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Convert the fuse ext_map iomap_ops to the new ->iomap_next() callback.
> The callback is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which
> wraps the iomap_iter_next() helper to finish the previous mapping if
> needed and produce the next one. No functional changes are intended.
>=20
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027215326.2693=
300-1-joannelkoong@gmail.com?part=3D2

