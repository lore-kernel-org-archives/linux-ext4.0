Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DADB399003;
	Mon, 23 Mar 2026 12:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774267937; cv=none; b=nqiRJ3JUbuvP+E4+bPmlVlZUVnfyaKWTXhX4kx1DlTEsVFzz/pb8/5oondRWl8VKhZqj01uILuZAPGw0SOwmlKOeA5HvuFprBU8QHlyXpTa/hDU7JaLtuDe1HQI+dHawnYT8JMWYXgV44Z0DwZkIGcTVazdBhfqQu0blgaDBvzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774267937; c=relaxed/simple;
	bh=Nh9Bjd+PJSHu8BtXpEhNLe6aHcXpnQLoPBo7oXmqAJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UY0G7D1kv9cCWYqph4FM+tcCL6YidF06clvVDlLGZ5Cb5hUbokYCUmyQhdE1aQYh6aCcC4JP6+U6WvaFYVl1ih+QPq3NTNOgJItuqpYB0fD0ld9FBMzlE8DmqKYD/E62T3NEcfE/q2tMvPJCIt8x7ID3WhLXNWg7sdnxBSQywyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ffX911RfTzYQtvQ;
	Mon, 23 Mar 2026 20:12:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 201E440562;
	Mon, 23 Mar 2026 20:12:12 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBHStoZLsFpvcbBBw--.9330S3;
	Mon, 23 Mar 2026 20:12:10 +0800 (CST)
Message-ID: <2dacb018-c486-455c-843b-7cc2f366557c@huaweicloud.com>
Date: Mon, 23 Mar 2026 20:12:08 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: skip split extent recovery on corruption
To: hongao <hongao@uniontech.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
References: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHStoZLsFpvcbBBw--.9330S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4UtF17tr1DKFy7trWxtFb_yoW8KFWxpr
	4xCw15ur4kta48KFZrJF47Ar1a9w45tw4UGFyrGw13Ka4aqa4rWr17K3WjgF48ZFWkXa45
	ZFW0y34jga1DCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/23/2026 9:57 AM, hongao wrote:
> ext4_split_extent_at() retries after ext4_ext_insert_extent() fails by
> refinding the original extent and restoring its length. That recovery is
> only safe for transient resource failures such as -ENOSPC, -EDQUOT, and
> -ENOMEM.
> 
> When ext4_ext_insert_extent() fails because the extent tree is already
> corrupted, ext4_find_extent() can return a leaf path without p_ext.
> ext4_split_extent_at() then dereferences path[depth].p_ext while trying to
> fix up the original extent length, causing a NULL pointer dereference while
> handling a pre-existing filesystem corruption.
> 
> Do not enter the recovery path for corruption errors, and validate p_ext
> after refinding the extent before touching it. This keeps the recovery path
> limited to cases it can actually repair and turns the syzbot-triggered crash
> into a proper corruption report.
> 
> Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
> Reported-by: syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1ffa5d865557e51cb604
> Signed-off-by: hongao <hongao@uniontech.com>

Thank you for the patch, this is a nice catch. This overall looks good
to me besides one minor suggestion below.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ae3804f36535..aba9947fd151 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3239,6 +3239,9 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
>  
>  	insert_err = PTR_ERR(path);
>  	err = 0;
> +	if (insert_err != -ENOSPC && insert_err != -EDQUOT &&
> +	    insert_err != -ENOMEM)
> +		goto out_path;
>  
>  	/*
>  	 * Get a new path to try to zeroout or fix the extent length.
> @@ -3261,6 +3264,13 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
>  
>  	depth = ext_depth(inode);
>  	ex = path[depth].p_ext;
> +	if (!ex) {
> +		EXT4_ERROR_INODE(inode,
> +				 "bad extent address lblock: %lu, depth: %d pblock %lld",
> +				 (unsigned long)ee_block, depth, path[depth].p_block);
> +		err = -EFSCORRUPTED;
> +		goto out;
> +	}

Should we move the entire code snippet before the previous
ext4_ext_get_access() call? Although this is not closely related to the
current patch.

>  
>  fix_extent_len:
>  	ex->ee_len = orig_ex.ee_len;

