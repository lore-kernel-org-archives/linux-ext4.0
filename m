Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3E3D6CC6
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 13:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785246339; cv=none; b=ZbV6uPfTrOwF4ptoPXDw0NQdfEgLoeHf6AKU0e75ENUrS2vctD2gDIJ+m2AN1jx1Vq4Ax+sp1u92AGyJwxzH5SDkLbKBrpTNR4l5vkeTVgwGd8ZMFeo3DrtRGzrSJJ2St92ngXuWuL05GhJjww+yeQUnWEa/dUaPttHFjyPf9/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785246339; c=relaxed/simple;
	bh=y2GWOmjjcRyLUkaNlXkPVU84+DEHJyH0LedydsHyDP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LX5COM4nWaGd5Eco+e4v2WZH3uAFVWCait46Cm0bJ43Dl6LREOcJFQjRjMk6XUWOTjgYVmrRfQDDNzaCcmaYImAELy/CpSS4aUCYLYGfjL8fQe1Xzp2ZwxGRSPBn73BEw0gkGS+WzgokGwI+sWxNsmnrbczGDo/wf1H8yXVny4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=n2v2+66c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=P8wmBOYf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iVxNkf0N; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8SIW/H2k; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="n2v2+66c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="P8wmBOYf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iVxNkf0N";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8SIW/H2k"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91E273E94;
	Tue, 28 Jul 2026 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785246330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AOKGR9Pwfp1q/yUfZvSH7BPWoDgznn7E79eZ29H99Hs=;
	b=n2v2+66cPuGyGXzuHyCSONhs/qZHh4dDy+W0XPjdTaTdiRRgQrx2RpNUZdV8wXedpR5UTa
	IDm4MnvAsaqMjsA+hoW4ri5XTTBcXGbKxRUhurhJ0942b0JDkfzpo0c+pYziY61RnBfT1S
	3nSfQaDd4UNuMlQyuTuHhi2lPZ7DM4c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785246330;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AOKGR9Pwfp1q/yUfZvSH7BPWoDgznn7E79eZ29H99Hs=;
	b=P8wmBOYfItxomBgA6F316BsAgGyFonj1ltJ3rhdOQvpvJsrGPtO/YbTZch/tjUVBpzxw9P
	dSwLOKpgnz3lqRDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785246326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AOKGR9Pwfp1q/yUfZvSH7BPWoDgznn7E79eZ29H99Hs=;
	b=iVxNkf0Ns7z4IIcXwZg1YjUYgSs/8NVX2r87w4qFnR5WNiqAf0aP5ofWQYl59F6moTOmAu
	MJEiRn8ZCUGOK58fwxdFtT1qECnHq7a1BkBjJUvuUZtZhGrmXbiu6xjXTieXnRKrc/BIKx
	Gges7qB8HTT4mkisnV7PVCQYQaP6MSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785246326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AOKGR9Pwfp1q/yUfZvSH7BPWoDgznn7E79eZ29H99Hs=;
	b=8SIW/H2k2E9Dd/3Abmpz21J1dy2MOghpD6w5ednUTSlz+fR98i4ssOuclT6oXy1l+1QSma
	VkWmt95p9Vy/9XCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86118779B9;
	Tue, 28 Jul 2026 13:45:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z2q2IHayaGrWaQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 13:45:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2965AA10B6; Tue, 28 Jul 2026 15:45:18 +0200 (CEST)
Date: Tue, 28 Jul 2026 15:45:18 +0200
From: Jan Kara <jack@suse.cz>
To: Luyao Bai <bailuyao1997@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: do not WARN when starting a journal on a frozen
 filesystem
Message-ID: <sriy2l6shuzesc364p5pg3ixlziimtlduag2fm63q7ajxcietf@pttahezzea3g>
References: <20260723205036.661832-1-bailuyao1997@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723205036.661832-1-bailuyao1997@gmail.com>
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
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,syzkaller.appspot.com:url,appspotmail.com:email]

On Thu 23-07-26 20:50:36, Luyao Bai wrote:
> A WARNING is triggered in ext4_journal_check_start() when a background
> writeback thread attempts to start a journal transaction while the
> filesystem is in the SB_FREEZE_COMPLETE state:
> 
>   WARNING: CPU: 1 PID: 2903 at fs/ext4/ext4_jbd2.c:76
>            ext4_journal_check_start+0x1f8/0x250
>   Call Trace:
>    __ext4_journal_start_sb+0x181/0x600 fs/ext4/ext4_jbd2.c:105
>    __ext4_journal_start fs/ext4/ext4_jbd2.h:326 [inline]
>    ext4_do_writepages+0x112c/0x3d20 fs/ext4/inode.c:2707
>    ext4_writepages+0x213/0x3c0 fs/ext4/inode.c:2813
>    do_writepages+0x35f/0x870 mm/page-writeback.c:2683
>    __writeback_single_inode+0x14f/0x10d0 fs/fs-writeback.c:1658
>    writeback_sb_inodes+0x80c/0x1370 fs/fs-writeback.c:1954
>    wb_writeback+0x41b/0xbd0 fs/fs-writeback.c:2134
>    wb_workfn+0x410/0x1090 fs/fs-writeback.c:2321

How this patch is broken has been already explained by others. Let me just
add that usually bugs like these are caused by stale PAGECACHE_TAG_DIRTY
tags in the xarray (so tags are still there but folios aren't really dirty
anymore so writeback wouldn't do anything in the end). We had several fixes
for those lately. So that's the direction you might want to explore and I
also suggest verifying whether the problem still reproduces with current
Ted's tree because it might well be it got already fixed.

								Honza


> 
> The background writeback flusher does not take freeze protection, so it
> can legitimately reach ext4_do_writepages() and try to start a journal
> handle while the filesystem is frozen. This happens, for example, when
> ext4_writepages() failed earlier (e.g. -ENOSPC or -EDQUOT) during the
> sync_filesystem() phase of the freeze: sync_filesystem() can still
> return 0, the freeze completes, but dirty pages are left behind. A later
> writeback pass then tries to write them out on the now-frozen
> filesystem.
> 
> The same state is reachable through the EXT4_IOC_SHUTDOWN path: if
> fs_bdev_freeze() succeeds in freezing the superblock but the subsequent
> sync_blockdev() fails, the filesystem is left in SB_FREEZE_COMPLETE and
> dirty pages remain, so writeback eventually retries and trips the WARN.
> 
> Because this state can be reached without any kernel bug, WARN_ON() is
> the wrong tool here: WARN_ON() must only fire on conditions that should
> never happen. Replace it with an ext4_msg() error message and return
> -EROFS, rejecting the transaction cleanly. All callers of
> __ext4_journal_start_sb() already handle an error return (it is the same
> path used for the existing is_journal_aborted() -EROFS case), so the
> dirty pages are simply kept and written back once the filesystem is
> thawed.
> 
> This patch is intentionally limited to the ext4 journal-start check,
> which is the direct cause of the reported warning. Any improvements to
> the generic VFS freeze/thaw error handling in fs/super.c are a separate
> concern and are deliberately left out of this fix.
> 
> Reported-by: syzbot+b75d75f957975f3d40e3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b75d75f957975f3d40e3
> Fixes: 49ef8832fb1a ("bdev: implement freeze and thaw holder operations")
> Signed-off-by: Luyao Bai <bailuyao1997@gmail.com>
> ---
> Tested with the syzbot reproducer under QEMU: the WARNING at
> fs/ext4/ext4_jbd2.c fires on a clean mainline build and no longer fires
> with this patch applied.
> 
>  fs/ext4/ext4_jbd2.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 9a8c225f2..1756039b1 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -75,7 +75,12 @@ static int ext4_journal_check_start(struct super_block *sb)
>  	if (WARN_ON_ONCE(sb_rdonly(sb)))
>  		return -EROFS;
> 
> -	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
> +	if (unlikely(sb->s_writers.frozen == SB_FREEZE_COMPLETE)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Attempt to start a journal transaction on a frozen filesystem");
> +		return -EROFS;
> +	}
> +
>  	journal = EXT4_SB(sb)->s_journal;
>  	/*
>  	 * Special case here: if the journal has aborted behind our
> --
> 2.43.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
