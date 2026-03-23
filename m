Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8798F36605F
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 11:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774263920; cv=none; b=qX/7lj4S0ieBuNjCEIn4z9QuxjTHv2N+LfHVLkSAU7jshOxqka4HT/YJ7HU9jbbRY+tnA0ucH8B9BgJCR3V/XWdwdgelnqdxE8Q7l6M044a1fHEOTIF6E561Onf3I3xMKDTFWR8cNB3rh+YweE+2M0nQds9OUXko+5DxRhWT0Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774263920; c=relaxed/simple;
	bh=C0pcORVNFmJcfFR7Cm/tLMUqgtUSLbyV0ZLACjoJWds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eVJ6vI3iKbhKGxQq5LgVHgGMRiYcM7pjSc908vhskPDCQCcrSvvpmj2rJbwfG+8evh3bnNW+mfi4SznLxu1QLQF1qolgHAXwCDZYVhK0BV9F7lhk9R3yyunLWu+9b1me5US5Hk4yMTm9K6izkd5sxxZ/NXZNzYPiawnKCrZWtaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ffVgj5DxQzYQtlV
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 19:05:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 913A64056D
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 19:05:12 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhmHsFpYC28Bw--.1688S3;
	Mon, 23 Mar 2026 19:05:12 +0800 (CST)
Message-ID: <fb686349-254c-4e3b-8549-0d9c190673ad@huaweicloud.com>
Date: Mon, 23 Mar 2026 19:05:09 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error
 paths
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20260323060836.3452660-1-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260323060836.3452660-1-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgD3+NhmHsFpYC28Bw--.1688S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyxKF1Utw48CFyfGrW5GFg_yoW8Kr4kpF
	W2ya1xKr18XryqgwsaqFnxZay293Z3Kw45CrW7u3y7Zr12qw18Ka1a93WSvFsrtrW8Aa42
	qF1jvFZrCFyrG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/23/2026 2:08 PM, Baokun Li wrote:
> During code review, Joseph found that ext4_fc_replay_inode() calls
> ext4_get_fc_inode_loc() to get the inode location, which holds a
> reference to iloc.bh that must be released via brelse().
> 
> However, several error paths jump to the 'out' label without
> releasing iloc.bh:
> 
>  - ext4_handle_dirty_metadata() failure
>  - sync_dirty_buffer() failure
>  - ext4_mark_inode_used() failure
>  - ext4_iget() failure
> 
> Fix this by introducing an 'out_brelse' label placed just before
> the existing 'out' label to ensure iloc.bh is always released.
> 
> Additionally, make ext4_fc_replay_inode() propagate errors
> properly instead of always returning 0.
> 
> Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/fast_commit.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index f575751f1cae..f1df5581fa96 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1613,19 +1613,21 @@ static int ext4_fc_replay_inode(struct super_block *sb,
>  	/* Immediately update the inode on disk. */
>  	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
>  	if (ret)
> -		goto out;
> +		goto out_brelse;
>  	ret = sync_dirty_buffer(iloc.bh);
>  	if (ret)
> -		goto out;
> +		goto out_brelse;
>  	ret = ext4_mark_inode_used(sb, ino);
>  	if (ret)
> -		goto out;
> +		goto out_brelse;
>  
>  	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
>  	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
>  	if (IS_ERR(inode)) {
>  		ext4_debug("Inode not found.");
> -		return -EFSCORRUPTED;
> +		inode = NULL;
> +		ret = -EFSCORRUPTED;
> +		goto out_brelse;
>  	}
>  
>  	/*
> @@ -1642,13 +1644,14 @@ static int ext4_fc_replay_inode(struct super_block *sb,
>  	ext4_inode_csum_set(inode, ext4_raw_inode(&iloc), EXT4_I(inode));
>  	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
>  	sync_dirty_buffer(iloc.bh);
> +out_brelse:
>  	brelse(iloc.bh);
>  out:
>  	iput(inode);
>  	if (!ret)
>  		blkdev_issue_flush(sb->s_bdev);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  /*

