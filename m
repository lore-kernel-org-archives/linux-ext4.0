Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBB139EF2E
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780041654; cv=none; b=HhKBhln/9kT9JbPjUjFGuzs87zE3idoBMXNwR2Ldvfps8+yfnO0tKo9DlvyWR9vbUb7nWlnLErPDGFDei1ROngt7H7tXVf2cowUeujw1XxbLmdxn/O6PN6iqRbRHh1MjO1lBCHA2bkcmDjZjRQI5heGcmX1EK9x6j/zYSzfvH/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780041654; c=relaxed/simple;
	bh=mKHW6uvZAkSaJehGNu3PADCW8wFOg5TaCw/xi3JwR1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=leqSO7Ux9c0SOczRt6P6So3Dzy5FtviIIDtBPr42aS8SiHWQ0FEqywMu/VqLmxeUQS/Kc9XdIYj7nx4oK3FAFkXPiLPAiJ4tWapAw7AA54NlNSRu2W4GPcQeLL/RaR3ZCbsqrhrmM2BA7vUGPYYQ89aq56bAuLDh8GpqDEoi7Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hI+0y9jD; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hI+0y9jD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780041649; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6nhbxKAg2KdgoJdVlJ4YjLnm/pfy6wckL3Gr9svP4bY=;
	b=hI+0y9jDed3QrqZoaXvLGD5oT4EveBgHygfzkzGjnNUaD1wl0KYFP1drjjJMnCEZ5LlGM0nwwHbX+H14g7Z5E/8jNZjge77IablLrupwWthREhcGi7JBwwulkt1l0geJmzxk9gj5LyUh5WGbqTa1oPRkefYdDQqjXLNkLqJ93EA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X3onPTv_1780041648;
Received: from 30.221.147.25(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X3onPTv_1780041648 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 16:00:48 +0800
Message-ID: <623182b8-0b9b-4d47-858a-4c7e2eb9bbb5@linux.alibaba.com>
Date: Fri, 29 May 2026 16:00:47 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: validate dx count against limit in dx_csum
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
References: <20260528160557.6956-1-ablagodarenko@thelustrecollective.com>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260528160557.6956-1-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/5/29 00:05, Artem Blagodarenko wrote:
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>
> Sashiko AI, during inspection of the "ext4: replace ext4_dir_entry
> with ext4_dir_entry_2" series, reported a missing bounds check on
> count against limit in DX block checksum verification and setup
> paths.
>
> The code validates that limit fits within block boundaries, but does
> not verify that count <= limit. A maliciously crafted filesystem image
> could therefore provide an artificially large count value.
>
> Since ext4_dx_csum() uses count to determine the checksum region
> size, this may result in an out-of-bounds access crossing page
> boundaries into unmapped memory, potentially leading to a crash during
> checksum verification.
>
> The same issue exists in ext4_dx_csum_set().
>
> The bug was not introduced by the patch under review, so the fix is sent
> separately.
>
> Signed-off-by: Artem Blagodarenko artem.blagodarenko@gmail.com

Looks good, feel free to add:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/namei.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a316fc2ac41b..20b7bac69889 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -472,7 +472,8 @@ static int ext4_dx_csum_verify(struct inode *inode,
>  	}
>  	limit = le16_to_cpu(c->limit);
>  	count = le16_to_cpu(c->count);
> -	if (count_offset + (limit * sizeof(struct dx_entry)) >
> +	if (!count || count > limit ||
> +	    count_offset + (limit * sizeof(struct dx_entry)) >
>  	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
>  		warn_no_space_for_csum(inode);
>  		return 0;
> @@ -501,7 +502,8 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry_2 *diren
>  	}
>  	limit = le16_to_cpu(c->limit);
>  	count = le16_to_cpu(c->count);
> -	if (count_offset + (limit * sizeof(struct dx_entry)) >
> +	if (!count || count > limit ||
> +	    count_offset + (limit * sizeof(struct dx_entry)) >
>  	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
>  		warn_no_space_for_csum(inode);
>  		return;


