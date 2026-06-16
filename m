Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EECD35E1AF
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 12:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612965; cv=none; b=gMfYzY/XdJhDDwIZuk+wGkD98/trGhID17TEugUsasBIzahuM/pvGLrihIYJvQ43y5fjKCCdx7rxcT0Nl5dLObDcXwJZOg/Imy0Gjll7O874QRQUrbLPZOYKctNWN4J9tH6ypKJk/phzyM085GHBUcn7AmkDadbof1+/JaRC6W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612965; c=relaxed/simple;
	bh=9K4fnLSQQ4tUitF4yspyCHtlzXJtCGLtEkp8QBbDX1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drwbHYiVI5ByDfqUcYnnwfyErqrbESOVXjXaHcQ+isTH15t5itIGOdkM0W0ATy2NcWN8baInta2F+KlraBKQQ0bWNFMM/rB2O+y+vc/clfNJQor8LA0/UEEwCeZ9c5BIyIEN42Uvh7pRV4248TMmuUA3CLp75gB1t7zbF/PL9SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=f8bTZ5Fo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=p9fIpSqQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dwg/8J6u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jF/rLEp5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="f8bTZ5Fo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="p9fIpSqQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dwg/8J6u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jF/rLEp5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C61BA7586D;
	Tue, 16 Jun 2026 12:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781612961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dy6v1lFu+vVeoV09c4Qb4KGa1p4JcJA9w5qIzmJ/HKE=;
	b=f8bTZ5Fob99dfJNIe/zYbIdhO3dLKzz8JiqdYzE7yijMghXVoUwRo5R7xbxmFQBPsdtONu
	xVsp1P3JXGE/NqK8wL++FekqWT8E6PGEju8ljsG+e3TM4kg+p5uLtXJE4W6DhS6bJb5All
	vIQ5iAxO8+2F0emTtLP+I0mSATDqOCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781612961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dy6v1lFu+vVeoV09c4Qb4KGa1p4JcJA9w5qIzmJ/HKE=;
	b=p9fIpSqQTYlIlfx/x0BXUMGqCFGhzaQzT5hENqBZq5p9svdoar/lgFkV7jYeB/1Q9gTNwI
	H1Vw0brY/ubx/WDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="dwg/8J6u";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="jF/rLEp5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781612960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dy6v1lFu+vVeoV09c4Qb4KGa1p4JcJA9w5qIzmJ/HKE=;
	b=dwg/8J6uVEkseU0hH/R41lb4pvytgzS2g4EiLxi8t9rvrSJh2/W4iQtLvr2CvhCqsEau8l
	7z3fFAyhV+FlBcVrbM2yuHLrdJZbWldGJTs8P9X7P5t50AlJwaOmsv210nJjlbLtt3ohd8
	2SLPlaE8PJKCXV+o6jt9vNth8k5JJ7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781612960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dy6v1lFu+vVeoV09c4Qb4KGa1p4JcJA9w5qIzmJ/HKE=;
	b=jF/rLEp54svBq01+ofBCLCZIvdKpV+7U7m+9W6BJC3XHFk+dA34pACmccZiTfc7NeSU0Ut
	RNMRtSATFWcb9JAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBA59779A8;
	Tue, 16 Jun 2026 12:29:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wHvOLaBBMWobbwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 12:29:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6BD17A12D3; Tue, 16 Jun 2026 14:29:20 +0200 (CEST)
Date: Tue, 16 Jun 2026 14:29:20 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 15/23] ext4: add block mapping tracepoints for iomap
 buffered I/O path
Message-ID: <gzo3njztiz6kzlq5n57qfhswbmwxayik7sl7vj6hmdtfyjhrnr@2olf4sgha5op>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-16-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-16-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,huawei.com:email,suse.cz:email,suse.cz:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[16];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C61BA7586D
X-Spam-Score: -2.51

On Mon 11-05-26 15:23:35, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Add tracepoints for iomap buffered read, write, partial block zeroing,
> and writeback operations to help debug the iomap buffered I/O path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c             |  6 +++++
>  include/trace/events/ext4.h | 45 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e0dae2501292..239d387ffaf2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3961,6 +3961,8 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>  	if (ret < 0)
>  		return ret;
>  
> +	trace_ext4_iomap_buffered_read_begin(inode, &map, offset, length,
> +					     flags);
>  	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	return 0;
>  }
> @@ -4034,6 +4036,8 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>  	if (ret < 0)
>  		return ret;
>  
> +	trace_ext4_iomap_buffered_write_begin(inode, &map, offset, length,
> +					      flags);
>  	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	return 0;
>  }
> @@ -4136,6 +4140,7 @@ static int ext4_iomap_zero_begin(struct inode *inode,
>  			map.m_len = (start >> blkbits) - map.m_lblk;
>  	}
>  
> +	trace_ext4_iomap_zero_begin(inode, &map, offset, length, flags);
>  	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	iomap->flags |= iomap_flags;
>  
> @@ -4308,6 +4313,7 @@ static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
>  		return ret;
>  	}
>  out:
> +	trace_ext4_iomap_map_writeback_range(inode, &map, offset, dirty_len, 0);
>  	ext4_set_iomap(inode, &wpc->iomap, &map, offset, dirty_len, 0);
>  	return 0;
>  }
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index f493642cf121..ebafa06cd191 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -3096,6 +3096,51 @@ TRACE_EVENT(ext4_move_extent_exit,
>  		  __entry->ret)
>  );
>  
> +DECLARE_EVENT_CLASS(ext4_set_iomap_class,
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
> +		 loff_t offset, loff_t length, unsigned int flags),
> +	TP_ARGS(inode, map, offset, length, flags),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(u64, ino)
> +		__field(ext4_lblk_t, m_lblk)
> +		__field(unsigned int, m_len)
> +		__field(unsigned int, m_flags)
> +		__field(u64, m_seq)
> +		__field(loff_t, offset)
> +		__field(loff_t, length)
> +		__field(unsigned int, iomap_flags)
> +	),
> +	TP_fast_assign(
> +		__entry->dev		= inode->i_sb->s_dev;
> +		__entry->ino		= inode->i_ino;
> +		__entry->m_lblk		= map->m_lblk;
> +		__entry->m_len		= map->m_len;
> +		__entry->m_flags	= map->m_flags;
> +		__entry->m_seq		= map->m_seq;
> +		__entry->offset		= offset;
> +		__entry->length		= length;
> +		__entry->iomap_flags	= flags;
> +
> +	),
> +	TP_printk("dev %d:%d ino %llu m_lblk %u m_len %u m_flags %s m_seq %llu orig_off 0x%llx orig_len 0x%llx iomap_flags 0x%x",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, __entry->m_lblk, __entry->m_len,
> +		  show_mflags(__entry->m_flags), __entry->m_seq,
> +		  __entry->offset, __entry->length, __entry->iomap_flags)
> +)
> +
> +#define DEFINE_SET_IOMAP_EVENT(name) \
> +DEFINE_EVENT(ext4_set_iomap_class, name, \
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map, \
> +		 loff_t offset, loff_t length, unsigned int flags), \
> +	TP_ARGS(inode, map, offset, length, flags))
> +
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_read_begin);
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_write_begin);
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_map_writeback_range);
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_zero_begin);
> +
>  #endif /* _TRACE_EXT4_H */
>  
>  /* This part must be outside protection */
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
