Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657809;
	b=fIVKR0EsZB/vVxt6l2kc3FSTYQluWOdBO9vpV1DG7YCGU+RzfwIJ4Y19I+2L5blUifPE
	 zNvLN9Yg/mQAz5aeABdKNEgyFKegV/6UdnqnzPn8W++GKaJfGGyD1GcwGCaya3CAd+nZS
	 EbFh0AcuKilP4T3cxvJVzwIJoas1lLr4MUlM9J6QFJCVuYn2/T1j2luczX7mWb7H0rNvh
	 gzYoKmqbX7XWHxKOrFbWu7KQSxu44NVLftZyTZ50QBc8h9IfOMW3sLC7gFIcWzMm7z0kW
	 qe2gq/0MqumAL+RWiRxHgIlPhK+zBThRach3mfbzXeGJeSrFS1BjDsCS8BzbpJJwI+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657809;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oge5gHl+Ji7nKy/eL+dZMpu8kpivAdHNITu7sKlcjQc=;
	b=AS2DcPQ1Uf70KGq4fu59gesjBcRHAy5WPkEGOqZcdcw6wcSGnRhoIQvjO2xnLqOBRYIW
	 Ws+xDaOscO6eDfWtWJWy8OQOA4+D+ZcUYmatf0WW/926J3dmqP6nzaeiHGpyY1h+RShDG
	 dPnkkI6W3zbGolXEXQTNU4exEpn0kNOaE1+dH9v2TAdCiuykUn2EyOvlWyE0NS5BiMAsR
	 dZ0voV/3ZNA63aW4FKMWHeFbC8U1C0Sa1phkRDk4p9oPk4mPOYIrO+ea3v+JOO4Mp6LTh
	 6Q/pU96wnxFnrE9/5IALMBHZBEDv4laWZ3T+WPUnTg2ULMpOy1VSxff5gpGRyW+rbaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5b0v7Xr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAB3606A337;
	Sat, 14 Nov 2026 12:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5b0v7Xr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2781F000C5;
	Sat, 14 Nov 2026 12:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657809;
	bh=oge5gHl+Ji7nKy/eL+dZMpu8kpivAdHNITu7sKlcjQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O5b0v7XrzA1WELCmu12+3CEzgi7O2PA8wGWyXzNM6/DMm+jeSwo7oaNtTiwWqL9Sj
	 3gPK042ci68YlqI+D+3g0OaUg+cutVM9FqYrbRFcuHLaesVhmnq25vU/sNxGRAhl04
	 lHz0EGke2a+V5t/bAXS+qhZG7iJ4YwHUvUQpE9xRz7XS8V7QPJ0pGzJkjCB4lIFZsl
	 eTaJfqrZs41T2hNOMdzBWNdHHvd2P8ZNfSec5Wn6PxaFZqKE069wvpqaCaAwQ7Zfef
	 6SVzrh26YuobiR6IehubHAymqiV5REZJzZb4qBUlYCjtdsY7Rt+Ut+g8VLdhtdgAH+
	 Ox8ubwhXVfuug==
Message-ID: <sashiko-outbox-214460@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/33] fat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-9-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-9-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:28 +0000
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
- [Medium] fat: fat_free() zeroes i_start on disk when
  fat_free_clusters() returns -EROFS
- [Medium] fat: directory modifications proceed after fat__get_entry()
  sets emergency RO
--

commit 7ce00aaef1e345a2ca01443ccff3c19884d9bcc3
Author: Christian Brauner <brauner@kernel.org>

fat: don't set SB_RDONLY after filesystem errors

This commit switches __fat_fs_error() from setting SB_RDONLY on a mounted
superblock to calling sb_set_emergency_ro(), and adds sb_emergency_ro()
checks across FAT write, allocation, and state paths.

> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 35bdb62944a2e..553034bcbed40 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -1329,6 +1329,9 @@ int fat_add_entries(struct inode *dir, void *slots,=
 int nr_slots,
>  	loff_t pos;
>  	bool saw_eod;
> =20
> +	if (unlikely(sb_emergency_ro(sb)))
> +		return -EROFS;
> +
>  	sinfo->nr_slots =3D nr_slots;
> =20
>  	/* First stage: search free directory entries */

[Severity: Medium]
Can fat_add_entries() and fat_dir_empty() still modify directory buffers
after a FAT error in fat__get_entry() sets SB_STATE_EMERGENCY_RO?

In fat__get_entry(), a fat_bmap() error calls fat_fs_error(), sets
sb_emergency_ro(sb), and returns -1 just like normal EOF.  In
fat_add_entries(), if the fat_get_entry() loop hits a FAT error on a later
cluster after collecting some free slots (0 < free_slots < nr_slots), it
falls through to found:, writes the partial slots into bhs[], fails in
fat_add_new_entries() -> fat_alloc_clusters() with -EROFS, and then
overwrites the original slots (including 0x00 end-of-directory markers)
with DELETED_FLAG in __fat_remove_entries().

Similarly, in fat_dir_empty(), a -1 return from fat_get_short_entry() after
a FAT error makes a corrupted non-empty directory appear empty (return 0),
and because neither fat_dir_empty() nor fat_remove_entries() checks
sb_emergency_ro(sb), rmdir and rename proceed to delete the directory entry
on disk after the filesystem has entered emergency read-only mode.

> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
> index 2d10a815a5797..9e4bb0140320f 100644
> --- a/fs/fat/fatent.c
> +++ b/fs/fat/fatent.c

[ ... ]

> @@ -620,6 +626,9 @@ int fat_free_clusters(struct inode *inode, int cluste=
r)
>  	int i, err, nr_bhs;
>  	int first_cl =3D cluster, dirty_fsinfo =3D 0;
> =20
> +	if (unlikely(sb_emergency_ro(sb)))
> +		return -EROFS;
> +
>  	nr_bhs =3D 0;
>  	fatent_init(&fatent);
>  	lock_fat(sbi);

[Severity: Medium]
Does returning -EROFS from fat_free_clusters() without guarding fat_free()
cause fat_free() to zero i_start on disk while leaving the cluster chain
allocated in the FAT?

When cont_write_begin() fails due to a FAT error that sets
sb_emergency_ro(sb) (for example on a 0-byte file with fallocated clusters,
or after allocating the first cluster of a multi-cluster write),
fat_write_begin() calls fat_write_failed() -> fat_truncate_blocks(inode, 0)
-> fat_free(inode, 0):

fs/fat/file.c:fat_free() {
    ...
	if (!skip) {
		MSDOS_I(inode)->i_start =3D 0;
		MSDOS_I(inode)->i_logstart =3D 0;
	}
	MSDOS_I(inode)->i_attrs |=3D ATTR_ARCH;
	fat_truncate_time(inode, NULL, FAT_UPDATE_CMTIME);
	mark_inode_dirty(inode);
    ...
	inode->i_blocks =3D skip << (MSDOS_SB(sb)->cluster_bits - 9);

	/* Freeing the remained cluster chain */
	return fat_free_clusters(inode, free_start);
}

Because fat_free() clears i_start and marks the inode dirty before
fat_free_clusters() returns -EROFS, and fat_write_inode() stays active in
emergency read-only mode, writeback writes start =3D 0 to the directory ent=
ry
on disk and orphans the allocated clusters in the FAT.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D9
