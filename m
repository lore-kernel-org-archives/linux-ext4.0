Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135745;
	b=evrgCDiXXQlF4hj4aLMhKA6UavcXaRyv+0S0aMuN2/woB1XmywG+MNCdpqSEBXVEOdfU
	 2b2Ov7v2H7zIZ/eVyd0mebzI/fS/JzRad8tOjEXraQWWlaN5cn5jwRgoH7w9vjEKtJPLO
	 FB6gnkgPw8QdaR+JIWzI74MsiZbbrvEdRLet3OPd+k8d69IystCJvZSKaiHuYAuhS/XIq
	 c99Gqbn2L4IHuCHJ+86/t9TVGbtuOlfcat8n7WV5fNeC/0g8GIEggqsKwfyaS6MLtlfGp
	 eRVdnIgRQvnu3N1VKEUzFfKFlp85dT3oIpHanQzm2Z5cnuJOk8Jl52Q/yzWfQ81n9YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135745;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/N+XNOW2YQWTvCqS4uTzXS8Y4C84siWxp3HfyJkMKUE=;
	b=IzQ3GLeMmW5WrDr1EBVmJ4xL6mFTBq639CdeGYXniRHPteCDIYHCtgIq7DPRTMVyg7R0
	 iJ7XlPKopCUUgFEyuX/aim1+WYGePnM6C9+21Ta/Zd5Q7ut+Wk5WQq1WmKhLIb6HGV7PV
	 iWBwRv12T+GTtBi4KQkoQ0jWU8ox4iZWgg05IuVyn5aPE4Fs+rXj/bjsKl8XXSC4Oc0jf
	 tMa5TZncQGLWoMsXDwhmuu7gOaDDwF2ErG6BRyKBKFPpC3MvD2Oaz6LfsWiLq8olCRTsh
	 thVLxrWQ2pQkKVnp0vR/dhgveGqs7gSxdEy2dlvgk8T9Rex3Gj+xS6UQeWEGhplzvjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LsqhxyuB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1746606A31D
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LsqhxyuB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129B31F01825;
	Tue, 27 Oct 2026 21:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793135744;
	bh=/N+XNOW2YQWTvCqS4uTzXS8Y4C84siWxp3HfyJkMKUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LsqhxyuBAdIo2x0rfvqZd39TzxM2rqlnk3k+oaB7fd7VtJ9Hkt9If0KiWwixM38ZD
	 /6nXD2ZH9vLhFyKo6t1fe+c8vexiHWnpoiMv075/dsTr0nXq/+G3hSJSu63CR1q/62
	 KHaSz5hq1E3W0byRQy/TINdLVEQB/Ghg3h+OccX+HpyJNezsj7YEhhcS+qq2+mzguL
	 aW1VNnVWjOkWmRBV14ItOVpJpaxgBce1LR+ooDBjMDmln43azJY1VaH2RVBav69fKB
	 PvcULp+LnLDTE6Zt1aTcwTXgjHwBuHdcgmcVizkKaM0eNDkSJ3mXwUcfZSYXhr0Rn2
	 zinREnFeNqtEg==
Message-ID: <sashiko-outbox-187116@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/10] ovl: setup overlayfs' private bdi
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-5-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-5-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:15:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Chengguang Xu <charliecgxu@tencent.com>
>=20
> Setup overlayfs' private bdi so that we can collect overlayfs' own dirty
> inodes.
>=20
> Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
> [josef: only for an overlay which is going to have dirty inodes, rebased]
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D5

