Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793327174;
	b=a7HaZ3gK4NmDZl4IuZLYDLx0bRBNKoTDWxf72c0nu4Ef4iL8n98aouRUBlslrkmO1Wn+
	 UrLcn9/GrBiHSRfpCmRKHY0ISNzBqY6pYwL+PLPr7KeVUNGT+lYKKvjKtP5n7dIktdiaj
	 thLMhuoIsajvuyVtX3qhvJnz92ZLdgpgr52wcpZXGy+3jroBx6lZFeFWclFUvTuzlGBMe
	 YEX5R7BcQCX/oSxfaos6PraEjo8Km8E2dzQg5+edh+1aTrm4P8tjAdM0eNKC75eoKECsW
	 I1B/NTnyB67N2a6E3lfMqQMtTsZrdmZxsVQUd3IwBXGt37XekTl9haOraaAE6GYoLJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793327174;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oXbCN+Hid1Ufw+Wx3q8N361BEBIQaomvX3Tt9fxd8Ns=;
	b=hCKt2d1vQfN12iot9Qyd3TCG8yUUWMQ2Lq28KFZkU2UvWU/L8M73r5kHRUiLbR8QvWtS
	 XhBmfe0eRA2Y8kMIW++ank+jRsbRuljXEOl1Tksbhe72DCiqGtQzSN+v/iCvYhpiQCO95
	 VAsB1tPq0hqQnB/o0O/UPcuZ9L/M9sFWVp0Qi6vSA4DJgD7FHOMHMV7UcZFSSINv4BSqS
	 do0a7qSHkv/GoZnjp/PkOdUb97hkkSYSmhd5SLNm/AgXy1xZAs8Sq4quAJqcTVFkB2JDJ
	 x7rJeuYyu6OpaFHVMCXiknpZzKKyEPyyFXEv/zJwrggmuCB6hJVtgM3s48CGMMEkzyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NXBMjgvh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1692606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 02:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NXBMjgvh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0F71F000C1;
	Fri, 30 Oct 2026 02:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793327173;
	bh=oXbCN+Hid1Ufw+Wx3q8N361BEBIQaomvX3Tt9fxd8Ns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NXBMjgvhVz/cCJfHKG0qw8V/0Y8zfYArzNO5VaH10f2BI2PFKqvQNRs/BSrVejsCj
	 b6koQLUu8RjnXbKwlfMktplUueAbJ6doZlcyiFFwD9Yv85UXad7IO0feFv3bVpiHCr
	 KvwnjexqrYD8x9Dqt8NglY+mjR6AJyOJX0d0b3DQqNkCuEzaATVpv9jse+zbhqju1Y
	 5XPiv4pMwhIXMCtdWepV/45saqD4osYJtHcWAU2NslWLGv5bwefNEe7wLAh6fpnl1G
	 uNmGvA/4H1DEqEKImoAFvEBQY0ty51/QpAKhYM0spyrujslEs+KM6n1I+9wslvAmuQ
	 zxJMB6+5KdXow==
Message-ID: <sashiko-outbox-190174@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] ext4: initialize map->m_pblk in
 ext4_da_map_blocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261030021338.1768292-5-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
 <20261030021338.1768292-5-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 02:26:12 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030021338.1768=
292-1-yi.zhang@huaweicloud.com?part=3D4

