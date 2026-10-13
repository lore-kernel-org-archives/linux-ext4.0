Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BDE1A0B0E;
	Tue, 13 Oct 2026 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896871; cv=none; b=CTEJOToc/0AOpCb6lFdghpMyW0LV4qfoGn8SNak31dnA5zIQRtfloArwM+p9tHqbmOoORmNnJyScZc+mwlmtEP2XFpDRTbkbORSmqD83Qj6AvDV13LFSQGGc+wC76J34ZgFHesga3v11ULSxR3xOwdd3edfPE10s/ihCNdI5t7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896871; c=relaxed/simple;
	bh=ove0/nJXFIcTyLu4qLUQBXb/WzrHy+edswF6NwYK26Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMXXIuWNoiocVLyLAzvD6ELDcb91YoeJy7J5CoTWqSyf0K58BeINr4qYxYP5lmxxVN0SzAsdtZC6sz8uIEck/verMeI9fkuHoyQBHD3v5Gm7VhGQFF7/WHj/2rOOChKjGswu74FKLXL/7VSP6cGONHZAJrXTxqUIqoApOEG9JyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kxzy/1OP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4VEQhFWf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kxzy/1OP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4VEQhFWf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kxzy/1OP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4VEQhFWf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kxzy/1OP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4VEQhFWf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D6981F443;
	Tue, 13 Oct 2026 13:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791896868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4knovqdvVC+Nqda8FHrje2s3FsDBoKFv+b9WLy512J8=;
	b=kxzy/1OPuD98qwnboQgb4RvgSXDtrK11AcbKYggM3YmnxutyYoZUaN903OSKTf7qM3Vn61
	NGzkePD6lm7/ykaWYAJBqM6BP0/t50gtpZt00G+UVqtgtUA4mspATTy4xWK07x5xK6FbHb
	16rNSPp6am+v4rDzFkkfJjzN0hlMJsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791896868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4knovqdvVC+Nqda8FHrje2s3FsDBoKFv+b9WLy512J8=;
	b=4VEQhFWfgic286H/Dcalu5YN1VAhd0Is6UpgVmZhYtiHfqdxZ/zFZpm1jMydX1ysibSXpb
	hqj1a8BKwdUSfGCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791896868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4knovqdvVC+Nqda8FHrje2s3FsDBoKFv+b9WLy512J8=;
	b=kxzy/1OPuD98qwnboQgb4RvgSXDtrK11AcbKYggM3YmnxutyYoZUaN903OSKTf7qM3Vn61
	NGzkePD6lm7/ykaWYAJBqM6BP0/t50gtpZt00G+UVqtgtUA4mspATTy4xWK07x5xK6FbHb
	16rNSPp6am+v4rDzFkkfJjzN0hlMJsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791896868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4knovqdvVC+Nqda8FHrje2s3FsDBoKFv+b9WLy512J8=;
	b=4VEQhFWfgic286H/Dcalu5YN1VAhd0Is6UpgVmZhYtiHfqdxZ/zFZpm1jMydX1ysibSXpb
	hqj1a8BKwdUSfGCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34C06134B8;
	Tue, 13 Oct 2026 13:07:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id loOMBCQtzmq+WwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Oct 2026 13:07:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B760FA1407; Tue, 13 Oct 2026 15:07:43 +0200 (CEST)
Date: Tue, 13 Oct 2026 15:07:43 +0200
From: Jan Kara <jack@suse.cz>
To: yangguikun <yangguikun19@qq.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] ext4: mount-time orphan recovery silently truncates
 a LIVE file (crafted s_last_orphan; only log line is the routine "1 truncate
 cleaned up")
Message-ID: <ipfpx7fmpmare3lyl52har6up6lqpi7irziiqwiflra5nigy7i@4lhj4asb76hh>
References: <tencent_30C554296ACA4722AA33D5E81B7C24CF6905@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_30C554296ACA4722AA33D5E81B7C24CF6905@qq.com>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[qq.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

Hi!

On Tue 13-10-26 19:51:51, yangguikun wrote:
> During field-semantic corruption testing of ext4 images, we found that the
> mount-time orphan recovery path truncates a fully-live, linked file when
> four individually-plausible on-disk fields are made mutually inconsistent —
> and the only kernel log line is the routine recovery message, making the
> destruction indistinguishable from legitimate crash recovery. Deterministic
> reproducer below (e2fsprogs + one mount; no syscalls needed after mount).
> 
> ## The corruption
> 
> Four coordinated edits on a stock 1MB ext4 (mke2fs -O ^has_journal,^metadata_csum,
> three 8KB files; /file1 is a normal live file, nlink=1, has a dirent):
> 
>     1. s_last_orphan (sb+0xE8) := /file1's inode number
>     2. /file1 i_dtime := 0
>     3. s_state: clear EXT4_VALID_FS
>     4. /file1 i_size := 4096   (real data: 8192)
> 
...
> ## Why we think this is worth a look beyond "corrupt fs"
> 
> - The damage is cross-file and kernel-initiated: one superblock u32 selects
>   ANY inode on the filesystem for data destruction at mount, with zero
>   syscalls from the (unprivileged-after-mount) point of view.
> - It is silent: the only log line ("N truncate cleaned up") is exactly what
>   legitimate recovery prints. An operator mounting a suspect image gets no
>   signal that a live file was destroyed.
> - The comment's "Having the inode bit set should be a 100% indicator that
>   this is a valid orphan" holds only if the inode bitmap is trustworthy;
>   with a crafted image both the bitmap bit and the chain head are
>   attacker-chosen, and the no-nlink-check design decision becomes the
>   amplification point.

I'm sorry but all I can read here is: "When you corrupt a filesystem, you can
silently loose data" which isn't really surprising and I don't really care
much.

> We appreciate the truncate-in-flight orphan use case that motivates
> skipping the nlink check, so a full "must be unlinked" rule is not the
> answer. Two directions that might be cheap enough:
> 
>   a) warn loudly (ext4_warning with inode number and old/new size) whenever
>      orphan cleanup truncates an inode with i_nlink > 0 — turning the
>      silent destruction into an observable event, or

No. Trucation of inode with i_nlink > 0 is a perfectly valid event so
warning about it wrong.

>   b) recording the truncated inodes (e.g. rate-limited per-mount summary
>      "orphan cleanup truncated N linked inodes") so post-mount forensics
>      can distinguish this from normal recovery.

But this is already reported. There's:

	 ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
                         nr_truncates, str_plural(nr_truncates));

so I'm not sure what else you're asking for...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
