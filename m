Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE0844064F;
	Mon,  5 Oct 2026 11:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791199463; cv=none; b=FlAxvWKiyod2UWSr3zxeDLvDhQyjtDER7uZS+czgHU7EeqiqXmF1lGAyk+uJzRDf1vigAHhv5nvzz78CaSlX3H2iVhv0mS9RD4schaJMzgbmkWmsRqr11WpZB5Iw4C/JwY4a4TYwQ8MmoIHX1UzbXTUwPpxLs95iNx5mQalJul8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791199463; c=relaxed/simple;
	bh=CSmPIaDtkWmRAxvi4z+Q9eQC29zs0bT3atX6Q0/C5Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cHw92CWMuWSzDmbx9rfEQ6XZDObhZKU2FiUAHDvBzHE3GY60WK3ir12TvQwKk348XyAKvAd/zvQLXeDbushxdpMdFuJhLTqEgOkB0SWjkhUcasp6khuExmnCPqePrMN9Ix4Vp/VMJ5RXdQ5YHxIxCjFx3p54uk8hRkdiLjgb2lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nnzImiYC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kl54yzLG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ki1VvQnq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VwKRGgiA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nnzImiYC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kl54yzLG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ki1VvQnq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VwKRGgiA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8CDBA21E1D;
	Mon,  5 Oct 2026 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791199455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxuTGo+tTIY0PEAiPDgmHhIZ8B8hxAoW13unw98BYfg=;
	b=nnzImiYCQ6kvgG+WQsafICCmJR6sBtcg8ywK9RAdI7lCenpKlSC78+jXmEZcR3aTXnNJXw
	UISI6ailJCmxCNgN8Mlmoi+3rOHVmUyB6PlH470Z5RaDLErxHciuK+IZBakSOomwDL85hU
	KoUKCw2rhra0OepCCOyXeWPcs16Xb9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791199455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxuTGo+tTIY0PEAiPDgmHhIZ8B8hxAoW13unw98BYfg=;
	b=Kl54yzLGqVtE9ws4tSmmYQ0cGmr0uDesz8wQHzLRkWbNir4CtlxdUDiSgHRs8pu3mXNWbw
	z9jlikUGaSJ2kOAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ki1VvQnq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VwKRGgiA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791199451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxuTGo+tTIY0PEAiPDgmHhIZ8B8hxAoW13unw98BYfg=;
	b=Ki1VvQnqOv8JnHDjKcdV6r06Y9JVXFBx2i9PNEZNJuqmSkMGkHvaR3V4HtHbZ9gpvzZXBS
	9/j8/AWlsUL54OlemVs/75iH4yMvC97rR5pC1PGAhdjcO457D2efPELpHXxDPD35Rxev0S
	+D04PO94Od8ldvpIvm2+5fNGSB2zBZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791199451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxuTGo+tTIY0PEAiPDgmHhIZ8B8hxAoW13unw98BYfg=;
	b=VwKRGgiA98NAQVkvbHfjx35QDyISzXeNYTnCM7Z5PpENiA0rSQ2/xLmgQYaXlJFISAbEE6
	kjGvzGxG0D3F4JBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 55B6913A58;
	Mon,  5 Oct 2026 11:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ll5FDNuIw2p9YgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 05 Oct 2026 11:24:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 723E8A13FB; Mon, 05 Oct 2026 13:15:56 +0200 (CEST)
Date: Mon, 5 Oct 2026 13:15:56 +0200
From: Jan Kara <jack@suse.cz>
To: Adriano Cordova <adrianox@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ext4: don't append a directory block already mapped
 in the inode
Message-ID: <ypwk5uwc6zmjksnqwsdj3wuajns5khoelq5uzln35opszdpfpd@rluzpxvpfroe>
References: <20261005003528.92046-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005003528.92046-1-adrianox@gmail.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8CDBA21E1D
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[09bec78ee77613a3efdd];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

Hello!

On Sun 04-10-26 21:35:28, Adriano Cordova wrote:
> ext4_append() grows a directory by one block.  It checks that the target
> logical block is a hole, but a corrupt block bitmap can still make the
> allocator hand back a physical block that is already in use by this
> inode.  The in-memory copy of a block is keyed by its physical block
> number, so the "new" block and that existing one are the same memory;
> callers that split a directory (make_indexed_dir()/do_split()) then move
> entries between two aliased buffers and corrupt the directory, until a
> bogus rec_len read from the middle of a name runs the wipe out of bounds:
> 
>   BUG: KASAN: slab-use-after-free in dx_move_dirents [inline]
>   Write of size 90458 ...
> 
> Reject the block and report the corrupt bitmap instead of corrupting
> memory.
> 
> Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
> Tested-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Signed-off-by: Adriano Cordova <adrianox@gmail.com>

Good that you tracked down the reason for the corruption. But what you do
below isn't really a good fix and I don't think you've put too much thought
into it. Firstly, it would work only in the specific case this syzkaller
reproducer triggers where the same block is claimed twice by the same inode
(but other inodes can end up claiming the block as well!). Secondly, it
would heavily slow down appending to large directories.

Frankly, I don't think this case of multiply claimed blocks is easy to deal
with. To properly solve it you would need something like storing in the
struct buffer_head the type of metadata (and perhaps inode & offset owning
it) when loading metadata from the disk and then validating this when
getting the buffer head from cache. But it's a lot of work and practically
only to make fuzzer of disk images happy so I'm not really sure it's worth
it.

								Honza


> ---
> Changes in v2:
> - Rework after review of v1 ("ext4: wipe moved dirents with their real
>   length"). dx_make_map() already validates each entry, so the bad
>   rec_len does not come from disk. The problem is that the block
>   allocator was handing back a block already mapped by the inode.
> 
>  fs/ext4/namei.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3b9740c1c16d..ff6013306b74 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -83,6 +83,25 @@ static struct buffer_head *ext4_append(handle_t *handle,
>  	bh = ext4_bread(handle, inode, *block, EXT4_GET_BLOCKS_CREATE);
>  	if (IS_ERR(bh))
>  		return bh;
> +
> +	for (map.m_lblk = 0; map.m_lblk < *block; map.m_lblk += map.m_len) {
> +		map.m_len = *block - map.m_lblk;
> +		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (err < 0)
> +			goto out;
> +		if (err == 0) {
> +			map.m_len = 1;
> +			continue;
> +		}
> +		if (unlikely(map.m_pblk == bh->b_blocknr)) {
> +			EXT4_ERROR_INODE(inode,
> +					 "new block %llu already mapped",
> +					 (unsigned long long)bh->b_blocknr);
> +			err = -EFSCORRUPTED;
> +			goto out;
> +		}
> +	}
> +
>  	inode->i_size += inode->i_sb->s_blocksize;
>  	EXT4_I(inode)->i_disksize = inode->i_size;
>  	err = ext4_mark_inode_dirty(handle, inode);
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
