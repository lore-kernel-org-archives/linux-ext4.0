Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCB8415B90;
	Thu, 20 Aug 2026 11:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224136; cv=none; b=oFAFacSwCQ5CcndOj3MGAgX3xKGp3o6UtfBWTWqUcydlDbbEhQOxWfZQU2GFD8nKWqrNODxp7VkNqBR9qZ3vAChSoFTukjrzHP4/O8r06cOkZbHqJknL+y11QMDIirIheT0GtWBW1LzEPbsZPvMwfxPngaltJWvOFAEXfI8/cac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224136; c=relaxed/simple;
	bh=bPRBdUpzIm2s1eAZpnihewwZArgWvnaE23s61UeiAKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3SA/m6xHh+CduX/Vjt9N/YEwApyBcoYQg5eK+yWU3pvILgyh4T7UOXZUdMUwrXTlZzqfXU2wP3LTqEsMPRfrLlPJdgymwuEdYpPalmOjC6tptvJTh9voacnUPY766CDtmgzyLD8gNyQ1mrF7ilQeu9gVwelFqV8ZXCiIF304oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RwCMhpQc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JBB7nnB2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TGSfZHWb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=udR+D2Ql; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RwCMhpQc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JBB7nnB2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TGSfZHWb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="udR+D2Ql"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A66113EB1;
	Thu, 20 Aug 2026 11:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787224126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yfQe8qCXafeY/v3YQtv2qR39nOFKrbAjyfJEMwLvSHk=;
	b=RwCMhpQch0YgPVp+fkRqEXyfyXYlXPTo7fBi3KU87LWiDNEet9on4dwPVhyE8DqmyC/Nog
	/AeJQbAU2QL3/SxzNuFRT7T5LR7BZxn4mfk+b+2nKcszHJARw72KP0hD6oes1R41yv3/Mt
	ROq7rtcn1eT8jzY8K8HLuZeMggPvexg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787224126;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yfQe8qCXafeY/v3YQtv2qR39nOFKrbAjyfJEMwLvSHk=;
	b=JBB7nnB2gmADZ4VQGLnJ48PwBjk8zljIBN4fUS2kWP/sGcWY9ZW+i0i0xzKKdhiqMEK/RD
	MkooGfHRinbX2iBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787224122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yfQe8qCXafeY/v3YQtv2qR39nOFKrbAjyfJEMwLvSHk=;
	b=TGSfZHWb6ZRWXR/ugBXOuWxbLo2bgMXWvcSZhadFTWB6E/lUvI6uQfp6+k7L9ANTqT3MtS
	NGLF4tBKKD6JDtM1h/pI5dr2IvFVsEWuBQlWQns41j6ffDoHfIo4oNg2hIm+1KQzQ7oVxM
	w06iLY/jeZb4kF8ALw8eQIy09NmsuZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787224122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yfQe8qCXafeY/v3YQtv2qR39nOFKrbAjyfJEMwLvSHk=;
	b=udR+D2Ql+bvdaFqThhtHHnAqALxty00d0n5Oyxyod7br+0E98Ri/i/ueXe7E6hcC93DvPE
	G81BTJhxvAtPGNDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C8CB27A8;
	Thu, 20 Aug 2026 11:08:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TK8yJjrghmrBJwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 20 Aug 2026 11:08:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3BC9AA13B9; Thu, 20 Aug 2026 13:08:42 +0200 (CEST)
Date: Thu, 20 Aug 2026 13:08:42 +0200
From: Jan Kara <jack@suse.cz>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix discard work use-after-free on failed mount
Message-ID: <ao3hudzjy2ljujygifsf7bcbffnfhp4uhxln3qkzdbszih3mjf@cqcopsdlkpnw>
References: <20260820052102.4616-1-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820052102.4616-1-fanwu01@zju.edu.cn>
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
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

Hello!

On Thu 20-08-26 05:21:02, Fan Wu wrote:
> ext4_put_super() destroys the journal before it calls
> ext4_mb_release(), but the failure unwind of __ext4_fill_super() runs
> the two steps in the opposite order: failed_mount6 calls
> ext4_mb_release(), and the journal is destroyed only later, just above
> failed_mount3a.
> 
> ext4_mb_release() flushes sbi->s_discard_work before releasing the
> mballoc structures, a drain made unconditional in commit 9ee29d20aab2
> ("ext4: always drain queued discard work in ext4_mb_release()").  With
> -o discard, the journal destroy that runs afterwards re-arms that work
> after the flush: ext4_journal_destroy() calls ext4_force_commit(), and
> the commit callback, registered once mballoc is initialized, queues
> s_discard_work whenever the discard option is set, even with an empty
> freed-data list.  A quota-enabled mount reaches this with a live
> transaction (ext4_enable_quotas() failing into failed_mount8,
> ext4_quotas_off() on the failed_mount9 path), so the final force
> commit is not a no-op.

Yes, I think orphan replay is the easiest way how to have running
transaction in the journal in this shutdown path.

> Nothing drains s_discard_work after that point: failed_mount3 flushes
> only s_sb_upd_work and the s_err_report timer, and ext4_fill_super()
> then frees sbi with a plain kfree() through ext4_free_sbi().  If the
> system_dfl_wq worker is delayed across the rest of the unwind,
> ext4_discard_work() then accesses the freed sbi, first through
> sbi->s_sb and then while taking sbi->s_md_lock.
> 
> This is the pattern fixed for the s_err_report timer in commit
> 0ce160c5bdb6 ("ext4: fix timer use-after-free on failed mount"):
> async state armed after the unwind's last drain point.
> 
> Destroy the journal at failed_mount6, before ext4_mb_release().  This
> restores the ext4_put_super() order, so the final commit re-arms
> s_discard_work before the flush_work() in ext4_mb_release() drains
> it.  The journal destroy further down the unwind still covers paths
> that enter below failed_mount6; on the failed_mount6..failed_mount9
> paths it does nothing, because ext4_journal_destroy() clears
> sbi->s_journal.
> 
> This issue was found by an in-house static analysis tool.
> 
> Fixes: 55cdd0af2bc5 ("ext4: get discard out of jbd2 commit kthread contex")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6
> Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>

Thanks for the analysis and the patch. I agree the problem exists and your
patch fixes it but I just don't like the solution. Firstly, it looks very
suspicious both failed_mount6 and failed_mount4 labels would be shutting
down the journal. It makes me even more nervous that only failed_mount4a
does:
        dput(sb->s_root);
        sb->s_root = NULL;

which drops the root directory inode reference and with your change you'd
already have shutdown journal by that time which could cause problems in
some corner cases. Normal fs unmount path drops sb->s_root reference even
before calling ext4_put_super() BTW...

So to summarize I don't think we should really shutdown the journal
earlier. I think failed_mount6 should just force the commit to flush out
the running transaction before mballoc will be shut down and
ext4_mb_release() can also use disable_work() after flush_work() to make
sure no new s_discard_work can be queued as a safety measure.

								Honza

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4b6112e5d6c5..58b210637b57 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5761,6 +5761,12 @@ failed_mount8: __maybe_unused
>  failed_mount7:
>  	ext4_unregister_li_request(sb);
>  failed_mount6:
> +	/*
> +	 * The last commit can re-arm s_discard_work, so destroy the
> +	 * journal before ext4_mb_release() flushes it.
> +	 */
> +	if (sbi->s_journal)
> +		ext4_journal_destroy(sbi, sbi->s_journal);
>  	ext4_mb_release(sb);
>  	ext4_flex_groups_free(sbi);
>  failed_mount5:
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
