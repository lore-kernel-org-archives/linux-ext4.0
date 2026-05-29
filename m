Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B696237DEA3;
	Fri, 29 May 2026 07:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040239; cv=none; b=CIAdMWn+ySUQSQ6cXPamtbNDUSIocJj3R6fiLbxgQN9fB2hQzNpqWVwI/wZL+IsqReBoatHRqlumyWqhkTnhVWmiWjGbtGhheVVUOJiqcA0c0ColdUETNOR5R2Fk6SimEpjdB12rwsrpjSORW1g1YFjItL/4smR4eon4yYo/k2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040239; c=relaxed/simple;
	bh=lV1MoXPwGp0Fg2IvzbXYC57iOoYXXOwE4mrZlGEZkMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZ3gZWDIxS7btmv0pkfPgEsNjP5Xgn5Fqg3ZgOYOoQlIglxb6wSMyZo2NAKJ4xmKm4HwqG7LDaOot6g1Ahkmn9oIj1iREzmBWMtrgXX2yU9+Z4BQGyLCTThNhuPqrz57bTg5kiRfkUw9Z9ug1myXQ+eO/4LJ3+732/17J9O0vY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=a8CcPmKy; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="a8CcPmKy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780040234; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EgTOkm1UqhW5Ae3I6QYG/p7Y8M7k/O2f1oDUZFi3ZAE=;
	b=a8CcPmKy/amyN0QIaJkq69GQuxcNH4WHGc6uSfDUfcp+9QWXvyUhk0uL523eUGa8yFX98qg8Gua5iGAygCUBpCw46THXiCZKHyXK/eica0abCKe/3MdOyyWDrbzZzIe+Dn5wurQi7aQmn2MyVMVEbqT39vQaM9E3+N2zBAHrq1c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X3oeqif_1780040231;
Received: from 30.221.147.25(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X3oeqif_1780040231 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 15:37:12 +0800
Message-ID: <419df758-a936-47f5-a278-b005f8a0d0a2@linux.alibaba.com>
Date: Fri, 29 May 2026 15:37:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix ERR_PTR(0) in ext4_mkdir()
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhongling0719@126.com, neil@brown.name, brauner@kernel.org,
 jlayton@kernel.org
References: <20260520074634.53656-1-zenghongling@kylinos.cn>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260520074634.53656-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/5/20 15:46, Hongling Zeng wrote:
> When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
> It should return NULL instead for success and ERR_PTR() only with
> negative error codes for failure.
>
> Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

Looks good.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4a47fbd8dd30..8cadaeb15b2b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3054,7 +3054,7 @@ static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
>  out_retry:
>  	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
>  		goto retry;
> -	return ERR_PTR(err);
> +	return err ? ERR_PTR(err) : NULL;
>  }
>  
>  /*


