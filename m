Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678FD331221
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856665; cv=none; b=MAMqZty0ABUrY3+692y3WU3dOi5SlUvHUruDZzupISrUX8+qwHiRCslfnLsps8sW7fxshTbSksSpgpEvS1mzM4VRguPZ2HCkBVgx3GE46rc8ml+91X4b5oyfdZQcHLds3MLgxrmd/RC+wY/tRR/q2yVcrjHDsjgafYmBoM1mf58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856665; c=relaxed/simple;
	bh=Nt0tszlp/0h8bclETnFXg+to25bEWwTjcGvwwnMMEXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYwMWAM4Jwh3M0e30UEhULL3Y5tZL08veBZWP+8qgnBATp4qvJN31r38ADrBOvDoIU/0sR7ASv8o0yiDn0QnMjyeyNkenI2o6imA1cTQOnYWC7j3idNTRP5CubaYHiKiCWNE+ECHgI6s1+fUrSBQ5PyR7KPXV6QtSrMJHZj8t6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vZ9PAE8e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e1/EkfKa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vZ9PAE8e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e1/EkfKa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vZ9PAE8e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e1/EkfKa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vZ9PAE8e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e1/EkfKa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91DFD4D3FC;
	Wed, 18 Mar 2026 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773856662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIE/mlVKz2popuEn0zU1mSicMiSyIxuqyIpOjT72AVA=;
	b=vZ9PAE8e1sGCvzGN15itWwtiO+aswO8k2M6Ru2utVN6FSPyVVrn4WpGEt8QZUqJd+FNRZt
	+yp7nueAxOw9gDzA535YhHifhotPM0Q/JqlfrJ7GXfMr15CbDOLDQn93qr/MEFR6BKfV2s
	MivIDcQscfYkVWsLzJva0/KbssyUpJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773856662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIE/mlVKz2popuEn0zU1mSicMiSyIxuqyIpOjT72AVA=;
	b=e1/EkfKazKzaYr5aBYKkkt2UjnBQWEjdrMqTRLByYYw9R1+9bAHDXm4mLy1HKTlui/I9TX
	Wi/6O2ksspnG1dAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773856662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIE/mlVKz2popuEn0zU1mSicMiSyIxuqyIpOjT72AVA=;
	b=vZ9PAE8e1sGCvzGN15itWwtiO+aswO8k2M6Ru2utVN6FSPyVVrn4WpGEt8QZUqJd+FNRZt
	+yp7nueAxOw9gDzA535YhHifhotPM0Q/JqlfrJ7GXfMr15CbDOLDQn93qr/MEFR6BKfV2s
	MivIDcQscfYkVWsLzJva0/KbssyUpJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773856662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CIE/mlVKz2popuEn0zU1mSicMiSyIxuqyIpOjT72AVA=;
	b=e1/EkfKazKzaYr5aBYKkkt2UjnBQWEjdrMqTRLByYYw9R1+9bAHDXm4mLy1HKTlui/I9TX
	Wi/6O2ksspnG1dAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 895764273B;
	Wed, 18 Mar 2026 17:57:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0vKEIZbnumnLQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 17:57:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 20823A0AFF; Wed, 18 Mar 2026 18:57:34 +0100 (CET)
Date: Wed, 18 Mar 2026 18:57:34 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neil@brown.name>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] ext4: add ext4_fc_eligible()
Message-ID: <gh7e7uykczpyhfxrh6y54c2jlcs4pzcud65aqsjoj4am6cajzp@wq26crdxv2yd>
References: <20260317224638.3809014-1-neilb@ownmail.net>
 <20260317224638.3809014-3-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317224638.3809014-3-neilb@ownmail.net>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,brown.name:email,suse.cz:email]
X-Spam-Flag: NO

On Wed 18-03-26 09:39:50, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> Testing EXT4_MF_FC_INELIGIBLE is almost always combined with testing
> ext4_fc_disabled().  The code can be simplified by combining these two
> in a new ext4_fc_eligible().
> 
> In ext4_fc_track_inode() this moves the ext4_fc_disabled() test after
> ext4_fc_mark_ineligible(), but as that is a non-op when
> ext4_fc_disabled() is true, this is no no consequence.
> 
> Signed-off-by: NeilBrown <neil@brown.name>

One nit below, otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> @@ -557,16 +548,13 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
>  	if (S_ISDIR(inode->i_mode))
>  		return;
>  
> -	if (ext4_fc_disabled(inode->i_sb))
> -		return;
> -
>  	if (ext4_should_journal_data(inode)) {
>  		ext4_fc_mark_ineligible(inode->i_sb,
>  					EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
>  		return;
>  	}
>  
> -	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
> +	if (!ext4_fc_eligible(inode->i_sb))
>  		return;

Here I think the !ext4_fc_eligible() check could be actually above the
ext4_should_journal_data() check - if the fs is not eligible for
fastcommit, there's no point in marking it ineligible again...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
