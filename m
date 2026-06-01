Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9603A2E2E
	for <linux-ext4@vger.kernel.org>; Mon,  1 Jun 2026 09:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307555; cv=none; b=SQHsbisu+DzPh28UmjkXQWn1w11kxinQGsKLgBw9PZyMe+V9SfU6ANaD9tcmQYl8Yd5U1+UOLTTF5/74MlLM90TYUbk5ZKm6olGuvmVF9I1SseLFfNT8OA5ubYVRjaBnTwBckVPsGni1htO7ZFlog/tOZ4O9Ta8II3fEaZ8mD7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307555; c=relaxed/simple;
	bh=GbH+3gui1gozOYcWfBKkNeYDATfBvIYM74/+kb9dEDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYjQJ4ZhkE9xbKX3TZzK1a1ykSMcXPsJ7YEz58OKwc6NHzyZyJFxET3QP5r6WBKPEeBmEQ31HD9imCmKqrQPrHyCuGI9E2cwqzCJkD6mPuiDYj5D5nNjKmGqMSOtIHyM7xbBgmkPtuy9/pVfiszxrEuX+iO6N0w1hpdyl+4Db3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=e4j5fkIh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OXtHlfw7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=e4j5fkIh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OXtHlfw7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="e4j5fkIh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OXtHlfw7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="e4j5fkIh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OXtHlfw7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 66C556B89D;
	Mon,  1 Jun 2026 09:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780307543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kACuJyVnOFQ03WjvWQPG6+N71Vy6k5l+8uIM48Wo09s=;
	b=e4j5fkIh0awm7ivEoHtanBzvYGukdQyHA0bOc4kx/P80L7a9oUxxjmGIBolHkWb5BBA5Yg
	tOM9eAoTVzKjwP8G5ei6CoY0JJu3T6e31cdWY4UNmrhtrG6ajbDj6ziA27ewF29nTVifnG
	eMKARAMWbt2IttwJ/mivRiv3mdufMpk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780307543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kACuJyVnOFQ03WjvWQPG6+N71Vy6k5l+8uIM48Wo09s=;
	b=OXtHlfw7TFURZ+hjWV21ug0Y7FdOvDYpkzem6E7Zzbb5eEFeRxpadiKYDmPltTdDAhIIO7
	x/ktGbmhYtmqdTCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780307543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kACuJyVnOFQ03WjvWQPG6+N71Vy6k5l+8uIM48Wo09s=;
	b=e4j5fkIh0awm7ivEoHtanBzvYGukdQyHA0bOc4kx/P80L7a9oUxxjmGIBolHkWb5BBA5Yg
	tOM9eAoTVzKjwP8G5ei6CoY0JJu3T6e31cdWY4UNmrhtrG6ajbDj6ziA27ewF29nTVifnG
	eMKARAMWbt2IttwJ/mivRiv3mdufMpk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780307543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kACuJyVnOFQ03WjvWQPG6+N71Vy6k5l+8uIM48Wo09s=;
	b=OXtHlfw7TFURZ+hjWV21ug0Y7FdOvDYpkzem6E7Zzbb5eEFeRxpadiKYDmPltTdDAhIIO7
	x/ktGbmhYtmqdTCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A5F7779A7;
	Mon,  1 Jun 2026 09:52:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z2MIFldWHWoxZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 01 Jun 2026 09:52:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F31DCA0EBE; Mon, 01 Jun 2026 11:52:22 +0200 (CEST)
Date: Mon, 1 Jun 2026 11:52:22 +0200
From: Jan Kara <jack@suse.cz>
To: Yifei Chu <yifeichu24@gmail.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ext4: delayed-free buddy load error reaches BUG_ON in
 ext4_process_freed_data
Message-ID: <hng6exlajpjxvbodftr4pb6ekjbcd3ktgo7qd72sqemcdtjkbv@ocynwilr5uvl>
References: <CAPJnbg+QS5z8D9kvjSukZDPnLLGv4P9jyUC3nx4enac75haecQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPJnbg+QS5z8D9kvjSukZDPnLLGv4P9jyUC3nx4enac75haecQ@mail.gmail.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

Hello!

On Sun 24-05-26 11:14:43, Yifei Chu wrote:
> Short version: I am reporting an ext4 delayed-free error-path bug found
> with targeted fault injection. The injected -EIO is in
> ext4_mb_load_buddy()’s normal error-return domain, and the injection is
> placed at the helper return boundary for the delayed-free caller. With that
> rare lower-layer failure made deterministic, ext4_free_data_in_buddy()
> reaches BUG_ON(err != 0) and crashes the kernel.

So how did you inject the EIO error? ext4_mb_load_buddy() returns EIO only
if the folio is not uptodate. Did you manage to hit non-uptodate folio when
ext4_mb_load_buddy() is called from ext4_free_data_in_buddy()? Checking the
code it actually might be possible as I don't see where the buddy folio
would be actually pinned in memory these days but I'd like to to verify...

								Honza

> 
> Tested kernel:
> 
> v7.1-rc4-640-g79bd2dded182
> 79bd2dded182b1d458b18e62684b7f82ffc682e5
> x86_64 QEMU, KASAN config
> 
> The relevant code shape in fs/ext4/mballoc.c is:
> 
> err = ext4_mb_load_buddy(sb, entry->efd_group, &e4b);
> /* we expect to find existing buddy because it’s pinned */
> BUG_ON(err != 0);
> 
> The point of the injection is not to corrupt ext4 state. It only makes a
> plausible buddy/bitmap load failure deterministic at this caller, so the
> caller’s error handling can be tested. ext4_mb_load_buddy() already has
> normal negative error returns from metadata loading paths.
> 
> Reproducer shape:
> 
>    1. Mount a fresh ext4 filesystem.
>    2. Create and fsync a 256 KiB file.
>    3. Unlink the file.
>    4. Call sync() to force delayed-free processing.
>    5. The instrumentation forces ext4_mb_load_buddy() to return -EIO at the
>    delayed-free callsite.
> 
> Two fresh image runs reproduced the same crash:
> 
> AGENT_INIT: unlink ret=0 errno=0 (Success)
> AGENT_INIT: calling sync to force delayed free processing
> EXT4-fs: AGENT_EXT4_FREE_DATA_BUDDY_BUGON: forcing ext4_mb_load_buddy EIO
> before BUG_ON
> kernel BUG at fs/ext4/mballoc.c:3990!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ext4_process_freed_data+0x1fe/0x510
> 
> I did a local duplicate sweep and found related older
> ext4_mb_load_buddy()/mballoc fixes, but I did not find a direct
> current-upstream fix for this delayed-free BUG_ON(err != 0) path.
> 
> Expected behavior:
> 
> A metadata load failure during delayed-free processing should go through
> ext4 error handling / transaction abort / filesystem error propagation,
> rather than treating the error as an impossible invariant and BUGing the
> kernel.
> 
> The attached tarball includes README.md, repro_init.c,
> instrumentation.patch, and both full serial logs.
> 
> Thanks,
> Chuyifei


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
