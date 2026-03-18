Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E364D2D0C92
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773853156; cv=none; b=qpoy641hE+I8UH9ivpArJ+f3UJek38nqDiJckpLeloq5KmxWIp3nBm4JHaX+N8am8V6AFJeUQJciaxpr+vxnXjlLmg20CUaNRDMq7feFP1TYfURM37TlDFMUojKajdVAAH8xd3XFEfAcEEkV3mr2L68SUDJlkWbmXWx6x6StoAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773853156; c=relaxed/simple;
	bh=OaEt76F9TG+Bc661mX5+VugjGYcw6YlNWKFSHVQp6nI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKgQm9mry4LgfORiFVX1uqOIICYwiZ3kJPvkSKdFft3t4hV1P+fzvoUNhPMO2Ty6Fw+Dofp2M3akZX4SjhoCk8iyndniFNxDC0dA2+DxAw9zPMwOLUHGjFyyNA5NA13ytumosQBV0E59X+VS+Md7v1SLwceRbZivBT/A/I+7L4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qrs19Q6t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fVzvml81; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qrs19Q6t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fVzvml81; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qrs19Q6t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fVzvml81";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qrs19Q6t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fVzvml81"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21C6E5BECE;
	Wed, 18 Mar 2026 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773853153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Ns0//PGJkoTe3dpkrPOE0NNb/0VrHvk9KJiDRtnEQU=;
	b=qrs19Q6tWygWJJVaFMt4zRI3Uqov2fgir3wqIe2L8yw8WfdOmcmx2rm7RUJW91KV6++pdO
	jguuFlQyVSMdnTSyI6fq8YXmazzH62L++dflkfjya8t9WZqr65in7FrEnoXzMkgpa7JJj/
	8ZHhJ6Q60xP6NLZiVqr/6uZO9rEW3Yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773853153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Ns0//PGJkoTe3dpkrPOE0NNb/0VrHvk9KJiDRtnEQU=;
	b=fVzvml81TFuo2wqfG7KV5wp6g41r2ubTScArYVY2FJazk6HYtZVv8yStyAKE00SljNCigl
	kbARZ/57yO7WwxDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qrs19Q6t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fVzvml81
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773853153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Ns0//PGJkoTe3dpkrPOE0NNb/0VrHvk9KJiDRtnEQU=;
	b=qrs19Q6tWygWJJVaFMt4zRI3Uqov2fgir3wqIe2L8yw8WfdOmcmx2rm7RUJW91KV6++pdO
	jguuFlQyVSMdnTSyI6fq8YXmazzH62L++dflkfjya8t9WZqr65in7FrEnoXzMkgpa7JJj/
	8ZHhJ6Q60xP6NLZiVqr/6uZO9rEW3Yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773853153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Ns0//PGJkoTe3dpkrPOE0NNb/0VrHvk9KJiDRtnEQU=;
	b=fVzvml81TFuo2wqfG7KV5wp6g41r2ubTScArYVY2FJazk6HYtZVv8yStyAKE00SljNCigl
	kbARZ/57yO7WwxDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 177C14273B;
	Wed, 18 Mar 2026 16:59:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +Iu0BeHZumlsAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 16:59:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CC3CDA0AFF; Wed, 18 Mar 2026 17:59:08 +0100 (CET)
Date: Wed, 18 Mar 2026 17:59:08 +0100
From: Jan Kara <jack@suse.cz>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	jack@suse.cz
Subject: Re: [PATCH v2 0/3] decoupling the ext4 test module
Message-ID: <czxgdl6rf65z3mekxu53gpxcjwoknpkqkzihxqalumuhbuadck@67kxfnn6r43q>
References: <20260314075258.1317579-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314075258.1317579-1-yebin@huaweicloud.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 21C6E5BECE

On Sat 14-03-26 15:52:55, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> This patchset is split out from the "Fix some issues about ext4-test"
> patchset. It decouples mballoc-test.c and extents-test.c from the
> ext4 module, resolving the issue where these two tests could not be run
> when EXT4_KUNIT_TESTS is set to M.
> 
> Ye Bin (3):
>   ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
>   ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
>   ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
>  fs/ext4/Makefile       |   5 +-
>  fs/ext4/ext4.h         |   5 ++
>  fs/ext4/ext4_extents.h |  12 +++++
>  fs/ext4/extents-test.c |   8 ++--
>  fs/ext4/extents.c      |  39 +++++++++++++---
>  fs/ext4/mballoc-test.c |  81 ++++++++++++++++----------------
>  fs/ext4/mballoc.c      | 102 +++++++++++++++++++++++++++++++++++++++--
>  fs/ext4/mballoc.h      |  30 ++++++++++++
>  8 files changed, 227 insertions(+), 55 deletions(-)
> 
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
