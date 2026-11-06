Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978415;
	b=2ahdCh1qlEOPk6IFaIgKKebpsXqhvpPYQjH9nGLKgfPEXBvYwSvX4eVP32rRVw1IJ5nR
	 DELTrrmUogeIrd43PcGE7Ttx/ejr+5BxpewP3GSqYtuV8L8iLh4Web6wzMcMOJqI+oP4k
	 byw+5a1OPtwV4rOi/nx3WxA5iytfSD6WkBXQp183+POFsrSte2yXTLbHnogforDmyGdj7
	 MNR49MKDtn8H+VnI/l1cCMekqJC4uSVdmBhcLSp+1VewbdLjHWsCEuFQhnnmPD7fqvsPz
	 HxqarrBwkyIr9KfMYnK4P30l7CXcPJSlmCGGbuPaVb0m1qfuGPmT8TfaOQLQhu4TV+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978415;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=0DnTiF9N9jt7RPoZedsxqY90E/mEdXt4Hpb/OqsC/sk=;
	b=DW3WFIvQpc/dc54f90gOqCY0/qVrxNt0spr6B+PisAVQWg14E/ic+RBXnHGmw1hUOz/m
	 T0zr4TPRAgDoQHzT4lk2DdXSzQz+LzEfr1Mnqn5dUznRYNyTt9UFNfypfdlWg9/2sL20+
	 qTnrV4HoZlMuoBYrcrbOxEq2RGvAFe8ithjhZ07CXef0REuEjS/QG90oMdq3QCxvAyVdf
	 C92orpyntMJ4+1eXDwDyfv5nR9lf/TLptsH9T6iXOHEqBaoFo6yu8Egl9uZXqyOI8jw4M
	 5wPElK5hfibACzpBNsGOOwKUXBNFns+QAW7u/qQ+vvxmkzroTXgnNBScIYta9AC2TYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uokVctPJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CJZM6kQ5;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uokVctPJ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CJZM6kQ5;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5616082BD9;
	Fri,  6 Nov 2026 15:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD5616082BD9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uokVctPJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CJZM6kQ5;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uokVctPJ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CJZM6kQ5
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1037822142;
	Fri,  6 Nov 2026 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793978413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0DnTiF9N9jt7RPoZedsxqY90E/mEdXt4Hpb/OqsC/sk=;
	b=uokVctPJL1pYh7Rg+LQmvz1lo48i4CXOYwFsdGIOUhIjurqg0Zaa6xD5/PzAUnE81mToWo
	I8wZHnd51kC0+lKi2zAh+B/B72Z2BshxQMqte+5AsPWkfhoBRmD/K+AH97VqGEHSeYRG1N
	mhufisMDXrB/FNgFuzeRe/Y6bO5PI6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793978413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0DnTiF9N9jt7RPoZedsxqY90E/mEdXt4Hpb/OqsC/sk=;
	b=CJZM6kQ5nJkRpwgYh2lx359Vt9HVadoNyyq/+Yo9AR1BoToH2yrz8D/rY/oWtyemUHcZlY
	rAErZSvbLq+Q1vBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uokVctPJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CJZM6kQ5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793978413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0DnTiF9N9jt7RPoZedsxqY90E/mEdXt4Hpb/OqsC/sk=;
	b=uokVctPJL1pYh7Rg+LQmvz1lo48i4CXOYwFsdGIOUhIjurqg0Zaa6xD5/PzAUnE81mToWo
	I8wZHnd51kC0+lKi2zAh+B/B72Z2BshxQMqte+5AsPWkfhoBRmD/K+AH97VqGEHSeYRG1N
	mhufisMDXrB/FNgFuzeRe/Y6bO5PI6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793978413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0DnTiF9N9jt7RPoZedsxqY90E/mEdXt4Hpb/OqsC/sk=;
	b=CJZM6kQ5nJkRpwgYh2lx359Vt9HVadoNyyq/+Yo9AR1BoToH2yrz8D/rY/oWtyemUHcZlY
	rAErZSvbLq+Q1vBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D764D134E9;
	Fri,  6 Nov 2026 15:20:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bZuhLCzw7Wr5KQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 15:20:12 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6609621BB3; Fri, 06 Nov 2026 16:20:08 +0100 (CET)
Date: Fri, 6 Nov 2026 16:20:08 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC v2 04/13] ext4: use sb_find_get_block_nonatomic() in
 ext4_get_inode_loc_noio()
Message-ID: <zprc66sa2mttik7thumhs32euuweb25jse3zcgxudbm3eij4yx@hhivkadfbjl5>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-4-48628c60c336@kernel.org>
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
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-4-48628c60c336@kernel.org>
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 1037822142

On Thu 05-11-26 13:41:33, Christian Brauner wrote:
> ext4_get_inode_loc_noio() looks the inode table block up with
> sb_find_get_block(). That's the atomic lookup. It serializes against
> try_to_free_buffers() with i_private_lock instead of the folio lock and
> gives up if the folio is being migrated. So it can report the block as
> not cached while it is.
> 
> For ext4_fc_snapshot_inode() that only means falling back to a full
> commit. But ext4_sync_inode_metadata() is going to use
> ext4_get_inode_loc_noio() to find the inode block that fsync() has to
> write out and there a dirty block must not be skipped.
> 
> ext4_fc_snapshot_inode() is the only caller and it can sleep. It runs
> under jbd2_journal_lock_updates() and allocates the snapshot with
> GFP_NOFS. So use sb_find_get_block_nonatomic() which takes the folio
> lock and waits for the migration instead.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b4d581aa5ee1..4484c2383eaf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5876,7 +5876,8 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
>  /*
>   * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
>   * It looks up the inode table block in the buffer cache and returns -EAGAIN if
> - * the block is not present or not uptodate, without starting any I/O.
> + * the block is not present or not uptodate, without starting any I/O. It may
> + * sleep on the folio lock of the block.
>   */
>  int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
>  {
> @@ -5912,7 +5913,7 @@ int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
>  	}
>  	block += inode_offset / inodes_per_block;
>  
> -	bh = sb_find_get_block(sb, block);
> +	bh = sb_find_get_block_nonatomic(sb, block);
>  	if (!bh)
>  		return -EAGAIN;
>  	if (!ext4_buffer_uptodate(bh)) {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
