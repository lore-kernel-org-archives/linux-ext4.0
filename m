Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794227263;
	b=EoG51CH4OiNp8TkP7Knt0lMufxkxCHPpJYB5WLkScs+4P+/JpuNTd3YcFv8Yj8q71C4w
	 j+QDFbfAHXzHZKsfShRG+CTJrdptxorvZxdPx3cKc0nL6nzxJyVECpo5ZdUOOslDGOUPR
	 g3IFbhtSafE0pCJ3o7ci0jjJzNGZQa1jrryn2lZfzi0dtA71fVRSankNJfNqRFcLlCsW0
	 vnRg+y7uBCQ8aUTWQf4Jnny8fk3QbK7/7WhrBstBlNx8xTuliVXnuBkDRf6Qvzi4lgN6n
	 1xky0Rn7flWTpO6Ujt38livTqCP6Yte6sD3e1GWEwrPY6q3ErrrgqZ1tqcy1hSaK4mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794227263;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=TShl4Qj5cd4OI7xVaq2rRd5VnuO0gWJeEAaJPlDCzGI=;
	b=Crbzo8Tdh7LUCDKzLKJSbHQfLN84By4yiOp8VEmOI+49TtANsSFYYnDdgTNTPoBGkWGz
	 tpXynriaFEU6XSg4rDhrMlUexFMD3F1AEAtGmo+kYHfovHcukOX+pB0WXswLbS/xH42I4
	 GvTZFiI041ZEDIUTgYbhzxhctITW77xvzsXxewEslztdlPksmXC4em7Kyj32iAfLovpSi
	 M1oU2yQyezQiVMj4ozJRLF7msmzVDpScuhw3Ml2IqAOiTMWjPPVV5Ac/A0r5sdGtMq31K
	 KJB9kTahlBUfZV6BnAudW+3d6Jv9iiHjuSBGwqEAYadnfyyb8nOO+5oLgK1hSlF91Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SIl3yVPK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LHEzo2P4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SIl3yVPK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LHEzo2P4;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EE1606A322;
	Mon,  9 Nov 2026 12:27:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3EE1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SIl3yVPK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LHEzo2P4;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SIl3yVPK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LHEzo2P4
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2006C21E65;
	Mon,  9 Nov 2026 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794227261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TShl4Qj5cd4OI7xVaq2rRd5VnuO0gWJeEAaJPlDCzGI=;
	b=SIl3yVPKYJ965+u18PElxIf+SpbpW9DWOuFivvdPxjIDLRcPdYWHeVFP9dPVrOvXcWNKHa
	QXWM4EIsZVEyF2p0+NLKnEPZJswIvNpkjKSzAxCdNLvROd3do4q7E3j/2YcMzYyd9cvVzp
	RXluAneK5cTMlSfwGW/6lIEv1dT+Hf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794227261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TShl4Qj5cd4OI7xVaq2rRd5VnuO0gWJeEAaJPlDCzGI=;
	b=LHEzo2P4Zo+Bt+UY04a9M+fhogjIywgou5EURXROXkzz4WbhnnNfgMWk34VPXbZnigkaLb
	HZQAcNGmQfCGGxBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SIl3yVPK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LHEzo2P4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794227261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TShl4Qj5cd4OI7xVaq2rRd5VnuO0gWJeEAaJPlDCzGI=;
	b=SIl3yVPKYJ965+u18PElxIf+SpbpW9DWOuFivvdPxjIDLRcPdYWHeVFP9dPVrOvXcWNKHa
	QXWM4EIsZVEyF2p0+NLKnEPZJswIvNpkjKSzAxCdNLvROd3do4q7E3j/2YcMzYyd9cvVzp
	RXluAneK5cTMlSfwGW/6lIEv1dT+Hf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794227261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TShl4Qj5cd4OI7xVaq2rRd5VnuO0gWJeEAaJPlDCzGI=;
	b=LHEzo2P4Zo+Bt+UY04a9M+fhogjIywgou5EURXROXkzz4WbhnnNfgMWk34VPXbZnigkaLb
	HZQAcNGmQfCGGxBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED15813302;
	Mon,  9 Nov 2026 12:27:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gX2eMzy88WoZZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 12:27:40 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 83CC921FF9; Mon, 09 Nov 2026 13:27:32 +0100 (CET)
Date: Mon, 9 Nov 2026 13:27:32 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 3/9] ext4: add ext4_inode_loc_block() helper
Message-ID: <txaqqelwopcsrt5hzisylayvcc3h522ga5f7m3kfn2imcs7qwr@xs6v23q6cpeq>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-3-7d6c678a585d@kernel.org>
 <lqhym4n6vu46kretnwfstfutik4vl4l5imhnf6pi3aranjpryx@bgtxuzuha2zs>
 <20261105-eurer-wimpel-gierig-935915475d98@brauner>
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
In-Reply-To: <20261105-eurer-wimpel-gierig-935915475d98@brauner>
X-Rspamd-Queue-Id: 2006C21E65
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	RCPT_COUNT_TWELVE(0.00)[13];
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
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.51

On Thu 05-11-26 10:37:01, Christian Brauner wrote:
> On Wed, Nov 04, 2026 at 06:07:04PM +0100, Jan Kara wrote:
> > So I don't think this patch is really needed. ext4_get_inode_loc_noio()
> > does exactly what you need so you can use it in the next patch. If you
> > really wanted to use sb_find_get_block_nonatomic() instead of
> > sb_find_get_block(), you can actually switch ext4_get_inode_loc_noio() to
> > use it.  ext4_get_inode_loc_noio() has only a single caller in ext4 -
> > ext4_fc_snapshot_inode() - that is actually fine to take the folio lock.
> > But that is mostly unrelated improvement to ext4.
> 
> Ok, I'll drop this and use ext4_get_inode_loc_noio().
> 
> Hm, the nonatomic lookup isn't optional though. Afaict, the atomic one
> bails when the folio is being migrated. So for the fast commit snapshot
> this now means we fall back to a full commit.
> 
> So in ->sync_inode_metadata() we now skip a dirty inode block and
> fsync() returns before it's on disk. So we need to switch
> ext4_get_inode_loc_noio() over to atomic as well, no?

Yeah, you are right. That's a subtle difference.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
