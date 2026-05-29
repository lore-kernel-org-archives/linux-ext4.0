Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E59324B33;
	Fri, 29 May 2026 07:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040698; cv=none; b=nrhyG68B2gaNgc8wqIw9N4g6CYaEzCN5rr5vu5prPwnqsS7rb+RMhyq423eWCon+WH+uASakyPGjIFPU5pKA9TUfxAmeCuZPqbGgWPoFIBjIW8KJgH/Kj6nckSiGIPjeuZPbvPcI3CHjbVJolCkmS3ktBW3AwZfoBS08QAONo6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040698; c=relaxed/simple;
	bh=cB27Mh1HUTnXGRSxotjkwXbGuqYrHxKH+HLY78NY50c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e34FKtauvHbvT5Sj5LDImP6+Vneyd2EC660iZ0wQECMRIK/IWbLbBhdSTHJlN0EcBix1gozPBL/lmA9EGrlXdqqJJr40WPi6wwID8GDVIOjq1x9BuKCAbsCyJmMNr/LRHaWcgfDCakqcb8sDKkKlRj7MjnxzD1tQmagbxt6ddWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WB2mtnwz; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WB2mtnwz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780040693; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=loLxr9AEwXFSxl7fMiJvMlHp6IUysF8oNr6OTh0HXZM=;
	b=WB2mtnwzKCoE1NBSp9gpx/+fYD/dZFUu3E5sWh7/nHgRFw6VsdxYg6NoxmntI+WBzAwTGjZaKpVLGamB+qDKCNhQDiYK4GS9UH7ZcXXs0xGU0O6EWMJIE+szbEjTAscHvrqRgq3PB0UvBYM6YvN/HskAGjRhPXdnJGAJFiTFm/M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X3ongqz_1780040691;
Received: from 30.221.147.25(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X3ongqz_1780040691 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 15:44:52 +0800
Message-ID: <a54198a6-06ac-48fb-a91f-6e69fcf51fec@linux.alibaba.com>
Date: Fri, 29 May 2026 15:44:51 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: update outdated comment for
 jbd2_journal_try_to_free_buffers()
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260522030540.3896201-1-yi.zhang@huaweicloud.com>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260522030540.3896201-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/5/22 11:05, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> jbd2_journal_try_to_free_buffers() currently only tries to remove
> checkpointed data buffers from the checkpoint list for data=journal
> mode, and bails out if any buffer is still attached to a transaction.
> For data=ordered and writeback modes, data buffers never have
> journal_heads, so the function degenerates to a plain
> try_to_free_buffers() call.
>
> Besides, The release of metadata buffers has been delegated to the jbd2
> journal shrinker in commit 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to
> release checkpointed buffers"). jbd2_journal_try_to_free_buffers() is
> not used for handling metadata buffers now.
>
> However, the comment above the function still references
> jbd2_journal_dirty_data(), __jbd2_journal_unfile_buffer(), t_datalist,
> BKL, and BUF_CLEAN, all of which were removed in commit 87c89c232c8f
> ("jbd2: Remove data=ordered mode support using jbd buffer heads").
>
> Replace it with a description of what the function actually does now.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good!

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/jbd2/transaction.c | 39 ++++++++++++---------------------------
>  1 file changed, 12 insertions(+), 27 deletions(-)
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bbd10..239bcf88ed1c 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -2139,38 +2139,23 @@ static void __jbd2_journal_unfile_buffer(struct journal_head *jh)
>  }
>  
>  /**
> - * jbd2_journal_try_to_free_buffers() - try to free page buffers.
> + * jbd2_journal_try_to_free_buffers() - try to free folio buffers.
>   * @journal: journal for operation
>   * @folio: Folio to detach data from.
>   *
> - * For all the buffers on this page,
> - * if they are fully written out ordered data, move them onto BUF_CLEAN
> - * so try_to_free_buffers() can reap them.
> + * For each buffer_head on @folio, if the buffer has a journal_head but
> + * is not attached to a running or committing transaction, try to remove
> + * it from the checkpoint list.  This is needed for data=journal mode
> + * where data buffers are journaled: once they are checkpointed, the
> + * journal_head can be detached and the buffer freed.  If any buffer is
> + * still attached to a transaction, the folio cannot be released and we
> + * bail out.  Otherwise we call try_to_free_buffers() to detach all
> + * buffer_heads from the folio.
>   *
> - * This function returns non-zero if we wish try_to_free_buffers()
> - * to be called. We do this if the page is releasable by try_to_free_buffers().
> - * We also do it if the page has locked or dirty buffers and the caller wants
> - * us to perform sync or async writeout.
> + * For data=ordered and writeback modes, data buffers never have
> + * journal_heads, so this degenerates to a plain try_to_free_buffers().
>   *
> - * This complicates JBD locking somewhat.  We aren't protected by the
> - * BKL here.  We wish to remove the buffer from its committing or
> - * running transaction's ->t_datalist via __jbd2_journal_unfile_buffer.
> - *
> - * This may *change* the value of transaction_t->t_datalist, so anyone
> - * who looks at t_datalist needs to lock against this function.
> - *
> - * Even worse, someone may be doing a jbd2_journal_dirty_data on this
> - * buffer.  So we need to lock against that.  jbd2_journal_dirty_data()
> - * will come out of the lock with the buffer dirty, which makes it
> - * ineligible for release here.
> - *
> - * Who else is affected by this?  hmm...  Really the only contender
> - * is do_get_write_access() - it could be looking at the buffer while
> - * journal_try_to_free_buffer() is changing its state.  But that
> - * cannot happen because we never reallocate freed data as metadata
> - * while the data is part of a transaction.  Yes?
> - *
> - * Return false on failure, true on success
> + * Return: true if the folio's buffers were freed, false otherwise
>   */
>  bool jbd2_journal_try_to_free_buffers(journal_t *journal, struct folio *folio)
>  {


