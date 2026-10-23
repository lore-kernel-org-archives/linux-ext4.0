Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792756624;
	b=WduefCIBRxD9qZwcMKXhxJSK8c7BBzUYkIfo90jda2RMEbeseJdIAz0ZycpPRpWaZr9E
	 lqrNR3ErucXhJ7G0Ar+F9ILwCMVQc48+ydUg1799aDGRcex3tW0BoI8XOmdScRN9Q526f
	 Ys3Xab98EwrFlIJuCps+25XfsXWvkGLKqTZOcFrW5W1QJXRS+ntBzjBVXcs+9IS8Y0uIX
	 +SdnpwakoxUu1LV199g91bLGdq50merDS0qhBssM+AgKOUWvdZBdWq4MrFDqCSp8Y8u8Y
	 n8EOQCMkuY5FjZK77RU0jmH8deuafMqoxP1AMB1NkbovBzUxQR8RtIqDoMrAO5HM0Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792756624;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=s7GyYTsxFkDixHtR/HmKPa+oNPiXtL+xyApDo2gROCg=;
	b=HuDUm7hPjEhHMoPc3WA2ZMO4HpjxRBTJZ12NsoeFJvm9bZt3b6X4piI8dXMtDPFQgYRl
	 qRIpRUucR9XYxmTnnhSFeiQChNbfE3BFyzCg5ihhmoyT4SfClaR5zLuVte3926KefIG6+
	 upm6gtXJq585w4LHDnzqt+e7PWelG1kA5C7dMP7ICx+fybedvCfDDaRD35WaUid6fwPys
	 HUUxLTq0p4X1+emwFXo7vc16ZIQ3TZzUzqnyrllp9kCyJ5iabBxk/fNE9akLb4XZPR0zj
	 cfBxw0WvfpIEYU+NenmAl51LidddFIi6ieSTSTTOzfnTLIpvvjOkhFU4cV5kCX5tr/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=kOdAjzyB;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0S8wGFsk;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=kOdAjzyB;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0S8wGFsk;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF9A606A336;
	Fri, 23 Oct 2026 11:57:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FF9A606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=kOdAjzyB;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0S8wGFsk;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=kOdAjzyB;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0S8wGFsk
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B236A2217F;
	Fri, 23 Oct 2026 11:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792756621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s7GyYTsxFkDixHtR/HmKPa+oNPiXtL+xyApDo2gROCg=;
	b=kOdAjzyBqtQ5JaTpPMHmj8LyMCsCQdexZt5AnrfVMp+RvzsLIGiVsa2Yo/Dnob+bQZ3tGD
	j/jThp6dE/uKLhPaauC9A6A9JHoPgFPNEdUgGelYeLyiYoDzP8oUzDRUp3VAfYcJoDR+bQ
	a9JDqnf3HZrMPrWmiNJv6GgZI4de6eY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792756621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s7GyYTsxFkDixHtR/HmKPa+oNPiXtL+xyApDo2gROCg=;
	b=0S8wGFskMJmtZylvem8SZ2I7AJfndktgpJuinZTkbemsRf5mUge/YBaIq9GW6CRaBCC/cN
	9lPcKWONwPWEuvCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792756621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s7GyYTsxFkDixHtR/HmKPa+oNPiXtL+xyApDo2gROCg=;
	b=kOdAjzyBqtQ5JaTpPMHmj8LyMCsCQdexZt5AnrfVMp+RvzsLIGiVsa2Yo/Dnob+bQZ3tGD
	j/jThp6dE/uKLhPaauC9A6A9JHoPgFPNEdUgGelYeLyiYoDzP8oUzDRUp3VAfYcJoDR+bQ
	a9JDqnf3HZrMPrWmiNJv6GgZI4de6eY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792756621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s7GyYTsxFkDixHtR/HmKPa+oNPiXtL+xyApDo2gROCg=;
	b=0S8wGFskMJmtZylvem8SZ2I7AJfndktgpJuinZTkbemsRf5mUge/YBaIq9GW6CRaBCC/cN
	9lPcKWONwPWEuvCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A2B5133F6;
	Fri, 23 Oct 2026 11:57:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MY55FY1L22oUZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 23 Oct 2026 11:57:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 027F4A1415; Fri, 23 Oct 2026 13:56:52 +0200 (CEST)
Date: Fri, 23 Oct 2026 13:56:52 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: return -EINVAL on hole in
 ext4_convert_unwritten_extents_atomic()
Message-ID: <mn4jxlh52gkg5vqhxf5q7kd6ecszx5haujozrqdgxpkonepe2a@ntyq4plapjgt>
References: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
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
In-Reply-To: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
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
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email]
X-Spam-Score: -11.30

On Fri 23-10-26 15:53:45, Ojaswin Mujoo wrote:
> We should ideally never encounter a hole during the endio conversion as
> that indicates something is wrong with our extent handling. Still if we do
> find a hole at atomic write endio, ext4_map_blocks() returns 0 which would
> be returned back to callers by ext4_convert_unwritten_extents_atomic().
> This can be wrongly interpreted as a success. Fix this by bailing out with
> -EINVAL instead.
> 
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Makes sense! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7193429a05e1..b54d8227786b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5107,6 +5107,14 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
>  		map.m_lblk += ret;
>  		map.m_len = (max_blocks -= ret);
>  		ret = ext4_map_blocks(handle, inode, &map, flags);
> +		if (ret == 0) {
> +			ext4_msg(inode->i_sb, KERN_ERR,
> +				 "inode #%llu: block %u: len %u: "
> +				 "hole found while converting extents for atomic write",
> +				 inode->i_ino, map.m_lblk, map.m_len);
> +			ret = -EINVAL;
> +			break;
> +		}
>  		if (ret != max_blocks)
>  			ext4_msg(inode->i_sb, KERN_INFO,
>  				     "inode #%llu: block %u: len %u: "
> 
> ---
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
> change-id: 20261023-ext4-atomic-endio-fix-b4-9e1ead9e1aca
> 
> Best regards,
> -- 
> Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
