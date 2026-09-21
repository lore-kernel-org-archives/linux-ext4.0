Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FCA3559C9;
	Mon, 21 Sep 2026 09:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981791; cv=none; b=fcdq/9XgnAPDt+pzVEgMkHZ0/A0SV38HjcurBzZcDOhBJ7A3D+IVHAmrhNi3hHPIVVJQDBOc4M5Uk/iKxFfFqi7lXnVbqHUoNaO0Q50HyOupcVLan28GBZYYQqpZW422oF4OI/YVvCY25oU5OjrtNsNsGksrp6H9rCLMDUgg4Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981791; c=relaxed/simple;
	bh=FC6rts5iX6PaZKgWQE7XgVzD5qhzb6gjc9SVjg94fYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adh8b/6nCEZQn+rG/gAXAzDABxJz1NrGGHCePW763nXX8N57/l8jYVnbIZ9weIIWMaDbsBSbVH+s+4Jt3jIiX8sNJ5AlynEWjbsf9gT4UDOIXXOR7mYVG8bG92q2ybCpJeO7lV7QVvU/mvpEwBvezAXFCFlJdnWGLlbOfxy5NYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TivbOJ0x; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QxvR08KG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BekFBb33; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SQOZgQni; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TivbOJ0x";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QxvR08KG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BekFBb33";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SQOZgQni"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A831C21C08;
	Mon, 21 Sep 2026 09:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789981783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xY2KVLq9cSio0ys71LWr26a1j0slOLo8q2lgLNgE7eA=;
	b=TivbOJ0xLarVQlX7APgMEzjQ2v0Trpg4SUl2qKjXYSiIl2WxBxt+PDcRXaqhJujqYNqqI8
	5RDbnZZ6u7LEN+obFVOWr+7xC9rNUeqFDkJZaq04XasCAbRtDjib841D98cnG5avUmwQJq
	D9olWmOjuTEyjx5Pspf+fzT7eR5eQY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789981783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xY2KVLq9cSio0ys71LWr26a1j0slOLo8q2lgLNgE7eA=;
	b=QxvR08KGtM8e/F7baxet1kARWnjSswjCRIvSRtOYFsxKUvteNg5j90wIYykOTFbx2ssXtC
	mNdsmVyOn5jtl7Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BekFBb33;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SQOZgQni
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789981779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xY2KVLq9cSio0ys71LWr26a1j0slOLo8q2lgLNgE7eA=;
	b=BekFBb33+vx+/z8+853w54PLCLdYe226PPKSpyYsX8QpEg+lxlE2HBVFKhlvkIJUn5hOyZ
	VN2zPMEdWKBmc0Gf3dBWJvbYsPiieaZIebSZGhcuNd++Bo2jAVA8u3C4F2bCsbKV70oVDj
	OCva0qHkm/p6urQcmuGy7BqqlCjrJoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789981779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xY2KVLq9cSio0ys71LWr26a1j0slOLo8q2lgLNgE7eA=;
	b=SQOZgQniCIkCyTwSYIC+qxhaAdsD3T79daKP+irTMTdcvR7yCzVoGt4d3a7WUxFMOfUikP
	EogHHrSUB9Xg0ZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E39B1368D;
	Mon, 21 Sep 2026 09:09:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vTB/FlP0sGojZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 21 Sep 2026 09:09:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0C63CA13D5; Mon, 21 Sep 2026 11:09:39 +0200 (CEST)
Date: Mon, 21 Sep 2026 11:09:39 +0200
From: Jan Kara <jack@suse.cz>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, linux-ext4@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4, doc: remove unnecessary bracket
Message-ID: <qxtwbujylatoi7vl2lyngg4n557to6rdafpk45hzlnjxnx5ezp@lcdaur46z3vu>
References: <20260916104251.296148-3-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916104251.296148-3-manuelebnerli@mailbox.org>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: A831C21C08
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[14];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,lwn.net,linuxfoundation.org,infradead.org,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,infradead.org:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Flag: NO

On Wed 16-09-26 12:42:52, Manuel Ebner wrote:
> Fix sentence structure to improve readability
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> CC: Randy Dunlap <rdunlap@infradead.org>
> ---
> @Jan Kara, is the reviewed-tag ok even though I changed the patch?

Well, it doesn't seem to have changed substantially so sure, you can keep
it in such cases.

								Honza

> 
> [v2]
>  Incorporate Randys suggestion.
> 
> [v1]
>  https://lore.kernel.org/all/20260902143254.702971-2-manuelebnerli@mailbox.org/
> ---
>  Documentation/filesystems/ext4/directory.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/ext4/directory.rst b/Documentation/filesystems/ext4/directory.rst
> index 9b003a4d4..6d8021309 100644
> --- a/Documentation/filesystems/ext4/directory.rst
> +++ b/Documentation/filesystems/ext4/directory.rst
> @@ -429,7 +429,7 @@ block (precisely the length of one dx_entry) are used to store a
>  ``count`` entries in the dx_root/dx_node structures are adjusted as
>  necessary to fit the dx_tail into the block. If there is no space for
>  the dx_tail, the user is notified to run e2fsck -D to rebuild the
> -directory index (which will ensure that there's space for the checksum.
> +directory index, which will ensure that there's space for the checksum.
>  The dx_tail structure is 8 bytes long and looks like this:
>  
>  .. list-table::
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
