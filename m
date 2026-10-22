Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639059;
	b=wSmIMnhaEbtOvjew9f6c5V7qzAgvF9QBQUlxoh+2JIPSljBJfp/kisn8EgPu7Snshu/W
	 m1GQNlwrF/cft7FTEE5QjhdkZuj5bnZOunm32HceR2k0G8XE01lvPlKB3t9xyH8eKUOoj
	 Mk2sKf/Ew2m3Sx+7eJA6FWJPmM9gm3NDLhdlIQ6eqpbwmXLj3FPbLh50nUklUtXOMfm8o
	 yexPP28stwbWHyDbUxWpjwDC4JBovpo8NLWdvJ+XmDCxEXdSmj51yWwtqPunW/rXQwnuY
	 Gdw/0Rqfax743nxNfLk9fTnzK2CZycLQhnrVWHUOaSjhk8gNrJory/KAG7cfD6x06Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639059;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MfcpyVIQuWp3bjP0c679bxzq186r0798wxFqDOb593c=;
	b=Skw49wgMCdGJm48KduJ9oCkh4hXwalJCoywvK8wYYGavPNNJXgn085lO1wHNKJISar7O
	 shwHSPwD+vjaADWvQdG3bUAB8Erv/P3/boYOQbKayTutqBco7DsIcjaUksNKcA1rTtTUx
	 vpQA0ceetQ7vzahv0FqtHPOVeVFjJ+IdY++6gR7AOki2cVM+QltySqA2FDOcpVX60EEwB
	 8kW2eP2T4yQ0AZbk0dCNeerMpVL2Bfk/Jj5+KCeOFp+QyRz6RBcJtDA0lYIP3dCwYYwja
	 0Waf/7vp0AvmVQb4xK8QBx3+7QJvOdGlwgL6xoKeOn2cF/r+qHx4GGsHf8nm7CYb7uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxWW+i1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B6060A2624;
	Thu, 22 Oct 2026 03:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxWW+i1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5EE1F000D2;
	Thu, 22 Oct 2026 03:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639058;
	bh=MfcpyVIQuWp3bjP0c679bxzq186r0798wxFqDOb593c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WxWW+i1j3GANaD+0ilAi1QXXvma8qL0IEkSHK49q1QJpuY77BZpyrfc1xB+mNJrNS
	 KEU7XELldNmsGqQpOKTMmTUkwWY65ddstCOFRs82T70PjIK3Oi7066A/44MpuL1/+U
	 7kSyQCTkptHWgvalY4/omLfxeLXVB32DiYSZMjkB/DDOq4PmwHKMnPD9xyDzcJaJZB
	 AluqZNFNLjeAEmIV/N+uOnZdQZpybnFOkt1VbfhOy1DXJYXA12E/wxBP9qzdfseiI6
	 Tv7j8Jb3uTUvppFcY4+Z80HyyuLTcah2KQqEcb93JToGqqDf00WVMx2nE6SwRdsOQo
	 fqFrpL5KDysyg==
Message-ID: <sashiko-outbox-180915@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 14/41] nfsd: don't hand out uid 0 for read
 layouts of UUID-owned files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <88afe10ca34a89b9a0776752d6583cda3cdf747c.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <88afe10ca34a89b9a0776752d6583cda3cdf747c.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:37 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Read-only flexfile layout segments use the owner's uid plus one, so the
> client gets no write access on the data server. For a UUID or GUID
> owner from_kuid() is -1 and the "plus one" makes it 0, root. Use the
> overflow uid for them instead.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D14

