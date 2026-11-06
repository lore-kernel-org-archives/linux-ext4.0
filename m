Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978558;
	b=aGpbcsPHMvIRSvmTA3+sm0iTSISZAamxzElpvFjp3AeH6qSvxWzOrBUzpeKaMzvyjhQ9
	 XSm97XOeYYrdVu5qc7FHKRtBYe7tPHw7mgrExIy/MEsoFIKXy9c1mU4dil2JPgOV4qRUq
	 zA5a2XYkW5RqO+qVSHdyc9RLoHQLClvj9UW/XCGO4kUi9CAV3dCmmf5nhYsJaWJQ4Yq/Z
	 PZ/sqW2rDsRxPyMa/5k1ItLr8lyIAcBs1Z2+0Uugc90T1+n7/rsntiLq/ibJuxqgElpzf
	 O58ciTfwXJzpk5a7m6+4InbxemYZDdIHMxha/ceoWyIOMq2mv9OLJg0jICcBQ8IeM3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978558;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=Td8B4X5FVnj4bgB2qv3pedjWx6urRlwbaxzxfrv0G44=;
	b=5V67JBM1YiF/c+KnI3jA0JJ6qBw+vJr9zI6v4kBBe2+ipFtjCE5i3BLfKXEXJu7bcJHm
	 KvnZpQ9Dz9v74LCPSorGeljPCH68x2YRLMXRpKGRnLdDgeMuOyI1iMp4K9L51xenjENyk
	 OxkxIUR67CoKkNhiKDZoQ3TYldvJCj3CDwqdHfNkwHULKyHWY285pjZ+aW+qCe7JCaQsj
	 cRW1EZaynsA47VXzk3GoCxV3e1c41LyQ4hvjIc9KrOoJwWFyqRVB7p6IMpW6OaI5MOLTW
	 z3YVaL1TgWgPQaM7MjkGYv+jneBDVu87Y0EWh6Z1TtUfpCRm0eRZNYs57+lT/BnG/gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MR6ztttI;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="v/iP4Pgu";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MR6ztttI;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="v/iP4Pgu";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445A8606A326;
	Fri,  6 Nov 2026 15:22:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 445A8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MR6ztttI;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=v/iP4Pgu;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MR6ztttI;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=v/iP4Pgu
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 37E421F452;
	Fri,  6 Nov 2026 15:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793978556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Td8B4X5FVnj4bgB2qv3pedjWx6urRlwbaxzxfrv0G44=;
	b=MR6ztttItbndgTEGozJLa6guvPlvE2QKVcXTpWQVPU+Ws5Qd6oxyTlrrBLkPJzKvV9NQVr
	qF9T9in3l7YVAqGNOO3Cdz+E/UmjtoBlW9asyyFtMWbQaX+dykPsoRrFZYHhvdZ24eHSYs
	w8JULqSFVrM2DCn9aOoVe/YNxQmfZVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793978556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Td8B4X5FVnj4bgB2qv3pedjWx6urRlwbaxzxfrv0G44=;
	b=v/iP4PguDtenZMTnospTO37Itc1LxvJEMXtzVBK8YIpHvyT+NZ2aLitH8jZtES3+Wf9J1I
	K5SMGdBHoMuSEHDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MR6ztttI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="v/iP4Pgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793978556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Td8B4X5FVnj4bgB2qv3pedjWx6urRlwbaxzxfrv0G44=;
	b=MR6ztttItbndgTEGozJLa6guvPlvE2QKVcXTpWQVPU+Ws5Qd6oxyTlrrBLkPJzKvV9NQVr
	qF9T9in3l7YVAqGNOO3Cdz+E/UmjtoBlW9asyyFtMWbQaX+dykPsoRrFZYHhvdZ24eHSYs
	w8JULqSFVrM2DCn9aOoVe/YNxQmfZVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793978556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Td8B4X5FVnj4bgB2qv3pedjWx6urRlwbaxzxfrv0G44=;
	b=v/iP4PguDtenZMTnospTO37Itc1LxvJEMXtzVBK8YIpHvyT+NZ2aLitH8jZtES3+Wf9J1I
	K5SMGdBHoMuSEHDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0715D134E9;
	Fri,  6 Nov 2026 15:22:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KCY6Nrvw7WpiLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 15:22:36 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A3E4421BB7; Fri, 06 Nov 2026 16:22:27 +0100 (CET)
Date: Fri, 6 Nov 2026 16:22:27 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC v2 13/13] fs: don't strand I_METADATA_WRITEBACK
 inodes outside the LRU
Message-ID: <lw7ukbtgicrikfqujwyspwld4a4l7736raczrago4iaicn27ve@g37wwuthduv7>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-13-48628c60c336@kernel.org>
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
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-13-48628c60c336@kernel.org>
X-Rspamd-Queue-Id: 37E421F452
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,toxicpanda.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.51

On Thu 05-11-26 13:41:42, Christian Brauner wrote:
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
> written out. But that's no different from the metadata buffers these
> filesystems track in their mapping_metadata_bhs. Their ->evict_inode()
> calls mmb_sync() and that is what allowed commit 972b9dd4e418 ("fs:
> Ignore inode metadata buffers in inode_lru_isolate()") to take those
> buffers out of inode_lru_isolate(). With the previous patches
> ->evict_inode() writes out what I_METADATA_WRITEBACK tracks the same
> way, without reading anything from disk.
> 
> So let the shrinker reclaim inodes with I_METADATA_WRITEBACK like any
> other clean inode.
> 
> Handing these inodes to a work item that syncs them and puts them back
> on the LRU would work too. But that's a second inode reclaim offload
> mechanism next to the deferred inode reclaim that is being worked on,
> and it needs a reference on the inode which leaks into remount, freeze
> and umount.
> 
> For stable this needs the previous patches as well. Without the
> ->evict_inode() changes an fsync() after the inode was read back in
> misses the inode block. Without the lookup changes ->evict_inode() reads
> inode blocks from disk with __GFP_NOFAIL allocations from reclaim. v7.3
> also still has bfs which sets I_METADATA_WRITEBACK too, so the backport
> needs the same two changes for bfs.
> 
> Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata writeback")
> Cc: stable@vger.kernel.org # v7.3; see patch description
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/inode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 1cb6293b237a..16ebd686d681 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -947,9 +947,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>  	 * they're already on the LRU, and this can make them
>  	 * unreclaimable for a while. Remove them lazily here; iput,
>  	 * sync, or the last page cache deletion will requeue them.
> +	 * Nothing requeues them for I_METADATA_WRITEBACK, ->evict_inode()
> +	 * writes that out instead.
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
