Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64F44973A2;
	Wed,  7 Oct 2026 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377060; cv=none; b=N/sTnwtyj/5JNp6E0UHJTgsgZx9TCGpPTc9651GlqzjBb7086atEe8BHn5FPokymRgU1yU8HLdZkvZTIzqlTREG1x2JNyOVc/Txde26LHcrsz3FV2mjwfChm1+59HcsdG3fIubproYu6JvU+7FMQMpqf29c65ssSs/Zq6uuDTmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377060; c=relaxed/simple;
	bh=4rZ1YrUR53Ww2fXvW5mSKt2hnfigChYTV1LZHZbGtBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJ69Fq0wqo0yOS1J7aTJpnSu7/a53yLEHhUqQwlRzxicF31hHV9a36AznhhYE3x2fluX9YaKM9wtRVz08qjPUQec2I7lnIDxEDuirPxh9oExuDDPChvI++Fsy+CepqnFVJcxM7nfDjY75Kh3jahADVIGDWYY7DUkZUgPqP/itX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CmSTxDjk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hAA19RFU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EQYLwAxC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oNpD3aU1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CmSTxDjk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hAA19RFU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EQYLwAxC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oNpD3aU1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44FCE1F391;
	Wed,  7 Oct 2026 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791377050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W8YmGbG2QVXUCosoSguT8Yoo2PP6BTDi63ecnP8k3G0=;
	b=CmSTxDjkgIFyVHegcX43tHPfw5JVNiwywQfk9SEBg8vzBdvTNupD0aPAuTvYnwTEGyfKQ2
	uM+bJE4bmvsscd6ojs5nUtYEQV/gefBbfKJBU/BqmJT6nn4dUk3cDGcn1ILuS4UQL1vHMQ
	FJvEvLPGkTWBvpFGVQ/5/UDOzND11Sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791377050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W8YmGbG2QVXUCosoSguT8Yoo2PP6BTDi63ecnP8k3G0=;
	b=hAA19RFUFz+9mMGtQa2okeWhIb2HVFn9YFKlsYOsh5AgCO9OLeEKyBXMcyN/vQKPFSduPx
	ll3dejAUr7FQljDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791377049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W8YmGbG2QVXUCosoSguT8Yoo2PP6BTDi63ecnP8k3G0=;
	b=EQYLwAxC6gaYjMoZSOWCxS1W+vRaKShHp49P6g4qzo0stm2g0ITYSt43qZeX4lp/+GSSaj
	KOBqIEeHA5ONQX9jZ7Tg0xE0Ty/OiLbCeMR4818V3KDPMTPxhsJOmmQY/YM3FHhcykj8W+
	JUPUpegw3Fg2GbmRyKlgZPscRw8uEHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791377049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W8YmGbG2QVXUCosoSguT8Yoo2PP6BTDi63ecnP8k3G0=;
	b=oNpD3aU1kQqKiVwq7O7SA/u8oVOVixf62TuGUi7uZeTyS0i5xYX9YRi8gNsYv4ZW8NbktC
	0PT/ovSrFjUL0IDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC4DB13354;
	Wed,  7 Oct 2026 12:44:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vYPhMZg+xmpdWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Oct 2026 12:44:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4EEE2A13FE; Wed, 07 Oct 2026 14:44:04 +0200 (CEST)
Date: Wed, 7 Oct 2026 14:44:04 +0200
From: Jan Kara <jack@suse.cz>
To: daejun7.park@samsung.com
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>, Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] jbd2: don't start a fast commit while the journal is
 marked empty
Message-ID: <coe3to72lu7bpma674x2z5yy6ng3ixia5xkqcx3halyijbmcnr@j5fierqu2stw>
References: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,suse.com,suse.cz,vger.kernel.org,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,linux.beauty];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,samsung.com:email]

On Wed 07-10-26 09:41:09, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> jbd2_journal_flush() checkpoints everything, and
> jbd2_mark_journal_empty() then writes the journal superblock with
> s_start == 0 and the fast commit feature cleared. It sets JBD2_FLUSHED
> so that the next commit writes the log tail and the feature back, but
> only jbd2_journal_commit_transaction() looks at that flag. A fast commit
> started before the next full commit writes its blocks while the
> superblock on disk still says the log is empty: jbd2_journal_recover()
> returns at once and the fast commit is never replayed.
> 
> On ext4 with -O fast_commit this happens after ext4_freeze(), and after
> a remount to read-only, which flushes the journal in
> ext4_mark_recovery_complete(), once the file system is read-write again.
> EXT4_IOC_CHECKPOINT and online resize flush it as well. An fsync that a
> fast commit handles after one of them is lost if the system crashes
> before the next full commit, which can be up to the commit interval
> later:
> 
>   mount -o commit=60 (-O fast_commit file system)
>   echo first > a; sync
>   fsfreeze -f; fsfreeze -u      # or: remount ro, then rw
>   write b; fsync b              # one fast commit, s_start still 0
>   crash (kill the VM), mount
>   b is missing
> 
> Refuse to start a fast commit while JBD2_FLUSHED is set, as is already
> done before the first full commit. ext4 then falls back to a full
> commit, which writes the log tail, and the fast commits after it are
> recovered again. fc_info counts the refused fast commit as ineligible,
> as it does for the existing check.
> 
> Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Yeah, good catch! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Tested in QEMU on ext4 dev 9091c97be340, crashing by killing QEMU: the
> sequence above loses b without this change and keeps it with it, both
> after fsfreeze and after a remount ro then rw. A second fsync after the
> fallback is a fast commit again and is recovered. xfstests ext4/044
> ext4/045 generic/455 generic/456 generic/482 with -O fast_commit, and
> generic/068 generic/085 generic/390, give the same results as without
> the change (generic/455 fails on both).
> ---
>  fs/jbd2/journal.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d..22576af8c8 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -695,7 +695,8 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
>   * it to complete. Returns 0 if a new fast commit was started. Returns -EALREADY
>   * if a fast commit is not needed, either because there's an already a commit
>   * going on or this tid has already been committed. Returns -EINVAL if no jbd2
> - * commit has yet been performed.
> + * commit has yet been performed, or none since the journal was last marked
> + * empty.
>   */
>  int jbd2_fc_begin_commit(journal_t *journal, tid_t tid)
>  {
> @@ -714,6 +715,16 @@ int jbd2_fc_begin_commit(journal_t *journal, tid_t tid)
>  		return -EALREADY;
>  	}
>  
> +	/*
> +	 * The log was emptied and the superblock on disk says so, which makes
> +	 * recovery skip the fast commit area as well. Only a full commit
> +	 * records the log tail again.
> +	 */
> +	if (journal->j_flags & JBD2_FLUSHED) {
> +		write_unlock(&journal->j_state_lock);
> +		return -EINVAL;
> +	}
> +
>  	if (journal->j_flags & JBD2_FULL_COMMIT_ONGOING ||
>  	    (journal->j_flags & JBD2_FAST_COMMIT_ONGOING)) {
>  		DEFINE_WAIT(wait);
> 
> ---
> base-commit: 9091c97be34083587a75db174aab51551d8e8543
> change-id: 20261006-jbd2-fc-after-flush-2ef9bbc32cea
> 
> Best regards,
> -- 
> Daejun Park <daejun7.park@samsung.com>
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
