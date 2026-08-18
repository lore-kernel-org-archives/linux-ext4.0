Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E63D4749EC;
	Tue, 18 Aug 2026 12:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787057318; cv=none; b=szGVDq/84/GOBut5afv2x8FhAjQZgbHae5BJxJ4s9a2UxVoEg8MtZ/6Y4wBgSTu0Y9ObZ2xj8V5u6mz4C7yFdBNcwIM6j50N2D8/0UcKcoB3oTVwD9JNr3a+w5V68dXA5EeUD7fYnLSwn2VNKcvIzv/xU1FOx50pkL0jincUfVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787057318; c=relaxed/simple;
	bh=tKUchanq+KiJIQd03AVF65L9DntOK0DRYRroaYveGUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGilAfRcUfTs0pH2KV1f6xVkCRLwP86Dl9eOvqLr78KK6sBjGN7uh+3Gg4oi97M27/k+3YVUuqaHr3mQFLXX2kYfZtko+Kg9OdbFdNUbUz29Sdv8H3DZMh9ux2M/NeHGL+yPiB1VUC5ngLuWWvYR40FQwWg/YfFVlBY+2F710Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AAzUsx1h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0q+k+h4z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EY33hLE1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vlx2GxaF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AAzUsx1h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0q+k+h4z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EY33hLE1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vlx2GxaF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2D30845A2;
	Tue, 18 Aug 2026 12:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787057310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hFYf+PI69zb24U4ClXKTJmq8CU5/m79MkW1z4jFPHM0=;
	b=AAzUsx1hKXFh3yNJcy1W1acpYYkEsb3YEw7rYSOpIhEMByskGpYH1lvRiLef1qlCBpdLS4
	i11ly/qS48nfrly75zWukI0DdsHFvdKc2j6LvZMWeAdy5JSAQ3p6Pzu8FVQyek5g3HDvLt
	29+R7/ry8vCKuezX6btiPIZMN+245/U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787057310;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hFYf+PI69zb24U4ClXKTJmq8CU5/m79MkW1z4jFPHM0=;
	b=0q+k+h4zm69d17SoApG/cc2uVWV8cXSWxUEF7JCcxNBzAmiEQx9YUfo2tOKOSHC/PbwVXD
	eh0uZAgD783LBQCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EY33hLE1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vlx2GxaF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787057305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hFYf+PI69zb24U4ClXKTJmq8CU5/m79MkW1z4jFPHM0=;
	b=EY33hLE1GKlc6EltJP6qzHUyoWO/ipGjeZvD0fS//NqfiwNqLNxR7pcpz7DX45RJilXg6c
	JhuyQY+zl7VWHo0HLfDS/zFeDsUV/tdZo+mF5GP1YFwWxq4JxhP65J5Pw96QqXVk8oNBBH
	1YwhRrg1MdH7J7ASE2MgGnPpEyL/U88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787057305;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hFYf+PI69zb24U4ClXKTJmq8CU5/m79MkW1z4jFPHM0=;
	b=Vlx2GxaF4hEpLooChA5+9WvDFG4GrZEHfJ/iB+dx/J0Fm7+XT7rg4nyoh9pBUwfgYUwCNV
	rqxcmH52EdsjXtAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B93E522BA;
	Tue, 18 Aug 2026 12:48:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hh83LZlUhGrqHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 18 Aug 2026 12:48:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 941CDA13B2; Tue, 18 Aug 2026 11:58:20 +0200 (CEST)
Date: Tue, 18 Aug 2026 11:58:20 +0200
From: Jan Kara <jack@suse.cz>
To: Timothy Day <timday@thelustrecollective.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Marco Elver <elver@google.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
Message-ID: <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh>
References: <20260811160336.782342-1-timday@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811160336.782342-1-timday@thelustrecollective.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: C2D30845A2
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hello!

On Tue 11-08-26 12:03:28, Timothy Day wrote:
> This description is mostly copied from v1:
> 
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
> CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc7.

Thanks for the patches! They look good to me. Once the merge window is over
I'll queue them to my tree. The only thing I'm not fully sure is how much I
like the spinlock_init scoped guards - they looked quite confusing to me at
the first sight (as much as I understand the convenience, conceptually how
can initialization of a global lock be scoped?). I'll sleep over it, maybe
I'll change them to just spinlock_init() + scoped_guard for the lock itself
or maybe I'll get used to them. Anyway, no action on your side needed :).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
