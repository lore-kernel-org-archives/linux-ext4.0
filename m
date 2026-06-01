Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4A536B05E;
	Mon,  1 Jun 2026 11:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780313865; cv=none; b=TkbTEy1PYhUZwIYOw/RvdtO7axcTK8aKSyvAAAixPXosJwcs5fLhbga0ddVcLsG9BePCbUmyCD1Fx9qzzWfHdBOz7Sya8ErrbHMcbSeA5WzYc9jsfk+DgjWImp+8GCxyZqBhU4sjzyfZhsqX5atA9SY4xIP0h5D4CzV529MfSe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780313865; c=relaxed/simple;
	bh=Z0R+2NN8+w+A3W++ii5o/BymVepw4G2p1ksrhljVooo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ekQfqJPgKt2uUMKeFRpW/8ck+wQuRYwFkgPSOcaklHJvhkjQMzrbh8FepgkMjL216rVUknEuJQmuVAK1XDCDwMIYgX1o9hYBuUmeSigz2Lw8+9AVoDRqpYdLnjlpDZFdHsshjZjf5bDSzou+HLaY9J9EPaTNZwuCuIV7KhTFDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Nb3kXXzP; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Nb3kXXzP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780313859; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EtTEpLU1YJOiARBPXy6/lFGdu8Wz9lFX0l1pyL2a6fc=;
	b=Nb3kXXzPLY+l7jDVCXcvkGVRkMxIcGAV7Z88js14TFvQhvj/IHuNSWmpkOVuaRLlULpP6r2mUTIXoupqyZ0HA9sM1hDNUFizzdzr74QYrLKe4/sSi1cS+Jene6d/ciaCz01kd2A2CB+eevyDXKUFvyqKF2NgGb5qjV4Er3u4z5E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X4-gxeX_1780313858;
Received: from 30.221.147.139(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4-gxeX_1780313858 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 19:37:39 +0800
Message-ID: <3b4f8d56-8b7f-40cc-a555-db414473dcd5@linux.alibaba.com>
Date: Mon, 1 Jun 2026 19:37:38 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] jbd2: fix integer underflow in
 jbd2_journal_initialize_fast_commit()
To: Junrui Luo <moonafterrain@outlook.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yuhao Jiang <danisjiang@gmail.com>, stable@vger.kernel.org
References: <SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/5/13 17:28, Junrui Luo wrote:
> jbd2_journal_initialize_fast_commit() validates journal capacity by
> checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
> Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
> j_last the subtraction wraps to a large value, bypassing the bounds
> check.
>
> The resulting underflow corrupts j_last, j_fc_first, and j_free,
> leading to journal abort.
>
> Fix by checking num_fc_blks against j_last before the subtraction,
> returning -EFSCORRUPTED.
>
> Fixes: 6866d7b3f2bb ("ext4 / jbd2: add fast commit initialization")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

The Fixes tag is not quite accurate, it should be:

Fixes: e029c5f27987 ("ext4: make num of fast commit blocks configurable")

Otherwise looks good to me:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

(P.S. Resend due to malformed email. Sorry for the noise.)

> ---
> Changes in v2:
> - Return -EFSCORRUPTED instead of -ENOSPC
> - Link to v1: https://lore.kernel.org/all/SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com/
> ---
>  fs/jbd2/journal.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index cb2c529a8f1b..0bb97459fbf0 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2263,6 +2263,8 @@ jbd2_journal_initialize_fast_commit(journal_t *journal)
>  	unsigned long long num_fc_blks;
>  
>  	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
> +	if (num_fc_blks > journal->j_last)
> +		return -EFSCORRUPTED;
>  	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
>  		return -ENOSPC;
>  
>
> ---
> base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
> change-id: 20260513-fixes-e6dcda3273d4
>
> Best regards,


