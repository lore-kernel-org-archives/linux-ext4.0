Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611985;
	b=Zs+SaTHMMIBEbM5IMyulRhIfogRh6Ooq/m8kddbNohJQOURNgkdyGZNaqCpENhY0kYez
	 GXix6hrLghRTE+pOVFeKr+Mryq05ZNB42WUCHUnU6arK4MvrEdOypHUoocaWha8NEQqY8
	 Xg97v1YQPcoBP0M7bJgqxf4+4/hasj0QhLB89c7ObZJEweBAaeDXJq8oxe9+hPOEpbH2k
	 gWOY0Xlr2TXyxkLp2K6t/yT+gx1WpH8VBgcg1QuV6MQwV1INT25dqgwsD7PTU/7+8eNr9
	 QfOh3xV8hPH5PL9dXWCK/hYxYVTRzvKhB+6enPQF8NJvW6hvTCO/Jc0Tmg2Rqtp9Tzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611985;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T6bx7FPTlJWSDVMksSPuV8msDex6/pfBUOxmUYfO75g=;
	b=W8dVsJUFRvgNYill4LO3f8+3bXgvUe5gNC98Es9oN3YVsQdwk+ls/HPj1em9VueNAT3w
	 bxU1ioTu/NZ8D2KUNRhTRQzT282MUgVlXMKm2ofXGD8I0osxDcFeqI6oMIT2l2s3fZdmv
	 2D2upUvhFsiAsWB0E7dJfC0DzglE8ADukP+tvaJF1yE3xtvXgxMzi9fez3oeX+MdQWVKK
	 81op5auNFaB2KytpXAGTiIwFa5IDYhiElE3xWNZ0IBGJIL8j+8m/TeEbsTREPpmW+nr7T
	 6bRdIXbNgMwv2IZVrBRIk7Ra4SIjeOdSdXC10+oPl9QgTHvEgcT+BiDN5s2230E/wCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SlfrU30D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB798606A326
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SlfrU30D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868B41F000EF;
	Wed, 25 Nov 2026 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611985;
	bh=T6bx7FPTlJWSDVMksSPuV8msDex6/pfBUOxmUYfO75g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SlfrU30DdW6cl+MdyW8GdYJt+XRIwOs/1GXFgO/uymnn/C3uaFZv+MvzeYQXfSvtj
	 gd6oSOuFn+JDEOqLZ0ktU2naQcxlaR2866A2h4iJP+p/RXuYaLPlX1v0I0blJOVQM7
	 g5oFCV9C/6c7sTX84DU8lYDBmtPvYKoeBo5MHg/WyZ97u2tfxcmLifBn/3r4MZZkCU
	 4lHOelKKjDkIWyS4EcDENUwMKSnIf1uaKqpYCALItAzlHLdHqNaDwtwO8yHexcup8l
	 PewIZEvtqsIwHYaxmKhDalOB1bDBKEKReOM17Tvoc3mx9ontOQF6BDBnnBzkwKIU8d
	 NUMLhGdspteZg==
Message-ID: <sashiko-outbox-233453@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] ext4: cache full extents during mapping lookup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fengnan Chang" <changfengnan@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125125101.528146-1-changfengnan@bytedance.com>
References: <20261125125101.528146-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:06:25 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The extent status (ES) tree and extent tree leaf buffers are reclaimed
> independently. An ES entry can be reclaimed while the leaf buffer remains
> cached with BH_Verified set.
>=20
> When this happens, ext4_es_lookup_extent() misses.  Since the leaf buffer
> is already verified, __read_extent_tree_block() returns it without calling
> ext4_cache_extents(). ext4_ext_map_blocks() returns the part of the extent
> covered by the request, and ext4_map_query_blocks() caches only that rang=
e.
> Reads to other blocks in the same extent then keep missing the ES tree and
> walking the extent tree.
>=20
> Cache the full extent in ext4_ext_map_blocks() before the returned mapping
> is limited to the requested range. Add an optional read-side lookup to
> ext4_es_cache_extent().
>=20
> [ ... ]
> Suggested-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@byted=
ance.com
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125125101.5281=
46-1-changfengnan@bytedance.com?part=3D1
