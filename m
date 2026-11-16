Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833326;
	b=hkgShAa/XCp8yM0g34Lq8sOQPvVvaF06P6qx/jprZu6dYV1rWBysdOd5xRR8mXdpNSC8
	 akM+LK62Tgvi2pqexGtdFpaglcCde911QPFFASCYN/s0z9R+2NS2ZJLhDXNcob4sOejJu
	 /oikNuWDVwT+aWx1X0vAdVJc5WIKfWV1hUwSBle2uQIRyqTWhamjKl7t4PBE3nbDfFFPa
	 DWW8KxEpPhQiYe9bzZL2jt9Eqi1PwhUoHkTCbAPUQCUc6cKfJXq6GTFw1WghaOBLk46qB
	 GP1xo8f8wavD4HrDsUiImpER/GVk22imDJHKL+Cp+N84egNPUx46MGzLjPPs9VKzcmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833326;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=muCsOHPgshNynmm1OLGJYfu6W2sds6nitTgZ+7QRuR4=;
	b=HhQlsZDDaUFD6hhoQH1jOj2Zdh+3yoyJhBJuQ/NWILETV1gS0ddIPg1mf7fJgieCrm56
	 m/a7T9mGv0qkTd5kb/S/rOgd7mXM8FtTlPo9jKniS9lA5cUmOQrjFtxSOnv0rQhf6nK0o
	 fMiFr8gyGagwmDbP7o4nmQUrsP0kuSkyZ7dHo+HR3p0YnXmJEBKPS3ZFkT04oyLnebZeT
	 vpZJqXE7TfYDMlfq+mWoDDMKeq0TTNpe9BoHr0iC7phaJENOlQ0e1gTsr8VroT6io+FDO
	 BWnyg17+uiK9+IFml73zIs1Vohy6vf6QprduBsl3U1U1wvKPU3lzZEynxw+4CGbPxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=apNPIfb6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="hgy7725/";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nt0QvDaP;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7VcVi+gM;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FD1606A323;
	Mon, 16 Nov 2026 12:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70FD1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=apNPIfb6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hgy7725/;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nt0QvDaP;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7VcVi+gM
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11C6321DFE;
	Mon, 16 Nov 2026 12:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794833322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muCsOHPgshNynmm1OLGJYfu6W2sds6nitTgZ+7QRuR4=;
	b=apNPIfb66Va+LbqfktNNcArsxTUjia89+nO/IYZNRhXcjercHexCX3wF4Z8dKN3pqHUWXw
	L8XtP+arAXjuvXYmHKIHMNxyrxiLIKpgqpPRW43i2eU+SotAKPYJypRJomsqbemy0vTZAS
	Hv5ktoWrb0nHq9ByOZWrmFQlGG0giAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794833322;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muCsOHPgshNynmm1OLGJYfu6W2sds6nitTgZ+7QRuR4=;
	b=hgy7725/CWunCK/JEauo/zXGDcWesrJSLGsgx8IbV256dgQKX8nLgj9HtxsxCoYHbySmCr
	g/f6wLVdLgAz24DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nt0QvDaP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7VcVi+gM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794833321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muCsOHPgshNynmm1OLGJYfu6W2sds6nitTgZ+7QRuR4=;
	b=nt0QvDaPvJcwKrIUlO6ggIpwTTPxr7Opu0/elsnR9U7gJ2OhcxPILAhFrD+jIqgMuNjfBd
	6ceNeSJ+9aEcxACrXMJuTjke+t97jBfJ5NE2xFo5amxT/vejhq5liqc5KHoxP4ZMyjGRtX
	egZvl51K1P2dH4q3arSwDHbTyziMFDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794833321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=muCsOHPgshNynmm1OLGJYfu6W2sds6nitTgZ+7QRuR4=;
	b=7VcVi+gMZSY9k49upLnc8L9D7Wb05qnPsarEcKvnSzv4bSm3BHTTQG+GWLklbkASkHzUs8
	8BoUPh2o6xtHvVAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD98E1334C;
	Mon, 16 Nov 2026 12:48:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aZdtLaj7+mpOfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 12:48:40 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7044024DF8; Mon, 16 Nov 2026 13:48:36 +0100 (CET)
Date: Mon, 16 Nov 2026 13:48:36 +0100
From: Jan Kara <jack@suse.cz>
To: Alan <3164729207@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, harshadshirwadkar@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: reserve inode write access before unlinking entry
Message-ID: <otvuclstcoaysrnywzdttapxbxg7hq3p7lp3iexy7u5cuj6plx@waqfsi2dg2p4>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
 <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
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
In-Reply-To: <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[qq.com];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 11C6321DFE


Hi!

On Mon 16-11-26 15:35:19, Alan wrote:
> Hi Ted, Jan and ext4 reviewers,
> 
> A gentle ping on this patch from October 27. Are there any comments on the
> approach?

So for me it is unclear whether this needs addressing at all. Because
realistically the only reason why getting write access to inode bh can fail
is due to aborted journal in which case no transaction will get committed
anyway. So this looks mostly like a problem specific to this error
injection testing...

								Honza


> 
> I have additional validation from November 2 using QEMU blkdebug to fail an
> actual guest block READ. These results supplement the source-derived fault
> injection described in the original mail.
> 
> On the unpatched Linux 6.12.1 test kernel, with errors=continue, the failed
> read was at sector 2312, in the parent inode-table block (block 289, parent
> inode 13). The kernel reported:
> 
>   I/O error, dev vda, sector 2312 op 0x0:(READ)
>   ext4_get_inode_loc:4554: inode #13: block 289: unable to read itable block
>   __ext4_unlink:3469: inode #13: mark_inode_dirty error
> 
> unlink returned EIO. After normal unmount, /p/file was absent, but raw
> inode 2064 still had Links: 1. e2fsck -fn reported:
> 
>   Unattached inode 2064
> 
> In this case the inode-table read fails in ext4_get_inode_loc(), before the
> journal write-access call. A separate run of the same block-read failure
> traced JBD2 through unlink, sync and normal unmount:
> 
>   jbd2_journal_abort() probe hits: 0
>   unlink handle at jbd2_journal_stop(): TID 7, T_RUNNING
>   h_err=0, h_aborted=0, j_errno=0, journal JBD2_ABORT flag clear
>   jbd2_journal_stop() return value: 0
>   jbd2_start_commit: transaction 7
>   jbd2_end_commit: transaction 7
> 
> The offline filesystem check still reported the unattached inode. This
> demonstrates that this read-error path can commit the directory change
> without a journal abort when mounted with errors=continue.
> 
> With the fix, the same clean input and block-read error failed before the
> directory entry was removed. After normal unmount, /p/file remained present,
> inode 2064 still had Links: 1, and e2fsck -fn completed without diagnostics.
> 
> Thanks,
> Alan
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
