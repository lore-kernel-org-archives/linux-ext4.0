Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38461A9FBA;
	Tue,  7 Apr 2026 01:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775524436; cv=none; b=fjWEjwJiiF5lEZrOo7IfUH/r0DApkXDo7W9Qb0iPdcQVU9DEY5veshZMfGel0oGtvunK2OgwOepn3iJPhG6+mg6OCC+hq9ztyJQzU+Y/5I8VnmzN08oVNb6R7sc8O/Lmt3wfVKRQHQvko/u1ozQrh5HpzKyafxGOulzJEv1iQj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775524436; c=relaxed/simple;
	bh=vvBe9Muv2c5jeAUg6u5C70ti/Hh5gSJXqOytBfqGUYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sU5ylXUjrgl7HkNEv1fPmPzbIZaQlDf07Vc5py+5xiy+M3RxiJAX46GMRoh8WWWSuV28X7z1gb97dc8p3EVjvYtUJGEwMdAXIjCrGjdD7ADaBqmKiqxBiyYiupuv1S4DxnOGsMFYebZhHEU+vmPjLhgmhapZSEpEnhga/u0TPRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fqSqK62hNzKHML7;
	Tue,  7 Apr 2026 09:12:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2E06140575;
	Tue,  7 Apr 2026 09:13:44 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgCHitpFWtRpbzmeDg--.48272S3;
	Tue, 07 Apr 2026 09:13:43 +0800 (CST)
Message-ID: <a8c93ed1-9bbf-43bf-9255-fafb72bddda8@huaweicloud.com>
Date: Tue, 7 Apr 2026 09:13:41 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: fix missing brelse() in
 ext4_xattr_inode_dec_ref_all()
To: skoyama.kernel@gmail.com, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 bhupesh@igalia.com, Sohei Koyama <skoyama@ddn.com>,
 Andreas Dilger <adilger@dilger.ca>, stable@vger.kernel.org
References: <20260406074830.8480-1-skoyama@ddn.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260406074830.8480-1-skoyama@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCHitpFWtRpbzmeDg--.48272S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr4DCr1kCrW7XrW7CFy5CFg_yoW8GF45pw
	43G3W8Cr48XFyjkayakF1UuanIga47G3yUurW2k34Ykr93X3s3tFy7t3WrCa15ur4kWa12
	qF9Fk3Wj93ZxAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 4/6/2026 3:48 PM, skoyama.kernel@gmail.com wrote:
> From: Sohei Koyama <skoyama@ddn.com>
> 
> The commit c8e008b60492 ("ext4: ignore xattrs past end")
> introduced a refcount leak in when block_csum is false.
> 
> ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
> get iloc.bh, but never releases it with brelse().
> 
> Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
> Signed-off-by: Sohei Koyama <skoyama@ddn.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: stable@vger.kernel.org

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/xattr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 7bf9ba19a89d..19c72e38fb82 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1165,7 +1165,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  {
>  	struct inode *ea_inode;
>  	struct ext4_xattr_entry *entry;
> -	struct ext4_iloc iloc;
> +	struct ext4_iloc iloc = { .bh = NULL };
>  	bool dirty = false;
>  	unsigned int ea_ino;
>  	int err;
> @@ -1260,6 +1260,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>  			ext4_warning_inode(parent,
>  					   "handle dirty metadata err=%d", err);
>  	}
> +
> +	brelse(iloc.bh);
>  }
>  
>  /*

