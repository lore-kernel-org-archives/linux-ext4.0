Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007FC37B010
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 07:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786691074; cv=none; b=bXylPkC43lMhzuPDGw5323qePf8SHQqHmvKJmCKQvtGkN6N41Ij2JigUpUXYtAeaQOGeE1a440FS9eIBBo0Qlz7MyeI2CkxeEiQKbVe9sizMwhZzkLI5K1j2duOcitBX9tAmHZtKHGiGTI2/bXFhGzr7qf3JtA+zaSRkP1VUGhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786691074; c=relaxed/simple;
	bh=II5DI6AL1tJg30M7Dq3iT58bIVCod8jD+rxxsTX7/58=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F1VAxqGUHG8DcTJNT56lwOjsjIojfdlsRmF2TsqFx3HDyrH1o6UgDxH7+c8mKokTOUs9abdUtIIMSz/QnafcDUda7SMBoocNxgdIWWdwGpi81pDrLPUbRXFoa/YsKC2sMGr/tMV1Sb+Js4lySwUv9GK/I5N4zWm5Ozw5kDt7LDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5lPN8rF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5lPN8rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595B91F00A3A;
	Fri, 14 Aug 2026 07:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786691072;
	bh=OMULvuOGN0jTLjzuTlKxob/IWFSxDYdBRcMe4IuuRH0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C5lPN8rF3z6uMlocHy5sQ7UL/jV5pIkRWMa3ko5L93qZECipRKQnp4ONF+DxZWUKS
	 LU4XWRUeOFgh+EldrvhaMPscXh0NSXJ3QCH1oi9V0qjdeXj4NQj5vDeqW3jmdRFqAl
	 FS+3cK/hK5bjPgPt3qEBKxIJzySMF+ya/eiuFJHOeSbBJcliPV6h+U0GCff6AQltpZ
	 vcMTTPD891uiPp65thEUyt4kPUdnO6TK3VimshBL/wed699YhD1i0prbq6zzrv09ZM
	 G2kT9dfNcZ78qNFCJRsPvyBYequ/pvIH+cCW1QPD7b2Wez0aESHfLbwxgH0wzt1xF3
	 G9aKSmj8Y00MA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: drop extra ea_inode ref in cached-block reuse
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matthias Goergens" <matthias.goergens@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814065023.3466742-1-matthias.goergens@gmail.com>
References: <20260812044556.2209787-1-matthias.goergens@gmail.com>
 <20260814065023.3466742-1-matthias.goergens@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 07:04:31 +0000
Message-Id: <20260814070432.595B91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Permanent reference count leak for EA inodes when jumping to `getb=
lk_failed` after `ext4_xattr_inode_inc_ref_all()` succeeds.
--

--- Patch [1]: [PATCH v2] ext4: drop extra ea_inode ref in cached-block reu=
se path ---
commit 6323662f6aec67da90a2777f14df4011e64b989b
Author: Matthias Goergens <matthias.goergens@gmail.com>

ext4: drop extra ea_inode ref in cached-block reuse path

This commit addresses an EA inode reference count leak when reusing an
identical cached block in ext4_xattr_block_set(). It also modifies the
new-block allocation path to fail the operation instead of just warning
if dropping the extra reference fails.

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 6127e94ea4f5d..29b08b69da2be 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c

[ ... ]

> @@ -2075,13 +2119,21 @@ ext4_xattr_block_set(handle_t *handle, struct ino=
de *inode,
>  			if (error)
>  				goto getblk_failed;
>  			if (ea_inode) {
> -				/* Drop the extra ref on ea_inode. */
> +				/*
> +				 * Drop the extra ref on ea_inode; on
> +				 * failure the decrement may already have
> +				 * run, so just fail and free the block.
> +				 */
>  				error =3D ext4_xattr_inode_dec_ref(handle,
>  								 ea_inode);
> -				if (error)
> -					ext4_warning_inode(ea_inode,
> -							   "dec ref error=3D%d",
> -							   error);
> +				if (error) {
> +					ext4_xattr_inode_free_quota(inode,
> +								    ea_inode,
> +								    i_size_read(ea_inode));
> +					iput(ea_inode);
> +					ea_inode =3D NULL;
> +					goto getblk_failed;

[Severity: High]
This isn't a bug introduced by this patch, but this new goto getblk_failed
path appears to exacerbate a pre-existing reference count leak for EA inode=
s.

Just above this block, ext4_xattr_inode_inc_ref_all() successfully iterates
over all EA entries and increments their inode reference counts:

	error =3D ext4_xattr_inode_inc_ref_all(handle, inode,
				      ENTRY(header(s->base)+1));

If the decrement of the extra reference fails, the code now jumps to
getblk_failed. The getblk_failed label frees the newly allocated physical
block and jumps to cleanup:

getblk_failed:
	ext4_free_blocks(handle, inode, NULL, block, 1,
			 EXT4_FREE_BLOCKS_METADATA);
	goto cleanup;

However, it completely skips rolling back the newly incremented EA inode
references via ext4_xattr_inode_dec_ref_all(). Because inc_ref_all already
called ext4_mark_iloc_dirty() for those EA inodes, won't the artificially
elevated reference counts be committed to the journal?

Since the error here doesn't mark the filesystem as containing errors,
could this silently leak these references without triggering an automatic
e2fsck on the next reboot?

> +				}
>  				iput(ea_inode);
>  				ea_inode =3D NULL;
>  			}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814065023.3466=
742-1-matthias.goergens@gmail.com?part=3D1
