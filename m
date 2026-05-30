Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04FE36895D
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780135865; cv=none; b=tphVRVX7or5RrEt+1UaU2j9DTzq6zYj6nKRM1wW8MVOWX0gRv7+33chE5B5tYMU4Exw7tOW8lgNbw8vM6evFZ9KNYHJUJub/XVSR+dwGtSsjRYSap4kGGP6YHc1Pd15mFq9B3NMMTgGSjcOeiWMHHl6kT2x9D2mzS2goUUuYEsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780135865; c=relaxed/simple;
	bh=JIHj/mwbhHv3VFpPqqpUQlx0TBLygafKy6kDpCWRTp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1P6yfjWBFGiNqwP9c8ScxoBYORRPEbYU3WSE8ToHflls9OUjIX0e5AoPnP0zyT2rUCCudZd2hBAEdstWju5CDKGWQ9k0n8K/tycqPF9pfpkZT5TZBQL2ZA2XWFNZ4g5JIEIF7SsJFHaYbu2iD0ZV/9GBTPSMqhHXjXzejgHoaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tBC/gkvy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6BWk1/NT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=njBNouHq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8w2pcMT4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tBC/gkvy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6BWk1/NT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="njBNouHq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8w2pcMT4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C4622671D8;
	Sat, 30 May 2026 10:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780135860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94eImjKCI0g67yDSes02eEHGvNfb3G8YwjUmlAmhb8w=;
	b=tBC/gkvylUDXQaqgS6F+Do+Vqec0UAf6ifN5bkn9rr2+CTpXV1hrMJUHapPRFcNp4SFZNa
	vj/kFG0/eGPUCwhNc6hxnQA2uhPcRLiEhpP/qQMxUMGzhhm9f9xWiAr1OQFQH6XV0VGTdb
	kEliIIFb/r+/sGk4dYcqGonNBEZwTlg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780135860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94eImjKCI0g67yDSes02eEHGvNfb3G8YwjUmlAmhb8w=;
	b=6BWk1/NTsMa32nayGQqSKXRmPPCGjwRu8u8waQaLM6cYVCwAquQhN+WQPSSFSjiG00EW4U
	MPKe5Nv7QHsPFVCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=njBNouHq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8w2pcMT4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780135859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94eImjKCI0g67yDSes02eEHGvNfb3G8YwjUmlAmhb8w=;
	b=njBNouHqXl97ZK1vNkFMVoMNtgYj4zbF/Abg7yY38rlunKakmCd/hCMKFlt7fT1TJgBaRM
	Me4jAMNLK1S9CuXr9OLHrbaXlmPb4VKPrC+IN2CmltKRXhOcq3o4AGPUYS7yXXxCTZ/KqF
	5te+k2VpJNzMdZLU+EG/a/DeoX4AYJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780135859;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94eImjKCI0g67yDSes02eEHGvNfb3G8YwjUmlAmhb8w=;
	b=8w2pcMT4pnKVsHHS0kj/GXorGMVWut81WN8cA6ctg5el83JmaZMnOUrojby8yIiJsCxcFG
	9XNoCSh+AvCkEEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B6206779A7;
	Sat, 30 May 2026 10:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mx3rK7O3GmqVZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 10:10:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 59DB4A0EBD; Sat, 30 May 2026 12:10:59 +0200 (CEST)
Date: Sat, 30 May 2026 12:10:59 +0200
From: Jan Kara <jack@suse.cz>
To: Dai Junbing <daijunbing@vivo.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, 
	jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pipe: mark blocking pipe read and FIFO open sleeps
 as freezable
Message-ID: <j44pojzowtbta2pxeb6nfwnw3mu4thlx5o73es3a5kivibwnvs@cqhwry46h2fy>
References: <20260527064912.1038-1-daijunbing@vivo.com>
 <20260527064912.1038-4-daijunbing@vivo.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527064912.1038-4-daijunbing@vivo.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C4622671D8
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,vivo.com:email,suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]

On Wed 27-05-26 14:49:11, Dai Junbing wrote:
> Tasks blocked in pipe read or FIFO open may be woken during suspend and
> resume due to freezer state transitions. This can cause avoidable
> activity in the suspend/resume path and add unnecessary overhead.
> 
> Mark these sleeps as freezable so they are not unnecessarily woken by
> the freezer.
> 
> Signed-off-by: Dai Junbing <daijunbing@vivo.com>

So, you don't mention here the reason why not all interruptible sleeps can
be freezable - and that is because you have to make sure we aren't holding
any resources that shouldn't be held when freezing a task. Typically these
are sleeping locks. Freezing task holding a mutex or semaphore or similar
lock is nasty and would need *much* stronger justification than "save a
pointless wakeup on hibernation". 

Making sure we don't hold any lock is rather non-trivial in some cases. For
example in your case here, anon_pipe_read() is used in .read_iter method so
you should make sure all places calling .read_iter don't hold some lock. If
nothing else, I'm missing this analysis in the changelog and I actually
strongly suspect it is not true in some corner cases (like when playing
with splice(2), some files in /proc, or similar).

								Honza


> diff --git a/fs/pipe.c b/fs/pipe.c
> index 9841648c9cf3..594726a7e542 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -385,7 +385,7 @@ anon_pipe_read(struct kiocb *iocb, struct iov_iter *to)
>  		 * since we've done any required wakeups and there's no need
>  		 * to mark anything accessed. And we've dropped the lock.
>  		 */
> -		if (wait_event_interruptible_exclusive(pipe->rd_wait, pipe_readable(pipe)) < 0)
> +		if (wait_event_freezable_exclusive(pipe->rd_wait, pipe_readable(pipe)) < 0)
>  			return -ERESTARTSYS;
>  
>  		wake_next_reader = true;
> @@ -1102,7 +1102,7 @@ static int wait_for_partner(struct pipe_inode_info *pipe, unsigned int *cnt)
>  	int cur = *cnt;
>  
>  	while (cur == *cnt) {
> -		prepare_to_wait(&pipe->rd_wait, &rdwait, TASK_INTERRUPTIBLE);
> +		prepare_to_wait(&pipe->rd_wait, &rdwait, TASK_INTERRUPTIBLE|TASK_FREEZABLE);
>  		pipe_unlock(pipe);
>  		schedule();
>  		finish_wait(&pipe->rd_wait, &rdwait);
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
