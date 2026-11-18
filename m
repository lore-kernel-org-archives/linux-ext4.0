Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795000552;
	b=vN42M5MswnyJbb05syUvv/WEm1+UDvqDSBDb4yeR+SmrryoTSYR8WTCZtGFuhBLwUgWl
	 HxG9yktzXj7hvXQrXVUqJjnaOB4va6c2cv1njopWPspmm9GHacWtD562D9be65okSmWCu
	 MrkWxlYwPu/4oVhW8EHdAuF67tS037xekzBf3H68dR88yka6wPZe1+TXUbMfZvYnoeSyU
	 m1ITOYLhnKA5RpwZ4XRQlkPBujCa0xTjvnvO5Bl4WAx2+wdLU9BTiDHgafgw7pKdvnBrW
	 ongdNzerNWePEhdp9oPyRj9gj0ARkrw7yWZr8UfG1Bz1oy8K5a8HPoKSzVBQap4sFSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000552;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=FFCp4KDT2LcWcGOoxahgST59aYtC1T0hU0v/3EFzywc=;
	b=j0hAWGIralJIzM5FJ9ExXwFzZGEv5fFFm4v2LLRNs3DlsyaTRRxmd6xWpQjE5aDg2WTy
	 RU7AwThia5oEAs4PYUt/5Tp1HTPBaB0rviy+BvHkRnvbGCZkN6ygJTjtBVK3flNvVGE0I
	 JgQbVirI60j+aOey+pJQAEMRsdC4FfvxqiWtLSthQXdCrUE6y451qbegTVN8MObTw3BdJ
	 tdW42l3/uOpToNlBH5lPAqFc0pDgRkFQTssinyEhu1ur2QMvSJbg003cGhTOQb+XbFur8
	 jXsCBxH8muZnNSJZFfbiLau8bcfCQ8MZI11QZ9zaOmjodIMMh5ijJaGFEdg9HHxD5GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Yse+GBIg;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvK3ADAO;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Yse+GBIg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvK3ADAO;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB34606A32F;
	Wed, 18 Nov 2026 11:15:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CB34606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Yse+GBIg;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvK3ADAO;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Yse+GBIg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lvK3ADAO
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A92FE1FB67;
	Wed, 18 Nov 2026 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795000549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFCp4KDT2LcWcGOoxahgST59aYtC1T0hU0v/3EFzywc=;
	b=Yse+GBIg+n7Sp/Yubh70gI36P41cCiW9uL9zFe68ACj0ZIDkZZSiCPYO0XHaQBioFVmZCa
	glWDb1eBxbwrBucV6pJz3jZZLR40N8+8iNM/hLed3R60QUImLr8wd1WX9sHy3hVI6o6Nh3
	IMQLxkSqcmJO2b3h2GQeTpoVEO3JTco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795000549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFCp4KDT2LcWcGOoxahgST59aYtC1T0hU0v/3EFzywc=;
	b=lvK3ADAOGQT7D2kpGGiLCEJkvJo+w5L2uKkmYiLL7fEUn+M1FG+fRxr1/Y4X6b4qhbf3UB
	d89NynRIctWYS/CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795000549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFCp4KDT2LcWcGOoxahgST59aYtC1T0hU0v/3EFzywc=;
	b=Yse+GBIg+n7Sp/Yubh70gI36P41cCiW9uL9zFe68ACj0ZIDkZZSiCPYO0XHaQBioFVmZCa
	glWDb1eBxbwrBucV6pJz3jZZLR40N8+8iNM/hLed3R60QUImLr8wd1WX9sHy3hVI6o6Nh3
	IMQLxkSqcmJO2b3h2GQeTpoVEO3JTco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795000549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFCp4KDT2LcWcGOoxahgST59aYtC1T0hU0v/3EFzywc=;
	b=lvK3ADAOGQT7D2kpGGiLCEJkvJo+w5L2uKkmYiLL7fEUn+M1FG+fRxr1/Y4X6b4qhbf3UB
	d89NynRIctWYS/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 825181334C;
	Wed, 18 Nov 2026 11:15:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Li/QF+WI/WqdcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 11:15:49 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0D5802500B; Wed, 18 Nov 2026 12:15:49 +0100 (CET)
Date: Wed, 18 Nov 2026 12:15:49 +0100
From: Jan Kara <jack@suse.cz>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com
Subject: Re: [PATCH] ext4: use a stable source for the kmmpd thread name
Message-ID: <x2m3ypyugjn25myfovxs42jgctnctmz6iof77juya3464o3bbl@qlsx2mk4smhr>
References: <20261114172523.5888-1-zhaogongyi@bytedance.com>
 <qz2gh5bbbyqjqfqclatkq34pgxnvbu3ey5kf3octnlykstzhx2@s65dxum2wdso>
 <da634961-1d13-4d21-b181-f366fd72e0d1@bytedance.com>
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
In-Reply-To: <da634961-1d13-4d21-b181-f366fd72e0d1@bytedance.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

Hello,

On Tue 17-11-26 00:36:50, Zhao Gongyi wrote:
> On 11/16/26 8:16 PM, Jan Kara wrote:
> > What can change it? I don't see anything that should be doing that...
> 
> A concurrent buffered write to the loop block device can change it. In
> one diagnostic run, the write reached the page-cache buffer ext4 was
> using for MMP. mmp_bdevname is embedded at bh->b_data + 0x50.

Ah, I see. So you're corrupting the filesystem through the block device
while it is mounted.

> I understand that raw writes to a block device during ext4 access can
> corrupt metadata. The proposed change gives the two-pass thread-name
> formatting a stable source; it does not change MMP's protection logic.
> I can provide the full diagnostic diff, kprobe module, and console log
> if useful.

Yes, sorry, but this isn't really something we care about. It is in
principle very similar as corrupting memory through /dev/mem and the
filesystem can crash in many different ways. When you are fuzzing, you
should disable BLK_DEV_WRITE_MOUNTED config which will also disallow
corruption like this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
