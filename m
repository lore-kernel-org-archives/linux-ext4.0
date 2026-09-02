Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6424A64E2;
	Wed,  2 Sep 2026 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788361032; cv=none; b=Ee+hZUaBzVMJPupHUm5Gvtu7T6w6MIFQLl9EQ88hUqsRm/hLdLch3GlxQfOBia+FNAJ9MoIaLp2BmGa++iPK6yujPrkQTw7wf0/NxxqvkD+J9Ouz8TTslqNb/JNgAs7lPgzfiz+zm898r1joLeJzqsmpv/gUQsDkA0Blogd5/nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788361032; c=relaxed/simple;
	bh=EcwD6RySu+Vi2oDqb/Cbh6fRw3TVgFdZSMuq+8Ytg2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPbwC4Bej2qL3WuwPOvj0sA6kSMgxNVh6uBRB+0L8p4TWIjK2XivK2mu8+y53URbQ5fbugDaqWfJl3HSMLXNSPsDCdycZKkuAeXkT3RqJ6wCx6dV5ej3Ex81A69LuAJVQVl0rw2Z2hZWWGdxG4hwEZDR2i3jTXMf/ZwH/jiPqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dnew6nRR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0GCEvP3q; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j0wxN3AO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=78uO1DIs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dnew6nRR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0GCEvP3q";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j0wxN3AO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="78uO1DIs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1C14D21E1D;
	Wed,  2 Sep 2026 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DTaZRJF7E4m58tGqejqLU6yBS1jXF76V0QMjhTNpg4Q=;
	b=dnew6nRRFMVUUnPTU9/EgOMTHioW2Im9zA1C+04uczxq7Utx3JpDraGG7gzkXzG/kd/gi+
	HPloynMmdaN1yn4Dxz90wI89y336ROXi0VlbribVpDR/ktva4faIx4VmPNB2J8mvXl4TBx
	Lcl4MyBnyjQxbfk7mLken7q1CmDMQ/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DTaZRJF7E4m58tGqejqLU6yBS1jXF76V0QMjhTNpg4Q=;
	b=0GCEvP3qrP0fKlUWajRZaHdGGoT0BQqsoeJP0GrydZIZ2pLhbCPeCKCn+wRNDYwzsbWCJw
	T/lFI7ApXD4hF0Bg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j0wxN3AO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=78uO1DIs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DTaZRJF7E4m58tGqejqLU6yBS1jXF76V0QMjhTNpg4Q=;
	b=j0wxN3AORIKe5x2jl87BHtIXAy6f4dUHvX9ZHHJefH8cb24dOoVbg2+vLyeNztiwd55rq7
	4FtVjWk2JsBc39dRWhEJMsPkDFpqcKjhROQQ/pRW0FDOfnIm/RLHA4zIQ5AAyAGT/e1Nnf
	8B6KlM9KJc3owZfR+SJYSfeD9A50jBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DTaZRJF7E4m58tGqejqLU6yBS1jXF76V0QMjhTNpg4Q=;
	b=78uO1DIsTGApubBflfpR3ncPUKEQuHfpKm2hKgyiUtbzFh5P+6n3CUVpXij89iY7gzm5Go
	nS8UrkX6dcYp7IBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EEEA3136E6;
	Wed,  2 Sep 2026 14:56:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aIlBOjg5mGqjMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:56:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8692DA13B5; Wed, 02 Sep 2026 16:56:56 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:56:56 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>, bcrl@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, sforshee@kernel.org, akpm@linux-foundation.org, pmladek@suse.com, 
	rostedt@goodmis.org, andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, 
	senozhatsky@chromium.org, kees@kernel.org, tglx@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 0/8] Convert barrier pairs to acquire/release for
 better performance
Message-ID: <mamuiutepiyntod2mjigirx4bpn7kadrbtn74i3f4egl5wcg7t@ubixnvgdntie>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <apgv5w116frzutwH@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apgv5w116frzutwH@mit.edu>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 1C14D21E1D
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[huawei.com,kvack.org,zeniv.linux.org.uk,kernel.org,suse.cz,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,linux-foundation.org,suse.com,goodmis.org,linux.intel.com,rasmusvillemoes.dk,chromium.org,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO

On Wed 02-09-26 10:19:46, Theodore Tso wrote:
> On Wed, Sep 02, 2026 at 03:47:57PM -0500, Jinjie Ruan wrote:
> > 
> > This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
> > smp_store_release()/smp_load_acquire() across various subsystems.
> 
> I would like to land the ext4 related patches through the ext4 tree,
> so please detach them from this patch series.  That's because I want
> to be able to monitor the regression testing before sending a pull
> request to Linus.
> 
> More generally, I think we should be looking at this kind of barrier
> conversion on a per site basis.  If there is a bug that isn't notice,
> it can result in a very hard to debug problem.  And if the benefit of
> speeding up a particular code path isn't particularly that great,
> maybe the cost vs benefit vs risk calculation might cause us to decide
> to take a pass on the change.

FWIW I believe each patch in this series is standalone so you can just pick
the ext4 ones yourself. Regarding the benefit, I actually find load_acquire
/ store_release more self-documenting, what exactly they are protecting, so
generally I'm in favor of such conversions if they logically make sense
(i.e., it's really the "prepare some data + store to publish" pattern) -
which was the case in the patches I've reviewed in this series.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
