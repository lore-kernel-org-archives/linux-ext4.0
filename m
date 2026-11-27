Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795789769;
	b=UJORjQYMGvrHHEvij1d4wKrp9m/2+I5WwRAyjVYIKRvF3B1LrSM1XzjyYJHCJXJARnzL
	 Tp6G96mZtme32TUwoO6QUMnDjkm1r0tK2nKR22iH8lykuHVTzEXcxqbf2+/fejPBmN8VJ
	 USi6Hqgq7td3BjJ8vkQ7rYGgDJEeYj1gTG7DxkduqFUqxwEWhDWkob8oLAkUW5ssZXe3h
	 3F1v7rsofkHpoQh1/E4mrI/eMq6uTWSbHlXO53KlDp+p48SlPOo78m1KpV1Ge5o5ZopmY
	 oI4BiTjXwpPl1SvACghre7SnzDCGtIsHrpF4aJfQqNDXLZHeh2gMo+YtI7CE/wf4Ukw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795789769;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=kuhW9lDWfneWeZsk+TIdcuuOQdceWcujJoVRGEDz8Vg=;
	b=EvSO4/axbGb8ojK0+R3b0+5vg/U+FRo1lcIjTjIWp0qbQaEU2aRP2JsRgkf/2T7d6ugL
	 VdxKTo+agwsg69/8BdY1Z/wXWIdjVwUeYw/KfWbVHZOpKHUKKB+qyWtJ472CKBirlGxE7
	 DMJQ/Rvt9eUZq6n8J9BiDbCQi2hJYiE4H2WIY2yrzNnjR9xML6nPa/vJYZmF8Q4bSAJGi
	 BLWsMy310Qx/51w78hY+nIDJM6dR2sk5+pCMaqQdKG09uhJ1EBG5Ws81LvmVUzTu+mAIJ
	 wjfIk8hkT11THBkTXp280Vqvl1i1caRAFThHJZ69awTF477JcoGo1groecbdu1nrJWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lKHKPyxM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ktP1SV97;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wTDWH56U;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=G1isq0ds;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C801E606A685;
	Fri, 27 Nov 2026 14:29:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C801E606A685
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lKHKPyxM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ktP1SV97;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wTDWH56U;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=G1isq0ds
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E248A22996;
	Fri, 27 Nov 2026 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795789767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kuhW9lDWfneWeZsk+TIdcuuOQdceWcujJoVRGEDz8Vg=;
	b=lKHKPyxMwPUxgYW5YdKdQFkoz9m4rE57CIRhz6biJTjTygs1S1VlghcaDtGH9YmGRVKD4l
	E8CkMd3B6jLA+tJ7ZBu9BD4L57ljJ9WlNM+6hdcmFn9oWaKnK+jo8+cMTG3SXl4/wRPzFq
	vGhkXwEdvJyYySpRKxfnj5B36CGga6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795789767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kuhW9lDWfneWeZsk+TIdcuuOQdceWcujJoVRGEDz8Vg=;
	b=ktP1SV97Y/thykAiKmmc3VqiZzEZeFcmONfRrm6PfurSssFSGqVjDmJQlI279EC6SNl9YN
	fNPR43zeUvb0B6Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wTDWH56U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G1isq0ds
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795789766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kuhW9lDWfneWeZsk+TIdcuuOQdceWcujJoVRGEDz8Vg=;
	b=wTDWH56Uy8u+jI12AX5EczkuGIIrYmHYbkvnBrz2S4bGUhkf2EKOjjayyXBttmitiEyLQU
	qtGb2txHZlp7hOgPyzDg8GEGW+XoYtcyCEv+dbXMEZ4c1SqYmTXkhamuWSNtre9ZuGBjYX
	jXheCllkgnpRxDbhIawc3MDlHFmfcTY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795789766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kuhW9lDWfneWeZsk+TIdcuuOQdceWcujJoVRGEDz8Vg=;
	b=G1isq0dskEjXytVokHgEk4iXKC1KgN6vDScaSLhpt27Grx2AodnJNABcR78vR6OMk4+P8N
	XBUANH+Src3o9HAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B842E13432;
	Fri, 27 Nov 2026 14:29:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3KfrJMaTCWvUUwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 14:29:26 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 47F245104D; Fri, 27 Nov 2026 15:29:26 +0100 (CET)
Date: Fri, 27 Nov 2026 15:29:26 +0100
From: Jan Kara <jack@suse.cz>
To: jiazhenyuan <jiazhenyuan@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	gouhao@uniontech.com, niecheng1@uniontech.com, guanwentao@uniontech.com, 
	caina@uniontech.com, zhaoshuang@uniontech.com, wangqing@uniontech.com
Subject: Re: [PATCH 1/2] ext4: fix buffer head leak in ext4_ext_precache()
Message-ID: <gnl2hl6a27e2pjlwufu2nrg6edze4b7vvofyeyrxvntct53ruc@wxj5onv2sjq3>
References: <20261127064926.135945-1-jiazhenyuan@uniontech.com>
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
In-Reply-To: <20261127064926.135945-1-jiazhenyuan@uniontech.com>
X-Rspamd-Queue-Id: E248A22996
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,uniontech.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.51

On Fri 27-11-26 14:49:25, jiazhenyuan wrote:
> ext4_ext_precache() stores each successfully read child extent block in
> path[1..depth].p_bh. During normal traversal, these references are
> released as the loop backtracks. If a later read fails, traversal breaks
> to out and calls ext4_free_ext_path() before all ancestor references
> have been dropped.
> 
> path[0].p_depth is not initialized, so ext4_ext_drop_refs() only
> releases path[0].p_bh. Since the root block is inline and path[0].p_bh
> is NULL, buffer heads held by path[1..depth] are leaked.
> 
> Set path[0].p_depth to the inode's extent depth so cleanup covers the
> entire traversal stack.
> 
> Without this patch, the KUnit test added in the following patch reports:
> 
>     # test_ext_precache_read_failure_bh_leak: EXPECTATION FAILED at
>     # fs/ext4/extents-test.c:1568
>     Expected atomic_read(&bh->b_count) == 2, but
>         atomic_read(&bh->b_count) == 3 (0x3)
> 
> Fixes: 7869a4a6c5caa ("ext4: add support for extent pre-caching")
> Cc: stable@vger.kernel.org
> Signed-off-by: jiazhenyuan <jiazhenyuan@uniontech.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b65b0261ee5c..4c775aa41459 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -638,6 +638,8 @@ int ext4_ext_precache(struct inode *inode)
>  		return -ENOMEM;
>  	}
>  
> +	path[0].p_depth = depth;
> +
>  	path[0].p_hdr = ext_inode_hdr(inode);
>  	ret = ext4_ext_check(inode, path[0].p_hdr, depth, 0);
>  	if (ret)
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
