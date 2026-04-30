Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4493393DF2
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2026 13:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777554204; cv=none; b=MuuzIiletbWoxXWNWqH9CInFd14l/eu5WO5+A8qXC5hvpeoPDs0U5EOjQyII2Spa36pyE3IqasO717aZoFOVIDendhog+0R3WT7asSRygYktS2xomgetYEhU5cGdZdnIF/LssMOJnyYlN2O5aIAeLXEkFpBswyvaLf8+NuCFj94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777554204; c=relaxed/simple;
	bh=wXABK4448l7PMJBpb810DULt9EZ5DCdFBoM1B4PtgBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLytkgkbGu283fRH5C/8wA659eLr/rM5Jd8UPyRMN46t5nc1k0accSK+Qw6ItgqHKA690uuTxLnmswpQ7ca84ZjGpiledEj2w5KvH8iCU5SUjDrtONC4PXaLESqdDzO/4Y7wJBmobBi1e/Qv6+dx1S1dKOeYopRgfcO5TEAe530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MlWxM7hD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+LVzJOMp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dB4jX5Y5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tpxJsPJ0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MlWxM7hD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+LVzJOMp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dB4jX5Y5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tpxJsPJ0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 279B66A821;
	Thu, 30 Apr 2026 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777554197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yvK5z9Gu7PdBa9/uf2J2aXNXxyD98J70cIR0ygOaGt8=;
	b=MlWxM7hDhVjpZuZMxWbinWtH4ycVfiR+j8Ddc9Wrbeh4QimgjNCgKc7JPp5IG9P7ElclLN
	e4UzGln+n1xUDhamEUOWkLs8/e1TBNhzNVxhA4qGizn/mZq/+Ou9OULbo8sh553iInhVxk
	LjZXtYrviJT9PbxOz0trLpf/725FiQo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777554197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yvK5z9Gu7PdBa9/uf2J2aXNXxyD98J70cIR0ygOaGt8=;
	b=+LVzJOMpfenkRp1NiitiCjrJiF8csG97KGR/STpuRvx72/bHDZEd5hbEdi3nEQRli2/bwF
	rL4l/vyd/yvPz1BA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777554192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yvK5z9Gu7PdBa9/uf2J2aXNXxyD98J70cIR0ygOaGt8=;
	b=dB4jX5Y5DaOOjDLxkdeq7571tnkzCNOCUP+7VhZbex8ZTSPLhTdP9ZaX7ap1uIchNhhdbX
	XUGfV7j+MMPLWaBjH/0cRiA+6rXnDfhVHD57fN8nNEUnB/aphQw6A81ES9H3hABgRIqSHF
	nO2bQVx8QEqqI5Hdep0jvrQsxFcLd+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777554192;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yvK5z9Gu7PdBa9/uf2J2aXNXxyD98J70cIR0ygOaGt8=;
	b=tpxJsPJ0C/qNWL1PJbbo5+9p53NXwHSdopnxwc4fbBESsQkvR9DljubXYLue0y0C3OSnr/
	wrvEuMAQn+DsW1Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C439593B0;
	Thu, 30 Apr 2026 13:03:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TZ/jBhBT82lvHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Apr 2026 13:03:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B4134A0523; Thu, 30 Apr 2026 15:03:03 +0200 (CEST)
Date: Thu, 30 Apr 2026 15:03:03 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 03/22] ext4: simplify error handling in ext4_setattr()
Message-ID: <yueuhejhnqlffyjth5u56japyrgeoa74pasp5zydwrxgbnfrco@iv3gpx33esvu>
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-4-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422021042.4157510-4-yi.zhang@huaweicloud.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RSPAMD_EMAILBL_FAIL(0.00)[yi.zhang.huawei.com:server fail];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email]
X-Spam-Flag: NO

On Wed 22-04-26 10:10:23, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Remove the redundant rc variable and consolidate error handling.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

One comment below. Otherwise the changes look good.

> @@ -6073,8 +6073,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  
>  		filemap_invalidate_lock(inode->i_mapping);
>  
> -		rc = ext4_break_layouts(inode);
> -		if (rc) {
> +		error = ext4_break_layouts(inode);
> +		if (error) {

This is wrong. Errors from ext4_break_layouts() just need to be returned
but they shouldn't be logged with ext4_std_error().

>  			filemap_invalidate_unlock(inode->i_mapping);
>  			goto err_out;
>  		}

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
