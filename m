Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C92427A1A
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 14:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785247308; cv=none; b=mle85JOj5vG5MpP/jAQQcAO7z8GHrk2DSmaZw822fIU87UBP+VPauJDeZQLG3R9mPIteGjZWURqU2PJTPJ0B363rTuHa3hUQLBemJDm5BSGOdbNnNnoMwOJ2L0EXesEp+FhNzscDqqmmVTF0Kc2EzjqTQ4nwIPJnd1yGY2e1znk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785247308; c=relaxed/simple;
	bh=vEd8ol3gjnKr+VE6P3KVRcLVCTtwt11ZjbDmoB3XYmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ge3UiVpOoFlFc3iyqzQwxanO7nET0TTsbNMg3eXgYjMGK71yq0hwhFbMUsPu7Pl9tJyTl2NXoE5HJbhqEMOH3D7sPQWhBzWPmhGSX+K7avzx2c19KNIAbwySTT3FjyQlcYSuHdV7IayL8Tot5ei8rXlRd5yJo0wLbTtxREClv6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VDPRcSCK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ao1jlDkQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aUbhqyPo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=y8gJd070; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VDPRcSCK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ao1jlDkQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aUbhqyPo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="y8gJd070"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 122EB7C361;
	Tue, 28 Jul 2026 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785247301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3c0f2qQ3T/PsTyr9tny+1wqgMNXBLa+8jylPMH6gVnI=;
	b=VDPRcSCKZENHCn+TTrN8n1UDd1lO7v0cK1ZduV8NvsXp8vej6r+TKkREUhmXO4RVPM9dDB
	XcIdW3TE9W/8IeKOBVF76Pzp4uf7Uj3C2CEP4ioMpPdDjoUG6JenuWFzduNzfc12F6Ubwb
	n6omIVZTih6FArjxUo/512UnHovOFV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785247301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3c0f2qQ3T/PsTyr9tny+1wqgMNXBLa+8jylPMH6gVnI=;
	b=ao1jlDkQq+XO0aUIcUKwZr53QjpXM4YGp5jTNw3WbDqtTd+vk8TworBRHGMB2eeoUBtQ1J
	1wSuPdr3gT5PzYCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785247297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3c0f2qQ3T/PsTyr9tny+1wqgMNXBLa+8jylPMH6gVnI=;
	b=aUbhqyPoKGQsygwls+MdwseBjVRoyjKAeWVcFBUEJ5dpqcj24cq+EfSWUomGafyOPd6ovX
	arvAHgP4xkQWBFdqL6FWp34iKL5/z7DqOrInkMoyEa4Y23qm1K2Wf2TbBizee4nACPLqII
	OLHN36GdLUov9WRvCALoLvRw7XSlk/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785247297;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3c0f2qQ3T/PsTyr9tny+1wqgMNXBLa+8jylPMH6gVnI=;
	b=y8gJd0708XK5J8E9RygUsH+8Y/1DQCNjMnJBOw4YWfMbyHvx5VIw+fI1IOBbfndvVSg1DT
	ql2ia9s0XX4SelBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08607779B1;
	Tue, 28 Jul 2026 14:01:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M6MJAkG2aGrmeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 14:01:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A3881A10B6; Tue, 28 Jul 2026 16:01:28 +0200 (CEST)
Date: Tue, 28 Jul 2026 16:01:28 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] ext4: validate EA inode i_nlink in
 ext4_xattr_inode_iget
Message-ID: <vcplbpvf4tpxg5khdu7wwmxyqlo4tb7wji43yhbvfzjsdblumn@hooso27hekio>
References: <20260724100255.144768-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724100255.144768-1-yun.zhou@windriver.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,syzkaller.appspot.com:url,appspotmail.com:email]

On Fri 24-07-26 18:02:55, Yun Zhou wrote:
> Validate EA inode state in ext4_xattr_inode_iget() to reject corrupted
> EA inodes early, before they trigger WARN_ONCE in
> ext4_xattr_inode_update_ref().
> 
> When a corrupted ext4 image has an EA inode with inconsistent i_nlink
> and ref_count values (e.g. i_nlink=65535), the code currently allows it
> through and later hits WARN_ONCE when ref_count transitions cross the
> 0/1 boundary.  This is better handled as an early sanity check that
> returns -EFSCORRUPTED, consistent with how ext4 treats other on-disk
> corruption.
> 
> Since ext4_xattr_inode_iget() resolves references from active xattr
> entries, the target EA inode must be in active state (i_nlink=1,
> ref_count>0).  Reject any inode that does not satisfy this.
> 
> Reported-by: syzbot+76916a45d2294b551fd9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
> Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v5:
>  - Use ext4_put_ea_inode() instead of make_bad_inode() + iput() to
>    safely release the rejected inode regardless of jbd2 handle or
>    SB_ACTIVE state.
> 
> v4:
>  - Take I_MUTEX_XATTR before checking orphan state to safely decide
>    whether to call make_bad_inode(), avoiding orphan list corruption
>    if another thread is concurrently freeing the EA inode
> 
> v3:
>  - Move check after Lustre branch to avoid false positives on Lustre EA inodes
>  - Merge into single condition: i_nlink != 1 || !ref_count
>  - Add make_bad_inode() before iput() to avoid truncation in active txn
> 
> v2:
>  - Add ref_count validation to also catch i_nlink=1, ref_count=0 case
> 
>  fs/ext4/xattr.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 4ae6ce111566..1eee25955107 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -460,6 +460,21 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
>  		inode_unlock(inode);
>  	}
>  
> +	/*
> +	 * Since this function resolves references from active xattr entries,
> +	 * the EA inode must be in active state (i_nlink=1, ref_count>0).
> +	 * i_nlink > 1, i_nlink == 0 (dangling reference), or ref_count == 0
> +	 * (inconsistent with an active entry) all indicate on-disk corruption.
> +	 */
> +	if (inode->i_nlink != 1 || !ext4_xattr_inode_get_ref(inode)) {
> +		ext4_error(parent->i_sb,
> +			   "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
> +			   ea_ino, inode->i_nlink,
> +			   ext4_xattr_inode_get_ref(inode));
> +		ext4_put_ea_inode(inode);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	*ea_inode = inode;
>  	return 0;
>  }
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
