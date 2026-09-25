Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CA449B209
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 15:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351249; cv=none; b=bI+B15d4G2qr43ATv4AG5c+0Xv0Dt7S5iusqWT9lT3OgNFnsqaYaTwndHkbOUyLDGbhJ5nbAuP0SAZ4p8iedNzzv2Zb5Lu2QYKvjlGkC/oZuqe5zIi8f8Eqs/mOC9pX0drsTsxCGuuCvMde0fueSFh0ND5jBenriTPwbaNY7m9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351249; c=relaxed/simple;
	bh=D1QODsO/uA1pNNj0jfzkAHowcc53oy3IDHgSxETSdfA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=llKDEJrQkZsr0N7o6WGyCoPVCe1u6hb+Fg15YyEbd3DS152OyWI5zeJwSM9/BvoF3K3tSwgP0H8qQUxtd054gOwmhJY9Eo3l4Ijv0fTIv5QwhaSPReNZ+m3399UMzcIHtiJK602lX0tkGMRPC49cqxNK/w8iKWk1aD+0lpSP4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqBXSNtw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqBXSNtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654D51F0089A;
	Fri, 25 Sep 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790351247;
	bh=zvhxeRrejOB4Lnp15rmxgVCZquWDDMamzrr2qR3HwvI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MqBXSNtwqr2pEoVm3SxV72s+kNvVjPhPlwhnX0MSwV38lIWzxszacaSp9kE8e8IBN
	 lrjT/a3YXziU1NjG7eG7SJ9UiUVjCv+dFIuXModZ9ducZgs89/Wqsp3V7DGqv21LxB
	 wgj/XDycV9jAD4okd5bxXPAs353EX5BqA188bdMqUZFXhZockUMWSyZSYaVY50rK+b
	 bX2MnNya9Y6WRFOe6ZaBrJmNcoGWgUZYtplliGNCkxk2qP7T0ebPUrrTkGenke//lV
	 w0O36ZOR354qJO/hfcPNAU2o3lLjDxXa/Z3xOuonBvw9ob/sIb1KY94RCX/C3JWdfq
	 MkQMu0VNHGHpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7.2.y] ext4: don't enable large folios on encrypted
 inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alberto Garcia" <berto@igalia.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260925153127.1472301-1-berto@igalia.com>
References: <20260925153127.1472301-1-berto@igalia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 15:47:26 +0000
Message-Id: <20260925154727.654D51F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Commit 709f0f1f1bf5 ("ext4: add checks for large folio
> incompatibilities when BS > PS") disables large folios at mount time
> if the "encrypt" feature is set. However, enabling that feature on a
> mounted filesystem circumvents that check, and writing encrypted data
> results in a crash:
>=20
>   BUG: kernel NULL pointer dereference, address: 0000000000000028
>   Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
>   RIP: 0010:ext4_finish_bio+0xf7/0x3e0
>   Call Trace:
>    ext4_release_io_end+0x51/0x110
>    ext4_end_io_end+0x4c/0xe0
>    ext4_end_io_rsv_work+0xb3/0x100
>=20
> Fix this by disabling large folios on encrypted inodes, as is
> already done for inodes that use data journaling.
>=20
> This affects all kernels between v6.19 and v7.2, but it is not needed
> in v7.3, where the code was significantly refactored.
>=20
> Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities =
when BS > PS")
> Signed-off-by: Alberto Garcia <berto@igalia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925153127.1472=
301-1-berto@igalia.com?part=3D1

