Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191217;
	b=AzkhRcw1x8n2lPBNGCqcN4o9gWi6KZiLTryhRfDt6jD5hhOFTCpWhdq+XOspRvxeDEym
	 j0zEXk82ULMUiFhwdTXaS4sHgC4xB//QjQcjbO60uH64n9MdtwZQhoLPsiwDAqR6TiYvz
	 u2yRMOWpVspaz6REF9omXRJTvo0SC+px3Kvaewtdg4286QsbukM6Ad0CQSmccjenuY9nq
	 YzbIoLDJ4vNs8p76VFwxciATPmNX2xcGV46PMd2uE6fPSrWYIQoMxjrGxf3AlkwGSo2f3
	 RITlOKOz6icq1qsLpGmRqFepWqzGp7UeLBcuVFGSFb17EGQveuVs8cVNnd+js5MhDMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191217;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N0o1bcS84DgZltNA7EBOYuRyozHI1j4cFDkrEXpTiN8=;
	b=YjJ1Av5gVXgBLm9NTSyQZ2PPSbqEWFGwlW6UdjSE5EzNX+L3vK0b5n6VB45P3ADUTd5K
	 tuAYnYZw7lfR7O5XWJzVcMKEOawbtAuR7pI7ZljlJvoLbT7OA6QVEvMHQYj1FhzAgofN8
	 4acpIkpV/Frp1vSVCNkeZXNPsC6pTtnwe/2qXnrwrV42WwtxtthHQZqAEwXh9SstCpFcF
	 8Qd7t346Jlr4ipdyvJ2HGmrEWZAeFInuvwlAbSf7iYjYI3wCSHqmGypZzC2lNBNXUxQkV
	 eyJ31NJFNA0m/Cq30jhUnccbS4VBekNSCExloUwoxnzC0/oAjeXOyiZI0YQgmwI6nnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VcLfmnKM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59D1606A335;
	Fri, 20 Nov 2026 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VcLfmnKM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DCD1F000C0;
	Fri, 20 Nov 2026 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795191217;
	bh=N0o1bcS84DgZltNA7EBOYuRyozHI1j4cFDkrEXpTiN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VcLfmnKMzFFY25wXsY5ug86Fsi94C36PZelKrcTANyaesCg22ekVEFov4ehq3cSdx
	 i4Ut6WLDMQO98meXKOQ7VTZw43UgHasGrWnT+pB+qhGMa0pIxQTVdJF4rr70xfnmjd
	 GKVnDcIN2+Y63WxMunK5I0z6lpUAOQccMB8A//Pd8Z49LwAGyhc8s1fFfiP3N4Gm7Z
	 EUZxqCx9+bPvAE79HLhAGZIn3yLE2GNfl+9Y5RlAn/kJdGYrwZnxwjnSX2pT8by6Zb
	 IGNR1pQKOdigBPNjdsA3M1wNnuEDgOq5534HicQ/yTfnee9Qi+pkOXUrOAj/PlwxSC
	 vRa7S9nqPrs+w==
Message-ID: <sashiko-outbox-225545@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/7] iomap: use fsverity_is_building() to check for
 fsverity IO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, fsverity <fsverity@lists.linux.dev>, linux-ext4 <linux-ext4@vger.kernel.org>, dsterba@suse.com, "Eric
 Biggers" <ebiggers@kernel.org>, "Christian Brauner" <brauner@kernel.org>
Cc: tytso@mit.edu, chao@kernel.org, jaegeuk@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.cz
In-Reply-To: <20261120155032.187246-5-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-5-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:13:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] iomap: false warning and skipped EOF zeroing in
  iomap_writeback_handle_eof()
- [Low] iomap: missing Fixes trailer for commit 63e242afa466
--

commit d5a593fe13feaadaf9eccdc0fdcb54b6905598bb
Author: Andrey Albershteyn <aalbersh@kernel.org>

> iomap: use fsverity_is_building() to check for fsverity IO
>
> Recently, inode gained new I_VERITY_BUILDING flag. This flag indicates
> that inode is undergoing fsverity metadata construction. Previously, it
> was indicated by stale iomap flag on the IO, now we can check the inode
> instead. As fsverity inodes are read-only, the only write IO happening
> during I_VERITY_BUILDING is fsverity metadata.
>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

[Severity: Low]
Since this fixes the check on the uninitialized or stale wpc->iomap.flags
in iomap_writeback_handle_eof(), should it carry:

  Fixes: 63e242afa466 ("iomap: introduce IOMAP_F_FSVERITY and teach writeba=
ck to handle fsverity")

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d6e2f1ded5ca6..4fb4136908ec5 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1930,7 +1930,7 @@ static bool iomap_writeback_handle_eof(struct folio=
 *folio,
>  	struct inode *inode =3D wpc->inode;
>  	u64 isize =3D i_size_read(inode);
> =20
> -	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
> +	if (fsverity_is_building(inode)) {
>  		WARN_ON_ONCE(folio_pos(folio) < isize);
>  		return true;
>  	}

[Severity: Medium]
Can this trigger a false WARN_ON_ONCE() and skip EOF tail zeroing when
pre-existing dirty data folios are written back while I_VERITY_BUILDING
is set?

fsverity_ioctl_enable() calls deny_write_access(), and enable_verity()
sets I_VERITY_BUILDING after ->begin_enable_verity() without flushing
dirty data folios already in inode->i_mapping:

fs/verity/enable.c:enable_verity() {
    ...
		err =3D vops->begin_enable_verity(filp);
		if (!err) {
			spin_lock(&inode->i_lock);
			inode_state_set(inode, I_VERITY_BUILDING);
			spin_unlock(&inode->i_lock);
		}
    ...
}

If a file is written via buffered write or mmap, closed without fsync,
and reopened O_RDONLY for FS_IOC_ENABLE_VERITY, writeback of dirty data
folios below i_size can run while I_VERITY_BUILDING is set.  Because
fsverity_is_building() is an inode-wide flag, iomap_writeback_handle_eof()
fires WARN_ON_ONCE(folio_pos(folio) < isize) and returns early.  For a
dirty data folio straddling i_size, returning early also skips
folio_zero_segment() and leaves *end_pos unclamped past i_size.

Checking fsverity_is_building(inode) only when the folio is completely at
or beyond i_size (where iomap_writeback_handle_eof() otherwise returns
false) would avoid affecting regular data folios.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-2-aalbersh@kernel.org?part=3D4
