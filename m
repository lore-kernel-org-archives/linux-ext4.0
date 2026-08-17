Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D4D1386C9;
	Mon, 17 Aug 2026 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982200; cv=none; b=eC43MRFQyumMhMLSM/fPsu1h5KUAfFknLvKV7a3x0/EHuMB5ZRAXuUIQxofx1QsM20xJYcD/Wb7DWFdE0ST7/JJPXNRCK557WsBkp9k4ImiBcc3kjzMMC/FAsypKsdNLJ+VSjxIbxkCB9NGZR3omyCj4iv304KXHEpZIhiBqTQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982200; c=relaxed/simple;
	bh=7pIBfZHXCD1Wm2GmV2KA13I5UF7kk6j+dg4F4flwyFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZEzX1kkLaD1VfjD40qrJyXwNc7sS0353KAr8e3bUj0cHg9jBOFGbnVJKzWVS6FwFt8TtdyM1QY2DgvAQJo72vekey1fFPJjiCyP3MueH5P+yn1+5Axo8375aU1dGz+pqpuhDyNUAWWHJO3o0XuOFkqSJuEG+kVgxAaF3+6Bbo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2apFJ76m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wJgKgr8e; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XBNnMQhS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iX74HtNe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2apFJ76m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wJgKgr8e";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XBNnMQhS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iX74HtNe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C7B3F84082;
	Mon, 17 Aug 2026 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786982193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mr+T1U1mRfGvFpaI0JvMSbNLi4jihP99eTNEpzADsJw=;
	b=2apFJ76m6wprvZPLtSabeabs+CjbFy8gv7YF7QV2nVOkbU8aePG+Cv7ysecoySpqs88nN+
	K7Qhr3NO9SCzu+4SrY3H7QDfeZVDStIZt2Mt/y/zWx2+h/OD9noJIjOu064ml/yhnt/gSF
	Lk0xwL/zJqyUDVY/uSyg6/H6kPwsvhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786982193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mr+T1U1mRfGvFpaI0JvMSbNLi4jihP99eTNEpzADsJw=;
	b=wJgKgr8eh+wJxNTxWbJS0A+XLgT1RWQduh8XQLlR86N4T0H2OR1I2V9bby007CjRtUbfbK
	LtC4GD8UmCY9ugCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XBNnMQhS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iX74HtNe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786982188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mr+T1U1mRfGvFpaI0JvMSbNLi4jihP99eTNEpzADsJw=;
	b=XBNnMQhSetYO8ROwFBF39U9rnt94uAEJbIAPboHOJS7DCy/+HCnIdtxOue/+sNlJ7xgFuU
	U2vJixwl83r7w/UTevcIzcVKCzGfoZALGRbJkF7wfGSyodzFH/2xUMhk4PqCQOXm9rg9kS
	ejl981j+m2+LMe7T9YHMq2urPikNbO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786982188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mr+T1U1mRfGvFpaI0JvMSbNLi4jihP99eTNEpzADsJw=;
	b=iX74HtNeGOrBivudY3giIXlmadN/eW3KCnVbgmGLrcD6H78rZomwT95Dppv9BnLSLVECEh
	X6GNZD4PrG/dcLDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDF0A79543;
	Mon, 17 Aug 2026 15:56:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DEFXLiwvg2pmWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 15:56:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6627DA13B5; Mon, 17 Aug 2026 17:56:24 +0200 (CEST)
Date: Mon, 17 Aug 2026 17:56:24 +0200
From: Jan Kara <jack@suse.cz>
To: Guanghui Yang <3497809730@qq.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext4: orphan tracking after a failed truncate
Message-ID: <66vcv4ircw5mqadt4eki52hujmykrrsqp2cux4qvn37v6kzvs7@d7ys45emz3dr>
References: <tencent_3E210B6E71105F311354D53C158A3A9E1E08@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_3E210B6E71105F311354D53C158A3A9E1E08@qq.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[qq.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: C7B3F84082
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hi!

Quick note for Ted: these kind of reports where LLM complains about
inconsistencies after IO errors or other catastrophic failures are rather
frequent. I think that would be a good candidate for an ext4 specific
prompt for LLMs to explain to it that after metadata IO failure filesystem
inconsistencies are expected and we should just strive to limit lost data.

On Sun 09-08-26 13:45:09, Guanghui Yang wrote:
> I am looking for clarification about the intended orphan handling when a
> truncate fails after its journal transaction has been restarted.
> 
> I reproduced the following using the official kernel.org Linux v6.14
> source:
> 
> - a large truncate naturally triggers jbd2_handle_restart()
> - after the restart, a block-layer fault makes ext4_read_bh() return -EIO
> - ext4_ext_truncate() and the truncate syscall return -EIO
> - the restarted transaction is committed on disk
> - before journal replay, e2fsck -fn reports that the orphan file contains
>   no orphan entries
> - the inode has i_size 0 but still has allocated blocks beyond EOF
> - mount-time journal recovery completes, but the inconsistency remains
> 
> In ext4_truncate(), an error from ext4_ext_truncate() jumps to out_stop.
> For an inode with a nonzero link count, that path calls
> ext4_orphan_del(handle, inode) regardless of the error.  In this run, the
> committed post-restart transaction contains the orphan-file block, and the
> pre-recovery check reports that the orphan file is clean.
> 
> The comment above ext4_truncate() says that an incomplete truncate can be
> restarted from ext4_orphan_cleanup() after a crash.  Should the on-disk
> orphan entry therefore be retained when block removal fails after the
> entry has been added?
> 
> There is a second part to the recovery contract that I am unsure about.
> The EIO marks the filesystem with EXT4_ERROR_FS, and
> ext4_orphan_cleanup() skips orphan recovery in that state.  Is an e2fsck
> repair the intended outcome for this class of error, or should ext4 keep
> enough orphan state for mount-time recovery to finish the truncate?

This is expected. If you hit IO error on metadata, all bets are off wrt
filesystem consistency. Running e2fsck to fix the filesystem is the only
way to establish filesystem consistency again. So there's nothing to fix in
the kernel really as the fact that an inode with blocks beyond EOF is not
on orphan list is just a little nuissance...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
