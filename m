Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625098;
	b=A1JDeLEN3pRFB8dfXlxHLgW80tjn+8f27tizUFJq1zX0vhLxMDCvR3oHebNV0P832Fut
	 6cJdngYodanDRssjzMa0EqqPUsu/epeyZKFybWpcF/PQFWrGOGeCo38NOY1MFA8oQ3oI5
	 5hqQ2Sqjb3uFXn/E2Kqr0nepjWF1o0HfvYS8Arf0p9L1G1UBCePaJploFbyHZSOpy3Jkc
	 4Y+goCh+Du0iaSMvgYX0BMYwiyaXhsPUc7ULzw6U0H9dmD73YrBwxxw2up9yaKumasKsE
	 W2ytdSu7qk2WXbE3l3EYrfV+aJ2Jz8JbZBBPKNVp03wA5XwpLvzXt3zxjK7pn6Psegw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625098;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=+J4EEOaBt5pd8NJS5/yzH261i79GmuENAxdyKKnkldI=;
	b=YhoWXK2m0JopcFmacWPo18avnLNvhJu0cTvXnJf3mMfAjwYyNVvl73VAMKFBEswSbxyy
	 +FCLu/PA59zxWdo2F+nq76qRUuJ7OQ5MSQHssA3h6UApPA0Uj+RYUEPoEYgnb8ZnQDJl8
	 gNiWTw/iMSJ6HjvzLoryUcEZ9G3gzg1E1ZSttLUEDyoAM+zMr0yMQ15gBM8hBPTvLN3Ul
	 gfn4Dnk+gTgZkT9uUS3JD9KEtiMUNG280DrV/qIoXTqhJJnzK8BQ62d8WVDmXM2caAlES
	 QpDg6deYVNLeMZ4FakC3Y/NuT9W9yOc2fi1HRLxM4mNaaxVABY+Op7qVqjV+EDUBcsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IHKopKpd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+8a0GsZM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IHKopKpd;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+8a0GsZM;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACAF606A326;
	Wed, 25 Nov 2026 16:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ACAF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IHKopKpd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+8a0GsZM;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IHKopKpd;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+8a0GsZM
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C8E91FABC;
	Wed, 25 Nov 2026 16:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795625095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+J4EEOaBt5pd8NJS5/yzH261i79GmuENAxdyKKnkldI=;
	b=IHKopKpd1FGBl907HDL/oxUWFtr1BTgUjZccbguG0/qQ40flSOHAFy7mno+V1COb5ywgMm
	+1vSIL5ntmMoi9eO/YeXj8nb1vcN04051I+BomtoRqI7bmt0TsknjIgJKcAE485U8pJYvE
	9WZjYBavGZDGQqMoV2rYf29wF1t/4p8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795625095;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+J4EEOaBt5pd8NJS5/yzH261i79GmuENAxdyKKnkldI=;
	b=+8a0GsZMcHcdDhDXazmR5PzLE19k4xdEf/2pkSKkbAjlKo6Dxb27oqz0fgVMhhxoBjEB9/
	WYtXmj9e28yIVPDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795625095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+J4EEOaBt5pd8NJS5/yzH261i79GmuENAxdyKKnkldI=;
	b=IHKopKpd1FGBl907HDL/oxUWFtr1BTgUjZccbguG0/qQ40flSOHAFy7mno+V1COb5ywgMm
	+1vSIL5ntmMoi9eO/YeXj8nb1vcN04051I+BomtoRqI7bmt0TsknjIgJKcAE485U8pJYvE
	9WZjYBavGZDGQqMoV2rYf29wF1t/4p8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795625095;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+J4EEOaBt5pd8NJS5/yzH261i79GmuENAxdyKKnkldI=;
	b=+8a0GsZMcHcdDhDXazmR5PzLE19k4xdEf/2pkSKkbAjlKo6Dxb27oqz0fgVMhhxoBjEB9/
	WYtXmj9e28yIVPDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DC46134CA;
	Wed, 25 Nov 2026 16:44:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /2l0DYcQB2uadAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 16:44:55 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CEC5A27CCD; Wed, 25 Nov 2026 17:44:54 +0100 (CET)
Date: Wed, 25 Nov 2026 17:44:54 +0100
From: Jan Kara <jack@suse.cz>
To: Petr =?utf-8?B?VmFuxJtr?= <petr.vanek@e2b.dev>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: recompute the inode checksum after restoring
 inline data
Message-ID: <56f56udp6ehob2wu4xmhihux5wnll3s3yy34kzztuuetuvwual@3dc3c2aac2l2>
References: <20261125143841.928615-1-petr.vanek@e2b.dev>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261125143841.928615-1-petr.vanek@e2b.dev>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,system.data:url,e2b.dev:email,suse.cz:email];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Wed 25-11-26 15:38:39, Petr Vaněk wrote:
> ext4_restore_inline_data() recreates the system.data xattr with
> ext4_create_inline_data(), which marks the inode dirty and so sets its
> checksum, and only then copies the saved bytes into the raw inode with
> ext4_write_inline_data().  Unless something dirties the inode again
> before it is written out, the inode reaches the disk with a checksum
> that does not match its contents.
> 
> Failed inline data conversions take this path, for example an mmap write
> to a small inline file on a full filesystem:
> 
>   mkfs.ext4 -O inline_data /dev/vdb 64M
>   mount /dev/vdb /mnt
>   xfs_io -f -c "pwrite -S 0x61 0 42" /mnt/small
>   xfs_io -f -c "falloc 0 64m" /mnt/fill                # ENOSPC, fs is full
>   xfs_io -c "mmap -rw 0 42" -c "mwrite 0 1" /mnt/small # SIGBUS
>   umount /mnt; mount /dev/vdb /mnt
>   cat /mnt/small                                       # EBADMSG
> 
> The read after the remount fails with:
> 
>   [    1.203967] EXT4-fs error (device vdb): ext4_lookup:1635: inode #4097: comm cat: iget: checksum invalid
> 
> Mark the inode dirty again after ext4_write_inline_data(), so the
> checksum written to disk covers the restored data.
> 
> The Fixes tag is based on code analysis: ext4_restore_inline_data() has
> called ext4_create_inline_data() before ext4_write_inline_data() since
> that commit.  The failure reproduces on v5.19 and later; older kernels
> were not tested.
> 
> Fixes: 3c47d54170b6 ("ext4: let add_dir_entry handle inline data properly")
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Vaněk <petr.vanek@e2b.dev>

Yeah, looks easy enough. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> This patch was developed with the help of an AI coding assistant
> (Claude Opus via OpenCode).  It analysed the bug, wrote the fix and the
> changelog, and built the QEMU test setup; I reviewed the change and the
> test results.
> 
> Tested with the reproducer above in QEMU (x86_64, KASAN and lockdep
> enabled) on 7.4-rc5 with and without the patch; e2fsck is clean after
> the patched run.  Not tested: xfstests, other architectures.
> 
>  fs/ext4/inline.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index acdc65ce47960..360c06441c8f1 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1111,6 +1111,8 @@ static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
>  	}
>  	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
>  	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> +	/* Update the inode checksum to cover the restored data. */
> +	ext4_mark_inode_dirty(handle, inode);
>  }
>  
>  struct buffer_head *ext4_inline_getblk(struct super_block *sb,
> -- 
> 2.56.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
