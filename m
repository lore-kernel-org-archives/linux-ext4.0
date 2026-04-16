Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE6338F626
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 10:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776334574; cv=none; b=RLHQsYZx7buprFECwvlSlzTInS+c6e2gjq62BGkjc2AtUUqZhMVm4YSNfTI2ub3iu5V7i9/LC/3GvgtF7wmgxLAjPPWWtxBhm/K4eM9KiqsD4M4bt90oW0o+FrYlARxVSDTHvkX9ew25sjOI+qRB+yAZOUhRb0srjgfcK5SGI98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776334574; c=relaxed/simple;
	bh=fyghT8ME37ke8vvckm3H1nFwEQPuJVc0d+cZvvVHcDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYzp0kSckd/LsEWo5pRzkFAVN5yAOyJ2adBvUg3bTl1AtorSo2ww/3u+ezAgpq2O/N3lJk1VGW+kNQPo/VXPj9rioFjzydQRYozs6i4qdWKgbupxEboVxmbaflbfJ93MrXxscEb4GULaxCGS9siP9wghZiNhdRUOsn/O2RJQjCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mAOYj7x9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JawsL70j; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mAOYj7x9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JawsL70j; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mAOYj7x9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JawsL70j";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mAOYj7x9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JawsL70j"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 538225BD14;
	Thu, 16 Apr 2026 10:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776334570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=41EOIJzPGQo3xHK22HH0MfdYe4Gf2Sonn5V7avucpHM=;
	b=mAOYj7x9lmo7ALg6MaKYZF9ROfqKJszMoBQcfxj2evlvmF8un5ZrZfAoVtlxZTM3PtEQyU
	bFJpcBWppQSw8WzyaU7JJMlXcBp1resgfCGXi+66E5akXIJtD1EZnnTTXLEEFasGQQDsI9
	NWX9Wt+Hz3kMPctqmwHBiTftIyfdREU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776334570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=41EOIJzPGQo3xHK22HH0MfdYe4Gf2Sonn5V7avucpHM=;
	b=JawsL70jvBk2N1Q4xztPaic/sx85ArkcXsRLsTsrGChIpBTbsgCEb5yRh050K2G825SRJs
	P80v1SvPQf8F2DBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776334570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=41EOIJzPGQo3xHK22HH0MfdYe4Gf2Sonn5V7avucpHM=;
	b=mAOYj7x9lmo7ALg6MaKYZF9ROfqKJszMoBQcfxj2evlvmF8un5ZrZfAoVtlxZTM3PtEQyU
	bFJpcBWppQSw8WzyaU7JJMlXcBp1resgfCGXi+66E5akXIJtD1EZnnTTXLEEFasGQQDsI9
	NWX9Wt+Hz3kMPctqmwHBiTftIyfdREU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776334570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=41EOIJzPGQo3xHK22HH0MfdYe4Gf2Sonn5V7avucpHM=;
	b=JawsL70jvBk2N1Q4xztPaic/sx85ArkcXsRLsTsrGChIpBTbsgCEb5yRh050K2G825SRJs
	P80v1SvPQf8F2DBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4583C4BEE6;
	Thu, 16 Apr 2026 10:16:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uuHpEOq24GnpGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Apr 2026 10:16:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E9CC8A0B30; Thu, 16 Apr 2026 12:16:05 +0200 (CEST)
Date: Thu, 16 Apr 2026 12:16:05 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Jan Kara <jack@suse.cz>, Milos Nikic <nikic.milos@gmail.com>, 
	tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: enforce power-of-two default revoke hash size at
 compile time
Message-ID: <gq6n6m75h47lcr2hvmtlun7revnyf3bx3aanndglbh6djmrjcp@jmxhl7kf7bwu>
References: <20260413212724.127035-1-nikic.milos@gmail.com>
 <cjtirtqozud4keiu2fqi6sj3o4moimloti7celc4y44eejsn2y@i2tz72chmm34>
 <C27553C0-0A8E-4BCF-8C6F-1D62A69841C1@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C27553C0-0A8E-4BCF-8C6F-1D62A69841C1@dilger.ca>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,mit.edu,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

Hi!

On Wed 15-04-26 19:35:21, Andreas Dilger wrote:
> On Apr 14, 2026, at 06:59, Jan Kara <jack@suse.cz> wrote:
> > On Mon 13-04-26 14:27:24, Milos Nikic wrote:
> >> The jbd2 revoke table relies on bitwise AND operations for fast hash
> >> indexing, which requires the hash table size to be a strict power of two.
> >> 
> >> Currently, this requirement is only enforced at runtime via a J_ASSERT
> >> in jbd2_journal_init_revoke(). While this successfully catches invalid
> >> dynamic allocations, it means a developer accidentally modifying the
> >> hardcoded JOURNAL_REVOKE_DEFAULT_HASH macro will experience a system
> >> panic upon mounting the filesystem during testing.
> >> 
> >> Add a BUILD_BUG_ON() in journal_init_common() to validate the default
> >> macro at compile time. This acts as an immediate, zero-overhead
> >> safeguard, preventing compilation entirely if the default hash size is
> >> mathematically invalid.
> >> 
> >> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
> > 
> > Eh, if you modify JOURNAL_REVOKE_DEFAULT_HASH you should better know what
> > you are doing and if you mess up, then the kernel failing with assertion
> > isn't that difficult to diagnose. So sorry I don't think this "cleanup" is
> > useful either.
> 
> Jan,
> this is a BUILD_BUG_ON() so it won't cause any runtime assertion.

Yes, I know. But there is already a runtime assertion in
jbd2_journal_init_revoke() making sure the passed value is a power of two
which is verifying also other callers that aren't using
JOURNAL_REVOKE_DEFAULT_HASH value. I don't see a value in the *additional*
BUILD_BUG_ON when we already have that runtime check.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
