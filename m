Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF073D669D
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 08:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782721423; cv=none; b=Y0Z5lpY2HCyC2tvIqoonuCW+7RC83EEcjC/KdaVwL8TvHVTrm8MgoPPHYAZhbK6PgCHqboIRQ63wYBklvD6MrOIAX/D3w4YPMROUJTTJ7M2R5wW1xGds9jTi2rUFP07ICh+kMH5bvCmkc/7oB9rCNEtDTLLR+dc/552vFK1F/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782721423; c=relaxed/simple;
	bh=hydj41qsyMXtgEAspdeYaknvsExX8PGCUYFlrOZhwsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=saIRhjHCRTQAOMMrH8al0RV2AJV4TjEi1ZzRFGbZ/ixmxWx+sGrPULcvjbAdJI6LAeejJf+eoM+IYnU2TilwvbPFTxpaQTwrQfbYzDGlHX1hlbQp+2u4FTYGA13vvbC+ngfiMuzSMdRh3IdEni0BMP9pdD435rgMHycJXe/C+Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JjCcrSCm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0GOwA1MW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JjCcrSCm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0GOwA1MW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JjCcrSCm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0GOwA1MW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JjCcrSCm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0GOwA1MW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2C52272F93;
	Mon, 29 Jun 2026 08:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782721419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2KYE4XhuYpJGK0vxx86oD6YLp2xDlkA3enBGAunFsI=;
	b=JjCcrSCmReOTDjAIzF7doE0yTSKpbxQROwtLd/6f4MkzaANmHiYTL/VmrAhPirNOZW+SGg
	V72UvfqMfT1DxWBIxgcol1pGgQGVQiCWC6+F8zIKIz1DVEX6hHQMl4DkMJF2dweUGQ9G1h
	hYeXvgQMr5LB4142N39hKriHspCM3dQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782721419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2KYE4XhuYpJGK0vxx86oD6YLp2xDlkA3enBGAunFsI=;
	b=0GOwA1MWqhyyhluXVNohy1egA8Y1ZRRd8bAiPQCJpwDbGCBCRWraGRQkjRENsLI6DrMRj8
	6ZBSLAovuxhXwaCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JjCcrSCm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0GOwA1MW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782721419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2KYE4XhuYpJGK0vxx86oD6YLp2xDlkA3enBGAunFsI=;
	b=JjCcrSCmReOTDjAIzF7doE0yTSKpbxQROwtLd/6f4MkzaANmHiYTL/VmrAhPirNOZW+SGg
	V72UvfqMfT1DxWBIxgcol1pGgQGVQiCWC6+F8zIKIz1DVEX6hHQMl4DkMJF2dweUGQ9G1h
	hYeXvgQMr5LB4142N39hKriHspCM3dQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782721419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g2KYE4XhuYpJGK0vxx86oD6YLp2xDlkA3enBGAunFsI=;
	b=0GOwA1MWqhyyhluXVNohy1egA8Y1ZRRd8bAiPQCJpwDbGCBCRWraGRQkjRENsLI6DrMRj8
	6ZBSLAovuxhXwaCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C8E5779A8;
	Mon, 29 Jun 2026 08:23:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rE73BosrQmoWGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 08:23:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3D7EA10B5; Mon, 29 Jun 2026 10:23:38 +0200 (CEST)
Date: Mon, 29 Jun 2026 10:23:38 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v10 2/5] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <hxkq54njehj4sin7ymm7kbpqy2hs2x7w7evi6qurxsyjsa3xvx@pzindvdeaii5>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-3-yun.zhou@windriver.com>
 <t7ewb5or7ybrt3mwbnjxjddo7ok75dopf5czoib7nyou4zwdmd@plj4clfhoybl>
 <b7f1b4ea-6594-4dd4-a035-f555a822d48a@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f1b4ea-6594-4dd4-a035-f555a822d48a@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2C52272F93
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Sun 28-06-26 16:13:18, Zhou, Yun wrote:
> 
> 
> On 6/27/26 00:53, Jan Kara wrote:
> > On Thu 25-06-26 23:29:38, Yun Zhou wrote:
> > > +
> > > +/*
> > > + * Drain all pending deferred EA inode iputs.  Must be called before
> > > + * freeing resources that eviction depends on (quota, block allocator).
> > > + * Loops because worker iput may trigger eviction that re-queues.
> > > + */
> > 
> > Can you please explain how iput of EA inode can trigger iput of another EA
> > inode? So far I don't think that's possible but perhaps I'm missing
> > something.
> > 
> > > +static inline void ext4_drain_ea_inode_work(struct ext4_sb_info *sbi)
> > > +{
> > > +     while (flush_delayed_work(&sbi->s_ea_inode_work) ||
> > > +            !llist_empty(&sbi->s_ea_inode_to_free))
> > > +             ;
> > > +}
> > > 
> 
> On a corrupted fs, an evicted ea_inode might still have xattrs and point to
> another ea inode, which creates a potential "re-arm" scenario.

That should be caught when loading such EA inode into memory and result in
EFSCORRUPTED at that point. So please add such check to __ext4_iget().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
