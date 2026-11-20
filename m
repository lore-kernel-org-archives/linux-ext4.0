Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190466;
	b=qZzAhO/k0UXUl4XQgsuvniFwgZaEvGA8iQ/WAfGMpaXig6V+y/mc49Mq7mNpFYlS+W/L
	 oESF1L+JfQz02HXRgXfAKzmaZO2hWcStm6Rl4SwEDOkOmC/NTRpgeimHKwtr3LNEmzVmW
	 51mkKPtKZwak57jI6O7/7MDSwA2gN5hCqZCvIAKLVoH4d0t7gz7DiL60EZffcWmj3+B8h
	 mJGn3qV878qyQSJMpKWvSZuNOgTd8y0IZ9igxBUAYxfvnzWjx2YfZVCLHHOhBHtxy4g+q
	 wfC2y9mARH8VUINLHLmIG7L7magblh7U2Ccmy9B+bTEJBFQmAEWPydFzggJZzDBZRNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190466;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=V2SqnhGr5XJ9Ex7VePEI1fy379fETPdmLIlLiSX9qrw=;
	b=Gs5Ay6GhDnxPz4PJpOfqeQHH15G6FDIWEZz2KRRxnJ53Q/8ZjXv/fqwo1iXSg60ex1ec
	 usdc4YTtkG30MfHd832hYvBghpmI9iDdLPgsVWDXa4899kqtDC7RnuJr/NrLxMuGqhKz4
	 ETYHBiJXQ4S9B2Z+iJiyW8BdTVqo2y8OTxfwiQFYrLiEmGPYLcvZH/+wPWYd0Oxa+RE9S
	 Ysd8Tw5svyw9z0ba3gcBwRnwXr3Kcbq9RbLxAGSbuN2CQKlBzgkMrUWi5A9ogAgqAoJ9z
	 MBHR7yXIxiQ5iQi66steRKnuAveZoA0b3Phso7pZZZlDOqHu1oWlGoY9B4RWkHCe2Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OeNtgdom;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450DF606A335
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OeNtgdom
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15971F000EE;
	Fri, 20 Nov 2026 16:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190465;
	bh=V2SqnhGr5XJ9Ex7VePEI1fy379fETPdmLIlLiSX9qrw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OeNtgdomL3Q50W2grnx9cnFbL7lVWnEoFsz+qqZBFE2AjkMdJfgIfJPPopSy5ss7T
	 ExU3hasXMzBIxl45plff8dVYyc23sMMOcWBvCnCFuuFDmflS6ChdgBkV8XzoPI2duI
	 ww2OXHFzyndkRJSfyPK4VSmdj1tgXjSwf2kj21V7iLBFdS+IcwlHkCflOGY7OKrnex
	 LAqpibN5alm4Mxf0KU+6bK0S1U6r1yfDfjib4C9K50VEWlRKndd5AVIFtJpubu6W0U
	 WF1t/91V1NRCLt6fzzF7IONjDynD3iXWrC5UwtnhhqsGEHhI2bjMIPgbNHh5vw4a+g
	 KXULMHII3/nQA==
Message-ID: <sashiko-outbox-225507@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/7] fs,fsverity: add I_VERITY_BUILDING inode state
 flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-4-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-4-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:01:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Every filesystem that supports fs-verity keeps a private runtime inode
> flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
> They all serve the same two purposes: reject a concurrent enable with
> -EBUSY and let the write paths recognize the special writes done while
> the tree is under construction.
>=20
> Hoist this flag into the VFS as a new inode state flag,
> I_VERITY_BUILDING, and manage its lifetime in the generic fs-verity
> enable path. The flag is set after ->begin_enable_verity() succeeds and
> cleared after ->end_enable_verity() returns (both on the success and the
> rollback paths). Add the concurrent-enable guard.
>=20
> A new helper, fsverity_is_building(), is provided for filesystems to
> query the flag. No filesystem uses it yet; the per-fs flags are
> converted in following patches.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-2-aalbersh@kernel.org?part=3D3

