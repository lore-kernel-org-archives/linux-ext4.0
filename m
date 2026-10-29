Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280852;
	b=uX4bsiOak/qJRyR3YaZOheZg54hdlNRIglXG30oQ9jLZZK3pJi9aFoSwn7VyGIuB7blQ
	 HpYeWUF7Hqii20tT71SgS/dtQ6uyuk9XHlnc3Ftjkcrr3FS3fNdofSDVdLRAkvPkoBia3
	 VuPIepPSSWRyz7mlPfPTXqkY6REbaV0eEdSRMzfSdV8eAAoqSLZ1TmHuQ1+qT4Pe4TZoA
	 8xPOC31RKLdFVEYPiEp0nDtB9vXTJj6R/XMX1hEFJpc7GyFzd4TBLD3gZtvYcuxUkR52I
	 wysKKks9d5Wlb67a9NpEM3PfT7I53aMjVOKhm/m4gynRPGlZ9f47JPENBtHHp9h4TcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280852;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BrjbhUE3Lk64mbF9WVBlM+QXCFFQl9Ca0BDrP9qctY0=;
	b=UMMUdgzCenggdtog63OE4fi5nXFvrbrk0VuejLOFF8cqNvRMPC73flTslpQbtA8wopqr
	 w3epm009Q2aBFNMgrrkl9jutBmXy/z5HxbbBZ9/kxbW/ocRDHGpDlhIN3sa3oSLS7iCqA
	 FVPoxBsHSt4NgxuiWL64hJ3F6YT4PDwTpJ9IxC2DFneTDouxWrljk57F++3CkxDLiyfYc
	 BsWFaRiFy/LxomTrlbEIQUinqqkkUG592DUMqZHW/80DhvFNZXn3On2I9/RJl/e0zxOaD
	 4nMj0FnQhdvcysnRBS8WVrpvH6U21t2k1CUvt3rKQx+31PHhHMCQvuSjKeP6JkvSw/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nntSbmzL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC6606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nntSbmzL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8021F01825;
	Thu, 29 Oct 2026 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280851;
	bh=BrjbhUE3Lk64mbF9WVBlM+QXCFFQl9Ca0BDrP9qctY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nntSbmzLjiTSiUtljPRP6tx2iub7unPBxkVmlPUj/BxlD0zhzJ0oKd88E9P10b0so
	 18Z29hGP7FuKexQ7dsm9o+LT+PJ6iSnECMzYCA1iW8HadVu7t/JHg/J/AYM322p9KH
	 pj+FqSoJh+1vyk4aFJRgUJxyNSemzH2jJ/9LVK05C4ruaH0RByN6f50DVKyxkSP5Gi
	 59u03mF1RRY9vZ5HanlgB7vkrfnUcCsUdY9V4b4+q5JcZResApWBV42uxtcgWd1aEb
	 9VhascsPpHZrvCahWxDKxB8UaisNZo27E/aO9S3qUAZT3cpiP5KlmhvfOQNkCe7aqz
	 by2APqhN6ljWQ==
Message-ID: <sashiko-outbox-189393@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 4/9] ext4: don't read the inode block in
 ext4_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-4-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-4-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:34:10 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> In nojournal mode ext4_sync_inode_metadata() looks up the inode table
> block with __ext4_get_inode_loc_noinmem() which reads it from disk, with
> readahead of the inode table on top, if it isn't cached. But a block
> that isn't in the buffer cache is neither dirty nor under writeback. So
> there's nothing to write or to wait for and reading it in is pointless.
>=20
> It's also not something we can afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead.
>=20
> Note that ext4_get_inode_loc_noio() isn't usable here. It uses the
> atomic lookup and that one gives up on a folio that is being migrated.
> That's fine for a best-effort fast commit snapshot but not for a data
> integrity sync.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D4

