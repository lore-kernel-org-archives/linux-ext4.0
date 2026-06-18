Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F08539FD9;
	Thu, 18 Jun 2026 01:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781746996; cv=none; b=nMN0ogYbOovw7mOVoqO+tWEP5Ic4QQFWSElxh4DpHuPe1VuYnM43hRpSSGnRy2wlENfdKRILtjW8GWqwnOHYidAFUK6CwjxYIxOF6G+q/Xye6UkmamdcK3wA7f3iS0Qf+7ELseGlQra429db6MBp01SWpGyk4u5J5BL4FNzQ15E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781746996; c=relaxed/simple;
	bh=CnE+tHift91NW7KVcz4F90uocoWIyRwmZf0x46qY59I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RKi0f+Cly0pDIWMWtKO/zW8k5FAfof70D96jbAqplWfSU4pmIl+0pFKOsfDp3I4R6xnl9TiqvOiEfWqKC3ZjMMsvSeIEDq5EwZPvjEMOfhLY/i0+/8wlmL+2yeE0vfA9sFh2IMTrUI8gSOWhA6UdI7brEUoJNy0Gkkie6eTxutw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ggk4B1WBFzKHMZm;
	Thu, 18 Jun 2026 09:42:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 738A740583;
	Thu, 18 Jun 2026 09:43:07 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgA3OT4pTTNqwnq+CA--.30640S3;
	Thu, 18 Jun 2026 09:43:07 +0800 (CST)
Message-ID: <cf4b41a7-a1ee-42d8-aafc-f8ddc6687a49@huaweicloud.com>
Date: Thu, 18 Jun 2026 09:43:05 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/23] ext4: pass out extent seq counter when mapping
 da blocks
To: Jan Kara <jack@suse.cz>, Zhang Yi <yizhang089@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-7-yi.zhang@huaweicloud.com>
 <ghe4izo4od2b4fcgmiayopkaombyjjopao266sseuqim72t5sj@h2meez5lalsl>
 <58ee3009-8a0e-4657-a473-475ea998316e@gmail.com>
 <xt3zkmgktl7wpbwt4de76wh4q576fkmytw6udeojmj4goi6ul6@np4zgi2zinkg>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <xt3zkmgktl7wpbwt4de76wh4q576fkmytw6udeojmj4goi6ul6@np4zgi2zinkg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgA3OT4pTTNqwnq+CA--.30640S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZFy3uF43Kw43AF4UAw43Jrb_yoWrAw43pa
	90kF15KrsxZ348uF4xtF1xXr1F9a1UKrW7Wr43Xw1FgF90kFySgF47WF12kFy8Kr4xJr10
	qF4jkryxur1FyrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 6/18/2026 4:29 AM, Jan Kara wrote:
> On Tue 16-06-26 20:37:00, Zhang Yi wrote:
>> On 6/16/2026 6:04 PM, Jan Kara wrote:
>>> On Mon 11-05-26 15:23:26, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> The iomap buffered write path does not hold any locks between querying
>>>> inode extent mapping information and performing buffered writes. It
>>>> relies on the sequence counter saved in the inode to detect stale
>>>> mappings.
>>>
>>> Now that I'm looking at it again, I've got a bit confused here. Buffered
>>> write path is holding i_rwsem between mapping blocks and using them so
>>> there shouldn't be races.  Perhaps you mean buffered *writeback* path? But
>>> then ext4_da_map_blocks() should not ever get called in the writeback path
>>> because it is allocating delayed blocks... So this change looks unnecessary
>>> to me now. Am I missing something?
>>>
>>> 								Honza
>>>
>>
>> Hi Jan,
>>
>> Thanks for coming back to this series. Sorry for the inaccurate
>> description in the commit message. However, this change is still needed.
>>
>> As mentioned in the comment before the ->iomap_valid() callback in
>> iomap_write_begin(), consider the following scenario — a buffered write
>> to a dirty unwritten extent, with this concurrent race:
>>
>>   Buffer write (holds i_rwsem)    Writeback (no i_rwsem)
>>   ext4_da_map_blocks()
>>     // ext4_es_lookup_extent()
>>     // finds UNWRITTEN extent
>>   ext4_set_iomap()
>>     // type = IOMAP_UNWRITTEN
>>     // validity_cookie = m_seq
>>                                   ext4_iomap_writepages()
>>                                     // writeback for unwritten extent
>>                                     // ext4_convert_unwritten_extents()
>>                                     // extent tree: UNWRITTEN → WRITTEN
>>                                     // advancing i_es_seq
>>   __iomap_write_begin()
>>     // ext4_iomap_valid(): cookie != i_es_seq
>>     // iomap invalidated, re-maps
>>     // gets type = IOMAP_MAPPED (WRITTEN)
>>     // iomap_block_needs_zeroing(): FALSE
>>
>> Without passing out m_seq, the stale IOMAP_UNWRITTEN type from the iomap
>> would cause __iomap_write_begin()->iomap_block_needs_zeroing() to zero
>> out blocks that have already been written, corrupting data on partial
>> writes.
> 
> Ah, right, thanks for explanation. So please update the description to
> explicitely mention that iomap doesn't hold folio lock between mapping the
> extent and copying data and thus can race with writeback modifying the
> extent type. Thanks!
> 
> 								Honza

Sure, thanks for pointing this out.

Cheers,
Yi.

> 
>>
>> Thanks,
>> Yi
>>
>>>>
>>>> Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
>>>> blocks") added the m_seq field to ext4_map_blocks to pass out extent
>>>> sequence numbers, but it missed two callsites within
>>>> ext4_da_map_blocks(). These callsites are on the delayed allocation
>>>> path, which is also used in the iomap buffered write path. Pass out the
>>>> sequence counter to ensure stale mappings can be detected.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>>> ---
>>>>   fs/ext4/inode.c | 4 ++--
>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index 6c4d9137b279..39577a6b65b9 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -1929,7 +1929,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>>>>   	ext4_check_map_extents_env(inode);
>>>>   	/* Lookup extent status tree firstly */
>>>> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
>>>> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>>>>   		map->m_len = min_t(unsigned int, map->m_len,
>>>>   				   es.es_len - (map->m_lblk - es.es_lblk));
>>>> @@ -1982,7 +1982,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>>>>   	 * is held in write mode, before inserting a new da entry in
>>>>   	 * the extent status tree.
>>>>   	 */
>>>> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
>>>> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>>>>   		map->m_len = min_t(unsigned int, map->m_len,
>>>>   				   es.es_len - (map->m_lblk - es.es_lblk));
>>>> -- 
>>>> 2.52.0
>>>>
>>

