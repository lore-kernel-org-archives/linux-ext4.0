Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB984D90A8
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 17:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784050066; cv=none; b=duUsBvwkZw8+3AMOZnbzRF4Qa15SBUpj3r5r5VkWvVVQAXS/zNU6WyNHrna4hQgGKOJ5Ts0aLCJuuSzhJr57iyj3PdWBksXnVC/y5dLE626Ic0PDIE/ggP1yQ6PmYe/v/byCUDau34F7qFsexji9FZK6pFtDalTl+S1Jwso5eP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784050066; c=relaxed/simple;
	bh=ztCQCR/3v7dEitzxg2feBsBk9WnhKd6I5rs7wgxPIdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEYrB3gpJbegV6wlkJ7tOgFW2hphCrqKWrJTYRvSES5fs+ZTpiSNZFIi0oP3UlmHVj29Kcz15l4DoLQPq0gnPpsXCnDuGoekkE8B67J57MNxiQUAsadu6Zwg5DqcVB79RrlH2KZ2uGJkbyFUHrM3g8Xjl1ZnAWi0bgiXrNOlN08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rh66rQmQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lxO8kugu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rh66rQmQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lxO8kugu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rh66rQmQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lxO8kugu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rh66rQmQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lxO8kugu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C8A7C77DE9;
	Tue, 14 Jul 2026 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784050062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vCU3nDMqTqslzaNY/tQnqgH3Yn3EAJH52/dfhwcyRBY=;
	b=Rh66rQmQC54cu+wls/Jskd/aKBXgqhpgItgvahj5UuysZQPigKbU/ngU3mH92bKkPxjekL
	gfbrYVlzHOcppLZ1p8DkvPaynIyOvHvPBE2L5Ya+ZDmh8Z8obM1QeGzn0UIlxWskBvrShX
	EmgyqpEMjWLAXrtO/XJdFKgUO8ciJ5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784050062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vCU3nDMqTqslzaNY/tQnqgH3Yn3EAJH52/dfhwcyRBY=;
	b=lxO8kuguHD1VZDc1WdVW/2YQdhiKSOr7N27p8a+Dgy+/SHVfiLxMJZpWvy2LsR2SLCWd2I
	CbU5/z9RsnEhehAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784050062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vCU3nDMqTqslzaNY/tQnqgH3Yn3EAJH52/dfhwcyRBY=;
	b=Rh66rQmQC54cu+wls/Jskd/aKBXgqhpgItgvahj5UuysZQPigKbU/ngU3mH92bKkPxjekL
	gfbrYVlzHOcppLZ1p8DkvPaynIyOvHvPBE2L5Ya+ZDmh8Z8obM1QeGzn0UIlxWskBvrShX
	EmgyqpEMjWLAXrtO/XJdFKgUO8ciJ5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784050062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vCU3nDMqTqslzaNY/tQnqgH3Yn3EAJH52/dfhwcyRBY=;
	b=lxO8kuguHD1VZDc1WdVW/2YQdhiKSOr7N27p8a+Dgy+/SHVfiLxMJZpWvy2LsR2SLCWd2I
	CbU5/z9RsnEhehAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC3D0779AE;
	Tue, 14 Jul 2026 17:27:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4nSKLY5xVmoUUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Jul 2026 17:27:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A19CA1319; Tue, 14 Jul 2026 19:27:38 +0200 (CEST)
Date: Tue, 14 Jul 2026 19:27:38 +0200
From: Jan Kara <jack@suse.cz>
To: Timothy Day <timday@thelustrecollective.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Marco Elver <elver@google.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/9] Support Clang context analysis for ext2
Message-ID: <2mnivydbfh5h44gf7h2it4wmn6pbhbjyb23w24l7zh4tw6ytsu@wyvwrz4yxapu>
References: <20260712165610.366474-1-timday@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712165610.366474-1-timday@thelustrecollective.com>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Sun 12-07-26 12:56:01, Timothy Day wrote:
> This series adds annotations for Clang's context analysis to ext2.
> Clang context analysis was recently added in a series by Marco
> Elver [1]. This allows the compiler to validate different
> locking patterns at compile time.
> 
> This series enables context analysis, fixes pre-existing warnings,
> and adds new annotations. It is inspired by similar series in the
> block layer (NVMe host driver, for example [2]).
> 
> I'm starting with ext2 since it's smaller and simpler compared to
> ext4/btrfs/etc. After ext2, I'd be interested in converting the
> other filesystems and infrastructure code in fs/. I think the ultimate
> goal would be to enable this by default across all of fs/.
> 
> The series was built and tested with Clang 23 with
> CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc2 (since the
> minimum Clang version was recently bumped to 23 in 7.2+ [3]).
> 
> I'd appreciate reviews and suggestions. I'm especially interested in
> suggestions on how we can make this easier to enable for other
> filesystems.
> 
> Thanks!

Overall this looks sane to me and I kind of like the documentation value of
__guarded_by and __must_hold annotations. The context_unsafe annotations
are a bit annoying but I can live with that for now. Just one question: do
I understand right that the compiler verifies whether the lock is held when
entering the function marked with __must_hold? So if we get the annotation
wrong, the compiler will tell us?

								Honza

> 
> [1] https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/
> [2] https://lore.kernel.org/all/20260706141452.3008233-1-nilay@linux.ibm.com/
> [3] https://lore.kernel.org/all/20260515124426.2227783-1-elver@google.com/
> 
> Timothy Day (9):
>   ext2: fix ext2_xattr_delete_inode() context analysis warning
>   ext2: mark s_next_generation as guarded by s_next_gen_lock
>   ext2: annotate ext2_update_dynamic_rev() as requiring s_lock
>   ext2: mark statfs overhead cache as guarded by s_lock
>   ext2: mark s_mount_state as guarded by s_lock
>   ext2: annotate ext2_init_block_alloc_info() as requiring
>     truncate_mutex
>   ext2: annotate block-mapping helpers as requiring truncate_mutex
>   ext2: annotate s_rsv_window_root as requiring s_rsv_window_lock
>   ext2: enabled context analysis support for ext2 filesystem
> 
>  fs/ext2/Makefile |  2 ++
>  fs/ext2/balloc.c |  4 ++++
>  fs/ext2/ext2.h   | 19 +++++++++++--------
>  fs/ext2/inode.c  |  7 +++++++
>  fs/ext2/super.c  | 18 +++++++++++++-----
>  fs/ext2/xattr.c  |  4 +++-
>  6 files changed, 40 insertions(+), 14 deletions(-)
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
