Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872452;
	b=VyhD7UubOT8ch+QKLzi88R2QtiN0JIYIXYg3BEPBBq0qs8+niZ/hV1aKapg/VJhqOrZs
	 lSxCWXLPG2RYxnxtbB8+o2IxE2xhYxH6RK+K1CZRJZcxbjDdBOsn3I8v3g6eAVB7hBsHh
	 q/MQY5I37uPJxRi0tjYnl7T+vDAIaPELToaOTE5dYYEJNegDBsjjNHNZMJD/UzxPBXThh
	 S5ga1+jl0SVNyo7obxLnWvJxncblurBDBZknZyJ06o0lSddk84XAEmJ+S3INylrGsvu/L
	 CVNPQ0xRHreecG/OjCncjKlZNRpsSTbdcoCpkkrm6kvwUYm0guum5fDZtSWfmYdxGNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872452;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=oUEbx2+4U+LDsl5nvzYDoBWKA0thTBPr5ylR+eD5Gu4=;
	b=vL+v3tLPGxTW6QySE1dFOVNoa4bcKy88DyZW/8bYO4bktgHktGRBz5//rNDj0rRNK6+f
	 uQXDlzcVIXpTifuoR7bAdrOY3tdbeAzKlxo4vSm7q10DHcoEqDPMgv0Fq/ZKBIJ7EFJz6
	 XC1wSDGxWcLNpqoYAjMYMEH0h/l7l+PdJPeuCKUeYGlKIMd0PrpO1PpN8HW0j7qSsT3ZR
	 7ePsaRlxkTq6DC9EO79FiEJrIda3fg77gdHda5e6h7OLldP4KqouSeELKSr3sjUpGKdob
	 LMeciLXixdu1oJgLqwsitnWrQnrkNHLscXBLbwVJgdrgKYAZ5z1FkPCMfTkxTEv2tlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQypUc4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14C2606CC78;
	Thu,  5 Nov 2026 09:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQypUc4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922DD1F00919;
	Thu,  5 Nov 2026 09:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793872451;
	bh=oUEbx2+4U+LDsl5nvzYDoBWKA0thTBPr5ylR+eD5Gu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eQypUc4lCHxICRDLP4a9G4Nu2/0z2Z9/01KsMkx8eCxGz6XRXX0OEVLFZmlh0bzHA
	 gI/Yv4d8KsrtKgzlTcGAX+ISNJ66A89z61yExYwbgtoGuFQX1V4k+5lTOceVN7lxam
	 F8ZUtdxUNeC9aHAHljfHcrYnWmFaomivoGtmSIzVjqbTpQ0SbpDFKYDW/aqox+JFxa
	 7wM/xLfvFYX3O261+AmaMihVbYEwIo2cCMnyHxf7ffZkvDJ7nKWMvgo1KOQu6FJD/2
	 ibffHucgQEjVbLIZyjqLCYkxF1kpN4dPECq/htdqAYlGNFKPiZvQfiXF5Nw3lgoio9
	 kv962nL5wG0AQ==
Date: Thu, 5 Nov 2026 10:54:06 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev, 
	linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
Subject: Re: [PATCH 5/5] f2fs: use I_VERITY_BUILDING instead of private flags
Message-ID: <auxSBY54CHYGixpz@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261104194618.103332-1-aalbersh@kernel.org>
 <20261104194618.103332-6-aalbersh@kernel.org>
 <sashiko-outbox-197991@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-197991@kernel.org>

On 2026-11-04 20:04:17, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] f2fs: unconverted f2fs_verity_in_progress() calls break build in data.c
> --
> 
> commit 915530af8afaaef004825dfc719049bb96b8cda2
> Author: Andrey Albershteyn via Linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>
> 
> f2fs: use I_VERITY_BUILDING instead of private flags
> 
> This commit replaces the f2fs-specific FI_VERITY_IN_PROGRESS flag and
> f2fs_verity_in_progress() helper with the generic fsverity_is_building()
> helper.
> 
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 4fa4d8042f702..11d1cade11510 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -925,7 +925,6 @@ enum {
> >  	FI_EXTRA_ATTR,		/* indicate file has extra attribute */
> >  	FI_PROJ_INHERIT,	/* indicate file inherits projectid */
> >  	FI_PIN_FILE,		/* indicate file should not be gced */
> > -	FI_VERITY_IN_PROGRESS,	/* building fs-verity Merkle tree */
> >  	FI_COMPRESSED_FILE,	/* indicate file's data can be compressed */
> >  	FI_COMPRESS_CORRUPT,	/* indicate compressed cluster is corrupted */
> >  	FI_MMAP_FILE,		/* indicate file was mmapped */
> > @@ -3627,12 +3626,6 @@ static inline void clear_inode_flag(struct inode *inode, int flag)
> >  	__mark_inode_dirty_flag(inode, flag, false);
> >  }
> >  
> > -static inline bool f2fs_verity_in_progress(struct inode *inode)
> > -{
> > -	return IS_ENABLED(CONFIG_FS_VERITY) &&
> > -	       is_inode_flag_set(inode, FI_VERITY_IN_PROGRESS);
> > -}
> > -
> >  static inline void set_acl_inode(struct inode *inode, umode_t mode)
> >  {
> >  	F2FS_I(inode)->i_acl_mode = mode;
> 
> [Severity: Low]
> Does removing f2fs_verity_in_progress() break the build in fs/f2fs/data.c?
> 
> Two callers in fs/f2fs/data.c still reference f2fs_verity_in_progress()
> after this patch:
> 
> fs/f2fs/data.c:f2fs_write_cache_folios() {
> ...
> retry:
> 		pos = folio_pos(folio);
> 		end_pos = pos + folio_size(folio);
> 		isize = i_size_read(inode);
> 		verity_in_progress = f2fs_verity_in_progress(inode);
> ...
> }
> 
> and:
> 
> fs/f2fs/data.c:prepare_large_folio_write_begin() {
> ...
> 	if (!f2fs_verity_in_progress(inode) &&
> 	    !(pos & (PAGE_SIZE - 1)) && (pos + len) >= i_size_read(inode)) {
> 		size_t zoff = ori_off + len;
> ...
> }
> 
> Should these two call sites also be converted to fsverity_is_building(inode)?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261104194618.103332-1-aalbersh@kernel.org?part=5
> 

Ah, this refactored code is from f2fs/dev which is not yet in
v7.4-rc1. Sashiko applied this patchset to f2fs/dev.

-- 
- Andrey
