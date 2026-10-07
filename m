Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8137E3BB690;
	Wed,  7 Oct 2026 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381294; cv=none; b=GMVicV6iWiieiGfastup29ZGQuLsgVJFKLxzV4tG0lVU0JQU61XPuP+Kv4etBMC97b+HBzWJdLbxrLdKPp7VmPo/puxQfHxBshe3rkAbFP13ZQEgpjsHz3MUbgRFRMSVbjxaSEmpX8eOusgpIUQpQzZyveX+eBPtzK4cnXWId+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381294; c=relaxed/simple;
	bh=vVz0B+Hq630lyHWO4dsa9e8Ot+ru6vRmAqfbGXGksgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8J6OAll0mlq8Z1wfSpVun8sDebt2BmbshysF/uZOpDoSwKpQNqHFwTUQHoayzyKkTRJvqb3jhQqZ8SdT2rW1ZNyw6UXNttDvYVnFfqR5JboXAERihqsFF4RU2M+FTz+DHjKfaFdeCbuepYDycG6bZ3dBk7fYG2Hrx9kK68kT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vb6HQXqA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qjN4hrYc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BNxYnCPQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FusdUlgE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vb6HQXqA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qjN4hrYc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BNxYnCPQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FusdUlgE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0401121B95;
	Wed,  7 Oct 2026 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791381282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzNnHgupEzV3mK1/juDW7c5YhcWqPdBTDKYxTARVvlg=;
	b=vb6HQXqAfoJm5noRuBFC8l7dS4hMh0f6t9XyKKhRAfWSGFNXAke+77yz3bMXROZECN2ihG
	W1i6pilaJUGSTUM0Q8p89pG/5g4DTwe/LVAWrhQ175hfcYyQmcIoaoPLy9LZPCgn7i+P8p
	fYjtziFYnRztNENf5iNx1ZfMSnMOM6w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791381282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzNnHgupEzV3mK1/juDW7c5YhcWqPdBTDKYxTARVvlg=;
	b=qjN4hrYc9Zu+mspBreEaYRXMKsmBoxmokWk13KIQ+ocEvMgD8bcN3Gk9z6AcLmRZr/KxNs
	uyDVi9s/SCs7wdAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BNxYnCPQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FusdUlgE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791381281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzNnHgupEzV3mK1/juDW7c5YhcWqPdBTDKYxTARVvlg=;
	b=BNxYnCPQ1oQj1kdqv1CJCVT22Brp+5Um+8bbSnGq1KfIcdwxEZHnXDJ3NBN0tO2jezWaah
	DL3tFgzivl+Ri7dD57DRFko5RltDir+Rtf39mRN4YQN97q8jPRA9HlmH8DOa3DuzjjbOZI
	wGZBiGy18Z2mhVi7vKL3muYVFh1ZjPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791381281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzNnHgupEzV3mK1/juDW7c5YhcWqPdBTDKYxTARVvlg=;
	b=FusdUlgEIFGpltAeuxlWD+2E21lRax+ngzGmb52071KQxPL+ibx7TdTiQA0wZLhegTsPgF
	Iy6iLkN/2F+Zv1BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC43713312;
	Wed,  7 Oct 2026 13:54:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EZU8JSBPxmqFJwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Oct 2026 13:54:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1F6BCA13FE; Wed, 07 Oct 2026 15:54:40 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:54:40 +0200
From: Jan Kara <jack@suse.cz>
To: daejun7.park@samsung.com
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
	Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: skip holes when shrinking the extent tree in fast
 commit replay
Message-ID: <oyy4hynhfgoiqjxcwmr32xr6asbwi5wsfen4fu6l5ipnzpdddz@6fnbt2psuxio>
References: <20261007-ext4-fc-replay-shrink-v1-1-0e45fc03030d@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-ext4-fc-replay-shrink-v1-1-0e45fc03030d@samsung.com>
X-Spam-Flag: NO
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,suse.cz,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,linux.beauty];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,samsung.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 0401121B95

On Wed 07-10-26 09:41:31, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> ext4_ext_replay_shrink_inode() walks the extents of an inode from block
> 0 up to the given end and tries to merge each one with its neighbours.
> When the walk is in a hole that follows an extent, ext4_find_extent()
> returns that extent, and the walk moves on by a single block. Replay
> calls it up to i_size after every ADD_RANGE and DEL_RANGE tag, so the
> time recovery takes is proportional to the number of tags times the
> number of hole blocks below i_size.
> 
> After a crash, mount can be busy for minutes. Replaying a single
> ADD_RANGE tag, for one block written and fsynced in a sparse file with
> a 1 TiB i_size, kept mount busy for 157 seconds. Replaying four fast
> commits of a sparse file with 512 written regions (2048 ADD_RANGE tags,
> and 2044 DEL_RANGE tags for the gaps between them) took 44 seconds when
> the file was 64 MiB and 177 seconds when it was 256 MiB. With this
> change the 1 TiB case takes less than 0.1 seconds, and the other two 3
> seconds each.
> 
> When the walk is in such a hole, continue at the next extent, as
> returned by ext4_ext_next_allocated_block(), or stop if there is none.
> For each block skipped this way, the old walk found the same extent
> again and retried the same merges, so the resulting tree is the same.
> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Tested in QEMU on ext4 dev 9091c97be340 with a 2 GiB file-backed virtio
> disk and 4 KiB blocks, crashing by killing QEMU and timing mount(8).
> Every fsynced block was verified and e2fsck -fn was clean in each run.
> A 1 GiB file with 40 such fast commits (20480 ADD_RANGE and 20440
> DEL_RANGE tags) took 31.5 seconds with this change. xfstests ext4/044
> ext4/045 generic/455 generic/456 generic/482 with -O fast_commit give
> the same results as without it (generic/455 fails on both, at different
> marks).
> 
> The walk still visits every extent from block 0 for each tag. Bounding
> it to the extents around the tag's range, or shrinking once per inode at
> the end of replay, could be a follow-up.
> ---
>  fs/ext4/extents.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 836396ea79..df7e1ccb94 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -6217,8 +6217,10 @@ void ext4_ext_replay_shrink_inode(struct inode *inode, ext4_lblk_t end)
>  		}
>  		old_cur = cur;
>  		cur = le32_to_cpu(ex->ee_block) + ext4_ext_get_actual_len(ex);
> +		/* ex ends before old_cur, which is in a hole: skip the hole */
>  		if (cur <= old_cur)
> -			cur = old_cur + 1;
> +			cur = max(old_cur + 1,
> +				  ext4_ext_next_allocated_block(path));
>  		ext4_ext_try_to_merge(NULL, inode, path, ex);
>  		down_write(&EXT4_I(inode)->i_data_sem);
>  		ext4_ext_dirty(NULL, inode, &path[path->p_depth]);
> 
> ---
> base-commit: 9091c97be34083587a75db174aab51551d8e8543
> change-id: 20261006-ext4-fc-replay-shrink-c42988822156
> 
> Best regards,
> -- 
> Daejun Park <daejun7.park@samsung.com>
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
