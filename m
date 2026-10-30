Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376596;
	b=At+t46Pi8lh3Hblh25BFNG2OlSi17F7RuCKdExI2IOiStj5Pj4NA2HOjjHSI0bgKZ6YT
	 xcMJCjoygcqvyQo4mxoKOuQGIADtd6LDIjW0Rs6biq9/u7ZcETje7xKgujnZbdd6aMAcI
	 sHfARtxNDu1EMtkZOOQYOe4swzlN3L/GJcoonaHIJHQq1s3YygMlnHwGnD9xf2bxIFmcB
	 vijITqPZweijqS3x4kNpJcxS2/JbjHlY99Rj5UJ7J3Y5DPiaEAGopLcdDvXJaW1AfhY7+
	 UhEDefITiK2kCxkgmZ659TX8f4mtNNDYQRDu1G8Os+QY1OYal2algmq7a/36G/bgPiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376596;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Fcm+hIfEyXj/1FIUdG0rmsM/tGutxaQ6UYWcc0TMcU8=;
	b=E7HDK/e9pIfPwPUyYoVXi8lfzj03bv59ePP1uygRCWoTqOZE4sfqQ7cJKpAWV+KOg/ft
	 Bzfv+Xb6NeBUqVYcWADw2fgBmO9sgt9fo5HO6nHsTpnuECPBvNG1Y6gTp+UPiWUmnpZ+Z
	 hkPhlRZLqBAGm4EvP7iZie2Dwal/uJCHBwoY7Qep+lYC8kH3SkobrJgBpc0teju54cQkh
	 zsOj2oAMZkATIb08GOB+hGF8GvHGf5bbQoc19tB4PkpKXsXVZ7waSLuPR+N/8o+UAYhYk
	 Y76Fm0yV5nNEMOnXonUkxdh7Qi+pedAs2LbXE1/eRQy+161EFM64Afb3bhyJSutH/qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QI6bw7Wp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBF5606A33C;
	Fri, 30 Oct 2026 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QI6bw7Wp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF091F00A17;
	Fri, 30 Oct 2026 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376596;
	bh=Fcm+hIfEyXj/1FIUdG0rmsM/tGutxaQ6UYWcc0TMcU8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QI6bw7Wpe0jvnRPZ/15BzNWtxNle/TBdjDueozdSB/u2+/+fN4EKSixohfH5HY8vF
	 hPc/925bZQTYTslO+O7V3sjaQP8Q4jnS47UWxyoQhVd3NuruyQmqu5PyHSYDWcmfVF
	 2r6pd4ob3QSIt8N/S0Ra/BZ8+RRVJk2wFTjqxvITxBIchJXK6FE66lWDShwdQqP0CN
	 lUBtcpSOBG+XvEynjhP6CpHYGeTlxDVG3rz9pVGpRy/D8t6rMhUhVLrDhyseFKXrbY
	 b0W63QZ0rPxzdHARLQo2Yxq7pucvv7/7vOOY68ITxchgMhLfPg+AWOiAcUjYzSEkWH
	 Rw2ljddrjlsEg==
Message-ID: <sashiko-outbox-191228@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/34] exfat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-9-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-9-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] exfat: __exfat_truncate() and exfat_evict_inode() modify fs in eme=
rgency RO
--

commit 17c10ac04b3dad50bb870e977d92e72ea9d3bcfd
Author: Christian Brauner <brauner@kernel.org>

exfat: don't set SB_RDONLY after filesystem errors

This commit introduces EXFAT_FLAGS_EMERGENCY_RO and exfat_emergency_state()=
 so
that filesystem errors after mount mark the filesystem emergency read-only
rather than setting SB_RDONLY without holding s_umount.

> diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
> index 5129df1e79b44..3f24e5bd3eb11 100644
> --- a/fs/exfat/inode.c
> +++ b/fs/exfat/inode.c
> @@ -114,8 +114,9 @@ int exfat_write_inode(struct inode *inode, struct wri=
teback_control *wbc)
>  {
>  	int ret;
> =20
> -	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
> -		return -EIO;
> +	ret =3D exfat_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> =20
>  	mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
>  	ret =3D __exfat_write_inode(inode, wbc->sync_mode =3D=3D WB_SYNC_ALL);

[Severity: High]
Should __exfat_truncate() or exfat_evict_inode() also check
exfat_emergency_state()?

When an unlinked file is closed (or during unmount) after a filesystem error
sets EXFAT_FLAGS_EMERGENCY_RO (or SB_STATE_EMERGENCY_RO in the follow-up
commit "exfat: use the generic emergency read-only state"),
exfat_evict_inode() calls __exfat_truncate():

fs/exfat/inode.c:exfat_evict_inode() {
	truncate_inode_pages_final(&inode->i_data);

	if (!inode->i_nlink) {
		i_size_write(inode, 0);
		mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
		__exfat_truncate(inode);
		mutex_unlock(&EXFAT_SB(inode->i_sb)->s_lock);
	}
    ...
}

Similarly, if a write in exfat_file_write_iter() encounters a corrupted FAT
chain or cluster error that sets EXFAT_FLAGS_EMERGENCY_RO via
exfat_fs_error(), the error unwind in exfat_extend_valid_size() or
exfat_write_failed() calls exfat_truncate() -> __exfat_truncate().

Because __exfat_truncate() in fs/exfat/file.c calls __exfat_write_inode()
directly rather than exfat_write_inode(), it bypasses the
exfat_emergency_state() check above:

fs/exfat/file.c:__exfat_truncate() {
    ...
	if (__exfat_write_inode(inode, inode_needs_sync(inode)))
		return -EIO;

	/* cut off from the FAT chain */
	if (ei->flags =3D=3D ALLOC_FAT_CHAIN && last_clu !=3D EXFAT_FREE_CLUSTER &&
			last_clu !=3D EXFAT_EOF_CLUSTER) {
		if (exfat_ent_set(sb, last_clu, EXFAT_EOF_CLUSTER))
			return -EIO;
	}
    ...
	/* free the clusters */
	if (exfat_free_cluster(inode, &clu))
		return -EIO;
    ...
}

This modifies directory entries, FAT entries, and allocation bitmap buffers=
 via
exfat_free_cluster() -> __exfat_free_cluster() -> exfat_clear_bitmap() (whi=
ch
also writes synchronously when IS_DIRSYNC(inode) is set), and if mounted wi=
th
discard (which __exfat_fs_error() does not clear, unlike
exfat_force_shutdown()), issues block device discard requests via
exfat_discard_cluster() while walking a potentially corrupted cluster chain.
Furthermore, because SB_RDONLY is no longer set on error, sync_filesystem()=
 no
longer returns early at sb_rdonly(sb) and flushes those dirtied metadata
buffers to disk.

Can __exfat_truncate() and/or exfat_evict_inode() check
exfat_emergency_state() to prevent metadata modifications and discards after
the filesystem enters emergency read-only state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D9
