Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540465;
	b=J6Qi6Ge9k8Whzc3TpFN2iPgvZClya3ExZTkpUOsytBSviCODjx+0qZDlrfo4l065t1rL
	 C0xJz6+Js345klS9dprk5Ijy02WgMmsy2qKX4cNjFKEyMMor5bhCxGMfKNp00LINHJSLQ
	 kr33r9YceLx8zvJRx8t8r/eI89o63IgiH9Bf/TQwgc+Md9ismFOkgXQpHsjuDZ/Cj+X5R
	 BPrjfypxiRa1vFaHownngBFwEfXVyhVin3Lu5baVo9w8EtrXS1WRomVl7QPG5PFg20rq/
	 caYpXwreNH9K4kCZw4Y+5c9RPN9k6x5kznCYUSabBmmHc5AMaxLkUZL5DrdaM/ZglIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540465;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=rzqCQtpqrLDDyu7ncN7OAfBve3N8Z/NJ+nLdXHaRrnk=;
	b=ccdLBm1cCzMVde72Zyv2YJeSCzn7Zg+BSH6xzEeIVMmFZJMYUFdAlIwM/h+XRDprrv+s
	 SHw8m9ir1+FDifMbW4wKd14biTyOTyT2yROoEjSEkVMiKPcg87FrRP3pnosyxCmOOhBqI
	 s13a5nbONIdGv8P4NoglCoRzjePZge5WgL9xdV+z3xJos90Bgl8Py9+elGoZwWESfOS36
	 fdu2DIHcT7QwZ+ZVf3Ca8UUqhvz3oR+g0LmgIrs3CkPXEsg89bdWOcFmlXEi4sB5rqxgG
	 OrAmTXlOWRtM33H1rmozqR80SPlflEof+0+FU6O3mU0+GLT05eD0uuE34oC6qwrnh5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FHUxAU7k;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="Vwjmi/U6";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lBdrN5Hz;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Pi88vuV;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772C2606A321
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 17:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 772C2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FHUxAU7k;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Vwjmi/U6;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lBdrN5Hz;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Pi88vuV
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76A861FD12;
	Tue, 24 Nov 2026 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795540462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzqCQtpqrLDDyu7ncN7OAfBve3N8Z/NJ+nLdXHaRrnk=;
	b=FHUxAU7k1Xdd23yNm6nFSC6YXdsTNyiUyo8HZgSep3iBUS/6zo8shNm5MZEuLSgDB6imON
	SpLZuP6fLgF0VvfQ5tmlrdMnHjXIQsIpsHyEk7c91Mu0/ckUD1ynHBhxt8IfNYnfs1P+Am
	wxjwMKXP9GSnsvoqPveaEWm88VQbiHw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795540462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzqCQtpqrLDDyu7ncN7OAfBve3N8Z/NJ+nLdXHaRrnk=;
	b=Vwjmi/U6OmbTY/gdKQ0HOrdEurwlnY0tf7SDa0a35O/ao3xB459JapFMpqBvn1lRQ+C746
	nEgZpY+7c5LOGpDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795540461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzqCQtpqrLDDyu7ncN7OAfBve3N8Z/NJ+nLdXHaRrnk=;
	b=lBdrN5HzWwj9Pj/z79JGfhZJtDwWDvNItG4uANAWkZKAuOZJs/AaoYKbDiuQnip64KjVOe
	TFmCDaaTHCuVkQ5CEHod+msRzdFx7rJChnhqFsguNE6YAnV8CibG0FuiUXF6K5SqZPqvsb
	q6/sKTjmI14bnydQZxOmdGv3Y1yK/kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795540461;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzqCQtpqrLDDyu7ncN7OAfBve3N8Z/NJ+nLdXHaRrnk=;
	b=8Pi88vuVKIxfc5ppRHBsuESrtrUOehQ9sH9PgdJEoIGGVdjOS9Cc1jPdX3hOfshuRL17SB
	j5lFAnfzvpS7/nCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30C7C1339F;
	Tue, 24 Nov 2026 17:14:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id adovBOzFBWvUWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 17:14:20 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9F33727A3B; Tue, 24 Nov 2026 18:14:15 +0100 (CET)
Date: Tue, 24 Nov 2026 18:14:15 +0100
From: Jan Kara <jack@suse.cz>
To: "yebin (H)" <yebin10@huawei.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] ext4: protect ext4_acquire_dquot against freezing
Message-ID: <5u223kwv7ro7drsneuho3xsa2u6xnbkctqpmnjek6542w6jc7m@ywa436txf5h6>
References: <20261123114602.66520-1-yebin@huaweicloud.com>
 <sashiko-outbox-229179@kernel.org>
 <6B050ABA.1050808@huawei.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B050ABA.1050808@huawei.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80

On Tue 24-11-26 11:55:38, yebin (H) wrote:
> 
> 
> On 2026/11/23 20:02, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue to consider:
> > - [High] ext4: deadlock with thaw_super() in ext4_acquire_dquot() via
> >    Q_XGETQUOTA
> > --
> > 
> > commit f23e3eb68e6a88d3c8dec26c7efee607385b6388
> > Author: Ye Bin <yebin10@huawei.com>
> > 
> > ext4: protect ext4_acquire_dquot against freezing
> > 
> > This commit wraps ext4_acquire_dquot() with sb_start_intwrite() and
> > sb_end_intwrite() when no journal transaction is currently active to
> > protect quota acquisition against filesystem freezing.
> > 
> > Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/20261112135245.3347102-1-yebin@huaweicloud.com/
> > 
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index 359f9d4ed4479..a06d5f298c849 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -7118,11 +7118,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
> > >   {
> > >   	int ret, err;
> > >   	handle_t *handle;
> > > +	bool freeze_protected = false;
> > > +
> > > +	/*
> > > +	 * Trying to sb_start_intwrite() in a running transaction
> > > +	 * can result in a deadlock. Further, running transactions
> > > +	 * are already protected from freezing.
> > > +	 */
> > > +	if (!ext4_journal_current_handle()) {
> > > +		sb_start_intwrite(dquot->dq_sb);
> > > +		freeze_protected = true;
> > > +	}
> > 
> > [Severity: High]
> > Can calling sb_start_intwrite() here cause an ABBA deadlock between
> > sb->s_umount and SB_FREEZE_FS when Q_XGETQUOTA or Q_XGETNEXTQUOTA runs on
> > a frozen filesystem?
> > 
> > quotactl_cmd_write() returns 0 for Q_XGETQUOTA and Q_XGETNEXTQUOTA, so
> > quotactl_block() and quotactl_fd() acquire down_read(&sb->s_umount)
> > without waiting for the filesystem to thaw.  If the queried dquot is not
> > yet active in memory, dquot_get_dqblk() calls dqget() ->
> > ext4_acquire_dquot() with no running transaction and blocks in
> > sb_start_intwrite() while holding s_umount:
> > 
> > CPU0                              CPU1
> > ----                              ----
> > down_read(&sb->s_umount)
> >                                    sb_freeze_unlock(sb, SB_FREEZE_FS)
> > sb_start_intwrite(sb)
> >                                    down_write(&sb->s_umount)
> > 
> >   *** DEADLOCK ***
> > 
> > CPU0: do_quotactl() -> quota_getxquota() -> dquot_get_dqblk() ->
> >        dqget() -> ext4_acquire_dquot()
> > CPU1: thaw_super() -> super_lock_excl() -> thaw_super_locked()
> > 
> > Once this happens, thaw_super() cannot acquire s_umount to unfreeze the
> > filesystem, leaving the filesystem permanently wedged.
> > 
> Hi Jan,
> 
> Sashiko reported a deadlock with thaw_super() when Q_XGETQUOTA or
> Q_XGETNEXTQUOTA runs on a frozen filesystem.
> 
> Looking at this, I think the same reasoning as commit ccf370e43e08
> ("quota: Forbid Q_GETQUOTA and Q_GETNEXTQUOTA for frozen filesystem")
> also applies to Q_XGETQUOTA/Q_XGETNEXTQUOTA, since these can likewise
> end up in ->acquire_dquot().
> 
> So my question is: would it be acceptable to also forbid these two
> commands on a frozen filesystem, i.e. add them to quotactl_cmd_write()?

Yes, please make them consistent with Q_GETQUOTA and Q_GETNEXTQUOTA. Nobody
complained in those 10 years about the generic quotactls so I doubt anybody
will complain about these XFS ones. Just make it a separate change. If
somebody complains about changed behavior, we'll have to revert and
implement proper read-only querying.

> My concern is the resulting behavior change for read-only mounts.
> quotactl_fd() would then call mnt_want_write() for these commands, which
> returns -EROFS on a read-only mount.  So Q_XGETQUOTA on a read-only
> mounted filesystem (e.g. via xfs_quota) would change from working to
> failing with -EROFS.
> 
> Alternatively, I can keep them as read-only commands and only make both
> quotactl() and quotactl_fd() wait for the filesystem to thaw without
> taking write access, which keeps read-only mount queries working and
> only waits while the filesystem is frozen.

Yes, that would be possible as well but let's keep things simple and
complicate them only if somebody actually complains :). Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
