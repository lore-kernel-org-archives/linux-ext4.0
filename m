Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1414AF9C3;
	Thu,  3 Sep 2026 12:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439396; cv=none; b=gx6WzkkIXxLtLTfBqZnm1yUtASqIffisIZlj9CwIpZcGSoNg3EQBpsPABbY7TZDeJSNJe8tlAy7Vdid2olNNu61quufW59XpPxcZ8yvKBcYreNm56lj8URYQK+hcfNsOqkV3MVD7LlslEkC9LpBd3CZdd5Lus4dDewRFjUJW+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439396; c=relaxed/simple;
	bh=mvZDiqO+Pe9snFYTUHuXSvVFKF94r+PNuGOALRzK8Mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ufz5cUL1sIAuuNxTdfGnLqGz3TYF8d1bSHAP1aE0JTn+d6Rovvk2ZSbG9VOxkenVSKp2Yu6lvjeHC0nR3RP9BDC/d7Qmky/byXIe8QrDj+hU2RH9nWAY2836dpKhNFRNHw/crHg9gU79qFGPkhuPFOFT5YO0B1obXSgqA723Wf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=f4vu8uoO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tGt5cqa0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Abt9suoA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o45cVcE1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="f4vu8uoO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tGt5cqa0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Abt9suoA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o45cVcE1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C48221EB4;
	Thu,  3 Sep 2026 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788439388; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apdOHiDarq0hKZLmSE6vMKU0nR+Lcau0dcF5C3LN+R8=;
	b=f4vu8uoO/sLVcs2p3NxLjhXuHuhJyCp8BTxg5p2YAQPR0t335NlN4vUnI3MVnAMTOlgljF
	8xrg3oQ4ccpwZcz6jwo90GYngQZCLroV00ytEgPoUZ1Idsty6u8fuhsceWOTZ+NebZaItE
	4tl/Huu7brJNawUAcHzMDe53Kqet19s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788439388;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apdOHiDarq0hKZLmSE6vMKU0nR+Lcau0dcF5C3LN+R8=;
	b=tGt5cqa00Txv3//tHRuri9g1nxKEiIGQ58NKpSK9PDK9YWXmuDSNqGP++/oq6hxoowUvCR
	MQwNHgYi0ZVXkQCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Abt9suoA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o45cVcE1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788439384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apdOHiDarq0hKZLmSE6vMKU0nR+Lcau0dcF5C3LN+R8=;
	b=Abt9suoA9MilwLa33Rzrk5KuNS9pMC19ha6fTrGFnG6XQqFDTcouq2XFVuN42yYeMHjBmn
	8DcI16Tezj2hUuoWY5rMMJixK72cQu+YIYuKNsnAM6yHMVoq/6IHXmaem1Z6pm657la30j
	JPmeySxyOJM8fCQmmZ7xybYavPzUy2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788439384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apdOHiDarq0hKZLmSE6vMKU0nR+Lcau0dcF5C3LN+R8=;
	b=o45cVcE1R134LzF7W83GVeyszfPbc1OnNAm9QuMTmsveJXgxAkinEDdPQ7XfwN24RYGmvg
	8x7077nxn3KVdbDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B51D136E6;
	Thu,  3 Sep 2026 12:43:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jz8ZHlhrmWqMKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 12:43:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F077AA13AC; Thu, 03 Sep 2026 14:43:03 +0200 (CEST)
Date: Thu, 3 Sep 2026 14:43:03 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Elver <elver@google.com>
Cc: Jan Kara <jack@suse.cz>, Nathan Chancellor <nathan@kernel.org>, 
	Timothy Day <timday@thelustrecollective.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
Message-ID: <46mgpyanbjl7eiln3nodqtpbubrwsc5blcjqd6r5pfokmssrce@k5qgaws7b2l7>
References: <20260811160336.782342-1-timday@thelustrecollective.com>
 <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh>
 <20260903072759.GA1750084@ax162>
 <CANpmjNNWiX51UU064+P823sDX42=O6ChSHrUux1aNqLj60mfUg@mail.gmail.com>
 <hnmqtyjazturtmhrw5xh445q4vrwv2mldhhspl6sf4hj6yzvqn@vzje2tuhtzdq>
 <CANpmjNPBxfgbuyK1VWsCukurEzhR5nFg1ydwEP9Gt0sGm9p5GQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNPBxfgbuyK1VWsCukurEzhR5nFg1ydwEP9Gt0sGm9p5GQ@mail.gmail.com>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 9C48221EB4
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Thu 03-09-26 14:06:22, Marco Elver wrote:
> On Thu, 3 Sept 2026 at 13:06, Jan Kara <jack@suse.cz> wrote:
> >
> > On Thu 03-09-26 12:34:34, Marco Elver wrote:
> > > On Thu, 3 Sept 2026 at 09:28, Nathan Chancellor <nathan@kernel.org> wrote:
> > > >   fs/ext2/super.c:1149:3: error: calling function 'ext2_rsv_window_add' requires holding spinlock 'EXT2_SB(sb).s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
> > > >    1149 |                 ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
> > > >         |                 ^
> > > >   fs/ext2/super.c:1149:3: note: found near match '_res->s_rsv_window_lock'
> > >
> > > sbi was just allocated, and EXT2_SB(sb) and sbi are pointing to the
> > > same object (unless I misread the code), but the compiler can't tell
> > > since aliases can't be tracked through non-local objects. So that
> > > scoped_guard could just become:
> > >
> > >   scoped_guard(spinlock, &EXT2_SB(sb)->s_rsv_window_lock) {
> > >   ...
> > >
> > > But I'll leave that to Jan and Tim.
> >
> > Yes, at the beginning of ext4_fill_super() we do:
> >
> >         sbi = kzalloc_obj(*sbi);
> >         ...
> >         sb->s_fs_info = sbi;
> >
> > and EXT2_SB(sb) is just sb->s_fs_info. Are you saying that clang is not
> > able to infer that sb->s_fs_info and sbi are still pointing to the same
> > memory later in the function where we do scoped_guard()?
> 
> Yes - alias tracking is only done through local aliases. sb is
> non-local, along with additional member indirection; unfortunately,
> the C language doesn't give us the guarantees that it wasn't modified
> somewhere in between, say after a function call (this rule is applied
> also for local aliases if clang sees that they "escape" their local
> scope via non-const pointer to pointer).

Hrm, ok, understood (but still it's annoying ;)). I've pushed out the patch
with the suggested fixup.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
