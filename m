Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941F9221D89;
	Thu, 26 Mar 2026 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774516163; cv=none; b=Es9kQmxB+Ul+FzDV80cd+JUR7vloBK9RsgH2rXSvx/3o26qwD8Mu7x2HkgBewLPe5wwX07JKZDTIcR7M86zJ77g0v5VZPY78qofEEdLVMYLtAyj7RmbZP8Yu9ScXjIhGwqnsVG/lJqI9jlvCwouHQyhxq9JbXB6hs6NGtGmufxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774516163; c=relaxed/simple;
	bh=tLY0ePJlKmZKLqmOL9WiC9ORTlmc/Y/m+2xJ8tQZ3xQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t9ZcH6GMa2sRrqTU3GrREz7AaRPTyaHOAup7lSliO8M6D0qh8jblJ8gInIxqRpi/0WqFsBFVd+aJDlgJwe8TxLtx/oDcmKZ3WNUlBtwJTsxup5QOZdryROjMvMqAfHrbT2TbHozgSGgi++0J/riAgArfiioAt8xqBNgLzKbjnFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fhHbH2s6tzKHMhW;
	Thu, 26 Mar 2026 16:52:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 61AEA40573;
	Thu, 26 Mar 2026 16:53:07 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBHStrv88RpqlIbCQ--.6951S3;
	Thu, 26 Mar 2026 16:53:05 +0800 (CST)
Message-ID: <4cb874b7-f5e3-4612-a2cd-c5e707c72985@huaweicloud.com>
Date: Thu, 26 Mar 2026 16:53:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/10] ext4: refactor partial block zero-out for iomap
 conversion
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260325072850.3997161-1-yi.zhang@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260325072850.3997161-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHStrv88RpqlIbCQ--.6951S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw47Jr4UAF1rZFyfGrWDCFg_yoW5Kw4DpF
	ya9w1Y9r4xG39F9an7CF48XF1a9wn3Gr4rGry3G34kZ3y5ZF1IkFs3Ka1F9FWj9rW3Ga40
	qF4UAa4UWFn8Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 3/25/2026 3:28 PM, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>

Sashiko found some real issues in patch 09 and 10, I will send v3 to fix them.

https://sashiko.dev/#/patchset/20260325072850.3997161-1-yi.zhang%40huaweicloud.com

Best Regards,
Yi.

> 
> Changes since v1:
>  - In patch 04, rename ext4_block_get_zero_range() to
>    ext4_load_tail_bh() and drop the unused 'length' parameter as Jan
>    suggested.
>  - In patch 06, modify the commit message, add another reason to drop
>    data=ordered mode when zeroing partial blocks in ext4_punch_hole()
>    and ext4_punch_hole() as Jan pointed out.
>  - In patch 10, modify the commit message, explain the race condition
>    between the buffered write and mmap write that pointed out by Jan.
>  - Collect reviewed tags from Jan.
> 
> v1: https://lore.kernel.org/linux-ext4/20260310014101.4140698-1-yi.zhang@huaweicloud.com/
> 
> Original cover letter:
> 
> This patch series extracted from my iomap conversion v2 series[1]. It
> refactors the ext4 zero partial block code path in preparation for
> converting buffered I/O to the iomap infrastructure. The main changes
> are:
> 
> [1] https://lore.kernel.org/linux-ext4/20260203062523.3869120-1-yi.zhang@huawei.com/
> 
> 1. Introduce ext4_block_zero_eof(): Extend and rename
>    ext4_block_truncate_page() to handle post-EOF partial block zeroing
>    for both append writes and truncate operations.
> 2. Separate ordered data handling: Move data=ordered mode handling from
>    __ext4_block_zero_page_range to ext4_block_zero_eof(). Only truncate
>    and post-EOF append write/fallocate paths need ordered data mode,
>    hole punching and zero range paths don't need ordered data handling.
> 3. Split journal mode handling: Extract
>    ext4_block_journalled_zero_range() from
>    __ext4_block_zero_page_range() for data=journal mode, leaving
>    ext4_block_do_zero_range() for data=ordered/writeback modes.
> 4. Refactor ext4_alloc_file_blocks(): Change parameters to loff_t byte
>    granularity to simplify callers and prepares removing the zero call
>    from the allocation loop for unaligned append writes.
> 5. Remove handle parameters: Stop passing handle_t * to zero functions.
>    Make ext4_block_journalled_zero_range() start its own handle, and
>    move zero operations outside active handles. This is required because
>    iomap uses "folio lock -> transaction start" lock ordering, opposite
>    to the current lock ordering.
> 6. Centralize zeroing in ext4_write_checks(): Move all post-EOF partial
>    block zeroing to ext4_write_checks() so it applies to both regular
>    buffered writes and the upcoming iomap path.
> 
> Thanks
> Yi.
> 
> Zhang Yi (10):
>   ext4: add did_zero output parameter to ext4_block_zero_page_range()
>   ext4: ext4_block_truncate_page() returns zeroed length on success
>   ext4: rename and extend ext4_block_truncate_page()
>   ext4: factor out journalled block zeroing range
>   ext4: rename ext4_block_zero_page_range() to ext4_block_zero_range()
>   ext4: move ordered data handling out of ext4_block_do_zero_range()
>   ext4: remove handle parameters from zero partial block functions
>   ext4: pass allocate range as loff_t to ext4_alloc_file_blocks()
>   ext4: move zero partial block range functions out of active handle
>   ext4: zero post-EOF partial block before appending write
> 
>  fs/ext4/ext4.h    |   5 +-
>  fs/ext4/extents.c |  83 +++++++--------
>  fs/ext4/file.c    |  14 +++
>  fs/ext4/inode.c   | 255 ++++++++++++++++++++++++++++------------------
>  4 files changed, 207 insertions(+), 150 deletions(-)
> 

