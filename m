Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B99D52D2DF;
	Wed,  9 Sep 2026 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950757; cv=none; b=hP/NKagRyMIOSv5FKD7AmSQD30Bq4mkdDcwLQB/yMUUC+rgdC/LCnK4g7Z+lw0g9Qg33pO1Y0uic6tQJs4bD0DnhB/Q0f0akeKWSWmO2fwmQkOFJhMZqL0spVDLT3Cw1PsBmT9+aZLQ5fNsIu3phDuQ9TZSe4XhRwyt1qIrNZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950757; c=relaxed/simple;
	bh=SW7cLgojHrcUYXKcjEEu0ONNrq/wW4d4yuppKQ28Jf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfNLnSUjjDXfweVOGYO+RmdgQ8TGeFLVku+iCXDVY691XsoOXRgEfSdcBgu+MWkZsYJ+NU18JwJdVqDMqtbbXotrenBTLGP0ysfw4Boa5vW6NUoqC9+gS6bE4Yxsk5xXnVuDaCYTYTeV+aGWWd74ELKCA1LvW6TIbHevfi31djQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wZgrh7oK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XjpjIQVP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vjJehZzv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bYv4a894; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wZgrh7oK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XjpjIQVP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vjJehZzv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bYv4a894"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EDE321FB94;
	Wed,  9 Sep 2026 10:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788950748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=veSNjv/CclJGuuawSVwaLJ3kDirS5tEQKBLayZHneAA=;
	b=wZgrh7oKi8hZUx7nwG1ZyXsH4zeQ+R57NtJrI7AuJoFRAYtnhcTGUxsDip373OrgGnkPMf
	kOh0AIIhzE1eQ13LPb4edWvOLAaq8RZSKzZkQ4TerMusCiWkY00TlkZCqsmvNqZ9AL2lUh
	+zwWJpYBM8yg3yx0b9MUILL7TpnFUhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788950748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=veSNjv/CclJGuuawSVwaLJ3kDirS5tEQKBLayZHneAA=;
	b=XjpjIQVPER7klngKkoKX6dl73PnYd5HPHKSXemlioT+835uqhfJwaoRIydhafAcwo7IfUt
	eV/2bQO7Ocp0KACg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vjJehZzv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bYv4a894
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788950743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=veSNjv/CclJGuuawSVwaLJ3kDirS5tEQKBLayZHneAA=;
	b=vjJehZzvgePVEh21qvW9xKptgBmpAzeSyUIqr5baRoBDZgfLATM5wrInmlIpuwwHdvYiJD
	ZiP9pbszyaAz3OengjRc4FGx6nANRKPMF9UaGp9AxcEeEZ/ltbmnzjHC2ktm1usI5R0MTc
	KSwdVPmNo1BOmPMbXSJYtGbaZZV5baQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788950743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=veSNjv/CclJGuuawSVwaLJ3kDirS5tEQKBLayZHneAA=;
	b=bYv4a894oFIomDN7P7MKdZJozbClCezL3uISMMevPmLYxIu2mbQ+8b/905tKthqX2r7evd
	dbSk2/puRZAJFhAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5FDA1352C;
	Wed,  9 Sep 2026 10:45:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lr9PMNc4oWpHQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 10:45:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5958DA1341; Wed, 09 Sep 2026 12:45:39 +0200 (CEST)
Date: Wed, 9 Sep 2026 12:45:39 +0200
From: Jan Kara <jack@suse.cz>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix discard work use-after-free on failed mount
Message-ID: <yk63qkcutb7znlrsiwtrc6ijkjtptfxaj73oclyx5px24wka2t@4s4wjofmlnwm>
References: <20260909054124.657782-1-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909054124.657782-1-fanwu01@zju.edu.cn>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EDE321FB94
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
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,zju.edu.cn:email,suse.com:email,suse.cz:dkim,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Wed 09-09-26 05:41:24, Fan Wu wrote:
> ext4_put_super() shuts the journal down before it releases the mballoc
> structures, but the failure unwind of __ext4_fill_super() runs the two
> steps in the opposite order: failed_mount6 calls ext4_mb_release(),
> which flushes sbi->s_discard_work, and the journal is destroyed only
> later, just above failed_mount3a.
> 
> With -o discard, that journal destroy re-arms the work after the flush:
> ext4_journal_destroy() calls ext4_force_commit(), and the commit
> callback, registered once mballoc is initialized, queues s_discard_work
> whenever the discard option is set, even with an empty freed-data list.
> A running transaction can be live at that point: replaying the orphan
> list is the easiest way to get one, and the quota paths on
> failed_mount8/failed_mount9 can leave one too. The final force commit
> is not necessarily a no-op.
> 
> Nothing drains s_discard_work after that point: failed_mount3 flushes
> only s_sb_upd_work and the s_err_report timer, and ext4_fill_super()
> then frees sbi with a plain kfree() through ext4_free_sbi(). If the
> system_dfl_wq worker is delayed across the rest of the unwind,
> ext4_discard_work() then accesses the freed sbi, first through
> sbi->s_sb and then while taking sbi->s_md_lock.
> 
> This is the pattern fixed for the s_err_report timer in commit
> 0ce160c5bdb6 ("ext4: fix timer use-after-free on failed mount"):
> async state armed after the unwind's last drain point.
> 
> Force the commit at failed_mount6, before ext4_mb_release(), so that
> the discard work its commit callback queues is normally already
> pending when the flush_work() in ext4_mb_release() runs.
> disable_work_sync() there then makes this airtight: it also drains an
> instance the flush missed, and no later commit, including the force
> commit inside the journal destroy further down the unwind, can
> requeue the work. The journal destroy stays at its existing position.
> 
> This issue was found by an in-house static analysis tool.
> 
> Fixes: 55cdd0af2bc5 ("ext4: get discard out of jbd2 commit kthread contex")
> Cc: stable@vger.kernel.org # v6.10+
> Assisted-by: Codex:gpt-5.6
> Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>

Looks good to me. Just two nits below. After fixing them feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

>  failed_mount6:
> +	/*
> +	 * Flush any running transaction: its commit callback may queue
> +	 * s_discard_work, which the flush_work() in ext4_mb_release()
> +	 * below drains; disable_work_sync() there also drains an
> +	 * instance queued after that, and keeps the journal destroy
> +	 * further down the unwind from requeueing the work.
> +	 */

I think this comment is a bit too detailed. Maybe just:
	/*
	 * We can have a running transaction from orphan replay or quota
	 * setup. Commit it so that discard work after commit runs before
	 * we shutdown mballoc.
	 */

> +	if (sbi->s_journal)

No need for this check. ext4_force_commit() -> ext4_journal_force_commit()
does it on its own.

> +		ext4_force_commit(sb);
>  	ext4_mb_release(sb);
>  	ext4_flex_groups_free(sbi);
>  failed_mount5:

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
