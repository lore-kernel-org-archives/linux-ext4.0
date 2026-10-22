Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639069;
	b=qHW9u1oaKjmc0+Dc5FWrpPtDJBWgbxKBVxzXlT1u5BZUsSH80eUvlfwVAoz+PIwy1wIr
	 lCFLBgPAjgyU3zwcajSQwHNFmnhhff/q5E1rI/9TVpMHhIiskSIMjYq3oSZdU3ngVnNqC
	 cUStU0lKcQlXayo3z9d5zaEIvt1yjlfXJ8HLlW6HbIPFJOW7vpkEb0T5ktm9kide6jPKS
	 fMdhW+ykKbsU2onjlROWVCFnRSC7GSUqEDL7V5u6AjsZ27hLhP1nWajNhU8vY6y0AiXgb
	 uwpJicASkIqVlHq5CpfIk7JojVT9jjX8hdEmUDZyQwu54fex+RjVY0n2P94/OtSbXlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639069;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R/bmj/im1cSj9RxegnF4SoX2nF68lh0kVTeB/V21Bx8=;
	b=e9nmVRu5ZFukGV5LunElIq8dqDTlkqAnUnRkNJBw93I6Ts1FLiYt9j1xdq03KzBzCij9
	 GUA/wKh2z83yV2dQvu0wBZz6L/MRf4kMSd7B7zqIV2FGMCevRa9ugvoFwwyE1or7Gw7E/
	 O4GPNqyv7X56R1yI5VrwEQS+5vRNQDChGOCZPBfLff8uowXbf5vhdvm50eN3uAXydXsLO
	 4aBXOmBfqYzXqdZ2huOMtaUHt7aX8NB+82hH2BO9PITp2Hc9Zb5IHgEaCHMpKT7j52hF4
	 6ZsDJdIVE2dzIi3LxkdgIwg/mypBC5nLe5pcUo4CuWP/aPRxpBA83OFzTl1UztV8ssw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h0Hea3tZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D4760A2602;
	Thu, 22 Oct 2026 03:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h0Hea3tZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CE71F000CE;
	Thu, 22 Oct 2026 03:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639069;
	bh=R/bmj/im1cSj9RxegnF4SoX2nF68lh0kVTeB/V21Bx8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h0Hea3tZqncXOQ0/hd4GuNfsnR3ssnPdSZch4iOwi+/r8hpFtQA4b+8TgIkMoQAH3
	 8nwZzsNjw7j5s6DIGFgbTN9hrVr1craMrInX3ygqUD34R2ckbZ7v3OimFQAW+H8uIe
	 eUP+2mirB88jucEclMMu7Kw4Uhfmsjvf2pX3UX/Q4SGQZ+39COe91aL1QZpU0QVyj4
	 S4CvnErjIN35D3uUq7FvTNr2yKGAGwDOtZimzgn5PnU8SzdxaIycHCqP1+sHl77ml6
	 sIUCCBMqdO5g7egbHOIFG9a95JpLmTwU05rznWhldzD0iajF+4crlVu8IHtNHhNLNc
	 cN/1nDB8pgfZg==
Message-ID: <sashiko-outbox-180924@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 23/41] statx: report UUID and GUID owners
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <68b5679a91d1d0f017d088a05595d0bdcefd58f5.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <68b5679a91d1d0f017d088a05595d0bdcefd58f5.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:48 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add stx_uid_r and stx_gid_r, the owner and group as __kernel_uid_r_t,
> taking 40 of the 64 spare bytes at the end of struct statx, and
> STATX_UID_R and STATX_GID_R for them. Every filesystem provides them,
> from the kstat the VFS has anyway. stx_uid and stx_gid keep showing a
> UUID or GUID as the overflow id.
>=20
> struct statx is designed to be extended this way, so there is no new
> system call: statx() with the new mask bits is the *_r variant.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D23

