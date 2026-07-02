Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F42B4DB570
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002322; cv=none; b=DuwFaNzP1bSDuN2Z0wbA5IqggcGUyFXUuRH3C1pS3mVi/yb9nZ514l/nF4OBfZt4mcKBpkQbjSQlP7ZVDgl85HcF3UBGDIWzCo/ml8K9UEUCzTrSX7n/oP0YakjCDkYCwsKqBMIp+KzdnX3AffldKUfjibV2FifwGfvQetYf6Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002322; c=relaxed/simple;
	bh=btHQyhunEiGffs5qzss/5oZqFMdk46YqSCN2OMLKq1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0wOgZmP2JLaTdpXGEl1AHG1rbUPHAoF8U4HBxS8WrCK6vPYNjIcDX6Uzi/tpCueoDpF++QmQtRC81CxTR1yvvHq7uw/30AC9ORVSfbMIXWYRBt0EdgcppzERdwo4i5OVr7HuWlebbBpZyJnlky88C2CUJAXtXvha/U3HY5uS7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xILfie6E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L+k0vvab; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xILfie6E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L+k0vvab; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xILfie6E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L+k0vvab";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xILfie6E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L+k0vvab"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1912574220;
	Thu,  2 Jul 2026 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783002317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2mvTo13UDZWasKlGkpxWAfxMxVwyDQyTfMbb5Z+ZZwQ=;
	b=xILfie6E/VoLZTXpXn/hdEsmcNU+o6jfjAkAVAI06RYkZ9JKQRiD4YZFGXEGrIK5eK8sik
	a0uWerXTcPJV/3SiKWHO2HjaI+zmP4P7PSno7bMxz+Y6BlhcveefIPyTpEaUOwyiiGS1ix
	84jetfKYrTTHdNfrg6bpG98Ly/rc8Ow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783002317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2mvTo13UDZWasKlGkpxWAfxMxVwyDQyTfMbb5Z+ZZwQ=;
	b=L+k0vvabmFkiESfu3iM36vVFMWX70RQMlJTdR3VdhGYrBjyLuspjSM634bH7AMu+Z4qLLq
	g/Q4XwihiFaZCfAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783002317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2mvTo13UDZWasKlGkpxWAfxMxVwyDQyTfMbb5Z+ZZwQ=;
	b=xILfie6E/VoLZTXpXn/hdEsmcNU+o6jfjAkAVAI06RYkZ9JKQRiD4YZFGXEGrIK5eK8sik
	a0uWerXTcPJV/3SiKWHO2HjaI+zmP4P7PSno7bMxz+Y6BlhcveefIPyTpEaUOwyiiGS1ix
	84jetfKYrTTHdNfrg6bpG98Ly/rc8Ow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783002317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2mvTo13UDZWasKlGkpxWAfxMxVwyDQyTfMbb5Z+ZZwQ=;
	b=L+k0vvabmFkiESfu3iM36vVFMWX70RQMlJTdR3VdhGYrBjyLuspjSM634bH7AMu+Z4qLLq
	g/Q4XwihiFaZCfAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A8A4779AA;
	Thu,  2 Jul 2026 14:25:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q+aQAs10RmpELQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 14:25:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4DF56A0AE1; Thu, 02 Jul 2026 16:25:08 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:25:08 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: use fsdata to track inline data write state and
 fix race
Message-ID: <g5eysqk2ksqaigvjn6a6ffkmrukpaorfd5e6eyhdamqwtz5idg@ta5veoyzfab4>
References: <20260702050724.1658-1-aditya.ansh182@gmail.com>
 <3sbocdflzeajcievmbdwprrgzkztd7ogn7mmjx4quptorotwak@rlzklako3yht>
 <CAK5ssPOM-rddJR6=QJ4RSCeQvamKKAbJS+NCOLbsC2eSODydkQ@mail.gmail.com>
 <zwfhyqxdxfigm5nced3hgsp4mygwxgwc4cxzeyl7glrmie73rm@r66bdrw7fjsj>
 <CAK5ssPPPfkL889aCK_z9EnDNbKBuHRQd45uLzXpeUVrVkFkzbw@mail.gmail.com>
 <CAK5ssPOxredbV5dDsyc4YLdDBVPEv5b6qOKCxiWPLMWSc7VyaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ssPOxredbV5dDsyc4YLdDBVPEv5b6qOKCxiWPLMWSc7VyaQ@mail.gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,taobao.com,syzkaller.appspotmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

Hi Aditya,

On Thu 02-07-26 18:15:21, Aditya Prakash Srivastava wrote:
> Thought a bit more about it. Treating fsdata as
> bitwise flags rather than mutually exclusive enums is a much
> cleaner and more robust design. It completely decouples the
> different write path states.
> 
> To implement this, I will define:
> 
> #define FALL_BACK_TO_NONDELALLOC 1
> #define CONVERT_INLINE_DATA 2
> #define EXT4_WRITE_DATA_INLINE 4
> 
> This ensures that the flags are fully independent and do not
> overlap.
> 
> Regarding unrolling the state on exit, there is a slight
> asymmetry in the VFS interface. ext4_write_begin() receives
> fsdata as a pointer-to-pointer (void **fsdata), while
> ext4_write_end() receives it by value (void *fsdata).
> 
> Because write_end() receives fsdata by value, modifying it in
> the write_end handlers has no effect on the caller's
> (generic_perform_write()) local stack variable. As a result, a
> stale EXT4_WRITE_DATA_INLINE bit would remain in the VFS across
> a retry.

Right, my bad.

> To handle this cleanly within the constraints of the VFS
> interface, I propose clearing the stale bit on entry to
> ext4_write_begin():
> 
> static int ext4_write_begin(..., void **fsdata)
> {
> ...
> 
> /* Clear any stale inline flag from a previous retry. */
> *fsdata = (void *)((unsigned long)*fsdata &
>   ~EXT4_WRITE_DATA_INLINE);
> 
> ...
> }
> 
> This ensures that:
> 
> any stale inline flag from a previous retry is cleared from
> the VFS stack variable before the next attempt;
> 
> the FALL_BACK_TO_NONDELALLOC bit remains preserved; and
> 
> if the retry prepares an inline write, ext4_write_begin()
> simply sets the bit again.
> 
> Please let me know whether this write_begin unrolling approach
> looks good to you, and I'll submit the v3 series shortly.

Yes, that should work and should be clean.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
