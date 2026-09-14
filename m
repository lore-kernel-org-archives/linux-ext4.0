Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7CA42902E
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 10:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789380830; cv=none; b=k9xQ+htp5Qi7QriIvMV1kkuXpkyBXT6BnofO1IXyUVqMxD/W0WWZVFSJLYUh9JqHFe7aC65nhc/xuUIyEN3zB8CJ9cWQ5r4uXUB/QW4aTSGsHbhFq6y37XEB3EIt/5jd6A9pmklRpu2Fcp4jcn7X+M1Jj1Azw+YcrscqE+QhyV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789380830; c=relaxed/simple;
	bh=75BmLiTQZA6CzCH7+HU2BBYY62U599onAYo1+ru00/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPBaBYsbPo5lwVAo60EnZoQyEVSKV+Ut8ffZpucUxnqC1IZ1zIes2cPnxpYd9op2lvpQiu2fyTsCF7p2c6zl/5ZHG27SjGStMhugunUNWHgPBt8jMcysGtxmV4UaR5/1YwlngrwtvZQ5DTzaG6CH9SjoXn7d31YY//hxY+vZu1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fLSv9H53; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0bVIBlP5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=i50xfjsA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+xYDE9HQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fLSv9H53";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0bVIBlP5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="i50xfjsA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+xYDE9HQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 20BB91F7CC;
	Mon, 14 Sep 2026 10:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789380817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N9BHmeGfmaM+h795l4mMnp1HlmzQAsRfDtIglI7G/3U=;
	b=fLSv9H53BidWfQU6/IG2PAihj6h56upBY9bWULSbp53sVDhyXi976DpBi6KZwFa+WfyEcg
	zJU1bl1xd5gX/Lz+o2JS8DyUDguHuB3ZV57QQ66Engnayur0MhjAIS8LaF9to1MmQgzmld
	Sw8d2KnXKPQ5ks9OxNbac8Jq0NLHAKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789380817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N9BHmeGfmaM+h795l4mMnp1HlmzQAsRfDtIglI7G/3U=;
	b=0bVIBlP5HdmTZdCwyflBX8Ns+EEBu29NzZ2c7nTPQac09609WMWqYTA2jXRh3UKIKUoCiZ
	+JCveae53poalaBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789380813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N9BHmeGfmaM+h795l4mMnp1HlmzQAsRfDtIglI7G/3U=;
	b=i50xfjsAB2tDV+YHYeo1ImBzj1cHvePBeFT7ZjL8f3IACZQBpCAyw85suBK29yr/IQDajt
	Of6N+MGegAjyZoubA6dEKFeVCht9bir4mIhACPEnw1JrmXibYNm6SQNUGkmYWcAsGysPc7
	HT6AfZclvxq74ALZ0I7bkSwrePYr2Vo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789380813;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N9BHmeGfmaM+h795l4mMnp1HlmzQAsRfDtIglI7G/3U=;
	b=+xYDE9HQv9/RzFkLC8W2kDgE95XZLJ9ok4epQBi1Ipmw6h9nL0vBJYb2Y3pzFUBZOhVkKu
	5DSmpXeCLS5Z2GAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FB7113515;
	Mon, 14 Sep 2026 10:13:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3Mc7G8zIp2qXCgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 10:13:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D38D3A12E4; Mon, 14 Sep 2026 12:13:31 +0200 (CEST)
Date: Mon, 14 Sep 2026 12:13:31 +0200
From: Jan Kara <jack@suse.cz>
To: shuo chen <1289151713@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH] ext4:Fix WARNING in ext4_journalled_invalidate_folio
Message-ID: <6uzuje34d7v5bu6kgciwh5rusqwkumj2yx5cvew3levyubbslo@cpxmmtmjapv3>
References: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[qq.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Mon 14-09-26 10:19:20, shuo chen wrote:
> when the bh's transaction is committing and the bh is part of the folio,
> journal_unmap_buffer returns -EBUSY and triggers a warning.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes:https://lore.kernel.org/linux-ext4/CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-JLDCqQWEmd9ELtkzddA@mail.gmail.com/T/
> Signed-off-by: shuo chen <1289151713@qq.com>

This is a wrong way to fix that warning and would introduce deadlocks into
the folio truncation in data=journal mode since we'd be waiting for
transaction commit with folio lock held.

The proper fix is to use ext4_wait_for_tail_page_commit() helper before
calling ext4_truncate_failed_write() from ext4_journalled_write_end().

								Honza

> ---
>  fs/ext4/inode.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..6bb94afd5100 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3429,7 +3429,27 @@ static void ext4_journalled_invalidate_folio(struct folio *folio,
>  					   size_t offset,
>  					   size_t length)
>  {
> -	WARN_ON(__ext4_journalled_invalidate_folio(folio, offset, length) < 0);
> +	tid_t commit_tid;
> +	int ret;
> +	bool has_transaction;
> +	journal_t *journal = EXT4_JOURNAL(folio->mapping->host);
> +
> +	while (1) {
> +		ret = __ext4_journalled_invalidate_folio(folio, offset, length);
> +		if (ret != -EBUSY) {
> +			WARN_ON(ret < 0);
> +			return;
> +		}
> +		has_transaction = false;
> +		read_lock(&journal->j_state_lock);
> +		if (journal->j_committing_transaction) {
> +			commit_tid = journal->j_committing_transaction->t_tid;
> +			has_transaction = true;
> +		}
> +		read_unlock(&journal->j_state_lock);
> +		if (has_transaction)
> +			jbd2_log_wait_commit(journal, commit_tid);
> +	}
>  }
>  
>  static bool ext4_release_folio(struct folio *folio, gfp_t wait)
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
