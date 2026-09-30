Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0863E410D;
	Wed, 30 Sep 2026 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768926; cv=none; b=QgxfcMX/Rfk7/VFmF5mDRMhZ58e4hPjxwH4FdHAv0jCOaRxOrPNj7Dkch5QaJYjU1FX9YA7VYFuv3s8U0BQNjiT9zccyFROn14D4JnsMyEfsFzfFVyNJrQ0e7DzciFXb56/O3HjjRsLxZumrepQK2bJ9dXtbFdZyJ4eMx/VW6gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768926; c=relaxed/simple;
	bh=9F+T4Na/riiqICcl0vGr2JUkTczLvLZgLnkb6Y+o2mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ra6tfc1hdqf6338WsRSB69R1YqYerZJx5FCQ4OnH0AzXoZ6kx7qAn2GDK/o0DxdOUAMzpZtka0oicn+yNPPZOCtOM8ZRPQQP9tZQMz2Ztci+Iw4T487JqVm71efQMcJbHUIeogrIAbE4p8GQs3R9VAA1Lgs9ZpfBMMXutk01XUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bp8/S35A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kPvZlmC6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tuc/zqhf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V/Oh4gml; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bp8/S35A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kPvZlmC6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tuc/zqhf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V/Oh4gml"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9786021EA4;
	Wed, 30 Sep 2026 11:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790768918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8NA3FO+yklh2ckreB1dDAWoQ++G31/X7cKbyQtUhPo=;
	b=Bp8/S35AVgwkbqbIkLigIDhxIE85PrqPstrio8hHRwwYTxL5KQXw4736VhYedV2xUSfznP
	dMsa40fERf1xFP19EnuYyLofEodT1KmC9GpUAdc//WBJd4hYnJxOKtAOsHTx9A9yGAWd2R
	Lze7v7pTu0zlSPPAaexykYcuOhqyEEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790768918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8NA3FO+yklh2ckreB1dDAWoQ++G31/X7cKbyQtUhPo=;
	b=kPvZlmC6v4iINokF6bIaUT45yzrIkgO3DCHHRLjd//o3HszKe7sbmHhZFOAzwLqH9V0ygI
	ZM9UQhSKeoQIhfDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="tuc/zqhf";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/Oh4gml"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790768914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8NA3FO+yklh2ckreB1dDAWoQ++G31/X7cKbyQtUhPo=;
	b=tuc/zqhfZUu/xaoKnup51P3Tren1h6/0w/8B7Q3a1O/pNAWP6+wjTIStL39rWIGOvmJkkR
	m6TKe6g7r1ICBVu0c0Wwuu74wlcl9V72mqkv6Wzyf33MbY4nw8d9mfxPKHAsKFPnhHIs1p
	XIRtUXXFALc9c8NnPZ7X7ypT/dtz/Oo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790768914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8NA3FO+yklh2ckreB1dDAWoQ++G31/X7cKbyQtUhPo=;
	b=V/Oh4gmlzzfZtkWPfnT05QQ1wszwaUgMQTYmrUoxCj9S5FabMdeKIip+bLFzH6jsM8xRUo
	AiEsm6ZkRZ6xGEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6286D13722;
	Wed, 30 Sep 2026 11:48:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wGKvDhL3vGqrTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 11:48:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DC41EA13AD; Wed, 30 Sep 2026 13:48:29 +0200 (CEST)
Date: Wed, 30 Sep 2026 13:48:29 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Qiliang Yuan <odys.yuan@gmail.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Message-ID: <shfd6lmgopxqvcwaq6dqrm2x4ovlnzvspmatpqxtaf6wmb7z5p@lqog5ma575x7>
References: <20260929-fix-ext4-es-scan-nr-scanned-v2-1-f4e8f6f6b8b1@gmail.com>
 <f8e677df-4896-415d-9795-e15362be6b92@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8e677df-4896-415d-9795-e15362be6b92@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,huawei.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9786021EA4
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed 30-09-26 09:45:26, Zhang Yi wrote:
> On 9/29/2026 10:20 AM, Qiliang Yuan wrote:
> > @@ -1774,15 +1777,41 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
> >  {
> >  	struct ext4_sb_info *sbi = shrink->private_data;
> >  	int nr_to_scan = sc->nr_to_scan;
> > -	int ret, nr_shrunk;
> > +	int ret, nr_shrunk, nr_scanned;
> >  
> >  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
> >  	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
> >  
> > -	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
> > +	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL, &nr_scanned);
> > +	sc->nr_scanned = nr_scanned;
> 
> 
> I'm a bit concerned that modifying sc->nr_scanned here could actually
> end up increasing the number of scan_objects() calls in real-world
> usage. If there are other background processes running and continuously
> accessing certain files, they may keep producing a small number of new
> reclaimable extent caches. That would mean nr_scanned stays at a
> relatively small value on each iteration and never drops to 0, so
> shrinker->scan_objects() may end up going through more loops because it
> can't return SHRINK_STOP. So I'd tend to leave shrinkctl->nr_scanned
> alone. What do you think?

Well, I agree but lying to upper layers about the number of objects we have
scanned doesn't look like a proper solution? We could return SHRINK_STOP
when we scanned everything before nr_to_walk dropped to 0. It isn't perfect
but would somewhat address your concern...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
