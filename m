Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347953;
	b=FIavaBkUoXDaLfBodMciB1GdsE/qIQm3117u895S+T4JdAZuEn8IR/ZGFnS8467WXLwa
	 HhyJ8qeGHZPpIKpo+gY2TEpTpvA+zGdYWAZULs8e7SoKkuRLzccRuK2ZSd37+rVllYcXy
	 wGgse2ihgs0qX5u9FkKopm1cdy4eBn52GnQJ/aVN7P39WOp44oId0RTX5FCozJwwAwzwr
	 qxq6TMINi6h76odAyBYHxrHWEIXDknxwyimoUq5RwvMYTOACnJOYEi2G3coYNvEa26P6G
	 LKoQ/nGkLwCnB/x4U/Nm4p9bJWKSmWHkguIovfEYu3zHiZdd8Q4DbZNd6RanA7JMJZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347953;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZJO94l84QK4bprsIuDcbPoluEQrXPtjS00pqy7xCAGM=;
	b=sqZiZWUVvEAaNTsieb6Kv4R6mP4Lmvl4IjuEfa83OvIxfQQya3osI6J/naIBkufVZdT7
	 utoV8TOBJXvDi1uTxdp8f198OMzLhPMQTcAD96GFk9VAEoU7lMuU1t6E3ARy3Zvv2x1kK
	 B2sloxmrtuzFli+UqWQa/nVN1japUqT21Cw5IDNAGbyoy1LpDWiYUmm0XvAcYqg/u5LfS
	 8q3zXr0Slfdoz9qSm4hJ8n7bAfeaCC4GNJO0eBkl/+XYBpmlaOHhcBELAdZORzqKYHAXf
	 ixvaZIqY8mMVcoAZKGQi/rcnvOAMPdFpFxYDDy1sA7hpXp5zbS0APRpUEdYw55Pmx6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JAtowwJ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CAD606A325;
	Tue, 10 Nov 2026 21:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JAtowwJ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D211F0089F;
	Tue, 10 Nov 2026 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347953;
	bh=ZJO94l84QK4bprsIuDcbPoluEQrXPtjS00pqy7xCAGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JAtowwJ2pPdCxaTBZjmKWNh5PkcnHC1a6JqF1BhyWgLEOzat739v+ux/OaqQKC+zo
	 AJRUFFRLkFiCTJvFNJCxS5fuoKKN/yiKzz5944+hRGW1Pk36p4YwmEI4B4ymNtaS/s
	 0LG9OFyRJ+uw3MFuCJ7mc5ieslXrWLACXId7HRo+lURTCYdpyQMb9AADbXSWAfDBpM
	 SKZvctyT4GvwnyYePshqwabyG10N3/JG245TfZxFrDfXyI4Y3nncp9K4Lquhu65ZhH
	 75DW9LUy9jNh6MqNcF4VarBImxcsrFW34Gyf42+1X63g6x7zu2D3TkBye2OXHVrX3u
	 H1oHCd7yuYlag==
Date: Tue, 10 Nov 2026 22:59:08 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, 
	tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 05/34] jfs: don't set SB_RDONLY after filesystem errors
Message-ID: <20261110-tasten-willst-denken-3168bf999f0d@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191224@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191224@kernel.org>

On Fri, Oct 30, 2026 at 04:09:51PM +0000, sashiko-bot@kernel.org wrote:
> With COMMIT_Dirty never set on ip (and jfs_freeze() skipping txQuiesce() once
> sb_emergency_ro() is set), could evicting the inode trigger
> BUG_ON(!list_empty(&ji->anon_inode_list)) in jfs_evict_inode()?

No for extAlloc(). dquot_free_block() in its failure path marks the
inode dirty and jfs_dirty_inode() sets COMMIT_Dirty because atlhead is
set by then. extRecord() doesn't mark the inode dirty on failure without
this patch either and it only runs for XAD_NOTRECORDED extents which
Linux never creates.

> sb_rdonly(sb) is still false, so won't jfs_extendfs() proceed on a filesystem
> that just entered emergency read-only mode during sync_filesystem(sb)?

Right, I'll check sb_emergency_ro() there too.

> What happens if userspace requests a read-write remount (for example, mount -o
> remount,rw) after a runtime filesystem error without having remounted
> read-only first?

It succeeds and the filesystem stays read-only. That's how ext4 behaves.

> won't updateSuper() take the JFS_NOINTEGRITY branch instead of returning early
> at sbi->state == FM_DIRTY, and overwrite the on-disk FM_DIRTY error state with
> FM_CLEAN?

Pre-existing.

> Wouldn't jfs_evict_inode() hit BUG_ON(!list_empty(&ji->anon_inode_list))
> because nothing commits the inode after jfs_reconfigure() sets SB_RDONLY?

No.

> If the filesystem was mounted with JFS_NOINTEGRITY and an error occurs while it
> is frozen, does calling updateSuper(sb, FM_MOUNT) in jfs_unfreeze() clobber the
> FM_DIRTY state?

Yes, I'll make jfs_unfreeze() record FM_DIRTY again in that state.

-- 
