Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243766;
	b=CZb3LbAmFUHzdmn4UUMZkYq9VNnuT1wwxD4iTEuVgPZAsZT7GqNVqR/t8ECSp5+dR119
	 4rVgjNv81ZsB2/CiygDOW9ZKD859qZVJJXh1JG74THK+nnwL5Sbfhjnin/OgrrLMwBfhK
	 Zusf3+tku5myHZi0mK0koHDOD7SMZcp/yTSceMEFTd9oi+Gdt0iCxPJbt4/95jWIyb8RO
	 V2rlYXlm+uR7kwo11tOqLWgUfUhVtPigFx9WDmcvgZE3WIakbeawcW4Hwf3dI+uwWPzQ6
	 R0WyWT1qei2xWzbVbWPHQgSRb/qPB9Uyp2r15Ir032Cp/PpZhx80vLbyuZuoSJM2URQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243766;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=djjiC+Q2I3DOYprZap7iG6c3XjO+UNQ7/gzdTd/2PBY=;
	b=U1bCy3sUi6MbDs4IBKSAyxPNRsyyIKo8ZlaTl9anHFD6oDpz3Oc/DHCHt+l6oUduoPKt
	 1CA75mscnFGtFoQsm/mXuZXRtIsOaoDrlBAVFd47ZuVvqfcByo7L3tJqGxT3AiH3eFula
	 JEhbenSxo4h3+jQg2wOGATPg9mY0FAEDZPuDNizTQPed9p4ZAIgndDCchgYEOWXn7AqBx
	 gTP4N5PuZpppg/kg+44D3TtleUWaX59e01Tj7iF4uRRaZRuBwgX74JO1wwibys1OCsYQc
	 kCuJ4jeGGMKiYyAxrJJUrz1mOeKTQYJuX0Ix7OmGYVC6DuNLtKYGf5r3oj+8AGMc1yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kl7Z5qFC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6407606A338
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kl7Z5qFC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3031F008A2;
	Mon,  9 Nov 2026 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243765;
	bh=djjiC+Q2I3DOYprZap7iG6c3XjO+UNQ7/gzdTd/2PBY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kl7Z5qFChx4Lds8ITMb01IlmK8aMdl4TUZ5IxNLg7PZZ+Sucxuy94eR07dwhcZGm2
	 K2nK+WIW2mq3vQufC+rPbSVLq9os+5vy1VYQP+kReGHMG/Tzk1o7QLdiwZrufT22dN
	 giJrmmLaBGtGgF9xB1/TPkdv5naeG6DZypiihZCuvsEzLLqCqcyu76pW5q6MJKLv2Y
	 ecCSinD6sp82AerWOTC0LTNY6KsG/U34WdKTr0v/szWjmvqdCJ+aSiekAX+EgVWtb7
	 Ka4lGp5guYOlVjBJkoq2RZODIvKKu7f7RpB/DMKHRxZb4ty5day9mQXRv5Ixw7qk2s
	 u22yGVaZNnLgA==
Message-ID: <sashiko-outbox-205261@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 02/14] ext2: don't read the inode block in
 ext2_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-2-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-2-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 17:02:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext2_sync_inode_metadata() looks the inode block up with
> ext2_get_inode() which reads it from disk if it isn't cached. But a
> block that isn't cached is neither dirty nor under writeback, so there's
> nothing to write or to wait for.
>=20
> That read is also something we can't afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead, the way fat_sync_inode_metadata()
> already does.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D2

