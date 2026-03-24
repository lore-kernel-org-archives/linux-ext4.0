Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213563E556B
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774360570; cv=none; b=AnzmCdwggmhupTawGJhfUXkII/RrZFdG56l0GNOxK4F3WudbW/wswGWCPQY8gE6V7bSWrUyjfJGYch1YR+3TQN21jfCZEwoLF8beNgEnbRmmbyWQWWgESJMODCce0UdNbfEBb1Ts49VrGJBMuckLdDMvG4BrqRCy6Ygiv8POh9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774360570; c=relaxed/simple;
	bh=wzDPb14kr2pCImB6dQnkUULtJuvaamQvGvLe2QbM+BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aC/NZkV45+tOpE3TZ94/2f+4xSoyGeMMIDHPd1K7m3pQORIA3JdhZHRi4TlrKNgqIxAILabOkuZKcRZuES0siRosv/MPEvDdKabU86bU2YHo4blYug8LF4qe51ZPq/deUpLYMtvg5FftGyVdBKjUXAueivPjF17wXCOCSDJ1edw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d35LRlCs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4/38gvu3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d35LRlCs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4/38gvu3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d35LRlCs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4/38gvu3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d35LRlCs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4/38gvu3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 531635BCEB;
	Tue, 24 Mar 2026 13:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774360566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGZZOvd3k++L8qP6bDgWLb4hKlyIZ69YrTWaam0tH8g=;
	b=d35LRlCsY24Vrq7V0wAyZ2TNvsDHMdmtZZeAxGJvWOHHhkzKwuRo1CEKzv8uXiS7o4ASni
	/Yt22AvpvuKn+IK7JsxIRPICdsIwpetVvLZY4Pz4WtMbc4hUHQwW7usnh6qhiUmlZTBdJV
	BbCdWnJ20B8ASrH0tUjbPGiK38cnbXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774360566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGZZOvd3k++L8qP6bDgWLb4hKlyIZ69YrTWaam0tH8g=;
	b=4/38gvu3WyDzIXpYUKuGV/73uXWO55St5QmoEMCmkAGVT+B6OSFJc63p4ozufe33qH9O/o
	1ddL/7SRoGbeSUAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d35LRlCs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4/38gvu3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774360566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGZZOvd3k++L8qP6bDgWLb4hKlyIZ69YrTWaam0tH8g=;
	b=d35LRlCsY24Vrq7V0wAyZ2TNvsDHMdmtZZeAxGJvWOHHhkzKwuRo1CEKzv8uXiS7o4ASni
	/Yt22AvpvuKn+IK7JsxIRPICdsIwpetVvLZY4Pz4WtMbc4hUHQwW7usnh6qhiUmlZTBdJV
	BbCdWnJ20B8ASrH0tUjbPGiK38cnbXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774360566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGZZOvd3k++L8qP6bDgWLb4hKlyIZ69YrTWaam0tH8g=;
	b=4/38gvu3WyDzIXpYUKuGV/73uXWO55St5QmoEMCmkAGVT+B6OSFJc63p4ozufe33qH9O/o
	1ddL/7SRoGbeSUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4759A43E89;
	Tue, 24 Mar 2026 13:56:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kINhEfaXwmlLRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 13:56:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 059EEA0B32; Tue, 24 Mar 2026 14:56:01 +0100 (CET)
Date: Tue, 24 Mar 2026 14:56:01 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	libaokun@linux.alibaba.com, yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, 
	yukuai@fnnas.com
Subject: Re: [PATCH 09/10] ext4: move zero partial block range functions out
 of active handle
Message-ID: <dlxu3pvhlwgbggdt5lfgxltqrpeqj3vqhal3hkvbwkx7x3ydil@xnzcts5zve2l>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-10-yi.zhang@huaweicloud.com>
 <irkaodowvqmpug3moetmd75vssj6czh67qzuxs4v5vxe56qxz7@opkvl3apdpuk>
 <7fa8415e-199f-4e31-8b07-08f0f73d5b99@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fa8415e-199f-4e31-8b07-08f0f73d5b99@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,mit.edu,dilger.ca,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Rspamd-Queue-Id: 531635BCEB
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Tue 24-03-26 11:10:13, Zhang Yi wrote:
> On 3/24/2026 4:17 AM, Jan Kara wrote:
> > On Tue 10-03-26 09:41:00, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> Move ext4_block_zero_eof() and ext4_zero_partial_blocks() calls out of
> >> the active handle context, making them independent operations. This is
> >> safe because it still ensures data is updated before metadata for
> >> data=ordered mode and data=journal mode because we still zero data and
> >> ordering data before modifying the metadata.
> >>
> >> This change is required for iomap infrastructure conversion because the
> >> iomap buffered I/O path does not use the same journal infrastructure for
> >> partial block zeroing. The lock ordering of folio lock and starting
> >> transactions is "folio lock -> transaction start", which is opposite of
> >> the current path. Therefore, zeroing partial blocks cannot be performed
> >> under the active handle.
> >>
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > 
> > So in this patch you also move ext4_zero_partial_blocks() before the
> > transaction start in ext4_zero_range() and ext4_punch_hole(). However
> > cannot these operations in theory fail with error such as EDQUOT or ENOSPC
> > when they need to grow the extent tree as a result of the operation? In
> > that case we'd return such error but partial blocks are already zeroed out
> > which is a problem... 
> 
> Thank you for review this patch set!
> 
> Let me see, I believe you are referring to the cases where
> ext4_xxx_remove_space() in ext4_punch_hole() and
> ext4_alloc_file_blocks() in ext4_zero_range() return normal error codes
> such as EDQUOT or ENOSPC.

Yes, I was referring to those.

> In ext4_punch_hole(), we first zero out the partial blocks at the
> beginning and end of the punch range, and then release the aligned
> blocks in the middle. If errors occur during the middle of the
> hole-punching operation, there will left some data in the middle of the
> punch range, this is weird. Conversely, if the zeroization is performed
> in sequence, the result is zeroization at the front and the retention of
> valid data at the rear, which is acceptable. right? Besides, this
> problem seems not occur in ext4_zero_range() because
> ext4_zero_partial_blocks() is still called after
> ext4_alloc_file_blocks() after this patch.

Indeed, I've got confused. Your patch is fine. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
