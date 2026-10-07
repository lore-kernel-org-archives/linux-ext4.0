Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C500F3368BD;
	Wed,  7 Oct 2026 06:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791356233; cv=none; b=gL3uaqpYTXsWPEpjo8ZSYpk+gALfBcSLZ5LlXe+dpqw5OMPPfHJ/EFc3/i0YNfw4d74FYHu3MS51T5wp/fOk8IHStjCULMgPeGmlzC6FXRXGq2TsllCcKNRU6FZ6TTopJQmBieg/mx/tT/+8QmYkIms8kdfsDkTNi/SAcMwrvlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791356233; c=relaxed/simple;
	bh=9rfwHMUwyz8VC6Ti7njLyE0s9M8EFCTF6JbmUK8pRzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRLnwglDP+SXMT6bu18IEvY03eUVU4wMXz/Q6Azp23bqbltLn5Nj0j3vEm1f9UAEyUehgeOug0Y+9TKVTBQBIBarqb/7ndVwzgI5U7KfCjJMGTkR14mQ2KvDv1XIslAGenOzbsqsjzFi/1w96/df6XRUNAD/bCT2F927PInNWhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PswEdYdZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9T3719O2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DbIWPe7y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bzduENZv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PswEdYdZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9T3719O2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DbIWPe7y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bzduENZv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2BE8B21FEC;
	Wed,  7 Oct 2026 06:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791356225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovKT2YbwMSUYimytgA1EZdkwM2zxLkfdWwlZy9wzhpk=;
	b=PswEdYdZ3GC1sdmhJ1y2nPJsOth7ivBWDNBl0ip6+4CicHvpDuG2RjRABX6I17d8/OHvdw
	UqvKfQQCtJuP+cVQfeX9Nf07338I286Vyv3Y1JppQpIudNvEY8KIwg05TxAla7OLbEhmY3
	bnOZbm55VXa6g+5GGZt9NgTH0L418+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791356225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovKT2YbwMSUYimytgA1EZdkwM2zxLkfdWwlZy9wzhpk=;
	b=9T3719O22eNHrUswr/xD0XSV0eBprmqHceHQ8+OrG+g32bPe4A8eyWGd2ppCONMSyXmaUi
	QpgBFyLT36suZRCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791356221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovKT2YbwMSUYimytgA1EZdkwM2zxLkfdWwlZy9wzhpk=;
	b=DbIWPe7yWMf83WyGdVgbm6s47PQV7JnuMt42QwD+dCx2QKVE5wVo9PWMHJqqZSte/Y3W2n
	v0bNHfHjFZr7wOSJXuektdR4kEpL2gRmA+kbKuZrFhrVOWiB2YOAkpC2GC3nl5JHkcGJEZ
	jWeoREGEF64kNtD09gL6WpRxPB9/L40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791356221;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovKT2YbwMSUYimytgA1EZdkwM2zxLkfdWwlZy9wzhpk=;
	b=bzduENZvYZExcguUc3GCEEijBVjvEdTQ0/uZ0s7U9WYgWfMomj1H7ASqG7R9OJoEHRQG+d
	gz3YXNcPMhSnRHDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8B7013B94;
	Wed,  7 Oct 2026 06:57:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0HwHKTztxWpeQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Oct 2026 06:57:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 02E99A13FE; Wed, 07 Oct 2026 08:56:55 +0200 (CEST)
Date: Wed, 7 Oct 2026 08:56:55 +0200
From: Jan Kara <jack@suse.cz>
To: Hsiu-Hsien Lee <swinds24@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: don't fail journal recovery on an incomplete
 fast commit
Message-ID: <mlgjr7bdg2b6ay6ggooqam6xkiwlyytslgar3csqmq3loz4d7a@7sqyk2lj55li>
References: <20261007040829.2074386-1-swinds24@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007040829.2074386-1-swinds24@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,suse.cz,dilger.ca,gmail.com,linux.alibaba.com,linux.ibm.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO

On Wed 07-10-26 12:08:29, Hsiu-Hsien Lee wrote:
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
> when an earlier fast commit in the area has a valid tail.
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

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Drop the warning and the helper, use ext4_debug() and set the return
>   value inline (Jan Kara)
> - v1: https://lore.kernel.org/linux-ext4/20261006070005.1209234-1-swinds24@gmail.com/
> 
> Testing: re-tested on 6.6.y with the same crash images used for v1 and
> for the unpatched baseline (identical files).  Without the patch, all
> torn first-fast-commit variants fail to mount rw and ro with "JBD2:
> journal recovery failed".  With v2, all of them mount rw and ro, the
> state of the last full commit is recovered and e2fsck -fn is clean.
> Images with intact fast commits, or with a torn fast commit after a
> valid one, behave the same with and without the patch.  The tail was
> torn by zeroing whole blocks, so only the invalid tag length path was
> exercised.
> 
>  fs/ext4/fast_commit.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf370..165950e2b7d9 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2443,6 +2443,12 @@ static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
>   * It returns a negative error to indicate that there was an error. At the end
>   * of a successful scan phase, sbi->s_fc_replay_state.fc_replay_num_tags is set
>   * to indicate the number of tags that need to replayed during the replay phase.
> + *
> + * An invalid tag or a tail that does not match ends the scan without an error.
> + * This is what a fast commit that was only partially written before a crash
> + * looks like.  Its tail is written last and fsync() does not return before
> + * the tail is on disk, so such a fast commit was never reported as durable and
> + * is simply dropped, like jbd2 drops a transaction without a commit block.
>   */
>  static int ext4_fc_replay_scan(journal_t *journal,
>  				struct buffer_head *bh, int off,
> @@ -2489,8 +2495,9 @@ static int ext4_fc_replay_scan(journal_t *journal,
>  		val = cur + EXT4_FC_TAG_BASE_LEN;
>  		if (tl.fc_len > end - val ||
>  		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
> -			ret = state->fc_replay_num_tags ?
> -				JBD2_FC_REPLAY_STOP : -ECANCELED;
> +			ext4_debug("Scan phase, invalid tag length, blk %lld\n",
> +				   bh->b_blocknr);
> +			ret = JBD2_FC_REPLAY_STOP;
>  			goto out_err;
>  		}
>  		ext4_debug("Scan phase, tag:%s, blk %lld\n",
> @@ -2530,8 +2537,9 @@ static int ext4_fc_replay_scan(journal_t *journal,
>  				state->fc_regions_valid =
>  					state->fc_regions_used;
>  			} else {
> -				ret = state->fc_replay_num_tags ?
> -					JBD2_FC_REPLAY_STOP : -EFSBADCRC;
> +				ext4_debug("Scan phase, invalid tail, blk %lld\n",
> +					   bh->b_blocknr);
> +				ret = JBD2_FC_REPLAY_STOP;
>  			}
>  			state->fc_crc = 0;
>  			break;
> @@ -2551,8 +2559,9 @@ static int ext4_fc_replay_scan(journal_t *journal,
>  				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
>  			break;
>  		default:
> -			ret = state->fc_replay_num_tags ?
> -				JBD2_FC_REPLAY_STOP : -ECANCELED;
> +			ext4_debug("Scan phase, unknown tag %d, blk %lld\n",
> +				   tl.fc_tag, bh->b_blocknr);
> +			ret = JBD2_FC_REPLAY_STOP;
>  		}
>  		if (ret < 0 || ret == JBD2_FC_REPLAY_STOP)
>  			break;
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
