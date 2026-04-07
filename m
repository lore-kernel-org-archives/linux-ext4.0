Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7141521B9F5
	for <linux-ext4@vger.kernel.org>; Tue,  7 Apr 2026 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570472; cv=none; b=Gwhb+XEjyZNn2g74mssZLNLAyLEz23B+bPuXwtV2Ma0yTJYpQVpwb2LdLSfLSqVaDYB5e4jCsOE0HjYkMU+R5WveLjeCcO32WH5gATF18XMbQq5g33mWHfkDuL8+OE2PQllyv7n8KqBT/vYU+/nw4060pkuX6GaSVX72fwM+/a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570472; c=relaxed/simple;
	bh=nt3VqJQXTR21Rp2kyBxpvnL/FzButQj5JZ0BhqYPuvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQZFVWe+Jmb5el9J3oERz/mOaCzagy7ulgktv6ilYOGxMdasQquKCvXMpCaclnZrOjPmnz+au+jM7tcigDbbQkcVbZnpwQbSm95Z8MhVaFRqDVT80QsppfSUfEDrgc9S1alU9wyv53bo1ZLi+FgMmCAyD9WBToFovpbX4v83cag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DYN6IVUI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wgcsjY79; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YfSsOjNv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=J7VSvXKx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DYN6IVUI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wgcsjY79";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YfSsOjNv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="J7VSvXKx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB4E74E48A;
	Tue,  7 Apr 2026 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775570464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3B0E0VJbP0ni6UNC+CyIHckgKZHIPszOu5IpL3GJgzM=;
	b=DYN6IVUIPIPPE2tcKJ1f+MeqVM7yEsizKGCQHHFlp5my1hSLMflRT7x6QiOldvp3/C9Qcz
	+2SV2eQCXBzxBQ1xKbwMglq1J0FvKZCrcqcFBi6UAGhOyY3Tj6blVyNE+iwXc7KQ3ube9H
	axDDgFqbwisqgfXCPhXSRQdAyOKM6CM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775570464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3B0E0VJbP0ni6UNC+CyIHckgKZHIPszOu5IpL3GJgzM=;
	b=wgcsjY79Dj6SKSbWDGJl9rSDoRO4Q3d7Hw55zUOJSujykgKFNkrQy4y3MSGrWMR2FQKJnz
	brLuMN/rMBQZZADA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YfSsOjNv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J7VSvXKx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775570459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3B0E0VJbP0ni6UNC+CyIHckgKZHIPszOu5IpL3GJgzM=;
	b=YfSsOjNvmkTZW/KbZ0vcw8saC8C/u94/AD7JlFCEUV1qcErEY9i7N1qQgyHoq00OveH/rn
	ISyPKYUxthVPOrB0AA1YFK7sjjrz1aRWPGeZpyq/qRDlAaB0ZDqXxal/Y1SGsSwqBfy7nZ
	znRDbEFQtr3wQ+k9lXMg+pq+vkGHR1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775570459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3B0E0VJbP0ni6UNC+CyIHckgKZHIPszOu5IpL3GJgzM=;
	b=J7VSvXKxs8506sckFipEqmcKn4fJstYElFW2/LHI8wTFMxVNaQVmliWzxl2/WKS69Cza5n
	S85gks8SmIQiVrBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C03954A0B0;
	Tue,  7 Apr 2026 14:00:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z8npLhsO1WmScwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 07 Apr 2026 14:00:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 658BDA0A81; Tue,  7 Apr 2026 16:00:51 +0200 (CEST)
Date: Tue, 7 Apr 2026 16:00:51 +0200
From: Jan Kara <jack@suse.cz>
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] ext2: reject inodes with zero i_nlink and valid mode in
 ext2_iget()
Message-ID: <3fvlnlctw6skbkl6egh4wdz3fhhyuhjudxkk2suh5va7xx6s5p@4hjink4jidco>
References: <20260404152011.2590197-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404152011.2590197-1-kovalev@altlinux.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RSPAMD_URIBL_FAIL(0.00)[suse.cz:query timed out];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,vger.kernel.org,osdl.org,gmail.com,linuxtesting.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: CB4E74E48A
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Sat 04-04-26 18:20:11, Vasiliy Kovalev wrote:
> ext2_iget() already rejects inodes with i_nlink == 0 when i_mode is
> zero or i_dtime is set, treating them as deleted. However, the case of
> i_nlink == 0 with a non-zero mode and zero dtime slips through. Since
> ext2 has no orphan list, such a combination can only result from
> filesystem corruption - a legitimate inode deletion always sets either
> i_dtime or clears i_mode before freeing the inode.
> 
> A crafted image can exploit this gap to present such an inode to the
> VFS, which then triggers WARN_ON inside drop_nlink() (fs/inode.c) via
> ext2_unlink(), ext2_rename() and ext2_rmdir():
> 
> WARNING: CPU: 3 PID: 609 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
> CPU: 3 UID: 0 PID: 609 Comm: syz-executor Not tainted 6.12.77+ #1
> Call Trace:
>  <TASK>
>  inode_dec_link_count include/linux/fs.h:2518 [inline]
>  ext2_unlink+0x26c/0x300 fs/ext2/namei.c:295
>  vfs_unlink+0x2fc/0x9b0 fs/namei.c:4477
>  do_unlinkat+0x53e/0x730 fs/namei.c:4541
>  __x64_sys_unlink+0xc6/0x110 fs/namei.c:4587
>  do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> WARNING: CPU: 0 PID: 646 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
> CPU: 0 UID: 0 PID: 646 Comm: syz.0.17 Not tainted 6.12.77+ #1
> Call Trace:
>  <TASK>
>  inode_dec_link_count include/linux/fs.h:2518 [inline]
>  ext2_rename+0x35e/0x850 fs/ext2/namei.c:374
>  vfs_rename+0xf2f/0x2060 fs/namei.c:5021
>  do_renameat2+0xbe2/0xd50 fs/namei.c:5178
>  __x64_sys_rename+0x7e/0xa0 fs/namei.c:5223
>  do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> WARNING: CPU: 0 PID: 634 at fs/inode.c:336 drop_nlink+0xad/0xd0 fs/inode.c:336
> CPU: 0 UID: 0 PID: 634 Comm: syz-executor Not tainted 6.12.77+ #1
> Call Trace:
>  <TASK>
>  inode_dec_link_count include/linux/fs.h:2518 [inline]
>  ext2_rmdir+0xca/0x110 fs/ext2/namei.c:311
>  vfs_rmdir+0x204/0x690 fs/namei.c:4348
>  do_rmdir+0x372/0x3e0 fs/namei.c:4407
>  __x64_sys_unlinkat+0xf0/0x130 fs/namei.c:4577
>  do_syscall_64+0xf5/0x220 arch/x86/entry/common.c:78
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> Extend the existing i_nlink == 0 check to also catch this case,
> reporting the corruption via ext2_error() and returning -EFSCORRUPTED.
> This rejects the inode at load time and prevents it from reaching any
> of the namei.c paths.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>

Thanks. I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/inode.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index dbfe9098a124..39d972722f5f 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1430,9 +1430,17 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  	 * the test is that same one that e2fsck uses
>  	 * NeilBrown 1999oct15
>  	 */
> -	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ei->i_dtime)) {
> -		/* this inode is deleted */
> -		ret = -ESTALE;
> +	if (inode->i_nlink == 0) {
> +		if (inode->i_mode == 0 || ei->i_dtime) {
> +			/* this inode is deleted */
> +			ret = -ESTALE;
> +		} else {
> +			ext2_error(sb, __func__,
> +				   "inode %lu has zero i_nlink with mode 0%o and no dtime, "
> +				   "filesystem may be corrupt",
> +				   ino, inode->i_mode);
> +			ret = -EFSCORRUPTED;
> +		}
>  		goto bad_inode;
>  	}
>  	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
> -- 
> 2.50.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
