Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880233;
	b=xrbjmI9/YS204/e1pMghLdgOk/OVi/1YT1IOwF1SOEEILxSBE3Glv5qT3jzh6mtMbItU
	 a0JAYVoKvNaPYgDhwhpQd2CkUVKUPZ1HHmNrPLs6Vhm/xYNnTGB74sFQ3LMQalNhoamWT
	 9MnMVkdbcLT7f30zKS7q8bBEmClrvUGmPKOfZ2pzhUuXc4eYsKQIOy61Wfg2cLIHDdeGQ
	 wlyqIfDA6znUyrUfUfpJJw3oqPbMThVklxtKR4sTWQrJbhO9ogj0mg+U9tBbntwZbTZ9O
	 mxQ1435u3kDhqD3SGTkm5u492CVIvUjX6b+mtdjQyKN2snEqi5qWSSsbSnNcIbryAow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880233;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HF/8SKBuUEL3ztk7Xy2RdRhyZwmvfJNmYpPnOYSmWak=;
	b=E9357GbssUEGeoDtEhIbMIez/0ZtRu8loxnIep7H6UzFbZiuMYxicC0LvL8/KpSS8Ob4
	 vbuy4BKGaP6v023WQ02YNrMzPbDxxWsvA4KGPxQ26PthpiRbnWddtg1p7eHsX1iyz41kW
	 zyddkKWnXGh9rmdKVgLrMHqB14PHag2kPhupq3xzSo2fg+7UWu7BHUmpb9ueSKtl1O9uV
	 WeVuX580Wn24ykA7lLqvsouDl+Z/pBx0TNWNyKTRubpy/wxKueJFLf2Hj3honSp3QFyYY
	 pz7PIvLFJlM3RHW9Uo0oRc4Ut3JRbdlurmS28b5R6Z456Q6/dIHc9L7nYvZqpxiwLmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ilwp2xhg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F849606A329
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ilwp2xhg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EEC1F00919;
	Thu,  5 Nov 2026 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880233;
	bh=HF/8SKBuUEL3ztk7Xy2RdRhyZwmvfJNmYpPnOYSmWak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ilwp2xhg2yB74zKjJ0GrHJFkqagzcVYDPbbR6u7rV5wIwJDzCmR+Hl8FS1EmJ0BU0
	 34c5OgwaCmZyL/Gdmx2CPwz3AmOzqOT0bUcsqq53xgGUzMaxq1f7zDV3wQ0dR9sFQL
	 md+xhMg5ub6Ug57zZZtrR24hU/KOSdbwKn3BdIFjrEWVK5rCvjmr5IGrh0N5Ybp7lF
	 ru2xN5kLjRQ72kfVazgFAzKpgRdjA/tTMRQddxtVzX59x0LLzsDOlseynzEmpBkv8z
	 NTOkco3alm1veiE/jhOra2fyUWox6RzLGuPRJPFrKyZb6uiYs4PJZlCvRKQ0kmytji
	 v9MNaKMlc76Yg==
Message-ID: <sashiko-outbox-198987@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/5] btrfs: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105115532.613467-4-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-4-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:03:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the inode runtime flags that
> duplicated this.
>=20
> btrfs only used BTRFS_INODE_VERITY_IN_PROGRESS internally, so remove it
> outright.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105115532.6134=
67-1-aalbersh@kernel.org?part=3D3

