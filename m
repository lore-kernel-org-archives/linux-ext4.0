Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EE83EE1E0
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 09:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782896606; cv=none; b=ZXRwaxgF7uw9WCBPhoDmfouqbEuBKPXLCG0+k1jS2EP0d2ZGWdN+X56fw0bTfkQdDKnVUGe5rSJOucGkJAM8FUM31lHEY02QE07Ee50ys7u/FRzOKFFXQn4FuMM67UbMRuQuAaTcNphD24ypqHAAZAWDlPULJLqc8upkB0fzSx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782896606; c=relaxed/simple;
	bh=T+ZLu2pJHq4Eg0kji3n8UE63cq5O5IqOVtD0TiTa6XA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2qPlSSynn1LkgJ7F+TjqqeMWTuaVqZDR8SPCeNzyp5LrjsO1u1aw+oNVyavEVwZc9wvx7aRfyx6jalfa1c/WeoepdZf/T/TNeARfoEVOOw87nKUWdCiG5t/wJTk21uW+m3BQJSv2BqegnzweSp0C8xDo3yQJwqhPZbT/bo+h7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bEd73fdB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vqw9LN4S; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bEd73fdB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vqw9LN4S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bEd73fdB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vqw9LN4S";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bEd73fdB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vqw9LN4S"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 97CAD76048;
	Wed,  1 Jul 2026 09:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782896596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xg4EwvjtJRXEKwioiMSjB9Ekv3Y30Go08vyAMga2+0s=;
	b=bEd73fdB8Lp+YO+fL67voSrCkyWfuoY95z55i99bP1hAgyGyB/9pARTOP02sRGTG70g8FB
	4dbEx6D+D9PuyRZt45wlbHpKzaI+3JsDDoAFSjuZrVIhlWB6vyIKUQwVnS+v23ECCCBCat
	xhRKBia41Lt4zQkkTsO7/M4ddv//xXY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782896596;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xg4EwvjtJRXEKwioiMSjB9Ekv3Y30Go08vyAMga2+0s=;
	b=Vqw9LN4SoPKXHf55Tr872PiwhZLXghRiwqrT3vx9soU5B2J85tRmeQL70hAyNBAemHjqk1
	bSP7SOkk1uYvC7AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782896596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xg4EwvjtJRXEKwioiMSjB9Ekv3Y30Go08vyAMga2+0s=;
	b=bEd73fdB8Lp+YO+fL67voSrCkyWfuoY95z55i99bP1hAgyGyB/9pARTOP02sRGTG70g8FB
	4dbEx6D+D9PuyRZt45wlbHpKzaI+3JsDDoAFSjuZrVIhlWB6vyIKUQwVnS+v23ECCCBCat
	xhRKBia41Lt4zQkkTsO7/M4ddv//xXY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782896596;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xg4EwvjtJRXEKwioiMSjB9Ekv3Y30Go08vyAMga2+0s=;
	b=Vqw9LN4SoPKXHf55Tr872PiwhZLXghRiwqrT3vx9soU5B2J85tRmeQL70hAyNBAemHjqk1
	bSP7SOkk1uYvC7AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8CCC7779AA;
	Wed,  1 Jul 2026 09:03:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bshYItTXRGpyeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Jul 2026 09:03:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2804AA10B7; Wed, 01 Jul 2026 11:03:12 +0200 (CEST)
Date: Wed, 1 Jul 2026 11:03:12 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ext4: fix race conditions and clean up locking of
 inline data writes
Message-ID: <du3mel4k4hwnbbogufghauulvqrijx3bhgem2lfuss2nfgcoxv@6awcqkjsrsh6>
References: <20260630152812.1706-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630152812.1706-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[0c89d865531d053abb2d];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,taobao.com,syzkaller.appspotmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Tue 30-06-26 15:28:10, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> This patch series addresses the remaining race conditions and locking
> issues involved with inline data writes, implementing the clean
> state-communication design suggested by Jan Kara.
> 
> Previously, `ext4_write_end()`, `ext4_journalled_write_end()`, and
> `ext4_da_write_end()` checked the inode state and the inline data flag
> directly to decide whether to finish writing inline data or to fall
> back to block writes. This is highly susceptible to TOCTOU race
> conditions where concurrent memory-mapped page faults
> (`ext4_page_mkwrite()`) can convert the inline data to an extent
> between `write_begin` and `write_end`. Since block buffers were not
> allocated in the inline path during `write_begin`, such fallbacks
> resulted in kernel crashes and NULL pointer dereferences because
> `folio_buffers(folio)` was NULL.
> 
> The series cleans up and resolves these issues in two distinct steps:
> 
> 1) Patch 1 introduces state tracking via the standard `fsdata`
>    parameter. By marking whether a write was prepared as inline
>    (`EXT4_WRITE_DATA_INLINE`) directly in the private per-write
>    `fsdata` during `write_begin`, the corresponding `write_end`
>    handlers can reliably decide whether to call
>    `ext4_write_inline_data_end()` or complete a normal extent write.
>    This eliminates the race-prone checks on the live inode state and
>    gets rid of crude fallback/retry hacks.
> 
> 2) Patch 2 replaces a potential kernel panic
>    (`BUG_ON(!ext4_has_inline_data(inode))`) inside
>    `ext4_write_inline_data_end()` with a graceful retry error path.
>    If a concurrent conversion clears the inline flag right after the
>    `write_end` checks pass but before the xattr semaphore is acquired,
>    we gracefully release all held resources and return 0 (VFS retry) to
>    let the VFS safely retry the write from scratch.
> 
> The series compiles clean against the latest linux-next/ext4 tree.

This caught my eye: Do you actually do real testing of your patches? Like
using fstests / kvm-xfstests? Every patch author for ext4 is supposed to do
that before submitting his changes...

								Honza

> Aditya Prakash Srivastava (2):
>   ext4: use fsdata to track inline data write state
>   ext4: replace BUG_ON with graceful retry in ext4_write_inline_data_end
> 
>  fs/ext4/ext4.h   |  1 +
>  fs/ext4/inline.c | 14 +++++++++++++-
>  fs/ext4/inode.c  | 22 +++++++++++++---------
>  3 files changed, 27 insertions(+), 10 deletions(-)
> 
> -- 
> 2.47.3
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
