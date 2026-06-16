Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD0935C183
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 09:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781600870; cv=none; b=nf3btHICGAkAFLBu7D19cVEOkfehAotkEheGuKUNzNpkeOhA0ZyXvfGthsh8r5pMhKLoddxFdaOJKfGTdAuHEdfQZ3K5PaxWG1yPtXYE5es6QBll8mFGV/rKpu18Umk/+IcsSoYqfRBF2gl14q3olVh5HguY/0PQp+DGPNywG30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781600870; c=relaxed/simple;
	bh=GZBS4z1XeHp8PcPU6X5UqaG9T4ox6K8ZP2A191NV0Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJkUhXKt9thHBML3hNSNQk+XunUDQXy/OgBkToy81xFz35VBDDIxDZL+eE9zivHC76wWurxuxuultHHtnZFCNTTLUe+1aYmRyNpQXLFQIyZDXfWkWqWFewVeWMXUSafsST980nCqJ2iefH+vXPaf4f9dWaqkCidRbwaEOqZ4TLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HB/Epww7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vIAXgXaU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HB/Epww7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vIAXgXaU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HB/Epww7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vIAXgXaU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HB/Epww7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vIAXgXaU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9C6075E3B;
	Tue, 16 Jun 2026 09:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781600866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4/Gdym1Hh07+o8eEQPrkR502cPZgKLNoQ8HilLrfIc=;
	b=HB/Epww7kRqnaAUmrPTTCpNTlDeGrXwSC+Iccp8VlBTD/R9XbPDEXvUpSo+IRe0KV6RPup
	GuyosOGjeF21i4/iF795GZM8Bb4sX80OW8YT4BjpjlqNrhk5lIBpXrX16H5rAbtq1k6LPV
	0ojHyp5nQv9Hcr/TeDyaXMPLEoYvPJY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781600866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4/Gdym1Hh07+o8eEQPrkR502cPZgKLNoQ8HilLrfIc=;
	b=vIAXgXaU/kk1xBJ6E+R24eRtDFcacO96K14rzqPVvZBkF9Twlsii5aJm47SIoUAPsCzR6y
	qpWAJw0ndOGbLsBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781600866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4/Gdym1Hh07+o8eEQPrkR502cPZgKLNoQ8HilLrfIc=;
	b=HB/Epww7kRqnaAUmrPTTCpNTlDeGrXwSC+Iccp8VlBTD/R9XbPDEXvUpSo+IRe0KV6RPup
	GuyosOGjeF21i4/iF795GZM8Bb4sX80OW8YT4BjpjlqNrhk5lIBpXrX16H5rAbtq1k6LPV
	0ojHyp5nQv9Hcr/TeDyaXMPLEoYvPJY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781600866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4/Gdym1Hh07+o8eEQPrkR502cPZgKLNoQ8HilLrfIc=;
	b=vIAXgXaU/kk1xBJ6E+R24eRtDFcacO96K14rzqPVvZBkF9Twlsii5aJm47SIoUAPsCzR6y
	qpWAJw0ndOGbLsBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E29A779A8;
	Tue, 16 Jun 2026 09:07:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hrCXJmISMWpZIwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 09:07:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 39926A12D3; Tue, 16 Jun 2026 11:07:42 +0200 (CEST)
Date: Tue, 16 Jun 2026 11:07:42 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com, ebiggers@google.com
Subject: Re: [PATCH v3] ext4: fix circular lock dependency in ext4_ext_migrate
Message-ID: <a36xibab7wzpzgb75nyz64fp5aalfnhmbnxgnjsoihqutqm3he@3342yvbpho5v>
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
 <20260612005330.1930804-1-yun.zhou@windriver.com>
 <00673f65-cfd4-4042-93cf-cb04ad1d92fb@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00673f65-cfd4-4042-93cf-cb04ad1d92fb@windriver.com>
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
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,windriver.com:email,suse.cz:email,appspotmail.com:email,syzkaller.appspot.com:url];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,google.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

Hello Yun!

On Tue 16-06-26 15:51:13, Zhou, Yun wrote:
> > Move iput(tmp_inode) after ext4_writepages_up_write() to avoid a
> > circular lock dependency between s_writepages_rwsem and sb_internal
> > (freeze protection).
> > 
> > The deadlock scenario:
> > 
> >    CPU0 (EXT4_IOC_MIGRATE)        CPU1 (orphan cleanup during mount)
> >    ----                           ----
> >    ext4_ext_migrate()
> >      ext4_writepages_down_write()
> >        s_writepages_rwsem (write)
> >                                   ext4_evict_inode()
> >                                     sb_start_intwrite()   [sb_internal]
> >                                     ...
> >                                       ext4_writepages()
> >                                         s_writepages_rwsem (read) [BLOCKED]
> >      iput(tmp_inode)
> >        ext4_evict_inode()
> >          sb_start_intwrite()         [BLOCKED]
> > 
> > The tmp_inode is a temporary inode with nlink=0 created solely for
> > building the extent tree.  Its eviction does not require
> > s_writepages_rwsem protection, so deferring iput() until after
> > releasing the rwsem is safe.
> > 
> > Reported-by: syzbot+212e8f62790f8e0bc63b@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=212e8f62790f8e0bc63b
> > Fixes: cb85f4d23f79 ("ext4: fix race between writepages and enabling EXT4_EXTENTS_FL")
> > Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > ---
> > v3: fixes Reported-by tag and Closes tag.
> > 
> > v2: remove redundant null pointer check for iput(tmp_inode).
> > 
> >   fs/ext4/migrate.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Thank you very much for taking the time to review these patches and
> providing your valuable suggestions. I am eager to solve these long-standing
> deadlock issues on Syzkaller, but I do not have much community experience.
> I'd like to know, regarding this patch, should I launch a new RR thread or
> continue waiting? BR, Yun

Please keep waiting. On Sunday the merge window for 7.2-rc1 has opened.
That means that about week before and at least for the next week,
maintainers often aren't taking any patches in their trees. I expect Ted to
pick your patch later when he collects fixes to send for 7.2-rc2 or so - he
sends email about that as a reply to the patch. If nothing happens for next
two weeks, I suggest you send a ping asking whether the patch didn't get
lost as a reply to your patch submission. Thanks for your fixes!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
