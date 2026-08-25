Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6FE3B059C;
	Wed, 26 Aug 2026 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731300; cv=none; b=ShOG4bYlXjJAQFFpI73eqw/OmWvY2LvGf3tiPmtgjLgftKYPSBe6NtL/Mg82hRdxr9T4qXTXIysY9TOCGtec9ShNMQEXPA0IcMAewUUjNGR7Yow8srPzkU6CJQBAFdbT2bFr9oYmSki6izwf8UUXIftlJXhKKuS3KBF+ROR/HfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731300; c=relaxed/simple;
	bh=IxiVrrpTHyFhji7IHn86HtWkolVGPiN0U/NpaF18ngg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3S44H3PzbZEwx6VcckAdpuyjG1HWns+d+TVZsydBZZhGuxY+lOw6mldatvJEJXuGV+Q1gNHB1MPj4suvEhZWVdkCB75PQV75mhNkrFgOws+Uefh2quBEPRAYl/gulVjbtkw3R8c+WfNkr4gkMLzfHnoHlyKppo/k04GSPSD79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DTkged1j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dehLYe7D; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=A7qEACt2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nKHPNW0a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DTkged1j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dehLYe7D";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="A7qEACt2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nKHPNW0a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91D501F808;
	Wed, 26 Aug 2026 07:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CdvxYmU0If9qcyse2xh45WeoUF9Da1mUHHyMpdwfLk0=;
	b=DTkged1j0ey7mAbRXOpBdE3MmSJt4QNgySnq7AIKVbvl6fxx6hA0bkmfmcW+EgjZfN7PTm
	KXTYGHC0PHlIqEH1lAwcMPGBAprxH/cz3SvWgxL+RkxmS5Xs6ssVkdPxVLYCMs4fqjo3VF
	mNmOWif/NmKz2P5F9X86r9I6ydIVzsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CdvxYmU0If9qcyse2xh45WeoUF9Da1mUHHyMpdwfLk0=;
	b=dehLYe7D1TAURXfljQb88H/rMUJW/4tqZwDDQUYrfSGQVJpI2cKAezBprWMJyiEXtsJtZt
	c0vil8ms9Z9kW1CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CdvxYmU0If9qcyse2xh45WeoUF9Da1mUHHyMpdwfLk0=;
	b=A7qEACt2canZGIqO6me6VbBwwhs31JR+Ku58kUdhSFhcrNemBst9nR9kB0YVPA/wlpdsWf
	Qn4dOMKBdciwOMvv40KJYEHzHZP0qQs6pbdkvczkRE/Cw6e22R1XAPIFZhtwJtsyJIxuXx
	gsz1iTWjiDNAgvBiNbSUtmgxmVLxOJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CdvxYmU0If9qcyse2xh45WeoUF9Da1mUHHyMpdwfLk0=;
	b=nKHPNW0a3IhvWDm2ZUsj7uSp0QIcgDFVj0zlhkmXL7F3wtI2pL1nGo4D+4s9EeQR371lG7
	FXxlpw4xwSMsHjBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A30061368C;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6RnHJ6OajmoPDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E19B5A13BB; Tue, 25 Aug 2026 19:18:14 +0200 (CEST)
Date: Tue, 25 Aug 2026 19:18:14 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 18/21] jbd2: say what jbd2_freeze_jh_data()'s
 assertion is actually checking
Message-ID: <bnzktcjzpxbnmxmvljg7nnxulvuz3vyqd5p2xrn6orf66kirea@nw2m66x3khvm>
References: <cover.1785951556.git.coshi036@gmail.com>
 <713ffb9c0cdfe55499b3cdd2c06a59a2c152c46c.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <713ffb9c0cdfe55499b3cdd2c06a59a2c152c46c.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:email,fiu.edu:email,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLhn4jw3wthgom179184pqozfe)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Thu 06-08-26 12:58:41, Chao Shi wrote:
> The assertion that the buffer about to be copied out is up to date is
> correct and stays, but its message - "Possible IO failure" - describes what
> a buffer that is not up to date used to mean rather than what is being
> checked.
> 
> Once this series stops clearing BH_Uptodate on write error, that reading is
> wrong twice over.  A failed write no longer makes a buffer not up to date,
> and a buffer that does carry BH_Write_EIO is fine here: it still holds
> valid data and the journal will write it again.  What the assertion is
> really guarding is that there is something valid to copy at all.
> 
> Say that instead.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/transaction.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 5cc7d097b2ac..85d84d909f78 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -920,7 +920,7 @@ static void jbd2_freeze_jh_data(struct journal_head *jh)
>  	char *source;
>  	struct buffer_head *bh = jh2bh(jh);
>  
> -	J_EXPECT_JH(jh, buffer_uptodate(bh), "Possible IO failure.\n");
> +	J_EXPECT_JH(jh, buffer_uptodate(bh), "Buffer not uptodate!\n");
>  	source = kmap_local_folio(bh->b_folio, bh_offset(bh));
>  	/* Fire data frozen trigger just before we copy the data */
>  	jbd2_buffer_frozen_trigger(jh, source, jh->b_triggers);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
