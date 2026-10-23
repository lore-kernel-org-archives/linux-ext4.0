Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792743380;
	b=i1px9Gi5MrMhAaQS559Hvfy+adKQJjVZtmqwvW/8p9ski00bc9F35gLLQuggi6ppLbvb
	 eInqc2zt2KwFROk0Ebe0FOXPY4r+86feS3iv4cfZjLrJdfX05sh74RjJtxHyshSGRKfPr
	 ARe990Qdw7/2x6WjWblTBZoeAi854RqW9DYBgA8aOqByn1ADWzGtDE+5mImmK9fxMI930
	 CmNzXIIbsMWUZ+RG0fu/Z2V/MoZ1U9o0lnk5pKrb6cu7YLm2LocarA+gowtXEraPTmWJf
	 k/tFtGu6tuKvfKsPaaGm2/G+OtFgpiO407gdty3JTHGsFK4a9onJNtAYgw9+xIZxd7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792743380;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=Own+XDkrcsa0rAqcKruFpM5LMPUrTaQ78MTF+e2vtIw=;
	b=ckhFsKow0G8wzPDi1pB0n0NX3NXYqZ8VFgfSqDxboxzKifL3GTdMz4Y56hLbYvkOQ5Ck
	 H0nLCaacCb/ZfwDGsuupl5eYHaWFqK4PkDyV+ZG0GBmFeZEaNyN9/6Pf1VHnhq1yfKWz+
	 SsIvsT9yAtcUTDWNMLioUFbtWmpaD+15lrkSjhvoJ56v5WcPwpJ4SY0vnSe8tHdIAO5Ny
	 x0913t2XWZP3/dtTS2tPcygBzS1l88qxn7O+/eJ/FHQUY0mKI/3KQ9qTY3nTTOMNKP1to
	 /WP2JtZQ+qikNsVYf9sxPVk+s4ieNcUvmHwK7I/tB/QJO6ro2cxu5km9wVMnqiqgAjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rLG79M9C;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LU4qWsqy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rLG79M9C;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LU4qWsqy;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BE8606A31B;
	Fri, 23 Oct 2026 08:16:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5BE8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rLG79M9C;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LU4qWsqy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rLG79M9C;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LU4qWsqy
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C6471F385;
	Fri, 23 Oct 2026 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792743376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Own+XDkrcsa0rAqcKruFpM5LMPUrTaQ78MTF+e2vtIw=;
	b=rLG79M9CiCwVLyOXNkk5o0ii2Lm4C3Z8/sXrxAWuOkOtiuCpiJO8Ceq6wXH7P4AS09pNPD
	VsRZirmu/VYnwdg7Nc7op+FdjGJ2xvDqRiYL9ExEPV8mOvAFLO6y5lzfuZgLXKwoJGmVbP
	NAklCfPvM9WSnbLSbDXEcgLi4eG0rc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792743376;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Own+XDkrcsa0rAqcKruFpM5LMPUrTaQ78MTF+e2vtIw=;
	b=LU4qWsqy9gqPGbxIi+P8F9q2yfefzBzWfU3JS8J+09I3WPaaVUBcV/hDG5klyOahQirQGH
	5jP57FV+chjar3CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rLG79M9C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LU4qWsqy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792743376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Own+XDkrcsa0rAqcKruFpM5LMPUrTaQ78MTF+e2vtIw=;
	b=rLG79M9CiCwVLyOXNkk5o0ii2Lm4C3Z8/sXrxAWuOkOtiuCpiJO8Ceq6wXH7P4AS09pNPD
	VsRZirmu/VYnwdg7Nc7op+FdjGJ2xvDqRiYL9ExEPV8mOvAFLO6y5lzfuZgLXKwoJGmVbP
	NAklCfPvM9WSnbLSbDXEcgLi4eG0rc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792743376;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Own+XDkrcsa0rAqcKruFpM5LMPUrTaQ78MTF+e2vtIw=;
	b=LU4qWsqy9gqPGbxIi+P8F9q2yfefzBzWfU3JS8J+09I3WPaaVUBcV/hDG5klyOahQirQGH
	5jP57FV+chjar3CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2964133F6;
	Fri, 23 Oct 2026 08:16:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g09uKs8X22p7eAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 23 Oct 2026 08:16:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 55361A1415; Fri, 23 Oct 2026 10:16:11 +0200 (CEST)
Date: Fri, 23 Oct 2026 10:16:11 +0200
From: Jan Kara <jack@suse.cz>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, yi.zhang@huawei.com, dave.hansen@linux.intel.com, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: do not advance i_size on a buffered write that
 copied nothing
Message-ID: <yicmd2fqtfqfl7fmyvkrwwnewk7ahbzzvtceeowa7k5w6v3hbn@lmuqp4a2ojmb>
References: <20261009044656.1993196-1-hengyul@cs.unc.edu>
 <34dtkdstf5yxg2ulinnh4hocc53gz35ij6k62egi2ykgpyc3a5@zuxt6doiajwq>
 <20261022142911.1490979-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261022142911.1490979-1-hengyul@cs.unc.edu>
X-Rspamd-Queue-Id: 2C6471F385
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,linux.intel.com,linux-foundation.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Spam-Score: -11.51

On Thu 22-10-26 10:29:11, Hengyu Liang wrote:
> Hi Jan,
> 
> On Thu 22-10-26 11:48:35, Jan Kara wrote:
> > I agree with the problem but first, Ted has merged rewrite of ext4
> > buffered IO path to iomap your fix would very likely need rebasing, and
> > second:
> 
> Thanks for the review.
> 
> In the ext4 dev branch, the iomap buffered path is only used with the
> new buffered_iomap mount option, and it faults the source in before
> ->write_begin(), so it does not have this problem. The default
> buffer_head path still does: on 8c4f6e337634, a 100-byte file still
> has a size of 1048586 after a failed pwrite() at 1 MiB + 10, sync and
> remount. The patch applies to the dev branch without changes, and I
> will base v2 on it.
> 
> > this is wrong and would leak delayed allocation reservations AFAICT. You
> > should just use ext4_truncate_failed_write() like e.g.
> > ext4_da_write_begin() does on failure.
> 
> I don't think it leaks. ext4_es_remove_extent() gives back the
> reservation of the delayed blocks it removes through
> ext4_da_release_space(), which ext4_iomap_punch_delalloc() also relies
> on in the iomap path.

You are right. I'm sorry for my confusion.

> To check this, I ran my earlier tests on the dev branch with the patch
> as sent and with the helper replaced by ext4_truncate_failed_write(),
> plus a test on an image with the quota feature that reads the user's
> quota usage (which includes reserved space) and the free block count.
> After a failed write past EOF, both versions bring both numbers back
> to their values before the write, and nothing is logged at umount.
> Without the patch, the same case keeps 64 KiB reserved until the inode
> is evicted.
> 
> I did not use ext4_truncate_failed_write() because since 665575cff098
> this path is also taken by ordinary writes. When the source page is
> not faulted in yet, the first copy fails, ->write_end() sees
> copied == 0, and generic_perform_write() faults the page in and tries
> again. ext4_truncate_failed_write() would then run ext4_truncate() for
> each such write that starts past EOF, and that frees blocks
> preallocated past EOF with FALLOC_FL_KEEP_SIZE, even though the write
> succeeds right after. In my test, a 64 KiB write from untouched
> anonymous memory into a file with 1 MiB preallocated past EOF leaves
> st_blocks at 2056 with the helper, but drops it to 136 with
> ext4_truncate_failed_write().

OK, that's a good observation. Let's keep your special function then.
Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
