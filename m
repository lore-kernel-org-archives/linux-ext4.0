Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA30239D6CA
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780135982; cv=none; b=VEUARxf6ox46DDKyU2aYRPO1MO9LGZrDC9wEh3r1+akMio3FpF58shNHIuet6khyAn3k1HUMidIZ3ArmpjXWtFh3OTdJWTD6wbvHRPF+tjAtY2hSjE2KIGUyjQqOkY0zSiduQe3vx3F2Tp6WMGEC55V66lEEvOv1P2jsN6PlV6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780135982; c=relaxed/simple;
	bh=mU7B9FclbIt7/dNVkXEzijNLMwykdzimeDyYxtlw8sU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CV8jsG/d5ciWfAi0LXjN16eCNGx4zaRu3i+MfIswJZwMmgNiBnEhfm9JiLlEG8ykf4wMk3ngo6PrQr9QtqwhiTnt6Cs+8PZmhReeKssij1Z5YWcwoekzCabSAngZEdvlr6GUk1yASXrAekLJ3L6R38q3KZkpoOP0taZXer/l5dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dgzFszjF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dELTLuhp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ajRYhVOT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/pzPSPxw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dgzFszjF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dELTLuhp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ajRYhVOT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/pzPSPxw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D66026701B;
	Sat, 30 May 2026 10:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780135979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rEYFSU7Bo2H6Y2+Cy03x/YSg0dt9dQzm/ouK3nX6ywk=;
	b=dgzFszjFXTV0AQRxdkAJStSxf+2HEC8tH5SD+F5K6lG4/pv5Pi2oL9HBGA+hcEqqq/Vt/d
	ULulPVtl+Fm3VYgUr+peVm0c6a0INrN7i+8Phimm9aGbJ5MtM59OsqI6/M2nZS8tLHk6SA
	wk8zOy01ZHAzQDlmUH5QUEY2d4TNdcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780135979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rEYFSU7Bo2H6Y2+Cy03x/YSg0dt9dQzm/ouK3nX6ywk=;
	b=dELTLuhpNgByavvlImCcv1tbobeQgJptlKI879cdbI8KleFoiP1lfJb6p2PidLrJEQrBEh
	7KWRJe3dTScFi7Ag==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ajRYhVOT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/pzPSPxw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780135977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rEYFSU7Bo2H6Y2+Cy03x/YSg0dt9dQzm/ouK3nX6ywk=;
	b=ajRYhVOTXEEbdbAyZ+w7gzNNCGfPG14rwt7NcjHcCEiYVAJS6BDqIhyJ+bcQ/IIhqUAr/Q
	JbC1ogpttrfWK0yS1351ayuy/fcHN7/3ZYMIF5unVlrRTSWTPeSCC21yIp/soSlf0wt9Ee
	uISb1/8UQQpOal3WoXtPd8X/NFw7fek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780135977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rEYFSU7Bo2H6Y2+Cy03x/YSg0dt9dQzm/ouK3nX6ywk=;
	b=/pzPSPxwQdJJsce3VyQfdhFZoOrXqBIrbebQZZz3T9/NGP7rkx8mQy+nxgBi0aQ7Dacf4G
	sYkXx2SpsbVrMSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C886F779A7;
	Sat, 30 May 2026 10:12:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cCiMMCm4GmqWaAAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 10:12:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6C28EA0EBD; Sat, 30 May 2026 12:12:53 +0200 (CEST)
Date: Sat, 30 May 2026 12:12:53 +0200
From: Jan Kara <jack@suse.cz>
To: Dai Junbing <daijunbing@vivo.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, 
	jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] select: make select() and poll() waits freezable
Message-ID: <x6scykp6y64sm4wh7auj3scadznxgdtfepwvkkhxmlfjfdnamu@et556hm7rlhy>
References: <20260527064912.1038-1-daijunbing@vivo.com>
 <20260527064912.1038-5-daijunbing@vivo.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527064912.1038-5-daijunbing@vivo.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D66026701B
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,vivo.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]

On Wed 27-05-26 14:49:12, Dai Junbing wrote:
> Tasks blocked in select() or poll() may be woken during suspend and
> resume due to freezer state transitions. This can cause avoidable
> activity in the suspend/resume path and add unnecessary overhead.
> 
> Mark the waits in do_select() and do_poll() as freezable so these tasks
> are not unnecessarily woken by the freezer.
> 
> Both functions are only used from their respective system call paths,
> where the task sleeps without holding locks that would make freezing
> unsafe.
> 
> Signed-off-by: Dai Junbing <daijunbing@vivo.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/select.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index bf71c9838dfe..b0b279748355 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -600,7 +600,7 @@ static noinline_for_stack int do_select(int n, fd_set_bits *fds, struct timespec
>  			to = &expire;
>  		}
>  
> -		if (!poll_schedule_timeout(&table, TASK_INTERRUPTIBLE,
> +		if (!poll_schedule_timeout(&table, TASK_INTERRUPTIBLE|TASK_FREEZABLE,
>  					   to, slack))
>  			timed_out = 1;
>  	}
> @@ -962,7 +962,7 @@ static int do_poll(struct poll_list *list, struct poll_wqueues *wait,
>  			to = &expire;
>  		}
>  
> -		if (!poll_schedule_timeout(wait, TASK_INTERRUPTIBLE, to, slack))
> +		if (!poll_schedule_timeout(wait, TASK_INTERRUPTIBLE|TASK_FREEZABLE, to, slack))
>  			timed_out = 1;
>  	}
>  	return count;
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
