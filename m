Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655986;
	b=kBQ59ErNt+ROhufqo43m281Ua9ocCC8ad+jqK2ecysxIVME4v1mKuATtiEuTtjLVn+6x
	 gv3ILkUId0W4RN8ekme3A71WEPxk9MxDJnnjZkzAZUOgOi06bRIF+9DVJRudghi/CernL
	 /hwSnU6fnUczQ7cKDVGRiO5H6uRg+i2KWCCKJpSEPcqQerUwjUTytmDoqTN0XcTqqJCgW
	 I3drPG71F3kM8k41Ax854tGc8ySp+QaSQ7SW3WUVRiOBqifUEuAkCZfRUPbSBTTWDSeEK
	 UOU+MViMNVFRaZB7zv2P9hmbPF/3QwMOvJqhK5Qutgh3nV2zpkuzXxJJO4jYSv5+ayw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655986;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=UBFqrKp4cKUYcFlAf02vBn1ItZ8E2DcxpmhGQRQybUo=;
	b=H9QIIJo3OBB60gMHFay8OH9lsSKiEcae11Oj3i9xGQuhSimvY3H2BHEWKeUzqA1tIqJv
	 jWL2BMv/ukR/XVPjl+KHRgMv2NlDoNU6KsoWw5uT5iP0VUnfQrGsxuNOHYf0hJny2oz7R
	 /T24PJLDjkD575YX1oEApbEySs7d3IbKyF4/ZC1sb/M62IjvijJYJpjqyNFHuNS+r/G0C
	 KuerhizeYuL+oK96MwyMsM5blfUueUYlgKmZ1ce2vGa+f3SLDehj0Om7ZQjhOiNbD36pV
	 FWXKpkfbWLz8qcPukfuczN/Ota3Q+zMyfPY1R6CDf7eaOfWYozIm2SHOmtK+lMyj+lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fgYQRJTT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fIdKJXjG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fgYQRJTT;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fIdKJXjG;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64924606A339;
	Mon,  2 Nov 2026 21:46:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64924606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fgYQRJTT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fIdKJXjG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fgYQRJTT;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fIdKJXjG
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3B52621F8A;
	Mon,  2 Nov 2026 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793655983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UBFqrKp4cKUYcFlAf02vBn1ItZ8E2DcxpmhGQRQybUo=;
	b=fgYQRJTT0Z+vNC4puk6jADiGxf5ZlpVAkSmHBb632oH0XKWeOZFMT+ej1Bw13/U4eZnRqp
	Ge8Ropb5TDyCfu1OLxe27ImlDBXwFTlZaDk7OZWHvfNccIYEVUrlIdVKVWM+h8LVdKUgt+
	pBIMu13vmOIhhAN0QLYabhrQqtPATHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793655983;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UBFqrKp4cKUYcFlAf02vBn1ItZ8E2DcxpmhGQRQybUo=;
	b=fIdKJXjGSsox3kwEiCRV+pA+zEOm8Dt1oOljkM/TdrhXab9qoVa8ylJMo38SnDw3oM2HWy
	PM8VLi1EbZO/yPCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fgYQRJTT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fIdKJXjG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793655983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UBFqrKp4cKUYcFlAf02vBn1ItZ8E2DcxpmhGQRQybUo=;
	b=fgYQRJTT0Z+vNC4puk6jADiGxf5ZlpVAkSmHBb632oH0XKWeOZFMT+ej1Bw13/U4eZnRqp
	Ge8Ropb5TDyCfu1OLxe27ImlDBXwFTlZaDk7OZWHvfNccIYEVUrlIdVKVWM+h8LVdKUgt+
	pBIMu13vmOIhhAN0QLYabhrQqtPATHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793655983;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UBFqrKp4cKUYcFlAf02vBn1ItZ8E2DcxpmhGQRQybUo=;
	b=fIdKJXjGSsox3kwEiCRV+pA+zEOm8Dt1oOljkM/TdrhXab9qoVa8ylJMo38SnDw3oM2HWy
	PM8VLi1EbZO/yPCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1151E134B3;
	Mon,  2 Nov 2026 21:46:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0qqsN64E6WqSfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:46:23 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A84ADB161; Mon, 02 Nov 2026 22:46:22 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:22 +0100
From: Jan Kara <jack@suse.cz>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: reject impossible group free cluster counts
Message-ID: <cbgvlgjlddvvjfzq2vsdyl2gmnn4dnwxkrty7lzeikbvx4jvwg@6h6jmvygf4cz>
References: <20261102042428.65204-1-zhaogongyi@bytedance.com>
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
In-Reply-To: <20261102042428.65204-1-zhaogongyi@bytedance.com>
X-Rspamd-Queue-Id: 3B52621F8A
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim,suse.cz:email]
X-Spam-Score: -11.51

On Mon 02-11-26 12:24:28, Zhao Gongyi wrote:
> ext4_count_free_clusters() initializes global free-space accounting from
> group descriptors. A corrupt bigalloc image advertises 201327130 free
> clusters in a 32-cluster group. The mount succeeds and delayed
> allocation later sees an impossible free-space total.
> 
> Reject counts above the group's cluster capacity during descriptor
> validation. Reuse the existing capacity calculation so bigalloc and
> short final groups use the same bound as the block bitmap.
> 
> Journal replay can overwrite a descriptor after the initial check. A
> crafted transaction changes a valid count to 32769 in a 32768-cluster
> group; a pre-replay-only check lets both read-only and read-write mounts
> succeed. Recheck after recovery, before initializing free-space
> counters. Limit the second scan to mounts needing recovery.
> 
> Apply the bound to read-only mounts too, since they use the descriptor
> count for in-memory accounting.
> 
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/balloc.c | 10 +++++-----
>  fs/ext4/ext4.h   |  2 ++
>  fs/ext4/super.c  | 38 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 778fe87..0f36630 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -159,8 +159,8 @@ static unsigned ext4_num_overhead_clusters(struct super_block *sb,
>  	return num_clusters;
>  }
>  
> -static unsigned int num_clusters_in_group(struct super_block *sb,
> -					  ext4_group_t block_group)
> +unsigned int ext4_num_clusters_in_group(struct super_block *sb,
> +					ext4_group_t block_group)
>  {
>  	unsigned int blocks;
>  
> @@ -228,7 +228,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
>  	 * the blocksize * 8 ( which is the size of bitmap ), set rest
>  	 * of the block bitmap to 1
>  	 */
> -	ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
> +	ext4_mark_bitmap_end(ext4_num_clusters_in_group(sb, block_group),
>  			     sb->s_blocksize * 8, bh->b_data);
>  	return 0;
>  }
> @@ -240,7 +240,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
>  				       ext4_group_t block_group,
>  				       struct ext4_group_desc *gdp)
>  {
> -	return num_clusters_in_group(sb, block_group) -
> +	return ext4_num_clusters_in_group(sb, block_group) -
>  		ext4_num_overhead_clusters(sb, block_group, gdp);
>  }
>  
> @@ -313,7 +313,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap_padding(struct super_block *sb,
>  {
>  	ext4_grpblk_t next_zero_bit;
>  	unsigned long bitmap_size = sb->s_blocksize * 8;
> -	unsigned int offset = num_clusters_in_group(sb, block_group);
> +	unsigned int offset = ext4_num_clusters_in_group(sb, block_group);
>  
>  	if (bitmap_size <= offset)
>  		return 0;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8d3af06..3956545 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3468,6 +3468,8 @@ extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
>  				      struct ext4_group_desc *bg);
>  extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
>  				     struct ext4_group_desc *bg);
> +unsigned int ext4_num_clusters_in_group(struct super_block *sb,
> +					ext4_group_t block_group);
>  extern __u32 ext4_free_group_clusters(struct super_block *sb,
>  				      struct ext4_group_desc *bg);
>  extern __u32 ext4_free_inodes_count(struct super_block *sb,
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7d8aedf..83e4ef6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3355,6 +3355,36 @@ void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
>  	gdp->bg_checksum = ext4_group_desc_csum(sb, block_group, gdp);
>  }
>  
> +static bool ext4_check_group_free_clusters(struct super_block *sb,
> +					   ext4_group_t group,
> +					  struct ext4_group_desc *gdp)
> +{
> +	unsigned int free_clusters = ext4_free_group_clusters(sb, gdp);
> +	unsigned int group_clusters = ext4_num_clusters_in_group(sb, group);
> +
> +	if (free_clusters > group_clusters) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "%s: group %u has invalid free clusters count %u > %u",
> +			 __func__, group, free_clusters, group_clusters);
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static int ext4_check_replayed_free_clusters(struct super_block *sb)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	ext4_group_t group;
> +
> +	for (group = 0; group < sbi->s_groups_count; group++) {
> +		struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
> +
> +		if (!ext4_check_group_free_clusters(sb, group, gdp))
> +			return -EFSCORRUPTED;
> +	}
> +	return 0;
> +}
> +
>  /* Called at mount-time, super-block is locked */
>  static int ext4_check_descriptors(struct super_block *sb,
>  				  ext4_fsblk_t sb_block,
> @@ -3467,6 +3497,8 @@ static int ext4_check_descriptors(struct super_block *sb,
>  			}
>  		}
>  		ext4_unlock_group(sb, i);
> +		if (!ext4_check_group_free_clusters(sb, i, gdp))
> +			return 0;
>  		if (!flexbg_flag)
>  			first_block += EXT4_BLOCKS_PER_GROUP(sb);
>  	}
> @@ -5567,6 +5599,12 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		err = ext4_load_and_init_journal(sb, es, ctx);
>  		if (err)
>  			goto failed_mount3a;
> +		/* Journal replay may change descriptors after the initial check. */
> +		if (needs_recovery) {
> +			err = ext4_check_replayed_free_clusters(sb);
> +			if (err)
> +				goto failed_mount_wq;
> +		}
>  		if (bdev_read_only(sb->s_bdev))
>  		    needs_recovery = 0;
>  	} else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&
> 
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
> -- 
> 2.39.5 (Apple Git-154)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
