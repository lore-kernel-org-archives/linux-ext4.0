Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2840364934
	for <linux-ext4@vger.kernel.org>; Sun, 12 Jul 2026 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783873996; cv=none; b=M6PtoU/okdVDmTncu182Uyz5o6jx13DpKSEo+E5XuGmAuQY+yC9qgP8tH2jcV0PgCxUlGV6bcViNvjcRotT3Fr0Z0HzK2PyiwGhhcPtmwynGceYBp84mTT4ZHTx5oD4MdX84bzh861wxMyc7piS1Oc3hFGbm45+XLij9Vu6BVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783873996; c=relaxed/simple;
	bh=cbThFHLdB0BtyoBtphQdpKYNcg9502xT+0XsZiNLAXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h09ilOkaU6PDgbCqWtxIFSS3fHEAtk+Jalxw0QOvb8L5x1Y6cVaNCazP8U+qXEMgrk0rGixmuIwrYPYwXD2xQV/lNaNl7m5HJt/1ZFEn5s0TuuIL7mK16Ltvz8SqBB4g4MyrU5p8vPXLVHQsZv4+UtnMR7A49kD8OS1grOv58u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pIL1DbGF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bx4ogxzZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sqa5aTpz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4+Q1Njze; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pIL1DbGF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bx4ogxzZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sqa5aTpz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4+Q1Njze"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD106770AF;
	Sun, 12 Jul 2026 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783873993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kChF3fyDAuB29aUOtl+N6zYt9fdzUGj6qH5AQ0UJhFg=;
	b=pIL1DbGFC2muUCuy0Azbj54Z4VY6V7lhMqdUci/u6eXx3JxJ6vRbLoDQdG1LCXdlqnUTh6
	VALaXo7x3YXmks8FNN1MSf0MTSHtbGDW8BTVU6vJXSI2KgmYubsY75LJuKz7UZ+ZrcffIc
	qjQM/mJyArFP2lv0lLFLFEKqSy+EM44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783873993;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kChF3fyDAuB29aUOtl+N6zYt9fdzUGj6qH5AQ0UJhFg=;
	b=Bx4ogxzZJfOjkv8FDSv/JCmZWPfoGj/0W51U7/gHbMbz4VdqPRmCst3ZjhL+H2chCW93Yy
	PXVpMgk8fEx4UUCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sqa5aTpz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4+Q1Njze
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783873992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kChF3fyDAuB29aUOtl+N6zYt9fdzUGj6qH5AQ0UJhFg=;
	b=sqa5aTpz2mXkKT1P0ls5NF2Js2kq8p12SX4/8QdZygDOaXpb4GqgiMOHBcr84DijC7bGJW
	2nO2Rioc73Rhd1YVTF/P8BRsNCoMFF7jyFoeEZ9Iykc1REt3yHwnWupWoSf/XjpUoVUca1
	/QJhK02t0Rrov5fhTVBRKkw1bqYYrGU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783873992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kChF3fyDAuB29aUOtl+N6zYt9fdzUGj6qH5AQ0UJhFg=;
	b=4+Q1NjzeVaN7fa96ighDWDdCZDnHRIf4+Z0FkdUStmh7p+OZyCQ4tGmofwyKw2JBj2DkJ3
	7u1a7yB+N75KCYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3C68779B5;
	Sun, 12 Jul 2026 16:33:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xS3hK8jBU2ptKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sun, 12 Jul 2026 16:33:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 58C97A1319; Sun, 12 Jul 2026 18:33:12 +0200 (CEST)
Date: Sun, 12 Jul 2026 18:33:12 +0200
From: Jan Kara <jack@suse.cz>
To: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: use str_plural() instead of custom macro
Message-ID: <32utmcyfbs6esfgqvffhnwaa3uoint3sdz2hkzflzdiplq5zgn@qg55at7n4iqc>
References: <20260711-remove-plural-macro-v1-1-b3dcd44e4068@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711-remove-plural-macro-v1-1-b3dcd44e4068@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BD106770AF
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Sat 11-07-26 08:38:18, Joshua Crofts wrote:
> Remove the custom PLURAL() macro and use str_plural() from
> string_choices.h instead.
> 
> Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>

Yeah, I guess it's cleaner this way. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/orphan.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index 64ea47624233..e307d6d55451 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -4,6 +4,7 @@
>  #include <linux/fs.h>
>  #include <linux/quotaops.h>
>  #include <linux/buffer_head.h>
> +#include <linux/string_choices.h>
>  
>  #include "ext4.h"
>  #include "ext4_jbd2.h"
> @@ -486,14 +487,13 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
>  		}
>  	}
>  
> -#define PLURAL(x) (x), ((x) == 1) ? "" : "s"
>  
>  	if (nr_orphans)
>  		ext4_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
> -		       PLURAL(nr_orphans));
> +			 nr_orphans, str_plural(nr_orphans));
>  	if (nr_truncates)
>  		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
> -		       PLURAL(nr_truncates));
> +			 nr_truncates, str_plural(nr_truncates));
>  #ifdef CONFIG_QUOTA
>  	/* Turn off quotas if they were enabled for orphan cleanup */
>  	if (quota_update) {
> 
> ---
> base-commit: c143957520c6c9b5cd72e0de8b52b814f0c576fe
> change-id: 20260711-remove-plural-macro-7ecfa879fcae
> 
> Best regards,
> -- 
> Kind regards
> 
> CJD
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
