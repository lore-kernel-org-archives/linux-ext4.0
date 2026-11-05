Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793884002;
	b=5eEd3+tocmnlxA/M/S2jC8sEgyLoojg2+jyNL7o38TlaXCfyhconqdHzK6ZNFhzlnweY
	 VCxEpzLzzspFKE6aQ8eJbXT4iopQvME375tpnfW3PwMfdTUe8ZDOvXKURaje6Lg6n20Xs
	 HOo8w7kSu4yXiqIz+1O2p8Bb4+4cbW9ABWRewVn/dSyHPXjICDKJn4vg+uLSzt/7MbtiJ
	 HH9UzQ6gaegFeYE1zLPczyUDcUGs5XBk5rnkjqup7F+eOmwexOXFmSvDpDz/g9aWeMlOs
	 e/ODHfLWxfE/4R1dNJ/ZOXhXooST2jiSrB+fWJq/4vGmK5Nn7M8XRu7u0thq/T7UjIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884002;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zxC1tbHwZliHwXzfTOeFwJIrAVz3L2/JNsN6NU2H0VE=;
	b=MJsWHz+zngx+U+lxSrtNLvsDzjh0+A6j83YhuV6iVBkDsAUTxXllpuIXkPCu/TsTh+Ye
	 Hj45AXBv1MVfIb88FKhebG+XrkjhYZOrk6E2yxpAFS///DBUa1e89KkKvIx91ZHbicEnB
	 lkyEaiCU/qIc23oN3Zm4itaeIAeMdt3m3dx1MFFvYuSlaxO37aaVsgVAh9S1tE1vabrvN
	 uTv//BEXd742xnxXZIsx57A6XoA9ktqzFP+G1Q0aoF6Mz3bGvU0BRg20XT5m82//sTKHR
	 6iq2LNXey9hu8uVRjIyVrxOgBqsvVgKFvEguoWKLWwZdm2gc6f2o/KPwNV/c1UMmWzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKemSfi1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664D9606A31B
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 13:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKemSfi1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA281F000C1;
	Thu,  5 Nov 2026 13:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884002;
	bh=zxC1tbHwZliHwXzfTOeFwJIrAVz3L2/JNsN6NU2H0VE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UKemSfi1dBvWWT6wLUuWdPqqQ4HvYLa6xesEtit96hNcAxoGa0SRCrHVi2G5b0nKl
	 tmromBHM+v8p7heyUEuhT7w/C+TT4vSTyKmNXBlUgqVhS04l2dynGjFHD+/3Q9Kf9r
	 VeRLhnrhyA2fngtnOFEBJpFiCkF+TPq3ZOR8vldjrl4NipPheeWyIOQUlW+wGvLgRq
	 0u0syOSimrnviUY2ngDDyK/HXAPyMibnezcA/DwtyyinpPsK9kXVknZovaml0TIzyP
	 i9h+LEPz/i0qF2jgnH42hduU5nWbFfXE2ErBqxGRePMQh5tDjCsgFDmUWOidovTC7s
	 l/+qUQcDI0c8A==
Message-ID: <sashiko-outbox-199118@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 12/13] fat: sync inode metadata in
 fat_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-12-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-12-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:06:41 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] fat: fat_evict_inode() syncs stale dir entry before fat_free_eofbl=
ocks()
- [Medium] fat: fat_evict_inode() skips mmb_sync() when fat_sync_inode_meta=
data() fails
- [Medium] fat: fat_iget() skips I_FREEING inodes while fat_evict_inode() s=
yncs metadata
--

commit bd339e5e48c232fb0520331a07810a35de6e7ce5
Author: Christian Brauner <brauner@kernel.org>

fat: sync inode metadata in fat_evict_inode()

This commit updates fat_evict_inode() to call fat_sync_inode_metadata() when
evicting a linked inode that has I_METADATA_WRITEBACK set, ensuring dirty
directory entry and metadata buffers are written out before the inode and i=
ts
state bit disappear.

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index d85c8fbdcca46..df4616636c659 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -693,7 +693,16 @@ static void fat_evict_inode(struct inode *inode)
>  		inode->i_size =3D 0;
>  		fat_truncate_blocks(inode, 0);
>  	} else {
> -		mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
> +		/*
> +		 * fsync() can't find what I_METADATA_WRITEBACK tracks once the
> +		 * inode is gone. This syncs the metadata buffers as well.
> +		 */
> +		if (inode_state_read_once(inode) & I_METADATA_WRITEBACK)
> +			fat_sync_inode_metadata(inode, &(struct writeback_control) {
> +				.sync_mode =3D WB_SYNC_ALL,
> +			});

[Severity: Medium]
Can a concurrent lookup reopen the file and complete fsync() before
fat_evict_inode() finishes syncing the old inode's metadata?

When reclaim isolates the inode, I_FREEING is set before dispose_list()
calls evict() -> fat_evict_inode(). Unlike filesystems that look up inodes
via iget_locked() and wait in __wait_on_freeing_inode(), FAT assigns a
synthetic i_ino via iunique() and looks up existing inodes by i_pos in
fat_iget():

fs/fat/inode.c:fat_iget() {
	...
	hlist_for_each_entry(i, head, i_fat_hash) {
		BUG_ON(i->vfs_inode.i_sb !=3D sb);
		if (i->i_pos !=3D i_pos)
			continue;
		inode =3D igrab(&i->vfs_inode);
		if (inode)
			break;
	}
	...
}

Because igrab() returns NULL when I_FREEING is set, fat_iget() returns NULL
without waiting for the freeing inode to finish eviction.

If another thread looks up the file while the old inode is queued on the
dispose list or sleeping inside fat_sync_inode_metadata() before
fat_detach() runs, fat_build_inode() allocates a new clean inode for the
same i_pos without I_METADATA_WRITEBACK set. Wouldn't a subsequent
fat_file_fsync() -> simple_fsync_noflush() on that new inode see a clean
inode and return before the old inode's directory entry buffer writeback has
completed?

> +		else
> +			mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);

[Severity: Medium]
What happens to MSDOS_I(inode)->i_metadata_bhs if fat_sync_inode_metadata()
encounters a buffer write error on the inode's directory entry block?

In fat_sync_inode_metadata(), if buffer_write_io_error(bh) is true after
sync_dirty_buffer(bh), the function returns -EIO early before reaching the
sync_bhs label:

fs/fat/inode.c:fat_sync_inode_metadata() {
	...
	if (bh && buffer_uptodate(bh)) {
		sync_dirty_buffer(bh);
		if (buffer_write_io_error(bh)) {
			brelse(bh);
			return -EIO;
		}
	}
	brelse(bh);
sync_bhs:
	return mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
}

When evicting a subdirectory inode that has I_METADATA_WRITEBACK set,
replacing the unconditional mmb_sync() with fat_sync_inode_metadata() means
an I/O error on the parent directory entry buffer skips mmb_sync() for the
child directory buffers tracked in i_metadata_bhs, right before
fat_evict_inode() detaches them via mmb_invalidate(). Should
fat_sync_inode_metadata() still run mmb_sync() before returning an error, or
should fat_evict_inode() call mmb_sync() unconditionally?

>  		fat_free_eofblocks(inode);

[Severity: High]
Could calling fat_sync_inode_metadata() before fat_free_eofblocks() write a
stale directory entry to disk and leave the post-truncation directory entry
unsynced without I_METADATA_WRITEBACK?

When clusters are preallocated via fallocate() with FALLOC_FL_KEEP_SIZE on a
zero-byte file, fat_chain_add() updates i_start and i_logstart and marks the
inode dirty:

fs/fat/misc.c:fat_chain_add() {
	...
	} else {
		MSDOS_I(inode)->i_start =3D new_dclus;
		MSDOS_I(inode)->i_logstart =3D new_dclus;
		mark_inode_dirty(inode);
	...
}

Before the inode can be isolated from the LRU and evicted, background
writeback runs fat_write_inode() -> __fat_write_inode(), which writes the
non-zero i_logstart into the directory entry buffer (with size still 0),
marks the buffer dirty, and sets I_METADATA_WRITEBACK on the inode.

When fat_evict_inode() then runs on a normal async mount:

1. Because I_METADATA_WRITEBACK is set, fat_sync_inode_metadata()
   synchronously writes the pre-truncation directory entry buffer (pointing
   to the fallocated clusters on a zero-byte file) to disk.

2. Next, fat_free_eofblocks() truncates the unused fallocated clusters back
   to mmu_private:

fs/fat/inode.c:fat_free_eofblocks() {
	if ((inode->i_blocks << 9) >
			round_up(MSDOS_I(inode)->mmu_private,
				MSDOS_SB(inode->i_sb)->cluster_size)) {
		int err;

		fat_truncate_blocks(inode, MSDOS_I(inode)->mmu_private);
		...
		err =3D sync_inode_metadata(inode, inode_needs_sync(inode));
		...
	}
}

3. On an async mount, sync_inode_metadata(inode, 0) calls
   __fat_write_inode(), which updates the directory entry buffer in memory
   back to i_logstart =3D 0, marks the buffer dirty again, and sets
   I_METADATA_WRITEBACK on the dying inode without syncing the buffer.

4. fat_evict_inode() immediately finishes and calls clear_inode(), losing
   the newly set I_METADATA_WRITEBACK bit while the updated directory entry
   buffer remains dirty in memory.

If the file is reopened from the cached buffer and fsync() is called,
simple_fsync_noflush() sees a clean inode without I_METADATA_WRITEBACK and
skips syncing the directory entry buffer, while fat_file_fsync() flushes the
FAT table updates where those clusters were freed or reallocated, leaving
the on-disk zero-byte directory entry pointing at freed clusters if a crash
occurs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D12
