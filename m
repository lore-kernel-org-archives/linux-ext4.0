Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562E24BCACF
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782986264; cv=none; b=rzBUSByLNTKcX69WPN6GpkEcoJYJ3OPxT7rAlq8v3mM4oUXPBHwXsJPe1Jg7xOSsgVdTrmaMQcKfkNCq4P++WrzdrW9W4UIwgEgEiEyn/eNkF4uSLe0ibVbbF4Y1C+cMOfBl+os8CX0L3MvOTeIVQnGUksLv745motAvs2rnX4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782986264; c=relaxed/simple;
	bh=BNFDrdPvq9mzRD45aFtwnk18UW4DPP3kimNwP4o8/pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nm6YkpVjTzXUk4hnqFeGRL27fpXuwGFjPF2scRP0gemZtgYd5eIUnk4KkSYiLxRKNAy39JckMC7zlszjv/sevIzUQ6PWAD0ua6KSf09MQ65wyPrOE4uo7hTML9Rc/ixnsV5AF8+tVukWL4ShWy2lmb7ch5ZiurtVirW4uaHFfs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GsEGTz3R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H0yBIV+D; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GsEGTz3R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H0yBIV+D; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GsEGTz3R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H0yBIV+D";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GsEGTz3R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H0yBIV+D"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7940C7410D;
	Thu,  2 Jul 2026 09:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782986248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qkHLi4bBeSixPSheQ5BY8WCz7v8WI2F8fgvlkqiCVKo=;
	b=GsEGTz3R1U37eZA6BNXBXTiK5XPnUww9D1bcTM8Es8MKSTdIKnXCXbig3tIM8bmEmKDcjh
	pRMs0Z3kRX5FNTbnxDa6gwdE5/rVb9UA4+epadyR3e1dy9ZQK+uH7NHBK2EWdJySaVOLWr
	Tke7cyxKadchedQd6nXFnNAYWRWK+yE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782986248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qkHLi4bBeSixPSheQ5BY8WCz7v8WI2F8fgvlkqiCVKo=;
	b=H0yBIV+DFIZ/ecyfRXlrrATOZf38h5BLlSzIJ8LlsqOBqf4EiMgxyMHx4I0jec3WCBTHJ5
	zTzPLBs7Owf0KtDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GsEGTz3R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H0yBIV+D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782986248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qkHLi4bBeSixPSheQ5BY8WCz7v8WI2F8fgvlkqiCVKo=;
	b=GsEGTz3R1U37eZA6BNXBXTiK5XPnUww9D1bcTM8Es8MKSTdIKnXCXbig3tIM8bmEmKDcjh
	pRMs0Z3kRX5FNTbnxDa6gwdE5/rVb9UA4+epadyR3e1dy9ZQK+uH7NHBK2EWdJySaVOLWr
	Tke7cyxKadchedQd6nXFnNAYWRWK+yE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782986248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qkHLi4bBeSixPSheQ5BY8WCz7v8WI2F8fgvlkqiCVKo=;
	b=H0yBIV+DFIZ/ecyfRXlrrATOZf38h5BLlSzIJ8LlsqOBqf4EiMgxyMHx4I0jec3WCBTHJ5
	zTzPLBs7Owf0KtDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E47C779AA;
	Thu,  2 Jul 2026 09:57:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B/bpGgg2RmpGGQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 09:57:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2F6CEA12AD; Thu, 02 Jul 2026 11:57:22 +0200 (CEST)
Date: Thu, 2 Jul 2026 11:57:22 +0200
From: Jan Kara <jack@suse.cz>
To: yizhang089@gmail.com
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yi.zhang@huaweicloud.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com
Subject: Re: [PATCH 3/6] ext4: track partial-zero outcome per edge in
 ext4_zero_partial_blocks()
Message-ID: <tb77wbv7gcqzkcftikip2bgftzqjdahuwsmrynfjke2prsz2kh@ux3sr3logun4>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-4-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701142009.1510104-4-yizhang089@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7940C7410D
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Wed 01-07-26 22:20:06, yizhang089@gmail.com wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Replace the single bool did_zero output of ext4_zero_partial_blocks()
> with a bitmask that records which edge (start, end, or both in the
> single-block case) was actually partial-zeroed. This allows callers to
> distinguish which edges have been zeroed, preparing for unaligned
> FALLOC_FL_WRITE_ZEROES handling in later patches.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Just some text corrections below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0b31fa873743..d68f7be4ff02 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4256,13 +4256,26 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	return 0;
>  }
>  
> +/*
> + * Zero out the unaligned head and tail of the [lstart, lstart+length)
> + * range.
> + *
> + * On return, @partial_zeroed records which edges actually got
> + * partial-zeroed.  Set EXT4_PARTIAL_ZERO_START/EXT4_PARTIAL_ZERO_END if
> + * the head/tail block got actually partially zeroed (in written, dirty
> + * unwritten or delalloc state).  Cleared if the head/tail block is a
> + * hole or a clean unwritten block, in which case there is nothing needs
								      ^^^
that needs zeroing.

> + * to zero.  When the head and tail land in the same block, both bits
> + * are set together on a successful zero.
					^^^ zeroing

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
