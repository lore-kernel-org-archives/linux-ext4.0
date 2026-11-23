Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795458401;
	b=fh91ebuTcOVQoZWIyYfxz5KlEBuAEPV6eVARcrxfVp7Jql5ENIHNzRSrBWHq0BSIHXUW
	 vVIQ5i0AAhLlwThK+3/g3tYCB8PsDrEUcR7dY72Bp8AGLi1Cshaaz2paTypvV+qF06RgE
	 XAUom/WoTXoHWxuszbfQ0GDKFACZuuuLAU2hsHmMwn4Cjf+KWhRfbKSavDtQ+CgqIg/Nm
	 SnL7+30O3SvPwIMmGCAmyYBv/tNEcth04x8/cMnQ24SdAhNi4U3EziIfO9cjMr0ddfs2W
	 hHMFRioV/uiqU7w6dH1hXdQzcQbyN7s1eVweTYOoqvmvLiV5CNKUFHJRP03fDEMfXAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795458401;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SjOX7ot6VZBSkIMKrSUNP2DXFRWgXxZC5QYRfDNqGRE=;
	b=r07MQDWOPOyyi0hv5fyDux8u15ds8OxU7xLfAlDq8QRI5mAARuG48e3H2fLYpIf63WaQ
	 /8184yJgmQ071N84fMjWW/6KETXGXsRpR+ELk5LcWLmI1B9fIbONcoMruNdby6YMzuIdd
	 +Eb+jgDwwZnfl24xB1jzUOhgu6bAni9G2RNUKId2q/nbamJ+1LfVqxE1tsVm3nMdVgk62
	 Pk3fDxnfxBxtDs9P6ZSo4XkSbQcvlfV5vPnAf2DUfXiSqxIbqWaHfKOhEhL7NK0/bK7uk
	 JkoRhgXCtTfXNxes6JbQTZpUFh0VqpdcqStX30hZxNQSuaDS5BzyQcYwj5AAoRPTYgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="b15/llBO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE367606A33C
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b15/llBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8C61F000C4;
	Mon, 23 Nov 2026 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795458401;
	bh=SjOX7ot6VZBSkIMKrSUNP2DXFRWgXxZC5QYRfDNqGRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b15/llBOwS2TVnjC6ZUJskm1Sjw266QZ5P8THYAEbzNar9Jya27nrJqiZvBU4OZbC
	 +e8pYkDVxPSIKv187GBz+YG0PYBsHtxrs5WkvpKP9NTeHr7CyqubTG/jd6RmyMnBzT
	 AWieLP9mgf7QfASIg2QVLNJq5uCyPVRgPCXSASbaYDu8Miwq6H4oPz78ZD8oIMPDPk
	 PJWW3/NVPLiqYRo7eN7M7nT6jnAW6H8rM61o65pP4JVWDjQAzBZXYBTSzOcV3R8Re2
	 1VJIZnybsbjI2BsO8mTDVvny8r9ZpvG2MWf3J1txaoFOl00bhmH6JHuFdcSyeNRslN
	 T68YTxR1FtGAg==
Message-ID: <sashiko-outbox-229814@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: undo the splice when ext4_splice_branch() fails
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QXlrdXQgQ8SxbmPEsWs=?= <aykutcincik@ogr.eskisehir.edu.tr>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261123-ext4-splice-unsplice-v1-1-d291b741d15a@ogr.eskisehir.edu.tr>
References: <20261123-ext4-splice-unsplice-v1-1-d291b741d15a@ogr.eskisehir.edu.tr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 18:26:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Aykut C=C4=B1nc=C4=B1k <aykutcincik@ogr.eskisehir.edu.tr>
>=20
> If ext4_handle_dirty_metadata() or ext4_mark_inode_dirty() fails,
> ext4_splice_branch() frees the new blocks but leaves the pointers to
> them in place.  A later write then reuses the freed blocks, which can
> silently overwrite another file's data.
>=20
> Clear the pointers before freeing the blocks.
>=20
> Found and fixed with the help of Claude Code (Claude Opus).
>=20
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aykut C=C4=B1nc=C4=B1k <aykutcincik@ogr.eskisehir.edu.tr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-ext4-splic=
e-unsplice-v1-1-d291b741d15a@ogr.eskisehir.edu.tr?part=3D1
