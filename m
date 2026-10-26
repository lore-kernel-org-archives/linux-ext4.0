Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020347;
	b=BHRlpkFnKAoC1fPLQ+rG6LXkkLDb5iiaiMUZZmbSW212YXaWbPJTbZ8q8aoA3glaPj+Z
	 k7vmr5ZZRqBFTmRgKMNBbGRn/taEsV1YqDkBNPKYw/DFKRBGe7bwvPSb+zn2RUsEp272q
	 egYw4uQEroifhfVC+cZ6AoZfyGS75dJVisMKbkDIO5RAkPYsi4sI0rfVm2BO6a5eEq2CK
	 KnTF//66ecj7Z7EyxbfGsyGco8JZ1jCpa+jMQYJlT7YxWhM1Oddn4CMuF/jPHg6MVXtuJ
	 9XjoZ/h+lSZYBwTtCOhoDNdGWZpkZcIl7llhLq1ozdlDW1kMVv57KZhrIQwTrEtOC1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020347;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AaGlvx+FkuMSWG+KgzhjLF0Er11CmJI+SPOSOfcVwNo=;
	b=VDv0GeVGjTL/ipuBbOGFn010eut4bGYVZ1PQ8Z13hRTBYCMxe7YhjBlfLpiGBdxaFk2D
	 PWX7XsT757pckI7XxYWeBltxfClMRNfjVbMhrq/SSu0XTAB7qeeHCqEH/Ha8SOjsXYuj0
	 jbYWBDmLpgNuBZFltnuX3ueN8foRpkpahbcvERCuH454lJrKxHHYiXSlnAzE3mT7wc+QN
	 DEzO/ir7Y9UxhiHm2G856Q5HUKI6CtdBLAh6/ALS7IOKMBAk7uyVvgXpoqRstOTjLZxdW
	 YsroXppLsuqOmxQUq0CeNofrZwPXAc+RGsWeR3/Xii5YCrO+lMwGVIDCuhprsP+vRRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WIznIsgU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A52606A31B
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 13:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WIznIsgU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41661F01825;
	Mon, 26 Oct 2026 13:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793020346;
	bh=AaGlvx+FkuMSWG+KgzhjLF0Er11CmJI+SPOSOfcVwNo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WIznIsgUoPdVrL3/66n3eKFAxzx9Z5Ey3X8Iaj7bfKhgATqrgaq5gyrR6cXWcS19S
	 OtXXufC4TwbYl+91AUgZXXqrZa0EUokwvt07WlIEEZXdbmhMtH88xRL6F3LpyjKM0h
	 rzDw6HXsFocseol8j7+6GtIKZ+i8UCTNnh0Iei7ez/t9uIsF9R9VUvngaKtj0E5uup
	 aiaS9ql1GhC0AmXm6dJsmGmGWo118/lQrxq4lboSKsuOusy2KPknEMrVSHTAdYXXOz
	 QBwWzop6a0Bup+CxbwbzyMddEsxisSWmX9uNFDO6Wq3XqHwHPJhtvqa6jCAQdbLlEY
	 4foW/DUnI35kg==
Message-ID: <sashiko-outbox-185283@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] ext4: initialize map->m_pblk in
 ext4_da_map_blocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261026115131.1735014-5-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
 <20261026115131.1735014-5-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 13:12:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> ext4_da_map_blocks() returns a delalloc mapping through @map without
> touching map->m_pblk at all. Callers that only set up m_lblk and m_len
> of their local struct ext4_map_blocks and leave the rest to the mapping
> helper, like ext4_iomap_map_blocks() does, end up with whatever happened
> to be on their stack, so the trace_ext4_iomap_buffered_write_begin()
> tracepoint prints an uninitialized pblk for a delalloc mapping.
>=20
> This has been harmless so far, ext4_da_get_block_prep() and
> ext4_set_iomap() both ignore m_pblk for a delalloc mapping, only the new
> tracepoint dumps it.
>=20
> Initialize m_pblk along with m_flags at the beginning of
> ext4_da_map_blocks(), so that a delalloc mapping is always reported with
> pblk 0, the same way ext4_map_blocks() reports it.
>=20
> Fixes: 008f019ab559 ("ext4: add block mapping tracepoints for iomap buffe=
red I/O path")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026115131.1735=
014-1-yi.zhang@huaweicloud.com?part=3D4

