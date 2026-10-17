Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EBB37DEBE
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2026 02:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792203594; cv=none; b=qvQe7U+kfZyBeNkT5awimc776CJ5+FxsKLLxLDAOPzcFMIdRXfM+32M5VGUrAirXEDWB6qYeFExiytivqqz/iBWps8fRQTAbGUzU5u4FJd8/qn8u79XkNKqBklhtZM8pQzqXd7fqnavOtVYSuBp0p5BWX8ddd11KB1MvIhgPJ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792203594; c=relaxed/simple;
	bh=5rRTjvVUCj1giTYCsBQ/YKcd/9d9HjEXgG9juU7sMfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dGDkd8ar6QkJNNlJJOs1j61c/T+WzL8SH2hRreduKBiIlJORG1Ct2ZVUE7GqOz7sluhNu1CBcYK4lwbJTLTHrl/POEc9DlOLV+xeHKTB0uGjEvlAzF98lmqL34Q2RpK7ZO5MKG9LpIwgz0bFDVcKMr9OB4AMJGgcY4MoW6HJgMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qZNiQ2vr; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZNiQ2vr"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35f1f76ea84so786574eec.1
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 19:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792203591; x=1792808391; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+kfzjr8MQEb3lKi5cTeDPkUvBSdgUV4zlTId0CwE3M=;
        b=qZNiQ2vrR8t1p1kDECcMcJ+4tgxT0xHqGWGnIkvfdJnmRdStPCy2f30zRNJhI6hpQn
         tVrB7pmcocSx6V8z0p2FgOWpDE+EhdzDOFlxZpESRsr6+4S5hIASg1BM70lbfvmW8S3G
         tX92JFpLaVwIwvIKBKMrF9jI5FO4kRhPAhCk7pgDe/Y4uSA33l1ulwF3qGtzwVVBux6G
         P2LcuWNFUIAaFJAis5qWu1OeyQ8cLWicwDfBCafuD4FljTEAujvXtbE/7kqkGnuIAzXu
         KAaZDWw+cZvBSMnayWw9ANvrZrPR6a30wVyClUXyohfyyDQ3jLl4oGzloS4scNhMVbgT
         QNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792203591; x=1792808391;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5+kfzjr8MQEb3lKi5cTeDPkUvBSdgUV4zlTId0CwE3M=;
        b=FYCJL36rjRrht+sOlrsixfMs88RVWLrBN66EkhE+FoJV6KqYAfGL58+YoSox/IlPSL
         MUWh5J8u6fKSWbsPXOubryGoLgFeA6hxAWtbrG6PODJSuC1vyCcBMdqDTsBnIopfg+vU
         ARiLMxAIuIM5VvbCjL1gCfN1hWAeYk0MBu0FqnLuyFYMQ0WqUPZvrpUvdLBcvKCsFedR
         Kze8je4/L+9mLUaTZCkMLVvx9aGhxRVsZOl66VcfvSzKR1Vx+8+NupzJJp22kZwXvnmz
         ntcMoEu7jveu0hlxfpPs9+fWR4/+hrZOHZD4wa+vo48myutR8NZCHogJNaClxl3uVtCA
         EQGw==
X-Forwarded-Encrypted: i=1; AKwUvBwhQoPrT+aKn4DDRGJFc5Ul5dUX8pRubaHCHgrxXWhFtes1bEddbH3OFn3YJzlMFwkQ0q1vv0Dw2Lax@vger.kernel.org
X-Gm-Message-State: AFq9FYLK4QBzV7l2jqDntONlYu1wS6N9eKNJIuckwODwWOUAjLe/0lTl
	5Xl9iLlQ7/d1kS+/1cu/F0BBgh8W/p93N9cECGbM2Ku52WQebBeqe5UXxdg39hRi
X-Gm-Gg: AYBFou01bZabuMpl5j56hIItMgzAtJPjm/kEoViJZLoRXFqNkxPt0VXsiV9km+hxFxG
	z/VUVhOYmFsJi6FhDiQ+mXCwVU1RDiI333Q1wYne1yY6aPC/lkwu6hpOSsLKpKI9PtqSqxGwzU0
	E1pByRYnwJA/IRkL3HVEk/bC8VGExHnxbJnSHacjYXlGR1Zs78zEisECKG9c9YFlKKv7taUHx2a
	znKeoYRqM645CWAi23P0Q0Q0w20Z12FA9essERAVMhSJCy/PVWI7y+EmIZJAkdZ8mO187Mhd5AM
	ZNQgvYoAUt5RklYRst8xw4xpb9maxSZkYoYklBxhHyMu4kwkUKJBOxeZABpLjOCssonGXyxm+X5
	glvBdAaxA59MJJHvt0IDzMo5ySefSh3SrzVr3bLdD+rPneox06/xp7nuHmdYIxDFAMFPl0OXIsJ
	raDM0sr9krO+JST/ZdOOesCmkNdKRuJ1kuSNHLoC7UI8x4p19giGarmmPDSkCPPAOiBOtIjFBGH
	MOwgEV0H88HpprjseY=
X-Received: by 2002:a05:7023:a47:10b0:14c:fb3f:bedb with SMTP id a92af1059eb24-185136cad08mr2162857c88.18.1792203591050;
        Fri, 16 Oct 2026 19:19:51 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-183190aa7bbsm9100489c88.5.2026.10.16.19.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 19:19:50 -0700 (PDT)
Message-ID: <743d1d96-40f9-4dac-839f-5d5269364b50@gmail.com>
Date: Sat, 17 Oct 2026 10:19:41 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix folio reference leak in
 mpage_submit_partial_folio()
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261016142524.655789-1-guolingxing@tju.edu.cn>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20261016142524.655789-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/2026 10:25 PM, guolingxing wrote:
> mpage_submit_partial_folio() obtains a folio reference with
> filemap_get_folio(). If the subsequent position check fails, it
> returns -EINVAL without dropping that reference.
> 
> Call folio_put() before returning from this error path. Leave the
> folio locked so that the caller can invalidate and unlock it through
> mpage_release_unused_pages().
> 
> Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents mapping loop")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Thank you for the fix, looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>   fs/ext4/inode.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03..7afba6298fa2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2412,8 +2412,14 @@ static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
>   	 */
>   	pos = ((loff_t)mpd->map.m_lblk) << inode->i_blkbits;
>   	if (WARN_ON_ONCE((folio_pos(folio) == pos) ||
> -			 !folio_contains(folio, pos >> PAGE_SHIFT)))
> +			 !folio_contains(folio, pos >> PAGE_SHIFT))) {
> +		/*
> +		 * Leave the folio locked so that the caller can invalidate
> +		 * and unlock it through mpage_release_unused_pages().
> +		 */
> +		folio_put(folio);
>   		return -EINVAL;
> +	}
>   
>   	mpage_submit_folio(mpd, folio);
>   	/*

