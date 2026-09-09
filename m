Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F90952B1C4
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 10:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950286; cv=none; b=PuIFWUChikDieGIjbf7HYwf0FAdS2EOXfjdsmdttVKeUUyoa0OzlYkkCOXagmWx5Kbk+bLai+HfJ9tM3QmJOJE1/bbt7NpyXYadDt9Ke1RaHegS3LUWQpaqcpp7cVuny8RoMvz8JIjMo2W69ZydBS6ekBgJtaJpDFBqJGUeQkX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950286; c=relaxed/simple;
	bh=r4AW2VUog05oQLlHzA2KTFXK21LdJRT4FElVGYTAYpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a189UiwTxOrSJrJagRnd2kc7ZdcMlGjES47bvm7zSGVbCLk0CE3Yl4Aqm2WzjWprEYteOsp+whbpwPY+FXryZGIGrraKeGCzTIPHBXHMf8retzzmH+cbYCSxp9nTANGpY9J1KoJ1SZvz27QUKsYZTA/lMjqk+R7u6vRBJ9pZLNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FSq4oEeh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nSZUlsri; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pAepWKHy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R8g/xIBT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FSq4oEeh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nSZUlsri";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pAepWKHy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R8g/xIBT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B9481FB16;
	Wed,  9 Sep 2026 10:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788950279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/YEzN+0Gns1ktvAOdQhd4O5aAaziQtIU/Klv89xd1t8=;
	b=FSq4oEehU6A7okppVlQMqV0z4PM158c8i1TqutbimZuye2Z1NDwBVOlcCTEV0LGfSm2Fdq
	MQx0m6aGGEMFTBFJZhePAsSPp2UCCVziQccYVfnLg+ToBsgKsXr31Mm3pitLst4imAbNc2
	F7IgsW1+BNbf5ALT2cHkALvgbN/DW4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788950279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/YEzN+0Gns1ktvAOdQhd4O5aAaziQtIU/Klv89xd1t8=;
	b=nSZUlsrij+IZtYIQ0LioucwHz2WqHE+jPfsqZf1URkdT6aHAUIw9dkS/JGzUNlZbC6o5uT
	GlmcqqqPZ+ElfxAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pAepWKHy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="R8g/xIBT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788950275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/YEzN+0Gns1ktvAOdQhd4O5aAaziQtIU/Klv89xd1t8=;
	b=pAepWKHyAj1bI8RJ7Yn4BqZtaa86WrPcEDt3KeaTuLicpdiZr/DsqucTVYvlpUpu/dzlUc
	it+oW0NVJO1gBK4Npjn9pKjsf2HWrsmIkbtzmm8fvXRxzNuiQ4pz5deRUI0uCuCdLPfMmL
	1aP81ZW/UyMIk1yBc5T9hNlrNCFaivY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788950275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/YEzN+0Gns1ktvAOdQhd4O5aAaziQtIU/Klv89xd1t8=;
	b=R8g/xIBTVorSCzOGNttGkvtV6isoNTOvu6Edd3aMZ3cO/TK7ijFKq2nwTaM6at9d9wIOD6
	STEWZDrDfIeQlkDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0F0F13354;
	Wed,  9 Sep 2026 10:37:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VlHROgI3oWrKNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 10:37:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 89A58A1341; Wed, 09 Sep 2026 12:37:50 +0200 (CEST)
Date: Wed, 9 Sep 2026 12:37:50 +0200
From: Jan Kara <jack@suse.cz>
To: shuo chen <1289151713@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4:Fix the initial value of not_found in
 ext4_destroy_inline_data_nolock
Message-ID: <r7cnmruhhypvxk32ilopf47mbx4qd6dcdsbari6zwovaerp7gz@a27v6irfx6hl>
References: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 1B9481FB16
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[qq.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Wed 09-09-26 09:12:35, shuo chen wrote:
> If a file has EXT4_INODE_INLINE_DATA set but lacks the
> EXT4_STATE_XATTR flag,

But how can this happen? Inline data is stored in xattrs so it shouldn't be
possible...

								Honza

> ext4_xattr_ibody_find() will exit early without
> modifying is.s.not_found. This may cause ext4_xattr_ibody_set()
> to behave incorrectly.
> 
> Signed-off-by: shuo chen <1289151713@qq.com>
> ---
>  fs/ext4/inline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..3398208f3e66 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -437,7 +437,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct ext4_xattr_ibody_find is = {
> -		.s = { .not_found = 0, },
> +		.s = { .not_found = -ENODATA, },
>  	};
>  	struct ext4_xattr_info i = {
>  		.name_index = EXT4_XATTR_INDEX_SYSTEM,
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
