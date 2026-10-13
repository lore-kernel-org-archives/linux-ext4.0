Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A0516149;
	Tue, 13 Oct 2026 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904649; cv=none; b=fCE8iajccuNfBwBJXtpl66LgYAVWZEb83eRkQrT8aN9CEKVyiyNvAr4FtsZdqCCl9Cu76SKdQhY+z/8z0x6BE6tnUFXRnTBCPN3bMR5Kav25xfzis/Ugv6zOijmTqor99F+3NxCQBaQPejwki+tOtNGEv2jXrmn+IV3/CyslKNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904649; c=relaxed/simple;
	bh=1PKx6K5kS9ixz7lpt3FtwaVW7RHV/EVckavCzYOad7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWm93utgZbZTleixWR4WEGn13UXlkwCEe+qUVIZsgx99g7M2Vu21nomtRJGceDbzGGWJNqeRE+m2Gn6tUjtx1Eel2/I0pNemEOjzuTuPUdaLayZcPXQ2HG6J1Z90jk9Mdvh9+N52Fu2/Z+hCd0raaIigygxkD5V6aeq1xFUsvmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=f19i+ryA; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="f19i+ryA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791904635; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kwGgW9ZfnhD2utrf0TJhdswRz4p0Pk722fsBy/r92CQ=;
	b=f19i+ryAvrbLYn+a9nmnjF/RRPiBojRjq9bb7dzon7pqhUv0OfLNpRL7HjyIoz8MDoBUlB8LxOJM1khkUOsNXzdpj4EoZ93xSGeM3zp41G0MQYQ6ExBijS05peFCxgQDC42X7aHOf0QpZ9hZNMJmM8myeArHFn5VRN0sL48hHBw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCm3MTA_1791904632;
Received: from 30.180.226.69(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCm3MTA_1791904632 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 23:17:13 +0800
Message-ID: <16cec777-2582-4080-a2c8-903b652db939@linux.alibaba.com>
Date: Tue, 13 Oct 2026 23:17:12 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: complete dropbehind writeback in task context
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Taotao Chen <chentaotao@didiglobal.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
References: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/13 02:04, Tal Zussman wrote:
> ext4_end_bio() ends writeback directly from bio completion, which
> usually runs in interrupt context, unless the io_end has unwritten
> extents to convert and is completed from ext4's workqueue.
> folio_end_dropbehind() only invalidates the folios of an RWF_DONTCACHE
> write when it runs in task context, and silently skips them otherwise.
> So on ext4, dontcache writes that overwrite blocks that are already
> written, or that allocate blocks without unwritten extents, leave their
> folios in the page cache. Dropping them was best effort so far, as there
> was no way to get task context from bio completion.
>
> Use the task-context bio completion infrastructure instead: set
> BIO_COMPLETE_IN_TASK on bios that carry dropbehind folios in
> io_submit_add_bh(), so that bio_endio() runs their completion from a
> worker. ext4's iomap buffered I/O path already gets this from iomap, so
> only the buffer_head based writeback is affected. Skip the flag when the
> io_end already has unwritten extents, as ext4 then defers the completion
> itself. A later extent can still make the io_end unwritten after an
> earlier bio was built. That bio's completion is then deferred twice,
> which is not optimal, but harmless.
>
> This changes behavior only for bios that carry dropbehind folios: their
> completion now runs from a worker instead of in interrupt context.
>
> On the unpatched kernel a dontcache overwrite of already-written blocks,
> or a dontcache write into a new file on a dioread_lock mount, leaves
> every folio in the page cache (16384/16384 for a 64M file). With the
> patch, none remain in the page cache. A dontcache write into a new file
> with unwritten extents already drops its folios on both kernels, as
> expected, and a plain write keeps them.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

We should add a Fixes tag:

Fixes: ae21c0c0ac56 ("ext4: support uncached buffered I/O")

Otherwise looks good to me:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/page-io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 734d856a6d47..e556598ce9e1 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -458,6 +458,16 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
>  		io_submit_init_bio(io, inode, folio, bh);
>  	if (!bio_add_folio(io->io_bio, folio, bh->b_size, bh_offset(bh)))
>  		goto submit_and_retry;
> +
> +	/*
> +	 * Dropbehind folios can only be invalidated in task context. An
> +	 * io_end with unwritten extents is completed from ext4's workqueue
> +	 * anyway, so only ask the block layer to defer the others.
> +	 */
> +	if (folio_test_dropbehind(folio) &&
> +	    !(io->io_end->flag & EXT4_IO_END_UNWRITTEN))
> +		bio_set_flag(io->io_bio, BIO_COMPLETE_IN_TASK);
> +
>  	wbc_account_cgroup_owner(io->io_wbc, folio, bh->b_size);
>  	io->io_next_block++;
>  }
>
> ---
> base-commit: 35aefefd7aba0801bab635b11943f932626be3b2
> change-id: 20260924-ext4-dontcache-complete-in-task-2340ed5f3114
>
> Best regards,
> --  
> Tal Zussman <tz2294@columbia.edu>


