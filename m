Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F3535C6A3;
	Fri, 11 Sep 2026 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789119624; cv=none; b=fBFkpzVGxoBvJmdkKVGmdMrem0Clm7+psJCRdAE9KbSU16E0tX3f3/UxbqEZsIHrTclZJN0vwniQMAduasJK1AgdZMtxuhVNNDpEHLnz9GeXCKY5I4+B2WYvkJT3wIjm005rrqyfioagCTe/zs6lg9KCUNG5OB2mupFQIoXBdOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789119624; c=relaxed/simple;
	bh=UA0gQp/GDhXT7TsLFJlDEHN8EwypYEYEgtzKNIO2pao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0cwuR/n/QYfGw4gyUVr+s/w98wTbMa70g1wAzSVh6ku2eO3XGRPEkUMmkofquG1hJITiTprz4K+jn2sa001nTfzpCMMmKAcFLGmud2XzedXKusY7pOqSRsxTcbspdnrRT+XfTYcSXLpib2vJ2rCJWxdrwWtso+inPbpmdiVJ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iAGyIK/R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U0Y6sc9y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ufEMPpKr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iY0ThGdk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iAGyIK/R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U0Y6sc9y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ufEMPpKr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iY0ThGdk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C95591FE77;
	Fri, 11 Sep 2026 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789119615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rdB+G3KHnjzKwF6D/DKATKW/4fI8TEax8oOFNgKVmlc=;
	b=iAGyIK/RrwBdlqFDvHUe6hIDsiE2mHEmyhx1vBJbptA1883DqNLiB1PokdM4nr3eMVvi3f
	q/08BLiPwTD5Cx35eQ07I8Y2mx+77DdvOnd6+4/lXIZWDcPrUMmYTVwVsTn8sL8KqDzsWi
	j9UVCOdXDXPBM0JrzicmGhlPLJhJ4Qw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789119615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rdB+G3KHnjzKwF6D/DKATKW/4fI8TEax8oOFNgKVmlc=;
	b=U0Y6sc9ykI+Jo064g+zk6kCMujZSRwNhqkER2seWduXe+bgCGLeFlzgRRZJN7IioIgHIlm
	F+6ufSOR5eNf0EDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ufEMPpKr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iY0ThGdk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789119611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rdB+G3KHnjzKwF6D/DKATKW/4fI8TEax8oOFNgKVmlc=;
	b=ufEMPpKrQIPVscF1M3lahPnKy3BjucVFEqL8w35hfYDQ3nReDWZTRK8r5NammTFTBkh3Ih
	SN1YAMaEqZAYxZaCwjwQcOBZd4Af31kffHDaSpQF7jWky8Q/LxMlOsSpFuDimI/Qt8YwOF
	deZ4ByKbLZIymeBdkhUZGcJGmTmEea4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789119611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rdB+G3KHnjzKwF6D/DKATKW/4fI8TEax8oOFNgKVmlc=;
	b=iY0ThGdkytpc4bkhqarbr6/Stx5mnRAYnTl+br7e6DIMavlRDAOISvlKEdSTn4NVQFGd7o
	aLOUzVLJI8bnY8Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A07FD13715;
	Fri, 11 Sep 2026 09:40:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rmwkJ3vMo2pSUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 09:40:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2E1E5A1342; Fri, 11 Sep 2026 11:40:07 +0200 (CEST)
Date: Fri, 11 Sep 2026 11:40:07 +0200
From: Jan Kara <jack@suse.cz>
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: linux-ext4@vger.kernel.org, Jonas Zhou <jonaszhou@zhaoxin.com>, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org, louisqi@zhaoxin.com, 
	jianhuizzzzz@gmail.com
Subject: Re: [PATCH v3] ext4: move orphan tracking away from journal state
Message-ID: <bs6ksf745stfoay2tb5g2cth4t2jwvgr5sudmgr5msznlwnt6n@xw7aro2dl7vy>
References: <575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6jeczy7czbi@a3yq26u52orp>
 <67ae57ef2ee3ac27ab844c22594351c83142d86f.1789097450.git.jonaszhou@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ae57ef2ee3ac27ab844c22594351c83142d86f.1789097450.git.jonaszhou@zhaoxin.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: C95591FE77
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,zhaoxin.com,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zhaoxin.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email]
X-Spam-Flag: NO

On Fri 11-09-26 11:31:13, JonasZhou-oc wrote:
> From: Jonas Zhou <jonaszhou@zhaoxin.com>
> 
> In the tested x86-64 layout, s_journal and s_ext4_flags share a cache
> line with s_orphan_lock and s_orphan. Legacy orphan-list updates
> invalidate the same line used by unrelated journal and inode paths.
> 
> Move s_orphan_lock, s_orphan and s_orphan_info together below
> s_journal_triggers. This separates orphan-list writes from journal
> and flag readers while keeping the related fields in logical groups.
> Add a comment identifying the orphan tracking group and preserve the
> existing member comments.
> 
> On a system with two Xeon Silver 4208 processors and a filesystem
> without orphan_file enabled, repeated tests against v7.3-rc2 recorded
> mean throughput increases of 11.06% for stress-ng dnotify and 35.93%
> for unlink.
> 
> Tests with orphan_file enabled showed no clear throughput change
> within the observed boot-to-boot variation.
> 
> perf c2c shows remote HITM samples on the original shared line, but
> none on the separate journal line after the change. Local HITM samples
> and orphan-lock contention remain.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/all/575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6jeczy7czbi@a3yq26u52orp/
> Signed-off-by: Jonas Zhou <jonaszhou@zhaoxin.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes since v2:
> - Follow Jan's suggestion to move the orphan tracking fields together
>   below s_journal_triggers, instead of exchanging journal state with
>   the error-reporting and lazy-init fields.
> - Add an Orphan inode tracking comment.
> - Rebase and retest against v7.3-rc2.
> 
> v2:
> https://lore.kernel.org/all/a33183c1c24ea47a98afdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com/
> v1:
> https://lore.kernel.org/all/20260903021836.962624-1-jonaszhou-oc@zhaoxin.com/
> 
>  fs/ext4/ext4.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..166910914973 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1644,10 +1644,6 @@ struct ext4_sb_info {
>  	/* Journaling */
>  	struct journal_s *s_journal;
>  	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
> -	struct mutex s_orphan_lock;	/* Protects on disk list changes */
> -	struct list_head s_orphan;	/* List of orphaned inodes in on disk
> -					   list */
> -	struct ext4_orphan_info s_orphan_info;
>  	unsigned long s_commit_interval;
>  	u32 s_max_batch_time;
>  	u32 s_min_batch_time;
> @@ -1786,6 +1782,12 @@ struct ext4_sb_info {
>  	/* Journal triggers for checksum computation */
>  	struct ext4_journal_trigger s_journal_triggers[EXT4_JOURNAL_TRIGGER_COUNT];
>  
> +	/* Orphan inode tracking */
> +	struct mutex s_orphan_lock;	/* Protects on disk list changes */
> +	struct list_head s_orphan;	/* List of orphaned inodes in on disk
> +					   list */
> +	struct ext4_orphan_info s_orphan_info;
> +
>  	/* Ratelimit ext4 messages. */
>  	struct ratelimit_state s_err_ratelimit_state;
>  	struct ratelimit_state s_warning_ratelimit_state;
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
> -- 
> 2.43.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
