Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624173;
	b=r0Zso7UZ9wDXr7+pCwKCdpAaSQym2QPaknXXX4AtcE1aUSSv/yDltP1Q2Rq4LZqsHM60
	 UikQlNd10tAr5bgFEzGR6CKF0s2IIsvLTTgD4efOLMAPrIGA3ikmW4oKCn/jHPjeYXa9d
	 zNFPzfYBK9XnUnE5C2Rz3z0DCHi3x6JYWcwS27NU5ma/jTtiKDce/cDbLHCdZ65Xq2D8B
	 P42ZM2SAXrRxWjjtyOY4TRD6hb+pvzbYRBx+Bcp+N11Dm2BbvV5Sb1SSwOK3RSVyCnBbB
	 nje0cqwTSPCYxZu7/JpiaytDQzIUuAk/oISyqorjpl9w9fbZzEg7oeBNps3ZMJAfQ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624173;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=CKYwNl/Ta1J7jCH2FaRNrK6Y0nHa56soWIBpAqyVGrQ=;
	b=33f0npMxJ/du1K8GoBYHOlTkGMLCD77dG0J+iAL8XWPSYDsNvL93R6hDFZHclGDR/NUs
	 cSt0rOsQP3jSnTCbdohcSkOlxWOnNkkeGHmIfjBori8Kdz4hgUjkTFxvSfHcOyuZY3HoJ
	 qAfW+9B5sXaVSYJjDtbO2djKpgyREH/DW0FUqW78Fn6+vaTyKqYQDdcfziSvzIDqOShxD
	 0tPzPxSwRr/YhXG9yidX0BSFJzNrkIgzF5NyykmECE52pvSibLL/zjNZdTTCIdu4nWBL0
	 OoA3J7DzNV8RCHb+Q06S+6jr3UOyDUlu4eCJUb1MrjZPDgHgh1LctDZ0HnpABI44/Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FOWUYZam;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hwApuTyg;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=gxC7oy25;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hNTD501h;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FFB606A32A;
	Wed, 25 Nov 2026 16:29:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99FFB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FOWUYZam;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hwApuTyg;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=gxC7oy25;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hNTD501h
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 910BD1FAA8;
	Wed, 25 Nov 2026 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795624170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CKYwNl/Ta1J7jCH2FaRNrK6Y0nHa56soWIBpAqyVGrQ=;
	b=FOWUYZamutVIfUAP8wABq7+DZLlhOoqeAV/G479AknWVUJ6q01aiwKvtwxbudlqxYnvF+V
	uWGUIXj6FNGEIgDwauVN0hCfhU34ed7TuUl8K37QcPh8WECL3fhjgdnfHYUERxxjyeqZ1s
	ypF1VoBjMEjTXjUWUeWrYeQNTWfwp1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795624170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CKYwNl/Ta1J7jCH2FaRNrK6Y0nHa56soWIBpAqyVGrQ=;
	b=hwApuTyg8DkA3/gr1hvDgERJod8FVpB3+vV1mUVrIxnaTZQofM5+ZXx/CNIA7DxEo01Ef9
	30yExUso8/XoTSCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795624169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CKYwNl/Ta1J7jCH2FaRNrK6Y0nHa56soWIBpAqyVGrQ=;
	b=gxC7oy25sB1TBcNhO7O53hdQp4xJokWINoazmj7ExSgk3TtQ6Bqok70AzuBt1hvEATNVpE
	sD9k78Beu36ADI0Ih5hDjZLqop/GVxlGCaKGvMmhSj4XEh+1raOw304yspzKC3Fz/Bd1/s
	PJnMIprE+7PTyvwwsRkcKNqMYkO1h9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795624169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CKYwNl/Ta1J7jCH2FaRNrK6Y0nHa56soWIBpAqyVGrQ=;
	b=hNTD501hBFihPepbypVdmBAIeFRaPOhQWCFDe67Vb6PaS57h+5UfT8epK970E5yt2n/ydh
	aiXTA4WeUzYpAGBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BF2F134CA;
	Wed, 25 Nov 2026 16:29:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tPE9EukMB2t0ZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 16:29:29 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id F199D27CBD; Wed, 25 Nov 2026 17:29:28 +0100 (CET)
Date: Wed, 25 Nov 2026 17:29:28 +0100
From: Jan Kara <jack@suse.cz>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] quota: Forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA for
 frozen filesystem
Message-ID: <2bdhvc72txjh47b7fhko5faykcjnt24cgow436z6eippdkypgz@jwb3ublivgjg>
References: <20261125111055.3672233-1-yebin@huaweicloud.com>
 <20261125111055.3672233-2-yebin@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125111055.3672233-2-yebin@huaweicloud.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huawei.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80

[added fsdevel to CC since people there might be interested as well,
keeping patch intact]

On Wed 25-11-26 19:10:54, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Commit ccf370e43e08 (quota: Forbid Q_GETQUOTA and Q_GETNEXTQUOTA for
> frozen filesystem) forbade Q_GETQUOTA and Q_GETNEXTQUOTA on a frozen
> filesystem because ext4_acquire_dquot() prepares for allocating space for
> a new quota structure and OCFS2 needs to update the on-disk structure use
> count when a new cluster node loads quota information from disk.  The
> same applies to Q_XGETQUOTA and Q_XGETNEXTQUOTA: userspace treats them as
> read-only commands, but if the queried dquot is not cached yet,
> ->get_dqblk()/->get_nextdqblk() call dqget() -> ->acquire_dquot(), which
> may write to the filesystem.
> 
> Until now this only made ext4 warn about starting a transaction on a
> frozen filesystem.  Now that ext4_acquire_dquot() also takes
> sb_start_intwrite() to protect against freezing, it turns into a
> deadlock: the query holds s_umount for reading and blocks on the
> SB_FREEZE_FS freeze protection, which thaw_super() can only release
> after taking s_umount exclusively.
> 
> So forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA on a frozen filesystem as well
> by moving them out of the read-only set in quotactl_cmd_write(), just
> like Q_GETQUOTA and Q_GETNEXTQUOTA.  This also makes quotactl_fd() take
> write access for them, so a query on a read-only mount now fails with
> -EROFS; that is the same behavior the generic quota commands already
> have.  If someone needs read-only querying on a frozen or read-only
> filesystem, proper read-only dquot lookup can be implemented separately.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/quota/quota.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 94e6407734c7..1669bb09b9f7 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -834,9 +834,10 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
>  static int quotactl_cmd_write(int cmd)
>  {
>  	/*
> -	 * We cannot allow Q_GETQUOTA and Q_GETNEXTQUOTA without write access
> -	 * as dquot_acquire() may allocate space for new structure and OCFS2
> -	 * needs to increment on-disk use count.
> +	 * We cannot allow Q_GETQUOTA, Q_GETNEXTQUOTA, Q_XGETQUOTA and
> +	 * Q_XGETNEXTQUOTA without write access as dquot_acquire() may allocate
> +	 * space for new structure and OCFS2 needs to increment on-disk use
> +	 * count.
>  	 */
>  	switch (cmd) {
>  	case Q_GETFMT:
> @@ -844,8 +845,6 @@ static int quotactl_cmd_write(int cmd)
>  	case Q_SYNC:
>  	case Q_XGETQSTAT:
>  	case Q_XGETQSTATV:
> -	case Q_XGETQUOTA:
> -	case Q_XGETNEXTQUOTA:
>  	case Q_XQUOTASYNC:
>  		return 0;
>  	}
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
