Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB0923EAB2;
	Wed, 11 Mar 2026 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773192151; cv=none; b=X8P6yLskjz24V2yMWYFxkKGW8taGYX8rEMNeGTx5WUZeKsqcuT1Ed35GxsE44ynczBHk6UEOsX+/Y6UYApIMHQuykQfDAj768AZ+Qfl6gNRMSxMYKa6dvt753+aatoeynRI6OiYDo/AKWkXtgWPnByIbbW1iI+1ULsE3FoOTxOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773192151; c=relaxed/simple;
	bh=2QCHHzVnyd+fsHp24NnIBOBWvoms4kCv2YKHJhEhzC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6S5oscXjplVD4GCofO61jdPKTMf7ueBa3K5BXNC5vTEbv8RrGo0IOWlkCVrgAeIPeB6sw4co5PjzKy6KrGO1xtVcLHngub0xiS3Wz1K+AFY+cLnap3/VgsHDzMT2ghH6IWkUn6aSxOmdad+iw1ct7/deJ5SwehqwdbOL8PfXK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVtJf1n9hzKHMkd;
	Wed, 11 Mar 2026 09:22:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5730740575;
	Wed, 11 Mar 2026 09:22:26 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgAXG9vQw7BpWzDaAQ--.37808S3;
	Wed, 11 Mar 2026 09:22:26 +0800 (CST)
Message-ID: <2112dc6d-dd1a-45cc-adf6-d9dad31f9597@huaweicloud.com>
Date: Wed, 11 Mar 2026 09:22:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: gracefully abort on checkpointing state corruptions
To: Milos Nikic <nikic.milos@gmail.com>, jack@suse.cz
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260309230838.422074-1-nikic.milos@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260309230838.422074-1-nikic.milos@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAXG9vQw7BpWzDaAQ--.37808S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww4fWrykAr1xtrWUJry8Grg_yoW8try5p3
	sYk34YyrWv9FyIyF1Sqa1UJFWxua10vF1UKrZIk3WvyayftrnxKr18GryDZr1jk393uw1F
	qFy5CFy3uayjya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjVbkUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/10/2026 7:08 AM, Milos Nikic wrote:
> This patch targets two internal state machine invariants in checkpoint.c
> residing inside functions that natively return integer error codes.
> 
> - In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
> corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
> and a graceful journal abort, returning -EUCLEAN.
> 
> - In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
> an unexpected buffer_jwrite state. If the warning triggers, we
> explicitly drop the just-taken get_bh() reference and call __flush_batch()
> to safely clean up any previously queued buffers in the j_chkpt_bhs array,
> preventing a memory leak before returning -EUCLEAN.
> 
> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>

Thank you for the patch. Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/jbd2/checkpoint.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index de89c5bef607..cdfbfd27afae 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -267,7 +267,17 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  			 */
>  			BUFFER_TRACE(bh, "queue");
>  			get_bh(bh);
> -			J_ASSERT_BH(bh, !buffer_jwrite(bh));
> +			if (WARN_ON_ONCE(buffer_jwrite(bh))) {
> +				put_bh(bh); /* drop the ref we just took */
> +				spin_unlock(&journal->j_list_lock);
> +				jbd2_journal_abort(journal, -EUCLEAN);
> +
> +				/* Clean up any previously batched buffers */
> +				if (batch_count)
> +					__flush_batch(journal, &batch_count);
> +
> +				return -EUCLEAN;
> +			}
>  			journal->j_chkpt_bhs[batch_count++] = bh;
>  			transaction->t_chp_stats.cs_written++;
>  			transaction->t_checkpoint_list = jh->b_cpnext;
> @@ -325,7 +335,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>  
>  	if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
>  		return 1;
> -	J_ASSERT(blocknr != 0);
> +	if (WARN_ON_ONCE(blocknr == 0)) {
> +		jbd2_journal_abort(journal, -EUCLEAN);
> +		return -EUCLEAN;
> +	}
>  
>  	/*
>  	 * We need to make sure that any blocks that were recently written out

