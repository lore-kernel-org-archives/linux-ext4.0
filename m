Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDAF31355B
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 09:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785834262; cv=none; b=p2LL2uvfM8Ai1fvJ41VDbERrHlfnysghLdfPl0icJCEEd62/dFEfLcILMJMrULKpJpG7FDQERryxbGIbofKr6srAY1rG77sc/E78w+BQXbpfPwGUzCwMVpFQXk22oX+wXasL3+VsYvt2DqT2cN6dBGSsGjUg1o9m142Ws/eC3F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785834262; c=relaxed/simple;
	bh=3dn/RwEYGrpkh/UuNMI5Le5aY/RaHFUAxTtvN2ENfTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUy2jpyJNPLB6N6XquuJAB8LjnPT0U5761Vn1Omj3/mtGGYzHVRdjg+8ZvX72ya4gHZdJftDTMatgaf6+c0zLWptbvg/f6PrHfiIGj9dDwK2WFFePFONJu5ykE5eo7lMteNMnCzbHTRqGIMbu2mPF8znTicSWrYzi0g9TI94hG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vuo4xSyf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pcVF42/3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hY1a3ljD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CCP/jGUB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vuo4xSyf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pcVF42/3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hY1a3ljD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CCP/jGUB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DA5C4093;
	Tue,  4 Aug 2026 09:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785834255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X4wSNjS4JuTr04KmsIeAuz3KCot9mJKSEXKBZS1AeNY=;
	b=vuo4xSyfGZCMgFhjYsLsTdDE5wRQeX3JsADuls95gyl6ZtHsbs8CHLR7K9B9eQyiyvLcPR
	e6BASCW9BJBstj/3tXPhVtxroiHmLjQGvZwiWu4I1FuhUwfSF1HMDq0+mbdm5sGDDjZCLn
	gcqjshaeiKmG5DjaZLseKS5COglomiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785834255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X4wSNjS4JuTr04KmsIeAuz3KCot9mJKSEXKBZS1AeNY=;
	b=pcVF42/3WonQ/glUN/0PytnCMACzxw+cTgnWmKB29sn6XpOnDqiODbFqCCaYQMRLEPeyoC
	kcxwD5zRhKfvnuCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hY1a3ljD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="CCP/jGUB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785834251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X4wSNjS4JuTr04KmsIeAuz3KCot9mJKSEXKBZS1AeNY=;
	b=hY1a3ljDi7vwc/jpt9daD+2AoHvVGhU67c0VuBD/OVEUDKCPP6Ue6tgdAwgtIAqP87YOw6
	sf9K0ctD5B0vnwjTvnU3VvWFRr32fCxIAquZct1SG47BPXJSJ/qUQw5VlCwmxupQbSm/PQ
	AKM3X9ZvORCVEi7/njeB6IBqlLWtgR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785834251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X4wSNjS4JuTr04KmsIeAuz3KCot9mJKSEXKBZS1AeNY=;
	b=CCP/jGUBYxAcQMcJcCRSXxcyx6NgJ09tgVSTFqg5C77d0MkbgAIey78upfq4JA6Y9mAHwH
	OazzGeGmfHf8JnBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5814D779C4;
	Tue,  4 Aug 2026 09:04:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PIZ+FQurcWoKfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 09:04:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8ED1FA13A6; Tue, 04 Aug 2026 11:04:10 +0200 (CEST)
Date: Tue, 4 Aug 2026 11:04:10 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] jbd2: assert on a failed write, not on a buffer
 that is not up to date
Message-ID: <3dqz5hq2phvgugscfk56q2h6ukf2fc3xfgjhoat222sonbhnr3@62pmosi6frzu>
References: <cover.1785621505.git.coshi036@gmail.com>
 <8aa2ee674d147d3630f73f7b53fef7781f2aeccc.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aa2ee674d147d3630f73f7b53fef7781f2aeccc.1785621505.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6DA5C4093
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Sat 01-08-26 18:01:01, Chao Shi wrote:
> jbd2_freeze_jh_data() asserts that the buffer it is about to copy out is up
> to date.  Once this series stops clearing BH_Uptodate on write error, that
> assertion stops firing for the case it was written for, because a buffer
> whose write failed stays up to date - which is the point: the in-memory
> copy being frozen is still the data the filesystem wants written.
> 
> Assert on the condition that still means something went wrong.  The message
> loses its "Possible", because BH_Write_EIO is not a guess.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Chao Shi <coshi036@gmail.com>
...
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 5cc7d097b2ac..fdabe34a7e22 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -920,7 +920,7 @@ static void jbd2_freeze_jh_data(struct journal_head *jh)
>  	char *source;
>  	struct buffer_head *bh = jh2bh(jh);
>  
> -	J_EXPECT_JH(jh, buffer_uptodate(bh), "Possible IO failure.\n");
> +	J_EXPECT_JH(jh, !buffer_write_io_error(bh), "IO failure.\n");

After some more thought I think getting here a buffer_write_io_error()
buffer is actually OK and we'll rewrite it. Instead this assert should just
have a different message:

	J_EXPECT_JH(jh, buffer_uptodate(bh), "Buffer not uptodate!\n");

to verify the buffer has valid data.

								Honza


>  	source = kmap_local_folio(bh->b_folio, bh_offset(bh));
>  	/* Fire data frozen trigger just before we copy the data */
>  	jbd2_buffer_frozen_trigger(jh, source, jh->b_triggers);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
