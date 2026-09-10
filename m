Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A33B71C7;
	Thu, 10 Sep 2026 10:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035469; cv=none; b=RYtaIq90ksVqoz/UddNzYbrFLYhdC9TO2sN3OpxSTgmnPGw3b8HUXHefr2XCOILH6DCaa3e6wcqSkFgTe7JPGRp7lXjJqg8Du9g8t27cdXGT90r6r92tnQcFz3k4evEoPvXfUePMxvAvLOTiU4hkltJltFM6v84aem2iFqThj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035469; c=relaxed/simple;
	bh=T9m8nC66ib11pvZvZyKxyuisQAOlXWmHIhF+2aIyMi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAlqR45oKTYmd8tPz5dDVZgAfDpGo/5N6B/Vvq4kGE0XadOGIsqMGxlZ7w9sIwUwPzVDySXDmBhEczf5A9gueroOGio7d6KTXqeBVDrOcjtRwQQzIcSf219ErZcgeLtCQFiQAA/7DhchqJfZv8d7NUFKN7V3I1k8Eg5h0B0akoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rmi7JiQJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XudBs3xO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bdDuquK0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EClbRSq+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rmi7JiQJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XudBs3xO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bdDuquK0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EClbRSq+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 70B231FD8B;
	Thu, 10 Sep 2026 10:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789035461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p6LeN/gfHcmSJcqr/mqEkBLS72E6Xex1OIsUtuFiB/A=;
	b=Rmi7JiQJk43wBiDSmdfrazEy1QUCYnmFOITztYbbRMCfa1ZGcSu7OIxwLwDScalzUj0+52
	Om8scqIdalysVXPj120cGdsi/WdCKQiG6JNaxxr+IOlzVeygHNcPPozph2rs/vEpht7yHY
	Dktpv1REm8RP9Ag+VakEZkWQ3ANRIi8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789035461;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p6LeN/gfHcmSJcqr/mqEkBLS72E6Xex1OIsUtuFiB/A=;
	b=XudBs3xOaHMGfSHwgCbwu1t7J+VNphT2zhZPaA0ScfkSLyXF0xPnXRDdmEI6tnIDxqymi/
	EWad+2ho8jeE7uCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789035457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p6LeN/gfHcmSJcqr/mqEkBLS72E6Xex1OIsUtuFiB/A=;
	b=bdDuquK0m1eEvtm5jJxatgzCnZjovyr0Xg+OT6S/VRwnw7V3ErRkGhBUSu/DZJ83HT04Aj
	VGEgKFpOzl/LjOEE1VpbptNFxqIg1x2BFSYFSlQO98DGdp1I4Vtbl+GUn7934HFOUp0J3b
	o2CcWfiQgrzEJV8GKx3y4NtmXNiOwNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789035457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p6LeN/gfHcmSJcqr/mqEkBLS72E6Xex1OIsUtuFiB/A=;
	b=EClbRSq+gVef5LdwcZFt82XElhmlfrkY/SxrKheB8xBpWb8aOSsVPf08NoYpuVv6H9hHkI
	O2v2Me4iv5OmAWCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49BDE13180;
	Thu, 10 Sep 2026 10:17:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dcP5EcGDomrLRAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 10:17:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D04ECA12EA; Thu, 10 Sep 2026 12:17:32 +0200 (CEST)
Date: Thu, 10 Sep 2026 12:17:32 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH] ext4: don't clobber the migration error in
 ext4_ext_migrate()
Message-ID: <kelmhh7sggy7jdobbennzi2k44etqd4pri37ky7yqxd2mecw2r@rsz3trqln4y4>
References: <20260910052927.3161092-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910052927.3161092-1-chenyichong@uniontech.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,uniontech.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Thu 10-09-26 13:29:27, Yichong Chen wrote:
> ext4_ext_migrate() records the failure of the migration in retval, but
> ext4_journal_ensure_credits() overwrites it: it returns 0 when the handle
> has enough credits or the transaction could be extended, and 1 when the
> transaction had to be restarted.  A failed migration is therefore
> reported as success, and a restart leaks the internal value 1 to
> userspace through EXT4_IOC_MIGRATE and FS_IOC_SETFLAGS.
> 
> Fixes: a413036791d0 ("ext4: Provide function to handle transaction restarts")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Indeed. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/migrate.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 2aa6572088cf..e06d847033a1 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -410,7 +410,7 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
>  int ext4_ext_migrate(struct inode *inode)
>  {
>  	handle_t *handle;
> -	int retval = 0, i;
> +	int retval = 0, err, i;
>  	__le32 *i_data;
>  	struct ext4_inode_info *ei;
>  	struct inode *tmp_inode = NULL;
> @@ -567,9 +567,12 @@ int ext4_ext_migrate(struct inode *inode)
>  	}
>  
>  	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
> -	retval = ext4_journal_ensure_credits(handle, 1, 0);
> -	if (retval < 0)
> +	err = ext4_journal_ensure_credits(handle, 1, 0);
> +	if (err < 0) {
> +		if (!retval)
> +			retval = err;
>  		goto out_stop;
> +	}
>  	/*
>  	 * Mark the tmp_inode as of size zero
>  	 */
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
