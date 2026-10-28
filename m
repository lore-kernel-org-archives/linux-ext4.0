Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168515;
	b=doCp5gm1c4wRdzr5tO3ywENA8ylfuhaxqKRgLDIgBMmxCIAZB1UoVy6tjC46ho185uwP
	 0ML6Jo6mmYU0S6g4iAp3OCDD0YxVUtAdCwthgHGAe1GOW1pbHGWqLgQeolmQzA16+bu/1
	 TsiA+ULJ3dXUMZ7zec8tI8p4xeX4nDiNonr66fkY+4fBqN7lpkuMiBxhDpa7a6dVZAHsb
	 a71WwKuKblf4BRcLfDEbkd3D2CxK3cy7nnEc+XFU84iR+cVFb8Kek5f3vHCywIvqFDEJ5
	 pjH4Jra0bunqUPLwrGvAHtKwDnaOSQGtSi71buWQrpQkh1piA0bQ4HfKDhRgvtrEmVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168515;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sgr5gjMYasPaD45fxcLYAndHp55NN7nda6Vl6QNZ80E=;
	b=Wogsc/4IcVdKgR5EWSV2NZ131UrZDStzhQh4fwLNRIJ8Q7LR6s65vY59GMWfVI+oKrVc
	 YuwUBA0a3K6nV2CJXXvWcBoLQsbl9oZYZBJCnUzPfY2ujUw8rF+oHwnWgbueUYgLLuxDK
	 NrO/EGstGruiUsdjmtAQA5psPFs7DLK7HzUHngeSsV9cpEA550Fo+52k/i/eRl5ltl9Z1
	 sUr/7fyE9QsSdnxhR/Oj6hcf5Yy5qMmL6k8l5lkYKgANYApfVdteGeXmKpreXM8Bynl0p
	 96rLT9yY+7nr//2A6Spy+Jc0y3pYSFPp6OhFzI6sAY12avarXX08ubWpLj1fjM9ZmVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aj7fjpgL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE52606A31A
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 06:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aj7fjpgL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52511F01825;
	Wed, 28 Oct 2026 06:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168514;
	bh=sgr5gjMYasPaD45fxcLYAndHp55NN7nda6Vl6QNZ80E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Aj7fjpgLTL9ACqwpzCI5K9usAEXlppAC7UdlOmuJkkVHGXYZMJKqTK1xvJ74mGKF/
	 HYDYHWVFSK+/M85sCaaKlfeUsNndzU1qeRJgXxvqWz4ICBZBlqHQfZIcp6/o+91/Sm
	 uTqFrbr0bc+jMrXvHpZgCx0J1CX2iCuocLzWQ8nrQbgez5NvCRDku9CxwPYle7KNQ0
	 ws5+fWinmWiHyTe2wYHr/IsdAUZUkhzjXaUx5LOJM6gElW24uMyQJptxj5E9tUPFBI
	 JqpxnkyWzumA3PdodPR/x+SJcp7UbEzoQdPlS5gvncMie+Yz3lSLg94PQLIqzx6deQ
	 ZML7rNlNpklHw==
Message-ID: <sashiko-outbox-187558@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix soft lockup while shrinking the extent status
 cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jianping Liu" <frankljpliu@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261028061628.1209508-1-frankljpliu@gmail.com>
References: <20261028061628.1209508-1-frankljpliu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:21:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Jianping Liu <frankjpliu@tencent.com>
>=20
> __es_shrink() walks sbi->s_es_list and reclaims extents from each
> inode. On a non-preemptible kernel that walk never gives up the CPU.
>=20
> There is a soft lockup report on our company's machine. The machine
> with millions of active inodes, 256 CPUs, and heavy memory pressure,
> concurrent shrinkers run too long.
>=20
> i_es_lock is dropped after es_reclaim_extents(), and s_es_lock is not
> taken again until the next inode. Once the shrink has run for one
> second, call cond_resched() so the CPU can be scheduled before the
> scan continues.
>=20
> Signed-off-by: Jianping Liu <frankjpliu@tencent.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028061628.1209=
508-1-frankljpliu@gmail.com?part=3D1

