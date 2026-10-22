Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792683648;
	b=0VJUfyaZm/Tu86UnZ8nVbLJFwBnTM8N4K7rRY/LkkjQpZrA5nfN45Vfaqmk0HzrAMLN6
	 EFxS3Sd0oE43LC8s1aExc4Ac5qcqacuF2uOtni+81liRlRZvvnNiNA1HryyIj0x3scfjW
	 2Ic+kalWxahr6/AygZ6c763fmHKXKly7fgxk0p8DRPn0YsBvXS98k5gHGJtDi7etBL/rf
	 ZqpdomSIPxxmKd+GlwE9XY1c99dv12ng9yJjl0UAcN4hXnUoBPE+t0u/BI59LWWwtam4r
	 KKFXFmKtvmNnz6dPenMtrxiIfCw1U9vaauaGQEGxk82mVaBI/5yiWSEZlogywpcok3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792683648;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PUw6JF3i1oX66R2u9A8HQXHZLhrsyR5VUVgi10Q4scc=;
	b=fxiRC5Bl8KjEsiG5KSMGf4eiUjeCU2s+VugBcl5IhkqcAe30l8oqm+zGKjq+DNrsEjCL
	 CH4fT/pYe4LnbF42Ra67s28xDVRaF512FR5NdZkrMVO1cP1qfpcoXL3ktu96UvYZd93i2
	 xwPc+a6k014SsnR+x3/uYdOMn6x6eEk8ZV2LQLt5bNzs92NutbdD95ENG2Xn1vLM+yva1
	 r0KG7jZE8fNW0VlEh6dQYaQt3jb/lfI0wpEYtlJUsO39TucDQxjjWPi8lAx/PfYASLDAS
	 Y81kZmt2J1tbvuARQkvxdKDWER+FP8m9roUsPGRi7GUeUr5mxousWei63g+lGbqUMuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BEM6II3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C507606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BEM6II3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B231F01825;
	Thu, 22 Oct 2026 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683648;
	bh=PUw6JF3i1oX66R2u9A8HQXHZLhrsyR5VUVgi10Q4scc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BEM6II3gqJmoaViz/hZjEVovLS4q75uTBOk4GqdynBn693Bp4/XW87jtVkjcqqNPI
	 soOanfLdq61nownjATZIAnA+vMV+FPX1rxaTjRJ/86zx4I8vpDlRk7kuo6aRt6Ud4X
	 Bh6vI1dYYcU7AKyQAVYhLtjIRDkntM4lkAcwFEMf1ResEtySSygzzPzCBW7TzvyDow
	 6TJxMd9VPb0SuWeCah50y6eDbpN7J85q8FvsBrzUM5xMufSant83vvjriz3+YiAG+X
	 24cxG2hBpSvrqaH4xZkgXxmP5gGeOCRtHhgo6Nyb7/oX0FSAGHZBoooUVMa5p6M9SM
	 B3j89UttjqdoQ==
Message-ID: <sashiko-outbox-181712@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] ext4: prevent stale data exposure after fatal
 mapping errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022145241.2950379-4-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <20261022145241.2950379-4-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:40:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When the block size is smaller than the folio size, a folio can contain
> several extents that need mapping. Mapping an earlier extent can succeed
> before mapping a later extent fails with a fatal error such as -EIO.
>=20
> mpage_map_and_submit_extent() submits the mapped part of the folio only
> for retryable errors. On a fatal error it discards the whole folio,
> including dirty buffers whose mapping has already succeeded. This loses
> data that could still be submitted.
>=20
> With dioread_nolock, the mapped ranges can also remain in io_end's
> unwritten conversion list. Conversion can then mark those extents
> written without their data ever being submitted, exposing stale data.
>=20
> Also submit the mapped buffers after a fatal mapping error when the
> filesystem is not in an emergency state. Discard buffers still marked
> [ ... ]
> retry behavior for transient errors.
>=20
> Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in diore=
ad_nolock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145241.2950=
379-1-sunjunchao@bytedance.com?part=3D3

