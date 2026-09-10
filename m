Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAB53BBFD8;
	Thu, 10 Sep 2026 07:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789024710; cv=none; b=ocvCxiIYRA88HV9kb9ATZphhnVz4a12bvcFpfGceTSUNwxj8lmUpe7rtMC+aO1rV2oGXgIO219NXZZ/V637+ExEJ6nsxU/++jS20Q7JhBOFztItGEswutKmUrooqGYxvlYUUAnpnyKQuu3jh+e6OQDabcjIdiFB418Q5uQEKq9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789024710; c=relaxed/simple;
	bh=L33spyIi49igwJHGU6a/daiLy9JRmCjsH01c4ZHY+O0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4WRiOrna6k8RtpZ4B20s53Tkiae/EpwB21fjoXGpxyTeWQpUV1/4K2SFqvevQbqU9vp5GahtKWOO/9OymmOWB7ifCMOcVbXkkrm2j8PE5isTKPZux6FZ9ILqRcG0KFoRedMCRjeYWS0aEJAHjpfZOmoekWjw++rPnQzV7z77G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hgTX10xNpzYQvF2;
	Thu, 10 Sep 2026 15:17:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A559A40576;
	Thu, 10 Sep 2026 15:18:15 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCHbgm0WaJqciq1BQ--.27171S3;
	Thu, 10 Sep 2026 15:18:15 +0800 (CST)
Message-ID: <25009e78-b1e1-4c3e-a12d-365869b1d475@huaweicloud.com>
Date: Thu, 10 Sep 2026 15:18:12 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 ziy@nvidia.com, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
 <20260909161433.d96c67399ccac8de27499925@linux-foundation.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260909161433.d96c67399ccac8de27499925@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCHbgm0WaJqciq1BQ--.27171S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw47Wr1kXF15uw4fur4kJFb_yoWrKFy7pF
	Wagas0kr1kG39akr13Aa1UXw15A34xXw4UJFyfG3ySyFZ8Zw1DKF15K3W8Way7Kwn7Cw1r
	Xa4jvayDW3WUAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jxCztUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/10/2026 7:14 AM, Andrew Morton wrote:
> On Wed,  9 Sep 2026 14:23:39 +0800 Zhang Yi <yi.zhang@huaweicloud.com> wrote:
> 
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()      # same_folio == true
>>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>       2nd split of folio2 fails / cannot lock
>>       return true                       # BUG: caller keeps default end
>>     end = 3
>>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
> 
> So is there any way of being hit by these issues in 7.2 and earlier?
> 
>>  mm/internal.h |  4 +--
>>  mm/shmem.c    | 13 +++-----
>>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>>  3 files changed, 67 insertions(+), 38 deletions(-)
> 
> I hope not, because that's quite a lump of code to be backporting.

I took a rough look at a few existing filesystems and had an LLM help
put things together.

Actually triggering it needs all of:
(1) a large folio straddling the punch/truncate boundary, so the
    in-range part is zeroed and the out-of-range part holds valid data;
(2) that folio dirty, so the out-of-range tail exists only in the
    pagecache;
(3) no filesystem private data on the folio (or ->release_folio()
    returning success), so the first folio_split() in
    truncate_inode_partial_folio() can succeed.

Filesystems that enable large folios fall into three groups, none of
which can currently satisfy all three:

- buffer_head / private-based (ext4, btrfs, ...): a dirty folio
  always carries fs private state (buffer_head, extent state), so
  ->release_folio() returns false and folio_split() aborts with -EBUSY
  before the first split — condition (3) fails.
- netfs (afs, nfs, smb, ...): AP_RELEASE_ALWAYS is set but
  netfs_release_folio() returns false on a dirty folio — same effect,
  condition (3) fails.
- iomap (xfs, zonefs, erofs): these can have dirty large folios
  without private data, but none reach the unsafe window — xfs always
  runs filemap_write_and_wait_range() (xfs_flush_unmap_range) before
  punching, so the boundary folio is clean; zonefs has no punch-hole;
  erofs is read-only. With the tail already on disk (clean), discarding
  the straddling folio loses nothing.

So on 7.2 and earlier I cannot find a reachable trigger path. It only
becomes reachable on the upcoming ext4 + iomap buffered-I/O path, which
for the first time combines large folios + no private data on
fully-dirtied folios + missing pre-punch writeback.

> 
> Thanks.  I'll queue it for testing and shall await your response to Zi
> Yan's questions.
> 
> I see you've received Sashiko's feedback.  Please let us know if
> there's any validity to it.
> 
> 	https://sashiko.dev/#/patchset/20260909062339.473816-1-yi.zhang@huaweicloud.com
> 

I took an initial look at Sashiko's review report. I think the
issue is valid — the current fix can get the wrong folio2 index
when there's a concurrent split. I need to think more about how
to fix it properly.

Thanks,
Yi.

