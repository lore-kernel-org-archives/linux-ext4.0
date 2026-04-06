Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191673845C8;
	Mon,  6 Apr 2026 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775486359; cv=none; b=F+BtEv/ELW7II9Mf7mSY26V6cVdfaLOFY3dqYWMqQpwh9KnAi2nRxCiGCOkIJdAfndAp/nzfYm9jsY7lc6rB8m0d6xDa6gG5DKY6UV18eStHWwXuSbNiCo+X4BsjwM/Qrb4XTTX8Sr41ZUzV289KbzUKAqiYK7dOleyBcalRCqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775486359; c=relaxed/simple;
	bh=dxZS07APXgt/dmN6zJ9TWXeU50NMovg93IUKFknmhvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QVvSPFDHMDzoKJPQlJiKUW1WsprAI8HRtl8+uc6RzG/exCDpTQrx8Gs2S5r6JqM9WVez2Nv+aQZZCXOTxJj7Zf02LWhLaS/scBzCOzW5FuWg4Z8LM6/Qnbuq6yY5Egb95vhGIIBOBKWUGtVOP6bdbitxRmkACpWEaBU3ayRMdnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=G084E1Qj; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="G084E1Qj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775486345; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D/rWtsmoe7dbMfLCdG9NTFNTxZ8ltntqEvtD01Di4K0=;
	b=G084E1QjPe3qFcvetDGTtSBYULO5UHufPO4OWlsjsrftDHkQ2/xDwrw8fZZvuhY1w7hqXWbG38y8lFS0dOB0NUC2efLttT4VQZ6TDPZLgm5OvaTkNnlaoW9qgfoa9k/Uwa1F+o7tCM6au5s/E0CAkRO1sIBG6VmrEIoS4OAK8jY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0WsweH_1775486331;
Received: from 30.42.44.119(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X0WsweH_1775486331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Apr 2026 22:39:04 +0800
Message-ID: <b47e31fa-35f5-4abd-beda-f1061d8a05e0@linux.alibaba.com>
Date: Mon, 6 Apr 2026 22:38:42 +0800
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
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 bhupesh@igalia.com, Sohei Koyama <skoyama@ddn.com>,
 Andreas Dilger <adilger@dilger.ca>, stable@vger.kernel.org
References: <20260406074830.8480-1-skoyama@ddn.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260406074830.8480-1-skoyama@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2026/4/6 15:48, skoyama.kernel@gmail.com wrote:
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

Looks good, feel free to add:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

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

