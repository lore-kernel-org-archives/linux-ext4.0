Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795428560;
	b=E70JATNb6QPjMA1niKshxSpziV4otwsJwVwQDGI6DZWy5wXOZ2xoZ8idNa+QhWERvSsk
	 hb/taXFw8qJavGQrFe08/I0re+FOkJ6c2X/HI26CJSZaZ3u2iZAprf2P2hZaG37ToXrbz
	 ceeyIYMtLUif5rVLy8FugGjSTvVAdE3buLArBylcBqtoZ/bNkdJXE2HgHl19XfHGdqKVt
	 oMNRTTSTMsVdBOfi4yq7lO8A2L5DApHqx2+yST2fLNspgjo3SvyBqSR/89mPMDDgzdCwI
	 91mo78skqxguK09Puc5a/stKolGOIFG9VnhAfQpYF3Mr5YpDlwNjfb3kUfS88ck9tbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795428560;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=z5RA0mOOGtppCNR+TVlNNlu921LghCrTQ8okbAGwxMs=;
	b=B7DjYtAvSWGube2p6ceGV5hPPB5lHmvBqoKZPEop+h9yBKTdiW1eb2S3cfMX99B45HZF
	 6HE1f/Nm40YVwx+fqCk+H7tIb+35toTniV+FeIJ4OcZ7PWA/qAmV9tNieNmWWn/ldeM8j
	 TK9K5fbNhDAsihilRphBzahijKBbvhUU2eG9lCtu0+uQtq2kEKRkv1mv4P3i2o8hftxJB
	 mrvPb7p70blaDyrkwO5ioF/HFsrE7IcCLIOh6vg6p4sIq1T+CzG6Q4YWYl2OPfihzEVq0
	 FQ5Xo2791qqbHKlgi8nDPBNliOANeI5L2qKm5AJHkgYcCYUQRtPg+SEiGw9Tw+/2rsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XCZYujhF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZDOJqc8S;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XCZYujhF;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZDOJqc8S;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBDA606A332;
	Mon, 23 Nov 2026 10:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FBDA606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XCZYujhF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZDOJqc8S;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XCZYujhF;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZDOJqc8S
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 476CC21A56;
	Mon, 23 Nov 2026 10:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795428557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z5RA0mOOGtppCNR+TVlNNlu921LghCrTQ8okbAGwxMs=;
	b=XCZYujhF1/u67sD75nsaLlMVWT1O5wvOlA75vztF+a/XZPD49OmUe0BVR8BtcUwLAHZJ49
	mCclSK/7nyMAkLtcTRRT5YUiQvTRhUHfAAzJoHg5vKvbBb40W71PSXS2SUsaGmr3KMkBNk
	FJiLdjmhXGMakfPFhnQEtD9QhOOFhpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795428557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z5RA0mOOGtppCNR+TVlNNlu921LghCrTQ8okbAGwxMs=;
	b=ZDOJqc8SXIRtuXDPii/vNDDzkoa7Yfhc47xbAPRlYJ6Z7sSy1mweM8uqhbh+V8bFawqs7c
	ilbI8geG9h7+6yCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795428557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z5RA0mOOGtppCNR+TVlNNlu921LghCrTQ8okbAGwxMs=;
	b=XCZYujhF1/u67sD75nsaLlMVWT1O5wvOlA75vztF+a/XZPD49OmUe0BVR8BtcUwLAHZJ49
	mCclSK/7nyMAkLtcTRRT5YUiQvTRhUHfAAzJoHg5vKvbBb40W71PSXS2SUsaGmr3KMkBNk
	FJiLdjmhXGMakfPFhnQEtD9QhOOFhpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795428557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z5RA0mOOGtppCNR+TVlNNlu921LghCrTQ8okbAGwxMs=;
	b=ZDOJqc8SXIRtuXDPii/vNDDzkoa7Yfhc47xbAPRlYJ6Z7sSy1mweM8uqhbh+V8bFawqs7c
	ilbI8geG9h7+6yCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2199313510;
	Mon, 23 Nov 2026 10:09:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jXBqO8wQBGuwTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 10:09:17 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A214E2763B; Mon, 23 Nov 2026 11:09:12 +0100 (CET)
Date: Mon, 23 Nov 2026 11:09:12 +0100
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?VG9tw6Fz?= Senart <ts@perfloop.ai>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, 
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] jbd2: fix fast commit recovery failure when the FC
 area is full
Message-ID: <m3st5t7s3xzuuphid6lcd22mazxt6ibxp44by27qdog7qbdcd7@775azrq2yohj>
References: <CAEEBa3XJt0XU+5pXNQz_tjZyPEeEnY67i_QGupOnHLnXB=BVDw@mail.gmail.com>
 <CAEEBa3Un8x208Ox=20TTmGgcmdMSTCC41fB7SWP7uuY1N3xLPw@mail.gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEEBa3Un8x208Ox=20TTmGgcmdMSTCC41fB7SWP7uuY1N3xLPw@mail.gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,suse.cz,gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80

On Sat 21-11-26 04:14:05, Tomás Senart wrote:
> jbd2_journal_load() sets j_fc_last to s_maxlen, which is the first block
> past the end of the journal, and jbd2_fc_get_buf() never hands out a
> block at or beyond j_fc_last.  The recovery loop in fc_do_one_pass()
> nevertheless runs while next_fc_block <= j_fc_last.  If ordinary fsync
> use has filled every usable fast commit block before the next full
> commit, recovery reads one block past the journal and jread() fails
> with -EFSCORRUPTED ("JBD2: corrupted journal superblock").  The
> filesystem then fails to mount after a crash until e2fsck is run.
> 
> Stop the loop at j_fc_last.
> 
> That alone is not enough.  ext4_fc_replay() calls
> ext4_fc_set_bitmaps_and_counters() only when it is called again after
> fc_replay_num_tags has reached zero.  A TAIL tag always ends its block,
> so the call that handles the last tag returns JBD2_FC_REPLAY_CONTINUE
> and the finishing call used to come from the next block.  When the last
> fast commit block is the last block of the journal there is no next
> call, ext4_fc_replay_inode() has already cleared the inode's blocks in
> the bitmap and e2fsck reports a block bitmap difference.  Do the
> finishing step in the same call that consumes the last tag, and drop
> the in-loop copy, which would otherwise run it twice.
> 
> Reproduced in User-Mode Linux with 1 KiB blocks (mke2fs -J size=8,
> 63 usable fast commit blocks) and 4 KiB blocks (default journal, 15
> usable blocks): with the fast commit area exactly full the unpatched
> kernel fails the mount, and with one block fewer it recovers.  With this
> patch mount succeeds, the file has all fast committed data, and
> e2fsck -fn exits 0 with no differences after recovery, for the full,
> one-block-short and three-fast-commit cases at both block sizes.
> 
> This bug was found with Perfloop, an automated code analysis tool. The
> fix, this message and the reproducer were written with AI assistance and
> reviewed by me.
> 
> Fixes: 5b849b5f96b4 ("jbd2: fast commit recovery path")
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tomás Senart <ts@perfloop.ai>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v2:
> - Please do not apply v1. v1 only changed the loop bound. As the
>   Sashiko review pointed out, a full fast commit area then mounts but
>   skips ext4_fc_set_bitmaps_and_counters(), and e2fsck -fn reports
>   "Block bitmap differences: +2113" (4 KiB) and "+32769" (1 KiB) after
>   recovery. ext4_fc_replay() now finishes the replay in the call that
>   consumes the last tag.
> - The reproducer now runs e2fsck -fn after recovery.
> 
> Tested on torvalds master 65e4fd942f72a9dba0e4e257290c4fa1aa756854,
> under User-Mode Linux only, with one journal size per block size, and
> only with INODE fast commit tags (no create, link or range tags).
> 
>  fs/ext4/fast_commit.c | 9 +++++----
>  fs/jbd2/recovery.c    | 2 +-
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf370..5d9b95817ac6 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2608,11 +2608,8 @@ static int ext4_fc_replay(journal_t *journal,
> struct buffer_head *bh,
>  		ext4_fc_get_tl(&tl, cur);
>  		val = cur + EXT4_FC_TAG_BASE_LEN;
> 
> -		if (state->fc_replay_num_tags == 0) {
> -			ret = JBD2_FC_REPLAY_STOP;
> -			ext4_fc_set_bitmaps_and_counters(sb);
> +		if (state->fc_replay_num_tags == 0)
>  			break;
> -		}
> 
>  		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
>  		state->fc_replay_num_tags--;
> @@ -2656,6 +2653,10 @@ static int ext4_fc_replay(journal_t *journal,
> struct buffer_head *bh,
>  			break;
>  		ret = JBD2_FC_REPLAY_CONTINUE;
>  	}
> +	if (ret >= 0 && state->fc_replay_num_tags == 0) {
> +		ext4_fc_set_bitmaps_and_counters(sb);
> +		ret = JBD2_FC_REPLAY_STOP;
> +	}
>  	return ret;
>  }
> 
> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index cac8c2cd4a92..a59de33a2a4a 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -242,7 +242,7 @@ static int fc_do_one_pass(journal_t *journal,
>  	if (!journal->j_fc_replay_callback)
>  		return 0;
> 
> -	while (next_fc_block <= journal->j_fc_last) {
> +	while (next_fc_block < journal->j_fc_last) {
>  		jbd2_debug(3, "Fast commit replay: next block %ld\n",
>  			  next_fc_block);
>  		err = jread(&bh, journal, next_fc_block);
> -- 
> 2.55.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
