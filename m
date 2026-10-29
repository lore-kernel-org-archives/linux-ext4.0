Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280816;
	b=u6v3+BR4JVQYbyazN/yUYuf95sZlDa86vvnUi9kabkNGiVq/5am12SY+2zBJ4kPHePF1
	 CEJ6tJWjIongh0SLpV+9j7GSkSPem7GiXZatzb79XiW5Bi0jxBxyQKorFlqdlnvRdpb3k
	 zA2jUUiefyQyFh+D4Xr0CzdfQYhnycpyjYCV0J37yk6+Mh9GyU8xwurCdzgYUhdY9LOsk
	 Qkj3I+JoCaKFi9axC65aoUAywHVarWzAfaBUcIPieJzY1iWJLZD9l0nwnFpXO/T0gZBNQ
	 crfz4JyyOLKuhney1HE/mnp36kdqIkeRNtrKx/+t+hX9lzPnDBzq43cpsHe80/fKejA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280816;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Sh9w518KTw914o+uGE0mwqfdbqOcpHxxDvFZJop3hE0=;
	b=eiO///EN+E6dvc5/upafA/Ikn4UdYn8X1ljIC6g707gEnqLRvmf6Aqm1Gc8SMBmSceel
	 lu1wyiIEVbm9o9YblYT9tCsKdekYEjh286I94iKrYV4I/H4886Au/vTWG7A9pidUNJ2lT
	 sMukw120QpFVh9FqSm/c7dwVlsqQXeszc7qjjFRMAcnhE+DQ4JguLE0pIAAvQX+nDlFcR
	 67YMQja6YhJc53uQctJNqY8LlhbpImk+wTHc5fLIUDifY5icjffgLkccIl3oEplpoZ4qo
	 BNahmD78u3M4bfiY+NtjPM8QWcZeFwKpVlTF5VgaZ/KSTYCjnpNYfKXDmoKL0I4JoIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHOHya24;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E645B606A31D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHOHya24
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFB51F01825;
	Thu, 29 Oct 2026 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280815;
	bh=Sh9w518KTw914o+uGE0mwqfdbqOcpHxxDvFZJop3hE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IHOHya24yWcm6GGSMV6v1bMWYsB55DLgV6w4/kPcQ+ctWjqOBU5btjTxHuKC8cAIh
	 4BpKY7Lxp+G2s3/K+Ybka2TDoVQWJNZaRHHsoERqW5DKXlTa/mX81AZkPBX+1j9QgU
	 P2/K97aJQxZXZsgWivzMzLlLFIPHDklqvNerQk3EwBDmSihQINvE+iY7txQq+bd9VA
	 51fmgc1uTlt6hST1au5DfWTeAamJLWz/4E3Gd/w77Z3lMFY0UxEjll+xa3GGH7DjIY
	 8uIT10k7jH3lpFqzrkGqsIVFHZtabJaWY3RYqKOLXWKJzVqfRO9Rsv1Jhy4VIdxLWv
	 ephyRjdBPjDkQ==
Message-ID: <sashiko-outbox-189391@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 2/9] ext2: don't read the inode block in
 ext2_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-2-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-2-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:33:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext2_sync_inode_metadata() looks up the inode block with
> ext2_get_inode() which reads it from disk if it isn't cached. But a
> block that isn't in the buffer cache is neither dirty nor under
> writeback. So there's nothing to write or to wait for and reading it in
> is pointless.
>=20
> It's also not something we can afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead, the same way
> fat_sync_inode_metadata() already does.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D2

