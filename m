Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B9275114;
	Wed, 11 Mar 2026 03:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773199115; cv=none; b=H09L53PB7qpNm2YNZYKfdSivjQrRoF1a8+tFd2fFclzqOgmQ687yNtjQMxuPKen04fPLNEtaklsqgTtdpAW7uUhWHwac1Tt6yQywFn0YOUQ8KDK/9LzsBRBD+f78yc16+IveaLUgj2REts1zE/zPTw3rvBAU5DP6mO2lBExtDUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773199115; c=relaxed/simple;
	bh=mAZ59s4J5m1GtOBCeKgZrr151ucMUEA5qg7iYX5o3bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hfu3xsm18q2mI0wTOCzMTtl4fxREtPVmv+2OiOUfq8ARW3+Z1pEwmySizyDIU7gYWY5M3N8QJQQvqEWB/TP6EhupShXh0YPrpsfmWussbl9iyMlv+XjmEJto6abG7Lo8vpUY4iZBUitXLkdtCFPzEcldrflFWBn8U1t0g923nls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=isY5tDpu; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="isY5tDpu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773199104; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WvT7Kh2pErGQr3gB/l5Jtliw9k5lzkhYZsTPbzW/x14=;
	b=isY5tDpu4yAoV9bP4IW8mJzUFgHAWfezacsr6IAbK8HWjIa5y9a/btpF0VLYPGbt5Kz11mZL7a/WBFWnpWgyMXQ8xpeY7FByd8ts8PGrTH9JONAAL4Qv1bX4FZOxymdR7bHcVpZr39VhLdD5/eAqqhWYiFXNDSCkCzEVl1hRnns=
Received: from 30.221.147.134(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X-iHY0a_1773199102 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 11:18:23 +0800
Message-ID: <f4ed0c9b-9081-4612-9811-dc7be8f9f5e1@linux.alibaba.com>
Date: Wed, 11 Mar 2026 11:18:22 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: gracefully abort on checkpointing state corruptions
To: Milos Nikic <nikic.milos@gmail.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, libaokun@linux.alibaba.com
References: <20260309230838.422074-1-nikic.milos@gmail.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260309230838.422074-1-nikic.milos@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 3/10/26 7:08 AM, Milos Nikic wrote:
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

Looks good to me, just two minor nits:

 * Replacing EUCLEAN with EFSCORRUPTED would make more sense.
 * Putting jbd2_journal_abort after __flush_batch reads more naturally.

Otherwise, feel free to add:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

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
