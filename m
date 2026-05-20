Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F389C3B6BEE;
	Wed, 20 May 2026 09:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268807; cv=none; b=NUn7s10mvjwpNpf52jjXYv0Wd8M5Ceu0CssTvwluQTR37tom9/MR6li3apAXfqYIoj40AJ8fqMMlkyViQ3ze9Lj02PYMvLSHC5MwbxeBx26r6VdEgAdzy8Vj/iVfHfIs61ps/5qLxUeCG9I4F4g/UX6VhhDIXdAnalGzM1rzE5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268807; c=relaxed/simple;
	bh=y4N18vQGyxtjlouwxXoCmJ2x4jHmORIT24C31z0ZghY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=imKzrk/nLbwwRnMK0vWT/aTr394XwA2veB80Jrss97ZAhzp3wi3SafR0ZyOjIEhpenKtwHtfXB/nis7BxtajI0K1qjKYYdG96dpOQEVN0sGRvXnKWjvo51fKzrZ7sbpHXlSHQykScn1BzIfdjebZAFnRS/giEyEuMACMPm11dxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gL5Zk6w72zYQvB4;
	Wed, 20 May 2026 17:19:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1F6C240562;
	Wed, 20 May 2026 17:19:55 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAX31q5fA1qt_rmCw--.4036S3;
	Wed, 20 May 2026 17:19:54 +0800 (CST)
Message-ID: <889382e7-69cc-4797-bf9a-3eada00bf1b3@huaweicloud.com>
Date: Wed, 20 May 2026 17:19:52 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix ERR_PTR(0) in ext4_mkdir()
To: Hongling Zeng <zenghongling@kylinos.cn>, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, neil@brown.name,
 brauner@kernel.org, jlayton@kernel.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhongling0719@126.com
References: <20260520074634.53656-1-zenghongling@kylinos.cn>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260520074634.53656-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAX31q5fA1qt_rmCw--.4036S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtFWUKFW3Zry3WrykWr4rXwb_yoWDZrc_G3
	yjvws7WFZYqr4IkayxCryayrWaqFZ5GF4rXFZ5t3sFqa98JFZ8Cas8Crn2yFWkWr18Kr9r
	Cr1kXrySkas2gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/20/2026 3:46 PM, Hongling Zeng wrote:
> When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
> It should return NULL instead for success and ERR_PTR() only with
> negative error codes for failure.

This point is indeed very easy to overlook. However, why not modify
other file systems as well? Commit 88d5baf69082 made changes not only
to ext4.

Thanks,
Yi.

> 
> Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
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

