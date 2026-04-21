Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEBB3C063F
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 12:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776774339; cv=none; b=UIc76OXySkbDTo1Vbe6A3e9eas5pbNNsMU5EqJHQvcKxkK8qPMTHl4gEKxaSQTfOVxa6bGmdPJ0basV3lH2rBVAfeyrP5fyqZvelqJOMM+gy/ovrULkVjtbHg6K5z0JTwbozuCtbIGXwS348ZwbD5yduhZogXJ6aavAtyWeSMxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776774339; c=relaxed/simple;
	bh=XysvBkBsxxFQxTjEggRALD/CKaaaN+T4er34rrF+EJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDaibtjP2uuIxUfQ9me8fFsQtTqV3q6tlgrZh+5iKufBJiCN1kbvSQUICAqzGjzXlDOdfvFW/tYa2HLmUH3crk5tQ9p94CJhanulGiVcvnFoPCJjjlZE4CZctZ3cmX8hRNJSkPXaGGZx4Om0XmZvJioIDV6ZI/2Oz2yUB14vUsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ICwAs1RO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2BozlI3b; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ICwAs1RO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2BozlI3b; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ICwAs1RO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2BozlI3b";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ICwAs1RO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2BozlI3b"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 269DB6A856;
	Tue, 21 Apr 2026 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776774331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnTObJQ3M08mEhrU6Ht3/kG9xKtkrC3clDCUBkUf4xU=;
	b=ICwAs1ROUu/CR0KkVtu/B5va2PiBrLL/PykJwNtByhlJvmBNZeiehYIH5w9MmJ/iMYL/8D
	s+dFOH1u8Pis7sDiCiBqT29RsdBj05jIOprCAwAz+AJ8TNw54dqVTDF2GW4c0sXyjQHYnq
	46Dx8ZZc7PHE5qii6E4lK+94E2yUVCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776774331;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnTObJQ3M08mEhrU6Ht3/kG9xKtkrC3clDCUBkUf4xU=;
	b=2BozlI3b1JNpPoXF3NX2CJJON0eF6Snv8SYdYcFUeaskVle0F51YiSylgflm1spnqcgNpO
	JCkymuDnaNYJhyDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776774331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnTObJQ3M08mEhrU6Ht3/kG9xKtkrC3clDCUBkUf4xU=;
	b=ICwAs1ROUu/CR0KkVtu/B5va2PiBrLL/PykJwNtByhlJvmBNZeiehYIH5w9MmJ/iMYL/8D
	s+dFOH1u8Pis7sDiCiBqT29RsdBj05jIOprCAwAz+AJ8TNw54dqVTDF2GW4c0sXyjQHYnq
	46Dx8ZZc7PHE5qii6E4lK+94E2yUVCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776774331;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XnTObJQ3M08mEhrU6Ht3/kG9xKtkrC3clDCUBkUf4xU=;
	b=2BozlI3b1JNpPoXF3NX2CJJON0eF6Snv8SYdYcFUeaskVle0F51YiSylgflm1spnqcgNpO
	JCkymuDnaNYJhyDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEC5B593AF;
	Tue, 21 Apr 2026 12:25:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jqSlKrps52l1TwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Apr 2026 12:25:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 68526A0AE1; Tue, 21 Apr 2026 14:25:26 +0200 (CEST)
Date: Tue, 21 Apr 2026 14:25:26 +0200
From: Jan Kara <jack@suse.cz>
To: Zw Tang <shicenci@gmail.com>
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [BUG] ext4: BUG_ON in ext4_write_inline_data
 (fs/ext4/inline.c:240)
Message-ID: <fujyjsmjnuoof3hssnbyunbgykqi45wgdvqwbs6nmjat4fjdfy@ufip4zz7aodw>
References: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

Hello!

On Tue 21-04-26 19:32:43, Zw Tang wrote:
> I am reporting a kernel BUG in ext4 triggered by a syzkaller reproducer on
> Linux 7.0.0-08391-g1d51b370a0f8.

Sorry but we don't generally debug fuzzer issues not being reported by
syzbot. It provides much better tracking, deduplication and general
handling of issues which significantly speeds up debugging. If you have
some interesting modification of syzkaller, please contribute it upstream
so that everybody can benefit.
								Honza

> 
> The first fatal issue happens in the ext4 inline data write path:
> sendfile64 -> ext4_file_write_iter -> ext4_da_write_end ->
> ext4_write_inline_data_end -> ext4_write_inline_data.
> 
> The crash is reported as:
> 
> kernel BUG at fs/ext4/inline.c:240
> 
> and RIP points to:
> 
> ext4_write_inline_data+0x3d0/0x490
> 
> This looks like an ext4 inline-data boundary/state inconsistency triggered
> while writing to an ext4 image crafted by syzkaller. The later
> KASAN: slab-use-after-free in rwsem_down_write_slowpath() appears to be a
> secondary effect after the primary ext4 BUG, likely during teardown/unlink
> after the filesystem failure.
> 
> Reproducer:
> C reproducer: pastebin.com/raw/3LmK5Kxg
> console output: pastebin.com/raw/C0XjNMXp
> kernel config: pastebin.com/raw/aq1V3cLk
> 
> Kernel:
> HEAD commit:
> git tree: <e.g. torvalds/linux>
> kernel version: 7.0.0-08391-g1d51b370a0f8 #1 PREEMPT(lazy) (QEMU)
> 
> Relevant log:
> 
> [ 1329.147750] kernel BUG at fs/ext4/inline.c:240!
> [ 1329.148692] Oops: invalid opcode: 0000 [#1] SMP KASAN
> [ 1329.149543] CPU: 0 UID: 0 PID: 334 Comm: repro1 Tainted: G W
> 7.0.0-08391-g1d51b370a0f8 #1 PREEMPT(lazy)
> [ 1329.153249] RIP: 0010+0x3d0/0x490
> [ 1329.167978] ext4_write_inline_data_end+0x293/0xc90
> [ 1329.170566] ext4_da_write_end+0x521/0xec0
> [ 1329.176842] ext4_buffered_write_iter+0x11a/0x430
> [ 1329.177610] ext4_file_write_iter+0x561/0x1840
> [ 1329.185052] iter_file_splice_write+0xa33/0x11c0
> [ 1329.190820] direct_splice_actor+0x18f/0x7a0
> [ 1329.198893] do_splice_direct+0x41/0x50
> [ 1329.200276] do_sendfile+0xa86/0xda0
> [ 1329.203110] __x64_sys_sendfile64+0x1cf/0x210
> 
> There is also an ext4 metadata inconsistency message right after the BUG:
> 
> [ 1329.221770] EXT4-fs error (device loop1):
> ext4_mb_generate_buddy:1314: group 0, block bitmap and bg descriptor
> inconsistent: 25 vs 150994969 free clusters
> 
> and later a secondary report:
> 
> [ 1329.274881] BUG: KASAN: slab-use-after-free in
> rwsem_down_write_slowpath+0x15e9/0x1640
> 
> Based on the log, I believe the primary issue to investigate is the BUG in
> fs/ext4/inline.c, while the later rwsem report is probably fallout after
> the ext4 failure.
> 
> Please let me know if more information is needed.
> 
> Thanks.
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
