Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794812353;
	b=27ZmMBYG2zyBZPDYerzrxInrrD8y5iSf4FdkeWg+wU9tX3Aw5XbHFKCKISJVTdoehtab
	 6vmHPJWVQMrGYTklhiMHp1X6ovqU5CMDKpR33Hlm57XyrXd6VNYtOuVE2l+VO+Mjm2oRT
	 +inwcmgmErtAOOHKpHBkrwcd20qqN9m1EttpJwjZW+BhpWvDbCzYUVGlKLWWvRFzZywnT
	 AHU9Yiw+urfP1QLtf7egrl2HoQW/KCFe3IYnpxGwcOXZFHS33W1hnO4ViYMAJAw5UqJnV
	 Vn5Ryx8m9MGJvFQIDSpdoHxhKAk0gQN/YG2locMEQIus416M1of+TxNZnySYWiR3Bpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794812353;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xYx8mxs1ra4GhCpCwPehYrz1P9tcdjzGOJ4QEOn8xiw=;
	b=IUcJWhAjoPjo+T4V+nmm85p3FaVhgCyDqR9wddNIADoiExWRlKtZzLmStnv6DiDeC+Vy
	 pTdpOk3LOB19/0DyPa6boULygPr8Fw3xTJneFDx174ADzus5IVP75VbTm69jdFyIimM/y
	 cLnezjMQVkZxEG5T8un0xQDO7Wve53y00agKfGc3LV2tvGczHjWbCwpyMdj7mzAbZ7HvP
	 664Lcwmdx0kO5Solu2nyrRcTjHXkqWqz63eXTAvtE0Tbo6eEh2hPY5ZpN1iAhAJf96FpY
	 Cm/1e3bhzPwhgrlrql2YmH/lB/H1bUAGBs3uGuMdI2+YoFoQgTWDsWc8RLtYIZm7Rrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfbT8NEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7CD606A329
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 06:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfbT8NEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9934A1F000C4;
	Mon, 16 Nov 2026 06:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794812352;
	bh=xYx8mxs1ra4GhCpCwPehYrz1P9tcdjzGOJ4QEOn8xiw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RfbT8NEWCDR8J6jy8DCBK0th3w39w3ttrRDqDp1+p3URWNc+kobzEZ0E6axfp2haW
	 bYeG/AwoxYE2OGRHkjMouu+klNnRpE1GFa8q420YTBIuLBKV3vW7Qmxg5WOJJqRBRu
	 xSxIzoDhcw3F4Th4LIxMMqYA+7dECUZ3V7bTk2hf46BF2FzhXLItJjzCFeoxwUAaeA
	 ZjCDgRvyDZZWUwsAankrMt784EeHLf10CnzGgthCn70ayCsDRXX6kOtaRURwAbpKea
	 RhM+tKTodklZ7ZHpbieBALrZ1TVw0C8hM9UhPQVT7ikfhUm+MA06nJSexcnBomzias
	 dlzovuOaWKMvQ==
Message-ID: <sashiko-outbox-216356@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] ext4: use atomic bitops for io_end flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261116064749.194146-2-sunjunchao@bytedance.com>
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
 <20261116064749.194146-2-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 06:59:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Before EXT4_IO_END_FAILED was added, the writeback thread set
> EXT4_IO_END_UNWRITTEN and final completion cleared it after the last
> io_end reference was dropped. Adding EXT4_IO_END_FAILED introduced a
> concurrent writer in failed-bio completion. Successful bio completions
> do not update the flags.
>=20
> An io_end can cover already-mapped folios submitted before a later
> unwritten extent is mapped. An earlier bio can fail while writeback
> first sets UNWRITTEN. The non-atomic updates can then lose a bit:
>=20
>   Bio completion                  Writeback thread
>   --------------                  ----------------
>   read flag =3D 0
>                                   attach reserved handle to io_end
>                                   flag |=3D UNWRITTEN
> [ ... ]
>=20
> Fixes: e856f93e0fb2 ("ext4: do not convert the unwritten extents if data =
writeback fails")
> Cc: stable@vger.kernel.org
> Reviewed-by: Zhang Yi <yi.zhang@huaweicloud.com>
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116064404.1899=
11-1-sunjunchao@bytedance.com?part=3D3

