Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822658;
	b=BAQIS1i9RkmELuYltKeC+VftsjtoN7UUtuSdfoPfhCon7NDAtSQIFKrX/kAj17SmeD1a
	 LXIcLK+SRfoAfUEoocUJjBxkqm5RzDDK/dFrDg+denOyykUOu8axsa+TGDBsyI8/qcvPX
	 zRpZWQQznwduH4+X/n5PPhBfze/7M9x1OD8OZhdb+Yd5hes2lDP+jsnZwdnMGf/4bhUG6
	 VxFkhU1NZ3lnCBnmQefi8V56ZgQk7j3WbB89dsTsdgrt+Ff0jy/2oePMAZnBqS6ysoG9R
	 YWMCBjPCd/6zBPEi74jhIX+JDXJPp6kT6QhM/CETCblUZ0r1DPKgtPjztp5smLUrCbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822658;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N6X/0zuc0HDWroLCKDHvOQ3Qwk/oYmD2m2xs2Jggit8=;
	b=w9NnB5iyF+mGuqbj/NfORhUYP5OpjXQpMFcdbtzQdEQ/ybUF0AyKRdc/9SkLn3jw1z66
	 HLfX3rFUsnjyNKx1vRG58PT0beQ9kKwgF1JM+jgkK6mTon7EhqTvSf5TbVuHnTHR7m9qH
	 DVbKoQ0p2+g3hRiZElRLvufEmGgM/2O/CAXbfrY/rXPiChFvfVkWndz8TZ3gcRisFP/DC
	 q93/KGwzF/mJBJ4rjmWcyACbY3yV6EJFyeXO/s2u90iCzT/K7HPRdqx8LL/Oy8yM2wjZq
	 ROS1fYf3FYrgqBbO3tLRfmgdLETbXAh7VGn5y9lclKFZPqx6ZoDHo4iixzvQ7ZbrYxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOG30cNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADED606D834;
	Wed,  4 Nov 2026 20:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOG30cNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864AA1F000C1;
	Wed,  4 Nov 2026 20:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822657;
	bh=N6X/0zuc0HDWroLCKDHvOQ3Qwk/oYmD2m2xs2Jggit8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aOG30cNtRKTSNKgd97MJtxtSPGjWKnxv72pFVT4Gxc2vN5T3NYLIbQkYWMEUN2L2T
	 VSR00nFx5xuoa1tOaNUKAE99o5CTX8Gx5ByWu5KjxLEDOUusibvGUD0/vzhTTiuU+m
	 sCL2SdIByoR318Q6Swms+ERtKFfogEazjL4NFFyJMvcBpLjbFmYj99MDXDXmD5OdAm
	 5qq1gVb92RwV8a1SlXmhwUrFOcBrCUsJyLSc/UsV909beOhRuAw/AD2fD9B8wLnRCC
	 EnjrfxF4A8TT86F3uL3yshSELeCI2v4uJrOVcKngG9n8VDFWrThoOZ8W3GKHe8Z0GW
	 AZFqueCcW6teA==
Message-ID: <sashiko-outbox-197991@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] f2fs: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261104194618.103332-6-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
 <20261104194618.103332-6-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 20:04:17 +0000
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
- [Low] f2fs: unconverted f2fs_verity_in_progress() calls break build in da=
ta.c
--

commit 915530af8afaaef004825dfc719049bb96b8cda2
Author: Andrey Albershteyn via Linux-f2fs-devel <linux-f2fs-devel@lists.sou=
rceforge.net>

f2fs: use I_VERITY_BUILDING instead of private flags

This commit replaces the f2fs-specific FI_VERITY_IN_PROGRESS flag and
f2fs_verity_in_progress() helper with the generic fsverity_is_building()
helper.

> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 4fa4d8042f702..11d1cade11510 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -925,7 +925,6 @@ enum {
>  	FI_EXTRA_ATTR,		/* indicate file has extra attribute */
>  	FI_PROJ_INHERIT,	/* indicate file inherits projectid */
>  	FI_PIN_FILE,		/* indicate file should not be gced */
> -	FI_VERITY_IN_PROGRESS,	/* building fs-verity Merkle tree */
>  	FI_COMPRESSED_FILE,	/* indicate file's data can be compressed */
>  	FI_COMPRESS_CORRUPT,	/* indicate compressed cluster is corrupted */
>  	FI_MMAP_FILE,		/* indicate file was mmapped */
> @@ -3627,12 +3626,6 @@ static inline void clear_inode_flag(struct inode *=
inode, int flag)
>  	__mark_inode_dirty_flag(inode, flag, false);
>  }
> =20
> -static inline bool f2fs_verity_in_progress(struct inode *inode)
> -{
> -	return IS_ENABLED(CONFIG_FS_VERITY) &&
> -	       is_inode_flag_set(inode, FI_VERITY_IN_PROGRESS);
> -}
> -
>  static inline void set_acl_inode(struct inode *inode, umode_t mode)
>  {
>  	F2FS_I(inode)->i_acl_mode =3D mode;

[Severity: Low]
Does removing f2fs_verity_in_progress() break the build in fs/f2fs/data.c?

Two callers in fs/f2fs/data.c still reference f2fs_verity_in_progress()
after this patch:

fs/f2fs/data.c:f2fs_write_cache_folios() {
...
retry:
		pos =3D folio_pos(folio);
		end_pos =3D pos + folio_size(folio);
		isize =3D i_size_read(inode);
		verity_in_progress =3D f2fs_verity_in_progress(inode);
...
}

and:

fs/f2fs/data.c:prepare_large_folio_write_begin() {
...
	if (!f2fs_verity_in_progress(inode) &&
	    !(pos & (PAGE_SIZE - 1)) && (pos + len) >=3D i_size_read(inode)) {
		size_t zoff =3D ori_off + len;
...
}

Should these two call sites also be converted to fsverity_is_building(inode=
)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104194618.1033=
32-1-aalbersh@kernel.org?part=3D5
