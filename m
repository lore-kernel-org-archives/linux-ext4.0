Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB412BEC3F
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781002850; cv=none; b=NeAeE30Ncay6jBu32NS4HTyngSUln0395yxg7wb9IPIgtqTM0w68b2Cjq7bi5K7poilMvhMDNU4gyVcc6D0nSGcPFcJW+QaLhydiH8xYICoo1FgHqKbEj3GR0ZLTnyQPSL41Uoen8nRLwjpREaeNtoBbJN0zU9fUqalJTtS1i3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781002850; c=relaxed/simple;
	bh=zIZzeqr9P6G8A8Zitj/lqUomymBegRBUR8uA8grIOII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAWm6SCIVPY+y5I3EKVyHzI/JCWqXKE7VVRaqvjJ3LA08rQzgOP0YN3dEI1FfYmykiM3t5x3MkBiOuZStom5EDfW4FYhhX7KUyHCNT5x9tM9hwSO44llD0qrNgf7EssPmJZ1dM47v5HCo+Msxc1p4dizGc7Jrd8XdCspYB9TFkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tuHMoZtk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2TROaznk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tuHMoZtk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2TROaznk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tuHMoZtk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2TROaznk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tuHMoZtk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2TROaznk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1A9B6A97C;
	Tue,  9 Jun 2026 11:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781002847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sBusdAtNQHGcO5dvYdC26vXS439bb3hRj2MIL30dEdc=;
	b=tuHMoZtkozG5pbxqtgbbyM6/0H+4IIdcqfST4HRBZKo7PaVz5Aa2eST5GhI5umYqCbKuiQ
	jWi8+CiAarCosI+e06zW3q9nVhIStEXuJx3AEVh3b8hfiXy7jr5E5yyi1IzAZA9W3qQR3j
	4VG/4Aj4e85W3DdD1B2ke0mE6EIeUUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781002847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sBusdAtNQHGcO5dvYdC26vXS439bb3hRj2MIL30dEdc=;
	b=2TROaznkySzLZm0od/rQOs/zU3gr5UWzkaflLE+Z+EbMNqkwhoPCbuvu9Qo1b6HEFVX4GK
	SCcgERsWmD7zh6Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781002847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sBusdAtNQHGcO5dvYdC26vXS439bb3hRj2MIL30dEdc=;
	b=tuHMoZtkozG5pbxqtgbbyM6/0H+4IIdcqfST4HRBZKo7PaVz5Aa2eST5GhI5umYqCbKuiQ
	jWi8+CiAarCosI+e06zW3q9nVhIStEXuJx3AEVh3b8hfiXy7jr5E5yyi1IzAZA9W3qQR3j
	4VG/4Aj4e85W3DdD1B2ke0mE6EIeUUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781002847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sBusdAtNQHGcO5dvYdC26vXS439bb3hRj2MIL30dEdc=;
	b=2TROaznkySzLZm0od/rQOs/zU3gr5UWzkaflLE+Z+EbMNqkwhoPCbuvu9Qo1b6HEFVX4GK
	SCcgERsWmD7zh6Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 973D4779A7;
	Tue,  9 Jun 2026 11:00:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VoXqJF/yJ2qcfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 11:00:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3BD17A0A90; Tue, 09 Jun 2026 13:00:43 +0200 (CEST)
Date: Tue, 9 Jun 2026 13:00:43 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 3/3] ext4: reject mount if inodes per group is not a
 multiple of inodes per block
Message-ID: <m77rk2zvnkvinh3a3uwlhklvdekswegyc2tcwaccgflgqg4wdd@eesjsul5oddc>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-4-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608111150.827117-4-libaokun@linux.alibaba.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[alibaba.com:email,suse.cz:email,sashiko.dev:url,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email,alibaba.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 08-06-26 19:11:50, Baokun Li wrote:
> If s_inodes_per_group is not a multiple of s_inodes_per_block, the
> division that computes s_itb_per_group truncates, reserving fewer blocks
> for the inode table than needed.
> 
> On a crafted filesystem image, this allows __ext4_get_inode_loc() to
> compute a block offset beyond the inode table, reading unrelated data as
> an inode structure.
> 
> Add the missing divisibility check alongside the existing validation in
> ext4_block_group_meta_init().
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3ddcb4a8d4db..5ec9e1ef00c0 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5306,7 +5306,8 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
>  	}
>  	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
>  	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
> -	    sbi->s_inodes_per_group & 7) {
> +	    sbi->s_inodes_per_group & 7 ||
> +	    sbi->s_inodes_per_group % sbi->s_inodes_per_block) {
>  		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
>  			 sbi->s_inodes_per_group);
>  		return -EINVAL;
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
