Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905881;
	b=VZAAD6vAgUbB4pYBkltcrCNukcaFo+/BubbdBF7aeQROTkewRsK+h+RIhPUzI68dqE7B
	 3af0I5vHdP9GzP7FR+H95Z+V0lyWf/50ciyzhZAH5w/XWUx0Sypi/s3J0PpnHbEIrfsVf
	 Kb5qEW7dj2ec/UaCWk6alHn228ku6Uh8wtRnKXbyhbEbhXnp1WDoVCD8j/3Aehe0ZK7ML
	 zo7Hb3j37jSQdRYUggss7syWtSO5X7rZ8lnGMGJTMy9GW0YlKasBCASOf5IQYnzAGXXXY
	 B7UpH/kgam9PVqKv6OReBdcgZ9vXjDBBQ2Cko8EQZ6rfsco9hb/lvu0kQbXQyGn8OnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905881;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=n3yEXi6OTivPfYgHTXZCsJbsplhpsTfTQ0NHWdHlsRg=;
	b=JNSolxuJZ1IiafWuKdGrjTcXWML367OyKqgzBTaXdqQFKjYKjU+z6C9VUvMdfynyXFOt
	 wGtTTnQVlfyGA5bNvsQ4IJ6yIQaQH264iN6u2nUIAeYUME1Ir7QkUeuhtCRN0gj+uv78Y
	 a9U00sit9NjqIiBI5vlEAmgaQCj4XGxtvO/zYuVrg1SsAOl4Hy8LjFBcOxCAZ7ZFmD27Q
	 RcaxLd+5z2TFUGp/C5cn/JkTV1bSH6gbkkQIkIATVxX+mWCgBN7wmuXOafaur6BCQQVbc
	 6CiIDPrlBFboBmzkDud7ERxfCPWX0rIi0AAXIzUn2iHHrXieWBhK1TC+/X4a+DaGsAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ccvWYqzo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hXlax1G0;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ccvWYqzo;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hXlax1G0;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA09606A32C;
	Thu,  5 Nov 2026 19:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DA09606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ccvWYqzo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hXlax1G0;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ccvWYqzo;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hXlax1G0
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 88ABC21FB9;
	Thu,  5 Nov 2026 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793905878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n3yEXi6OTivPfYgHTXZCsJbsplhpsTfTQ0NHWdHlsRg=;
	b=ccvWYqzoGHgzHeJj65wgZRwYpcaQeSAwfIFFSvDqR0dsb8fA2Ka/pdHrcpRzbCYDCF2B/o
	rnP7XNzlYHnw1QYn6Mvlmn3LSbLSO+NsY3OXq7/iqUoS4MxgZRzSH5bFJf+2z0adpi5sFG
	4TcKYNmyQe6Thb/ryfTEDwyLrdSn0Kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793905878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n3yEXi6OTivPfYgHTXZCsJbsplhpsTfTQ0NHWdHlsRg=;
	b=hXlax1G0dTU3WS4++6GjlloltsEmiLd0yq0aDVtIkmTehyI6hXYwHYgehnmf5oMPISy4ZA
	AVRWVqWNoJsLcbDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ccvWYqzo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hXlax1G0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793905878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n3yEXi6OTivPfYgHTXZCsJbsplhpsTfTQ0NHWdHlsRg=;
	b=ccvWYqzoGHgzHeJj65wgZRwYpcaQeSAwfIFFSvDqR0dsb8fA2Ka/pdHrcpRzbCYDCF2B/o
	rnP7XNzlYHnw1QYn6Mvlmn3LSbLSO+NsY3OXq7/iqUoS4MxgZRzSH5bFJf+2z0adpi5sFG
	4TcKYNmyQe6Thb/ryfTEDwyLrdSn0Kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793905878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n3yEXi6OTivPfYgHTXZCsJbsplhpsTfTQ0NHWdHlsRg=;
	b=hXlax1G0dTU3WS4++6GjlloltsEmiLd0yq0aDVtIkmTehyI6hXYwHYgehnmf5oMPISy4ZA
	AVRWVqWNoJsLcbDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6281C132C9;
	Thu,  5 Nov 2026 19:11:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QoY+D9bU7Go4SwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 19:11:18 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E0941B990; Thu, 05 Nov 2026 20:11:13 +0100 (CET)
Date: Thu, 5 Nov 2026 20:11:13 +0100
From: Jan Kara <jack@suse.cz>
To: Amit Patole <amit.patole@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: document the h_invalid handle flag
Message-ID: <blcq6pkrt6wycircqqm2dh5ss7nt3z7vuc47mvlc7czgpu2opo@jjpdhu3fbqo2>
References: <20261105-kdoc-jbd2-h_invalid-v1-1-4bc224f7d0a2@gmail.com>
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
In-Reply-To: <20261105-kdoc-jbd2-h_invalid-v1-1-4bc224f7d0a2@gmail.com>
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
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 88ABC21FB9

On Thu 05-11-26 09:00:36, Amit Patole wrote:
> Commit 61e2a90a910c ("ext4: enable scoped NOFS when starting a handle
> in nojournal mode") added the h_invalid bit to struct
> jbd2_journal_handle but did not add it to the kernel-doc comment above
> the structure, so kernel-doc now warns:
> 
>   include/linux/jbd2.h:523 struct member 'h_invalid' not described in
>   'jbd2_journal_handle'
> 
> Describe the new flag. It is set by ext4_get_nojournal() on a handle
> that is not attached to any journal and is tested by
> ext4_handle_valid().
> 
> The warning was found by running scripts/kernel-doc over the headers
> pulled into the htmldocs build. An AI coding assistant (Claude Opus
> 5.5) was used to locate the warning and draft this change; it was
> verified with scripts/kernel-doc (no warnings left) and checkpatch.
> 
> Fixes: 61e2a90a910c ("ext4: enable scoped NOFS when starting a handle in nojournal mode")
> Signed-off-by: Amit Patole <amit.patole@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Comment-only change. Built with W=1 on x86_64 (fs/jbd2/, fs/ext4/)
> with no new warnings.
> ---
>  include/linux/jbd2.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index e3886963ba00..69f12366a09a 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -482,6 +482,7 @@ struct jbd2_revoke_table_s;
>   * @h_sync: Flag for sync-on-close.
>   * @h_reserved: Flag for handle for reserved credits.
>   * @h_aborted: Flag indicating fatal error on handle.
> + * @h_invalid: Flag for a handle not attached to a journal (ext4 nojournal mode).
>   * @h_type: For handle statistics.
>   * @h_line_no: For handle statistics.
>   * @h_start_jiffies: Handle Start time.
> 
> ---
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> change-id: 20261105-kdoc-jbd2-h_invalid-8297dd06f190
> 
> Best regards,
> --  
> Amit Patole <amit.patole@gmail.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
