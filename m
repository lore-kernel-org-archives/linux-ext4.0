Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980220;
	b=eBHggFyp6KT18GWfQ3D3frV4R6RS70r2Rp5YLNzqNrS7jwS48kCv68PuBIYrAcwPSfLU
	 /2EEgDFg9cFfbLDP+XwKkCu+qKOTSrDwSwKvrQ6Dw72mHhnOAiUiNfWy0MBe2fgRxPvmA
	 PhWQg1gE4sRHkjMJApr6RL2NRJa/gKpRsjGAH/A2yhbs9xJc5nlV0f5XYRmin4Dz/j8xB
	 lfiwYqh1gBzKjpLAI90TQHQURkBSVvNDoGzIzgsWuf5+ba5TujHjT3dav772HN6+GRbig
	 MAr9HXt+rik9aY2VTZT2pbgsc1tfbXxzXUOFN3o+gtgetqwfQ115UnPGe+Bke9DKMHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980220;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=zTp9Cr20AR6CKCk5U+cw0acbXY2MwUTtO0/pfsY8yQ4=;
	b=rcregFGIzAmBubvjALeODQLKV3n1IbMRHFN0oDEMtZa4FLmO96FFbhBBCS4SoC79Ui+8
	 8rqgyI3/5lazYITRGLidZWP1ZZD1rkjyI3YkheAnOIBsqU4Q+msRm5hZ1eht5qaxfbGP6
	 1ebWybyulo5Jg41UKAsugU3MtvcCk1ovAaJwUfPAdQZwNQRmsKcynkHrLcv4zfAKXV/v9
	 mNw4YYBe/WFWSZzHPqfCXdr7jVvG3TMN+7edZS2VG34z4OMJnLsBv6BSf/X9YwChV1yre
	 jLZ37rT0aUUb/00p8IRYzn1cYpNM6DG58nCkdYWvo6TGvZOTjye6UE/8wDnWjbv3nfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vgCCwJGK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BWqGICap;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vgCCwJGK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BWqGICap;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE3606A326;
	Fri,  6 Nov 2026 15:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AFE3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vgCCwJGK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BWqGICap;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vgCCwJGK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BWqGICap
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 916871F78F;
	Fri,  6 Nov 2026 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793980217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTp9Cr20AR6CKCk5U+cw0acbXY2MwUTtO0/pfsY8yQ4=;
	b=vgCCwJGKbxqXUEjkqQTF5M5Urwy5sd/omWqyJOM9fFnpMtnNjRjiQAqv0EKvYiNrdI8EQl
	eP83z4c1kvA3YW4rLcN0VZnxR2wB8jUoqASArHLcRjJGtCkutb+4gWqVL93pCWDWAtrJef
	j8a+mIkttFPL7vSoF2V49++nrQrsDYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793980217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTp9Cr20AR6CKCk5U+cw0acbXY2MwUTtO0/pfsY8yQ4=;
	b=BWqGICapIqjyGC6Yj0OD3+tkyAskQ8ydsnJJhN7vhGL8pQoY7WMNgfKf6HMe1CuFEHVAV7
	TVnbKdYkovWoQ5DA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793980217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTp9Cr20AR6CKCk5U+cw0acbXY2MwUTtO0/pfsY8yQ4=;
	b=vgCCwJGKbxqXUEjkqQTF5M5Urwy5sd/omWqyJOM9fFnpMtnNjRjiQAqv0EKvYiNrdI8EQl
	eP83z4c1kvA3YW4rLcN0VZnxR2wB8jUoqASArHLcRjJGtCkutb+4gWqVL93pCWDWAtrJef
	j8a+mIkttFPL7vSoF2V49++nrQrsDYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793980217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTp9Cr20AR6CKCk5U+cw0acbXY2MwUTtO0/pfsY8yQ4=;
	b=BWqGICapIqjyGC6Yj0OD3+tkyAskQ8ydsnJJhN7vhGL8pQoY7WMNgfKf6HMe1CuFEHVAV7
	TVnbKdYkovWoQ5DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6487A134E9;
	Fri,  6 Nov 2026 15:50:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wVcUEDn37WoVSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 15:50:17 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E635A21BC9; Fri, 06 Nov 2026 16:50:16 +0100 (CET)
Date: Fri, 6 Nov 2026 16:50:16 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC v2 03/13] ext2: sync inode metadata in
 ext2_evict_inode()
Message-ID: <z2xbwyggdrfkoqalunacpfqtb3q7yqgg3m2qk2gdbrkgoios2m@blar7uefy42g>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-3-48628c60c336@kernel.org>
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
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-3-48628c60c336@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 05-11-26 13:41:32, Christian Brauner wrote:
> ext2_write_inode() copies the inode into its inode table block, marks
> the block dirty and sets I_METADATA_WRITEBACK so that a later fsync()
> writes the block out and waits for it. But the bit goes away with the
> inode. If the inode is evicted and read back in, fsync() finds a clean
> inode and returns while the block might still be dirty or under
> writeback.
> 
> Right now that can't happen because inode_lru_isolate() never lets go
> of an inode with I_METADATA_WRITEBACK set. That is about to change.
> 
> So call ext2_sync_inode_metadata() from ext2_evict_inode() for a linked
> inode that still has the bit set. It syncs the metadata buffers as well
> so it replaces the mmb_sync() there, and since the previous patch it
> doesn't read anything from disk.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

OK, only now I've realized that what you do here is indeed needed because
otherwise fsync(2) would miss calling .sync_inode_metadata() at all after
inode eviction so inode buffer won't be flushed. But seeing how things
evolve, it would look more natural to call set_inode_metadata_writeback()
from mmb_mark_buffer_dirty() and then the generic writeout mechanism in
evict() you had in v1 actually makes sense so we can return to it (and drop
mmb_sync() calls from the evict methods). Sorry for the confusion and going
there and back!

								Honza

> ---
>  fs/ext2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 9261b666d043..4ed727c3d26d 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -91,6 +91,14 @@ void ext2_evict_inode(struct inode * inode)
>  		if (inode->i_blocks)
>  			ext2_truncate_blocks(inode, 0);
>  		ext2_xattr_delete_inode(inode);
> +	} else if (inode_state_read_once(inode) & I_METADATA_WRITEBACK) {
> +		/*
> +		 * fsync() can't find what I_METADATA_WRITEBACK tracks once the
> +		 * inode is gone. This syncs the metadata buffers as well.
> +		 */
> +		ext2_sync_inode_metadata(inode, &(struct writeback_control) {
> +			.sync_mode = WB_SYNC_ALL,
> +		});
>  	} else {
>  		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
>  	}
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
