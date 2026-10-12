Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C61B48FF9A;
	Mon, 12 Oct 2026 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818968; cv=none; b=cT+L+Tya1J6r6ppS79jBMoc/AfeP9HQLGgiOEQZONnIg4rxaKVrwSVeFdzhVe8pvgTW4Tbap0VaQNaG3T4LegzZMC6GiQr7ANg24ZJ1ukv8Iy//tD9Y8lifHZq4S/GWDZE7TY7e70Lg7euIzyHsxmKQn/sAQlyCPls0w3nmvQUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818968; c=relaxed/simple;
	bh=oWBQ8Lzyj01Y9WR5TDsBYubeV3IVVy04tirTIspJmAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpCXYrl0Xku75IJGWiUoKUXmoZtt1da+ygJxBl1gnP6oIcJUmYY13WCKV7YjG+jwp+Sv/N+mfPW0LULvZd3i1iRxwvy7JppGO0L1jnlldWKH5aCZDukxbWF2NQJ4FdJjWOU7Apwft9+JF1/G4PVWKfThZjaAG67/8DgHFo9XHdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iUuV39Wz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Toxd9idk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iUuV39Wz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Toxd9idk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iUuV39Wz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Toxd9idk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iUuV39Wz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Toxd9idk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 575F01F391;
	Mon, 12 Oct 2026 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791818965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9MalKMdubRgEO6pLpBwqeroTe667AbZlp0u/K5FcYfE=;
	b=iUuV39WzOUVlF9CwnyIdVK/GKKW774Tu2ldGUIQuzj7RVQ5ull8BSrMJh3qsW+9ZIgf9CV
	f/+iRw58dfEVfxDPlOFLB22NO5HuS5TCoWC+KhSUH6rZODZD0xCVhYasVTHhf9Oe6ZTCfK
	asdQIuFQ9gTgHl5D1ppHP4e8+F7WRtU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791818965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9MalKMdubRgEO6pLpBwqeroTe667AbZlp0u/K5FcYfE=;
	b=Toxd9idkToY2I9USHNUrDVHBGCaCcUFo1kdmCdM3okAll6EWdN0kiwcTUThx+MDxydKgX4
	rIRHhEJs2Mj1EoDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791818965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9MalKMdubRgEO6pLpBwqeroTe667AbZlp0u/K5FcYfE=;
	b=iUuV39WzOUVlF9CwnyIdVK/GKKW774Tu2ldGUIQuzj7RVQ5ull8BSrMJh3qsW+9ZIgf9CV
	f/+iRw58dfEVfxDPlOFLB22NO5HuS5TCoWC+KhSUH6rZODZD0xCVhYasVTHhf9Oe6ZTCfK
	asdQIuFQ9gTgHl5D1ppHP4e8+F7WRtU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791818965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9MalKMdubRgEO6pLpBwqeroTe667AbZlp0u/K5FcYfE=;
	b=Toxd9idkToY2I9USHNUrDVHBGCaCcUFo1kdmCdM3okAll6EWdN0kiwcTUThx+MDxydKgX4
	rIRHhEJs2Mj1EoDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C08C13408;
	Mon, 12 Oct 2026 15:29:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2dO+AtX8zGq/cwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 15:29:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A2FF0A1407; Mon, 12 Oct 2026 17:29:24 +0200 (CEST)
Date: Mon, 12 Oct 2026 17:29:24 +0200
From: Jan Kara <jack@suse.cz>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] jbd2: check return value of blkdev_issue_flush()
 when checkpointing
Message-ID: <4jetlguhlm2f55g4uycjchpm2laxyngs4xzgb52mr4xe6e3l3n@rvfo5ft3jh4f>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 12-10-26 11:47:11, guolingxing wrote:
> jbd2_cleanup_journal_tail() calls blkdev_issue_flush() on the file
> system device to make sure all checkpointed data are on permanent
> storage before it updates the log tail in the superblock.  However
> the return value of blkdev_issue_flush() is ignored so if the flush
> fails, we still advance the log tail.  After a crash the journal
> recovery will consider the checkpointed transactions as committed
> and skip the replay while their data may have never reached the
> disk, which may lead to a filesystem corruption.
> 
> Abort the journal when the flush fails, similar to how we abort
> when detecting writeback errors of the file system device.
> 
> Fixes: 79feb521a447 ("jbd2: issue cache flush after checkpointing even with internal journal")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/checkpoint.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 513273712010..9bbce4c8cadb 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -346,8 +346,14 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>  	 * need this to guarantee correctness.  Fortunately
>  	 * jbd2_cleanup_journal_tail() doesn't get called all that often.
>  	 */
> -	if (journal->j_flags & JBD2_BARRIER)
> -		blkdev_issue_flush(journal->j_fs_dev);
> +	if (journal->j_flags & JBD2_BARRIER) {
> +		int err = blkdev_issue_flush(journal->j_fs_dev);
> +
> +		if (err) {
> +			jbd2_journal_abort(journal, err);
> +			return err;
> +		}
> +	}
>  
>  	return __jbd2_update_log_tail(journal, first_tid, blocknr);
>  }
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
