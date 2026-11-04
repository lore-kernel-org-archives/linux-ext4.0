Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793813243;
	b=kfqN7xW3NiyzT+3rIpyEyGs3xV1OmXEOahACoSJse8dBkDyTzfi8nuztSaB7LnVwFbDX
	 bHX01V8HJi0eG2N2MiK/djz6+uLeibDzDqNQ6MmucjteO1T2Vn5hex7L9Lsh0OQ60P7m4
	 5/xs2S0Z0pCyzF9tjAzwwPOMRX6unr+Z7Dyesnp3uyu2ExlxcmzwIHjiyZxKdkUM6MSaY
	 vSgMFINI9NdP7l1NfdgbjDJOa2KsX1IvkqhDD47qwsp4rS+TRR9M4qYlptJffZYGb0eZK
	 P8Of2y9OlyYA43EZiA7uMlMG3uCiHhqnX8EyLAIo0RvUMKZgBzuCoM94KpmCRzv3kDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813243;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=eGXvkssOV2QDvKB3+PMzPZxGJNQsG9ppegtem4X3jAA=;
	b=MZVE1VXst3syPBaSi6uI/k0Ujf/vNBTB76TtgKjcYdsUYysq595TqaZDd/OkIqlInW7O
	 /Hmj7g3pXxTBPqezPasDrjv8pfDNuUJ/lIA3Rp2nCsJ0nhEUpDDvMnOleCtfECWhCmITt
	 cVSuBe0v5i+e+8mT5QeytZ+uVvwRQMZJ4caKoozSMNQby8ruIlnRyE0wmyo9A27uNJNJQ
	 5eL5jTApueuoGChILbLdBfMCmuv9TYdIMAkjUs/CR2PGNcbel7rrJ3Iot52/ncIyFMSwz
	 ci25o8/04c+cz7AGj5HE+loLszybzAiCxnE7KiY7KDnKpuXCMKp9giTgf1Z9Jycjt4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="j/vl7Tbg";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OzKHMJAG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="j/vl7Tbg";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OzKHMJAG;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5752C606A32E;
	Wed,  4 Nov 2026 17:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5752C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=j/vl7Tbg;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OzKHMJAG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=j/vl7Tbg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OzKHMJAG
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6E9F71F388;
	Wed,  4 Nov 2026 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793813240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eGXvkssOV2QDvKB3+PMzPZxGJNQsG9ppegtem4X3jAA=;
	b=j/vl7TbgDG4aWWFGaOi6KJcWm2imBDDVVej95hpofUr1mto03JAa7EDAiBPvn8vMl6B4g1
	ieLwS8vN3PtDAm9avUFz5zrsdqmZ+cLXj4KdyRigvL0aeOq9zq0hGK+pLdLhkHOvMhEfKp
	P5QZQ7dsOWlStXXAcrOKrOXdscL7Cdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793813240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eGXvkssOV2QDvKB3+PMzPZxGJNQsG9ppegtem4X3jAA=;
	b=OzKHMJAGopRIcWM8G3UMwMA4uYbEiRqq2m8XPGgSJSAloVqsP2gsoCR6zoMDGkVrijpG1G
	IHPbJf13ZsffZkBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="j/vl7Tbg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OzKHMJAG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793813240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eGXvkssOV2QDvKB3+PMzPZxGJNQsG9ppegtem4X3jAA=;
	b=j/vl7TbgDG4aWWFGaOi6KJcWm2imBDDVVej95hpofUr1mto03JAa7EDAiBPvn8vMl6B4g1
	ieLwS8vN3PtDAm9avUFz5zrsdqmZ+cLXj4KdyRigvL0aeOq9zq0hGK+pLdLhkHOvMhEfKp
	P5QZQ7dsOWlStXXAcrOKrOXdscL7Cdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793813240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eGXvkssOV2QDvKB3+PMzPZxGJNQsG9ppegtem4X3jAA=;
	b=OzKHMJAGopRIcWM8G3UMwMA4uYbEiRqq2m8XPGgSJSAloVqsP2gsoCR6zoMDGkVrijpG1G
	IHPbJf13ZsffZkBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4349B134A5;
	Wed,  4 Nov 2026 17:27:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UjeMB/hq62o8KQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 17:27:20 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C3902B457; Wed, 04 Nov 2026 18:27:15 +0100 (CET)
Date: Wed, 4 Nov 2026 18:27:15 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 8/9] fat: sync the inode in fat_free_eofblocks()
Message-ID: <oilqmzo3vpddohxp46x3pjzf3wtoebahirtjqmt3izdw6ua5iq@ghdbk27wuf5f>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 6E9F71F388

On Thu 29-10-26 14:28:23, Christian Brauner wrote:
> fat_evict_inode() calls fat_free_eofblocks() for a linked inode to give
> back the clusters that were fallocated past the initialized size. For an
> empty file that also resets the start cluster in the directory entry. It
> truncates the clusters and writes the inode with:
> 
>   sync_inode_metadata(inode, inode_needs_sync(inode));
> 
> Unless the inode is IS_SYNC that is WB_SYNC_NONE writeback. It copies
> the inode into the directory entry buffer, marks the buffer dirty and
> sets I_METADATA_WRITEBACK. Then the inode goes away and with it the only
> thing that would have told a later fsync() that the directory entry
> still has to be written.
> 
> FAT doesn't have that problem. Its buffers are tracked on the FAT inode
  ^^ exFAT??

> and fat_file_fsync() writes them out on every fsync() of any file on the
> filesystem.
> 
> So after the next fsync() the clusters are free on disk while the
> directory entry of the empty file still points at them. If another file
> reuses them and the machine crashes before the directory entry makes it
> to disk, the two files share clusters. That's the corruption the comment
> in fat_free_eofblocks() is about.

Correct, but that does not violate anything AFAICT. fsync(2) promises data
is reachable (which it is), not that the fs metadata is all consistent.
For non-journaling filesystem you need fsck for such guarantee. And I know
I'm a bit obtuse here but the change results in a synchronous buffer write
on each eviction of inode that has preallocated blocks which will be a
noticeable performance regression for some usecases. Probably Ogawa should
decide whether this change is acceptable or whether we play fast and
loose... Ogawa?

								Honza

> So wait for the directory entry to reach the disk before the inode goes
> away.
> 
> Reproducer. The image file shows what reached the disk. The flusher is
> turned off so that it doesn't write the directory entry before fsck.fat
> looks at the image:
> 
>   img=/tmp/fat.img
>   truncate -s 64M $img
>   mkfs.vfat $img > /dev/null
>   dev=$(losetup -f --show $img)
>   mount -t vfat $dev /mnt
>   echo 0 > /proc/sys/vm/dirty_writeback_centisecs
>   xfs_io -f -c 'falloc -k 0 1m' -c fsync /mnt/a
>   echo 3 > /proc/sys/vm/drop_caches
>   echo 3 > /proc/sys/vm/drop_caches
>   xfs_io -c fsync /mnt/a
>   fsck.fat -n $img | grep -A1 '^/a'
>   umount /mnt
>   losetup -d $dev
> 
> On v7.3-17318-g65ba8f34ec88 in a KASAN and lockdep vng guest this
> prints:
> 
>   /a
>     Contains a free cluster (3). Assuming EOF.
> 
> With this patch fsck.fat finds nothing wrong with /a.
> 
> The stable tag is narrower than the Fixes tag. Before v7.3
> fat_free_eofblocks() called __fat_write_inode() directly and the fix
> there is to pass 1 for wait.
> 
> Fixes: b13bb33eacb7 ("fat: add fat_fallocate operation")
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/fat/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index d85c8fbdcca4..fc571ee2b174 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -675,7 +675,7 @@ static void fat_free_eofblocks(struct inode *inode)
>  		 * any corruption on the next access to the cluster
>  		 * chain for the file.
>  		 */
> -		err = sync_inode_metadata(inode, inode_needs_sync(inode));
> +		err = sync_inode_metadata(inode, 1);
>  		if (err) {
>  			fat_msg(inode->i_sb, KERN_WARNING, "Failed to "
>  					"update on disk inode for unused "
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
