Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793656002;
	b=yBZQE/aAXJ1uruRlbmllc6bv7RFsd/eyL7z8A+U2lQMfXb6PNKzfat+VP/8F0kKrG0q/
	 /v4wU1dzlo8D+fRY5i2XPO2GaswfO52R8vFfNv6lxA9gr7SJkxqqX/TaorqsgouNmJGfl
	 9bammJKgCDcIMRv3oXvyfDNLdpS255SXI9Yi4ahDAgr5N9N5hAVpv2dOTt5m882tfxLfp
	 u5Vu/5D6D37BCwLCpFzCL7q5K8OIcrFNy1DgIVGBWX8NYkVG53M98S6/7zS/108OBDbk4
	 ki5C/JPoVYIRahpKbvyNTssaFbeGzI5H6gnxVmpz6ZdvwyD5zc2s5hZStsICmZ29BjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793656002;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=Tw2fuwifIT62v473Kx2owlLDjXbxFH3YLeYo6j8SzLU=;
	b=VKEXWp3rhTu2R3EZwhgWSG/791JYeCRfoc/PxZbaveOSojAOUXM5XRNqfp6BbphO9Xkn
	 VQ18cwXYCDhmR2ln0khKAnyNU68PN2ZXfqotnh+9oXa0Y+pxCIFLJRQ8OkJFSEiQB1ixm
	 PLUlIXmsAqiq8Ovcqfu5ka+3Eey5EdPw13elJqmCjvc44+u2I3R1edM/HDTO3c3uExTQH
	 I/HdxIxn5CEfWfS4DcOR31vQrT3cVBm998MmdHG+6SdQxgGBXroprPhU8RCZzDaU5KkZb
	 wQJ2kZ3Z+9/wnGwqbKHmZQZyHgbobhb3hsAMEyr72BP5+3ABgBZmOFkZzzMgvT8ZdkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=B8m4OmwH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Jk+k+BOi;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=B8m4OmwH;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Jk+k+BOi;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469D606A330;
	Mon,  2 Nov 2026 21:46:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5469D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=B8m4OmwH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Jk+k+BOi;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=B8m4OmwH;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Jk+k+BOi
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF73F1FB28;
	Mon,  2 Nov 2026 21:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tw2fuwifIT62v473Kx2owlLDjXbxFH3YLeYo6j8SzLU=;
	b=B8m4OmwH1OiaVRaHm38scM9chJIvPjbkHtmlZOphhajvXIh5Mhm6PBW5EKI5tarqobRoNd
	Q4RpGN9leSJWdysuMTYdoS5DGwk5qxzcz7PPnKzs+xGsEpm42AC0qLdZhJQjVDvz3R47Cx
	OwcS1EeOO7TVSNwLNVUlXlEzWOlCV+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tw2fuwifIT62v473Kx2owlLDjXbxFH3YLeYo6j8SzLU=;
	b=Jk+k+BOiRyPjNhnkZ3RWeORLyaaU3/rCIVxx9dL7U3kaCwWPqTF7VFbR9JKNzUY71NkIrE
	g9KvqS8XtGRVEwBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B8m4OmwH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Jk+k+BOi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tw2fuwifIT62v473Kx2owlLDjXbxFH3YLeYo6j8SzLU=;
	b=B8m4OmwH1OiaVRaHm38scM9chJIvPjbkHtmlZOphhajvXIh5Mhm6PBW5EKI5tarqobRoNd
	Q4RpGN9leSJWdysuMTYdoS5DGwk5qxzcz7PPnKzs+xGsEpm42AC0qLdZhJQjVDvz3R47Cx
	OwcS1EeOO7TVSNwLNVUlXlEzWOlCV+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tw2fuwifIT62v473Kx2owlLDjXbxFH3YLeYo6j8SzLU=;
	b=Jk+k+BOiRyPjNhnkZ3RWeORLyaaU3/rCIVxx9dL7U3kaCwWPqTF7VFbR9JKNzUY71NkIrE
	g9KvqS8XtGRVEwBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6C4F134B3;
	Mon,  2 Nov 2026 21:46:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eMi5IMAE6WrJfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:46:40 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 51CDFB167; Mon, 02 Nov 2026 22:46:36 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:36 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 4/4] ext4: initialize map->m_pblk in
 ext4_da_map_blocks()
Message-ID: <vylak6fpgcn75pwqtcp2rlmnz4wubrmkfwiurxbkgzbgo4hfkt@j6juzacbcxog>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
 <20261030021338.1768292-5-yi.zhang@huaweicloud.com>
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
In-Reply-To: <20261030021338.1768292-5-yi.zhang@huaweicloud.com>
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
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,huawei.com:email];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
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
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: CF73F1FB28

On Fri 30-10-26 10:13:38, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_da_map_blocks() returns a delalloc mapping through @map without
> touching map->m_pblk at all. Callers that only set up m_lblk and m_len
> of their local struct ext4_map_blocks and leave the rest to the mapping
> helper, like ext4_iomap_map_blocks() does, end up with whatever happened
> to be on their stack, so the trace_ext4_iomap_buffered_write_begin()
> tracepoint prints an uninitialized pblk for a delalloc mapping.
> 
> This has been harmless so far, ext4_da_get_block_prep() and
> ext4_set_iomap() both ignore m_pblk for a delalloc mapping, only the new
> tracepoint dumps it.
> 
> Initialize m_pblk along with m_flags at the beginning of
> ext4_da_map_blocks(), so that a delalloc mapping is always reported with
> pblk 0, the same way ext4_map_blocks() reports it.
> 
> Fixes: 008f019ab559 ("ext4: add block mapping tracepoints for iomap buffered I/O path")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6b2f1b07f41e6..c1c46e86bba3e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2041,6 +2041,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  #endif
>  
>  	map->m_flags = 0;
> +	map->m_pblk = 0;
>  	ext_debug(inode, "max_blocks %u, logical block %lu\n", map->m_len,
>  		  (unsigned long) map->m_lblk);
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
