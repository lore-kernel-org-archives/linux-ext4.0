Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794555081;
	b=NxDYhKoidDcMWjePcrQAFF6MTjehtOLiZ+inh0emt9fMotW4CfvcsTjbU76DHLtFhUcH
	 ildl9m3Kq6NCHyEBFBtftlZRgJjht0FLuMUseFlkR/LJTG8UNpWyNowG4J3+cNkdovKw2
	 cmE3F4TcXhYfP4uEB3yo+PbchEKnn3Edgscvm1seW7psn9fVdbrbEogMMJGDpjrrO6Hbo
	 I02Zfmp2yR68dMyRrIEHGaBQrV6jpBX9RLvrf5c1apAzNs4r7sBCfDFwTH5X9tIgqbo+T
	 Dkws1GONupDm+dQbR5HCZ+9psQRyO1+60q3FBRXEmYTCR1IdarkVC12u138t3ARVN7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794555081;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nDa9VAjgxa+4n9LCqghzIHGgKUlaBKciWRqhOdkC+3Q=;
	b=v4FFXomzP9ldO+gEq5GICGWYTUAqar49NX0iLcE77y1q6LmSvLmMqZWRxUjdr3CiqQf0
	 ZoqMWX4DJ/1NJd2A1ielxbtyxmcBl/Njg/toPy04zqheXLGBDxZFPl9ggbCO06jZxCS8S
	 Y9JfaFSe01b1oyKJhI38FhAsklFukJcqo+xm9ACoTWnMcdh3qFagR1qvp5wtBRTlTTI+C
	 jc6V8FCE+deGSCUlQjE8si/9b8fIH6Q0vh0Dkqc1Dzn7J//Dbfp6L0yeIj+hA8X70DX/j
	 7uNjGJalAotARCgGSnx+9luN3m1mHDVBwSujDrnWw8ZvqIOgShdlE9KLuvhCRBMRwYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQpY08Z5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E3B606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BQpY08Z5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219AD1F000C4;
	Fri, 13 Nov 2026 07:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794555081;
	bh=nDa9VAjgxa+4n9LCqghzIHGgKUlaBKciWRqhOdkC+3Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BQpY08Z50UPXdCv8PkcZtUlkQUqUePfxza7Fxu6D8VbyLL5LgSVLu2CeVxtyUM1GS
	 PECmnz1cuxtxB5uXSezZiti0K6n0uMrwaqaRR4IMOXz3g3n8rD4T7BhufPs4K7PgYg
	 51Si4VVbbw5sD1SEU9PRUtMEQRjxJBtTYtcYOzkizWKOeqBYkSDHzT3N5CYgSceof7
	 usgUVUjNnF8w2vOLzYnUAKErlEPf0xv90vfQUEvcDLnR2RXRRqwj42LEGL5DEoqLNm
	 W8FZPbWD5tOAN0BjTlQCsidtaUWnfTt+zaIZC5PIlDpcLSRqgTPZsKXE0YkElRLsLg
	 KxTZpNyFQSPAA==
Message-ID: <sashiko-outbox-212352@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 2/8] iomap: add dma-buf direct I/O guards
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-3-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-3-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:31:20 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Nitesh Shetty <nj.shetty@samsung.com>
>=20
> Direct I/O copies data from the CPU in four places, zero-filling
> holes, inline data, bounce pages and integrity metadata. A dma-buf
> iterator has no pages behind it, so refuse it there.
>=20
> Reads that encounter a hole or unwritten extent therefore return
> -EOPNOTSUPP for the entire operation, even if I/O for an earlier
> mapped extent was already submitted.
>=20
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D2

