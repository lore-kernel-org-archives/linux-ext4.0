Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208FA408617
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974950; cv=none; b=K8KEZKarw4HQ2LsWndTkcWKGB281ven2+5wrPEuHpHKGoHeHLSozndlZuDUpNssBx3gmHviUy79TTPmGpLiyr0AKW/eNjxyHkxgGM6ZkBowigZFeT+gvAeZn3i4Oo1uOMlDEFHyih+F3dKegju5K8hjayWzwR4B+hbgdMNKVFhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974950; c=relaxed/simple;
	bh=q2xFimZEHWth/JqYHGC/Wdb/XA9sRnGvKlfd4Nee3oU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VriS+V9VyKRlMR2eofGRdWuzngDTqrr8V5G6A/NeWkCPThkQzZUW2PtNA48zZo9J0X+ZzngzvwDqZ2YzBRahp2z+majVttzsKDSOH2L1rM2fs83QKhTK90nrRBWVle+2wgtbmoI/ZVyokMQRIN0xj0xdd9Mm/eR/ecdW99gygsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qWqNkYMs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sPAvZZLU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WioCQXVM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L7fqHnIA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qWqNkYMs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sPAvZZLU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WioCQXVM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L7fqHnIA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A28F53E26;
	Mon, 17 Aug 2026 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786974935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgFNQ9EiQKOc/YQ4E/z2DvtHKT12MLZ58E+TRH4euSU=;
	b=qWqNkYMsehAJ2Wm1UjNuMs8Hh8jXabwo3AJugcTbBTVwlaXq5fLQa+0/XVlHaV92sVPlBh
	kPgn52Apf7u23PrvzxRTlV4F+KmsQTGFOW5BSz4zfF7wn9fpGVS9o3xK09fuhF0SIeCskT
	RJb2F8KPJVzkZ7n5BgbI3YP3cu2OqK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786974935;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgFNQ9EiQKOc/YQ4E/z2DvtHKT12MLZ58E+TRH4euSU=;
	b=sPAvZZLUgZNaSmkg6MUefwywO9Ox/dFtPgIAyVZGJSYF0p2A5JIPxFrztITeVCRnL7c/X9
	6jINlfdS72tNP/DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WioCQXVM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L7fqHnIA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786974931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgFNQ9EiQKOc/YQ4E/z2DvtHKT12MLZ58E+TRH4euSU=;
	b=WioCQXVMv425vaaLA5OQnPVHhPVEYPIk9maMzxl4kqDg/O6moKqxUBOnEd5TyJtHD2sDz8
	EzF+w2sNLbxenWcvXosOyHfyb73NZF2iVa271b/dy025hbXMtWWIRfLR9Ft581UZZT4rv4
	nU7xlKwEYIawhRt0QQHShariR8VSFi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786974931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgFNQ9EiQKOc/YQ4E/z2DvtHKT12MLZ58E+TRH4euSU=;
	b=L7fqHnIAmA7sQJbj1G1LB4a6gzeOcOG6iMGcFnMvrPSuXyGpJ/HKYq7T5o1+nDDE3lv1ie
	BRiZyLwPqY8/EBCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95555794CA;
	Mon, 17 Aug 2026 13:55:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yczUI9MSg2quXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 13:55:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 27DA9A13B5; Mon, 17 Aug 2026 15:55:31 +0200 (CEST)
Date: Mon, 17 Aug 2026 15:55:31 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Avoid entering writeback paths during fastcommit
 replay
Message-ID: <modcan55tuaiafsm7ki7zpvulvicck5aqt7msu26indxzyj2sk@dqcm62sh3y4n>
References: <20260804104112.93202-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804104112.93202-2-jack@suse.cz>
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A28F53E26
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Hello Christian!

With all the vacations going on this fixup to apply on top of vfs-7.3.sync
branch seems to have fallen through the cracks (I guess the note below the
changelog was too hidden, next time I'll try to indicate this is a fixup
inside the subject - maybe like [PATCH FIXUP vfs-7.3.sync]). Anyway, can
you please pick it up and push it to Linus later during the merge window?
Thanks!

								Honza

On Tue 04-08-26 12:41:13, Jan Kara wrote:
> Fastcommit replay effectively happens in nojournal mode. This results in
> ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
> we end up entering filesystem writeback functions. However during
> fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
> crash.
> 
> Fix the problem by avoiding setting I_METADATA_WRITEBACK during
> fastcommit replay. Journal replay flushes the whole block device after
> replay anyway so all metadata is properly persisted and replay is faster
> this way as a bonus.
> 
> Fixes: c26339e1df33 ("ext4: Fix data integrity writeout issues in nojournal mode")
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Christian, please add this fixup to my sync fixing series. Thanks!
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7a1f961cd11c..12ff84ab5741 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6408,9 +6408,10 @@ int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
>  int ext4_mark_iloc_dirty(handle_t *handle,
>  			 struct inode *inode, struct ext4_iloc *iloc)
>  {
> +	struct super_block *sb = inode->i_sb;
>  	int err = 0;
>  
> -	err = ext4_emergency_state(inode->i_sb);
> +	err = ext4_emergency_state(sb);
>  	if (unlikely(err)) {
>  		put_bh(iloc->bh);
>  		return err;
> @@ -6425,9 +6426,13 @@ int ext4_mark_iloc_dirty(handle_t *handle,
>  	put_bh(iloc->bh);
>  	/*
>  	 * Mark that there's metadata writeout pending for the inode so that it
> -	 * gets properly flushed on fsync(2) and similar.
> +	 * gets properly flushed on fsync(2) and similar. We don't bother for
> +	 * fastcommit replay as that flushes the whole bdev afterwards anyway.
> +	 * It is faster this way and we avoid entering fs writeback paths which
> +	 * aren't fully initialized yet.
>  	 */
> -	if (!EXT4_SB(inode->i_sb)->s_journal) {
> +	if (!ext4_handle_valid(handle) &&
> +	    !(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY)) {
>  		/*
>  		 * Inode didn't need to go through dirtying, make sure it is
>  		 * attached to wb so that writeback can handle it.
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
