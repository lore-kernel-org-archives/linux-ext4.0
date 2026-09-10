Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59F4BFE7C
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 12:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789042471; cv=none; b=LJC++ymH5MlnNj0Y/5WPw+yvszi3Z6pkBxIX6wayW0JdC5EMakZMZ9Ae48kc0mEiVkd/QQANQ3ligz4ZrA/ED0AiwVSEezQxoWWvhsvND3kE6J2gsGjTHhYY4xvtFul6BTB7ObVb1IkmJAem0n9hVQUbX184/A98GPaULsg8yIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789042471; c=relaxed/simple;
	bh=lErptj4tPZkqqiyNI6w+Zk7gJkd6t+/qDIVjR4w8sJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lAexAYGVzH1v8yFxn8V0H1GvAYZV4ABllPaKTcz3guDDy0/7mUGiiaPaFyntVRl/5BJGkfkWuyIUlLIRaq4+lhT6mPozjvKyOarwO/ePkkgapxQUOUCG6ih5+CsDeVcB7+KgFoay8FAd3BERf+O5eItIYp2/Vt528Xt30RpR2iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hgc5h3BgszYQwXk
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 20:13:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 56DDD40561
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 20:14:23 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCXzAcdn6JqHMrOBQ--.9954S3;
	Thu, 10 Sep 2026 20:14:23 +0800 (CST)
Message-ID: <6e110404-143c-4d21-a5ed-90ec7011ef55@huaweicloud.com>
Date: Thu, 10 Sep 2026 20:14:21 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/31] ext4: implement buffered write path using iomap
To: sashiko-reviews@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-15-yi.zhang@huaweicloud.com>
 <20260903132304.CE1EF1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260903132304.CE1EF1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCXzAcdn6JqHMrOBQ--.9954S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurWUJr4UJr1DWFW3ArWfuFg_yoW5ZF1DpF
	9xKr4UGr1vq3s29wsrWFs8Wryjk3W7tr47ury3WF15XrnrArWSgF4jgF15uF45G397AF10
	grW09r97Xry5ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/3/2026 9:23 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Spurious ENOSPC failures occur on large writes because space exhaustion protection is evaluated only once per write syscall.
> --
> 
> commit 0e8cfe3183ec36e2c7cb68a2f835e58a2e54d43e
> Author: Zhang Yi <yi.zhang@huawei.com>
> ext4: implement buffered write path using iomap
> 
> This commit introduces new iomap_ops instances for ext4 buffered writes to 
> transition to the iomap infrastructure. It also adds ext4_iomap_valid to 
> verify extent validity and handles cleanup of stale delayed allocation 
> ranges on short writes.
> 
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index 374b4bc25bd5d..50d3c92709c8b 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
> [ ... ]
>> @@ -330,6 +330,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>>  	return count;
>>  }
>>  
>> +static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
>> +					 struct iov_iter *from)
>> +{
>> +	struct inode *inode = file_inode(iocb->ki_filp);
>> +	const struct iomap_ops *iomap_ops;
>> +
>> +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
>> +		iomap_ops = &ext4_iomap_buffered_da_write_ops;
>> +	else
>> +		iomap_ops = &ext4_iomap_buffered_write_ops;
>> +
> 
> [Severity: High]
> Will this cause spurious -ENOSPC failures on multi-gigabyte writes?
> 
> In ext4_iomap_buffered_write(), the ext4_nonda_switch() check is evaluated
> only once before passing iomap_ops into the iomap_file_buffered_write() loop.
> 
> If space runs low during a large write, the operation stays locked in delayed
> allocation mode instead of dynamically switching to non-delayed allocation.
> 
> This bypasses the continuous per-page free space threshold checks that were
> previously done on-the-fly, which could lead to over-reserving space and
> silent data loss during background writeback.
> 

This is a trade-off. To keep the code simple,
ext4_iomap_buffered_da_write_ops is shared with the page-fault path.
iomap_page_mkwrite() locks the folio beforehand, and ext4_nonda_switch()
-> try_to_writeback_inodes_sb() synchronously waits for writeback, which
needs that same folio lock, so it could deadlock. That is exactly why
ext4_iomap_page_mkwrite() calls ext4_nonda_switch() before locking the
folio. I'm not sure how much checking it only once per write, rather
than per folio, would increase the probability of a writeback-time
allocation failure.

If it ever turns out to matter, we can re-check ext4_nonda_switch() per
extent in the write path only, since
ext4_iomap_buffered_da_write_begin() can tell the two paths apart via
the IOMAP_FAULT flag and avoid the folio-lock-holding fault path. I
think we can go with this implementation for now, and adjust it
separately if problems show up later.

Thanks,
Yi.

>> +	return iomap_file_buffered_write(iocb, from, iomap_ops,
>> +					 &ext4_iomap_write_ops, NULL);
>> +}
>> +
>>  static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>>  					struct iov_iter *from)
>>  {
> 

