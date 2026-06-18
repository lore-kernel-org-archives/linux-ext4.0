Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDBE38D686
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790784; cv=none; b=YAwFopTeUK/lOY9I/oBUZjSrlE6UkasWecusJlgM6eO8LPj7CrT6lvYFP5XJLzZve8jZJ9XsFhnVQdFIFZ2HdwqF9Nbr7v9zU4uERhWz8xmDkejljP3FtwHPg1D96oMbdyqLYQ1RyTunNp3N1MHjZMimPZXdscwEiAl6gdQKeoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790784; c=relaxed/simple;
	bh=rJQFb+yMku+s1DytSMQI8/MIBVAAKt5GLWLHFOi4Zsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTJqlKSyqPmz62FvvWPHvMjXGJ/iaBcLbOuBcNzRrTi6hPIQc49jjeISaK5xG9VCYV5MjfcYTghg9cknEtm3YAtYdRq65pz//r1I5POfLJr1c9X+I9BZT0PVi0+dnC1q2QE8ihiXkmIumcLK+GH5n3sVu3crOo8XUYuSoso6QMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wqLOFJac; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xNc+943h; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wqLOFJac; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xNc+943h; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wqLOFJac";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xNc+943h";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wqLOFJac";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xNc+943h"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FAC06D39F;
	Thu, 18 Jun 2026 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=upiBFUHF7V+JaF77+iNRreNbIkmhqGnIMgMwG94xlp0=;
	b=wqLOFJacgCtZ6xlVFov4QPaQf2qJzLFqZCYf9pMxveGaIlZ7jrXtcqUjvWV5dbaUOAuFtR
	4xUA4MH8kErWvSgUx/37pbe5UrgJDBlRcR1uAIl66nlGXYayDsZblz7bnkOdtyFuewIYxZ
	aWesiA97efK87o29e233/Q0KbQ1v6vE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=upiBFUHF7V+JaF77+iNRreNbIkmhqGnIMgMwG94xlp0=;
	b=xNc+943hvgyv1iObvEAH3fMDfV7K3jtgfcjZ4mWSSplRnS2v+/A6mXS2QEXuxqP2U5I06g
	UBs3KB321Yejz3CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=upiBFUHF7V+JaF77+iNRreNbIkmhqGnIMgMwG94xlp0=;
	b=wqLOFJacgCtZ6xlVFov4QPaQf2qJzLFqZCYf9pMxveGaIlZ7jrXtcqUjvWV5dbaUOAuFtR
	4xUA4MH8kErWvSgUx/37pbe5UrgJDBlRcR1uAIl66nlGXYayDsZblz7bnkOdtyFuewIYxZ
	aWesiA97efK87o29e233/Q0KbQ1v6vE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=upiBFUHF7V+JaF77+iNRreNbIkmhqGnIMgMwG94xlp0=;
	b=xNc+943hvgyv1iObvEAH3fMDfV7K3jtgfcjZ4mWSSplRnS2v+/A6mXS2QEXuxqP2U5I06g
	UBs3KB321Yejz3CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 077A1779AC;
	Thu, 18 Jun 2026 13:53:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HSPRAT74M2o7dwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 13:53:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A59ABA12D9; Thu, 18 Jun 2026 15:52:57 +0200 (CEST)
Date: Thu, 18 Jun 2026 15:52:57 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/8] ext4: prevent sleeping allocation in NOWAIT write
 path
Message-ID: <lewrggwmmryv6meqxfbcdph2bqe35gxwzjpkfqhyzpp7ti3pob@nnlgshijsvdy>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-2-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618125735.4156639-2-libaokun@linux.alibaba.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 18-06-26 20:57:28, Baokun Li wrote:
> Block allocation requires journal access which may sleep, violating
> NOWAIT semantics. Return -EAGAIN early when IOMAP_NOWAIT is set,
> allowing the caller to retry without the NOWAIT constraint.
> 
> This ensures that write paths using IOMAP_NOWAIT (e.g., DIO with
> RWF_NOWAIT) will not block on journal operations when blocks need
> to be allocated.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260611163441.2431805-1-libaokun@linux.alibaba.com?part=1
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..832794294ccf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3672,6 +3672,9 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
>  	int ret, dio_credits, m_flags = 0, retries = 0;
>  	bool force_commit = false;
>  
> +	if (flags & IOMAP_NOWAIT)
> +		return -EAGAIN;
> +
>  	/*
>  	 * Trim the mapping request to the maximum value that we can map at
>  	 * once for direct I/O.
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
