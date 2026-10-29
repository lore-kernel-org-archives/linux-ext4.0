Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281040;
	b=qk2d4bVzp5I0pg1T41x4Y8yNLHiZ9I3EynnF2ghhPlhqcyF7zS8m0rsGOOFlEwPJtpIz
	 JIQxG3x8hIR4FqKvF1PhynYyl0/x6lOOvSga+DIq5LW0h/wvAVm+vKkx5G3klfreYPntT
	 5RMTLmRd5bf+DZCdr92XRtvWvU/nKFTWgXBB9R4bG3nmBLEcxqxJFY/yShF/hBpXiG9ww
	 HAMW0S39ie2WRXENjTQ4Y2FcBMiGMtOrjGZxnnLYKsAhKdzy2CPKgeKHnh189RJ4ejxvH
	 HAauRziVNAgFTQyDUO/ol/B+A2s1c4c6VqFIU7jl6bfAUjVEqUlTB1dj4nVFDXbOIZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281040;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nv8rOw1XyRWzgmPkJDX1/6o6c3aovdDeH7bPKF997JY=;
	b=ZNZ7YRND4DIgzXGKYb4OFujWRNOswIT+YRTgV/lowSE9dK0c+g0yfNKsxhlK4RBWhiYl
	 ffGhb9PgRvE71LNKuPrOxhUGyMB7UYKCF+tYWiVghihuQfl7kbzyz7cZF18A4nOOYHn14
	 HeH3ubctRsIRXJxsFttPjAyLvLijVvWgNFDfsEUEckqDPMBR+E/kH5DfG8vRppER5wzb9
	 zoCH5uNRK/R/kf2KRCeEyi1ZX31aKjTyFSj4gQDU9E70k+N6hgezNgXhmgqtkTZAu99sL
	 drqOHi6dqILjz8PGnrGBgdbtwPPFLJ311ZlDEXoTdwSvg2QIeLxLpVPE90tmtXZp+PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CL0zAsIE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FE4606A330
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CL0zAsIE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0891F01240;
	Thu, 29 Oct 2026 13:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793281040;
	bh=Nv8rOw1XyRWzgmPkJDX1/6o6c3aovdDeH7bPKF997JY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CL0zAsIELERuZdxh0w4V8w/lam2V9tB1YMk5nn8gnpGLBBaoz1GGwyi+Fu/EUG+Bi
	 E9uRVM3NJz6sChvExgdHGY4E7HJImGTHg1TPMLQmtXfv82P4dgKziyjYI8LMvZUAAd
	 0V6cDb8wG3isdoeQuh5Ue6q8U6RdXQvlGHgpjZg3ZQNXoEp7ghsCGiTpUw9ddvRK2X
	 M61MiiyFBU6mBZ6sGran//NVzM3UuSu8p+/1EdFIVnzAP4WoiHk9yTePYnx58xsLq3
	 vd5szBHBaDzCxR5C0FFUqtd/ch/lR0VOtOFN1XM2QXOB2N6IKzZF4+Pp0miou6154y
	 rSggPzQO8RnuQ==
Message-ID: <sashiko-outbox-189397@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 8/9] fat: sync the inode in fat_free_eofblocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:37:19 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> fat_evict_inode() calls fat_free_eofblocks() for a linked inode to give
> back the clusters that were fallocated past the initialized size. For an
> empty file that also resets the start cluster in the directory entry. It
> truncates the clusters and writes the inode with:
>=20
>   sync_inode_metadata(inode, inode_needs_sync(inode));
>=20
> Unless the inode is IS_SYNC that is WB_SYNC_NONE writeback. It copies
> the inode into the directory entry buffer, marks the buffer dirty and
> sets I_METADATA_WRITEBACK. Then the inode goes away and with it the only
> thing that would have told a later fsync() that the directory entry
> still has to be written.
>=20
> FAT doesn't have that problem. Its buffers are tracked on the FAT inode
> and fat_file_fsync() writes them out on every fsync() of any file on the
> [ ... ]
> there is to pass 1 for wait.
>=20
> Fixes: b13bb33eacb7 ("fat: add fat_fallocate operation")
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D8

