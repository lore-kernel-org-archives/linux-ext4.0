Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880202;
	b=sYPgE7NXIgYH2aP7yIAMjkoIPRgxjUIm+nxr628600v+233jEuG3TO1LaBdTnOFW7kPR
	 cAHXehQ98Lzz6DfWzxXAsKy3QMpqtIwKMu2ufxBu8WoIj/egMmkTX7I6X3OFqDycJpQmz
	 VRhgtlDiMgm3jGlgTSuWO584BH+OdDMZsppDaafEVbW+aD9zFk40851fOFmURavyZPNvE
	 72lr6nOdLd8in7kkAfr1edGLY5Z2zvW2JaXR2mQzWorP6nqxNrK5ALOY2ZBBW8mdLgYiJ
	 oiwLG+eWvMhJAScRHnJ4Mc8opA0efnrEWbDwOsSl8jFAFtHd+QXwyKChdlF9aRAYg0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880202;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Gxcc1zkOY+57hokzq0GfoH/NV2UvZQZwh78R+8IWvrU=;
	b=WQSdtnHHujvC1S7PS/uDNrFlGpSK/SpHh693hGlAmx4J0q4wYtiKciUIjfuDxcYnxwCv
	 /2yU3L0fVvJ5HJp5DgU9bRFoFPpoC+uy1MDRVbj1QaStsh1sciOk49NzFyFhNlM9d5exd
	 jzJb9Z3USEs2yh7tqYZXhgCByJz7Hj9qqmNk6Btk+G4k8U6cGOEdjqim5iLfYxmV8+6uW
	 PEVA/2XRGWQCEdRazvVzvLqyz4Vbg5pOnxhSSV/m1KsANbRIjAeSIODpTDbqtcMJy1TV9
	 lHJ5CwcizZyi7jIpQG3twPANfNBmvDYrzLgPvxE47jQW7CkbFxsI8vyVPyTLhwunqKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZtIUNGm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105BF606D80E;
	Thu,  5 Nov 2026 12:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZtIUNGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA371F0093A;
	Thu,  5 Nov 2026 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880201;
	bh=Gxcc1zkOY+57hokzq0GfoH/NV2UvZQZwh78R+8IWvrU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mZtIUNGmeIXB62Pt6CTlcMa0HybTCPRuGs9LHX5kxBRSqu3+/AJ+PiG+Js/v6qpKc
	 l9pKVw+LXxK34u/SR1heVXq1fXspTx9s+Yi+bMgfxDelZwKsn7ZB8wg56sM/gCWCF+
	 NZkEEz6sg5ZS0bgZTg+GZVPA/JDKcu5M6M441RgonGnXn+3hjnQGihrrmtQwKFXLq6
	 tQY1eonI9bsPBylkv5FGA35h7yf7BgKT5cYgj5j3CHkZLF694OrS4pYE7Z8CnV2Pa3
	 /MmP7a52c8pV12rSK8BgEsk5AknxLMpRI/Q7cTtaqzFQUssAVjWY+8SJ/K//noe6EL
	 UBwSGwIxL7P9Q==
Message-ID: <sashiko-outbox-198985@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v2 5/5] f2fs: use I_VERITY_BUILDING instead
 of private flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>, ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com
Cc: tytso@mit.edu, brauner@kernel.org, "Andrey Albershteyn" <aalbersh@kernel.org>, viro@zeniv.linux.org.uk, jaegeuk@kernel.org, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261105115532.613467-6-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-6-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:03:20 +0000
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

commit e644391a5127c3435bf66450e53975dc1299ff60
Author: Andrey Albershteyn <aalbersh@kernel.org>

f2fs: use I_VERITY_BUILDING instead of private flags

This commit removes the f2fs-private FI_VERITY_IN_PROGRESS inode flag and t=
he
f2fs_verity_in_progress() helper in favor of the VFS I_VERITY_BUILDING flag
and fsverity_is_building().

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

[Severity: Low]
As reported by Sashiko on v1 [1], does removing f2fs_verity_in_progress()
break the build in fs/f2fs/data.c when CONFIG_F2FS_FS is enabled?

Two callers in the large-folio write paths in fs/f2fs/data.c still call
f2fs_verity_in_progress(inode):

fs/f2fs/data.c:f2fs_write_cache_folios() {
	...
retry:
		pos =3D folio_pos(folio);
		end_pos =3D pos + folio_size(folio);
		isize =3D i_size_read(inode);
		verity_in_progress =3D f2fs_verity_in_progress(inode);
		poff =3D 0;
	...
}

and:

fs/f2fs/data.c:prepare_large_folio_write_begin() {
	...
	if (!f2fs_verity_in_progress(inode) &&
	    !(pos & (PAGE_SIZE - 1)) && (pos + len) >=3D i_size_read(inode)) {
	...
}

Should these two callers also be updated to use fsverity_is_building(inode)?

[1] https://lore.kernel.org/r/sashiko-outbox-197991@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105115532.6134=
67-1-aalbersh@kernel.org?part=3D5
