Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6E33EFFC6
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 10:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781086868; cv=none; b=ob0IMnq4RntGGUUag0Qot2rrQ783vyRwsfTYQpO6QfW5K5TzsJHgmJfE5tzEPnZplO0xh2SMwjTBczYtiXyaIs1nQo6cOCKm1zPOH3Tz5G8xrITO5YUTSMd8EXTZAkPtBdE7qzf57Ls33qUrVu/jJ1uBtLcHgU6GStg9L2yL0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781086868; c=relaxed/simple;
	bh=Xsmpt1Aj3MHp08VjW5W0rBQVaHkmvUKKd6TZwRGbYdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEz8JTInMghktfs7ATKoR7ZjWfYf9X1owwBWSG8m7m9Jw4KZ/BqIKgWb8N2J4GMYUkVQyGWT6btEmeTg7y01o3ps+LUOec4E6l7hkB4cgNLguP9wr2CpPg+wp0BrsFgoe2I8WLGW5R7R1UBBpkmpRqUIdJ4rg+NT9NlJwol5bTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TlEuBPka; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zFyD2A94; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TlEuBPka; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zFyD2A94; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TlEuBPka";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zFyD2A94";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TlEuBPka";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zFyD2A94"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5175675891;
	Wed, 10 Jun 2026 10:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781086865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0kND7BjJGH83tdD36K/7xRQMQwoDhTHp4fmCse5/V4=;
	b=TlEuBPka+ePoyDY7TNv98Of6KLY3ulYRoelcwHvbx6wgaR/3KPEpVKf9ewSg2xFoRFmsac
	/Tee+RLLnlozJyBQa4GBxJjOeOk3HbzQEOU/uAvUxgKg9xbVKlQjT2oDLkmsL5UAcCh2jz
	9ewO6tLQjYiJK5+Jtz4bJgJzW9KXXKg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781086865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0kND7BjJGH83tdD36K/7xRQMQwoDhTHp4fmCse5/V4=;
	b=zFyD2A941kAmNy8m7vW+1FJan6dK+D9c3lwkhVQhAHoDnSth2q6kodu+1wcV1uQQwFRCO6
	8NWoknOx8f4WyECw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TlEuBPka;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zFyD2A94
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781086865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0kND7BjJGH83tdD36K/7xRQMQwoDhTHp4fmCse5/V4=;
	b=TlEuBPka+ePoyDY7TNv98Of6KLY3ulYRoelcwHvbx6wgaR/3KPEpVKf9ewSg2xFoRFmsac
	/Tee+RLLnlozJyBQa4GBxJjOeOk3HbzQEOU/uAvUxgKg9xbVKlQjT2oDLkmsL5UAcCh2jz
	9ewO6tLQjYiJK5+Jtz4bJgJzW9KXXKg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781086865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0kND7BjJGH83tdD36K/7xRQMQwoDhTHp4fmCse5/V4=;
	b=zFyD2A941kAmNy8m7vW+1FJan6dK+D9c3lwkhVQhAHoDnSth2q6kodu+1wcV1uQQwFRCO6
	8NWoknOx8f4WyECw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3CC91779A7;
	Wed, 10 Jun 2026 10:21:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fOZtDpE6KWrLbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 10 Jun 2026 10:21:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CDC09A0A90; Wed, 10 Jun 2026 12:21:00 +0200 (CEST)
Date: Wed, 10 Jun 2026 12:21:00 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix circular lock dependency in ext4_ext_migrate
Message-ID: <jx7vqc5t2ylp2ddlxhrt24a3otnmqleaub6r5lotf5mgieixdy@anwv564znpsk>
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
 <lr2gyeoay4eai2nujk3siaq7wnqwg3t46an6sipqkmhxarvcrb@tqxhmnstmwnv>
 <7fe6eec7-acd1-4511-beb7-bac9bbdb9cb2@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fe6eec7-acd1-4511-beb7-bac9bbdb9cb2@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5175675891
X-Spam-Flag: NO
X-Spam-Score: -2.51
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Wed 10-06-26 15:04:33, Zhou, Yun wrote:
> 
> 
> On 6/9/26 20:05, Jan Kara wrote:
> > Looks good. Feel free to add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > Just one nit below:
> > 
> > > @@ -591,9 +592,10 @@ int ext4_ext_migrate(struct inode *inode)
> > >        ext4_journal_stop(handle);
> > >   out_tmp_inode:
> > >        unlock_new_inode(tmp_inode);
> > > -     iput(tmp_inode);
> > >   out_unlock:
> > >        ext4_writepages_up_write(inode->i_sb, alloc_ctx);
> > > +     if (tmp_inode)
> > > +             iput(tmp_inode);
> > iput(NULL) is properly handled so you don't need the if (tmp_inode) check
> > here.
> Hi Jan,
> 
> Thank you for your careful review. Should I remove this redundant check in
> v2?

Yes, please. Thank you!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
