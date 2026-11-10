Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306790;
	b=BPk8sIE1izJeQEktHr8x9U3/jpAtzlOfjEPBpg20UMZ6oZeclRl3HYx0ltxu2PQXHCEe
	 M6WerZ7U/kZNL7jVU3tB8qoshWrY6x/qaNZzaVkbEMQ3RjoAGlFx9SS/LA0TM0QixNCU5
	 C9S9lwB1t4F7+b5rw9bnpLKYvdkSznydPRUhBg5SCH8VnScoINNW+BWhXfDsDOtFwMDXa
	 EVvsKk/t748kGR4miYu2IFUO0JeOJ8KFoSQy/nNhSaBCeponsH+DwZT3pIdLJcuFqa8mr
	 js7NcOv7HaugbXi328qpxmmreucq0hRlPgzFyayIwEAMNZdbbefl7PtOjpsaCaw/KWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306790;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=6ch4xXQ7StUnbjm3wHzXSplK8uCVJPHj9zvM+WcPtS8=;
	b=lugDJVL8AOlx/OuEBzSJXHTcPgFRuqXR1xoza2eop3cwQuJwmmGD7OAj91pTfiv6T7p5
	 cQJRYGXHkGn+7kx/GAKdFnrcpq4eE6GJ2t6cJxsa3S8srSnxxLL9cdV5O9pmWLVtiu778
	 jdIFoXTshoRFGOCbuBet7tQQkVikv3M8CVYuKPkyVEsjOBcex305oGfA6bO+Rj7ks5GO+
	 qgwkosV8gt/6Rr/JO2vr3anWzmhe4zbsafloD9HeCnN6+awz74w/+S7BCRT3wGNxLz9Rg
	 mFwsgoTzZQA/9X0pXmZlbC6j9TsVxUvWwHDZ8Bv+mccBm++Iwf1IJROEnbUAqD8+4rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ea3pU+9l;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LfEvdBOH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ea3pU+9l;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LfEvdBOH;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7A606A33C;
	Tue, 10 Nov 2026 10:33:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38A7A606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ea3pU+9l;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LfEvdBOH;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ea3pU+9l;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LfEvdBOH
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2128B21E04;
	Tue, 10 Nov 2026 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ch4xXQ7StUnbjm3wHzXSplK8uCVJPHj9zvM+WcPtS8=;
	b=Ea3pU+9ly03VW1w2imW7KzCHztcdJNFMUhpnUlaos4f8qlZlK2Iyf7nOmwmBsXBqob9T+t
	8Cui50ntHFw3yF5Z0C7lmk6hykto8fJsA6tf0sWPwCgN1mBJ7aC51SApbx8gUc5h9nYtqe
	+KsjvFMX5CwhkzBc64PXczkNvx0CNBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ch4xXQ7StUnbjm3wHzXSplK8uCVJPHj9zvM+WcPtS8=;
	b=LfEvdBOHdpNmcCrxSpDK/TCe23UdXe0e4qifp9xJNNRY++c569uAGTCEPITc4fy2cSB07K
	q6uQOla7sO6xzyCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ea3pU+9l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LfEvdBOH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ch4xXQ7StUnbjm3wHzXSplK8uCVJPHj9zvM+WcPtS8=;
	b=Ea3pU+9ly03VW1w2imW7KzCHztcdJNFMUhpnUlaos4f8qlZlK2Iyf7nOmwmBsXBqob9T+t
	8Cui50ntHFw3yF5Z0C7lmk6hykto8fJsA6tf0sWPwCgN1mBJ7aC51SApbx8gUc5h9nYtqe
	+KsjvFMX5CwhkzBc64PXczkNvx0CNBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ch4xXQ7StUnbjm3wHzXSplK8uCVJPHj9zvM+WcPtS8=;
	b=LfEvdBOHdpNmcCrxSpDK/TCe23UdXe0e4qifp9xJNNRY++c569uAGTCEPITc4fy2cSB07K
	q6uQOla7sO6xzyCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA7FF1339F;
	Tue, 10 Nov 2026 10:33:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B5ZuMOPy8mr4LwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:33:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7843822483; Tue, 10 Nov 2026 11:33:07 +0100 (CET)
Date: Tue, 10 Nov 2026 11:33:07 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC v3 08/14] fs: set I_METADATA_WRITEBACK in
 mmb_mark_buffer_dirty()
Message-ID: <32pdmqc6zljbhiz2zvci5phqnzlh4ej2jeoymqepdggiwoatse@3xzb226r2au3>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-8-91ac6c024018@kernel.org>
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
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-8-91ac6c024018@kernel.org>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 2128B21E04

On Mon 09-11-26 17:51:23, Christian Brauner wrote:
> ext2, ext4 without a journal, fat, udf and minix track the metadata
> buffers of an inode in a mapping_metadata_bhs list and sync them from
> ->sync_inode_metadata() and ->evict_inode(). The inode block itself is
> only tracked by I_METADATA_WRITEBACK which ->write_inode() sets after
> copying the inode into its buffer.
> 
> Set the bit in mmb_mark_buffer_dirty() as well so that it covers all
> the metadata an inode may still have to write out. Set it after the
> buffer is on the list. An fsync() that sees the bit then also finds the
> buffer when it walks the list, and one that cleared the bit before we
> set it leaves it set for the next one.
> 
> The inode itself may never have been dirtied. fat for example tracks
> the FAT buffers on a private inode that nothing marks dirty. So attach
> the inode to a wb before setting the bit, the way ext4_mark_iloc_dirty()
> does, or writeback_single_inode() has no wb to lock once evict() syncs
> it.
> 
> That lets evict() write out everything the bit tracks in one place
> instead of every ->evict_inode() calling mmb_sync() itself.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good, just one nit below. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> @@ -641,6 +644,15 @@ void mmb_mark_buffer_dirty(struct buffer_head *bh,
>  		list_move_tail(&bh->b_assoc_buffers, &mmb->list);
>  		spin_unlock(&mmb->lock);
>  	}
> +	/*
> +	 * The inode itself may never have been dirtied, so attach it to a wb
> +	 * before setting the bit or writeback_single_inode() has nothing to
> +	 * lock when evict() syncs it.
> +	 */
> +	spin_lock(&inode->i_lock);
> +	inode_attach_wb(inode, NULL);
> +	inode_state_set(inode, I_METADATA_WRITEBACK);
> +	spin_unlock(&inode->i_lock);
>  }

I'd wrap this all in:

	if (!(inode_state_read_once(inode) & I_METADATA_WRITEBACK))

so that we save i_lock round-trip for the common case where
I_METADATA_WRITEBACK is already set.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
