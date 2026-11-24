Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795524298;
	b=NcWPy3niRYbiszNQLfbElvpiomulgE/RiWGtdS6OI56TeOyqXsA5wAV+vxQM6kSQXiCN
	 KOI5Sd0Ls2SzqT6bG9ECEBixh7i5m3KVs15TFYx8fk1CchQvtttVnFbgXoYNIOqCe21Oe
	 EjIsHMtgHOjPxH8PBwGfxtl5y2nmG2gVZHUiYAoZqJFY0DWWQaqJ5fe4AKbn+5Kfes66B
	 KFv5YrvVS1Mvdy30cVvzNq4Jc+/VUcEbfJlRGxdvzlVjpnpIyYQl+7/EUTWOn2nwhBJYC
	 DDF9MOHM5zhGJDiWT5LvFNuDzdpWI+bOOqUIuugMOTc5/DwwBFdlOdr2V4wrUqGk5MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795524298;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=RHHNML+FKm9z7LwFp3WDueu+F5fVE10g8mb8PXsntLY=;
	b=heTJEycYtVa0IzWrcY3I3NyYDBVPi+PT94cmaT9kvcpkDCDyabDUOG49xZLdc49hgT4G
	 hSPSsGG83wHleOk4m6lrCJvT/K30RK91+ClkXi1rm7SQ91fdSJQFPaNKpKo2kCHuL6lqa
	 SyRblA2Dp+/Afs4iZb34prP7jLylxFQgdR+wNDCJ8WF3bOZJO8p6Uxnp0uuq72jlIk16Q
	 CoUQbWIm+KuUzYM+nRJDsLMzIX8k7jyT4xmUB9Vu/a9KxPW3v0mCFD0CFEzUzxe22jQRY
	 5/GaK/T3QFZ0r1zYmf8WEgbAv1/CMtgL+8AhLp1JMAV36xIiLtNiEUYIEzqix1txbmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lBwHrJz7;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iC8El0k3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RbEv5f6g;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OghHJpX4;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86EF606A321
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 12:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B86EF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lBwHrJz7;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iC8El0k3;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RbEv5f6g;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OghHJpX4
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B98B61F7A0;
	Tue, 24 Nov 2026 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795524296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RHHNML+FKm9z7LwFp3WDueu+F5fVE10g8mb8PXsntLY=;
	b=lBwHrJz79KRQ55AUjUQzydpjfMdxB2p8oxaeNgvVCre59sUdzMRQf+MXPTTkC6wVuKl0p2
	YwcXRgVxebMgR2ZXAG9zATQqDrLwwUbknHBICRxNDoKFvw2ILXJbbEWc6yjVB4ca/cfF3h
	umw3qLiHRa4i65gw8y1t2BK8+ZoTOMA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795524296;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RHHNML+FKm9z7LwFp3WDueu+F5fVE10g8mb8PXsntLY=;
	b=iC8El0k3wnU/obyeFHlSYVmvckuKgJVc3jl2tI66TevziuyowclzjQL23ZKJVzEs5zXKpy
	kwCto+trfKkQrIAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795524294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RHHNML+FKm9z7LwFp3WDueu+F5fVE10g8mb8PXsntLY=;
	b=RbEv5f6gB5nlVqtolL6on8tY9DuJ3P+Kd5qCXGEqJLt9nKh7Wyh6v6Gheaxf2CHDnRryJG
	Avyt89NEJcd9HB7XOGxRTLMqYS1mpDIQobVoQqQAyV0g5WMqVHwxA+x+MFJhrYwWmd3QTj
	Z06bZN4AQB2Ujz+xNTaTbZS3756TGNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795524294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RHHNML+FKm9z7LwFp3WDueu+F5fVE10g8mb8PXsntLY=;
	b=OghHJpX4w8wdUU3YqPSZJaB+0M89g1NaHsqYkQMTHQzAu/TfwznId7ByXi4oYs3sBF95q0
	Adzwjt+7unJgxSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 932B41339F;
	Tue, 24 Nov 2026 12:44:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9xEYHMaGBWtNFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 12:44:54 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2835227877; Tue, 24 Nov 2026 13:44:50 +0100 (CET)
Date: Tue, 24 Nov 2026 13:44:50 +0100
From: Jan Kara <jack@suse.cz>
To: Peng Hao <flyingpenghao@gmail.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: Set the superblock UUID
Message-ID: <3q5wrdbsvxazaxru2psssue3mndvxt6x63clnwo3mijvbhj5td@v553ni2vd7bf>
References: <20261123044826.93953-1-flyingpeng@tencent.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123044826.93953-1-flyingpeng@tencent.com>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,tencent.com:email,suse.com:email]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 23-11-26 12:48:26, Peng Hao wrote:
> ext2_fill_super() never sets sb->s_uuid, so everything that uses the
> filesystem UUID through the VFS sees a null UUID on ext2:
> 
>  - IMA/EVM policy rules with fsuuid= never match;
>  - EVM HMACs that include the UUID (EVM_ATTR_FSUUID) don't bind to the
>    filesystem;
>  - FS_IOC_GETFSUUID fails with -ENOTTY;
>  - overlayfs can't tell lower layers on different ext2 filesystems apart
>    and falls back to xino=off,index=off,nfs_export=off.
> 
> This was found with the BPF selftest test_ima, which creates an ext2
> image, adds a "measure func=BPRM_CHECK fsuuid=<uuid>" rule and expects
> a binary executed from that image to be measured.  It only passes when
> ext2 images are mounted by ext4 (CONFIG_EXT4_USE_FOR_EXT2), which sets
> the UUID.  With CONFIG_EXT2_FS=y nothing is measured:
> 
>   test_test_ima:FAIL:num_samples_or_err unexpected num_samples_or_err: actual 0 != expected 1
> 
> Set the UUID from the on-disk superblock the same way ext4 does.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>

Good catch! Thanks. Added to my tree.

								Honza

> ---
>  fs/ext2/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index a40f530872a4..5e36007b3ffd 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1007,6 +1007,7 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
>  	sb->s_max_links = EXT2_LINK_MAX;
>  	sb->s_time_min = S32_MIN;
>  	sb->s_time_max = S32_MAX;
> +	super_set_uuid(sb, es->s_uuid, sizeof(es->s_uuid));
>  
>  	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV) {
>  		sbi->s_inode_size = EXT2_GOOD_OLD_INODE_SIZE;
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
