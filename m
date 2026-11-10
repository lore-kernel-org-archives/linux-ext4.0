Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306496;
	b=IHM6QSg9N+UbEz9NI5TyS2HC0Jx0Q+3GbOocqIA5+hliS3rJ1XS1SalhQacFqKU/Vd7z
	 s/va1lYqXsjZGXo1U7R/DiT6q1eQ83aSulqkZ3Xg6Obv62+FHo8G6Ixl9bfrkTEP9afIK
	 ye8UN+o/wK883Lx0yI9WUHhWy0eMUjumkbVQZYVNMpVWvJyqLwO3P2/AozDq1PtOFywXf
	 d4hTXJr1dRz9Q+gaUw/Atkj4treEdy8bTO5SENbPFcLOTMuiI500mQpfNEtccaXJARWEc
	 k/Y5pZ5KWN6zG/HR2dtUBLxB2QKH9wvQXtVbyFlySYnPyjG7D20eOizI81S+H37vehg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306496;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=AK+s3hJWcXrj5GwLU+M5YKfblnSJS/J6580o8fqd44g=;
	b=uY3HJFdRSMM/6vHX73PdVO4OI7oeiD4tk4EtDc2YY6ygszfG6gqBmqGp8INPNdc4fhAM
	 NFkdkMcPj0n+qM+7FRYuoP+5Ba43snIBJzP/8TOYSzxhDfYlHjq86tztDbxnBLh6A7pdV
	 kYoUPcnvV8pGqSoG5lTfyajZdug8t3sBLxWYg4zzEIuVjPZ08sGT9sLWjQhzTgJ1ghrRQ
	 zUA85rPljS8xOrHwYNNrFHaUL/5WW/POeJ5TMn34eaxG7yTZxjtViS5SlEAF003Qorqys
	 nNdM9t+X178pEUlSt5Gg0ZLqQakgifAQ6gGW8weAAX99CHeNFDWByfWeBXnAHrkRwnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xRU7nHP4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iL0HhHjT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xRU7nHP4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iL0HhHjT;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE2A606A31C;
	Tue, 10 Nov 2026 10:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AE2A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xRU7nHP4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iL0HhHjT;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xRU7nHP4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iL0HhHjT
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 24E7C1F7BF;
	Tue, 10 Nov 2026 10:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AK+s3hJWcXrj5GwLU+M5YKfblnSJS/J6580o8fqd44g=;
	b=xRU7nHP4qFkLaCrEWZvsPTpiU1AMFgsmgpXy927ohTCd+lq2zr8V8IkEIK/VNRNziP2C+z
	iekI1oZpCSel/o9mVnkP/MJMJtNl/IE4vMgXDU9S418RTIa/qO/rdLuKJKHlXLlAIVbyV5
	pdoYXuwLHJ4cq1kX1Hiecw8MeAyjojI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AK+s3hJWcXrj5GwLU+M5YKfblnSJS/J6580o8fqd44g=;
	b=iL0HhHjToBK6x6Nj9e8t/FKiF3KCRcgzUpwrX7uZYyZyGKe/RJLjzQcxOMfsxZzdm0TqEx
	pMjGSXnxLRK4zrAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xRU7nHP4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iL0HhHjT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AK+s3hJWcXrj5GwLU+M5YKfblnSJS/J6580o8fqd44g=;
	b=xRU7nHP4qFkLaCrEWZvsPTpiU1AMFgsmgpXy927ohTCd+lq2zr8V8IkEIK/VNRNziP2C+z
	iekI1oZpCSel/o9mVnkP/MJMJtNl/IE4vMgXDU9S418RTIa/qO/rdLuKJKHlXLlAIVbyV5
	pdoYXuwLHJ4cq1kX1Hiecw8MeAyjojI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AK+s3hJWcXrj5GwLU+M5YKfblnSJS/J6580o8fqd44g=;
	b=iL0HhHjToBK6x6Nj9e8t/FKiF3KCRcgzUpwrX7uZYyZyGKe/RJLjzQcxOMfsxZzdm0TqEx
	pMjGSXnxLRK4zrAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE75F1339F;
	Tue, 10 Nov 2026 10:28:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hSGBMrzx8moAKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:28:12 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7727F22471; Tue, 10 Nov 2026 11:28:12 +0100 (CET)
Date: Tue, 10 Nov 2026 11:28:12 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC v3 09/14] fs: don't strand I_METADATA_WRITEBACK
 inodes outside the LRU
Message-ID: <4rwugltieam6t5fw3ovurnt5xpc73xevt5z3h5egza4no77jvm@3eekprthhshj>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-9-91ac6c024018@kernel.org>
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
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-9-91ac6c024018@kernel.org>
X-Rspamd-Queue-Id: 24E7C1F7BF
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
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

On Mon 09-11-26 17:51:24, Christian Brauner wrote:
> Since commit c474bc56b6d1 ("fs: Provide way for filesystem to wait for
> metadata writeback") ext2, ext4 without a journal, fat, udf and minix
> set I_METADATA_WRITEBACK on an inode whose metadata was copied into a
> buffer that might not have reached the disk yet. Only data integrity
> writeback, i.e. fsync() and friends, clears it again. The flusher and
> sync(2) leave it alone.
> 
> inode_lru_isolate() treats every state bit other than I_REFERENCED as a
> reason not to reclaim the inode right now. It takes the inode off the
> LRU and relies on iput(), writeback completion or the removal of the
> last page from the page cache to put it back once the reason is gone.
> 
> But I_METADATA_WRITEBACK doesn't go away on its own. iput() puts the
> inode back on the LRU with the bit still set and the next scan takes it
> off again. So neither memory pressure nor drop_caches can free these
> inodes. Only fsync() and friends or unmounting the filesystem get rid
> of them.
> 
> On ext4 without a journal ext4_mark_iloc_dirty() sets the bit on every
> ext4_mark_inode_dirty(), so even an atime update is enough. An
> unprivileged user creating or touching lots of files grows the inode
> cache without bound until the OOM killer comes along.
> 
> The inode can't just be thrown away though. An fsync() after the inode
> was read back in wouldn't know that its metadata still has to be
> written out. So let the shrinker reclaim inodes with
> I_METADATA_WRITEBACK like any other clean inode and make evict() write
> out what the bit tracks unless the inode is being deleted. Since the
> previous patch the bit covers the tracked metadata buffers as well, and
> since the lookup patches ->sync_inode_metadata() doesn't read anything
> from disk for that. It writes and waits for whatever is still dirty or
> under writeback. The mmb_sync() calls in ->evict_inode() are redundant
> with that and the following patches drop them.
> 
> Handing these inodes to a work item that syncs them and puts them back
> on the LRU would work too. But that's a second inode reclaim offload
> mechanism next to the deferred inode reclaim that is being worked on,
> and it needs a reference on the inode which leaks into remount, freeze
> and umount.
> 
> For stable this needs the previous patches as well. Without the lookup
> changes evict() ends up reading inode blocks from disk with
> __GFP_NOFAIL allocations from reclaim. v7.3 also still has bfs which
> sets I_METADATA_WRITEBACK too and reads the inode block in
> bfs_sync_inode_metadata(), so the backport needs the cache-only lookup
> for bfs as well.
> 
> Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata writeback")
> Cc: stable@vger.kernel.org # v7.3; see patch description
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looka good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 1cb6293b237a..332108961df6 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -818,6 +818,14 @@ static void evict(struct inode *inode)
>  	inode_wait_for_writeback(inode);
>  	spin_unlock(&inode->i_lock);
>  
> +	/*
> +	 * fsync() can't find what I_METADATA_WRITEBACK tracks anymore once the
> +	 * inode is gone, so write it out unless the inode is being deleted.
> +	 */
> +	if (inode->i_nlink &&
> +	    (inode_state_read_once(inode) & I_METADATA_WRITEBACK))
> +		sync_inode_metadata(inode, 1);
> +
>  	if (op->evict_inode) {
>  		op->evict_inode(inode);
>  	} else {
> @@ -947,9 +955,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>  	 * they're already on the LRU, and this can make them
>  	 * unreclaimable for a while. Remove them lazily here; iput,
>  	 * sync, or the last page cache deletion will requeue them.
> +	 * Nothing requeues them for I_METADATA_WRITEBACK, evict() writes
> +	 * that out instead.
>  	 */
>  	if (icount_read(inode) ||
> -	    (inode_state_read(inode) & ~I_REFERENCED) ||
> +	    (inode_state_read(inode) &
> +	     ~(I_REFERENCED | I_METADATA_WRITEBACK)) ||
>  	    !mapping_shrinkable(&inode->i_data)) {
>  		list_lru_isolate(lru, &inode->i_lru);
>  		spin_unlock(&inode->i_lock);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
