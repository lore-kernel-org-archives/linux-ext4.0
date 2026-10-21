Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593282;
	b=2sCQBnIQuA1wSorzSPut1Se1RtmvWstNB7yjDk2BL0ezfvVNz25vC5WoR4PkY0yvlZWW
	 vX18rqR3WnWVANDWZCiIjumUx0B8dlaXXTEFTCKBeRcd3KQknyL/tCXABC8Vn2DfKOqi4
	 f27g6cqxfUvbd6OcL0p5tlGiW1wIrki5uJjZzRfgV1mIi1lZSX5jy71z0iLBDeYDhYEAI
	 iQk551C+IQbvotUKU+JumcJijP16Ya3aL3SYVVq0R9x+zt+yrwNHj9IX2a1pwExUKKozW
	 sM3wBaz/XDy8vgCeeF1sEnNl6/YjE817K8di3tIz8xX0Za0MxMed8JESbeY5we0AK8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593282;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=E+sp2M17D8mqOV4TLhVproL3957AJ3R6gUvKhBaFuzk=;
	b=b5Dt36whb4mVYVMCQWLOVT2Rxz8T3vlX85To7Jrnm0zM+kZ6QVYqVQ1o/CJdC88LAyEg
	 EaKa7VgoI7+rZQjh0fa9VqKZaU/py6ILCYYCkOprIsQLpqBiMnHFvVCA3TW8oPWH0hHc1
	 t6DVhMnUoV53kU7ng5AA6vfNFJuKo9DSwr3ev6RJg9iCeBBDjbhhIczk+wgVvqoWFT0ya
	 3BTYoVo3KfpWKBndNXlR2MkR2rdnHN6ScfJVb4e1fG0GkLw3+F3WjkqgDHyoXE5kku3Id
	 GX27iwUB/CQmd8Ey7vGxVqoY3s6Gkl0MtBeAa7Q7BfqNyVFu6bHw8UeGgUSGt4TDSVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vyUUg7Vg;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pC0XQbR;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vyUUg7Vg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pC0XQbR;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84994606A31E;
	Wed, 21 Oct 2026 14:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84994606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vyUUg7Vg;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pC0XQbR;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vyUUg7Vg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+pC0XQbR
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB98A2201A;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+sp2M17D8mqOV4TLhVproL3957AJ3R6gUvKhBaFuzk=;
	b=vyUUg7VgCazUSTzjE5X2Yv48RKaA/oP1n9kZNU8LsnE7vLRItjm9BkDmuLz0Jy6ACZDPSp
	bBwJW1eMf6iKM6N9PD4Otn143b4KEb+igcZK2LrPc7D3b/s+H2QRwVISrpu1gR6dXfXlxM
	PH0yuTC4WEZiEjEneiXcIP4ec0B/7kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+sp2M17D8mqOV4TLhVproL3957AJ3R6gUvKhBaFuzk=;
	b=+pC0XQbRZ4JhRAFaxnB8rMnDsYCGBLKWklK874VOuNUO22LOoWJ4f/1sSs+cncT1w91O4/
	NBJxFMvtNN+2CWCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vyUUg7Vg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+pC0XQbR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+sp2M17D8mqOV4TLhVproL3957AJ3R6gUvKhBaFuzk=;
	b=vyUUg7VgCazUSTzjE5X2Yv48RKaA/oP1n9kZNU8LsnE7vLRItjm9BkDmuLz0Jy6ACZDPSp
	bBwJW1eMf6iKM6N9PD4Otn143b4KEb+igcZK2LrPc7D3b/s+H2QRwVISrpu1gR6dXfXlxM
	PH0yuTC4WEZiEjEneiXcIP4ec0B/7kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+sp2M17D8mqOV4TLhVproL3957AJ3R6gUvKhBaFuzk=;
	b=+pC0XQbRZ4JhRAFaxnB8rMnDsYCGBLKWklK874VOuNUO22LOoWJ4f/1sSs+cncT1w91O4/
	NBJxFMvtNN+2CWCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F82313523;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WlBQFH/N2GoQWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 21 Oct 2026 14:34:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6ADA7A1419; Wed, 21 Oct 2026 13:13:47 +0200 (CEST)
Date: Wed, 21 Oct 2026 13:13:47 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Theodore Tso <tytso@mit.edu>, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] ext4: phase out inline data write paths for
 regular files
Message-ID: <h7bgkt2dbd54vjojph66d6c4kl77swtglnq26vz7irjoexb6wv@7oapqajt7j7m>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
 <amdhvSR2YL-3AJKS@mit.edu>
 <2b7e4668-9679-42e5-b71d-14b49e702624@windriver.com>
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
In-Reply-To: <2b7e4668-9679-42e5-b71d-14b49e702624@windriver.com>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: BB98A2201A

Hi!

So I was thinking about this for unrelated reasons and I think the
following plan / design should work.

On Wed 29-07-26 11:12:17, Zhou, Yun wrote:
> On 7/27/26 23:03, Theodore Tso wrote:
> > I agree that inline_data feature has been a persistent source of bugs,
> > and is relatively minimal for data files.  Howvever, the regular files
> > that are small enough to support inline data come really boring filess
> > where we're not doing the really stressful things that fsx, fstress,
> > syzbot, etc. do to punish the file system.
> 
> The "boring file" argument assumes benign workloads. Under adversarial
> conditions (which CVE assignments reflect), any race window is exploitable
> regardless of how unlikely it is under normal use.

I agree we have to keep things as simple as possible. Still what Ted
suggested below should be mostly achievable with quite simple design.

> > So what if we had a mechanism where we're using delayed allocation, if
> > the are no open file descriptor, so races and deadlocks can be
> > avoided, and in that case, we can write it as an inline regular data
> > file.  Otherwise, we back it using a regular block.  I think this
> > would get us 95% of the benefits of inline data files, with much less
> > of the complexity cost.
> 
> This is an interesting approach and could potentially work. That said, new
> mechanisms often introduce new race conditions. Do the minor gains truly
> justify the added complexity? No major distribution enables inline_data by
> default. The feature has been available for 14 years and remains opt-in,
> suggesting the benefit has never been compelling enough for general use.
> 
> It's not worth introducing new complexity for a feature that has no actual
> users and keeps introducing bugs. However, I am open to investigating this
> further in the hope of finding a good balance.

So I believe following design should be simple and achieve what Ted wants.
What I'd do is that without delalloc, we'd do practically what you have
implemented - convert inline data on first write(2) (in .write_begin) or on
.page_mkwrite under the folio lock. In fact we could just prepare the write
as if inline data was not existing and just destroy the inline_data xattr
once the preparation of the write succeeded. No extra special code needed.

When delayed allocation is enabled, again both .write_begin and
.page_mkwrite would prepare the write as if inline data was not existing
(i.e., reserve delalloc blocks as normal).  Then in writeback code once we
have folios locked and are mapping underlying blocks, if the data (based on
i_size) fits into the inode, we'd writeback it as inline_data xattr. If it
doesn't fit into the inode (writing xattr fails), we'd just delete the
existing inline_data xattr and continue with normal writeback. Again this
will require very little additional code.

Finally, truncate, in addition to operating as without inline data has to
also appropriately shorten inline_data xattr if it exists, but again this
should be very little code.

Thoughts?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
