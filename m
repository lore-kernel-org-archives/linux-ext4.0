Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7623D31BCAE
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 06:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260090; cv=none; b=iAV7pgSJ1vFR4UN7m+PWXAKzP2RngDSJIx/V5Uz3yuITS5IZ//2LnqqIUFXu3lB1FxF/HM/BPlvaGaU1MMQIcwX8MT38szeMfQMDbDQA+LgygNsuijmYohJWMuSEU84qgtDm4Dku6d6XZsy9uQPyOo4aD4wFAVu6cOPlnswD8e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260090; c=relaxed/simple;
	bh=kqaP0JpKYVXbDDXdiCaQdvxjZAqcmOM/Rnh2H1HAqsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TPrSBH1KUKyo/EXvLT8hvHznjJkkwUzor60qXMX/UKsBkGtEYbh3rfy4gAzaRBuj6ose1rLexvz0DyKPtL6vtICnEI1iwqYeUkfhO3LvSp6+umSc/WxCJNv7Qs69AyyMjsUJqx/xGxFLD/iwFS8fFA/AlRg0zeRAYsQKIZEXERQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m3grDMaQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L0uv2yxB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m3grDMaQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L0uv2yxB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m3grDMaQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L0uv2yxB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m3grDMaQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L0uv2yxB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8824E6ACE3;
	Wed, 20 May 2026 06:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779260087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8+BeSLGdC6GFGayNQikY/zeo5+fXI+Jl/ZW0ikawdU=;
	b=m3grDMaQeQHFJFtpkV1o5S5rwocvEUu3GGnQDLPRDzIUjLg3KVSYYlHDnBrTdOh3wcFqG3
	8Gyw2Ap95/ZFYivkrv2gJ3nPq8rPbAwpipedBU93T0P1ci4raosmWElpm+ja+ah5/d/ob2
	dLbUrcFS6qi8mIjM0Edb510/MhoVzrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779260087;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8+BeSLGdC6GFGayNQikY/zeo5+fXI+Jl/ZW0ikawdU=;
	b=L0uv2yxBqilBJvaQW8LbU7xYbQM8Bva5RE63Wtn+yIaiOF607WCxSKlbq6yDseDoz0am8O
	pVetx5jvNshdXDDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779260087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8+BeSLGdC6GFGayNQikY/zeo5+fXI+Jl/ZW0ikawdU=;
	b=m3grDMaQeQHFJFtpkV1o5S5rwocvEUu3GGnQDLPRDzIUjLg3KVSYYlHDnBrTdOh3wcFqG3
	8Gyw2Ap95/ZFYivkrv2gJ3nPq8rPbAwpipedBU93T0P1ci4raosmWElpm+ja+ah5/d/ob2
	dLbUrcFS6qi8mIjM0Edb510/MhoVzrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779260087;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8+BeSLGdC6GFGayNQikY/zeo5+fXI+Jl/ZW0ikawdU=;
	b=L0uv2yxBqilBJvaQW8LbU7xYbQM8Bva5RE63Wtn+yIaiOF607WCxSKlbq6yDseDoz0am8O
	pVetx5jvNshdXDDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80691593AA;
	Wed, 20 May 2026 06:54:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0hNQH7daDWqFQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 20 May 2026 06:54:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8A225A08D7; Wed, 20 May 2026 08:54:46 +0200 (CEST)
Date: Wed, 20 May 2026 08:54:46 +0200
From: Jan Kara <jack@suse.cz>
To: Sanman Pradhan <psanman@juniper.net>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, 
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>, 
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Subject: Re: WARN_ON_ONCE in ext4_journal_check_start() triggered during
 graceful shutdown
Message-ID: <zvcn6tpdsnuj7tji3cc37cyqo5mhikkctzmss6mdicj2rlrua5@zfefw5bf3fim>
References: <SJ0PR05MB870981E19060D579A839B4AFBA002@SJ0PR05MB8709.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SJ0PR05MB870981E19060D579A839B4AFBA002@SJ0PR05MB8709.namprd05.prod.outlook.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80

Hi!

On Tue 19-05-26 22:08:03, Sanman Pradhan wrote:
> We're seeing the following warning on v6.12 during graceful system shutdown:
> 
>   WARNING: CPU: 3 PID: 215 at fs/ext4/ext4_jbd2.c:73 ext4_journal_check_start+0x57/0xa0
>   Workqueue: writeback wb_workfn (flush-259:0)
>   Call Trace:
>    __ext4_journal_start_sb+0x4b/0x190
>    mpage_prepare_extent_to_map+0x41d/0x4c0
>    ext4_do_writepages+0x26d/0xd40
>    ext4_writepages+0xad/0x170
>    do_writepages+0xe2/0x280
>    __writeback_single_inode+0x4a/0x380
>    writeback_sb_inodes+0x220/0x4f0
>    wb_writeback+0x1cb/0x350
>    wb_workfn+0x259/0x440
> 
> This appears to be a race: during remount-ro, sync_filesystem() completes
> and SB_RDONLY is set, but a writeback kworker that was already scheduled
> before the remount still calls ext4_do_writepages(), which attempts to
> start a journal transaction.
> 
> The WARN_ON_ONCE was added by commit e7fc2b31e04c ("ext4: warn on
> read-only filesystem in ext4_journal_check_start()") with the rationale
> that EXT4_FLAGS_SHUTDOWN should catch all cases first.  However, normal
> admin-initiated remount-ro (shutdown path) does not set
> EXT4_FLAGS_SHUTDOWN, so the sb_rdonly() check is still reachable via
> in-flight writeback.
> 
> The warning is not a functional issue — the -EROFS return correctly
> declines the journal start — but it produces a noisy stack trace on every
> affected shutdown.

Right. I think f4a2b42e7891 ("ext4: fix stale xarray tags after writeback")
should fix your issue. See the changelog for explanation.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
