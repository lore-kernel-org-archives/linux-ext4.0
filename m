Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794251012;
	b=uuzcv+POfKtT9R4GuFmf0Bu56h4Q3FdGV072COcUMLHPh32Z8FibYon9LE90zcPC4Q+g
	 AbOa8qUxw38zpt3l5ZeehjHcS7kDvVuHeDG62ZoYs3y50zvjC/dl7SX7XdDosMhR9W4N0
	 D2j89CL21ExAAifOBqZzN7F4NOvQR0a7aJHxrhHSZEZ7UrKVc/zSxv0aPdU/AWJ+kqJFo
	 OME4vDG4qs6Ra8TmwQsIWJkhWc5ocQIfGjS/etGIaOCpxpEuUAZlyuD4kj1cB4obe6nIj
	 Az5duyIT5z/0FDVwUn/Jc1+jALY/+M7HMsjZfOyVKYg1Cs6gO5zhvf/PwIYq1GB1OhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794251012;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T+eUoefgcB/LIP3ZnBMIySsgceF5PqgZ7u5jaC+MtIo=;
	b=08tlxwSHMHbmKW8rgh1UJgvBJ9FeNnFvsdh4Ndbl0AQHInRARh1Kh2McSCdhztD/opTk
	 Cg3mbg5wyi6NJsRjRe1pXELZoznSFdTTopLC0SvkiNmZqDBXfHpPrGZwDiulkSMjcipED
	 4XZKN2OJk6Xr8FLOznkMDMGmq9+I9v5+ucY9FTXQF+Vw7RVWBcGUvr4Ayva0jF08X0Jce
	 /2W8x5Fjh+6mcgL9JfwxhsIKLLpnGwMC4jTm4lJj4F0lklURrxv+s+H3GAlLJtxw8O8OH
	 F+TMCJxGe2PsDiGbeWTWTDLqREQm/fh3QZ9xxeuxstwufmKFdAt+O6OWptpa9T8dVzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dm/kbo1a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8CD606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dm/kbo1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF0D1F0089F;
	Mon,  9 Nov 2026 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794251011;
	bh=T+eUoefgcB/LIP3ZnBMIySsgceF5PqgZ7u5jaC+MtIo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dm/kbo1aNEgNcKYyRwOxtkoaJ5eCreCMDfyyqdIXPTvye7tqwmT0CQ/TXC37DHd/r
	 LEezVU4L3Oy+ijLBFqZVyIFjjgEjknjHN+jwB3sVDMZCfohkBhkn9TOJ3Cjkz86LDf
	 EyMnTPb9J66aIs3PEc7zigK/RTlsezg6J9JQc5oo9rCUOieh4lns4gMvUEcR8T76kc
	 vGywsFEVv+F3iQIZJo92sIILk8MhMAG1SHsjwRoqk+24AjObjQd9+0fP+tZXbkfKMi
	 hf2O0tSKJqRj3IQo0SEbOu2dasItYuAlZRkajN7JWjF1kj2GxDVvSndW721ihahStf
	 89rrbkCBrIMFQ==
Message-ID: <sashiko-outbox-205455@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 13/14] udf: drop mmb_sync() from
 udf_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-13-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-13-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 19:03:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> udf_evict_inode() to sync for an inode that isn't deleted.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D13

