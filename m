Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF65A3630AF
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544246; cv=none; b=FFExLBMiePBFpOpZPIo6Ump6EdXXjy5aQ6nuSvLBHg3JIdpnks5mB+r3Wb5w/++NVJcg2wLyWP9ExeQ5JUh/b9wAMfcnY1RBBWUy4OXuSmR4tC3ptjm7ZUQYYaZWtiKFgX1zigY9BiyjkyN027dppMnHKcnQarm2rCzIPAhs5go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544246; c=relaxed/simple;
	bh=eN1SzLngRtnAsZijM+rMfElewNKbP17Ki1zPdnogbwg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eoZQGXG3xF3YnYA1eu6MPB1aXCfyCtJBaITAxc0kldr3FLtzwiKGJDLnentV98UpFt0sHM/Y1oFhgiFDS4dsUnoVuGCqiCrNfrC4FHf8OlDoTdLINqj9nR756VrBWwSdye8E1NLlOFBrjxsrJS1ugfwOgaovbDqctqifUEPY+Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFJivLMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFJivLMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8311F000FF;
	Fri,  9 Oct 2026 11:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544230;
	bh=eN1SzLngRtnAsZijM+rMfElewNKbP17Ki1zPdnogbwg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YFJivLMNnsntrkWpG3pm+LcOBm9Mvf5qoVixye7RyiRX+Q4i4qpQ7aphkMm3E+B0G
	 jRin3qERm/dUURNpHqN4opeYeQk4o0v5I1IAs+7MYzYCWKWKfB5YehgNwXGj2NM+9q
	 K305vWgZ+6nSaSRjEb6tMsVccYHlUDWpIkwAABImddS6hQc1+Z0qVcAubnQ1Tq0LC5
	 bEYM3+q05y0h3wQsB6/rDpCLwVQmSw3ifkruiPyVToob9Z96XBjjv0l0Ei6iC7xfG9
	 +PvEHdKkAy39cXI0Yp1wU3p0zyeHLr7haKZYF5iwlkTQfFhVKkmyLza51G2/sXQkzi
	 ty9ExLYE5ZWRA==
Message-ID: <sashiko-outbox-165326@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 16/31] ext4: implement mmap path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-17-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-17-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:10:29 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce ext4_iomap_page_mkwrite() to implement the mmap iomap path
> for ext4. The heavy lifting is delegated to iomap_page_mkwrite(), which
> only requires ext4_iomap_buffered_write_ops and
> ext4_iomap_buffered_da_write_ops to allocate and map blocks.
>=20
> Note that the lock ordering between folio lock and transaction start in
> this path is reversed compared to the buffer_head buffered write path.
> The lock ordering documentation in super.c has been updated accordingly.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D16

