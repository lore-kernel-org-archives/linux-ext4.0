Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836AA3C0617
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 08:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782721672; cv=none; b=tVfmQCj5VWH3VxjqbJudWv4ezL+EC9VRAlfJQotvjkRXd+8YEUkBKwJ0Yj/YG5IalA4y5sWAGQFAmV3eF/JBZDokZ7jNUoRCf8kwUzq6HXu1IPOUUG5VrL5HYOyDD1Ps3G4n9I2wKhr4CE5Fr1+RI9xty1IOZ0tjBCAdTH+maDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782721672; c=relaxed/simple;
	bh=Gi1iA9u3CLLui0JKTr5CdubjqUfwNeQd55Jvj/Z72j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rz2MbtQC2OQu3dC49S1WfvxW0SldkIEm4nDSlUvqyru7oC2ktDiJDPFja2IZU34M8a2spIQYOWOzIJYrVwdywNN7pAkGsMxDPM0naaXZEDBIsaHVI+EQDapQHOQK3zB5xp+mlrDaj/nwTax7WcILetXDrWhvyNwf754mE8+oYKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AqZigaMg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gdKWoTdz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lkvgHO9Z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QKo6GCPq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AqZigaMg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gdKWoTdz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lkvgHO9Z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QKo6GCPq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA4AC72F93;
	Mon, 29 Jun 2026 08:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782721669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xsBxVKi1VlvStDzDS55He7K+IRDKI/5zwgE7TblPHjw=;
	b=AqZigaMg1wZHIrppwaCDAMWc2Z3NsdrchQ5gQbF4VgWrxYLBuOfh5+fxfK5SGpEt8isuSz
	pra4BXYe9/5ilfWeLq+Thf6PzTGSgbLY5vdoEpULxDmD6OblK5dR0XVAOBhZe5dMI5GkY6
	+toKd+8/hQbhfh4Sj8wJScobMtKXwMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782721669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xsBxVKi1VlvStDzDS55He7K+IRDKI/5zwgE7TblPHjw=;
	b=gdKWoTdz5hDNFPB/TKTv6mTq6qIQN0CBMM2qRNOn4UfldfQDggXkKuD4KzT1ZhyhxH1G/u
	x4gPbJG8jplAZOBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782721668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xsBxVKi1VlvStDzDS55He7K+IRDKI/5zwgE7TblPHjw=;
	b=lkvgHO9Z+k4dlHpX95Y4k1rJ2NOwoufmEVAga2d0A6OeWPhTqXMfvD7p7WWLYxLefBpnZG
	X1j12lOnho2YM+CsiucvQ4w8rUepPmSch9Wek2YeYn6O+PeyxyYNPhv8OFEqL8mY05dkg7
	0SfO2PcnJJmcsx4E6G8mxs38AXhsCME=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782721668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xsBxVKi1VlvStDzDS55He7K+IRDKI/5zwgE7TblPHjw=;
	b=QKo6GCPq12Us/S9+6iq13RMZW9c8T8HCG+iN2DnhEn9xgdwmPvRmj+EHZosHg3g4lB8UJc
	GcDU5ehcqzPxayCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FC49779A8;
	Mon, 29 Jun 2026 08:27:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eSr/JoQsQmq0HAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 08:27:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 42DB0A10B5; Mon, 29 Jun 2026 10:27:44 +0200 (CEST)
Date: Mon, 29 Jun 2026 10:27:44 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v10 5/5] ext4: prevent deadlock from duplicate EA inode
 references on corrupted fs
Message-ID: <qwgt6qmtq6qjd7myn4dpl6xg62glj52a4ghj657j2m46hwpp7x@fchnmdnzfanw>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-6-yun.zhou@windriver.com>
 <ipqfj2abofanrrcapw2qp4wx6x6m647nqjrhqpuynpxxlh5ugr@utgka6gkeufw>
 <c66cf839-ce82-483c-a463-31204cd2cb5b@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c66cf839-ce82-483c-a463-31204cd2cb5b@windriver.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Sun 28-06-26 16:35:10, Zhou, Yun wrote:
> 
> 
> On 6/27/26 01:23, Jan Kara wrote:
> > On Thu 25-06-26 23:29:41, Yun Zhou wrote:
> > > On a corrupted filesystem, multiple xattr entries may reference the same
> > > EA inode.  When ext4_xattr_inode_dec_ref_all() processes such entries, it
> > > can dec_ref the EA inode (setting nlink=0) and queue it for deferred iput.
> > > If the deferred worker runs before the loop processes the duplicate entry,
> > > the second iget() may block on I_FREEING while the worker's eviction waits
> > > for the caller's transaction to commit -- classic ABBA deadlock.
> > 
> > Hum, this looks possible but it isn't a new thing this patch set
> > introduces. Even before if you had corrupted filesystem,
> > ext4_xattr_inode_array_free() from ext4_evict_inode() could deadlock in a
> > similar way against say ext4_xattr_inode_dec_ref_all() (but practially
> > anything calling ext4_xattr_inode_iget() while holding a transaction
> > handle). So please leave this alone for now. We can look into that once
> > other EA inode settle.
> 
> Mainly because sashiko-bot always flags this issue every time.

Yes, I can see how that's annoying.

> I've further improved the patch and believe I've thoroughly plugged this
> loophole. I will include it in v11, and please take a look when you have
> a chance. If it still has issues, or if you think it's redundant or
> inelegant, we can just drop it.

I can check it. But unless the fix is really simple I still think it
belongs to a separate series.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
