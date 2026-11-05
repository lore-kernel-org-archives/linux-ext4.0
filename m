Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882944;
	b=Fq70zF0Pop19UtAEHyCcroouqg81jR71xc+nqnQsBaBIuDKTfsbBBEJb+u1drd3UX4JJ
	 mTXvo/XErsrBNK1hEw9T5MY2fhMj22jjxsCwE0aw3QYAaNhD9E7YCrLlejqeZDAOfBx5u
	 2cFoBdepHSgKGyDw+IhkAtu/rgQXdpQjn5A3w0ACr1bufzI1s41u0J7Mtss3IvNPUWxAg
	 OU4LX1XkblO8oNgIe5LhVQLugQeyRL6I2la/93zo51NbrI6eX+KIyPzmZvV7sRpx02XtY
	 vYFkcRbbliXN1ZYiFFyc0cevL57cj6ZoYTdCr5dQArpUuLvA1Le96Oqoz9RwQY+HavA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882944;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Moa8e6fJCMOlrDQcCRLND5lskhuhsQDihsLb4DjLfio=;
	b=b9wuglf1nGbLG9esRxCraX0aKfBBVei3qFVKEv0bbN3o3Nx+fbCQlve2VbbtAgO4fRxG
	 LAlE0muxfO+fNfSgK572ovpWPJJYh0bKlLdr1DJLNldoTs88yzJs1q32irV+FkpzrOkI/
	 U2WIpGbBXjeObralOppBHqa3e8WQkZN0spr99eYEM1dvFYQVyJIxVQ+4hVLzkdq45PGHN
	 NMz1DGTBRqDVGrMWzAWGgxy/pOsT7Ji+X/EeIvJ3ChspmRm9JBLoONFGUN/DGzlR6SBRG
	 QhLFPqW6r9qH4zqx3Thx6w0bHybW4XxJwmxHf6B/fBAv98WDA5RNwjbOYtf+ZtkEjrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AiJ80jta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF291606A329
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AiJ80jta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372011F0093A;
	Thu,  5 Nov 2026 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882943;
	bh=Moa8e6fJCMOlrDQcCRLND5lskhuhsQDihsLb4DjLfio=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AiJ80jta5ts0Pch0qN1pZSFp4Acev0vGke8N6QDwp8tRmRkzh69XdIxddIjyLtTve
	 FCekb4ZZRCz30swbCt94WJeFHbVD67IE2SOYcXhR1Hu37aw+dUYJmRnMZ5WiK0+e+D
	 pzgcI9uM9UtqvZu4hgowACkStMZH+ogy/NPD+E8BeRxhTu8TGnPHmrDaqJA3AXzuA2
	 zh5XbO+UIsgPJnNWS4GXRL918HzdAWVkcm6T53cchJIXgNtshy0zgH2eccfb8yJP+S
	 qZ6JwUbTsJ4bnBaWkHt7YibcMzeTCRG0nVK6qATdnjdHhG9FHYRArRIPbN9GZXN4ny
	 NLeuJV7BlLLYw==
Message-ID: <sashiko-outbox-199062@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 03/13] ext2: sync inode metadata in
 ext2_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-3-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-3-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:49:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext2_write_inode() copies the inode into its inode table block, marks
> the block dirty and sets I_METADATA_WRITEBACK so that a later fsync()
> writes the block out and waits for it. But the bit goes away with the
> inode. If the inode is evicted and read back in, fsync() finds a clean
> inode and returns while the block might still be dirty or under
> writeback.
>=20
> Right now that can't happen because inode_lru_isolate() never lets go
> of an inode with I_METADATA_WRITEBACK set. That is about to change.
>=20
> So call ext2_sync_inode_metadata() from ext2_evict_inode() for a linked
> inode that still has the bit set. It syncs the metadata buffers as well
> so it replaces the mmb_sync() there, and since the previous patch it
> doesn't read anything from disk.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D3

