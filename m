Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795429231;
	b=XKLof8BoxZMeZ+vxwnV162kWQ/Ju9vFGJDRLSHGfrKInveDDr9JsS5sa5QpBgxzLGjNK
	 3Co4PtE4DzyP7BUshk1Vry63QOnPDr0Cpp1U5hyBYUnq/OUIMB/qqtGfx5FWxe/WeEZ/Z
	 8H0bAnXvXpG2wTzBU5bwTGPgtw0pK+lUNeI6f65d0mMXqdc1nopI/jSi/8tFxkGatb3sA
	 FKRKB6XleNo6ovE4CplKMfEtMsHFbHkQ7HsPsYbhiItzJzepNGtVN5F8G6CQqLZAaioum
	 UB04RK+JHikDmCpCNwFDxMvrxSh8rS9v+u6V9h455nCCIrlBT4/8M7TcWC0I24e+yZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795429231;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=nXQrda0aRT2N30fD5HbPAqaDJvuUWOe2czzuoJRWrUA=;
	b=BdiUAJr2iuwEftUo+wcPX1wj95o5EjgL1GIK9fOiG0enqstB051cpa6g0EKqtHKdubRF
	 QJK2DMWbydddTFw50BKuzjzBwwy5tmTUEeDzii4m9fKOAbGEgmR8eKT2LZGgtex4RRXYi
	 /E9d1ZvM0eYcCcnzbN+LWYWWdNl4nirlF7diB2W08dH+wdhOOIUlFiSAF7n680VcpjkN1
	 VIx5Bto0AzzG+fEvVWcS0NfDufitJTGlkm2Tw6wthuUs92Oer4DgZyCqF9678zKFNo/vX
	 hPaDo6aHoy2amO0B7AX6+qbWFkxwPgiC9r14e3GbYJE95hzfbETpHx4S5if4F40CSsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tzbZn+0l;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k4GN7YQQ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tzbZn+0l;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k4GN7YQQ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4725D606A31A;
	Mon, 23 Nov 2026 10:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4725D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tzbZn+0l;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k4GN7YQQ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tzbZn+0l;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k4GN7YQQ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 613C321F63;
	Mon, 23 Nov 2026 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795429229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nXQrda0aRT2N30fD5HbPAqaDJvuUWOe2czzuoJRWrUA=;
	b=tzbZn+0lWMOeGVW8eepVtUKEoFJd7gEouqnafCJd5b62+n1Kw8EcYA00eoOxmVVF6FuW5F
	/3N5lfUFow3GOyTq7JUlpY3w6vxG6ervN+oB9TgWBanF4YsxOdp2T8nM4yjWl6NtNgfQii
	t3mKbfm+vqhSO1uqgtn/uWjabp/xb9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795429229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nXQrda0aRT2N30fD5HbPAqaDJvuUWOe2czzuoJRWrUA=;
	b=k4GN7YQQojAvvnPaex0ZEUNq/8J6BnxLAMJQ6tyTZvz8jSaeAtrvhceyxvQem9FE+rVnxW
	3JiDkPWBNyKNUOBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795429229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nXQrda0aRT2N30fD5HbPAqaDJvuUWOe2czzuoJRWrUA=;
	b=tzbZn+0lWMOeGVW8eepVtUKEoFJd7gEouqnafCJd5b62+n1Kw8EcYA00eoOxmVVF6FuW5F
	/3N5lfUFow3GOyTq7JUlpY3w6vxG6ervN+oB9TgWBanF4YsxOdp2T8nM4yjWl6NtNgfQii
	t3mKbfm+vqhSO1uqgtn/uWjabp/xb9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795429229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nXQrda0aRT2N30fD5HbPAqaDJvuUWOe2czzuoJRWrUA=;
	b=k4GN7YQQojAvvnPaex0ZEUNq/8J6BnxLAMJQ6tyTZvz8jSaeAtrvhceyxvQem9FE+rVnxW
	3JiDkPWBNyKNUOBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3606D13510;
	Mon, 23 Nov 2026 10:20:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p6EaBG0TBGt7WAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 10:20:29 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B552C27642; Mon, 23 Nov 2026 11:20:13 +0100 (CET)
Date: Mon, 23 Nov 2026 11:20:13 +0100
From: Jan Kara <jack@suse.cz>
To: aykutcincik@ogr.eskisehir.edu.tr
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	syzbot+d79019213609e7056a19@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: discard inode preallocations when indirect block
 allocation fails
Message-ID: <y3nf4iozg3ec2kdo7g7a2ci4vo54j3ksjtdatx337q2jhgiip4@ynfo5ojxtr52>
References: <20261121-ext4-ind-discard-pa-v1-1-ee92928f7797@ogr.eskisehir.edu.tr>
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
In-Reply-To: <20261121-ext4-ind-discard-pa-v1-1-ee92928f7797@ogr.eskisehir.edu.tr>
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
	TAGGED_RCPT(0.00)[d79019213609e7056a19];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sat 21-11-26 16:09:40, Aykut Cıncık via B4 Relay wrote:
> From: Aykut Cıncık <aykutcincik@ogr.eskisehir.edu.tr>
> 
> When ext4_alloc_branch() or ext4_splice_branch() fails after the data
> blocks have been allocated, the blocks are released with
> ext4_free_blocks().  For an indirect-mapped inode these blocks usually
> come from the inode preallocation (PA), and ext4_mb_use_inode_pa() has
> already subtracted them from pa_free.  Freeing them does not return
> them to the PA, so the PA still covers the logical range while pa_free
> no longer accounts for it.
> 
> Writeback retries the same logical range after such a failure, for
> example after sb_getblk() returns NULL with -ENOMEM for an indirect
> block that lies beyond the end of a shrunk loop device, and
> ext4_mb_use_preallocated() picks the same PA again.  This time pa_free
> is smaller than the requested length and the BUG_ON() in
> ext4_mb_use_inode_pa() fires:
> 
>   kernel BUG at fs/ext4/mballoc.c:4779!
>   RIP: 0010:ext4_mb_use_inode_pa+0x557/0x890
>   Call Trace:
>    ext4_mb_use_preallocated+0xd96/0x1440
>    ext4_mb_new_blocks+0x72d/0x4900
>    ext4_ind_map_blocks+0x142c/0x2210
>    ext4_map_create_blocks+0x2be/0x5c0
>    ext4_map_blocks+0xbb2/0x1480
>    ext4_do_writepages+0x1dba/0x3a60
>    ext4_writepages+0x370/0x770
>    do_writepages+0x288/0x600
>    filemap_writeback+0x203/0x290
>    file_write_and_wait_range+0xf7/0x170
>    ext4_sync_file+0x418/0xdb0
>    do_fsync+0xda/0x240
> 
> If the BUG_ON() is not reached, the mismatch shows up later as
> "freeing already freed block" and "ext4_mb_release_inode_pa: free N,
> pa_free M" errors when the PA is released.
> 
> The extent-mapped path has handled this since mballoc was added by
> discarding the inode PAs before freeing the blocks in
> ext4_ext_map_blocks().  Do the same in both indirect error paths.
> 
> An AI coding assistant (Claude Code with Claude Opus) was used to
> analyse the syzbot report, write a reproducer, trace the root cause with
> temporary printk instrumentation, and draft both the fix and this
> changelog.  I have reviewed the change and verified it as follows:
> without the fix the reproducer hits the BUG_ON() deterministically in
> QEMU (virtme-ng, KASAN and lockdep enabled); with the fix it ran 3/3
> times without BUG, KASAN or pa_free reports.  The ext4 KUnit tests pass,
> and a copy/write/delete workload on a no-extents filesystem leaves
> e2fsck clean.
> 
> Reported-by: syzbot+d79019213609e7056a19@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d79019213609e7056a19
> Fixes: c9de560ded61 ("ext4: Add multi block allocator for ext4")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aykut Cıncık <aykutcincik@ogr.eskisehir.edu.tr>

Thanks. The patch looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> The syzbot reproducers no longer mount on current kernels (bigalloc with
> s_first_data_block != 0 is now rejected), so I used this reproducer instead:
> 
>   truncate -s 4M img
>   mkfs.ext4 -q -F -b 1024 -O ^extents,^huge_file,^has_journal,^metadata_csum,^64bit,^flex_bg img
>   losetup /dev/loop0 img
>   mount -o errors=continue /dev/loop0 /mnt
>   touch /mnt/f
>   ./shrink /mnt/f /dev/loop0
> 
> shrink.c writes 64 KiB, shrinks the loop device to 32 KiB with
> LOOP_SET_STATUS64 (lo_sizelimit), then rewrites and calls fsync().  The
> indirect block now lies beyond the end of the device, so sb_getblk() fails
> and ext4_alloc_branch() returns -ENOMEM.
> 
> shrink.c:
> 
>   #include <fcntl.h>
>   #include <linux/loop.h>
>   #include <stdio.h>
>   #include <string.h>
>   #include <sys/ioctl.h>
>   #include <unistd.h>
> 
>   int main(int argc, char **argv)
>   {
>   	static char buf[64 * 1024];
>   	struct loop_info64 li;
>   	int fd = open(argv[1], O_RDWR);
>   	int lfd = open(argv[2], O_RDWR);
> 
>   	if (fd < 0 || lfd < 0) { perror("open"); return 1; }
>   	memset(buf, 'a', sizeof(buf));
>   	pwrite(fd, buf, sizeof(buf), 0);
>   	if (ioctl(lfd, LOOP_GET_STATUS64, &li)) { perror("get"); return 1; }
>   	li.lo_sizelimit = 32 * 1024;
>   	if (ioctl(lfd, LOOP_SET_STATUS64, &li)) { perror("set"); return 1; }
>   	for (int r = 0; r < 8; r++) {
>   		pwrite(fd, buf, sizeof(buf), 0);
>   		printf("fsync %d: %d\n", r, fsync(fd));
>   	}
>   	return 0;
>   }
> 
> With the fix applied, fsync() in this reproducer still does not return,
> because writeback treats -ENOMEM as transient and keeps retrying.  That
> behaviour predates this patch and is not changed by it.
> 
> Two related problems in the same error paths are not addressed here and
> can be sent separately if wanted:
>  - ext4_splice_branch() does not undo *where->p = where->key on failure.
>  - The blocks are freed with a quota update even for delalloc-reserved
>    blocks, which can underflow i_blocks.
> ---
>  fs/ext4/indirect.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index a495080df710..3b4ec1c3d5ec 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -389,6 +389,11 @@ static int ext4_alloc_branch(handle_t *handle,
>  	return 0;
>  failed:
>  	if (i == indirect_blks) {
> +		/*
> +		 * The data blocks may come from the inode PA, which already
> +		 * counts them as used; drop the PA so they are not handed out twice.
> +		 */
> +		ext4_discard_preallocations(ar->inode);
>  		/* Free data blocks */
>  		ext4_free_blocks(handle, ar->inode, NULL, new_blocks[i],
>  				 ar->len, 0);
> @@ -493,6 +498,8 @@ static int ext4_splice_branch(handle_t *handle,
>  		ext4_free_blocks(handle, ar->inode, where[i].bh, 0, 1,
>  				 EXT4_FREE_BLOCKS_FORGET);
>  	}
> +	/* See ext4_alloc_branch(): the data blocks may belong to the inode PA. */
> +	ext4_discard_preallocations(ar->inode);
>  	ext4_free_blocks(handle, ar->inode, NULL, le32_to_cpu(where[num].key),
>  			 ar->len, 0);
>  
> 
> ---
> base-commit: c44104f3642da720164042623e4832836aefdd8e
> change-id: 20261121-ext4-ind-discard-pa-89f4515f9a77
> 
> Best regards,
> --  
> Aykut Cıncık <aykutcincik@ogr.eskisehir.edu.tr>
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
