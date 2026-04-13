Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE593AC0FB
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 08:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776069438; cv=none; b=BOzhSP0IWzgh/LS6IpnG3oEA3PNJXczG9btlLXQ3wS0TPl/ywmOtGxIR1WKgng+XYK6EIUIXNi3Mo9Gyx1yMWFosTt8vqpTq2pyTqBS4kAusFp0RjMVAk5hxhtjIfx5kgVxDX7Z/hlThae4wsxPOMRplJHJMUlKFkvm+eKNo3KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776069438; c=relaxed/simple;
	bh=OUTQED68C9rs9t0mYnPiCB5SItQkdbfRZew5KCAWem0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qJv7YvxVFHxUOWT8ppCCw5PSZvBrF7OzsUtN80C40EXwji2oO6wQt5aXvyRickSzPsC/pZQu+tfaBpffTuMi1hBTfLjJQ9iTWgXBbUiQt3vNk2W7mhoZSbuXSxS80bMqEE+Ml8ReNsNKNRMrR0pdHHl9YxR6iIVYaNR/sdUrnjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0rNN1GR2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QIDKGrV5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vhbQE5iY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Cf4xPT7z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0rNN1GR2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QIDKGrV5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vhbQE5iY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Cf4xPT7z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E608A6A895;
	Mon, 13 Apr 2026 08:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776069433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KysSLphccvMOluji1k4q2wryqMpXWkiFK+wkqX537Uc=;
	b=0rNN1GR22IvrXl6CdNPHH2E0Zl+rLoT5Zegxbjscy8Pd9eXyIDSPtYYPFtKa73JEpk8ZYA
	QPO58yEwC3uKqVcqSgF5anyMJiNfaOw1ROEv/mnA6r1gOCh9jOIuwMBLOJbhaIv0ozcY4U
	iN/WZfX+msWixxKNX8WIEP3ODy8suEU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776069433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KysSLphccvMOluji1k4q2wryqMpXWkiFK+wkqX537Uc=;
	b=QIDKGrV5nKp7tF64XkVtU5zatzLDg6QsuwwBPsGYIa+CfmSyfIk99ElQAk/Uq/dbmhx+ou
	Km6S4OvDnSeThrAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776069432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KysSLphccvMOluji1k4q2wryqMpXWkiFK+wkqX537Uc=;
	b=vhbQE5iYZwi3z3rhsNcg1AWIfd4l0+PTx9SsKRJBNf9cyTIeWhqlesibmeHhtitWBy3Ari
	UNunS88kwPNSHQZdZISDBpChsdJ6d9Z5Ntm2rmr7mImbBbHurFNXAb/nLo/f2jBi3oDylK
	p0WWlB5+U5E48J4nOyYOmkMmbFsnCYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776069432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KysSLphccvMOluji1k4q2wryqMpXWkiFK+wkqX537Uc=;
	b=Cf4xPT7zoSLfw5FILDwcHpSzNXfF1HupriFp+IaBtPOynoXlxFz85tac9Odl7ynHTe23rK
	JpIXPfFP1xKYrRDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7F964ADC1;
	Mon, 13 Apr 2026 08:37:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 442uNDir3GnDGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Apr 2026 08:37:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 99F06A0AFF; Mon, 13 Apr 2026 10:37:12 +0200 (CEST)
Date: Mon, 13 Apr 2026 10:37:12 +0200
From: Jan Kara <jack@suse.cz>
To: guzebing <guzebing1612@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, guzebing@bytedance.com, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: make mballoc max prealloc size configurable
Message-ID: <ww52l2gs7ddtsuz3xzhw3ud2ljjy445gypirrzegqm3z3gtbq5@jevysrhrmgte>
References: <20260410035635.1381920-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410035635.1381920-1-guzebing1612@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,bytedance.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Fri 10-04-26 11:56:35, guzebing wrote:
> From: Guzebing <guzebing@bytedance.com>
> 
> Add per-superblock sysfs knob mb_max_prealloc_kb (min 8MiB, roundup
> pow2) and use it in request normalization.
> 
> When multiple tasks write to different files on the same filesystem
> concurrently, each file ends up with 8 MiB extents. If the preallocation
> size is increased, the resulting extent size grows accordingly. Due
> to the readahead mechanism on NVMe SSDs, files with larger extents
> achieve higher sequential read throughput.
> 
> On an ext4 filesystem on an NVMe Gen4 data drive, dd read throughput
> for a file with 8 MiB extents is 455 MB/s, while for a file with
> 32 MiB extents it reaches 702 MB/s.

Hum, I think you are not speaking about general Linux readahead code here..

> Steps to reproduce:
> 1.Configure the maximum preallocation size to 8 MiB or 32 MiB:
> echo 8192 > /sys/fs/ext4/nvme13n1/mb_max_prealloc_kb
> echo 32768 > /sys/fs/ext4/nvme13n1/mb_max_prealloc_kb
> 
> 2.Run the following commands simultaneously so that the extents of
> the two files are physically interleaved, resulting in 8 MiB or 32 MiB
> extents:
> dd if=/dev/zero of=/mnt/store1/501.txt bs=128K count=80K oflag=direct
> dd if=/dev/zero of=/mnt/store1/502.txt bs=128K count=80K oflag=direct
> 
> 3.Read back the file and measure the read throughput:
> dd if=/mnt/store1/501.txt of=/dev/null bs=128K count=80K iflag=direct

OK, seeing that you are using direct IO here you are likely speaking about
some internal mechanism within the SSD that is happier when the IO is more
contiguous in the LBA space?

In general I find the example you show with dd not very performance
relevant. If you care about performance, then you should be running
multiple direct IO requests in parallel (either with AIO/DIO or with
iouring). Or you should be using buffered IO to do this for you behind the
scenes. So do you have a more realistic usecase where the extent allocation
size matters so much or is this mostly a benchmarking exercise?

								Honza
> 
> Signed-off-by: Guzebing <guzebing@bytedance.com>
> ---
>  Documentation/ABI/testing/sysfs-fs-ext4 |  8 +++++++
>  fs/ext4/ext4.h                          |  1 +
>  fs/ext4/mballoc.c                       |  2 +-
>  fs/ext4/super.c                         |  1 +
>  fs/ext4/sysfs.c                         | 28 ++++++++++++++++++++++++-
>  5 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
> index 2edd0a6672d3a..316ae1d1ec18b 100644
> --- a/Documentation/ABI/testing/sysfs-fs-ext4
> +++ b/Documentation/ABI/testing/sysfs-fs-ext4
> @@ -48,6 +48,14 @@ Description:
>  		will have its blocks allocated out of its own unique
>  		preallocation pool.
>  
> +What:		/sys/fs/ext4/<disk>/mb_max_prealloc_kb
> +Date:		April 2026
> +Contact:	"Linux Ext4 Development List" <linux-ext4@vger.kernel.org>
> +Description:
> +		Maximum size (in kilobytes) used by the multiblock allocator's
> +		normalized request preallocation heuristic. Values are rounded
> +		up to a power of two and clamped to a minimum of 8192 (8MiB).
> +
>  What:		/sys/fs/ext4/<disk>/inode_readahead_blks
>  Date:		March 2008
>  Contact:	"Theodore Ts'o" <tytso@mit.edu>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7617e2d454ea5..bce99740740f5 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1634,6 +1634,7 @@ struct ext4_sb_info {
>  	unsigned int s_mb_best_avail_max_trim_order;
>  	unsigned int s_sb_update_sec;
>  	unsigned int s_sb_update_kb;
> +	unsigned int s_mb_max_prealloc_kb;
>  
>  	/* where last allocation was done - for stream allocation */
>  	ext4_group_t *s_mb_last_groups;
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index bb58eafb87bcd..f5f63c56fcdac 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4589,7 +4589,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  					(8<<20)>>bsbits, max, 8 * 1024)) {
>  		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
>  							(23 - bsbits)) << 23;
> -		size = 8 * 1024 * 1024;
> +		size = (loff_t)sbi->s_mb_max_prealloc_kb << 10;
>  	} else {
>  		start_off = (loff_t) ac->ac_o_ex.fe_logical << bsbits;
>  		size	  = (loff_t) EXT4_C2B(sbi,
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a34efb44e73d7..f815e31657cc9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5447,6 +5447,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		sbi->s_stripe = 0;
>  	}
>  	sbi->s_extent_max_zeroout_kb = 32;
> +	sbi->s_mb_max_prealloc_kb = 8 * 1024;
>  
>  	/*
>  	 * set up enough so that it can read an inode
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 923b375e017fa..6339492eb2fa7 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -10,6 +10,8 @@
>  
>  #include <linux/time.h>
>  #include <linux/fs.h>
> +#include <linux/log2.h>
> +#include <linux/limits.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <linux/proc_fs.h>
> @@ -41,6 +43,7 @@ typedef enum {
>  	attr_pointer_atomic,
>  	attr_journal_task,
>  	attr_err_report_sec,
> +	attr_mb_max_prealloc_kb,
>  } attr_id_t;
>  
>  typedef enum {
> @@ -115,6 +118,25 @@ static ssize_t reserved_clusters_store(struct ext4_sb_info *sbi,
>  	return count;
>  }
>  
> +static ssize_t mb_max_prealloc_kb_store(struct ext4_sb_info *sbi,
> +					const char *buf, size_t count)
> +{
> +	unsigned int v;
> +	int ret;
> +	unsigned long rounded;
> +
> +	ret = kstrtouint(skip_spaces(buf), 0, &v);
> +	if (ret)
> +		return ret;
> +	if (v < 8192)
> +		v = 8192;
> +	rounded = roundup_pow_of_two((unsigned long)v);
> +	if (rounded > UINT_MAX)
> +		return -EINVAL;
> +	sbi->s_mb_max_prealloc_kb = (unsigned int)rounded;
> +	return count;
> +}
> +
>  static ssize_t trigger_test_error(struct ext4_sb_info *sbi,
>  				  const char *buf, size_t count)
>  {
> @@ -288,6 +310,7 @@ EXT4_RW_ATTR_SBI_UI(mb_prefetch_limit, s_mb_prefetch_limit);
>  EXT4_RW_ATTR_SBI_UL(last_trim_minblks, s_last_trim_minblks);
>  EXT4_RW_ATTR_SBI_UI(sb_update_sec, s_sb_update_sec);
>  EXT4_RW_ATTR_SBI_UI(sb_update_kb, s_sb_update_kb);
> +EXT4_ATTR_OFFSET(mb_max_prealloc_kb, 0644, mb_max_prealloc_kb, ext4_sb_info, s_mb_max_prealloc_kb);
>  
>  static unsigned int old_bump_val = 128;
>  EXT4_ATTR_PTR(max_writeback_mb_bump, 0444, pointer_ui, &old_bump_val);
> @@ -341,6 +364,7 @@ static struct attribute *ext4_attrs[] = {
>  	ATTR_LIST(last_trim_minblks),
>  	ATTR_LIST(sb_update_sec),
>  	ATTR_LIST(sb_update_kb),
> +	ATTR_LIST(mb_max_prealloc_kb),
>  	ATTR_LIST(err_report_sec),
>  	NULL,
>  };
> @@ -431,6 +455,7 @@ static ssize_t ext4_generic_attr_show(struct ext4_attr *a,
>  	case attr_mb_order:
>  	case attr_pointer_pi:
>  	case attr_pointer_ui:
> +	case attr_mb_max_prealloc_kb:
>  		if (a->attr_ptr == ptr_ext4_super_block_offset)
>  			return sysfs_emit(buf, "%u\n", le32_to_cpup(ptr));
>  		return sysfs_emit(buf, "%u\n", *((unsigned int *) ptr));
> @@ -557,6 +582,8 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
>  		return reserved_clusters_store(sbi, buf, len);
>  	case attr_inode_readahead:
>  		return inode_readahead_blks_store(sbi, buf, len);
> +	case attr_mb_max_prealloc_kb:
> +		return mb_max_prealloc_kb_store(sbi, buf, len);
>  	case attr_trigger_test_error:
>  		return trigger_test_error(sbi, buf, len);
>  	case attr_err_report_sec:
> @@ -695,4 +722,3 @@ void ext4_exit_sysfs(void)
>  	remove_proc_entry(proc_dirname, NULL);
>  	ext4_proc_root = NULL;
>  }
> -
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
