Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306564;
	b=BrTIHpzRVaRMUBm7Rvx3kbxnBB9XgFDbOgNZULrgs4ff2RMMKZqoEPtFJil/WGZKT18d
	 9YjEv3akwvb/+qFtHim5aK7MmyjHc8w1tBtkLlM5Ln7OvCa2wQU/SuIAXOC+5tlDLSzgO
	 F2UghZAlnJm01Iv7fSmL7cgTZ5yrVu5BfFDtanalIvsJ29DyCOxWkrnja+SQwHOwbKb7H
	 g4UNBA7WXwRgYeX8/w7tTEcywwF4rDGMdRE8Djz6qPYl0+r06kHlPE3yUSIuSnQKk7uQj
	 PR9zB2OJym0BV2zH2nqi3WyLZ8RhE8pcPy2vKpwn5am6VQ847n0axJy0xZL9YTMjaug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306564;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=Eljm0Ofrh8usY5uG2r88cE2taf0Pjeldnkt7mjQnqlM=;
	b=NETW3YkvNinrjTqIpKTBBbaACbMZig7QGJ1sjRbJ3/KHgSs+dI9OusEWpTLvUgwjRSta
	 d8LMncEMgjRTiU3sY7DAuXBmmYE5iUGN65+uV5dRSyJr0JyW95CyhRxGBr1Fke+KGp3Z7
	 NSbQiTuguzmZPxgYVIgMCRp0Ps9zlg/xfvTKgu4vsyKSINd9q9Zatf62Bkbek0gQRIl/Q
	 8OLLFqkjtoOswrN2yjUARbWCxZqdVR3va40pRAUTGNLL6ZGQAddCT6BgOKqIuAnNWJOsU
	 8+vY0oEIdLj+HrGFzfV8IupwvU5bhOb2do7bQJ1TpiysREOfitiChmmSs5QLty1SEMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uixMhRZ3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3S4ka6WD;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mFx+Y2iL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SyaZRHbt;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6C7606A334;
	Tue, 10 Nov 2026 10:29:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C6C7606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uixMhRZ3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3S4ka6WD;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mFx+Y2iL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SyaZRHbt
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB68321DCE;
	Tue, 10 Nov 2026 10:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eljm0Ofrh8usY5uG2r88cE2taf0Pjeldnkt7mjQnqlM=;
	b=uixMhRZ3PUS5afTCyHog5ov8RH4/Tvr2cYJYBUpoyCs4ZZHh+JFkVoqyroMWodruutXRjS
	hew4S2lNox4D/LK4qMUervLpipFSX3p5A9J9ojhjUsDh2wX4CVGZcDLJFdmVcwvm7jsTgM
	QlNy+8BTgLw3RficP/GsIA2LjHcDPGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eljm0Ofrh8usY5uG2r88cE2taf0Pjeldnkt7mjQnqlM=;
	b=3S4ka6WD8Dsxkn7kgn/ynpbTr3ECM69y7cdGsUYJs0OQ/w/ZTJYSbgGXzg5a/7gRZIkRPu
	esjsgM+weElJZ5DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mFx+Y2iL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SyaZRHbt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eljm0Ofrh8usY5uG2r88cE2taf0Pjeldnkt7mjQnqlM=;
	b=mFx+Y2iLaIeLOoIKhGLmt2qFjJQCRLc3WIv73VoRu3GlBL242oKAb1WyuI+7cYZdSAZvSJ
	JGAtFWHK37/8wG4AKL+R/fXPPQh2V3uzeZMOQy5F20peOelDQ5EHBtobxeG+FJyXheY+0l
	JeKUQjVsjbG8bsa8LRk2RsrTZUbZayE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eljm0Ofrh8usY5uG2r88cE2taf0Pjeldnkt7mjQnqlM=;
	b=SyaZRHbtcOIOOt8f4SAbBUTdhpXbmdAXyofmHYih7EY7JM9s4cadqXg6fa0ZZ1MOmhhQEs
	fZ4/lBC6Qcz7BIDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A26FC1339F;
	Tue, 10 Nov 2026 10:29:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id igUZHwHy8moDLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:29:21 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 49EF422479; Tue, 10 Nov 2026 11:29:17 +0100 (CET)
Date: Tue, 10 Nov 2026 11:29:17 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RFC v3 13/14] udf: drop mmb_sync() from udf_evict_inode()
Message-ID: <mlezsjcx4yuoatocfdglb4euokb2ixiaj7sghtd7tvmhengi75@rymozndeexcz>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-13-91ac6c024018@kernel.org>
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
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-13-91ac6c024018@kernel.org>
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
	RCPT_COUNT_TWELVE(0.00)[12];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: CB68321DCE

On Mon 09-11-26 17:51:28, Christian Brauner wrote:
> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> udf_evict_inode() to sync for an inode that isn't deleted.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/inode.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index b3e7c07cb9e7..a6c0b9d70ffb 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -152,8 +152,6 @@ void udf_evict_inode(struct inode *inode)
>  		}
>  	}
>  	truncate_inode_pages_final(&inode->i_data);
> -	if (!want_delete)
> -		mmb_sync(&iinfo->i_metadata_bhs);
>  	mmb_invalidate(&iinfo->i_metadata_bhs);
>  	clear_inode(inode);
>  	kfree(iinfo->i_data);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
