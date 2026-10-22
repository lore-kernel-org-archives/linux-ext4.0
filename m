Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639075;
	b=PwSMjDWrZcnGeWPCtnLPXCmLgn6VWy+W/P8kCBApzkiZP6w+7T1sYvYVZhjDvCJ+zxR3
	 vss4t++yw060qOK6GIK6/mKyNds7VL5EJuHGG7GPCwkVGhScCsdSMmkuQVmXH8vHAmFdW
	 AY9Qsv28YXAvw599Vy0MxTK3Rp7d5hlIxBtd+E0G9f+ELqnVD40kQ2tg1norZ4+L8Cvoq
	 UWorhR+RL3o9tz+cTk1eeRWn5Y7SYPAmcdBCYMD8AMK5nHxKtmbXMg1rCyFDOOkSgzqjN
	 owJloNLsci52lstsnxE+b7U/n6faPqaYzYuGqRy04dmyPLD8rFDWATI7lUrOhdq0ufw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639075;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YhGkLlJx5QVD+slE+0O2uxFnfgIFYxxARQHfGU160p8=;
	b=C41p/U/6QQOtywjDQRE9ZrXaYJFsrtXPlHGBIb6i/aw1hpGXluIw5PS4FHhFN2zL7QNH
	 vVQzo2Z45x/MM/iOj2OBgeb88dWiQnSBGDE/Y3mnVaKB6fn0+teJYbBEItpNCR2DEKcef
	 NDyiTR2N7gCSDqSFWOykCDzp5WUcn5BuVTF/ZuUVQw8pNT6pWfd8h65elF3yTfeuxgRnl
	 k9TnFkC1oohP0GD8BK4xwLj6PfNPUzcjguxgYRi3pa2RUuqmU1otVj+DDI4zWuXTXU8zD
	 b0hjef0zLnSIuKmnqbQTX9jVotii5YR4WZwh7Sagwu633OqjXkZYkrPjLqMinf9fcpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fme8wKDr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18757606A32C;
	Thu, 22 Oct 2026 03:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fme8wKDr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA901F000C1;
	Thu, 22 Oct 2026 03:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639075;
	bh=YhGkLlJx5QVD+slE+0O2uxFnfgIFYxxARQHfGU160p8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fme8wKDrp1fNABPJgYoqJ1FvOOYdXNjmaaIdpTg1RKCElDmD6gV7pNRDoQ2IieaHn
	 s5OOSFePXaWrVeKKxQe4/QGv6LQZO11jdz2izFMM7O2Vvk8g37ahracLoFpdV9muiZ
	 6+I9bB9EOcwMzDoFtAKCjoWsJ/Ksrf8l/wrw3ymyifIxkCZ8xso1yrnp1YQkL2LkJs
	 +tEp0/83lblKoTIhWGFJYsR7aKyG7rtNGjZd3D2bzE+6PW+KEjNNp3NHmEgKlgUTzv
	 RjKbMkw6ci87xx5RmodKShGrrR7gtRyck7IV08/Ft1RMjMVN/+et5HHToEirDEsPpA
	 9lgprshiePw6Q==
Message-ID: <sashiko-outbox-180929@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 28/41] net: add SO_PEERCRED_R, SO_PEERGROUPS_R
 and SCM_CREDENTIALS_R
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <ef85db692c151f13d4749f6c6f4fc7372a2ab0b4.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <ef85db692c151f13d4749f6c6f4fc7372a2ab0b4.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Services authenticate AF_UNIX peers with SO_PEERCRED, SO_PEERGROUPS and
> SCM_CREDENTIALS, which carry 32 bit ids: a UUID or GUID user shows up
> as the overflow id there.
>=20
> Add variants with __kernel_uid_r_t ids:
>=20
> - SO_PEERCRED_R returns a struct __kernel_ucred_r of the peer,
> - SO_PEERGROUPS_R its supplementary groups as __kernel_gid_r_t,
> - SO_PASSCRED_R asks for SCM_CREDENTIALS_R messages, with a struct
>   __kernel_ucred_r, next to or instead of SCM_CREDENTIALS (a separate
>   option, so receivers sizing their control buffer for SCM_CREDENTIALS
>   don't get truncated), and SCM_CREDENTIALS_R can be sent with the same
>   privilege rules as SCM_CREDENTIALS.
>=20
> The classic SCM_CREDENTIALS sending path now shares the checks and pid
> handling with it. Netlink keeps classic ids in its skbs, so it hands out
> the overflow id for UUID senders in SCM_CREDENTIALS_R too.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D28

