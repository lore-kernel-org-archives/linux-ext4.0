Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3441478846
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784041780; cv=none; b=QR1wLEdU8wNTGKrJI1XE0ZHEhwUsiQKWJ4qdD5i2IDpKNDLmoQCyf5GRuD/U73jRF+AuD8a5AndbziuzajVtzIxN05BmEpWmOtEJvN9UoqjmKxUKrhKvMUenmUzQrf2/me+jPXhyyKByFLEQSBnF5tBasoqRwCmUvzE918YC1hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784041780; c=relaxed/simple;
	bh=IE+8ibssRroOqOOGnCp56Nu8l6MLwQ4eWpplkxu7yq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzKlwJWpIOocqO4duMkSnsvueqycRzQOunUh53vWMM419eHrQJCmsXSgLzgurzkEUFkwqaRttQWtOUlQ52dClIKlDFDpzfcrjtQWR0ScR9ANpMmUfyYBtGSxoOY2qnSMS8DSWFifKHTgwz6sY4zxcfr2Gev1c3+x1NdqmCILvzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=S9ZPO8mx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vjk7leWe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=S9ZPO8mx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vjk7leWe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="S9ZPO8mx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vjk7leWe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="S9ZPO8mx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vjk7leWe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B746D77ECA;
	Tue, 14 Jul 2026 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784041776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEDraE5TchoTogFB1ypuX46XhqlEYyhY85yNYJQ2bOs=;
	b=S9ZPO8mxQq6H9EWzgICURi0uA79NezQmKf4ibvr1XPvu9ZdTr7b6ON+VIcPhYGiqFeksJC
	JQihoApxsqlrfEYTH2iM3sv1AXLZ9wGYuQw1ns1uBRXKNUV0rljBT4E6NwKsbsnCpeQL80
	YjJsVJviejK9l0GN1N9DTE9BKM4bcS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784041776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEDraE5TchoTogFB1ypuX46XhqlEYyhY85yNYJQ2bOs=;
	b=vjk7leWezw+E9oMY+fMeqagkKi0OcrK8vh8D05nc22FOB0sHqUj/Spd5iSawv3n/EEpAI7
	R+60nIWfJajQX3CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784041776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEDraE5TchoTogFB1ypuX46XhqlEYyhY85yNYJQ2bOs=;
	b=S9ZPO8mxQq6H9EWzgICURi0uA79NezQmKf4ibvr1XPvu9ZdTr7b6ON+VIcPhYGiqFeksJC
	JQihoApxsqlrfEYTH2iM3sv1AXLZ9wGYuQw1ns1uBRXKNUV0rljBT4E6NwKsbsnCpeQL80
	YjJsVJviejK9l0GN1N9DTE9BKM4bcS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784041776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEDraE5TchoTogFB1ypuX46XhqlEYyhY85yNYJQ2bOs=;
	b=vjk7leWezw+E9oMY+fMeqagkKi0OcrK8vh8D05nc22FOB0sHqUj/Spd5iSawv3n/EEpAI7
	R+60nIWfJajQX3CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABAD7779AE;
	Tue, 14 Jul 2026 15:09:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g0bjKTBRVmpsRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Jul 2026 15:09:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 599B7A1319; Tue, 14 Jul 2026 17:09:28 +0200 (CEST)
Date: Tue, 14 Jul 2026 17:09:28 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 2/9] ext4: skip tail block zeroing for inline data
 files
Message-ID: <kwc7kwmlzba3amcxr3hr3kxlgxmm4a3wo64wwphpkf2wpstyrp@zggr4cs3t46r>
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
 <20260714080044.4038124-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714080044.4038124-3-yi.zhang@huaweicloud.com>
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
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Tue 14-07-26 16:00:37, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_block_zero_eof() is called from ext4_write_checks() on every
> append write beyond EOF. For inline data files, ext4_get_block()
> returns -ERANGE when ext4_load_tail_bh() looks up the tail block.
> However, this error is currently ignored because the return value
> of ext4_get_block() in ext4_load_tail_bh() is discarded.
> 
> Before we fix ext4_load_tail_bh() to properly propagate the error,
> skip the zeroing for inline data inodes to avoid unnecessary
> failures or confusion.
> 
> Fixes: 3f60efd65412d ("ext4: zero post-EOF partial block before appending write")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7b2face041ef..3ce925ca0769 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4218,6 +4218,14 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	offset = from & (blocksize - 1);
>  	if (!offset || from >= end)
>  		return 0;
> +	/*
> +	 * Inline data has no tail block to zero out.  Note that a race with
> +	 * ext4_page_mkwrite() converting inline data to an extent without
> +	 * holding i_rwsem is safe, as that path zeroes the full block before
> +	 * copying in the inline data.
> +	 */
> +	if (ext4_has_inline_data(inode))
> +		return 0;
>  	/* If we are processing an encrypted inode during orphan list handling */
>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>  		return 0;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
