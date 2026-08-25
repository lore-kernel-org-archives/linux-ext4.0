Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD763B71B5;
	Wed, 26 Aug 2026 07:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730735; cv=none; b=ftqP7wbj0y/kH+cm6irFcvRocYs899r9Ht74pDwEza8cAyH+kEtDI0v0JBtpz11XE1G0JSCH/GQmcQUrAc2Txb+opgPfgIDnB3ZFIVSGspUtyzONyhqbQt7O7FDJA9nl6RsdvGEQIHNDgXjRzzCJsduo5LPSfdldI6fAjKYH3/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730735; c=relaxed/simple;
	bh=SVoJ1OI3dQGjYQH2QG1Wgnb7grwblCWNfudeJMMgJe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6BCTj8sPCfrBvhFr3KHbCROxF27/BuwZNdtd+qxW+spw/sAOzVs+Fke0ufoR1VCaDf6VV8umYqSFoOVWDujCoJy4IapoKlaxWK2T4hbnjZuDyULpj9qxFuKe3IRDC3xx0gWU+ejovuE+KxxGb2LMbZDnQffWF0sHYVz4UAEl3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CqtISVV+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gfl1y0yz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3NGMjCGp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tQraLm25; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CqtISVV+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gfl1y0yz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3NGMjCGp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tQraLm25"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0774E1F7F8;
	Wed, 26 Aug 2026 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xhmFNYVPeKjgZrR7L7bMBdZSCFUU1bReaXXHWoLNauE=;
	b=CqtISVV+cuddUD1VmXjXxzRYAE+aXacsf46wxBubuP342MrhMQLj0m01/gzU95ajwT/utd
	JIYzq8UwpdF5na9K1ps5A7nsEOpuN4lx0+TXgV8Ehw1T4NbTeNXFvgGbXYC7S6BV/UeZv9
	42Ff9xTA/9dv6nbz6Q/+7GsvFBKZ+Kg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xhmFNYVPeKjgZrR7L7bMBdZSCFUU1bReaXXHWoLNauE=;
	b=Gfl1y0yzkjnRpCZ4ElX5LaKqOr2OvVBpe5XalDBkq9/xnQxalGZ1V5N1lC1D3NEbdWpaEI
	SnvFp3xR25SV5mBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xhmFNYVPeKjgZrR7L7bMBdZSCFUU1bReaXXHWoLNauE=;
	b=3NGMjCGpcFFaf0sWO5x8pQFIJwx3rfGxfbiJIiDjQi9NG6vqPRUTU79/W+H95kC1uXcxKQ
	fx+ca1iTGSXtUsxJ46iCdeq75wBfw1hQlLOBGwXSpz+s3JdFALTTZmfXDQ6KAzEGMJPPr6
	4w3BRw2mvh93A1LpETInVzqrQ1gr6+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730606;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xhmFNYVPeKjgZrR7L7bMBdZSCFUU1bReaXXHWoLNauE=;
	b=tQraLm25kXu8pDycXAMRr57/5bGagx1laSVMWLOOLdbOOhhIfDS98KnMju7kFadt9D7VCA
	TxRIKuubxvINryBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB1F4136A1;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TjNiOaOajmohDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 66602A1324; Tue, 25 Aug 2026 17:28:58 +0200 (CEST)
Date: Tue, 25 Aug 2026 17:28:58 +0200
From: Jan Kara <jack@suse.cz>
To: Kitae Yoo <kitaeyoo777@gmail.com>
Cc: Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] quota: opt-in strict enforcement of project
 quota hard limits
Message-ID: <ajwpsowt4zfqucldk2obwrve77e3aydys6opub3pbgljxy55ua@32eu7mufukr4>
References: <20260814114649.51253-1-kitaeyoo777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814114649.51253-1-kitaeyoo777@gmail.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Fri 14-08-26 20:46:47, Kitae Yoo wrote:
> ignore_hardlimit() exempts CAP_SYS_RESOURCE holders from enforcement of
> hard limits (and of soft limits past their grace time), regardless of
> quota type, so it also covers project quotas.
> 
> For user/group quotas this matches the long-standing expectation that an
> administrator can act on a full filesystem. For project quotas it is a
> poor fit: a project limit bounds the size of a directory tree rather than
> restricting a user, and is commonly used for capacity isolation of
> container volumes and NFS-exported shares. There the exemption defeats
> the purpose. Two concrete cases:

Project quotas *can* be used for restricting size of the directory tree.
But it is not the only way how to use them (nothing really forces each
project files to form a tree).

>  1. A process holding CAP_SYS_RESOURCE (e.g. a privileged container)
>     writes past a project hard limit; accounting keeps rising above it.
> 
>  2. knfsd raises CAP_SYS_RESOURCE for requests mapped to root on
>     no_root_squash exports (CAP_NFSD_SET in <linux/capability.h>). So on
>     an ext4-backed, no_root_squash NFS export any remote root write
>     bypasses project hard limits, no matter how confined the client is.
>     We hit this while evaluating ext4 project quotas for multi-tenant NFS
>     volumes: with a 2 GiB hard limit, remote root writes proceeded well
>     past 2 GiB (v6.8, quotaon reporting "enforced"). The same setup on
>     XFS, whose enforcement path performs no capability check, stops the
>     write at the limit.

I would consider this a desirable behavior, not a bug. If you have
priviledged user, he/she should be able to overcome artificially imposed
limits. That was the design of quota subsystem from the early days. Running
as priviledged user in a container or without rootsquash on NFS is IMO a
bad security practice and such user can generally overcome the limits (e.g.
by changing file owners including owner project). So not only would this
break a long standing practice, I also don't see how this would
significantly change anything.

Sadly, XFS always had a separate quota implementation and as a result there
are subtle behavioral differences. In particular limits for
user/group/project 0 are treated as default limits for any user with unset
limits. I don't think they are expected to constrain root user.

> DQF_ROOT_SQUASH already disables this exemption, but setting it has been
> confined to the old v1 quota format, and commit ca6cb0918e87 ("quota:
> Verify flags passed to Q_SETINFO") later made Q_SETINFO reject it
> explicitly on other formats, on the grounds that those formats did not
> persist the flag and a flag silently lost on remount is confusing. That
> confinement predates generic project quota support (commit 847aac644e92
> "vfs: Add general support to enforce project quota limits").

DQF_ROOT_SQUASH was always intended to be limited to the old quota format.
For newer formats, we always allow setting limits even for
user/group/project 0 but we also respect process capabilities when checking
whether it can overcome the limits or not.

> This series lifts the restriction and addresses the persistence concern
> that motivated it:
> 
>   1/2 allows DQF_ROOT_SQUASH to be set through Q_SETINFO on all formats,
>       so it can be enabled per quota type (e.g. project only).
>   2/2 persists the flag in the v2 on-disk dqi_flags field, which already
>       exists, masking on read so only the supported flag is honoured -
>       which also keeps the pre-existing unvalidated on-disk bits (the
>       reason c119c5b9749e "quota: Don't store flags for v2 quota format"
>       stopped storing them) out of the in-memory state.

Thank you for your proposal but essentially you create a flag saying
"ignore CAP_SYS_RESOURCE for project quotas". As much as I can see how it
would be convenient for your setup, I think that is a bad design and would
create confusion down the road. All I can really recommend is to properly
separate priviledges for your processes and then you wouldn't have to come
up with hacks to ignore CAP_SYS_RESOURCE...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
