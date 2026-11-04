Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812160;
	b=qLEn6eJ0m2TLBF/0ucDvL1MaQOT936CDk35ScaAmze0Ogmw1HOajkZ8EIwdmknEWrH9g
	 mT0rIIY0lQVvtF4vcelIzWTgv2PrNqhD8PgcLet4EqNk+//v5OeOVa+pR0Bavy9TSzcyT
	 EO1M9XkSNAOil3F70WeoQmVh1AqhZqz9bxX9lDp9XkSjd+zeeF+z1QCHLsv0YFUh7DdPB
	 vzYsDxpN2sfOGLxHzxK2peo231L+jtmn7fa3waZX8WJRtJUnEbBM6MYMRuOF5Pg6PKMhL
	 K3H2lRU8BRWkveHyCugrzRnXucYVH+QJEEzOtPVtb7TtaZWUCsmzrElaJCtVB4KHicw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812160;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=lslXqdTd4kVUVRGQwZcsY/gAafwjWwTc+VvCFwnutQs=;
	b=l9m4Q6/E72HIq432RKrefQTiSs6uafjmEPbzXLkq2fqy3AahPIrR21+zFJo9uGVFbJgw
	 RMOmRxvGm9fDstg19nPy/YFjigWUygZwOJT555Xo7ZybIaELPs90UAb8DKWmZTnv4RC1q
	 OQ0Tom0hRgOWpTRgsr/XIlXihwFkVS2Kv+AFriIyAe0KMllOQ01LUgVYq7IlIwvLdjvI0
	 jD7wAFeWBDR8i1ko79iWOB539aFPHBrHi4v/BJS+7sWwn7NaGv7LJ2RL0nHucllMx5Az/
	 bnylcRdkYnvSFAJ3eIprwjx42DCsmhn0HTonWYHwSkMtQvhVpyiU/lxxO5PFvCEMadQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qVtImgmc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2JlwMWhD;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tJHcCZBg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HJQerC4i;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB04C606A31B;
	Wed,  4 Nov 2026 17:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB04C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qVtImgmc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2JlwMWhD;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tJHcCZBg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HJQerC4i
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA2C721E8B;
	Wed,  4 Nov 2026 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812158; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lslXqdTd4kVUVRGQwZcsY/gAafwjWwTc+VvCFwnutQs=;
	b=qVtImgmcEznrZfN15fRL5lQQ+YR00M3sPYthOV2QpeVVkD2KhIgjGYb5NZty0jH35UBhCE
	mpupciauVP+VIOLH2AK/4p+QIcltOKxx0J5ZD6IdlbEnyqhFjhTvXTEuH/gM54wCSgEHWl
	7PolSTVSNz5DHRvl02v4ykEtVFlwHY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812158;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lslXqdTd4kVUVRGQwZcsY/gAafwjWwTc+VvCFwnutQs=;
	b=2JlwMWhDyL+nIp1E6z//UMHM8+pQN/yctBkVI0+8nIvrfYvJ1zoBdQkMpv0KU67NspxT3A
	jXgPJlrg6XsdWLAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tJHcCZBg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HJQerC4i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lslXqdTd4kVUVRGQwZcsY/gAafwjWwTc+VvCFwnutQs=;
	b=tJHcCZBgREw80c0bMNYNjFimg+HEb2C/HV07xcfTndN6uZNzY2a71rCXh+aaS57rksX3hV
	9K0PdjhuWEX9YqKFaS1PBCWhr9/CvI4Xebc2a/OioWvFzt1QE3kQomrrvphgEbSOXgFBWp
	6Mkyy/55m/5t4RX2hAn6PcdAfPXrO3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lslXqdTd4kVUVRGQwZcsY/gAafwjWwTc+VvCFwnutQs=;
	b=HJQerC4ij6FIPym0EpIIpp5Nwgyqmh1GT5w+Lk+G+T71iFXmggJ5ledCc2lJHA9jhv1jng
	KLs10j2iTt4PYFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97F3A134A5;
	Wed,  4 Nov 2026 17:09:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rSnaGrxm62ohFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 17:09:16 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 15AC9B447; Wed, 04 Nov 2026 18:09:01 +0100 (CET)
Date: Wed, 4 Nov 2026 18:09:01 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 5/9] minix: add minix_inode_block() helper
Message-ID: <vgt2gg2lp4z3j3kgvbrboya7zb3ejl35i54jm32swv3yzobege@fbalmj5r64zk>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-5-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-5-7d6c678a585d@kernel.org>
X-Rspamd-Queue-Id: CA2C721E8B
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.51

On Thu 29-10-26 14:28:20, Christian Brauner wrote:
> Move the lookup of the block that holds an inode out of
> minix_V1_raw_inode() and minix_V2_raw_inode() into a helper.
> minix_sync_inode_metadata() is going to use it to find the block
> without reading it from disk.
> 
> No functional changes.
> 
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/minix/bitmap.c | 37 +++++++++++++++++++++++--------------
>  fs/minix/minix.h  |  1 +
>  2 files changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
> index abec438330a7..deac05472bef 100644
> --- a/fs/minix/bitmap.c
> +++ b/fs/minix/bitmap.c
> @@ -103,21 +103,35 @@ unsigned long minix_count_free_blocks(struct super_block *sb)
>  		<< sbi->s_log_zone_size);
>  }
>  
> -struct minix_inode *
> -minix_V1_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
> +/* Return the block that holds inode @ino or 0 if @ino is out of range. */
> +int minix_inode_block(struct super_block *sb, ino_t ino)
>  {
> -	int block;
>  	struct minix_sb_info *sbi = minix_sb(sb);
> -	struct minix_inode *p;
> +	int inodes_per_block;
>  
>  	if (!ino || ino > sbi->s_ninodes) {
>  		printk("Bad inode number on dev %s: %ld is out of range\n",
>  		       sb->s_id, (long)ino);
> -		return NULL;
> +		return 0;
>  	}
> +	if (sbi->s_version == MINIX_V1)
> +		inodes_per_block = MINIX_INODES_PER_BLOCK;
> +	else
> +		inodes_per_block = sb->s_blocksize / sizeof(struct minix2_inode);
> +	return 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
> +		 (ino - 1) / inodes_per_block;
> +}
> +
> +struct minix_inode *
> +minix_V1_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
> +{
> +	int block;
> +	struct minix_inode *p;
> +
> +	block = minix_inode_block(sb, ino);
> +	if (!block)
> +		return NULL;
>  	ino--;
> -	block = 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
> -		 ino / MINIX_INODES_PER_BLOCK;
>  	*bh = sb_bread(sb, block);
>  	if (!*bh) {
>  		printk("Unable to read inode block\n");
> @@ -131,19 +145,14 @@ struct minix2_inode *
>  minix_V2_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
>  {
>  	int block;
> -	struct minix_sb_info *sbi = minix_sb(sb);
>  	struct minix2_inode *p;
>  	int minix2_inodes_per_block = sb->s_blocksize / sizeof(struct minix2_inode);
>  
>  	*bh = NULL;
> -	if (!ino || ino > sbi->s_ninodes) {
> -		printk("Bad inode number on dev %s: %ld is out of range\n",
> -		       sb->s_id, (long)ino);
> +	block = minix_inode_block(sb, ino);
> +	if (!block)
>  		return NULL;
> -	}
>  	ino--;
> -	block = 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
> -		 ino / minix2_inodes_per_block;
>  	*bh = sb_bread(sb, block);
>  	if (!*bh) {
>  		printk("Unable to read inode block\n");
> diff --git a/fs/minix/minix.h b/fs/minix/minix.h
> index db92cf9e0e1b..67d8e2a7dc06 100644
> --- a/fs/minix/minix.h
> +++ b/fs/minix/minix.h
> @@ -47,6 +47,7 @@ void __minix_error_inode(struct inode *inode, const char *function,
>  			 unsigned int line, const char *fmt, ...);
>  
>  struct inode *minix_iget(struct super_block *, unsigned long);
> +int minix_inode_block(struct super_block *sb, ino_t ino);
>  struct minix_inode *minix_V1_raw_inode(struct super_block *, ino_t, struct buffer_head **);
>  struct minix2_inode *minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
>  struct inode *minix_new_inode(const struct inode *, umode_t);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
