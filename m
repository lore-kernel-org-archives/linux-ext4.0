Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E9A1DF748
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064395; cv=none; b=ZmqBFo6/dXWrJGLRX7E3ueGcD/GwZTzEWn1aiOxdFquHdoB6IKV/OVwCSQgVrTzBQOZIqiQoa2EK8sOBaCxf+ex3+cEpqKdFE36PE2mxXMrV5g+Z87SDhxqwPc4JWkVWveEsrfkrWCJVspxiw7C5RSgK3zH10k2bbhmmg0YwDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064395; c=relaxed/simple;
	bh=zZWZdFD6a8ih1eloLUqQoHIG87b27fAPfrYBFinM6Hg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MgGQc0zaw+C+alnEpqWGErEgftF8tgQX274y/Wpkp2E95jIF2cg+YhY4fEX5FijA/AUngrX5i4h82aSFXbjaxClvEMA/FMxZ3dhiEItjY+gpQI2H+sOgZkEkl9iEa/pNA00rn+My3kNJ3U+xczM7TZ81BTFeZ98Z+90KHYJNqqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDRbsSd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDRbsSd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8271F000E9;
	Sun, 30 Aug 2026 04:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788064393;
	bh=uC8TSE4rjYdtmsLOfNBrNKWCVZ/wsTiwY/eEZAXsbLg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QDRbsSd9CXjBhKXoodxq4PbogFAqSWohw0qcLuMJkqIglHQJonyT3JfBAEDiu9upR
	 /c2GZc9ZQLNGInKOosbZdxQbnZP5hQy452ExqlRWQ33zDFBweC+ZyC7sRM1yxHEt7s
	 NEziHIOPVZtBUPm2YjaeKCgUjNriWEcTwwIM2qVGfh+NtO2qEpweSpZxA1iLQoRHRs
	 oHHMIzCnl9LeKKaEJJJaTPhsQ8Mti+ZDBy5rpRUJGnS/Gg9JHb4aHCAJc2qQ9eFzzC
	 8GnfhtvarxYOVIH7H8rz+u0ahIbcBhNsEmWwrmbDTOyHdyFrZz/Jo9bUUBHJVnhJ6L
	 DxWnonCeALfqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/9] squashfs: Remove use of FGP_NOFS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20260830041901.2668-8-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-8-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:33:13 +0000
Message-Id: <20260830043313.7F8271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected GFP_KERNEL allocations while holding folio locks can c=
ause compaction deadlocks.
--

commit f9b201cd220cb4651ba3f51b039ab61732317528
Author: Matthew Wilcox (Oracle) <willy@infradead.org>

squashfs: Remove use of FGP_NOFS

This commit replaces the use of FGP_NOFS with memalloc_nofs_save() in
squashfs_copy_cache() to prevent page reclaim from calling into the
filesystem and attempting to compact the locked folio.

> diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
> index d83594ce91d23..34c550a266bcf 100644
> --- a/fs/squashfs/file.c
> +++ b/fs/squashfs/file.c
[ ... ]
> @@ -398,6 +398,7 @@ void squashfs_copy_cache(struct folio *folio,
>  	struct squashfs_sb_info *msblk =3D inode->i_sb->s_fs_info;
>  	int i, mask =3D (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
>  	int start_index =3D folio->index & ~mask, end_index =3D start_index | m=
ask;
> +	unsigned int nofs =3D memalloc_nofs_save();
> =20
>  	/*
>  	 * Loop copying datablock into pages.  As the datablock likely covers

[Severity: High]
This is a pre-existing issue, but while this patch fixes the allocation
context in squashfs_copy_cache(), does the same compaction deadlock risk
apply to other GFP_KERNEL allocations in the read_folio path?

For example, in fs/squashfs/file.c:read_indexes():

    __le32 *blist =3D kmalloc(PAGE_SIZE, GFP_KERNEL);

And in fs/squashfs/file_direct.c:squashfs_readpage_block():

    page =3D kmalloc_array(pages, sizeof(void *), GFP_KERNEL);

Both of these allocations occur deep within the read_folio call chain while
the target folio is held locked by the VFS. If memory pressure triggers
direct reclaim and synchronous compaction, it could attempt to lock the
exact same folio that the thread is already holding, leading to a deadlock.

While VFS readahead callers establish a NOFS context via
memalloc_nofs_save(), read_folio callers like filemap_read_folio() do not.
Should these locations also be updated to prevent compaction deadlocks?

> @@ -430,6 +431,8 @@ void squashfs_copy_cache(struct folio *folio,
>  		if (i !=3D folio->index)
>  			folio_put(push_folio);
>  	}
> +
> +	memalloc_nofs_restore(nofs);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D7
