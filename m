Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553978;
	b=MYJbkiJOBrpW+DS2EaBOLyh3aHoAEHPWqPC8iMVmQNn8PJ2B8BwLhBGCpcNtOZzB9WJN
	 rVPvwfk8oRWOg9XnyBJk7S8/g0jY47HY516wBPizluMErRO0xPmgwh9Ly1K6v8ibCO8rl
	 5uUqD+IFfygH+V/4RSiBZnoN09MEV2Sdk9QuYEOfQRUTr4ZjHmYEIOUXNx1h3ONyurMHZ
	 Uuh7bS6pjPtRARKkus1/wxKLJosKsKrPuAioJg57zBpEvFZHUjwR7uj0hixQieGC1oHie
	 7UM2xhPQNlyzGh3ONIrIWb0707FvlAdf7iP7dI/JdjisXjBUN0Q198m8EKxXn7vIZkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553978;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zse6WjVyoEL9eg1awFwpVJgWuqIHCaWbo1MRhVI+VUc=;
	b=YmGGQ+rI9no+3YPSXd9yIYm0VEGHwjqbBLB5XPVG1iI33ebPpO6X4kdlMN/dCHD3ULth
	 lZmpx5ig3tEzz/tlTcAFQSNZ+RgkBG8srb/YVzvxjHDNzxGsP6okvaYQ03Fakeo9NsPCM
	 r4YmtohrZJ+nQq8sAXF3TTSpWPEsB7U9HsWrT1//gPvMdw/jAUjhKcEATQ2A+ozM1pazX
	 yY8WaRj98PnwAL/O9lCTCkujDVuEhHfuvBYF9ojyYaJi9bmHdJoGZsr+BqXnWRhyRi1cO
	 DeVmoIGsFapfVzYvqLtB9rh6nH3kGKX0c7QtvCXOTDhnlvIOHXS1OyjgiGJcLA/0XOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2c3sFfU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E2A606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2c3sFfU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB11F000C4;
	Fri, 13 Nov 2026 07:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794553978;
	bh=Zse6WjVyoEL9eg1awFwpVJgWuqIHCaWbo1MRhVI+VUc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E2c3sFfUOx/Uuzhb32eUxCraprcq3Ekd79aBa/AMGxcxe9InFeojlAFixicmcFXfq
	 RK8bx4HtS+nCYnLbOPMcBwWcPm7fyCJDo+HHAe1LRGr4EqGTEZkiInnD/r8RDKJlgn
	 sQ12Ls+WvFvYh6QPET2aRZGlu+uMNJBE+WodbwMn1RuB4glq8RENRZdhJOMI+JBg2P
	 /efaOET9LUyoGLOMOQlGgVdzx0chW1XuucGZAbwMQaD1cUVY4KnDpSkbBDa2GGBABc
	 3mPCESUcffoWIyoSa2GiLh4/JqYVGxxFy5kGmd7F5D1WSJoF2dbWm7XIx5R8G9Yhxp
	 7RC/obm9E8msg==
Message-ID: <sashiko-outbox-212327@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 4/8] blk-mq: factor out a dma-buf bio refusal
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-5-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-5-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:12:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>=20
> Move the dma-buf integrity check out of blk_mq_submit_bio() into
> bio_dmabuf_should_reject(), so that such checks have one place to grow.
>=20
> No functional change.
>=20
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D4

