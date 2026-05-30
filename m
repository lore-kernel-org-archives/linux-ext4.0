Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F88D384CFD
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 09:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780134764; cv=none; b=cxqDPCL7LAk5dxa5KC8chjkTvnywnWSczg7bhezBodVMu1B/WjptvRSE1EJNQlFrWLpjDjIySCmQG1ygCM/jgjOJhA+MHD7BZmdW7q2dYBXOKd3CK0oG/+JoiLsUJHh4gfVacgXJUX5K5REVNtAtnf8E8pXYj5/W4Zlx0yi1E7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780134764; c=relaxed/simple;
	bh=7LTvUPpgj7FtxCsP+69flEvGN61sEKQCF2Gs5dq4vo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmH+gGAH50sQC2u1hj8i6ucC/ArvrwO8IE/zt4s3PjYSIu6VXg6fF8XEiA4mJUbOfD3Z1Qi0ep/DDzPSF+C5fzow0hfTCF0apH9d/J25Qajp41ujx3hYk6HXJ9hKJgY8O1vtFfWSNy2/qMweWXEpC/qhy9xSlI6NA4U/AfDc7cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jA4EviVV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NZobBrFt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jA4EviVV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NZobBrFt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jA4EviVV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NZobBrFt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jA4EviVV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NZobBrFt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 714B067077;
	Sat, 30 May 2026 09:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780134761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EYnUBZEOsY3m7ye/Hc5VRwl5Hw48WKq6WThDseY/SGM=;
	b=jA4EviVVG5JdKvkH7C5VvCQq0Bw9idtAeNJwsdcFTDgv3ElT/At9iPJNxJ6DWbphNjetz8
	VSd4ryLPp3n2kVGQamD8LbH3vCwc0ZVQSmuTA2z4Mr3PX/8lirngn5LjHdEOwi8T1zf9h6
	eklgxfzFuNNkHObI4vb+yslE6QRRHog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780134761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EYnUBZEOsY3m7ye/Hc5VRwl5Hw48WKq6WThDseY/SGM=;
	b=NZobBrFtSH8JdwsmUpCrlju3a2p/N7YDFeuv2o+mdDj2aet5GkzhX3s6StNej2gMkKcgBr
	VwQyqi2l+NL5RkDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jA4EviVV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NZobBrFt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780134761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EYnUBZEOsY3m7ye/Hc5VRwl5Hw48WKq6WThDseY/SGM=;
	b=jA4EviVVG5JdKvkH7C5VvCQq0Bw9idtAeNJwsdcFTDgv3ElT/At9iPJNxJ6DWbphNjetz8
	VSd4ryLPp3n2kVGQamD8LbH3vCwc0ZVQSmuTA2z4Mr3PX/8lirngn5LjHdEOwi8T1zf9h6
	eklgxfzFuNNkHObI4vb+yslE6QRRHog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780134761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EYnUBZEOsY3m7ye/Hc5VRwl5Hw48WKq6WThDseY/SGM=;
	b=NZobBrFtSH8JdwsmUpCrlju3a2p/N7YDFeuv2o+mdDj2aet5GkzhX3s6StNej2gMkKcgBr
	VwQyqi2l+NL5RkDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B89B779A7;
	Sat, 30 May 2026 09:52:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vl1IFmmzGmp3VQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 09:52:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EC8B0A0EBD; Sat, 30 May 2026 11:52:32 +0200 (CEST)
Date: Sat, 30 May 2026 11:52:32 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Bohdan Trach <bohdan.trach@huaweicloud.com>, 
	Theodore Ts'o <tytso@mit.edu>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, mchehab+huawei@kernel.org, bohdan.trach@huawei.com, 
	lilith.oberhauser@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ext4: avoid RWM atomic in
 EXT4_MB_GRP_TEST_AND_SET_READ
Message-ID: <rfb5wf4nrgu3ahfmc4wfasgrmtgsj3ig3oklthu47kkohr7qpq@2xcmyypqs3xk>
References: <20260527090329.2680170-1-bohdan.trach@huaweicloud.com>
 <20260527090329.2680170-2-bohdan.trach@huaweicloud.com>
 <2D89BCA2-8317-4399-B926-7F5094236C1C@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2D89BCA2-8317-4399-B926-7F5094236C1C@dilger.ca>
X-Spamd-Bar: +
X-Rspamd-Queue-Id: 714B067077
X-Spam-Flag: NO
X-Spam-Score: 1.29
X-Spam-Level: *
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.29 / 50.00];
	SEM_URIBL(3.50)[huaweicloud.com:email];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	MX_GOOD(-0.01)[];
	R_DKIM_ALLOW(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[huaweicloud.com,mit.edu,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[huawei];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,huaweicloud.com:email,suse.com:email]

On Wed 27-05-26 13:46:43, Andreas Dilger wrote:
> On May 27, 2026, at 03:03, Bohdan Trach <bohdan.trach@huaweicloud.com> wrote:
> > 
> > EXT4_MB_GRP_TEST_AND_SET_READ uses test_and_set_bit function which
> > issues an atomic write. This can cause high overhead due to cache
> > contention when multiple threads iterate over groups in a tight loop,
> > as is the case for ext4_mb_prefetch(). We have seen this to be a
> > problem for Kunpeng 920b CPUs which uses a single ARM LSE instruction
> > for this purpose.
> > 
> > Avoid this unconditional atomic write by testing the bit first without
> > changing its value. This is OK for this use case as this bit is never
> > unset.
> > 
> > This change significantly reduces costs of fallocate() operations which
> > trigger linear group scans on large multicore machines where
> > test_and_set_bit issues an atomic write operation unconditionally.
> > 
> > Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>
> 
> Thanks for the patch.  Definitely the benchmarks in the 0/2 email show
> significant gains for the Kunpeng system, and reducing contention makes sense
> as core counts increase and the likely case is that the bit is already set.
> 
> That said, I wonder if this should (also/instead) be put into test_and_set_bit()
> itself, or add test_and_unlikely_set_bit() or test_and_rarely_set_bit()
> (or similar) optimized for the case where the bit is likely to already be set.

Well, it is a common enough pattern in the kernel that it might be worth it
but I'd say that's a separate effort spanning much more areas.

> I see in your benchmarking that there is not "apples-to-apples"
> comparisons for ARM(Kunpeng) vs. AMD on the same storage.  The storage
> hardware and space usage is different for each test run, and the ARM
> numbers show only marginal gains and more negative than positive results
> at all thread counts:
> 
> > Benchmark on an existing file system for AMD 9654 (15T FS, 6% space
> > used), kernel 7.1-rc3. This shows the performance impact on a mostly
> > free file system.
> > | thr. |  base | patched |    improv. |
> > |      |  perf |    perf |            |
> > |------|-------|---------|------------|
> > |    1 | 30901 |   31191 | +0.9384810 |
> > |    2 | 50874 |   50504 | -0.7272870 |
> > |    4 | 66068 |   64108 | -2.9666404 |
> > |    8 | 63963 |   61927 | -3.1830902 |
> > |   16 | 47809 |   47044 | -1.6001171 |
> > |   32 | 42441 |   42326 | -0.2709644 |
> > |   64 | 39773 |   39929 | +0.3922259 |
> > |  128 | 37065 |   36413 | -1.7590719 |
> 
> The performance reduction might be caused by the now double memory access on
> AMD that is only adding overhead on that CPU implementation?  It would be useful
> to see the testing on Kunpeng vs. AMD/Intel on the same storage device/usage.
> 
> That would tell us if it is more appropriate to optimize this in the aarch64
> test_and_set_bit() rather than in ext4.

Well, even for x86 test_bit() || test_and_set_bit() is significantly
cheaper when the cacheline is hot because test_and_set_bit()
unconditionally invalidates the cacheline for all the other CPUs. And the
cost of additional test_bit() for something that is already in L1 cache is
very small (a few cycles) so I think the above differences are either pure
benchmarking noise or due to changes in code alignment or similar.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
