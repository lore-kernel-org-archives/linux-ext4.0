Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820453;
	b=SGyyKVeNPru4Qr2FFLQeM3NCFdMjGQA5niojjBT6Rxv8dq2s2CTgl1n2B3+YNitELZU+
	 uahT6zvdrkKZGm0RjVGLo8N2QJiLMrfLKoe4PDdeV7WFbPsBKUjyXLeavyqgL3yFrPyeq
	 wpdhoz28c2bnYNXs4KZWG1/uZ6pG5MinC1wcYTgXHnX6UraY4C1OhuyCXHmtJxpe/z9Ur
	 UXD8h3QiX/xfWyZG1UDZ5JmDBBtrLnAhUJXS0S3W+YL97b0gxLmrK3dGce91eL8bOUCMj
	 HnRoGURSEm9iHJ0e1WBaFxJLFhdj4CTyxc6rj7/pAchF6ugF+TuvYjntwreRR1sgj0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820453;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=1QxqEGu0EagkxxhYEfSH8rs0aIZCS0WxfJhGAHLRUmU=;
	b=Ab3O0+EMx/1OiBgMFMMXRuEyl6SDwvcHeSWRmb+TjHUhVjf0kdsy80w5oqNjhxELeBmP
	 jWs3yCZjGz+N14OmxWcnsFEPmRAGxY4Ravir6FzQAkE7JC82OukzlHPWHHLAwnKdtoTCs
	 xKNW4R9/IFTk//+6JKQEb4z3+IFNAnkXTGt5x9hZ6P5hyl9ygGWzKNZ6MHp+D0Eb4tdxn
	 xxZKtYRP7G6cjMixQeo2F9dosKqwTd9dFQXPmb0i1lV0nUBoC+pxmVx59uZA9rlfy9JD1
	 E9T3Ds/epbCm19SNbBOj8zTBEHzyy67g83toJzfV76Cn5BnzGaaBClF5mHLz2Yrmogg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=y2Z3MDIS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4rfZAZNz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lwqPcmAx;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SYKJhWKq;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9887C6070325;
	Wed,  4 Nov 2026 19:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9887C6070325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=y2Z3MDIS;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4rfZAZNz;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lwqPcmAx;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SYKJhWKq
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D15FF21E54;
	Wed,  4 Nov 2026 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793820451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1QxqEGu0EagkxxhYEfSH8rs0aIZCS0WxfJhGAHLRUmU=;
	b=y2Z3MDISNYZJM2eEmif55huREQxeSvvI/Tub4XKCNPqH/JzFFZKZt5y1JFhnZyy7X8FfkH
	TbSbFe8Menpcpp8b2F314j3eomEsPGHee5mJXP1R0iQUcjKE7cdl3kujJXVeZvbIESukn1
	l9HuHpRDjdk0v2tb/HaNhChlCP+wRXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793820451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1QxqEGu0EagkxxhYEfSH8rs0aIZCS0WxfJhGAHLRUmU=;
	b=4rfZAZNzauFSCkXoWdQvJtxR077iNLgNGbgxaHFRuwVKwNdwJmP3KpiUilqn1HiWpse8PV
	uqBYZo1inxWEHrAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793820450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1QxqEGu0EagkxxhYEfSH8rs0aIZCS0WxfJhGAHLRUmU=;
	b=lwqPcmAxbMdMPSPVASntLIb6Z7DMeg29rBrV5KP1U3aAJtFSQ2Eqbx4h7SzYtDLab/zVl1
	KFJZS7cXVW+BAnqiDMrGhTlcM0x8Cf2ALr4JsSGFUI77VY5FprRPlyMOBi9oGnTmy9le/7
	kOzw059PvD7EdxNF+EQU8b59DETvEPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793820450;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1QxqEGu0EagkxxhYEfSH8rs0aIZCS0WxfJhGAHLRUmU=;
	b=SYKJhWKqSXbQfE3UOZAxlCVoETCHaS0gXwKFNW8gSdOj+0MA7m4dANpUkpr+Frk470lqi2
	UArXpv9nGQ0QKSCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7C05134A5;
	Wed,  4 Nov 2026 19:27:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aW4FICKH62p7IQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 19:27:30 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2CCB0B494; Wed, 04 Nov 2026 20:27:26 +0100 (CET)
Date: Wed, 4 Nov 2026 20:27:26 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 8/9] fat: sync the inode in fat_free_eofblocks()
Message-ID: <3xsybk6czpjtovswdd46bvoug73ojrzshh5hkdjkfszyjl3x5h@j2l7dqxoorhi>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
 <oilqmzo3vpddohxp46x3pjzf3wtoebahirtjqmt3izdw6ua5iq@ghdbk27wuf5f>
 <87v76co5dv.fsf@mail.parknet.co.jp>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v76co5dv.fsf@mail.parknet.co.jp>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,vger.kernel.org,toxicpanda.com,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Thu 05-11-26 02:47:40, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Thu 29-10-26 14:28:23, Christian Brauner wrote:
> >> fat_evict_inode() calls fat_free_eofblocks() for a linked inode to give
> >> back the clusters that were fallocated past the initialized size. For an
> >> empty file that also resets the start cluster in the directory entry. It
> >> truncates the clusters and writes the inode with:
> >> 
> >>   sync_inode_metadata(inode, inode_needs_sync(inode));
> >> 
> >> Unless the inode is IS_SYNC that is WB_SYNC_NONE writeback. It copies
> >> the inode into the directory entry buffer, marks the buffer dirty and
> >> sets I_METADATA_WRITEBACK. Then the inode goes away and with it the only
> >> thing that would have told a later fsync() that the directory entry
> >> still has to be written.
> >> 
> >> FAT doesn't have that problem. Its buffers are tracked on the FAT inode
> >   ^^ exFAT??
> >
> >> and fat_file_fsync() writes them out on every fsync() of any file on the
> >> filesystem.
> >> 
> >> So after the next fsync() the clusters are free on disk while the
> >> directory entry of the empty file still points at them. If another file
> >> reuses them and the machine crashes before the directory entry makes it
> >> to disk, the two files share clusters. That's the corruption the comment
> >> in fat_free_eofblocks() is about.
> >
> > Correct, but that does not violate anything AFAICT. fsync(2) promises data
> > is reachable (which it is), not that the fs metadata is all
> > consistent.
> >
> > For non-journaling filesystem you need fsck for such guarantee. And I know
> > I'm a bit obtuse here but the change results in a synchronous buffer write
> > on each eviction of inode that has preallocated blocks which will be a
> > noticeable performance regression for some usecases. Probably Ogawa should
> > decide whether this change is acceptable or whether we play fast and
> > loose... Ogawa?
> 
> In my understand, the result of this change only affect to crash case
> (FAT has no guarantee about it with non-sync mode). And this doesn't
> lost data actually - lost some free blocks (maybe fsck would be
> recoverable).

The result won't be lost free blocks but rather reference from inode to
already freed blocks after a crash (and thus possibility of a block used by
two inodes). So it is definitely an unpleasant filesystem corruption after
a crash but as you say there are really no guarantees without fsck...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
