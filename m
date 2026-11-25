Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637198;
	b=G1PwT5EEpmgclVJ7shrxxhGP1ma9BsOOukd13DIvhBWiduelKqQEK+JB2RScYY/U6bcD
	 0xzGMGDayZeSBcuCNqXQfRkr4FtwogBSz0O2d+b9jQwo/AdqWia0J6mDMnPx4w9eptHfZ
	 HAKT5Bth0Ct8VGqJlBuVxxSUufTbpYDAaLx2gTesYc52tArQyaHgdqOT6e0Jeb6ZFDtXV
	 HvxwhE+0qQsxFC75Xv/Clojy1J/xMoAzBZDZb9QVwnfDB3u/YWuaa8LZOJOM/QOyWn1N8
	 0tOrmYHoidqGQYJvC5ltgpuIRfD3jetl+stJFhENCSDP78HbNcf9H/h4PWs0WJxEtEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637198;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=FaUWRIGhy+aDbbkEuwsTuQDQBax96w5QWylL9pgnrPA=;
	b=oRYVdYN4hS1IOW+bQCoVNATcJFyD1oNqRSubwGpPU04T3b2yecKaLuWTscI6ve21+0EP
	 JjBLGnufjHRxwhJCQAXYFSlyEyjs5T1M2yRxp21S4aQJPQ4jNmIphQULFV5Dpwddnr9Gj
	 crzM77Ias4KuiMtjDxGVziTNGO8KcT4kwfnDyR/kUDI2xkGx8P7d2lZD0xx61wzFlAdNx
	 2bY7DCmNHjuczXZQWxKuUy20V/NXm2uXpHgayl5QmdSPh7Q1zUB/c0DDZfBU9WFCnlGu7
	 T/t5BRs1RNMiHr83rjFjnY4dKS6Ftg1R6GFkBH1pvhaT/b/j9yhxCTzjjPPGHo0bC0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IrIBmC1E;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=z4JSI4hT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IrIBmC1E;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=z4JSI4hT;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC3C606A31E;
	Wed, 25 Nov 2026 20:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CC3C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IrIBmC1E;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=z4JSI4hT;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IrIBmC1E;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=z4JSI4hT
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A184B1F7CD;
	Wed, 25 Nov 2026 20:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795637195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FaUWRIGhy+aDbbkEuwsTuQDQBax96w5QWylL9pgnrPA=;
	b=IrIBmC1EfOBJJ4uwdXzLK1S2NiEEwg6Ybg6zAeMDaCEp9j/dfKh+7OjlFcYLm5WoGBQJsm
	a/9+gbuavEKMikJvFBKHjt92/ElHYEXApQARk5BdNzWj146e83Aa5vAIpWF1gSK+OyZvqr
	b6TaK8q9nNo8uj0W1IoC/X0KqLTQ7wA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795637195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FaUWRIGhy+aDbbkEuwsTuQDQBax96w5QWylL9pgnrPA=;
	b=z4JSI4hTPMXN/2fSgOiOXwcpp/1OkeBTUsraJ0XmgDOHAwM8XEe1gOOETLQ7903+tLqOIo
	Gu5Iyr3ZqcgTRyAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795637195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FaUWRIGhy+aDbbkEuwsTuQDQBax96w5QWylL9pgnrPA=;
	b=IrIBmC1EfOBJJ4uwdXzLK1S2NiEEwg6Ybg6zAeMDaCEp9j/dfKh+7OjlFcYLm5WoGBQJsm
	a/9+gbuavEKMikJvFBKHjt92/ElHYEXApQARk5BdNzWj146e83Aa5vAIpWF1gSK+OyZvqr
	b6TaK8q9nNo8uj0W1IoC/X0KqLTQ7wA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795637195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FaUWRIGhy+aDbbkEuwsTuQDQBax96w5QWylL9pgnrPA=;
	b=z4JSI4hTPMXN/2fSgOiOXwcpp/1OkeBTUsraJ0XmgDOHAwM8XEe1gOOETLQ7903+tLqOIo
	Gu5Iyr3ZqcgTRyAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7976A1339F;
	Wed, 25 Nov 2026 20:06:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IczkFcs/B2uAQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 20:06:35 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0E5E927D36; Wed, 25 Nov 2026 21:06:35 +0100 (CET)
Date: Wed, 25 Nov 2026 21:06:35 +0100
From: Jan Kara <jack@suse.cz>
To: TAKANO Mitsuhiro <takano32@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: Document the h_invalid flag of a handle
Message-ID: <ylfq77loldtcc3nogxtqkwxlnqnqp5d3nvyrl3kezjtxcnpojg@ujgcfjxe7gkd>
References: <20261125184027.2402549-1-takano32@gmail.com>
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
In-Reply-To: <20261125184027.2402549-1-takano32@gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80

On Wed 25-11-26 18:40:27, TAKANO Mitsuhiro wrote:
> struct jbd2_journal_handle has an h_invalid bit: ext4 sets it when it
> has given up on the handle, and __ext4_journal_stop() BUG_ONs when the
> bit is clear.  The kernel-doc comment lists the other three flags and
> not this one, so kernel-doc reports the member twice:
> 
>   Warning: include/linux/jbd2.h:523 struct member 'h_invalid' not
>   described in 'jbd2_journal_handle'
> 
> Add the line next to h_aborted.
> 
> Verification: kernel-doc -none include/linux/jbd2.h prints that warning
> twice before the change and nothing after it.
> 
> Signed-off-by: TAKANO Mitsuhiro <takano32@gmail.com>

See below for updated text:

> @@ -482,6 +482,7 @@ struct jbd2_revoke_table_s;
>   * @h_sync: Flag for sync-on-close.
>   * @h_reserved: Flag for handle for reserved credits.
>   * @h_aborted: Flag indicating fatal error on handle.
> + * @h_invalid: Flag indicating the handle must not be used any more.

Please write here "Flag indicating the handle is not pointing to a real
journal. Used by ext4 nojournal mode."

>   * @h_type: For handle statistics.
>   * @h_line_no: For handle statistics.
>   * @h_start_jiffies: Handle Start time.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
