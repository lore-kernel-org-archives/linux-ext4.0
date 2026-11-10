Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306531;
	b=IaUMeB9Kdekyl5a6b4Lc5tpj20R6o9HFHEvzeYS9n3suDAdPkP8rCEmScxT3LgNY9ECA
	 MB6EjWExSJJGSUdWNYBcigkppeKSuVCFWSsCv3kUQU4jAJjcWoI6+SpkOneYac2Pe4i+Q
	 Cydt7l13B+OImWudcIaDU4gOw61T98l3f6NZRYwrqwdmzLXgKZl3UnVg2rToz8XizuYd0
	 HpxIVJUX6xoAbU4mufn4RVL54T8BGK42gZSjJO1VX99cfYNJLPzE11ObnpSw2CROBd1Y4
	 QAjaDsgYy1iwEmd6H3pLBKA2MrvoRQj/LQNsxFJ7tdCzY+1FeVEY1gvNRywLo78tbRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306531;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=EcBPMonzkWsG94Y9yT682LHPzvBi3AlTOXSAjQhQPpA=;
	b=3uOH9HGFUHaolVsoGsy2AxzkcrN+psKNbK71oBSFBiw70zwu0lRvkLj0ljW2yQyerOtV
	 9Gv5/buU5buKgNmSoNxHooapSD1/nyuEykdkE1qCN+FYOroduecMX8WYzk0GISPALyOXX
	 qIjcIMgONcf7YgDA4yAY0B0Ni0/A5W8FbBmjc+YBGaaWacezJFQ/MCRQ+rYRbDHd8B9YQ
	 xRKDgDSriv+BsBbINTNE12bfy0vRiPMOV3K9hY5JXWKSjtuvAAeeKf3Qn27jz8okWRQZD
	 gpU9IhIEBFjeIYRRGUFwiCTIAuLUrxzvw3gsxdmSX2XyEz17mHtY8hzgPPyIT845sPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XXVANFhN;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xPlEKRRi;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=C4E5KMEN;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="Ifv/A2AW";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC54606A326;
	Tue, 10 Nov 2026 10:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CC54606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=XXVANFhN;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xPlEKRRi;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=C4E5KMEN;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ifv/A2AW
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE8ED21DBF;
	Tue, 10 Nov 2026 10:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EcBPMonzkWsG94Y9yT682LHPzvBi3AlTOXSAjQhQPpA=;
	b=XXVANFhN74149ev1IDDssUAOLtAOvOmptruK0j05p8AmuSLPnwupmefJR/zQBfcROWMMZp
	AIf/ku7+NzXm++dMXyV4bvhh4ry/HjeAGsunUTzKkNIYZYu5cjJ7vzxHKM7zRgWStqWDh5
	8IKQV9bV7VES+r/aumMST2IhQS/o6iw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EcBPMonzkWsG94Y9yT682LHPzvBi3AlTOXSAjQhQPpA=;
	b=xPlEKRRib4ygGQPHrcuk69o2B7x/afUNKgobaxxiZGCDAfl6SqN6/IOa/tM092596wjjp3
	k4dc7f9netdNlyDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EcBPMonzkWsG94Y9yT682LHPzvBi3AlTOXSAjQhQPpA=;
	b=C4E5KMENEWn6fuI3UHyM0HbzedmkGfcL66w+NxdrNK8AlyqhK4FSMAhz8NEDR6GITqMtdK
	fX08xCWvcppdjqtlnZ0v63/5o0Ny5cmGQiBQmiduxxfPVG2uzYNsJXCMYH2fW3kqN4Atp2
	B5s0DPdRioptxIdYjW7T4+iblGxjZvs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EcBPMonzkWsG94Y9yT682LHPzvBi3AlTOXSAjQhQPpA=;
	b=Ifv/A2AW8qUtqAdA1sCErERVSEIRXXOY7W+mjghGvCuJjgihfmr1Jcemmh2NiCJberLRud
	JgMVfU0o5s1QwJCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C36251339F;
	Tue, 10 Nov 2026 10:28:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8ZJoJ+Dx8mrLKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:28:48 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6B74C22475; Tue, 10 Nov 2026 11:28:44 +0100 (CET)
Date: Tue, 10 Nov 2026 11:28:44 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RFC v3 11/14] ext4: drop mmb_sync() from
 ext4_evict_inode()
Message-ID: <m6up3awwxp7gos7ga6xcfywk24t4comkkbwhrttkjdyo4b5xox@zjv7qy2iur6c>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-11-91ac6c024018@kernel.org>
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
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-11-91ac6c024018@kernel.org>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 09-11-26 17:51:26, Christian Brauner wrote:
> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> ext4_evict_inode() to sync without a journal, and with a journal there
> are no tracked buffers.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 18362580097f..b6c8c11525a8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -250,8 +250,6 @@ void ext4_evict_inode(struct inode *inode)
>  	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
>  		ext4_evict_ea_inode(inode);
>  	if (inode->i_nlink) {
> -		struct mapping_metadata_bhs *mmb;
> -
>  		/*
>  		 * If there's dirty page will lead to data loss, user
>  		 * could see stale data.
> @@ -261,9 +259,6 @@ void ext4_evict_inode(struct inode *inode)
>  			ext4_warning_inode(inode, "data will be lost");
>  
>  		truncate_inode_pages_final(&inode->i_data);
> -		mmb = ext4_i_metadata_bhs(inode);
> -		if (mmb)
> -			mmb_sync(mmb);
>  		goto no_delete;
>  	}
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
