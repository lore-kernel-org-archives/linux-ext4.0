Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6E521FF23
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 10:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779703596; cv=none; b=TcPiooBqK20U36UlqiHdWtKCgU0MAL3X9Ih7qQCDR9ah/stFcP28pi33spGucYCIAqpG+rTZnSauXo80gndNDNqv+IhCvZQ7GSqdtyXP6PQnFglQFH9E+zW0F7/ZjNApddi20a+nysKKHWLxTt7XHeNiyG9bsz3cPTl1evbGukM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779703596; c=relaxed/simple;
	bh=hZ1TvjhWzz5vWuzuCGmOQIs5nm3x/CA9+cefyK962+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/s+Aq1PETvnWbBhnOlWK6UOI0kPscY3ZeXiaBxDyIM7QMTOOxGyCjQsHQo6pGu+Ipi/7p8ums9qHGdGQvaEyQDClpCtlXpO/+zOEYeB/ZJpQpPSLABSK8ogtrbDFAS/cYAPFeZmUTWFU9xbAfFdFnaOcOFWAImJPkZwqwCkRIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=11g/u07r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=v0LYslZc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=11g/u07r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=v0LYslZc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="11g/u07r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="v0LYslZc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="11g/u07r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="v0LYslZc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B695E689D3;
	Mon, 25 May 2026 10:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779703593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yss4UJorv1yENV/ZosYpzvK9tN1Nk09hxjVf+F9GFVk=;
	b=11g/u07ry4i/CVtbM3XecSm9iPmg93+G/OikIGpzCFgRRARUtDpVxjgft44qsXAGj1W6aM
	1qafMUJ4eXEUdBFEY92KTXk/ulHlmU6cAJFib5ZnOyYLL0dtC4pBS6vI3CaZ+PsU8KDvN7
	WYkZxL0rhOZAs/DYwKfL5Dx2b7foFQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779703593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yss4UJorv1yENV/ZosYpzvK9tN1Nk09hxjVf+F9GFVk=;
	b=v0LYslZcnPZoC65xGELTEoXLcXSBJz73A6mwIopew5pr5aQWj8AQdb7jlYGM7BcJFG3nt4
	LTjy3MxycGNpunBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779703593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yss4UJorv1yENV/ZosYpzvK9tN1Nk09hxjVf+F9GFVk=;
	b=11g/u07ry4i/CVtbM3XecSm9iPmg93+G/OikIGpzCFgRRARUtDpVxjgft44qsXAGj1W6aM
	1qafMUJ4eXEUdBFEY92KTXk/ulHlmU6cAJFib5ZnOyYLL0dtC4pBS6vI3CaZ+PsU8KDvN7
	WYkZxL0rhOZAs/DYwKfL5Dx2b7foFQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779703593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yss4UJorv1yENV/ZosYpzvK9tN1Nk09hxjVf+F9GFVk=;
	b=v0LYslZcnPZoC65xGELTEoXLcXSBJz73A6mwIopew5pr5aQWj8AQdb7jlYGM7BcJFG3nt4
	LTjy3MxycGNpunBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 965CE59BAF;
	Mon, 25 May 2026 10:06:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9Q9bJCkfFGqRMAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 10:06:33 +0000
Date: Mon, 25 May 2026 12:06:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v2 01/10] affs: Drop support for metadata bh tracking
Message-ID: <20260525100632.GT12792@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260525085035.12891-1-jack@suse.cz>
 <20260525085821.769119-11-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525085821.769119-11-jack@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.50
X-Spam-Level: 
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	REPLYTO_DOM_EQ_TO_DOM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:mid,suse.cz:replyto,suse.com:email];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,gmail.com,mit.edu,mail.parknet.co.jp,suse.com];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:mid,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Mon, May 25, 2026 at 10:58:07AM +0200, Jan Kara wrote:
> AFFS did all the hard work of tracking metadata bhs dirtied for an inode
> but it actually never used this information as affs_file_fsync() just
> calls sync_blockdev() to writeback all filesystem metadata bhs. After a
> discussion with AFFS maintainer nobody cares about AFFS performance
> so let's keep this affs_file_fsync() behavior and just drop all the
> pointless tracking from AFFS.
> 
> CC: David Sterba <dsterba@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: David Sterba <dsterba@suse.com>
