Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736790;
	b=G0Go6g4SEsd13LgCZWoFLeq2EiER+UWQDG/DiE3bmal9NCLEfstIwrbYY3syWfD+vKIL
	 oL4AFCSIA9hl31+Etzy9UCE3XVZ2rYT0q/6WSe00tuheTTZFJeATQncLGtIzqjxkJqvqP
	 qsnN5dckL+vF51tRsJKtPtAy03Ze++R24nzAJkoJ+Fnxu5j31FK5UoCONvPUa83xYZ9u+
	 bSegJueeARXD7DMFIp6Jiw8rOvX2EBybtHWUa1uA5lDcK+DUk0JMO8jUCtwvfGpU5O0PA
	 J/hUksfUyERiaoyr6INCdK+ykHDR/A8jyPOaB65mt1x84ryfykcQGbeTK9DZce5FGXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736790;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cn+8PDRW+MZP/ZN35I8xV3B+70nPOJ8cTAhY3Db4rFE=;
	b=GXC48AGsZOIEz/jGQ+qzNzl0uk1Qp6uI1i9+qWazNei3UowA391ESFGT65f166iH1WiY
	 /vTSLjDd7p5HRyg4ZY4ZSa86dW9oscWxQonuI0myL5wki/aHpH7JGlv3iY/HWDNASN1EJ
	 wJLegBdMsMt/EbSHtML5iKyfktAonpsgfOsiV0MTVj3ULzDnwaFLnACsXcTdMriTOjF+3
	 U4lP8ollXtoFmNSAVq9LYBDmGQaPkqKIgT7WxZ6E5Q7T1sB0W+VzIeI3uX8x1NfnsLBTs
	 IZ32BXAnbP9t55/Uc12Rnqk/MdRH6aygK9TNYp90Upr8JfwUZotSpzAt/kABNgsRk1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Z//4820i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FD5606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z//4820i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC4C1F01825;
	Fri, 23 Oct 2026 06:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792736789;
	bh=cn+8PDRW+MZP/ZN35I8xV3B+70nPOJ8cTAhY3Db4rFE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z//4820i1qJn+Nu6ve4ljwea2RvME626wCwFn9q2mQs+gyiw5ZENd0DY/WbyLD0Sy
	 MVpNUzlFgOzpePyOM2xvSvlS1nkLgJWSr/vEcFUeq0SlG3VXFcqBHDVajWVyBqODbs
	 TXZqShgEGfBEUDRS8h84Qbt/dSla4MRXI5ji740uWGjWVIehHjeXpm/7uIGz55gjRS
	 QOowlmuXPo52Vey9lXAz23RjI4smzfkBZsS3lQDWeHwZV6vXJbdPhqfNLblYay5gF4
	 iGTJKY/9cQF9YHyhDvAbgWVuYB/tHSdnvEl/N8yRErgMQ/ZuCh2Sci/DpCjdZazyO2
	 FGoIjK99C/HGQ==
Message-ID: <sashiko-outbox-182347@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/6] ext4: report unwritten extent conversion errors
 to fsync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261023061851.45579-6-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-6-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 06:26:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Buffered writeback can complete data I/O successfully but fail to convert
> unwritten extents, for example when allocating an extent path returns
> ENOMEM. ext4_end_io_end() logs the failure and returns an error, but the
> conversion worker discards that return value. As a result, fsync() can
> report success while the extents remain unwritten and direct reads return
> zeros instead of the data written.
>=20
> Record the error in the inode mapping before ext4_release_io_end() ends
> folio writeback. This lets fsync() observe the error after waiting for
> writeback.
>=20
> Fixes: b82e384c7bb9 ("ext4: optimize locking for end_io extent conversion=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023061851.4557=
9-1-sunjunchao@bytedance.com?part=3D5

