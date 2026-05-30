Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D15439AD3A
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780134949; cv=none; b=fOjQwXUvUM66/0FJ0UeY9sMKF8r61hxGdunGzLI8RipITUoc71fZaMDdZQMO6hNk+btVV1Ij3Caw89+PYREpMw0e6rENpZx+Y7LHZsHFBQCvWUf8QR7r1/wuJKGsPibUbvK3lA0IdNnGeSblHsbySAxLVEw57IL14QK/BFiygJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780134949; c=relaxed/simple;
	bh=f0xQgi/DfhelB0PKDqwV/TEZrAue63PfbYn6QVdRPU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+6Zj5lg/yc5t3ikhxuoG3JPa5/VJ/tv0ikyJK/H1WRaiCVs3sID+T+4ZECDIFf8toEXspl9H1wbZBIfPWY7Op7/H2XGTvAcsQKIBL6H7FL/N18qcXoZ4Kv4WjzTXVGjA3hBdJnUVw86VFKrnQ12gpO07oBUWrtKJLa/RD+F22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x5GUJFMk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fjonuPbK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x5GUJFMk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fjonuPbK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x5GUJFMk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fjonuPbK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x5GUJFMk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fjonuPbK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 64A3B6B594;
	Sat, 30 May 2026 09:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780134946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T9Ud4YjAXjWMzUJVVe5qH1xeZRjauidth+ryBCp//TM=;
	b=x5GUJFMk/kI9yfT0V+aqzl1FrW03TbVU/r1yvXofa3e0sJ44/bO9VAxyefCJU0a8fLSq8Y
	7bwr+5r8B3dC2HoI77U2/rWD5Zbbp0KAQVRRmLZtbhEi5VqfEqs3b0WgZ/PmmN1iK/vZ56
	Qj5sUbLdMl0pI8bRyQ51+tTVwh1lCtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780134946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T9Ud4YjAXjWMzUJVVe5qH1xeZRjauidth+ryBCp//TM=;
	b=fjonuPbKVwPeqWDvkn2fUuT0CxOpQ94YwWjma+G7CDIE0voq7DNnyPn3b6nXUwSr53qRh9
	Kp02szaBHAVlRVBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x5GUJFMk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fjonuPbK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780134946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T9Ud4YjAXjWMzUJVVe5qH1xeZRjauidth+ryBCp//TM=;
	b=x5GUJFMk/kI9yfT0V+aqzl1FrW03TbVU/r1yvXofa3e0sJ44/bO9VAxyefCJU0a8fLSq8Y
	7bwr+5r8B3dC2HoI77U2/rWD5Zbbp0KAQVRRmLZtbhEi5VqfEqs3b0WgZ/PmmN1iK/vZ56
	Qj5sUbLdMl0pI8bRyQ51+tTVwh1lCtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780134946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T9Ud4YjAXjWMzUJVVe5qH1xeZRjauidth+ryBCp//TM=;
	b=fjonuPbKVwPeqWDvkn2fUuT0CxOpQ94YwWjma+G7CDIE0voq7DNnyPn3b6nXUwSr53qRh9
	Kp02szaBHAVlRVBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57C58779A7;
	Sat, 30 May 2026 09:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mCFMFCK0GmqrWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 09:55:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EAA14A0EBD; Sat, 30 May 2026 11:55:41 +0200 (CEST)
Date: Sat, 30 May 2026 11:55:41 +0200
From: Jan Kara <jack@suse.cz>
To: Dai Junbing <daijunbing@vivo.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, 
	jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] jbd2: make kjournald2 commit wait freezable
Message-ID: <g4ruau32wwd5n2l6laecffoudlwvh4dbgzlwdh4jp2ulhlrpx5@txr6jewfmcge>
References: <20260527064912.1038-1-daijunbing@vivo.com>
 <20260527064912.1038-3-daijunbing@vivo.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527064912.1038-3-daijunbing@vivo.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 64A3B6B594
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vivo.com:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim]

On Wed 27-05-26 14:49:10, Dai Junbing wrote:
> While waiting for commit work, kjournald2 may be woken during suspend
> and resume due to freezer state transitions. This causes avoidable CPU
> activity in the suspend/resume path and adds unnecessary power overhead.
> 
> Make the commit wait freezable so the thread is not unnecessarily woken
> by the freezer during suspend/resume.
> 
> Signed-off-by: Dai Junbing <daijunbing@vivo.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 4f397fcdb13c..d7ffe60c8793 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -222,7 +222,7 @@ static int kjournald2(void *arg)
>  		DEFINE_WAIT(wait);
>  
>  		prepare_to_wait(&journal->j_wait_commit, &wait,
> -				TASK_INTERRUPTIBLE);
> +				TASK_INTERRUPTIBLE|TASK_FREEZABLE);
>  		transaction = journal->j_running_transaction;
>  		if (transaction == NULL ||
>  		    time_before(jiffies, transaction->t_expires)) {
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
