Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871F7386C39;
	Wed, 19 Aug 2026 12:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787141081; cv=none; b=ptxzkxNn8PKDSLLTkUzocIBYXLlEwwjaQO8aWr78vaGOpxeazJDp6ZixzBMNSmv5t4zyeQveAjGBwXI/9hNe0/98PVjnuO4gUZMiOPJMIaGIgooiw0BrmayvYzTZMz0FLWfMSri4nRWuqUp8XWNgpbUk7bdMuXTLNoZcDUD12Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787141081; c=relaxed/simple;
	bh=iCSNk4IFD0fCm7vc3siJcU2qOOOkcSBz8AVq3kiOoR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svbw7O0NTBoBHUc0MExEa67TQmR8k/iloREPwb55MQ2latbsSFLIpuY7WCVD8X6jwYarWVW6Aoe2gGDGR4Jt5hDPQnNA+5guQP4qFPBew8k7xuJKQxDv7io0HiUJHeiQoLREa5+DWrm47NEUY0mPSXQYbYx3EhhH9T2NpJSXIWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hEm/5Hhd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+FWPoZ/C; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YdqUGNG+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=49wa9mhI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hEm/5Hhd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+FWPoZ/C";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YdqUGNG+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="49wa9mhI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B4BB3ECE;
	Wed, 19 Aug 2026 12:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787141073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LS23oImEvRgY7ml+nGYytiK9IyPlK5WtfiZGdBo9Rbk=;
	b=hEm/5HhdByjVxysnwikTwpZ791otMHGTHOW4gqxHsbKjNP3lVDZBDbX3nRWCqw2FL33CuO
	oD6FwETWJCuSNBfeTGnMFAVXCSen7ZupuxhKEOsS8bIjRrEw3DuWgomkYLU+/AtBQsG7pX
	u6EJ5xcH1A5fx9ysZEoNaJKOr3BaP4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787141073;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LS23oImEvRgY7ml+nGYytiK9IyPlK5WtfiZGdBo9Rbk=;
	b=+FWPoZ/CLO7Je7jMTyGoZi16EddJ1vfMd79/6cx/IJNcZXrgJp5nu9QEfAGJEbOMn/cgpZ
	mox0WQiS8G28shAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787141069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LS23oImEvRgY7ml+nGYytiK9IyPlK5WtfiZGdBo9Rbk=;
	b=YdqUGNG+AL6z0j2qBOXG7MxT8ySZqN9L9zaVgbA8mKVy5H74Obk+6a0ZfupOQ+UdGOiJBP
	uL0LNAKk9bq1Btz7Xmz3FlI29JaDmpz/dQRLIZPFl62vgqwCGsR2MZItneQoNgzGqgDZM6
	U4X/0ZWR1mqI+vrVv6vBGVNnMEqCPIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787141069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LS23oImEvRgY7ml+nGYytiK9IyPlK5WtfiZGdBo9Rbk=;
	b=49wa9mhI6v7d56CHmxdMnWZssDvoTAQM51GGsmAOxahQO3GmyscGItA+f/QqfiZfxevS4F
	G7oqgSCl/qafCZAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51FBB2F81;
	Wed, 19 Aug 2026 12:04:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5y4CFM2bhWr8dQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 19 Aug 2026 12:04:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F0C4EA13B2; Wed, 19 Aug 2026 14:04:24 +0200 (CEST)
Date: Wed, 19 Aug 2026 14:04:24 +0200
From: Jan Kara <jack@suse.cz>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>, 
	"jack@suse.com" <jack@suse.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "junzheyu1@gmail.com" <junzheyu1@gmail.com>
Subject: Re: [PATCH] jbd2: don't advance j_fc_off before the buffer is
 recorded
Message-ID: <3jcvyeamzmgdkusfflksi4iaocjb6h5ydgisc6wigxcm7e4lm2@sim2uf6zn7cl>
References: <CGME20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
 <20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,suse.cz,suse.com,vger.kernel.org,gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:email,suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Wed 19-08-26 15:09:39, Daejun Park wrote:
> jbd2_fc_get_buf() increments journal->j_fc_off before jbd2_journal_bmap()
> and __getblk() have had a chance to fail.  When either does, the slot
> j_fc_wbuf[fc_off] is never assigned, but j_fc_off already counts it.
> 
> ext4 then fails the fast commit and falls back, and the fallback path
> reaches jbd2_fc_release_bufs() via ext4_fc_commit ->
> jbd2_fc_end_commit_fallback -> __jbd2_fc_end_commit -> ext4_fc_cleanup.
> That walks down from j_fc_off - 1 and put_bh()es every slot until it
> sees NULL, so it also touches the slot that was never written.
> j_fc_wbuf comes from a plain kmalloc() and is never zeroed, so a slot
> used for the first time holds uninitialised heap data.
> 
> Advance j_fc_off only after the buffer head has been stored.  That
> restores the invariant that j_fc_off covers exactly the filled slots,
> which is what jbd2_fc_release_bufs() relies on: the live buffers of the
> current fast commit sit above the NULLs the previous one released, so
> stopping at the first NULL is correct.
> 
> Reproduced on a KASAN kernel with an ext4 fast_commit filesystem on a
> loop device, truncating the backing file under the live mount so that
> only the journal's fast-commit region falls past the end of the device.
> __getblk() then fails for the first fast-commit block while the rest of
> the journal is still addressable, so the journal is not aborted and the
> fast commit reaches the fallback path.  j_fc_wbuf was poisoned to make
> the read of the never-written slot visible:
> 
>   BUG: KASAN: wild-memory-access in jbd2_fc_release_bufs+0x6b/0xd0
>   Write of size 4 at addr 5a5a5a5a5a5a5ab2 by task sync/961
>    jbd2_fc_release_bufs+0x6b/0xd0
>    ext4_fc_cleanup+0x97/0x830
>    __jbd2_fc_end_commit+0x37/0xc0
>    ext4_fc_commit+0x524/0x560
>    ext4_sync_file+0x3c4/0x4b0
>    __x64_sys_fsync+0x20/0x30
> 
> With this patch the same run leaves j_fc_off at 0 across repeated
> __getblk() failures and completes cleanly.
> 
> Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
> Reported-by: Yu Junzhe <junzheyu1@gmail.com>
> Closes: https://lore.kernel.org/linux-ext4/7e4b109d-64c3-444f-a5dc-93c2ca4576cc@gmail.com/
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4f..55b4ce010228 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -843,7 +843,6 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
>  
>  	fc_off = journal->j_fc_off;
>  	blocknr = journal->j_fc_first + fc_off;
> -	journal->j_fc_off++;
>  	ret = jbd2_journal_bmap(journal, blocknr, &pblock);
>  	if (ret)
>  		return ret;
> @@ -853,6 +852,7 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
>  		return -ENOMEM;
>  
>  	journal->j_fc_wbuf[fc_off] = bh;
> +	journal->j_fc_off++;
>  
>  	*bh_out = bh;
>  
> 
> base-commit: 9091c97be34083587a75db174aab51551d8e8543
> -- 
> 2.43.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
