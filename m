Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226D81E5702;
	Fri, 29 May 2026 06:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780036431; cv=none; b=I5VDV6g+iOoOU4QePVlHVbnEwQ2P06X3BpOZAbaK+I49KwB0OOcwNL4/Sidmb5gFtUxqRhoriYupTCa2B46H1meCBt5IBwQo57Q1BUVF/3NtaOjSJ0gvrphzNdSH32fJuYn7sHvuUVcih1POliDU3pa5o3ANUdDGJO1InkSY5s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780036431; c=relaxed/simple;
	bh=7zdCfLBxaaNiRWcCsXYwBa94J652Pv9n4E1uUGz3YBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rznO+jJ4HVf+3YGZitiIWb0ZHQ+rgiQjbt9TIptGAKf96P5vHXBYHSUMEocO88B5xzcyJv3pZpUod7eZAhmxjwoC6KLtJl0TdgZfkoa9IrDeIWovBUT/Msg7YHiaUa1DE15HzGziAXtaPktSGeaftJ4bdMNcsZ+4J106MvGZ9R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qVGOqvvL; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qVGOqvvL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780036419; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hBAxosNt11IdMQ4a4MtKmhPG8HP39YP60rQgDXB/098=;
	b=qVGOqvvLKxl7IsRw4563cfp+ahruw24F9QlgsPIlFQWWfPCmIa8IZV1QNWbhlsiN3CM7VXbKElH8Vb9GF2L/7Nu7bL4XhyFu0ydL5lCuHumfNUX85cWBtlzdcEpX6gOg10JZsQsQc8EVRFfaFq2JqzZ+XAz6OTo3ncQC45rF7AQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X3oSFdN_1780036418;
Received: from 30.221.147.25(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X3oSFdN_1780036418 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 14:33:38 +0800
Message-ID: <72a2c70c-8611-4d42-842c-3ad51f5bf739@linux.alibaba.com>
Date: Fri, 29 May 2026 14:33:36 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Remove mention of PageWriteback
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260526190805.341676-1-willy@infradead.org>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260526190805.341676-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/5/27 03:08, Matthew Wilcox (Oracle) wrote:
> Update a comment to refer to the concept of writeback instead of the
> (now obsolete) detail of how it's implemented.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/page-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index dc82e7b57e75..bc674aa4a656 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -168,7 +168,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
>   * written. On IO failure, check if journal abort is needed. Note that
>   * we are protected from truncate touching same part of extent tree by the
>   * fact that truncate code waits for all DIO to finish (thus exclusion from
> - * direct IO is achieved) and also waits for PageWriteback bits. Thus we
> + * direct IO is achieved) and also waits for writeback to complete. Thus we
>   * cannot get to ext4_ext_truncate() before all IOs overlapping that range are
>   * completed (happens from ext4_free_ioend()).
>   */


