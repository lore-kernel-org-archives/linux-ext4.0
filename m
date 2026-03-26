Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B30F3783B1
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518300; cv=none; b=P8jrNuNcN9v0apdBlCw1pgS5GeqVELlsXZ1MNl66IOfAojUtkx52dm4oFWp8WRGQfTExuuY858wZ25Yuptci+zmiZ8QUIFaZJOl+sl8FSQfOcWa5AZ0kX001AbJ9uIm1MNLuCcDb6rtfmKnX4PvXiXDCqv0pY6BepJ1rW1qUJjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518300; c=relaxed/simple;
	bh=vHPHPG5d9/yXTYhUTtZRHz9H+6lLSXLeAkBtYZZlxjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/WZOl6yAC2uxAUSDrRD6nq9pLyBVNSegnO3kK6V9DvY8uMPd2PAyX8aasAeXSIQTx+hmDp4j0G2EKabeb/sFMlzo15Mo0XFcb6g9B0mlu+6Oif5TpXuyPRcWa+hs7Wr/bDZWXMv3kYnRt91aV6Xxm4fbQ99Ad7ZECUqecYgswA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=n2vsraFc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QvWiSBIs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=evwTSG90; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tc0rgANT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="n2vsraFc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QvWiSBIs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="evwTSG90";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tc0rgANT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBDB15BCD5;
	Thu, 26 Mar 2026 09:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8tCIjeei0ZSD/oWLx6brqQG/yznmr9Qepde+lWH8eo=;
	b=n2vsraFcEuECqsNvMWOPF0RYASXb1MLxZ13E7m+7aUR6MbUQKF1dpkpxBHvdDpJxs1t6uy
	k6bR+6i9tSkXIsz/l+fRvZPheXHH14sQ5ltgVebWVXe3VAyFWj7XzEg6WGuAO4utS7sdw3
	aFzkcSANp8+31Gn1miehufo734kjff0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8tCIjeei0ZSD/oWLx6brqQG/yznmr9Qepde+lWH8eo=;
	b=QvWiSBIs5if0OEFgvGX8ys5aF+B0Q+Y0d3H3s2q05fyFwDp4ZGQEeM+rwSxnOC+O7THW9g
	ZYVAD4PwKEEmjjDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8tCIjeei0ZSD/oWLx6brqQG/yznmr9Qepde+lWH8eo=;
	b=evwTSG908SIaOgJKqcxBuieI2VIRwLMSUchnAAF3syuhWTsrz4SR8d40NdagkePIlEGs4q
	Z+FAAfTzjqTi7xFA3lT6lgKl+3Yw1513agJF9c3PDamR/qDdv+5NnQaUg1c2IwQDSp335l
	2+dkD9SDOsYZUkTDPjA8RruLd0yu8a4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8tCIjeei0ZSD/oWLx6brqQG/yznmr9Qepde+lWH8eo=;
	b=tc0rgANTV4Gwuo2cio4ocgBzwfSg9LmKOZgvh4yQyaPdUhSx8+tWMIFzo6T69gNyPNzrre
	fN1Pwpy3bcK4hTDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1D914A0A3;
	Thu, 26 Mar 2026 09:44:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RnsdNxYAxWkqVQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:44:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A3D3FA0976; Thu, 26 Mar 2026 10:44:46 +0100 (CET)
Date: Thu, 26 Mar 2026 10:44:46 +0100
From: Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: handle wraparound when searching for blocks
 for indirect mapped blocks
Message-ID: <ah56sv6rtdspvsvvglzc6gc5qichykvj57z5s6naiveztidad3@2oiqdprcnu3c>
References: <20260326045834.1175822-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326045834.1175822-1-tytso@mit.edu>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Flag: NO

On Thu 26-03-26 00:58:34, Theodore Ts'o wrote:
> Commit 4865c768b563 ("ext4: always allocate blocks only from groups
> inode can use") restricts what blocks will be allocated for indirect
> block based files to block numbers that fit within 32-bit block
> numbers.
> 
> However, when using a review bot running on the latest Gemini LLM to
> check this commit when backporting into an LTS based kernel, it raised
> this concern:
> 
>    If ac->ac_g_ex.fe_group is >= ngroups (for instance, if the goal
>    group was populated via stream allocation from s_mb_last_groups),
>    then start will be >= ngroups.
> 
>    Does this allow allocating blocks beyond the 32-bit limit for
>    indirect block mapped files? The commit message mentions that
>    ext4_mb_scan_groups_linear() takes care to not select unsupported
>    groups. However, its loop uses group = *start, and the very first
>    iteration will call ext4_mb_scan_group() with this unsupported
>    group because next_linear_group() is only called at the end of the
>    iteration.
> 
> After reviewing the code paths involved and considering the LLM
> review, I determined that this can happen when there is a file system
> where some files/directories are extent-mapped and others are
> indirect-block mapped.  To address this, add a safety clamp in
> ext4_mb_scan_groups().
> 
> Fixes: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>

Yeah, this looks like all that's needed. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v2:
>   * Remove extra checks that were not needed once we add the clamp
>     in ext4_mb_scan_groups().
> 
>  fs/ext4/mballoc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..b10db5d7545b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1199,6 +1199,8 @@ static int ext4_mb_scan_groups(struct ext4_allocation_context *ac)
>  
>  	/* searching for the right group start from the goal value specified */
>  	start = ac->ac_g_ex.fe_group;
> +	if (start >= ngroups)
> +		start = 0;
>  	ac->ac_prefetch_grp = start;
>  	ac->ac_prefetch_nr = 0;
>  
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
