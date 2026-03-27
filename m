Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A101E35AC3A
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774628825; cv=none; b=cH4kSUQY+vBpaBIuxImpJYWgk9uKyGUdv3F9RoiKrnQQ4uBvjH8AB7ocBAvklPCaI59Vi37qcHaJyB3Yo12WrMmmpyv67QG6vXAijH/sgOVkXKw8hac8IwbgmDVG1pVibx5douthfpDbhRC56Bh18D/QG1BiVc7c6Lr0+3yV39k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774628825; c=relaxed/simple;
	bh=H6BFM46QAO9JXeDjUblDjIr7SHr/MFDykB777mwlxPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRoZVdo6mX1QIYUeEAdQlRHovto9rqrGFY4tu2WCtrKqMa/228I0RirVyzoL4nNQ/NPBlTr6rpqjGvm1j4T6wJaQVc2mZ5SNtZ6iKqtAMmVwI4moejP1ak4TT1QiPtUXqwivONN0gnMcRDQmv5eEp6D/lTWYjPRaRUC5vgEyia4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PWIRwc8r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aHy7/HrQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JdZTa2nF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4tn+bHEd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PWIRwc8r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aHy7/HrQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JdZTa2nF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4tn+bHEd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E83785BDED;
	Fri, 27 Mar 2026 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774628822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=PWIRwc8rOn9Nb4fu2FlwjtSXS1qkXG0tjm/SzAXF8JeibADY9YCwpulSakhZ9HEai4VzWq
	RcLicvOGKKXUgTc+/f7Ly1MITdhSOlfzYOsT4udpnbmj+3ESJx75D9CmE9de75tAao8tLu
	0iojcawi6Be59m8CiJSr+pgwVrdYaxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774628822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=aHy7/HrQ2QdAR4JQb/JErLh8xEBvQrwFvXxGaRsi+mCfX+f8aK+cDqc/cqOxstbbH/5D9u
	VP7Z3RP2uGuw0wAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774628821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=JdZTa2nFwYlx7Yz4v0Z1m4tXCmDoIzNzOJNW+8xEWeP8KwfAwRmuW6eBPI9Y4cuUjeAX/l
	tCv7i6kBMRuIOSP+jljGRT7CpbaFnd37x0zUwqg81DbBCJLnjPD9dXPI6iYvqnzSCXv4HD
	z7iMh9qWp9Db6GOOlplSxiGIi58kq90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774628821;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=4tn+bHEdrwopjN6Dk8ZMfXdEshhQTlIfghPu9FONoDvawdc8IUbttoyLrGr2hyy1XwXLDI
	+SyoNvyVCOyLf9DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAEAD4A0A2;
	Fri, 27 Mar 2026 16:27:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3v5vNdWvxml5SgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Mar 2026 16:27:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9A9C2A0976; Fri, 27 Mar 2026 17:26:57 +0100 (CET)
Date: Fri, 27 Mar 2026 17:26:57 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 14/42] fs: Rename generic_file_fsync() to simple_fsync()
Message-ID: <szke56tw43bq2wyv3rai3akrewxbpclbj3finajrwtubkzbgbz@zgj7cc7h2sr2>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-56-jack@suse.cz>
 <acYiH4ByDc1-nPqD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acYiH4ByDc1-nPqD@infradead.org>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 26-03-26 23:22:23, Christoph Hellwig wrote:
> > -extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
> > -extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
> > +extern int simple_fsync_noflush(struct file *, loff_t, loff_t, int);
> > +extern int simple_fsync(struct file *, loff_t, loff_t, int);
> 
> Please drop the pointless externs, and maybe also add the parameter names
> when you touch it.
> 
> Otherwise looks good.

I believe Christian has a patch from Jeff in his tree cleaning up the whole
fs.h header in this way. Not sure how Christian ended up resolving the
conflict but we can clean this up after the merge window if some externs
are still left there.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
