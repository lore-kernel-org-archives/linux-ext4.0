Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C946D314D34;
	Fri,  3 Jul 2026 03:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783049968; cv=none; b=YxRn2Jd85YmOCPFXa9WpXZk5s8Les+oqjZR2uzz6O/raTbeES19W8cjkNNKDPABdmsgsMI1juJvBqCrts0RWVFr5DZKCBgwZUdwp32kRCJYpoVYgdvsN2QCGCEUnFLL1kbMMcwYcsiR583kIZLmtm+UHpQbUmg8BtblATFVjQyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783049968; c=relaxed/simple;
	bh=VFby4seUU78zGYKEEAs1W1sFStQFVzrd4qz75Nwb994=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uAvo9psHC+mBnhbUNNnEHyvk8ELQiG1197d+u2dBl+QVinKWOBMbHklqLdSb3pvdKM6fXMoSI3fgJf5f89Vl3jNyHM57hab8/Ly9LMm++sRolVGYnKW06UUI/kmCBCclpNnBmutEurbiQ+URx7KEzdhtyP+ZZaLKvgQ7JOu7D5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4grzxn6fQ9zKHMRP;
	Fri,  3 Jul 2026 11:38:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 2F4F74058F;
	Fri,  3 Jul 2026 11:39:06 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgDnVvTYLkdqUBexAg--.24243S3;
	Fri, 03 Jul 2026 11:39:05 +0800 (CST)
Message-ID: <89a20f31-39e5-4592-9bc5-d444b6c1c7f4@huaweicloud.com>
Date: Fri, 3 Jul 2026 11:39:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
To: Jan Kara <jack@suse.cz>, Zhang Yi <yizhang089@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, chengzhihao1@huawei.com, yangerkun@huawei.com
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-3-yizhang089@gmail.com>
 <qpxvjsdnq6jgigjnwzkxny6lms6gi6t4bq5l33rr2f6m6l4oum@5e6ayymrgcbd>
 <a54c9df2-63e6-41ad-b32f-54d2f0356d5c@gmail.com>
 <5xgyaw3ufsymz7tqoyrkwo64a2uup75hnuaudtrejozhb2qnox@owzep3gkgf2v>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <5xgyaw3ufsymz7tqoyrkwo64a2uup75hnuaudtrejozhb2qnox@owzep3gkgf2v>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDnVvTYLkdqUBexAg--.24243S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr1DCFyUAr18AFWkJFyxZrb_yoWxZFyDpa
	9I9F1UKr4kJa409ayIy3W8Wrn2k34kJrW7urW8Kryjvas8Jr1SyF12gFy5uFyjkrs3WF1a
	qrWUKryxXFs8AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 7/3/2026 12:43 AM, Jan Kara wrote:
> On Thu 02-07-26 22:40:17, Zhang Yi wrote:
>> On 7/2/2026 5:53 PM, Jan Kara wrote:
>>> On Wed 01-07-26 22:20:05, yizhang089@gmail.com wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
>>>> buffers, but the conditions that lead to this are not obvious from the
>>>> code alone. Document this behavior to clarify the return value, so that
>>>> readers do not mistakenly assume that only holes result in a NULL
>>>> return.
>>>>
>>>> Also update the inline comment following the ext4_get_block() call to
>>>> reflect this: both holes and clean unwritten buffers fall through to the
>>>> "nothing to do" path.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>>   fs/ext4/inode.c | 6 +++++-
>>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index c2c2d6ac7f3d..0b31fa873743 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
>>>>    * because it might have data in pagecache (eg, if called from ext4_zero_range,
>>>>    * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>>>>    * racing writeback can come later and flush the stale pagecache to disk.
>>>> + *
>>>> + * Return the loaded bh if it actually needs zeroing - in written, dirty
>>>> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
>>>> + * a clean unwritten block).
>>>>    */
>>>
>>> Great that you're adding this comment because when I was reading previous
>>> patch, I've spent like 10 minutes trying to figure that out :). But as far
>>> as I'm reading the code, ext4_load_tail_bh() will return the unwritten bh
>>> even if it is clean - map_bh() in _ext4_get_block() will set
>>> buffer_mapped() even for unwritten extent. What am I missing? BTW, it also
>>> seems to be ext4_load_tail_bh() could attempt to ext4_read_bh_lock() on
>>> unwritten bh if things align wrongly...
>>>
>>> 								Honza
>>
>> Thank you for the review!
>>
>> Please note the ext4_update_bh_state(bh, map.m_flags) call in
>> _ext4_get_block() — it restores the mapped flag back to unwritten. As a
>> result, the !buffer_mapped(bh) check will evaluate to true for a clean
>> unwritten block, the function will return NULL.
> 
> Argh, right. But ext4_ext_map_blocks() sets both BH_Unwritten and BH_Mapped
> in the returned map->m_flags for unwritten extents. So I think my comment
> still applies. 

Because ext4_get_block() is called with create = 0, this is purely a
lookup operation. Therefore, in ext4_ext_map_blocks() ->
ext4_ext_handle_unwritten_extents(), only EXT4_MAP_UNWRITTEN is set,
and EXT4_MAP_MAPPED is not (please see the branch where
if (flags & EXT4_GET_BLOCKS_CREATE) == 0)). So at this point, whether
the lookup is served from the extent status cache or from the on-disk
query, it works correctly now.

> Plus there's a very strange inconsistency between this and
> the lookup in extent status tree in ext4_map_blocks() where (as you
> indicate) we only set BH_Unwritten but *not* BH_Mapped. AFAICT there's
> something buggy in here :) Note that when we don't set BH_Mapped flag e.g.
> from ext4_get_block_unwritten() (which gets used when delalloc is disabled),
> then writes to unwritten extent will get lost because
> ext4_bio_write_folio() will just treat them as holes...
> 
> 								Honza

In fact, there is no real problem here. For the write path that gets an
unwritten block, EXT4_GET_BLOCKS_UNWRIT_EXT and
EXT4_GET_BLOCKS_CREATE are always passed together. This ensures that
even if we find the unwritten extent in the extent status cache, we
still call ext4_map_create_blocks() (due to EXT4_GET_BLOCKS_CREATE)
and go through ext4_ext_handle_unwritten_extents(). Inside that
function, because the flags contain EXT4_GET_BLOCKS_UNWRIT_EXT,
EXT4_MAP_MAPPED is set. So for the write path, ext4_bio_write_folio()
still writes back correctly.

That said, the semantic inconsistency between the lookup-only and
allocation paths has been bothering me for a while. I had to be very
careful about this when developing the buffered I/O iomap path, because
this semantics also differs from the iomap infrastructure. In iomap, for
an unwritten extent, IOMAP_UNWRITTEN and IOMAP_MAPPED are not set
simultaneously; IOMAP_MAPPED always represents a written extent. The
good news is that this conversion is not complicated.

I asked an agent to look into the historical reasons, and here is what
he told me:

  When ext4 introduced fallocate + delalloc in 2008-2009, it followed
  the XFS convention that "unwritten is not mapped." However, ext4's
  writeback path (mpage_da_submit_io) depended on BH_MAPPED to issue
  I/O, which meant that unwritten buffers would never be written out.
  Commit bf068ee266f9 was the first fix - it converted unwritten to
  mapped during the writepages stage. Commit 29fa89d08894 was the
  second fix - it made unwritten carry mapped at the write-begin stage.
  Commit 2a8964d63d50 was a revert patch - it cleared the unwritten
  flag in the create = 1 path to avoid duplicate get_block() calls.

  Then the extent status cache was introduced in 2013. Commits
  a25a4e1a5d5d (Zheng Liu, 2013-02) and d100eef2440f (2013) added the
  ES-cache lookup path. In that path, ext4_es_is_unwritten returns
  EXT4_MAP_UNWRITTEN without EXT4_MAP_MAPPED - this was not a new
  design decision, but rather a continuation of the old 2009 convention
  that "unwritten is not mapped." Zheng Liu's commit message did not
  discuss whether MAPPED should be set at the same time; it only said
  "ext4_map_blocks needs to use this flag to determine the extent
  status." He was simply implementing the ES-cache lookup, and the
  status semantics followed the old implementation.

  The comment in ext4_map_blocks() - which says "if blocks have been
  preallocated ext4_ext_map_blocks() returns with buffer head unmapped"
  - was inherited from Aneesh's 2009 code. It was not a new decision
  made in 2013.

So my understanding is that this inconsistency in ext4_map_blocks() is
a historical legacy problem. There are many places where handling these
two flags is also semantically ambiguous. Some may treat those with the
BH_mapped flag set as written, such as ext4_load_tail_bh(). Therefore,
setting the mapped flag may cause many issues, and it can only be done
by setting the unwritten flag when performing a query. If I am wrong
about any of this, please correct me.

Going forward, I think we should revisit and clearly redefine the
semantics of these two flags, and unify the behavior of ext4_get_block().
Otherwise, carrying this historical baggage will only hinder future
development. :-)

Thanks,
Yi.

