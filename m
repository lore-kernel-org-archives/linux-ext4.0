Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C0A3E8685
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832156; cv=none; b=Nc6vFHJqKwiq4MgTQFjPoswazBqxxhDyRHWvheJS1fV3IYVuRRRsgKv3cMFoPWpXPGJtz2vGXV6hhCQSLtSxa26ODT2Enmmw358+2uXJ6SuHVZoIVQocscn/C7K0mJxzhCve9jUNBbJgNTkpE085JgMm/jg1qvxHoE6YGQ3PRmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832156; c=relaxed/simple;
	bh=BMDkNcdu+iioLPybkIiEmPep5fzwLGKnqs+WQFea84Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shdJmJsVpsbiLvAW3fq6cfeT82k7u+jBmCrY3CXXvMZ3Y1A8MKom9YqGm4X9T+wcAiadwRVcUUdLe9xCuzPza/TkIC2XpanzWv26mr1tZHLTXc9vrxOMmcm8pCjcGsf3qwbwgeUEhMOcd+JDBSZFRZVpD6D+z1bhk2Wobrv5SGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qzgHwpB/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NCNmsKFZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VIhb+tK+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zr9c/exW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qzgHwpB/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NCNmsKFZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VIhb+tK+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zr9c/exW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BF4D87F694;
	Tue,  4 Aug 2026 08:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sLX+LHbVwKJfL1CXVCz45JLc7CaEzV059LCCyCg3smU=;
	b=qzgHwpB//3b4oR1b2lTrvfGgxJ/Tpg2Gjn9ofocl8LSmpE/D4sUn4EIz1RmzBES1x3EymG
	IdhbjMa2QsTdFA20Md5A5DzjC3I/+Fp7oIjJgxOBA2dbqAnYXwRBhP6Pm/QabVbPZqOOXF
	JtwrQgTwMFpszmieL/4TPJUH2PEelVg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sLX+LHbVwKJfL1CXVCz45JLc7CaEzV059LCCyCg3smU=;
	b=NCNmsKFZRMkiq6+4U+KoGDX0VnqDNKhycAjyRvjgVT5mGZSbUlo6NwRGtGEkJs/YJfSO8L
	jyVtSjj+O95PbuCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VIhb+tK+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="zr9c/exW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sLX+LHbVwKJfL1CXVCz45JLc7CaEzV059LCCyCg3smU=;
	b=VIhb+tK+SxV9M92lYFffPvQIihOczz6pLsxvIMLT/gJy/GThtI9mcOG8ODizRunAtSSakk
	PfpbxqdfknvPiTTwNONWuCObhByiU9HY84zJU0dyg7+v9zzMnCPWdqgswyzMrAuI+yHKCN
	fGyByoQZ4r6wL3sIPeicKPFPcfG/bIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sLX+LHbVwKJfL1CXVCz45JLc7CaEzV059LCCyCg3smU=;
	b=zr9c/exWNOYtSrRaIoZVvMDjDbm8u0fuZZ9csJEtxRYuaarE+7nFu+skmDKuSGm8KkjZKb
	6hibqPFPUTC7iUCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0F63779BB;
	Tue,  4 Aug 2026 08:29:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dZwyK9CicWplWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:29:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6E946A13A6; Tue, 04 Aug 2026 10:29:04 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:29:04 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] buffer: clear BH_Write_EIO when a buffer is
 forgotten
Message-ID: <qjkgzks3sq57h2lek2ra75yqu46bh7uijesiddpcqvrxrdcmq4@cit3oay5pm3g>
References: <cover.1785621505.git.coshi036@gmail.com>
 <1bf058fd5867bceeede78d99844b49a26ed6f3c5.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bf058fd5867bceeede78d99844b49a26ed6f3c5.1785621505.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BF4D87F694
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Sat 01-08-26 18:00:48, Chao Shi wrote:
> BH_Write_EIO records that the last write of this buffer failed.  It is
> cleared when the buffer is submitted for write again - see the
> test_set_buffer_req() check in __bh_submit() - but a filesystem freeing a
> metadata block never submits it again.  It calls bforget() and hands the
> block back to the allocator, so the flag outlives the block it refers to.
> 
> That does not matter much today, because the write error is also recorded
> by clearing BH_Uptodate and the buffer is discarded soon after.  It starts
> to matter in the rest of this series, which stops clearing BH_Uptodate on
> write error and makes BH_Write_EIO the way a failed metadata write is
> reported.
> 
> bforget() is where a filesystem says it no longer cares about this
> buffer's contents, so clear the error there alongside the dirty flag.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 04fcc34e4fa6..7889c30d8715 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1091,6 +1091,7 @@ EXPORT_SYMBOL(__brelse);
>  void __bforget(struct buffer_head *bh)
>  {
>  	clear_buffer_dirty(bh);
> +	clear_buffer_write_io_error(bh);
>  	remove_assoc_queue(bh);
>  	__brelse(bh);
>  }
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
