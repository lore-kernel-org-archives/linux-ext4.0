Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812036;
	b=l0o4u/cu2rUS4xtCxgn7hAJG0sClJDZ3var4slqiwT6IJnvh1Z8YTX1KlKbN5TI7+9eD
	 7wqCkv9d2KGxajLdz2ikZ3KACXLC/X+FnnSFrJgcScXqY5solUsW4AVQ/QGqPEqAMQyu/
	 Ma+oxO5g4qhEBGXYlKQkBFemD+T7E21f/jYkHBMbxapqeQ1tVss//cjtm7WJ/WqWpmytw
	 a5GYWrvgHAhdjVFhUnJ2N2gpyoZwnKgFM1Te5QmwAI7ACYMds8vK9mWYcWcZsKdvOT9qO
	 PehW58+10ad0kAgxXSaTsuraNRuCgBz8HDKYouWJ8+PgFzDgJimtivQmg8Wc/QJLc1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812036;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=aNDPKOPejKWaDge59K9+Y4zvO9k5lOGA3Jkf04Pk/QY=;
	b=yDFjcQdHQ921nyr66Gr4P7766EttcmXFigqFtuF9uxrBS7lgdgbczV3tZC6hhSQYvm7M
	 e3WJULPSgZTjsPA7CKaNnWtLSDtot0o9bOAF57OTjHaIm4bIkdkeVKAOaCVHinnObhSop
	 ZMjBemLGjsH3tl4VzRZonTXC9naeLPYWI/e7SoXfKT8bxGNY7qq+akiXkkHPhJjomF1RU
	 DZ171mjkREcO9lv6qVRDXcLG/etPUAgMerP7ZaAUtSFHO09vMIVW1Ue2bjFsNwo13wNHE
	 mMMYctUFI/2qD01EwGa0kWWHmCohvtriA1/CqapY6Qywbl2Q6RkvxYRoqg+FavmdybA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ItA2E3p4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=62553P6V;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ItA2E3p4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=62553P6V;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F714606A326;
	Wed,  4 Nov 2026 17:07:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F714606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ItA2E3p4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=62553P6V;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ItA2E3p4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=62553P6V
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 751B41F388;
	Wed,  4 Nov 2026 17:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNDPKOPejKWaDge59K9+Y4zvO9k5lOGA3Jkf04Pk/QY=;
	b=ItA2E3p4o9qbG5LaRFWOhTqNeU0Eepe+Uw9UgIjt6b6Sjip5Y4p9tHm/9X8/t1R1i+8eIP
	FEV+OgrvYzbajR/JvwqIIzwsP9w5xHJRCsufbKzpjWMLjaq/5NsigMIy2aKQN9C9yj/tSU
	0kKHX4DD7Na5zDWrJLylYZ8tcPeGBpU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812033;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNDPKOPejKWaDge59K9+Y4zvO9k5lOGA3Jkf04Pk/QY=;
	b=62553P6V5yueYuV+re3HE/rB6ZrmSUnWEJrrN9vhf8JEM6mhbguBY5lKWKeAXis2KR7WGb
	Yt7PrhNIxt7fMXAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNDPKOPejKWaDge59K9+Y4zvO9k5lOGA3Jkf04Pk/QY=;
	b=ItA2E3p4o9qbG5LaRFWOhTqNeU0Eepe+Uw9UgIjt6b6Sjip5Y4p9tHm/9X8/t1R1i+8eIP
	FEV+OgrvYzbajR/JvwqIIzwsP9w5xHJRCsufbKzpjWMLjaq/5NsigMIy2aKQN9C9yj/tSU
	0kKHX4DD7Na5zDWrJLylYZ8tcPeGBpU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812033;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNDPKOPejKWaDge59K9+Y4zvO9k5lOGA3Jkf04Pk/QY=;
	b=62553P6V5yueYuV+re3HE/rB6ZrmSUnWEJrrN9vhf8JEM6mhbguBY5lKWKeAXis2KR7WGb
	Yt7PrhNIxt7fMXAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B3B0134A5;
	Wed,  4 Nov 2026 17:07:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hB+FCUFm62p4FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 17:07:13 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C5AD4B445; Wed, 04 Nov 2026 18:07:04 +0100 (CET)
Date: Wed, 4 Nov 2026 18:07:04 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 3/9] ext4: add ext4_inode_loc_block() helper
Message-ID: <lqhym4n6vu46kretnwfstfutik4vl4l5imhnf6pi3aranjpryx@bgtxuzuha2zs>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-3-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-3-7d6c678a585d@kernel.org>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.30

On Thu 29-10-26 14:28:18, Christian Brauner wrote:
> Move the lookup of the inode table block out of
> ext4_get_inode_loc_noio() into a helper. ext4_sync_inode_metadata() is
> going to use it to find the block without reading it from disk.
> 
> No functional changes.
> 
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

So I don't think this patch is really needed. ext4_get_inode_loc_noio()
does exactly what you need so you can use it in the next patch. If you
really wanted to use sb_find_get_block_nonatomic() instead of
sb_find_get_block(), you can actually switch ext4_get_inode_loc_noio() to
use it.  ext4_get_inode_loc_noio() has only a single caller in ext4 -
ext4_fc_snapshot_inode() - that is actually fine to take the folio lock.
But that is mostly unrelated improvement to ext4.

								Honza

> ---
>  fs/ext4/inode.c | 38 +++++++++++++++++++++++++++-----------
>  1 file changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b4d581aa5ee1..b34b99d15db6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5874,16 +5874,14 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
>  }
>  
>  /*
> - * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
> - * It looks up the inode table block in the buffer cache and returns -EAGAIN if
> - * the block is not present or not uptodate, without starting any I/O.
> + * Find the inode table block that holds @inode without looking at the block
> + * itself. Fills in iloc->block_group and iloc->offset.
>   */
> -int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
> +static int ext4_inode_loc_block(struct inode *inode, struct ext4_iloc *iloc,
> +				ext4_fsblk_t *block)
>  {
>  	struct super_block *sb = inode->i_sb;
>  	struct ext4_group_desc *gdp;
> -	struct buffer_head *bh;
> -	ext4_fsblk_t block;
>  	int inodes_per_block, inode_offset;
>  	unsigned long ino = inode->i_ino;
>  
> @@ -5902,15 +5900,33 @@ int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
>  	inode_offset = ((ino - 1) % EXT4_INODES_PER_GROUP(sb));
>  	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
>  
> -	block = ext4_inode_table(sb, gdp);
> -	if (block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) ||
> -	    block >= ext4_blocks_count(EXT4_SB(sb)->s_es)) {
> +	*block = ext4_inode_table(sb, gdp);
> +	if (*block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) ||
> +	    *block >= ext4_blocks_count(EXT4_SB(sb)->s_es)) {
>  		ext4_error(sb,
>  			   "Invalid inode table block %llu in block_group %u",
> -			   block, iloc->block_group);
> +			   *block, iloc->block_group);
>  		return -EFSCORRUPTED;
>  	}
> -	block += inode_offset / inodes_per_block;
> +	*block += inode_offset / inodes_per_block;
> +	return 0;
> +}
> +
> +/*
> + * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
> + * It looks up the inode table block in the buffer cache and returns -EAGAIN if
> + * the block is not present or not uptodate, without starting any I/O.
> + */
> +int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	struct buffer_head *bh;
> +	ext4_fsblk_t block;
> +	int err;
> +
> +	err = ext4_inode_loc_block(inode, iloc, &block);
> +	if (err)
> +		return err;
>  
>  	bh = sb_find_get_block(sb, block);
>  	if (!bh)
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
