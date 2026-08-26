Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C332C404BF9;
	Wed, 26 Aug 2026 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787763334; cv=none; b=h+ANiXnxZWZnq8Cn0EJKVOuGuk2Rlbw4nZWNPh23EPP8579goje3RHq/6vbGboknRpzdwm/y7tnTcVLCDnMBKbs0DN2XR3PLFsgaOJaibk1YjrihujNiHizxK8ny9ZxXTtaBWZ/qx70zgCPihYc3PbSSJcRIsNjX8Yeb81C26X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787763334; c=relaxed/simple;
	bh=xH0bNrp+oSSR+3EXk15d7szlJ/i/lhji1zrMK5wo9Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxUWagyyDtqkEi7m6HgGShRcBe9VMkWMa0up/XIqZMdseo6vbNf+UDuDsOSAfhj7g+maz9xxkspDVp66K8euiFPqfBHw7WUfRnK9Ems/mmWGVy5Ox6W0ubLzSfB8yHt0E0d721m/vB2zsSpAV1POPbaJcCjmYHZ+oEkJ2tWzxJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fxux6CNU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RoNmb1ei; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gnsFsjID; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XQnJpTVO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fxux6CNU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RoNmb1ei";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gnsFsjID";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XQnJpTVO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F8281F80E;
	Wed, 26 Aug 2026 16:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787763313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsrHi5T5oUS0tTADH/XkrMBgLtWoXpF2+ghPWlgvljQ=;
	b=fxux6CNU0gIxLL3GuhzelqQXo/cYjfMaUVGtgup93NjfHIwgzKrntMUxsQ7Ir9NdEmALpA
	2BOKGQ5LWuXjf+HHQxQgsxi3PK36u0diQ7NPZ7x9zoreYbGf7cfITdNasQ/unlj4IVEGZA
	i0vrxPsI14h+uC6LohHzpMeeBfyzFCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787763313;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsrHi5T5oUS0tTADH/XkrMBgLtWoXpF2+ghPWlgvljQ=;
	b=RoNmb1ein/SQEIDWZYbqNkYxTWA+zGMHkTen9HRbRnpMD3ahEnUbDtDmmVbXrPIN0cwZ68
	AFeW5LIktOmGvuBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gnsFsjID;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XQnJpTVO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787763309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsrHi5T5oUS0tTADH/XkrMBgLtWoXpF2+ghPWlgvljQ=;
	b=gnsFsjIDMxPevBY7kmmrcbWrtik+uH3IPqDXzPK4OjqUTDMQ+pfVgrURYkGLUfjXaulE5r
	lva/cGm0z3w4qD3V6EDU8e0LlmcmLGzWfrq8xG0KXrYrmi/136xwuK1TpDcVYnsQxpQ0xK
	cv/N9+cwCYEocqzgAfXRSFPlUCHpWt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787763309;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsrHi5T5oUS0tTADH/XkrMBgLtWoXpF2+ghPWlgvljQ=;
	b=XQnJpTVOI9PFq6WPaDGrKU+X+iEAM11qJIeN9n8Li21/ylSRa6b+RujrdSVNakVlydQUB6
	s6R7j64HUI/g9ZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BDCA13354;
	Wed, 26 Aug 2026 16:55:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CWxuBm0aj2onNgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 16:55:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B4939A13A7; Wed, 26 Aug 2026 18:55:04 +0200 (CEST)
Date: Wed, 26 Aug 2026 18:55:04 +0200
From: Jan Kara <jack@suse.cz>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, 
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "jack@suse.cz" <jack@suse.cz>, 
	"yi.zhang@huawei.com" <yi.zhang@huawei.com>, "ritesh.list@gmail.com" <ritesh.list@gmail.com>, 
	"libaokun@linux.alibaba.com" <libaokun@linux.alibaba.com>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>, 
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"amonakov@ispras.ru" <amonakov@ispras.ru>
Subject: Re: [PATCH] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Message-ID: <wffv3oy43ss7i3dd5td4he6bqwex2d56pbyie2spxludkr5vqe@d3lrjxx4a2gk>
References: <CGME20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>
 <20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826052446epcms2p5a415be5fbfe23b8a32786f0ae6d05aea@epcms2p5>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2F8281F80E
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,huawei.com,gmail.com,linux.alibaba.com,linux.ibm.com,vger.kernel.org,ispras.ru];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,samsung.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed 26-08-26 14:24:46, Daejun Park wrote:
> When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
> it reports by counting the empty subtrees under 'partial' in the on-disk
> indirect tree.  That count knows nothing about delayed allocation, so a
> range holding delalloc data that has not been written back yet is
> reported as a plain hole.  The extent-mapped path does not have this
> problem: ext4_ext_determine_insert_hole() trims the hole it found at the
> first delayed extent before returning it.
> 
> ext4_map_blocks() consults the extent status tree before it calls into
> the mapping layer, so a query that starts exactly on the delayed block
> still finds it.  A query that starts earlier does not, because the hole
> reported for the earlier block already spans the delayed one.  On a
> 4k-block filesystem, lseek(SEEK_DATA) from offset 0 on a file whose only
> data block is at logical block N and is still dirty returns:
> 
>   N = 0..11      direct blocks                 N << 12
>   N = 12         first single-indirect block   N << 12
>   N = 13..1035   inside that indirect block    -1 ENXIO
>   N = 1036       first double-indirect block   N << 12
> 
> Blocks 12 and 1036 survive because the query lands on the delayed block
> itself.  Blocks 13..1035 are swallowed by the 1024-block hole reported
> for block 12.  fiemap loses the same data for the same reason.
> 
> An ext3 filesystem mounted as ext4 hits this during ordinary use: ext3
> inodes stay indirect mapped, while mount -t ext4 turns on delayed
> allocation even though mounting ext3 with -o delalloc is explicitly
> rejected.  install(1) from coreutils uses SEEK_DATA to locate data in
> its source file, so installing a sparse file that has not been written
> back silently produces a destination of the right size holding none of
> the data:
> 
>   truncate -s 1G img && mkfs.ext3 -F img && mount -t ext4 img mnt
>   echo | dd of=mnt/src bs=1 count=1 seek=64K
>   install mnt/src mnt/dst
>   cmp mnt/src mnt/dst        # differ: char 65537
> 
> Trim the hole at the first delayed extent, the way the extent-mapped
> path does.  ext4_es_find_extent_range() does not clip the extent it
> returns to the queried range, so skip one that begins at or before
> m_lblk and clamp the result against the hole already found.
> 
> With this the sweep above returns N << 12 for every N, while the
> nodelalloc and extent-mapped controls are unchanged.  generic/225,
> generic/285, generic/286, generic/436, generic/448 and generic/490 pass
> on ext4 made both with and without the extent feature.
> 
> Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
> Reported-by: Alexander Monakov <amonakov@ispras.ru>
> Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru/
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Thanks for report and the fix! So I think a better fix here is to lift most
of the logic of ext4_ext_determine_insert_hole() into a helper function
like:

ext4_lblk_t ext4_determine_insert_hole(struct inode *inode,
				ext4_lblk_t hole_start, ext4_lblk_t hole_len)

and then use it from both ext4_ext_map_block() and ext4_ind_map_blocks().
That avoids the duplication and also have all the comments regarding
various special cases (like delalloc extent covering map->m_lblk) in one
place.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
