Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E6036403B
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 10:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782125059; cv=none; b=k/OuKXpwn/X6Q/b92hdtNACSk/AnLnwG7nineWdp3ZY5qQHdXNTIVQcKAbvIBVdHDeddeXQSMWIZHZkUpraCeNS46F5khPSDbwRHOpLiB/SPdDww4MThvWab3kM90GIdX8ipXNQUDHxtlx5apDxRiPwbFPu2F/F919DqmUgBnVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782125059; c=relaxed/simple;
	bh=Ch8pJA4BfhHz88dGzI4qEM3Rv2QXgLflQAjqGZAYbYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQ7NRSr3U3E+NIHNb1OWifJTJ5sO6FrUgjreRyEnYiRWGpeFcRp++Cs1xQNHYfsDpGIQECteMxt825Z8XL7jtOYg8Lr6MmIuSxBeWyDkqOyo4opUzqgOXd1SsiLFqCwpWYqh+0gLwT5/TiCFCvE25Q3ZZimHmVKvYZm1NO5nzW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h5hsi3Eo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qtOBuSUO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h5hsi3Eo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qtOBuSUO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h5hsi3Eo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qtOBuSUO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h5hsi3Eo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qtOBuSUO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 81C1175C63;
	Mon, 22 Jun 2026 10:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782125056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkJuekE8nBflzgRyWkLhxQbA8+es5nWK4Wbvf+d4WvA=;
	b=h5hsi3Eo2pqjt8WgJd5LlDGjoO0FeUVknCfhmHdL2v2LeQq+gjadIl0Ur4TVGeSnXzro+A
	q+izdwg/PCQA+LZUGaTGu+FjOHYlyOF78JFOa8VDxer5g6ynovA1T0IYanoCKljqaKfxJG
	MwbhyXb/6LC9xQOvwNc1y+aOdwrlVzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782125056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkJuekE8nBflzgRyWkLhxQbA8+es5nWK4Wbvf+d4WvA=;
	b=qtOBuSUOg0GbUtM99U1N6BIWt1oPqnTh7q0yZ/4p+o9JjmgoX+p5VoA3tqHb/9mXqBc4g+
	WdgmsrftDKLeHwCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h5hsi3Eo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qtOBuSUO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782125056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkJuekE8nBflzgRyWkLhxQbA8+es5nWK4Wbvf+d4WvA=;
	b=h5hsi3Eo2pqjt8WgJd5LlDGjoO0FeUVknCfhmHdL2v2LeQq+gjadIl0Ur4TVGeSnXzro+A
	q+izdwg/PCQA+LZUGaTGu+FjOHYlyOF78JFOa8VDxer5g6ynovA1T0IYanoCKljqaKfxJG
	MwbhyXb/6LC9xQOvwNc1y+aOdwrlVzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782125056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkJuekE8nBflzgRyWkLhxQbA8+es5nWK4Wbvf+d4WvA=;
	b=qtOBuSUOg0GbUtM99U1N6BIWt1oPqnTh7q0yZ/4p+o9JjmgoX+p5VoA3tqHb/9mXqBc4g+
	WdgmsrftDKLeHwCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 735FB779A8;
	Mon, 22 Jun 2026 10:44:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sb6kGwASOWojAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 10:44:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1A46CA12DE; Mon, 22 Jun 2026 12:44:12 +0200 (CEST)
Date: Mon, 22 Jun 2026 12:44:12 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/4] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <izhknkp6llgzvlhq54czatm545fox762vybekmwz3pck2bhjrp@vjj4afhbbkos>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
 <20260616151558.1728881-4-yun.zhou@windriver.com>
 <jxcbsd2ot63wy3dcoximemkuitwoqn2a7jgxcsfdwaf5q3ecdu@sahahqqopo6y>
 <f9c2c9a3-c68d-4c1c-b399-656068ef472e@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9c2c9a3-c68d-4c1c-b399-656068ef472e@windriver.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 81C1175C63
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
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 22-06-26 18:06:23, Zhou, Yun wrote:
> Hi Honza,
> 
> On 6/18/26 02:42, Jan Kara wrote:
> > 
> > Allocating ext4_ea_iput_entry for dropping each inode is somewhat wasteful.
> > I want to suggest another scheme (somewhat more involved but more efficient
> > scheme):
> > 
> > 1) Create a VFS helper bool iput_if_not_last(struct inode *inode) which
> > drops inode reference if it is not the last one (and returns true in that
> > case). Basically:
> > 
> > bool iput_if_not_last(struct inode *inode)
> > {
> >          return atomic_add_unless(&inode->i_count, -1, 1);
> > }
> > 
> > This needs to be a separate patch as it should get vetting from VFS
> > maintainers.
> After taking a closer look, it seems that this function doesn't need to be
> added to the VFS layer — at least not for now. For example, we could
> directly inline atomic_add_unless() into ext4_put_ea_inode():
> 
> void ext4_put_ea_inode(struct super_block *sb, struct inode *inode)
> {
>     if (!inode)
>         return;
>     if (atomic_add_unless(&inode->i_count, -1, 1))
>         return;
>     llist_add(&EXT4_I(inode)->i_ea_iput_node,
>         &EXT4_SB(sb)->s_ea_inode_to_free);
>     schedule_delayed_work(&EXT4_SB(sb)->s_ea_inode_work, 1);
> }
> 
> This way, we avoid submitting an isolated patch to the VFS layer that
> currently has only one user (ext4). If there is indeed a real need for it in
> the future, we can always submit a follow-up patch to refactor it.
> 
> What do you think?

No, please provide a proper helper in VFS for this. We don't really want
filesystems to play games with inode refcount without proper abstraction in
VFS. That causes longterm maintenance issues.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
