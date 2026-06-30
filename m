Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648873ED3CA
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 11:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782819285; cv=none; b=g+kwbvJ4qzqT/cxne4jc7h1iH+8eaAosVrb+5jpqWQhcV9rDtVrGgyLYFr2AptK4BOHSUPM0AbBFOm2II5nTYwXJxTiO3yN2TQxwwj54trqzoriIH59SviQpf1J9pfZTeyEpb9A7W+9yhrVBRigPaJMWh+RX4k3FS1nHpXrbIYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782819285; c=relaxed/simple;
	bh=ZHDBAloNxKfruFaT0EwbBh8RxtlbOYic49TrN4hatF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbnH70qdlM9WpgPLpGrM3BE396bMZQGOKwyXVkdjAlT5wq8pmEligZmfBWEV/bUJ3v5oY4lUpahe8SNGDydkmxdRPfGG2Vu8PlwZS2DAqcghCQuBAMu6rbtZHPcl9GpOQhmaSh27o/fT2h+JDemsW0VYYK/rHDgPRnxYZYS3VXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IRRUubZC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fjC/Nb9/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IRRUubZC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fjC/Nb9/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IRRUubZC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fjC/Nb9/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IRRUubZC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fjC/Nb9/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D81675E82;
	Tue, 30 Jun 2026 11:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782819282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1+if+i9skt0PcMuKsDrXYi4eXzKwWWIyPOYV25LeU=;
	b=IRRUubZCDFXBHEq+a/zlC0YQP3nph+aY5jBy2tehgPdOTBnfbNm41JjyfEe+cf6XI7NfqH
	zXSMYeQ2EcT5f/WtmnNPnylw+2Vdo8iL4js/M21WVjyOod4ODF0tGhQQriQgrPYgKZ/i4w
	XL14W7r39Xbw9oKY4wICRMNO9VpeMis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782819282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1+if+i9skt0PcMuKsDrXYi4eXzKwWWIyPOYV25LeU=;
	b=fjC/Nb9/b1tatKFITtJ5fE6vzo1Z+4r9UsyFWhLeDKdXcL9lE9kW0eAI+0T8MC4Olk38Ij
	TBxp10Ytz3ghFjDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782819282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1+if+i9skt0PcMuKsDrXYi4eXzKwWWIyPOYV25LeU=;
	b=IRRUubZCDFXBHEq+a/zlC0YQP3nph+aY5jBy2tehgPdOTBnfbNm41JjyfEe+cf6XI7NfqH
	zXSMYeQ2EcT5f/WtmnNPnylw+2Vdo8iL4js/M21WVjyOod4ODF0tGhQQriQgrPYgKZ/i4w
	XL14W7r39Xbw9oKY4wICRMNO9VpeMis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782819282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1+if+i9skt0PcMuKsDrXYi4eXzKwWWIyPOYV25LeU=;
	b=fjC/Nb9/b1tatKFITtJ5fE6vzo1Z+4r9UsyFWhLeDKdXcL9lE9kW0eAI+0T8MC4Olk38Ij
	TBxp10Ytz3ghFjDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90E82779A8;
	Tue, 30 Jun 2026 11:34:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Az9cI9KpQ2rqTwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 30 Jun 2026 11:34:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 27031A10B7; Tue, 30 Jun 2026 13:34:42 +0200 (CEST)
Date: Tue, 30 Jun 2026 13:34:42 +0200
From: Jan Kara <jack@suse.cz>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Yun Zhou <yun.zhou@windriver.com>, tytso@mit.edu, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	xiaowu.417@qq.com
Subject: Re: [PATCH v11 1/5] fs: add iput_if_not_last() helper
Message-ID: <txvgbvn77wjgfz4ywdb25v7ol4ecszqh5yg3p4g56sbxq6prlo@rpfwveotnfvz>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-2-yun.zhou@windriver.com>
 <4k4crl4oobz4xtmvjoqwoefrd6in46xf725z3ewme3smgh5ide@6dmywcnp6o6y>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4k4crl4oobz4xtmvjoqwoefrd6in46xf725z3ewme3smgh5ide@6dmywcnp6o6y>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[windriver.com,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org,qq.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,windriver.com:email,suse.com:email,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Tue 30-06-26 11:05:50, Mateusz Guzik wrote:
> On Mon, Jun 29, 2026 at 07:08:44PM +0800, Yun Zhou wrote:
> > Add a helper that drops an inode reference only if the caller does not
> > hold the last one.  Returns true if the reference was dropped, false
> > otherwise.
> > 
> > This is useful for filesystems that need to release inode references
> > in contexts where triggering final iput (and thus eviction) would be
> > unsafe due to lock ordering constraints.  The caller can check the
> > return value and defer the final iput to a safe context.
> > 
> > Unlike iput_not_last() which BUG_ON's if called with the last ref,
> > this variant is designed to be called speculatively.
> > 
> > Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > ---
> >  include/linux/fs.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index d10897b3a1e3..04f0de78fa7a 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2413,6 +2413,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
> >  extern void ihold(struct inode * inode);
> >  extern void iput(struct inode *);
> >  void iput_not_last(struct inode *);
> > +
> > +/**
> > + * iput_if_not_last - drop an inode reference only if it is not the last one
> > + * @inode: inode to put
> > + *
> > + * Returns true if the reference was dropped, false if this was the last
> > + * reference and the caller must arrange for final iput() in a safe context.
> > + */
> > +static inline bool __must_check iput_if_not_last(struct inode *inode)
> > +{
> > +	return atomic_add_unless(&inode->i_count, -1, 1);
> > +}
> > +
> 
> This still could assert on the count, for example:
> 	VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
> 	VFS_BUG_ON_INODE(atomic_read(&inode->i_count) < 1, inode);

Yes, it makes sense to be consistent with other helpers. Thanks for the
idea.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
