Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792839680;
	b=Iaw551kP9o8OrX6mfg+Px5M83hHTw+U2HlEpl9LbUENgA9/v9RcUz888hLqlL3dxSwAG
	 ciHuydbd9BnKdbyUV/2myVBcD+XcICziLDuduFeaPhfvONgMhL8q83JDtEaqLLTHVDB3y
	 4tDbhzDQN0mroavqrGTsu6UTidXehTRMdCqXj0IQb3xcmxbR1ngRrXzsQGk4Hyp/8AzD9
	 vRZX95LjZB8cd0J1euNur1srNl8ufx48uH/pNROV4/1QK3sqXPkDWxLY3UZTIiTKF4IUq
	 8VoreThu/Gc/A2bcKBm11Om3YkTVK4rF89dwhlOgk9fL4svkXFAxwE+c0OwqUanM11w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792839680;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RjDMKiSygmdeLKXcoeE5Whp5X9Bk9AAElX7Ns4qsiKA=;
	b=giux6u+28Ph5GR3+7hKapQvxn5o6o6PseMNiAv7PbGuVX1yDh5joLpbyCAsTyKKRgZ6p
	 4HIimVOd4Dd1EW4VlJHTZYMErcxx7NYu3cZxK11yCRdF/mEyK6rlHnf1LzEw8oDu5teM3
	 AHU0qDdX/LYqyI2NGgadk2cm8pxGB54Shwj30SGmljVzlRfDNDLPYrksIANODLzZqd29a
	 C7sWDtni45KhM8nZixSrXTk3hgohC9riCwqingWrZxtZTqkpdp7kcnsLQncwa30dOXsZl
	 zbSjEMhyIGdHBqLY9Jf3tKu3eovelU+1r30fclaxthnbeGiY9GVMEEnjbWp1UF50+Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IyBMY4Al;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7835606A31A
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 11:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IyBMY4Al
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E201F01828;
	Sat, 24 Oct 2026 11:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792839679;
	bh=RjDMKiSygmdeLKXcoeE5Whp5X9Bk9AAElX7Ns4qsiKA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IyBMY4Alg6jS/0wx/sllcaWKEh2QtLKt4WufiRaWgMlUbNTYevb7vsV0CupKBEweq
	 c4Uc1sPgheXft6WwJRPj+uEasEi2QBPJ/0V5J8vxyYAcHRi84Fot9DJTgpzUn5eceg
	 a1TarN0ZwoQg+kUiY0UUZMY20Vtv6Ch3peGWwfWzUJPv/Cui2nYBk/eY0nCuWoD9BX
	 BXndux0r4WVYTWoV2kIEnNCevSUlrIz6PwU4s8NHv7q7FXwSAA/7rAu1XUXeDDbu+Q
	 LYVrf5giNFu5FAOpbk9NcBUIDxBm3/X+7k23DwFjupM16aise+MnG8T4ED+rhaejLe
	 ryD7+0xdODoCQ==
Message-ID: <sashiko-outbox-183668@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: free fast commit replay state on failed mounts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lukas Czerner" <lukas@czerner.cz>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261024104407.1037354-1-lukas@czerner.cz>
References: <20261024104407.1037354-1-lukas@czerner.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 11:01:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_fc_replay_cleanup() is only ever called on the success path of
> __ext4_fill_super(). Fast commit replay runs from jbd2_journal_load(),
> so a mount that fails after that point leaks the fc_regions and
> fc_modified_inodes allocated during replay.
>=20
> Call ext4_fc_replay_cleanup() from the failed_mount3a error path, which
> every failure after jbd2_journal_load() goes through. Do it after
> draining deferred EA inode iputs, so evictions still run with
> EXT4_FC_REPLAY set. On paths where no replay happened both are NULL so
> this would be a no-op.
>=20
> Failures after the success path ext4_fc_replay_cleanup() call fall
> through failed_mount3a as well, so set both pointers to NULL after
> freeing them to avoid a double free.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Signed-off-by: Lukas Czerner <lukas@czerner.cz>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024104407.1037=
354-1-lukas@czerner.cz?part=3D1

