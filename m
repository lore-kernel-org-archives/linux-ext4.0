Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F3386450
	for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2026 10:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776765902; cv=none; b=UKFQUHViYKWnorg6fzNeWnDzfMQwv0IW8clungdoVZWIpVJ3YKj9ALoFXshl1CjfTMo/smR+goMnFhKzu0woRjmDOPTCG19ehljalMEXkcPoTFyIDtIL2vQGd29QpsfljEwWYhc/b9Wu9KJB8MUSl4MUOwkN1ZsNFGnKTTJJfTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776765902; c=relaxed/simple;
	bh=V3CqbP81QnQZqF17/gxCDj0g9AX7dC6Nl3PXf6aiHzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyqIv0TuQGkYMj09oAFsB7O0F/LaAIWY9wyTtXsrEHV8ekKASZa1ESKBgMK0qvgRq44H/IS9+RRN9sZUaz68HEH0KyUdIZ/Di/pYvB21zlkZ31TfRrvm10JSHChqrmbasJGitavypK7ds6ICyw5tKRqeA55FpFGU8bdIxVA8aOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=R0Ie1Hmj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JexmV41L; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0ILnJQty; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fKxBvfv6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="R0Ie1Hmj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JexmV41L";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0ILnJQty";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fKxBvfv6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAB2E5BCC1;
	Tue, 21 Apr 2026 10:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776765899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vs7u0fpOfhPpewcQZ54sx4EuzH250jnHBMd8ooAY/p0=;
	b=R0Ie1Hmj3R4ewMXJ9ZbszEkoET7rmBYiQx2sWhiWetpG5nto/pGihVys/OO/EWG4UKEdM2
	hI4bvrXt/8sAlTuhFA84fccZ8JJ7UwfQpeLJvwUu2D9M+7qok2YS2oT9G6UnPk687w98sf
	+lDOgS99ELDRG8TJtlzJ9TukCX53q1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776765899;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vs7u0fpOfhPpewcQZ54sx4EuzH250jnHBMd8ooAY/p0=;
	b=JexmV41LbqPBwuTgiMy9kLCXNstf4EcmGdZnlaNfOwcKl6T6LC5K/xl1nb93BQu8X0Majx
	oLh6RRK1UuU+V0AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776765898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vs7u0fpOfhPpewcQZ54sx4EuzH250jnHBMd8ooAY/p0=;
	b=0ILnJQtyNYSCQatzjFnQ579MfBiai+mPljSweMp5Bila5GR2PP2+sZjiY+P2plhgtQa2+Y
	GN9ft20b1ez7oz7sVmD651TNrnDEFiWLumqcpYfd/U07r8b6EJklGQojoJCZj4gHXSPdPe
	HHphBNbel49BvVSTEAGlhAVZUOJ4AjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776765898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vs7u0fpOfhPpewcQZ54sx4EuzH250jnHBMd8ooAY/p0=;
	b=fKxBvfv6t+DWeK0Qyah5eEzwk20PT777KML7fhaQWbo9Gar1cYcv+ZUxo6dx4DtKzIIwS9
	G/kJifpIwxeZ0JBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0864593AF;
	Tue, 21 Apr 2026 10:04:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uXbDNspL52kgRAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Apr 2026 10:04:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1E37A0AE1; Tue, 21 Apr 2026 12:04:50 +0200 (CEST)
Date: Tue, 21 Apr 2026 12:04:50 +0200
From: Jan Kara <jack@suse.cz>
To: Junjie Cao <junjie.cao@intel.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+26c4a8cab92d0cda3e3b@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: prevent out-of-bounds read in
 ext4_read_inline_data()
Message-ID: <ulfo7ut5ziqvrjy24besb4jtobijunycglvmqki7cwfzsancwi@5ycrwypubh56>
References: <20260421093138.906266-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421093138.906266-1-junjie.cao@intel.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[26c4a8cab92d0cda3e3b];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,imap1.dmz-prg2.suse.org:helo,iloc.bh:url,syzkaller.appspot.com:url,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 21-04-26 17:31:38, Junjie Cao wrote:
> ext4_read_inline_data() reads e_value_offs from the inode buffer_head on
> each call, but the decision to enter the xattr value path depends on
> i_inline_size cached in EXT4_I(inode) at iget time. If the buffer
> contents change after the initial validation, e_value_offs can point
> beyond the inode body while i_inline_size still directs the code into
> the xattr value path, causing an out-of-bounds read in the memcpy.
> 
> Add a bounds check before the memcpy, consistent with
> ext4_xattr_ibody_get(). Also guard folio_mark_uptodate() in
> ext4_read_inline_folio() since ext4_read_inline_data() can now return
> -EFSCORRUPTED.
> 
> Fixes: 67cf5b09a46f ("ext4: add the basic function for inline data support")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+26c4a8cab92d0cda3e3b@syzkaller.appspotmail.com
> Tested-by: syzbot+26c4a8cab92d0cda3e3b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=26c4a8cab92d0cda3e3b
> Signed-off-by: Junjie Cao <junjie.cao@intel.com>

If the buffer contents changes after the initial validation, there is some
problem somewhere and this isn't going to fix it (likely the fs is
corrupted and that isn't properly detected). Please fix the real problem,
not just paper over it.

								Honza

> ---
>  fs/ext4/inline.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 408677fa8196..18c678df0a6e 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -211,6 +211,14 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
>  	len = min_t(unsigned int, len,
>  		    (unsigned int)le32_to_cpu(entry->e_value_size));
>  
> +	if (unlikely((void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs) +
> +		     len > (void *)ITAIL(inode, raw_inode))) {
> +		EXT4_ERROR_INODE(inode,
> +			"inline data value out of bounds (offs %u len %u)",
> +			le16_to_cpu(entry->e_value_offs), len);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	memcpy(buffer,
>  	       (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs), len);
>  	cp_len += len;
> @@ -535,7 +543,8 @@ static int ext4_read_inline_folio(struct inode *inode, struct folio *folio)
>  	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
>  	kaddr = folio_zero_tail(folio, len, kaddr + len);
>  	kunmap_local(kaddr);
> -	folio_mark_uptodate(folio);
> +	if (ret >= 0)
> +		folio_mark_uptodate(folio);
>  	brelse(iloc.bh);
>  
>  out:
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
