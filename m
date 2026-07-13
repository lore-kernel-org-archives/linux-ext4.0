Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7DF19F121;
	Mon, 13 Jul 2026 12:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947237; cv=none; b=VhynDyzxs9nUBujB1DXfiCmrXKzNsRkVJ9e3/j0InL8xtofjyiH8V7OnneOo9ipnB2sXrzRiwB32Z6K7TMVtYhsLXg+XTR+XlsQoj0JZP+MD0hiNbSCJN+BnXlY5NAgIf1ISLhzmxqfietlF0qS0wHVlVKzyME3CcLA8f6xhV6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947237; c=relaxed/simple;
	bh=rOdfaeBSDGv2gKQxWCOHdhIsJAODpSFLhZy1gZuV2yE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dw+w8QkaR0IBBW8elbtSnWUKkZUCNIDPqbHUDF8vROKoV7Yus9HNfVAJvHXd53QMkZtEXSWdd4d2SQtvG7phVtFcbGTBGTGgTugVEXshqqdg0M91ZRi9O10C1R7wWDWeIez+hyGTrx949eERYarcA/qme7oy9Ygl9ME+PRkewfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzMmy1P6BzKHMWp;
	Mon, 13 Jul 2026 20:53:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4ADE940590;
	Mon, 13 Jul 2026 20:53:51 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCXp3Pd31Rqkw5ZBA--.43198S3;
	Mon, 13 Jul 2026 20:53:51 +0800 (CST)
Message-ID: <80184b10-f5b5-4b95-9c35-9a5d4208d579@huaweicloud.com>
Date: Mon, 13 Jul 2026 20:53:49 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] jbd2: bound j_list_lock hold time in the checkpoint
 shrinker
To: Max Kellermann <max.kellermann@ionos.com>, tytso@mit.edu, jack@suse.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260713102229.1598812-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCXp3Pd31Rqkw5ZBA--.43198S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7Jr17Kw13Xw4kWr4fuFg_yoW5ZF48pF
	Z0g3y8Xr4ku34xZrsIva18JFWFqa1kuryUWanF9r1Fvw4rXF4Sgry2kr42gFyUKFyfWw43
	tFyUWwnrWa1jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU80fO7UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/13/2026 6:22 PM, Max Kellermann wrote:
> We hit recurring RCU stalls / soft lockups on a busy ext4 filesystem
> that serves as the CacheFiles backing store for a Ceph (fscache)
> client.  The stall is always the journal commit thread spinning on
> journal->j_list_lock:
> 
>   rcu: INFO: rcu_sched self-detected stall on CPU
>   rcu:   106-....: (2099 ticks this GP) ... (t=2100 jiffies)
>   CPU: 106 Comm: jbd2/nvme1n1p1-
>   RIP: 0010:queued_spin_lock_slowpath+0x20a/0x240
>   Call Trace:
>    jbd2_journal_write_metadata_buffer+0x1c0/0x310
>    jbd2_journal_commit_transaction+0x5e2/0x16e0
>    kjournald2+0xa1/0x220
>    kthread+0xe4/0x1d0

Hi, Max!

Thanks for the report!

I'm a bit curious about which kernel version and CONFIG you
encountered this issue on. IIRC, after commits [1] and [2], the
spin_needbreak() in jbd2_journal_shrink_checkpoint_list() should
always be effective (unless the hardware does not support it, i.e.,
ARCH_NO_PREEMPT). Moreover, the number of buffer_heads in the
checkpoint list of a single transaction should not be large enough
to trigger such soft lockups. So I suspect this issue should be
unlikely to occur on the latest kernel releases.

[1] 7dadeaa6e851 ("sched: Further restrict the preemption modes")
[2] 7c70cb94d29c ("sched: Add Lazy preemption model")

Thanks,
Yi.

> 
> kjournald2 has already passed the "wait for outstanding handles"
> barrier and is in the metadata write-out loop; it is simply unable to
> acquire j_list_lock for >21s.  The lock holder is the jbd2 checkpoint
> shrinker.
> 
> Under memory pressure, the shrinker (jbd2_journal_shrink_scan ->
> jbd2_journal_shrink_checkpoint_list -> journal_shrink_one_cp_list)
> walks a transaction's checkpoint list under j_list_lock.  On this
> workload, the lists are large and dominated by busy buffers (dirty /
> under writeback / attached to the running transaction), and
> journal_shrink_one_cp_list() can therefore hold j_list_lock for a time
> proportional to the whole list length, for two reasons:
> 
> 1. The JBD2_SHRINK_BUSY_SKIP path uses "continue", which also skips
>    the need_resched() check, so the scan does not yield even when a
>    reschedule is pending.
> 
> 2. The scan budget (nr_to_scan) is decremented only for buffers that
>    are actually freed, so busy buffers do not consume it and the loop
>    is not bounded by the shrinker's batch at all.
> 
> Both were introduced by commit b98dba273a0e ("jbd2: remove
> journal_clean_one_cp_list()"), which folded
> journal_clean_one_cp_list() into journal_shrink_one_cp_list() and
> dropped the per-examined-buffer budget that the shrinker previously
> had.
> 
> The result is a self-reinforcing collapse: shrinker instances across
> many CPUs hold/contend j_list_lock, kjournald2 cannot commit, the
> journal fills, CacheFiles lookups block in ext4, fscache cookies get
> stuck in LOOKING_UP, and netfs I/O times out.
> 
> Max Kellermann (2):
>   jbd2: check need_resched() when skipping busy checkpoint buffers
>   jbd2: bound shrinker scans by examined checkpoint buffers
> 
>  fs/jbd2/checkpoint.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 

