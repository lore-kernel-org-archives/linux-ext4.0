Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B9243E484;
	Thu,  3 Sep 2026 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788433587; cv=none; b=tSKtFggPL24lRtKsFTQClXnD/7k7JoxkEG13SC4HIX+vt6CpGB8Yzwy6gOiD6xJ5faqEwjw7E4g1+q+ialfyfLGFn4ftBdZ0Ds4rvuDzKsiVYJs3dpQyY/zDboYjFPJRtnadwt20hLd//yrQMmavamcKo9AbxtmG/tCuOqmB/UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788433587; c=relaxed/simple;
	bh=3WKvcdtCwc5+cc4bwGpCAqBW7MRnXQifCKwut5VUVwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6qAA+ncMcRgnttKif3UIK2nyAPOOF8q7kJbC49igg8MIKJ17I3s8ULkr8anX/5OcmWOPZwbDjnswiNIVYW1WHdY7QmZY+zyTabLWx/LKaz8Z6CD336/88723JHYpOtvMkLmRrzLW1YqaxLR2lsQN14ancijAIfTAyaJSnq4h04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0PtG3oOI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BXTMAMzl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tZkm1xqT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sulMIqi2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0PtG3oOI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BXTMAMzl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tZkm1xqT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sulMIqi2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E68621A1F;
	Thu,  3 Sep 2026 11:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788433579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpWtoQEYzbSU7Unj8RTJr0pN/fiWfGdH0Iu8vI0crzk=;
	b=0PtG3oOIEzgzA8v6e40PeHxVIyMFbI/RXoe8vj93DNjs8DkXbHRVgw3MBtzAHSMLsQl9pe
	DFx+dOGQiBS79gNLhufHRNhPO2G87CQPquQiT6lnE3W2KV3SVRNj1acTQ3g6JPA9z0XCxz
	XSohnk3Y/5WIR2bG8YaTwY65v/0haPI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788433579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpWtoQEYzbSU7Unj8RTJr0pN/fiWfGdH0Iu8vI0crzk=;
	b=BXTMAMzlytuH95wao5CyFGGRgXu7WQ3IhyLZuGH5xGayStTkVILiptXrrHKXWszmbsfqPp
	Uh2be5+1d2ttlcAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788433575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpWtoQEYzbSU7Unj8RTJr0pN/fiWfGdH0Iu8vI0crzk=;
	b=tZkm1xqTnNwYICaRae1MToXjYH7av4XjPrUsnWe3AMP2q8pFAQ/yUxtUAQnwIlMGKeA73V
	QeEqmRV5+IrRx1r2dcBCmLt/UwCV2aIBghnLztukhKBuLMyTQLi35KGC9nY8Es3P2LfCfv
	OYqmv6iFkE41m7nIQkBLI31tFcqh4Ho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788433575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpWtoQEYzbSU7Unj8RTJr0pN/fiWfGdH0Iu8vI0crzk=;
	b=sulMIqi2gPSxhmuJ2tYLMKPt66OWHAJj1ZiMLNkWNi9eEgDr4RvidsC/P+uSyiorzSHx6+
	jWjSRPE4lmoKmDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0808136E6;
	Thu,  3 Sep 2026 11:06:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hTLNNqZUmWr1RgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 11:06:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7B8E4A13AC; Thu, 03 Sep 2026 13:06:06 +0200 (CEST)
Date: Thu, 3 Sep 2026 13:06:06 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Elver <elver@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Jan Kara <jack@suse.cz>, 
	Timothy Day <timday@thelustrecollective.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
Message-ID: <hnmqtyjazturtmhrw5xh445q4vrwv2mldhhspl6sf4hj6yzvqn@vzje2tuhtzdq>
References: <20260811160336.782342-1-timday@thelustrecollective.com>
 <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh>
 <20260903072759.GA1750084@ax162>
 <CANpmjNNWiX51UU064+P823sDX42=O6ChSHrUux1aNqLj60mfUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNWiX51UU064+P823sDX42=O6ChSHrUux1aNqLj60mfUg@mail.gmail.com>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Thu 03-09-26 12:34:34, Marco Elver wrote:
> On Thu, 3 Sept 2026 at 09:28, Nathan Chancellor <nathan@kernel.org> wrote:
> >   fs/ext2/super.c:1149:3: error: calling function 'ext2_rsv_window_add' requires holding spinlock 'EXT2_SB(sb).s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
> >    1149 |                 ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
> >         |                 ^
> >   fs/ext2/super.c:1149:3: note: found near match '_res->s_rsv_window_lock'
> 
> sbi was just allocated, and EXT2_SB(sb) and sbi are pointing to the
> same object (unless I misread the code), but the compiler can't tell
> since aliases can't be tracked through non-local objects. So that
> scoped_guard could just become:
> 
>   scoped_guard(spinlock, &EXT2_SB(sb)->s_rsv_window_lock) {
>   ...
> 
> But I'll leave that to Jan and Tim.

Yes, at the beginning of ext4_fill_super() we do:

	sbi = kzalloc_obj(*sbi);
	...
	sb->s_fs_info = sbi;

and EXT2_SB(sb) is just sb->s_fs_info. Are you saying that clang is not
able to infer that sb->s_fs_info and sbi are still pointing to the same
memory later in the function where we do scoped_guard()?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
