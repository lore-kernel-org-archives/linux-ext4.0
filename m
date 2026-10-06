Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450813B47D2;
	Tue,  6 Oct 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791302892; cv=none; b=DObfBq7EfEWCrEWK19O3yPUhp3ZBSCmMBb7+/LnqJwdP6ZuG3TRFsqpZn53WXKeE4Flklhhwu21nmYDZvesDCxdzNhoz/I17Dbj5lW/76rbz+ijIXg0SrhqJgLTwwT+HQOKbaW+0Xkt5SwXLRzlwWmVA3TpWAPK5KEjeP8UJYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791302892; c=relaxed/simple;
	bh=ZMbfy5T1L22ciFYreqBQEiV5PiUklSJsjaGzDALj2yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDyeYh6pCAly8obAzEscv08By24ivQBzspIFg8vwBHm7LGMPc7PlyLJyrfTFngFTussFC+uBqE2pEPU6WeGc3+t2XFSr4T3P7+b+i3bmCe4gxBflDI5XKnAlNwIPTcIbRXVcxRFgV0zqaFnAivpO8CGqpR+kU84kF9i7sZBdmJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tI9mxjP+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oHbEE9Rm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bNMoP48F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZB5Aq7VM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tI9mxjP+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oHbEE9Rm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bNMoP48F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZB5Aq7VM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB9361F7E7;
	Tue,  6 Oct 2026 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791302883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpz0lypCKncyT6u1lIVJMRv1p/Y8ZdSjusZqENW2IY4=;
	b=tI9mxjP+BcEAcaXMpM5yIQeIKtl2erhMgGxZMBaoNbLiAn/ralilVAYvRMSCg83oXE2Dul
	/rcQNYaUhlbQ2OqlYInBK/GKI9uScry26MaNAsQbOkq6fu5BxXGkz5ykD86m7XzIXzB1ed
	H4OhtrUwfi1O5q/t+oAWMPVGAIQ6At4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791302883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpz0lypCKncyT6u1lIVJMRv1p/Y8ZdSjusZqENW2IY4=;
	b=oHbEE9RmexxR05ENl2aqtxKfdPBNl48y3O1UYrNERHHiSqZIYvi7aocxjVBrhvSsXdA50u
	1dcuaoWl4xbYd9Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bNMoP48F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZB5Aq7VM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791302879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpz0lypCKncyT6u1lIVJMRv1p/Y8ZdSjusZqENW2IY4=;
	b=bNMoP48FmyYjm+tRRP/ZrF6wQdg14oh71FKhGIH9VaXPBPzjmewgeEJJweNXm868z2ePhn
	yHatpZLA5mOsjwLz4v725ezar9rWeNV6gUgnZepvfKF4cmkC25B0vdNcMCCU/vOj/AGV8f
	3LMWV8zBfkNkazPT0BK7b+c1AsxGQPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791302879;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpz0lypCKncyT6u1lIVJMRv1p/Y8ZdSjusZqENW2IY4=;
	b=ZB5Aq7VMhp+yxN0eSppGIRjCN3+irL+38c17gGGufLxFRp8acBv45111meZrEjBGmPdNAH
	exF56cVrA3O3oZAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A024133CF;
	Tue,  6 Oct 2026 16:07:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NIufFd8cxWrNFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 06 Oct 2026 16:07:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DD43BA13FA; Tue, 06 Oct 2026 18:07:58 +0200 (CEST)
Date: Tue, 6 Oct 2026 18:07:58 +0200
From: Jan Kara <jack@suse.cz>
To: Hsiu-Hsien Lee <swinds24@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: don't fail journal recovery on an incomplete fast
 commit
Message-ID: <s3rlm3edtb4hfcggiqkqotywfhobjnwmc2v373nwvkwihitstg@66kypvunlqqm>
References: <20261006070005.1209234-1-swinds24@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006070005.1209234-1-swinds24@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,suse.cz,gmail.com,linux.alibaba.com,linux.ibm.com,huawei.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AB9361F7E7
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Tue 06-10-26 15:00:05, Hsiu-Hsien Lee wrote:
> If the system crashes while the first fast commit after a full commit is
> being written, the fast commit area can hold the head of that fast
> commit without a valid tail.  ext4_fc_replay_scan() treats this as an
> error as long as no valid tail has been seen: an invalid tag length or
> an unknown tag returns -ECANCELED, a tail with a wrong tid or checksum
> returns -EFSBADCRC.  jbd2_journal_recover() then fails, the file system
> can be mounted neither read-write nor read-only, and the regular journal
> transactions committed before the fast commit are not replayed either:
> 
>   JBD2: journal recovery failed
>   EXT4-fs (sdb): error loading journal
> 
> The tail is written last and fsync() does not return before it has
> completed, so an incomplete fast commit was never reported as durable.
> Handle it like jbd2 handles a transaction without a valid commit block:
> stop the scan and replay what is valid.  This is already what happens
> when an earlier fast commit in the area has a valid tail.  Log a
> warning so that the dropped fast commit is visible.
> 
> Reproducer, with the power cut emulated by copying the device while it
> is mounted:
> 
>   mkfs.ext4 -O fast_commit /dev/sdb
>   mount /dev/sdb /mnt; mkdir /mnt/d
>   create 20 files in /mnt/d; sync
>   write a fragmented file and modify the 20 files, fsync one file
>       (one fast commit spanning several blocks)
>   copy /dev/sdb while still mounted, then zero the block holding the
>   fast commit tail in the copy
>   mount the copy
> 
> Without this patch the mount fails as above.  With it, the mount
> succeeds, the state after sync is recovered and e2fsck finds no errors.
> The same holds when a full commit precedes the torn fast commit, in
> which case the full commit is now replayed as well.
> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Assisted-by: Claude Opus 5.5
> Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>
> ---
>  fs/ext4/fast_commit.c | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf370..5649447b9524 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2427,6 +2427,26 @@ static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
>  	return false;
>  }
>  
> +/*
> + * The fast commit area ends with an invalid tag or a tail that does not
> + * match.  This is how a fast commit that was only partially written before
> + * a crash looks like: its tail is written last and fsync() only returns
> + * after the tail write has completed, so nobody was told that this fast
> + * commit is durable and it can simply be dropped, the same way jbd2 drops
> + * a transaction without a valid commit block.  Everything up to the last
> + * valid tail is still replayed.
> + */
> +static int ext4_fc_replay_scan_end(struct super_block *sb,
> +				   struct ext4_fc_replay_state *state,
> +				   int off, const char *reason)
> +{
> +	if (!state->fc_replay_num_tags)
> +		ext4_msg(sb, KERN_WARNING,
> +			 "ignoring incomplete fast commit at block %d: %s",
> +			 off, reason);

I don't think there's need to print any message when discovering incomplete
fast commit. As you mention, it is a perfectly normal situation (similarly
as incomplete normal transaction we spot in a journal). I'd perhaps just
print ext4_debug() message (and I don't think conditioning on
fc_replay_num_tags makes sense in that case. So probably just drop the
helper function and print the debug message and set the return value
inline...

								Honza

> +	return JBD2_FC_REPLAY_STOP;
> +}
> +
>  /*
>   * Recovery Scan phase handler
>   *
> @@ -2440,7 +2460,9 @@ static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
>   * This function returns JBD2_FC_REPLAY_CONTINUE to indicate that SCAN is
>   * incomplete and JBD2 should send more blocks. It returns JBD2_FC_REPLAY_STOP
>   * to indicate that scan has finished and JBD2 can now start replay phase.
> - * It returns a negative error to indicate that there was an error. At the end
> + * It returns a negative error to indicate that there was an error. An invalid
> + * or incomplete fast commit at the end of the area is not an error, see
> + * ext4_fc_replay_scan_end(). At the end
>   * of a successful scan phase, sbi->s_fc_replay_state.fc_replay_num_tags is set
>   * to indicate the number of tags that need to replayed during the replay phase.
>   */
> @@ -2489,8 +2511,8 @@ static int ext4_fc_replay_scan(journal_t *journal,
>  		val = cur + EXT4_FC_TAG_BASE_LEN;
>  		if (tl.fc_len > end - val ||
>  		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
> -			ret = state->fc_replay_num_tags ?
> -				JBD2_FC_REPLAY_STOP : -ECANCELED;
> +			ret = ext4_fc_replay_scan_end(sb, state, off,
> +						      "invalid tag length");
>  			goto out_err;
>  		}
>  		ext4_debug("Scan phase, tag:%s, blk %lld\n",
> @@ -2530,8 +2552,8 @@ static int ext4_fc_replay_scan(journal_t *journal,
>  				state->fc_regions_valid =
>  					state->fc_regions_used;
>  			} else {
> -				ret = state->fc_replay_num_tags ?
> -					JBD2_FC_REPLAY_STOP : -EFSBADCRC;
> +				ret = ext4_fc_replay_scan_end(sb, state, off,
> +							      "invalid tail");
>  			}
>  			state->fc_crc = 0;
>  			break;
> @@ -2551,8 +2573,8 @@ static int ext4_fc_replay_scan(journal_t *journal,
>  				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
>  			break;
>  		default:
> -			ret = state->fc_replay_num_tags ?
> -				JBD2_FC_REPLAY_STOP : -ECANCELED;
> +			ret = ext4_fc_replay_scan_end(sb, state, off,
> +						      "unknown tag");
>  		}
>  		if (ret < 0 || ret == JBD2_FC_REPLAY_STOP)
>  			break;
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
