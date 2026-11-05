Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882814;
	b=G8+QHFIa6ZlSc8vOJ1F3xzYwnFM9yX1TzrSzP9hE1JWWiHKAfTScUUmYFYiIWMP2xHXn
	 LuN+wWOVwbWzSYuD6eqDB0EoaqRFEqN9XvrSVuIeqsKjwcM6sVMimP4KX4W10ZFQfjThd
	 BWSRd5kBICpnwRBQO7i7uetkziLp3fJHMQOZwxc1+chIU9ObEHMiRciUBKo8lcG3sElNi
	 aPisWHRhBawikpdbyZZrfEP8gczynbwd8PJTVrGu2DAq1q11lqyX7oSaG1ks+eT+2gxmx
	 ODEBqZhHvruQkGIsYca51BF3ZhWDvLqttDvu8FJethbFSIuBQWynS1EAGHN2GHlJUHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882814;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K/mMl8wJsNiT/ZUqjAlv/UWGrx1OCbE5GoMmfuDHfsg=;
	b=W+zrlv8xKL4/Y8N120oU9/92QBCwRqlLhPBsn3Pld2viTuwoj6AzpY3IKj0YNQFhXiZK
	 6JMkGaVwi6uGSlRzioNqpI89vUsb50SWEhMKwVY4r5ym5eghQN7FNJw1b9o1WrvZzHIDR
	 SSWZKnenbrnyg9TxpKuCXYiobV8bw9ADEyaz6/nDPPNOHz8n0zxzHj8HIvlygJhTrRAkG
	 9yJhOIdy5DVz7BpqCntCqz8OdKR+mRdAYaWXgnQ/7ZOSljUs4bInQA/FkmuRECaatICEc
	 r9Apq7xGCbVwfIAd7xBCW2aSGCy0329QQ57XIFSHhE0Qe+wFj0V3SD00sCpTxgsymkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gkZ0Femc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E388606A328
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gkZ0Femc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F05C1F000C1;
	Thu,  5 Nov 2026 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882813;
	bh=K/mMl8wJsNiT/ZUqjAlv/UWGrx1OCbE5GoMmfuDHfsg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gkZ0FemcsCdGfNXVwGMPt4pq/BwcvkWpok7AXdPdETFsB5rl3RpLqvJRP08t36Bdn
	 uTHKGl+4F/o+7E6aQG3NriM1LXg5AxfwkACWODmKBCm5J25kaKv7L98fsfxj3p/sl6
	 /G7By8TwPodBca9swY3ikniFXIVNt0/F58iq9NKtPwhPDQ1ulx7B2lmAoFJCJ4FFYO
	 NHko5ZllGoOyVdovQ3z0WhKTjeZN81Qp3RfO7sT2it44LC6KfyMXAIvnqtKjEnctZI
	 Ask+4KhJWDmqQbzZKM5Aw2FWdJPnE7+jn1BZqfwKnCJjGqdGoiz8UQ1RwGQ8LMv6T/
	 kNkcnm3JaEd2Q==
Message-ID: <sashiko-outbox-199057@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 09/13] minix: sync inode metadata in
 minix_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-9-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-9-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:46:53 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> minix_write_inode() copies the inode into its block, marks the block
> dirty and sets I_METADATA_WRITEBACK so that a later fsync() writes the
> block out and waits for it. But the bit goes away with the inode. If
> the inode is evicted and read back in, fsync() finds a clean inode and
> returns while the block might still be dirty or under writeback.
>=20
> Right now that can't happen because inode_lru_isolate() never lets go
> of an inode with I_METADATA_WRITEBACK set. That is about to change.
>=20
> So call minix_sync_inode_metadata() from minix_evict_inode() for a
> linked inode that still has the bit set. It syncs the metadata buffers
> as well so it replaces the mmb_sync() there, and since the previous
> patch it doesn't read anything from disk.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D9

