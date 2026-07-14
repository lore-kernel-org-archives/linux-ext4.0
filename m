Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF70376A01;
	Tue, 14 Jul 2026 03:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784000525; cv=none; b=I1/YxOQ7i2hJwc8oDbdWjQlQRoJsG1D2pMGvKHISad91s0W6IT8C4h2AcQ8LGuIcx9jC4yPzDhVq/jATsmUDh7aiziZK4M1MFYUDlcdP+P7Ba5FwPoQ66PCHavBpTka+QFx9xAEXHW96RqLyhkD8OOo09WdI7dplSkhwSV4M0FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784000525; c=relaxed/simple;
	bh=rtAjduBj/IGK2rXhqV6SrOiabUBRldyRjKNh8jbB2dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dXq3IIqObROvG31s+e5mnx+36PZLWCxIgi6R4XYFUYeNgHltS21p2ogO8nBLLC0LOBLnJgvtGy7xVdOlqLoiyBhIXvBcDZaA3wHiXr2frZrhjp6HrLahWls2h4Gykab1yZG9lNz99CLS9DiOxYic7RYxZtP9O3vs38LcqllLjoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzlTh6SqmzKHLvF;
	Tue, 14 Jul 2026 11:41:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 038234056D;
	Tue, 14 Jul 2026 11:41:59 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCntnIFsFVqeW2jBA--.54087S3;
	Tue, 14 Jul 2026 11:41:58 +0800 (CST)
Message-ID: <ed43e93c-5938-4e02-b2c2-1550e98f7f20@huaweicloud.com>
Date: Tue, 14 Jul 2026 11:41:57 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] jbd2: bound j_list_lock hold time in the checkpoint
 shrinker
To: Max Kellermann <max.kellermann@ionos.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
 <80184b10-f5b5-4b95-9c35-9a5d4208d579@huaweicloud.com>
 <CAKPOu+_6afuEHv3EcLMe1fiQ9R_nvwOhBfXNCZeyxEe-wfkZuA@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <CAKPOu+_6afuEHv3EcLMe1fiQ9R_nvwOhBfXNCZeyxEe-wfkZuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCntnIFsFVqeW2jBA--.54087S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1UtFyrJFy3JF1UXFyDtrb_yoW5Xr18pF
	WfG393tw4kt3W8Cws7Ww1xuFWrXan5Gry5GrnxGrWkAws8Gr92yr4xKrWYga4UCr10k3yF
	qFZF93s3Wa48ZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7IJmUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/13/2026 11:03 PM, Max Kellermann wrote:
> On Mon, Jul 13, 2026 at 2:53 PM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>> I'm a bit curious about which kernel version and CONFIG you
>> encountered this issue on. IIRC, after commits [1] and [2], the
>> spin_needbreak() in jbd2_journal_shrink_checkpoint_list() should
>> always be effective (unless the hardware does not support it, i.e.,
>> ARCH_NO_PREEMPT).
> 
> We run 6.18.38, and preemption is disabled. Therefore,
> spin_needbreak() is a no-op.
> (We used to always run the latest stable, but got burned by way too
> many critical Ceph/netfs regressions and settled on the LTS.)
> 
> But even with preemption enabled, this would likely be a problem,
> though a much smaller one.
> 
>> Moreover, the number of buffer_heads in the
>> checkpoint list of a single transaction should not be large enough
>> to trigger such soft lockups. So I suspect this issue should be
>> unlikely to occur on the latest kernel releases.
> 
> Unfortunately, I don't have any numbers for you, because this problem
> occurs only every other week, but we have been haunted by this for a
> long time.
> 
> The setup is a 7 TB ext4 partition dedicated to fscache/Ceph. It's
> always full, and culling is running quite often.
> 
> For culling, we don't use cachefilesd but our own reimplementation
> (https://github.com/CM4all/cash) because cachefilesd scales
> quadratically and never makes any progress while burning CPU cycles
> and I/O forever; ours is massively parallel thanks to io_uring. That
> puts a lot of pressure on the ext4 filesystem, and a cgroup
> memory.high setting means it's always under memory pressure (or else
> the kernel will accumulate many gigabytes of RAM usage very quickly
> during the filesystem scan that is necessary for culling). Which means
> the shrinker is running all the time. Plus the usual kernel-initiated
> I/O on that partition.
> Every time this problem occurred, fscache culling was active.
> 

Thank you for the details!

We recently encountered the same issue on older kernels (up to v6.6)
during extreme memory pressure stress testing. Interestingly, we were
unable to reproduce it on the latest v7.1 kernel.

After investigation, we identified that commit 7dadeaa6e851 ("sched:
Further restrict the preemption modes") effectively prevents disabling
preemption entirely, which makes spin_needbreak() always work in
practice. So I was previously curious whether you discovered this issue
in the latest kernel.

However, let's come back to the point. I agree this is a real issue
that deserves a proper fix, independent of the preemption model changes.

Thanks,
Yi.

