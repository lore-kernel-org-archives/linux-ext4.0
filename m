Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0202B2BDC13
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2026 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297572; cv=none; b=RGa6iksgDPFpqE3BQoqRkkGU7bCSXif5WLkYNhmKq244bayMmZzf6RI8vyVOKa3El93ARYq/6ovYOzfSOfDDkP6G4mKGWZaN4y7KsBsWJLwKnQBJdMAypWUYThmTWCstMgvBvZctPEgigXltSefTtaDO7iZcnwjDAXzjopmIwkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297572; c=relaxed/simple;
	bh=mIcS1P0ZDTZArNTl6JypBjdY/EexnWjZ6Kqpfm0N7uE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnYI6/goW4nKrY5bNkmDbS8yUf/ISE/Q4nOD29D7WQJQKoVV0f4SDWw8Tjm/iTk8EbT1eZOJKFrUgsbEGzCg1yr6ExH09mzou+YyJo4yf1qH6A8m61t/Igxj+hfPKZA8dxVU1VnA6xAdIXd6Orw5sZV2hS+jXgOOP6+gt0/58Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kQSPcfuW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s85VGuOz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=O88HPSAl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z0mIoc0g; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kQSPcfuW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s85VGuOz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="O88HPSAl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z0mIoc0g"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D1DD03E47;
	Fri, 17 Jul 2026 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784297569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wvQ5eO8WYpQY4sLmvW9UEi2eNsE1Cwbt5Q9Niiwjylk=;
	b=kQSPcfuWwsQRX6fxczV2z60y1j9NwAy0oRx1JC499xSuWFFQbBdji8eoAtOjen9MNww57d
	VWRS14lHEgmhKM2oIR4FE/ob4N5yKb8ItR/JO8aTA+n6AmM83qVajGvxUH30bMJd/OOMAE
	3h53P3gsjOhqueltHKtWC7HvJwXVl9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784297569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wvQ5eO8WYpQY4sLmvW9UEi2eNsE1Cwbt5Q9Niiwjylk=;
	b=s85VGuOzz/up9R/1tgrhHKsg8r2cB5oF+nli7vYXDED/fj7zmNMlhvQ9v+H34g/YhdYAAb
	fDe8Tplmz8FtkqBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O88HPSAl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z0mIoc0g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784297568; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wvQ5eO8WYpQY4sLmvW9UEi2eNsE1Cwbt5Q9Niiwjylk=;
	b=O88HPSAlAXhukiZYK1jBYct1L5IF+1KiSFs+4Xl/LE45Tj9yh5nJXqFpRgZWxL5bGfdRw7
	u4DYfhSpNErjOYMaO0dQA0n+hkcofqv2NiGZYdDeoVsd3Z7Htc3YKoK2IPTczSBcg/t2Pe
	K2UdQuK/gTNiOM+j/oV1aGqcT2jCj3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784297568;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wvQ5eO8WYpQY4sLmvW9UEi2eNsE1Cwbt5Q9Niiwjylk=;
	b=Z0mIoc0gUN68sMAoYmOQYPnKTxRFXsMbskf8wiwhzEUIKMIvrIeLibjZHAMF7/tIoOHOem
	S1eAtkSz+3n9J0BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81AD2779AA;
	Fri, 17 Jul 2026 14:12:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /76lH2A4Wmp8EgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 17 Jul 2026 14:12:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D7D7EA09B7; Fri, 17 Jul 2026 12:04:15 +0200 (CEST)
Date: Fri, 17 Jul 2026 12:04:15 +0200
From: Jan Kara <jack@suse.cz>
To: Timothy Day <timday@thelustrecollective.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Marco Elver <elver@google.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/9] ext2: mark s_next_generation as guarded by
 s_next_gen_lock
Message-ID: <hf3qj2wqalzphmmz3r47ileff2cktc6hjhyjijba7q7stanapq@tmtqy6yup6c3>
References: <20260712165610.366474-1-timday@thelustrecollective.com>
 <20260712165610.366474-3-timday@thelustrecollective.com>
 <20260717020302.180974-1-timday@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717020302.180974-1-timday@thelustrecollective.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D1DD03E47
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu 16-07-26 22:03:02, Timothy Day wrote:
> On Sun, 12 Jul 2026 12:56:03 -0400, Timothy Day wrote:
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index 3999f8f3b156e..8c7f3772917bb 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -1125,9 +1125,11 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
> >  		goto failed_mount2;
> >  	}
> >  	sbi->s_gdb_count = db_count;
> > -	sbi->s_next_generation = get_random_u32();
> >  	spin_lock_init(&sbi->s_next_gen_lock);
> 
> If I change this to guard(spinlock_init)(&sbi->s_next_gen_lock), I should
> be able to avoid the context_unsafe() line right after this. I'll fix
> that in the next revision. There may be some other places in the series
> where I can make the same fix.

Yeah, I guess that would be a tad bit better.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
