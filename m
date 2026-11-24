Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795536466;
	b=U5eAl3BCRhi59SspUamMRjkhgXzKgapbraZeDFV6z7TIYeKsg2FtFKXo89W17hTd5b7Q
	 xKCRZAGanxF7cP1Udvm/UJLEDroLsK7yEmpglfm3TZBy106D1myLsswE6OS9ns5LQARtB
	 MaN10vdI0W37JrsRVTcQKqWN5sef3UWkVlP1hO/SfTE1cACv2btsyNb1xO37KTCzOtoFN
	 8HkezbTVMmeLpkSO4N09aZRwITLshgtqce51TogmO/6nwv8UovIbsJJST26X0RYB4w55K
	 C8nTXBV+1HutMK2knyZiQM+F6T9M9nUty/SCKb8yxZjnA7eQ4M+VMImv0jkgg/Xd5ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536466;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=VH3Mo7BWyRJao5Iz7OpXEVPHceV2VLDqyb+mgj770Gk=;
	b=HtsqqcOLh5hbdfF3VjBDpykM7WMFBTyfzoUb8V3sIk0o19yFiHiOiUsrhCdc15v9nHbD
	 Gt1FOgI58tbqAYS4FoX6hKqSG3rtahx4Z/Sv/2PYD2XnDZ/mGtuRDrjAdfKuYHDU9NuJN
	 3pUG1kAUSA/oEPJbRy4hSDSoepiPlP52VJBo9kz2z+t9ZxLVkc1PgLSPXpp7bTNYfzyhV
	 FAQmBhogZxI8/3jjQfxu8dB58ZQEZMAvhlwNPuOa1tkd49lV2feeuBI5LsVzWjlZUyxAC
	 rW4EeYr71pXJKMFPUxcESRiGN0wiym/dzCW2XyDMWC/QDhvyxBVv0p62aOTC4Nt2eBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qISNgKdc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="r6IJUX/O";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YX3VFFNI;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=01qpIaIe;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B44606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 16:07:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8B44606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qISNgKdc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=r6IJUX/O;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YX3VFFNI;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=01qpIaIe
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B915E2230A;
	Tue, 24 Nov 2026 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795536464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VH3Mo7BWyRJao5Iz7OpXEVPHceV2VLDqyb+mgj770Gk=;
	b=qISNgKdc31FMu3ZZ4HdNVjX3fqa6e4nOdZ3HzT47aeUEE4nZR6KWQcBABEaAgqA0B4ICuZ
	OD/iTQ2XVR/eGbV6ydfmHrxNlrLHSwocp8eLZ3zxdj1r2MLoRytFUArx8Wr9POaPa/HzCZ
	rUhutqNAd0q7F1bLjbD1NOQzYQNBz0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795536464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VH3Mo7BWyRJao5Iz7OpXEVPHceV2VLDqyb+mgj770Gk=;
	b=r6IJUX/OZL6X8DyQ3aHjRWFEaZf44XCeMpUj/ZfS/lch2z8ySs7xU3rp3eWcTCPhKiJC+/
	8WgpveCK9toCzqAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795536462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VH3Mo7BWyRJao5Iz7OpXEVPHceV2VLDqyb+mgj770Gk=;
	b=YX3VFFNIN9hw4GNXAPzrwZ6CUhIMSf+qoEXT/MtmsRKy2Idj/KphgyGRpGf5MtE8MSYl2f
	zWfYAhXjIaUR7dGwXIuoy6BKEeohAm1PIMFHWita3087ZcXg5i+amcnTDK9yc85nb/yFbG
	kcoWmtbiB3iwtJKvQ/0T4+VmGZKWDnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795536462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VH3Mo7BWyRJao5Iz7OpXEVPHceV2VLDqyb+mgj770Gk=;
	b=01qpIaIe4pc7vUkfF5rFr9WbNp413v1+L0TCJHaW9aUxf9Y6vocMnJ91QWzjytYGmz/7z6
	bx0e18IOqy3mszDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91ABD1339F;
	Tue, 24 Nov 2026 16:07:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RHEQG062BWv6FgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 16:07:42 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0566027A0F; Tue, 24 Nov 2026 17:07:38 +0100 (CET)
Date: Tue, 24 Nov 2026 17:07:37 +0100
From: Jan Kara <jack@suse.cz>
To: Peng Hao <flyingpenghao@gmail.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] ext2: Reject a superblock with an invalid s_first_ino
Message-ID: <a43ddlz6greotn5y6r6zl3arlsaeycp7eon55yvwbflpxx6qur@4pwyxll5wbjx>
References: <20261124111708.24204-1-flyingpeng@tencent.com>
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
In-Reply-To: <20261124111708.24204-1-flyingpeng@tencent.com>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tencent.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Tue 24-11-26 19:17:07, Peng Hao wrote:
> ext2_fill_super() takes s_first_ino from a revision 1 superblock without
> checking it.  ext2_get_inode() and ext2_nfs_get_inode() only reject
> inode numbers below EXT2_FIRST_INO(sb), so with s_first_ino == 0 an
> inode number of 0 gets through, and (ino - 1) wraps around when the
> block group is computed.  On such an image, opening a file handle with
> inode number 0 (open_by_handle_at(), or an NFS client if the filesystem
> is exported) triggers:
> 
>   block_group >= groups_count - block_group = -1, groups_count = 2
>   WARNING: balloc.c:51 at ext2_get_group_desc+0x5b/0x90 [ext2]
>    ext2_get_inode+0x9c/0x160 [ext2]
>    ext2_iget+0x63/0x4b0 [ext2]
> 
> Depending on s_inodes_per_group, the truncated group number may also
> land inside the filesystem, so that some other inode is read in place of
> inode 0.  Values from 1 to 10 make the reserved inodes reachable through
> file handles.
> 
> ext4 rejects s_first_ino < EXT4_GOOD_OLD_FIRST_INO at mount time since
> commit c37e9e013469 ("ext4: add more inode number paranoia checks").  Do
> the same for ext2.  As s_first_ino is an int, this also rejects values
> of 0x80000000 and above, which turn negative and make every inode except
> the root inode look reserved.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>

Thanks, I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/super.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index a40f530872a4..8a4412231394 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1014,6 +1014,11 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
>  	} else {
>  		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
>  		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
> +		if (sbi->s_first_ino < EXT2_GOOD_OLD_FIRST_INO) {
> +			ext2_msg(sb, KERN_ERR, "error: invalid first ino: %u",
> +				 le32_to_cpu(es->s_first_ino));
> +			goto failed_mount;
> +		}
>  		if ((sbi->s_inode_size < EXT2_GOOD_OLD_INODE_SIZE) ||
>  		    !is_power_of_2(sbi->s_inode_size) ||
>  		    (sbi->s_inode_size > blocksize)) {
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
