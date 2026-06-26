Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F125B2E7372
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 14:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782482843; cv=none; b=XcqdZ7pldARv7JrNCWfKJRDkJTmQrXGMvPsg7V1URFZKFj4eiJ/x/De1Dgj1+al+jjCcradj6Nf0fdTxQo8uZV0TJpLhcPoJgUrAEHluxMPOGBwYNXIFZcPm7YJTVxS6oJh/Lv3LGifA5p00t3nyOTDOLVEweF2IGY0LhmeISsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782482843; c=relaxed/simple;
	bh=ggYhmLXsklKHDGfEGbZ2OinClFYRbHZ0jK89iG1S590=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E60/8sDlkGAOyQoS5pK4Au0XdJ/1fk9X+9bNj/iABPsCvDZ3HFtXnShkOgxZksouFYY3vRp9zjWogODt2oyqiSIKrv6yGRTsVFOH/LYYkgleEVf7pyk4Ar2XmkN+QhkGM8LVVkVL6E9FDPpskp3OgKVhVcevS41lOSdw1+nmkZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SPY3BIAq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=E8KGZAXg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SPY3BIAq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=E8KGZAXg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SPY3BIAq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="E8KGZAXg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SPY3BIAq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="E8KGZAXg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0604A76392;
	Fri, 26 Jun 2026 14:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782482840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LY3e6GukNy6jxzmite9G/y4TOJ2e7KhgW7U0CrlcxdI=;
	b=SPY3BIAqZYU4fYFw4RLVWAlczgNsk3onMSQANDY5Q0FSYtCsIKb0VmJnPaysQ7vlaEVscw
	iTMLSjHv1f2pKcXvF0h2D8255W3W/sID8M06fCQvtHFEZlFU2HDQgBsSOMBuFpIegSh/Bt
	tuT+rZ7avLABTbO4BNw1EJOW4SBLfRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782482840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LY3e6GukNy6jxzmite9G/y4TOJ2e7KhgW7U0CrlcxdI=;
	b=E8KGZAXgf7DwsjgB/71v38dx8GQaln5ZyVwmBcMUqG+Uy/2nfaIR8rjrfc5icG0kO/TDZv
	sNrvz4KJL3G868Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782482840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LY3e6GukNy6jxzmite9G/y4TOJ2e7KhgW7U0CrlcxdI=;
	b=SPY3BIAqZYU4fYFw4RLVWAlczgNsk3onMSQANDY5Q0FSYtCsIKb0VmJnPaysQ7vlaEVscw
	iTMLSjHv1f2pKcXvF0h2D8255W3W/sID8M06fCQvtHFEZlFU2HDQgBsSOMBuFpIegSh/Bt
	tuT+rZ7avLABTbO4BNw1EJOW4SBLfRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782482840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LY3e6GukNy6jxzmite9G/y4TOJ2e7KhgW7U0CrlcxdI=;
	b=E8KGZAXgf7DwsjgB/71v38dx8GQaln5ZyVwmBcMUqG+Uy/2nfaIR8rjrfc5icG0kO/TDZv
	sNrvz4KJL3G868Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1008779AB;
	Fri, 26 Jun 2026 14:07:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ew7TOpeHPmo4UwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 26 Jun 2026 14:07:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8813CA10A3; Fri, 26 Jun 2026 16:07:15 +0200 (CEST)
Date: Fri, 26 Jun 2026 16:07:15 +0200
From: Jan Kara <jack@suse.cz>
To: Gerald Yang <gerald.yang@canonical.com>
Cc: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org, 
	gerald.yang.tw@gmail.com
Subject: Re: [PATCH v2] ext4: clear stale xarray tags on folios skipped
 during writeback
Message-ID: <5wteis5us7zxsjmuidws3llwgqyk27uoa35hybfyvrwenzu7m7@7kntxhzqmkwe>
References: <20260625160127.162272-1-gerald.yang@canonical.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625160127.162272-1-gerald.yang@canonical.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,suse.cz,vger.kernel.org,gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Fri 26-06-26 00:01:23, Gerald Yang wrote:
> In data=journal mode, the writeback thread can hit the
> WARN_ON_ONCE(sb_rdonly(sb)) in ext4_journal_check_start() while the
> superblock is being remounted read-only during reboot:
> 
> Workqueue: writeback wb_workfn (flush-253:0)
> RIP: 0010:ext4_journal_check_start+0x8b/0xd0
> Call Trace:
>   __ext4_journal_start_sb+0x3c/0x1e0
>   mpage_prepare_extent_to_map+0x4af/0x580
>   ext4_do_writepages+0x3c0/0x1080
>   ext4_writepages+0xc8/0x1a0
>   do_writepages+0xc4/0x180
>   __writeback_single_inode+0x45/0x2f0
>   writeback_sb_inodes+0x26b/0x5d0
>   __writeback_inodes_wb+0x54/0x100
>   wb_writeback+0x1ac/0x320
>   wb_workfn+0x394/0x470
> 
> And followed by the warning:
> EXT4-fs warning (device vda1): ext4_evict_inode:195: inode #6263:
> comm (sd-umount): data will be lost
> 
> This issue is not reproduced every time, but frequently.
> The reproduction step is to create a VM with 8 CPUs, 16G memory and
> setup data=journal:
> sudo tune2fs -o journal_data /dev/vda1
> Run fio:
> rm -f fiotest
> fio --name=fiotest --rw=randwrite --bs=4k --runtime=6 --ioengine=libaio
> --iodepth=256 --numjobs=8 --filename=fiotest --filesize=30G
> --group_reporting
> Reboot the VM, and check the console output from:
> virsh console testvm
> 
> But there is no dirty inode, folio_clear_dirty_for_io clears PG_dirty
> but leaves tags PAGECACHE_TAG_DIRTY and PAGECACHE_TAG_TOWRITE set which
> are only cleared by __folio_start_writeback.
> In data=journal mode, jbd2 checkpoints the journalled data to its final
> location and clears its own dirty flag without touching folio PG_dirty
> or xarray dirty flags.
> The commit f4a2b42e7891 ("ext4: fix stale xarray tags after writeback")
> fixes when PG_dirty is still set but there is no dirty page.
> Another case is PG_dirty is cleared, but PAGECACHE_TAG_DIRTY and
> PAGECACHE_TAG_TOWRITE is still set. In this case, writeback thread
> checks clean folio and skips it in mpage_prepare_extent_to_map:
> if (!folio_test_dirty(folio) ||
>     ...
>         folio_unlcok(folio);
> 	continue
> 
> And never reaches ext4_bio_write_folio where the commit f4a2b42e7891
> clears the stale xarray tags. Print debug logs after the filesystem
> is remounted read-only:
> writepages RDONLY nrpages=2048 dirtytag=1 wbtag=0 towrite=1 sync=0
> And all folios are actually clean:
> folio idx=3 dirty=0 wb=0 checked=0 dirtybuf=0 jbddirty=0 mapped=1
> ...
> 
> We need to clear the xarray stale tags for such clean folios by
> cycling them through writeback in the skip path, the same way
> f4a2b42e7891 does in ext4_bio_write_folio.
> 
> Fixes: dff4ac75eeee ("ext4: move keep_towrite handling to ext4_bio_write_page()")
> Signed-off-by: Gerald Yang <gerald.yang@canonical.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

> ---
> Changes in v2:
> Split the top level condition based on Jan's suggestion
> 
>  fs/ext4/inode.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..150f8789f0aa 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2694,13 +2694,25 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 * page is already under writeback and we are not doing
>  			 * a data integrity writeback, skip the page
>  			 */
> -			if (!folio_test_dirty(folio) ||
> -			    (folio_test_writeback(folio) &&
> -			     (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
> +			if ((folio_test_writeback(folio) &&
> +			    mpd->wbc->sync_mode == WB_SYNC_NONE) ||
>  			    unlikely(folio->mapping != mapping)) {
>  				folio_unlock(folio);
>  				continue;
>  			}
> +			/*
> +			 * If the folio is clean, skip writing it back.
> +			 * Cycle the folio through the writeback state
> +			 * though, to clear stale xarray tags.
> +			 */
> +			if (!folio_test_dirty(folio)) {
> +				if (!folio_test_writeback(folio)) {
> +					__folio_start_writeback(folio, false);
> +					folio_end_writeback(folio);
> +				}
> +				folio_unlock(folio);
> +				continue;
> +			}
>  
>  			folio_wait_writeback(folio);
>  			BUG_ON(folio_test_writeback(folio));
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
