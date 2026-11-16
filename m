Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794832074;
	b=lZgTvV+gMs/1iKj4H/6EO1k79wvjgO4IuTDxqdk89chEtOyR8j3+UB/4c5gGRw5vNyCC
	 T3wHOc3YGHcqKXRUcYNeerIfqvsgX/QfjxvqAGHVAoxyB6sjmMnAbsCFAVoYz8qpfm7jV
	 h/Ey9d7yt6ufikIu6Mxoq1sOP2OgyT0AsoIbFkqLQKHCg7M0cyVLKsmDe5lYlBxOnfGT2
	 8pdV/9AWhGHMkar3P4T6CwCtseXsvG1Lnf8mkWbdyC08XuFaTpuTLqmRNaPawyMgeo8gz
	 pJNFdslv6rWxrv8ld9EY2b/H82ZRS2eJ/GzanFpY6s8wzWRGtB3ikFwgWVZM/8WTgxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794832074;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=BJl817WbnyT0B8TsI9clcx+vrLcy2vNvWcdropDzQ2Y=;
	b=3s2FlGJKR3wcdSBQfJcCEVfnWop9s28CwmbBMrvTzlAzKZc7Gza8KBUcIVNdEKncPT3Z
	 DAV5Oge/4ysIQFL7zdSszmsLwmGtwIeSj8sDeGCLrVB45RZ/4kPfqC2q7UaMYxzYahVCD
	 uCbHfQUtFa8Wy1/GJ+69V7+vI0u9mMeumSMeAVRv1iWvvPqC37+APORVMLGRxRR3T6I9o
	 2/PbT4Zbp5uxvR1h+zDAXIPldMZfezw1FaxxBgOowq0MLZGjWX2xNHbi8k4lEkAEzptBI
	 9DgJ17k0/m8xvLS0PUXsD57rIjmA+lkNKW9PkMErSyMJM2v/QbUAQgbQ7N+RDUnVxQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wS1VS76r;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/r9kgd2N";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wS1VS76r;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/r9kgd2N";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31AD606A31C;
	Mon, 16 Nov 2026 12:27:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A31AD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wS1VS76r;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/r9kgd2N;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wS1VS76r;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/r9kgd2N
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6962F1FBA8;
	Mon, 16 Nov 2026 12:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794832071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BJl817WbnyT0B8TsI9clcx+vrLcy2vNvWcdropDzQ2Y=;
	b=wS1VS76rrPvkg0gqcRjss6l5d01px0tB0Sqv5HoaJGErh+upiraL9d116S+6l7XzYExIsi
	wnZXjmtz+rbIP3/ZpHReVfNlTrrBSejQG+apS+LmNu8Og6evhvLDExkWDBaqSvIRA5g0HO
	Pxmx5H5jCW7FGtn23PQrM6fnGOT8XGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794832071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BJl817WbnyT0B8TsI9clcx+vrLcy2vNvWcdropDzQ2Y=;
	b=/r9kgd2NLXBMzmrpfkuCDKqGe5dq47rlkGEKccIrJ/QCZwEwRTwhwHfv7RLe76qFFCWeK7
	SjyqhgZJiF/ZmoCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wS1VS76r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/r9kgd2N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794832071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BJl817WbnyT0B8TsI9clcx+vrLcy2vNvWcdropDzQ2Y=;
	b=wS1VS76rrPvkg0gqcRjss6l5d01px0tB0Sqv5HoaJGErh+upiraL9d116S+6l7XzYExIsi
	wnZXjmtz+rbIP3/ZpHReVfNlTrrBSejQG+apS+LmNu8Og6evhvLDExkWDBaqSvIRA5g0HO
	Pxmx5H5jCW7FGtn23PQrM6fnGOT8XGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794832071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BJl817WbnyT0B8TsI9clcx+vrLcy2vNvWcdropDzQ2Y=;
	b=/r9kgd2NLXBMzmrpfkuCDKqGe5dq47rlkGEKccIrJ/QCZwEwRTwhwHfv7RLe76qFFCWeK7
	SjyqhgZJiF/ZmoCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 420141334C;
	Mon, 16 Nov 2026 12:27:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LzwUCMf2+moUZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 12:27:51 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C8A8F24DE9; Mon, 16 Nov 2026 13:27:50 +0100 (CET)
Date: Mon, 16 Nov 2026 13:27:50 +0100
From: Jan Kara <jack@suse.cz>
To: Qing Zhang <diasyzhangqing@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	kartikey406@gmail.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Qing Zhang <diasyzhang@tencent.com>, 
	Ahmed Khan <ahmadpsn95@gmail.com>, syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: attach jinode before inline data conversion in
 setattr
Message-ID: <xrpc6ogciidiydmvr2t5hvmnpezu4ftbvtrqjpukpva2evwg3f@tdexmd5dk2lb>
References: <6afa2521.84fe3b82.798c4.0005.GAE@google.com>
 <20261116054424.62067-1-diasyzhang@tencent.com>
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
In-Reply-To: <20261116054424.62067-1-diasyzhang@tencent.com>
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,tencent.com,syzkaller.appspotmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[9c29b92a3b6500bb347d];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 6962F1FBA8

On Mon 16-11-26 13:44:23, Qing Zhang wrote:
> Commit ed9356a30e59 ("ext4: convert inline data to extents when
> truncate exceeds inline size") added inline data conversion to
> ext4_setattr(). Pathname-based truncate bypasses ext4_file_open(),
> so the inode may lack a jinode. In ordered mode, the conversion
> can pass this NULL jinode to jbd2_journal_file_inode(), causing a
> NULL pointer dereference.
> 
> Attach the jinode before ext4_convert_inline_data() and propagate
> attachment errors. The attachment in ext4_truncate_up() occurs
> after the conversion and is too late.
> 
> Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate exceeds inline size")
> Reported-by: Ahmed Khan <ahmadpsn95@gmail.com>
> Link: https://lore.kernel.org/r/CAOaS1==g3mdoqmS2AjOC0_-woXJbA_X0LJQt7+M7d1=+gfyQqw@mail.gmail.com
> Reported-by: syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9c29b92a3b6500bb347d
> Cc: stable@vger.kernel.org
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>  fs/ext4/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 10cd85d4c721..1e31933ae98c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -7127,6 +7127,9 @@ int ext4_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 */
>  		if (ext4_has_inline_data(inode) &&
>  		    attr->ia_size > EXT4_I(inode)->i_inline_size) {
> +			error = ext4_inode_attach_jinode(inode);
> +			if (error)
> +				goto err_out;
>  			error = ext4_convert_inline_data(inode);
>  			if (error)
>  				goto err_out;
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
