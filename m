Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A9D39B978;
	Tue, 12 May 2026 12:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778587751; cv=none; b=bzxONL1tBsHDxNpABs2VsA5yfD1JVlcNp4vbrgAYNjKZ8lI5gSjm1cbRfU4nQPQo0fWBWR0knypEPXaoUHRQbs5ahyMSBl1nVqC/zC/MP0HBRb12MPxVHzMT9Vmp/2cTUlU51zEC0+AF2W4R1qB+nhMU6fUR8jfbaj/HRxdZxIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778587751; c=relaxed/simple;
	bh=AXy2JS998/EMAZWvPM/ed4kfaEK5FvSs+9S3znbUw2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lxbdb8mSVJqrrFc0Ex7hBZf9ve54BjHlkIahmzv93cPKTOR1qDgFexkV63uvtVdVmrNJ2iWuzYLpfqDbJEQoelxjjX75wWkQRs1hoLNgDlhWvPcO7JKU10jK1lW2L0CGSNOiqgYXdcbZnSySmUm6uPO0KSyGIqrYQDhgybRd+Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gFFjm20yJzYQtFH;
	Tue, 12 May 2026 20:08:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 000564058C;
	Tue, 12 May 2026 20:08:58 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgCXX1tZGANqE9weCA--.59719S3;
	Tue, 12 May 2026 20:08:58 +0800 (CST)
Message-ID: <7cf5ea66-55e9-46ec-8f69-91e80d3c42b8@huaweicloud.com>
Date: Tue, 12 May 2026 20:08:56 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: fix integer underflow in
 jbd2_journal_initialize_fast_commit()
To: Junrui Luo <moonafterrain@outlook.com>, Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.com>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yuhao Jiang <danisjiang@gmail.com>, stable@vger.kernel.org
References: <SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXX1tZGANqE9weCA--.59719S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1DtFW5Cr1kAryfuFWUtwb_yoW8uryUpr
	Z7G34qkFWkZrW0yw17GrW8tFW0vFsak3yFgwnIkwn5K3yYgrnxK3ZFgrnxJ3WDAr4Fk34r
	tF1qya4kCw1UKaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/12/2026 3:49 PM, Junrui Luo wrote:
> jbd2_journal_initialize_fast_commit() validates journal capacity by
> checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
> Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
> j_last the subtraction wraps to a large value, bypassing the bounds
> check.

I'm wondering, how does the "num_fc_blks exceeds j_last" error occur?
Under normal circumstances, journal->j_last is initialized to
sb->s_maxlen, which is set to the total number of journal blocks (i.e.,
the sum of the normal journal area and the fast commit journal area)
during filesystem formatting by mkfs. Therefore, num_fc_blocks shoud
never exceed journal->j_last. Right?

Have you mounted a deliberately constructed corrupted file system? If
so, I'd prefer to return EFSCORRUPTED here.

Thanks,
Yi.

> 
> The resulting underflow corrupts j_last, j_fc_first, and j_free,
> leading to journal abort.
> 
> Fix by adding an overflow guard that checks num_fc_blks against j_last
> before performing the subtraction.
> 
> Fixes: 6866d7b3f2bb ("ext4 / jbd2: add fast commit initialization")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
> ---
>  fs/jbd2/journal.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index cb2c529a8f1b..a54146576c3f 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2263,7 +2263,8 @@ jbd2_journal_initialize_fast_commit(journal_t *journal)
>  	unsigned long long num_fc_blks;
>  
>  	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
> -	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
> +	if (num_fc_blks > journal->j_last ||
> +	    journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
>  		return -ENOSPC;
>  
>  	/* Are we called twice? */
> 
> ---
> base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
> change-id: 20260512-fixes-2ff4f9f7d064
> 
> Best regards,

