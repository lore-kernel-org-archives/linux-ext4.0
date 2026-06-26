Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DBA18FDDE
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782484343; cv=none; b=fxwDOmou6P6XfZ+OXByFtxTJ6/xHTXR2DDT9pWcx7gpnJMsFNfq0F+f8ctYoi0tWTeIVCTk85CuoaCdL4/PHaL7FUoQ6TLz0xfiM9xX6xbZQ5aKnYEjFOBxh9S4hAnT2Fyt8M6fgsEiP9lT0iZhJCOv5p8d7OztfvX2tR8ZmcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782484343; c=relaxed/simple;
	bh=q004am3Ss9EtM8C1z9OVdeV+82au7U9vSknA9tJd5f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqjd8cg1xZw9D7MRV550iY9WDxPOMfzgPCYJwn/LY9QU1j3txHsc91zw0f5/t93DZ4RwVZ6pt+K10NiEzY3Q8t2XSxNjQuUz0uGu0xXnA1OYwMGYvw9a4DR1x75yqdvNgE0XMkqh1Em+2Fo5C0G0a3jMnVEXf2Qxz3/ZKUSQmM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HlqrezgP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EwaRyawS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HlqrezgP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EwaRyawS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HlqrezgP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EwaRyawS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HlqrezgP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EwaRyawS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F850759ED;
	Fri, 26 Jun 2026 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782484340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8PK2vdUw41rrmpE/c7N8wIg8qIvSdAxJO2s77oCgSA=;
	b=HlqrezgPa8zH7WgieacL12NxUmkhxW8ybrK2y8f6B6EQFbwUET8TKd24JlVHfH0m4y7ZK4
	Dy944h629mpxnt9/pIp+BPgk5w4k0Jb0e+aEAKKOAeRq2qzEqUf6sMD+XXIyZ0iRl/ttaw
	JsZOzR+DT2zfT4JpzptJr98+1jalMn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782484340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8PK2vdUw41rrmpE/c7N8wIg8qIvSdAxJO2s77oCgSA=;
	b=EwaRyawSXWCcwbQg5CN3AN7N5B/wWzRZg2kmsMsg5WndWxkQlrViZ5Noj7sbdR9vWDxjVt
	a9+eTOK1OU7KP+AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782484340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8PK2vdUw41rrmpE/c7N8wIg8qIvSdAxJO2s77oCgSA=;
	b=HlqrezgPa8zH7WgieacL12NxUmkhxW8ybrK2y8f6B6EQFbwUET8TKd24JlVHfH0m4y7ZK4
	Dy944h629mpxnt9/pIp+BPgk5w4k0Jb0e+aEAKKOAeRq2qzEqUf6sMD+XXIyZ0iRl/ttaw
	JsZOzR+DT2zfT4JpzptJr98+1jalMn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782484340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8PK2vdUw41rrmpE/c7N8wIg8qIvSdAxJO2s77oCgSA=;
	b=EwaRyawSXWCcwbQg5CN3AN7N5B/wWzRZg2kmsMsg5WndWxkQlrViZ5Noj7sbdR9vWDxjVt
	a9+eTOK1OU7KP+AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28054779A8;
	Fri, 26 Jun 2026 14:32:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BU/DCXSNPmqLawAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 26 Jun 2026 14:32:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B399DA10A3; Fri, 26 Jun 2026 16:32:15 +0200 (CEST)
Date: Fri, 26 Jun 2026 16:32:15 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v3 9/9] ext4: fix NOWAIT semantic violation in DAX
 extending writes
Message-ID: <4rrujvd7k6q6su7qupltfgg5imeul6k5updm2yd53c7j63eqyx@fvqgx2rbx2mu>
References: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
 <20260626083518.1064517-10-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260626083518.1064517-10-libaokun@linux.alibaba.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,sashiko.dev:url]
X-Spam-Level: 

On Fri 26-06-26 16:35:18, Baokun Li wrote:
> When a DAX write starts before EOF but extends past i_disksize,
> ext4_write_checks() skips the IOCB_NOWAIT check because
> iocb->ki_pos <= old_size. However, ext4_dax_write_iter() later calls
> ext4_journal_start() to prepare for inode extension, which can sleep
> waiting for journal space or transaction commit.
> 
> This violates NOWAIT semantics and can stall asynchronous I/O frameworks
> like io_uring that rely on non-blocking behavior.
> 
> Fix this by checking IOCB_NOWAIT before calling ext4_journal_start()
> in the extending write path. If NOWAIT is set and extension is needed,
> return -EAGAIN so the caller can retry in blocking context.
> 
> Example scenario:
>   - File: i_size = 1000, i_disksize = 1000
>   - DAX NOWAIT write: offset = 500, count = 2000
>   - ext4_write_checks(): ki_pos (500) <= old_size (1000), skip NOWAIT check
>   - ext4_dax_write_iter(): offset + count (2500) > i_disksize (1000)
>   - ext4_journal_start() → may sleep → violates NOWAIT
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260618125735.4156639-1-libaokun@linux.alibaba.com?part=5
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 49074cc13751..610e109fcd36 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -731,6 +731,11 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	count = iov_iter_count(from);
>  
>  	if (offset + count > EXT4_I(inode)->i_disksize) {
> +		if (iocb->ki_flags & IOCB_NOWAIT) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +
>  		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
>  		if (IS_ERR(handle)) {
>  			ret = PTR_ERR(handle);
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
