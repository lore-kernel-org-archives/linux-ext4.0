Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49625175A85
	for <linux-ext4@vger.kernel.org>; Fri,  2 Oct 2026 12:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790943345; cv=none; b=YEgXq3rbMUvLxPcPAFhwyPjONbmiDG4yIFRWX5fXoR4DwZ44TQG7Bc4FqIQ6MB5V4mh/T6Nw5VIoyt/6FEsCjgJLVQRRXLBEkCJixLkcT3nEhGiQt7l98Emz5dx+P0kaXtVtfBw0CHnUM3nvuh3XMstsuaGPjwdvhL3SLRL5sWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790943345; c=relaxed/simple;
	bh=uYxCw6azyEkkmrXvnja6gsSOFsjpIawgGYBKjslrraw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=q7eO9QbXldfX1IAQRGAveBlyrVT05OVD1dTgKJzXR90/jm9o59BWYSQ4zgY4nAA07e138/JxWUujUC0DQMJI364meeNfuvxFDndNEUro9MEgVxlym3XAyYfRtE/8+Q4lKPZ76NmP0HG+JsgLG8DREVVu9gdgST0ImG7AP8El1fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DVZR28K6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVZR28K6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790943336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+0DCeacyY2UbnJSYFMUCNpLm1q/fdetDzgMEAhoA3ls=;
	b=DVZR28K6eGcKkomQ/v3KDkbF5DiyKyeMHO6SWY6ak0vVqIx/9wEDoZLQhXg7TqrRnxtl1W
	zF7gIrk8PpzrMptwj7Y7QYz2p+Sl4EtNzB7pzFyQgfbxgh/cSfA66rUMdT2N3yeSuDp3NR
	O3H0dlqgyqpUqTXOYSkMg+V3DlN3Y5A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-4i3zlOAONmahGrkNpqIr3w-1; Fri,
 02 Oct 2026 08:15:31 -0400
X-MC-Unique: 4i3zlOAONmahGrkNpqIr3w-1
X-Mimecast-MFC-AGG-ID: 4i3zlOAONmahGrkNpqIr3w_1790943330
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6330B1809C98;
	Fri,  2 Oct 2026 12:15:29 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 157F019560AB;
	Fri,  2 Oct 2026 12:15:26 +0000 (UTC)
Date: Fri, 2 Oct 2026 14:15:24 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>
cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
    Baokun Li <libaokun1@huawei.com>, Zhang Yi <yi.zhang@huawei.com>, 
    Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
    Ritesh Harjani <ritesh.list@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix maximum orphan file size check
In-Reply-To: <20261002115040.2783654-2-jack@suse.cz>
Message-ID: <9654a96e-918e-9ae4-e255-4931efc74e11@redhat.com>
References: <20261002115040.2783654-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Fri, 2 Oct 2026, Jan Kara wrote:

> Mikulas reported that e2fsprogs 1.47.4 with 1k fs blocksize by default
> creates orphan file of the size the kernel rejects. This is because that
> version of e2fsprogs creates 2MB file by default regardless of the block
> size and with 1k blocks that's more than the limit of 512 fs blocks.
> Fix the check to make kernel accept any file upto those 2MB regardless
> of the number of blocks.
> 
> Fixes: 7c11c56eb32e ("ext4: align max orphan file size with e2fsprogs limit")
> CC: stable@vger.kernel.org
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Link: https://lore.kernel.org/all/e65cdbfe-3ff9-4638-fbd3-4d8f8880966f@redhat.com
> Signed-off-by: Jan Kara <jack@suse.cz>

Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

Mikulas

> ---
>  fs/ext4/orphan.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index b4675aa7ea96..7394d04e0fd9 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -576,6 +576,7 @@ int ext4_init_orphan_info(struct super_block *sb)
>  	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
>  	struct ext4_orphan_block_tail *ot;
>  	ino_t orphan_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_orphan_file_inum);
> +	loff_t max_size;
>  
>  	if (!ext4_has_feature_orphan_file(sb))
>  		return 0;
> @@ -589,8 +590,13 @@ int ext4_init_orphan_info(struct super_block *sb)
>  	 * This is just an artificial limit to prevent corrupted fs from
>  	 * consuming absurd amounts of memory when pinning blocks of orphan
>  	 * file in memory.
> +	 *
> +	 * e2fsprogs 1.47.4 produces 2MB orphan files by default regardless
> +	 * of the number of blocks so that's where the second limit comes from.
>  	 */
> -	if (inode->i_size > (EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits)) {
> +	max_size = max(EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits,
> +		       2 << 20);
> +	if (inode->i_size > max_size) {
>  		ext4_msg(sb, KERN_ERR, "orphan file too big: %llu",
>  			 (unsigned long long)inode->i_size);
>  		ret = -EFSCORRUPTED;
> -- 
> 2.51.0
> 

