Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B55413247
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2026 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555390; cv=none; b=giJOdMQ/P8xE2F1Jmk1VYVf5y2FLTR5NGgHoK+67V0yhaxJ66Wb5+lrQ/poUNnK7adfZMp0cJzrBRUGIcYPD/CIRey7JK8StXeZh15bJft3poUyZmBhy8FJAxzH6FrnWR+iUgELuhALtMqpsGsbDVajHHdnoA062ItVhCbYT9ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555390; c=relaxed/simple;
	bh=48S/foEcJxgk0f7iCJXdlAi/kMcbWuokneH1MgGsvaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IopmSgIOh02EwB+go6PnL83lQyO8375TtRF1Af6e5K3D5h0EAmcKQ8DxvfE7RtCBGAnYymz4+zHhXqECt15Yv7KoRLBZ3ygXOmLvbNssJ4cOB8l66VSwVl/ZWf1F28ftt50XunrFIJT/POvPre/m4LJky3dTDZ7LpUgo3bjuQjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oCfCBuMl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L5S3t2aA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oCfCBuMl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L5S3t2aA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oCfCBuMl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L5S3t2aA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oCfCBuMl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L5S3t2aA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B55A15BD3C;
	Thu, 30 Apr 2026 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777555387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFdOAiB9K3wgNvPKl9OitCnItLR8XEDyGXzU7F1QS14=;
	b=oCfCBuMl/9kBX5rQM3kfIJP/2Sh78tZactr5uOGKurEDAfD/Irag5xqqbK6Y8dYQW5zmrt
	/DyFMyezB9FbdtKWZtuc+lnsEK0OEIEGXct/Ace4M7H5QquUjIkARY/TlPKzxbvozPpoHu
	E/E5FeZdgXUVv1OksEr5FPocjnskgx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777555387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFdOAiB9K3wgNvPKl9OitCnItLR8XEDyGXzU7F1QS14=;
	b=L5S3t2aA1HA/DLKG9ChvkgXeJvMXB2DpCBahNMs83bLgur5TV/Nqk+cGylkNoT0ee0/1Nt
	vBJ7yH2Vl9dLE1Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777555387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFdOAiB9K3wgNvPKl9OitCnItLR8XEDyGXzU7F1QS14=;
	b=oCfCBuMl/9kBX5rQM3kfIJP/2Sh78tZactr5uOGKurEDAfD/Irag5xqqbK6Y8dYQW5zmrt
	/DyFMyezB9FbdtKWZtuc+lnsEK0OEIEGXct/Ace4M7H5QquUjIkARY/TlPKzxbvozPpoHu
	E/E5FeZdgXUVv1OksEr5FPocjnskgx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777555387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFdOAiB9K3wgNvPKl9OitCnItLR8XEDyGXzU7F1QS14=;
	b=L5S3t2aA1HA/DLKG9ChvkgXeJvMXB2DpCBahNMs83bLgur5TV/Nqk+cGylkNoT0ee0/1Nt
	vBJ7yH2Vl9dLE1Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A84E2593B0;
	Thu, 30 Apr 2026 13:23:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iJ4PKbtX82mMMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Apr 2026 13:23:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 49BD7A0523; Thu, 30 Apr 2026 15:23:03 +0200 (CEST)
Date: Thu, 30 Apr 2026 15:23:03 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 06/22] ext4: pass out extent seq counter when mapping
 da blocks
Message-ID: <kp3oevjqmsusuonzte5t3qlqpzdra73a4ljbsf3k4hztj6fuxa@3roak7eotbum>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-7-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422021042.4157510-7-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Wed 22-04-26 10:10:26, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The iomap buffered write path does not hold any locks between querying
> inode extent mapping information and performing buffered writes. It
> relies on the sequence counter saved in the inode to detect stale
> mappings.
> 
> Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
> blocks") added the m_seq field to ext4_map_blocks to pass out extent
> sequence numbers, but it missed two callsites within
> ext4_da_map_blocks(). These callsites are on the delayed allocation
> path, which is also used in the iomap buffered write path. Pass out the
> sequence counter to ensure stale mappings can be detected.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index df21f6870ec4..5ffd6aeb3485 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1929,7 +1929,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  	ext4_check_map_extents_env(inode);
>  
>  	/* Lookup extent status tree firstly */
> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		map->m_len = min_t(unsigned int, map->m_len,
>  				   es.es_len - (map->m_lblk - es.es_lblk));
>  
> @@ -1982,7 +1982,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  	 * is held in write mode, before inserting a new da entry in
>  	 * the extent status tree.
>  	 */
> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		map->m_len = min_t(unsigned int, map->m_len,
>  				   es.es_len - (map->m_lblk - es.es_lblk));
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
