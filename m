Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280908;
	b=1Mpw7GZl++WvPvYLab4AQilK1vSJvQzF73A0d775Xo0z5KsABd/xFVnNe6sOs6dvTrUP
	 USXXXbzHQAVw8XwJ60o2LZOkFFaH7Gm0Jb3aW+VYeIGekaECEMgAe/KtsIYiOwyPQqJnB
	 Xn9CJ2jtD6YvkiSEUWRGd00IKfW6JpF2fOSchTGI4S+bhLPCuJOTtJSpR3rgUGLCnAzIs
	 qAUskCkp4zXmqeHLA7So0VFh9lsgMN/gvqQFw+wu9Wj7bXdSLCc5ZX+MIc3e1126RTmAW
	 YSMb4ciMBWzBM42jZj22BXxu5fZ0QJODhcsqz8OGavSZo/NMzPQgdQQvbW+e1wfa9bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280908;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2/8640RaZbf6TdWYeJdKycetgeHOsQGbDYBW9YxZAL8=;
	b=nOlLmodBOY/jvEzDLqu38kPrCN5gmxNBv17itXFzf+Mp9b6Vd3Rzf+L+ofZ/L6XzV700
	 2E+nci9oaqYU91LSFd4jhQtmUi7E7mmCuL2vlBuOizanJLjz7uui1WG35KvOHNKybLTaV
	 DAzNd7NFFBrJg28z5X9Pcy2amjd/zToCtLCGt5GboSE6UrvbvVFQGGi7ZjRNJ/rNO6S4M
	 YCp5qmiLXHPRuti3x8aD1yEgq3K3zZXTuP1et1vNgz7YjHZdarrNtM/wJGgr8nQH3pTW1
	 gmSJ/fhmeo54fnQ3Y1NBDkfNJH3n0BkwKr0GjJIIYzMylqkyy1AUzEnFOuC72ZtdqbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gJtks78N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7061F606A325
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gJtks78N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A811F01828;
	Thu, 29 Oct 2026 13:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280908;
	bh=2/8640RaZbf6TdWYeJdKycetgeHOsQGbDYBW9YxZAL8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gJtks78N7TvWtxdGmc0hqWJXGXQ3N5UZDoDognqh/IEA6kZmXp2bAI4KChJB3BJoc
	 qmcR/dGoMGzFt7hY5rwC5kl/5OrOjN7r/YHKyNVuROqHRuX7Y6s8WmjOfA9ZNuy9z9
	 rnkYQVTns9XsCePHaw554gtbR5TVR1Fyf3FjZ212ngso7fnwqTcf6qDoTCM1T6Wi9D
	 C9qrfnYnsZ0bzZswuJDwPLcIwy/l4catBHTsi7p+pfYa1GQjjR203wTdufKjhfM01X
	 LvkAw0Awh5AuHA8mjtC8nH00UVjHmf7GfP95oT7wMb4opa8Ll5cgz6GQk6UfrCQzJI
	 gi58VK5FQT+xA==
Message-ID: <sashiko-outbox-189396@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 7/9] udf: don't allocate the inode block in
 udf_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-7-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-7-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:35:07 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> udf_sync_inode_metadata() looks up the block that holds the inode with
> sb_getblk() which allocates a buffer for it if it isn't cached. But a
> block that isn't in the buffer cache is neither dirty nor under
> writeback. So there's nothing to write or to wait for and allocating a
> buffer that just gets thrown away again is pointless.
>=20
> It's also not something we can afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D7

