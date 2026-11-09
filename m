Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794230353;
	b=jqfFRm7Dp+9ph1QfkJhAbSRx0ldZ0HGJsoKpkEdgS2ABYW+YO3SAAoVSk1eRrTcaaSdk
	 ZvxMBxbMsXsR3l5evKWAebACClxxQn1nALm8gqGulqY71HfRTNcaadd9RHc/YBkTAli75
	 EYUmz1kg4bacFAllc3st3cWwmsP3IItAl2QvU5ezRTozqKxpRiGhAzd3usXXEdHWBmebG
	 VqYs2vxEp/Ui2TxCS1elYMmwGeawPYngmilaxRGcaSCZ2kMD7B5M4NlLadNMHla+D4Wrq
	 sNR4a8+b1T64EcuYWxbLTn1W93hpzfJoTtSOtgOGnIn86e12vRS0q1s+5MWyhLKDJ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794230353;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=zZ0zO0/b7wndx/eaqJPYaM6mjbvdFeSUXnPsfh8vP0o=;
	b=TjbNOVSVUwuy3I5+iesBtTMVEJL6vHiFv5zl4BBujCCJBw1Jy4DkcYl3meUNL35p+OTu
	 cpEGjnm7vf+QcFW7g6vILiNvwbYd5+M2sQpjt6J2N0z2ASmf+JvHW64CUBCpkm3KafEVf
	 JxYjd/hmWYLbu/rEtn2sE2XDP2KGtvAtd6idUOLKIMhK17XrylE6vSVWBZ1iTb1NoK3zv
	 Iv8YUoO0zFnVLOLOjxi/chYEfys8zxAaTv4qYl6AGB5z9AMV+FEz+V5d+M+Ydat3aMMSz
	 yjAoOp55pjJ0jVzNwXsm/jc5dTx0n8hmeRV1pp5AbSivA69Jd9t7aIazGZpnt53jVlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YLtTBCe2;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Zkv3GbjD;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1bYJFOGE;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lgr+KkFf;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8D1606A31C;
	Mon,  9 Nov 2026 13:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA8D1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YLtTBCe2;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Zkv3GbjD;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1bYJFOGE;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lgr+KkFf
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 88D321F385;
	Mon,  9 Nov 2026 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794230350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZ0zO0/b7wndx/eaqJPYaM6mjbvdFeSUXnPsfh8vP0o=;
	b=YLtTBCe2qgNs5qeH8zUqz/liXIuxtUPSWOUsu66zsoaPhX/FZkrXMw4H/QukSt1s6Va5lF
	IBU9d6ZWTo4F0n0fpXuD05Fk4wpc0seOh1a3mDsudJL6pb9Inpl7qn9Tv3D0ktJ/nJofKk
	fI/F3PrSlN0SX/O7xNuVN6FRO769y8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794230350;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZ0zO0/b7wndx/eaqJPYaM6mjbvdFeSUXnPsfh8vP0o=;
	b=Zkv3GbjDQ2dquxRtsim22JGFG/Lv08xHvBPOlG9eEqf6M+AvQoFbpNlRYz1Qhbt6ru5VYr
	vnCYf9MJi6MlEmBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794230349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZ0zO0/b7wndx/eaqJPYaM6mjbvdFeSUXnPsfh8vP0o=;
	b=1bYJFOGE1l8zV7hfr4g6l4TpFPxI8CTzo8ml77c6F6XZDwS3lYT0YNqdDhQvhY59TXOwej
	oZysffTHL/NzgC5TUjgPvT5MINhTmCb6cbIkmPa4fM5MteolYeHky+JIFpuicIQEvOjmq5
	H7sVUGbSLPjkS0mIePZi0JMOSDslYWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794230349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZ0zO0/b7wndx/eaqJPYaM6mjbvdFeSUXnPsfh8vP0o=;
	b=lgr+KkFfGKmPc1OL5HPninA4AvfOQ5/XGr9uqxNEx/CCwgCX58FxaSEI915VBI+UKtE0gp
	zeX9ve//ibU7liCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E81213302;
	Mon,  9 Nov 2026 13:19:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WjZ8Dk3I8WqRIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 13:19:09 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id DF4442201C; Mon, 09 Nov 2026 14:19:04 +0100 (CET)
Date: Mon, 9 Nov 2026 14:19:04 +0100
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix OOB write in fast-commit replay
Message-ID: <idqh5j5m3rhjsdu77h7dchk5vxj47fcsls7tcdhu4wdf75cthu@sxwipa7u2hyl>
References: <20261108204345.1423203-2-Jeremy.Jean@oss.cyber.gouv.fr>
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
In-Reply-To: <20261108204345.1423203-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sun 08-11-26 20:43:46, Jérémy Jean wrote:
> Fast-commit recovery checks record bounds and lengths during scan.
> Replay reads the records again without these checks. A corrupt filesystem
> can make an earlier replay operation overwrite a later record. Its new

This fact looks like the real problem. I think we should validate the
replay does not corrupt the journal. How does this happen? Otherwise we
have to fully redo the validation of each record done in
ext4_fc_replay_scan().

								Honza

> length can make ext4_fc_replay_inode() copy past the end of an inode buffer.
> The OOB write can trigger KASAN, which reports it as a UAF:
> 
>   BUG: KASAN: slab-use-after-free in ext4_fc_replay+0x1725/0x2de0
>   Write of size 200 at addr ffff888008598f64 by task busybox/62
>   Call Trace:
>    __asan_memcpy+0x3c/0x60
>    ext4_fc_replay+0x1725/0x2de0
>    do_one_pass+0x113c/0x2370
>    jbd2_journal_recover+0x528/0x7e0
>    jbd2_journal_load+0x7c/0x810
>    ext4_fill_super+0xaa54/0xc270
> 
> Check record bounds and lengths again before replaying each record.
> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  fs/ext4/fast_commit.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890..9edd26a 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2613,6 +2613,11 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
>  			ext4_fc_set_bitmaps_and_counters(sb);
>  			break;
>  		}
> +		if (tl.fc_len > end - val ||
> +		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
> +			ret = -EFSCORRUPTED;
> +			break;
> +		}
>  
>  		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
>  		state->fc_replay_num_tags--;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
