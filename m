Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D5C4F797F;
	Tue,  8 Sep 2026 10:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862525; cv=none; b=jvNOIHoyLP3xc9Wnvg4gJA3UpayFpzZE1NtzbxJXEaz76MKyIK8Z8W1MiJgpu+aE13BAGSWEAFG4Kd53emrwEeGNjgSJok+Ylx1ClAA5nbPlTgQBfBAt4+ynAVZ5mr4BjxwSsyXEa18Gjhd/xe46zEsDF6IbtjuxCvOx4Hqw95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862525; c=relaxed/simple;
	bh=WDTyb1scNjZcZcfWMAi32kar2RDeKokQGtwWgny0gXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlNqdSY/bd1BnUkQEsV9ylxwMhPn3zLQAndpsfaLsV15WsAhcvT1L/nJbf510OBBETgKGMkrY7y2vtky9rVY7XONhx8agjkNQ+0htrLjLQ6G+TqYd2w3/iWK2xc8wV6AUVi35UYWvfEhHlSrMVqt29tm1M3HhxpTWEaEc7jJxuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kp8+sNCZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bgAPPXN9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=t2l3OBEm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LianugfN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kp8+sNCZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bgAPPXN9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="t2l3OBEm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LianugfN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E5CE2219B8;
	Tue,  8 Sep 2026 10:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788862518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnggoyTBKsAGdg027tXoZOmT0sWiqPyFT/ezF3zuki8=;
	b=kp8+sNCZ+FORZ/10YuD+JRUd+pmqev8hmTEzEOyBZX+Pxyny6OIYhw2JuNIHXt86OKn34X
	bJrjg0M79toDFfHRFfmjHfpvf1xGPC0fRz5ixda2hFVURi1OJW6jDV4tOe/Q8IFuFOLTSh
	7/y2Og3gNG1CByCzf5zCHVm95Tk6waM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788862518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnggoyTBKsAGdg027tXoZOmT0sWiqPyFT/ezF3zuki8=;
	b=bgAPPXN9n6luzjJGPq4DNKRHr7nViaZ5G/9qnG8y0bziQADxNF6+Qi/hY1oonjkRTKRBQS
	ZumGjRLjR9nN19Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t2l3OBEm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LianugfN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788862513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnggoyTBKsAGdg027tXoZOmT0sWiqPyFT/ezF3zuki8=;
	b=t2l3OBEmyJMu7E3JulBm27dgD6P+/usbt4gLsUPFtPgFMzO8Eq/3W0SO2hj9EdwwxzYT2R
	NZLKyLE3ql9ix3tyetOgA1ljQaqY+ObhcICxUDTZH01Dyuh9ntw7TyXAZUVCZp9AJszshf
	NKm+8wVntXswQKK6+23JUuI7Do+vcYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788862513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnggoyTBKsAGdg027tXoZOmT0sWiqPyFT/ezF3zuki8=;
	b=LianugfNE2ehQ3cZ41MyWpmTtgQEtPOPUTi3OieIYHVHCY+rLRbQO8J5VtQPhlaOuiytQF
	+KoFHmlpitsTN8DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C731613332;
	Tue,  8 Sep 2026 10:15:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iambMDHgn2qhCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 08 Sep 2026 10:15:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 62736A12E2; Tue, 08 Sep 2026 12:15:13 +0200 (CEST)
Date: Tue, 8 Sep 2026 12:15:13 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Elver <elver@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, Jan Kara <jack@suse.cz>, 
	Timothy Day <timday@thelustrecollective.com>, linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] once_lite: Simplify condition handling and fix context
 analysis
Message-ID: <4ohly4m6ffr4jnpqncucwkajjorfzdi4x3perczoszs5cb7ljx@mrf7no3uuzua>
References: <20260903101843.3462767-1-elver@google.com>
 <20260907221334.GA1619741@ax162>
 <CANpmjNNuiX-rQFvn0GK1SxAbcxEUH7rKh69GPq+7u2tg63qbmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNuiX-rQFvn0GK1SxAbcxEUH7rKh69GPq+7u2tg63qbmQ@mail.gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E5CE2219B8
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 08-09-26 00:17:34, Marco Elver wrote:
> On Tue, 8 Sept 2026 at 00:13, Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > On Thu, Sep 03, 2026 at 10:16:38AM +0000, Marco Elver wrote:
> > > When WARN_ON_ONCE() wraps a conditional lock acquisition (such as
> > > down_write_trylock()) on architectures relying on DO_ONCE_LITE_IF()
> > > (e.g. arm), Clang's context analysis (Thread Safety Analysis) failed
> > > with a false positive:
> > >
> > >   fs/ext2/xattr.c:825:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not held on every path through here [-Werror,-Wthread-safety-analysis]
> > >     825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
> > >         |             ^
> > >
> > > This happens because DO_ONCE_LITE_IF() branches on __ONCE_LITE_IF()'s
> > > return value (__ret_once), creating an intermediate branch merge point
> > > where the lock may or may not be held depending on whether the once-flag
> > > (__already_done) was already set. Because the merge branch condition is
> > > __ret_once rather than the trylock predicate (__ret_do_once), Clang
> > > cannot reconcile the lockset at the branch merge points.
> > >
> > > Fix it by refactoring __ONCE_LITE_IF() into an unconditional
> > > __ONCE_LITE() primitive and redefining __ONCE_LITE_IF(condition) as:
> > >
> > >   (unlikely(condition) && __ONCE_LITE())
> > >
> > > This simplifies the implementation, short-circuits evaluation so that
> > > __ONCE_LITE() is not called when the condition is false, and ensures
> > > that DO_ONCE_LITE_IF() only enters __ONCE_LITE() when __ret_do_once is
> > > true.
> > >
> > > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > > Link: https://lore.kernel.org/all/20260903072759.GA1750084@ax162/
> > > Signed-off-by: Marco Elver <elver@google.com>
> >
> > Thanks, this fixes that warning for me across all my builds.
> >
> > Tested-by: Nathan Chancellor <nathan@kernel.org> # build
> 
> Thanks! I think this is one of those orphaned files - which tree can
> this go through? Can it go through your tree, unless Jan already
> picked it up with the other fix?

If Nathan can take it through his tree, that would be great, otherwise I
can take it through mine. Just let me know.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
