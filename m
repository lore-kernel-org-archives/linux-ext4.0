Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FEB3DCDAB
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2026 11:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780399073; cv=none; b=NT7GGt1ubW6353wWbRlUid6G4bNsHcJzFmju+x1P7WCa7XHqGfXjwYGi0f19k5Leozyw3mVVrp3M79uSHliQIIYbsF35KxguvlylzxHeyZVrDPe0CwycZ670W1FBzYD+FNFFqzmOt2z5sTK8vnp4FXJHoB3Rue+S0vKzc10fiVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780399073; c=relaxed/simple;
	bh=nuleYXFsFRMRvdJV03wJlYsCS3z0O11kQ0oTUwmI/ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poceqIaW0OzvwOnJa4niEjPpGGwxcinsU97C2J7yjk0pdefVlTXKH9+wxNUAqZNGJX+Zz+ZO8RvvxVCRj2BO6Xptq6PAzRCbkSuf8XqUlSjj3FTdJqPo450njAPCoWRoTaw26bH9tdW2K5Y38VfRRrd1psFA3uo0qjf9mVJRNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KVpxSwF9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NXXHBXiL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SiwkF2kz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s9/vBjj0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KVpxSwF9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NXXHBXiL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SiwkF2kz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s9/vBjj0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 30DFE6AC43;
	Tue,  2 Jun 2026 11:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780399062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kcoB0kiDyn8EqADERWPojV5U7fF8CqmSzbjRHpYeIT0=;
	b=KVpxSwF9iV72IPSnZ10htlzmPRkpHgqGW7lhMfAEurM1tCXf6zunRWpye7CMD9pMTTJBHA
	WPGODWq4YjyvpYrN1/pOyNFJyOk+Zzt95tC1dhvlswPyfa/rs+1alsX+Zx4PtmeLZ2Ghte
	X6mojEBj+TNPyYtUECvlwqh7bEjrsFM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780399062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kcoB0kiDyn8EqADERWPojV5U7fF8CqmSzbjRHpYeIT0=;
	b=NXXHBXiLztyckj4CfiCNfKepk481RZj85adEe2r/gXplYXQmGnddqr+fnaipMwuzR+/ibu
	+cMkuGs0qDLLC9AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780399061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kcoB0kiDyn8EqADERWPojV5U7fF8CqmSzbjRHpYeIT0=;
	b=SiwkF2kzHgcDKMj0yR6a2+Nx2SQaxWcsjQOxllx6NxlysJjQcqGkeCHpDGj0vwaKKX3iuj
	r+dhoOQ2uAclQNyTyj1sZWoo0aH8NglRJT/sImKdMB0L83iRIaP/MChuFz3FGKQ7lrOxNk
	xQTKPVjjlyblndevchZ9VKos2HPFoCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780399061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kcoB0kiDyn8EqADERWPojV5U7fF8CqmSzbjRHpYeIT0=;
	b=s9/vBjj0lA5nX9eLdAhiGY8lyx1LmsN7Zm5TjeH9qMEBd2fPTx8T9zL2JAVB4lyJ8cQBlB
	8fgI2OVRh8Y09WAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28A0A779A7;
	Tue,  2 Jun 2026 11:17:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XnPiCdW7HmofOQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 02 Jun 2026 11:17:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C003AA0EC1; Tue, 02 Jun 2026 13:17:36 +0200 (CEST)
Date: Tue, 2 Jun 2026 13:17:36 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 1/4] ext4: convert extents KUnit test to sget_fc()
Message-ID: <4i2a36bu45q2yvewhfhpbj7zxm5xjfutsc6lhm6czd4j63iyf2@5k5iaajs736v>
References: <20260529-work-sget-v2-0-57bbe08604e4@kernel.org>
 <20260529-work-sget-v2-1-57bbe08604e4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529-work-sget-v2-1-57bbe08604e4@kernel.org>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,gmail.com,zeniv.linux.org.uk];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Fri 29-05-26 10:43:40, Christian Brauner wrote:
> The extents KUnit test uses sget() to get an initialized superblock for
> its fake file_system_type. sget() predates fs_context and we want to
> retire it. Switch this caller over to sget_fc().
> 
> Add a no-op ext_init_fs_context() so fs_context_for_mount() has
> something to call on the fake fs_type. ext_set() now takes a struct
> fs_context * (still a no-op). extents_kunit_init() allocates the fc,
> hands it to sget_fc() and drops the fc reference once the sb is
> published. sget_fc() does not retain a pointer to it.
> 
> No functional change for the test.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents-test.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 6b53a3f39fcd..bd7795a82607 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -37,6 +37,7 @@
>  
>  #include <kunit/test.h>
>  #include <kunit/static_stub.h>
> +#include <linux/fs_context.h>
>  #include <linux/gfp_types.h>
>  #include <linux/stddef.h>
>  
> @@ -130,14 +131,20 @@ static void ext_kill_sb(struct super_block *sb)
>  	generic_shutdown_super(sb);
>  }
>  
> -static int ext_set(struct super_block *sb, void *data)
> +static int ext_init_fs_context(struct fs_context *fc)
> +{
> +	return 0;
> +}
> +
> +static int ext_set(struct super_block *sb, struct fs_context *fc)
>  {
>  	return 0;
>  }
>  
>  static struct file_system_type ext_fs_type = {
> -	.name = "extents test",
> -	.kill_sb = ext_kill_sb,
> +	.name		 = "extents test",
> +	.init_fs_context = ext_init_fs_context,
> +	.kill_sb	 = ext_kill_sb,
>  };
>  
>  static void extents_kunit_exit(struct kunit *test)
> @@ -223,6 +230,7 @@ static int extents_kunit_init(struct kunit *test)
>  	struct ext4_inode_info *ei;
>  	struct inode *inode;
>  	struct super_block *sb;
> +	struct fs_context *fc;
>  	struct ext4_sb_info *sbi = NULL;
>  	struct kunit_ext_test_param *param =
>  		(struct kunit_ext_test_param *)(test->param_value);
> @@ -232,7 +240,13 @@ static int extents_kunit_init(struct kunit *test)
>  	if (sbi == NULL)
>  		return -ENOMEM;
>  
> -	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
> +	fc = fs_context_for_mount(&ext_fs_type, 0);
> +	if (IS_ERR(fc)) {
> +		kfree(sbi);
> +		return PTR_ERR(fc);
> +	}
> +	sb = sget_fc(fc, NULL, ext_set);
> +	put_fs_context(fc);
>  	if (IS_ERR(sb)) {
>  		kfree(sbi);
>  		return PTR_ERR(sb);
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
