Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1FD3D6487
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2026 11:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780399134; cv=none; b=YNL1MCLzK9BeE3Qgod+TbFI27YNFaPNAsKiLI0j5/DZXX0IWL1Ud5EEG33l8U8NLLMrC5/wpstkEO8odABxC8MGAIbu1sgwBRimnYvICxYQWoE3+YR1Dfd4tCKARrX5cw6GYqtuMr4dE2DD2azNcKoshPEazPWYPFqg4ZyW90cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780399134; c=relaxed/simple;
	bh=RtwuG9j1VhoVMdjmNtjFv7adnGpEnN5wt7p0VMB8ZZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ek/Jzi2IB+HlNNw22+kXZ0eNjqtr1J0c2AQwAe5849UK/cEc8zimzWSSbTsYETPNv/yXVzrErfquKeyl8rK5EHHuNkWyvcIa4rt2y7CbObUM/UGBnMzyR/Z8lsXag1ZtLX2LG5EqIa+pko1UPXix902hQz6GheWOU/dGQwpbtjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HVo/8zsy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ai5wODQs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p4suvnYD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VCT3csCn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HVo/8zsy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ai5wODQs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p4suvnYD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VCT3csCn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F29F75A3E;
	Tue,  2 Jun 2026 11:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780399130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok+2dVWp9NviTqXyIHr9GBMyKtjowQprZhHaURQ49Ek=;
	b=HVo/8zsyXHhXj9oHqEEmGXHFlWscSJ9l4TnQc5aj+58QIeMmNuO7TK17SOYePSo1dXx7kk
	Guhple3QN5MmLPGt/jaDwIFc5wSelxbB/oaNLkKBvxuLVW+mb4BlIhpmnDxnrVye/xd53W
	loFv9628Clf634eVXgzkjexbswHtXwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780399130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok+2dVWp9NviTqXyIHr9GBMyKtjowQprZhHaURQ49Ek=;
	b=ai5wODQspijXJbfWVfAcozMTiO0IKlAKzctlqXoGVPOg5jgG3qWBt2P07DmkYJIzb9HfGd
	9U+rlraxQIqEixDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p4suvnYD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VCT3csCn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780399129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok+2dVWp9NviTqXyIHr9GBMyKtjowQprZhHaURQ49Ek=;
	b=p4suvnYDPx3jFvFIfVdmuer2czTq4B2PbvRshNNZrTza3GFgKsVUn5Gc0y9x7F0cDRMZSs
	2IstyoQvDEMfJCqi76b0ThANaZaglS97bpqyD+RTmBON9k/oT4Q/LIOdngdXkIlyMP3LWC
	Xrvbpg/CYZ5IUlMTWFAqo/8hn/j0ND0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780399129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ok+2dVWp9NviTqXyIHr9GBMyKtjowQprZhHaURQ49Ek=;
	b=VCT3csCn7EZD073eYwPDbUmDvDEs3twVUKFHgf6OAnBAZcB7clEJdNOFlPyLDWxBLifHt7
	32cgTDjnE7q2IACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 256E0779A7;
	Tue,  2 Jun 2026 11:18:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d5UhCRm8HmrfOgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 02 Jun 2026 11:18:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D6BCEA0EC1; Tue, 02 Jun 2026 13:18:48 +0200 (CEST)
Date: Tue, 2 Jun 2026 13:18:48 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 2/4] ext4: convert mballoc KUnit test to sget_fc()
Message-ID: <hszpymbib3p3yiynmtseelm4nesba2ppwa5ztwrjeknrwwey3l@ntetb3ptilfm>
References: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
 <20260529-work-sget-v2-2-57bbe08604e4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529-work-sget-v2-2-57bbe08604e4@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2F29F75A3E
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
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,gmail.com,zeniv.linux.org.uk];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Fri 29-05-26 10:43:41, Christian Brauner wrote:
> Same treatment as the extents KUnit test. The mballoc test uses sget()
> as a thin "give me an initialized superblock" wrapper for a fake
> file_system_type. Move it onto sget_fc() so sget() can go away.
> 
> Add a no-op mbt_init_fs_context() so fs_context_for_mount() has
> something to call on the fake fs_type. mbt_set() now takes a struct
> fs_context * (still a no-op). mbt_ext4_alloc_super_block() allocates
> the fc, hands it to sget_fc() and drops the fc reference once the sb
> is published.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mballoc-test.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index 90ed505fa4b1..d90da44aadbd 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c
> @@ -5,6 +5,7 @@
>  
>  #include <kunit/test.h>
>  #include <kunit/static_stub.h>
> +#include <linux/fs_context.h>
>  #include <linux/random.h>
>  
>  #include "ext4.h"
> @@ -63,8 +64,14 @@ static void mbt_kill_sb(struct super_block *sb)
>  	generic_shutdown_super(sb);
>  }
>  
> +static int mbt_init_fs_context(struct fs_context *fc)
> +{
> +	return 0;
> +}
> +
>  static struct file_system_type mbt_fs_type = {
>  	.name			= "mballoc test",
> +	.init_fs_context	= mbt_init_fs_context,
>  	.kill_sb		= mbt_kill_sb,
>  };
>  
> @@ -127,7 +134,7 @@ static void mbt_mb_release(struct super_block *sb)
>  	kfree(sb->s_bdev);
>  }
>  
> -static int mbt_set(struct super_block *sb, void *data)
> +static int mbt_set(struct super_block *sb, struct fs_context *fc)
>  {
>  	return 0;
>  }
> @@ -136,13 +143,19 @@ static struct super_block *mbt_ext4_alloc_super_block(void)
>  {
>  	struct mbt_ext4_super_block *fsb;
>  	struct super_block *sb;
> +	struct fs_context *fc;
>  	struct ext4_sb_info *sbi;
>  
>  	fsb = kzalloc_obj(*fsb);
>  	if (fsb == NULL)
>  		return NULL;
>  
> -	sb = sget(&mbt_fs_type, NULL, mbt_set, 0, NULL);
> +	fc = fs_context_for_mount(&mbt_fs_type, 0);
> +	if (IS_ERR(fc))
> +		goto out;
> +
> +	sb = sget_fc(fc, NULL, mbt_set);
> +	put_fs_context(fc);
>  	if (IS_ERR(sb))
>  		goto out;
>  
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
