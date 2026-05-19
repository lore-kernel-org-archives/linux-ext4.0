Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178A64DBD9E;
	Tue, 19 May 2026 12:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779194166; cv=none; b=thfbjH/8sJDiIuwmRAkXg0iaR94hlSCd8pr2w9yh2CYRT77pTwkyINncEKCJE/Vl8PpG3rUPchga95Eo7GIb8RRrWimLM0sqJyrZ2u4HT/az27+WZ4Y4iI4KOK+nCw01js5KXv+mK6VXZp1cw5gQDjlySXeWShq6t5MeIOTH8fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779194166; c=relaxed/simple;
	bh=2+0fCTu+ajtunE6rwCSysAWvkh9irCX3iGrXOePyuNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKCCAUN4nXqeAFqeaJJMwQLvFMwMbjqVBywWsAbzJ9neQ863uaA9L4hgCddJ2iCfErp2y3i/hSV6IZUKcUb36PB3awRO2Hsj7MqN8WPLlYpuhRTcT+r26r5AG1ZVeL2cktZ9tpF4cOVx2Yt8XVK92/PGZEbo4/9Zw4ilmRXW2Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gKZ076mWfzKHMLp;
	Tue, 19 May 2026 20:35:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C4D724058D;
	Tue, 19 May 2026 20:35:53 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgC3f1snWQxqf2J9Cw--.49753S3;
	Tue, 19 May 2026 20:35:53 +0800 (CST)
Message-ID: <236657df-71f2-446d-b44b-39865219a850@huaweicloud.com>
Date: Tue, 19 May 2026 20:35:51 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/23] ext4: add iomap address space operations for
 buffered I/O
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-5-yi.zhang@huaweicloud.com>
 <agwtJq5-B2E-t7zT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <agwtJq5-B2E-t7zT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC3f1snWQxqf2J9Cw--.49753S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GFWDuFW7uF4UJr45CFyfJFb_yoW7Gw4rpF
	98KFZ8Gr18XFy29an2qFWDZr1F93yftw4Uury3W3W3ZF98C3sFgFWUK3WYkFyUGw4kJw4I
	q3Wj9ry7WF15CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 5/19/2026 5:28 PM, Ojaswin Mujoo wrote:
> On Mon, May 11, 2026 at 03:23:24PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Introduce initial support for iomap in the buffered I/O path for regular
>> files on ext4.
>>
>>   - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
>>     inode uses iomap instead of buffer_head for buffered I/O
>>   - Add helper ext4_inode_buffered_iomap() to check the flag
>>   - Add new address space operations ext4_iomap_aops with callbacks that
>>     will use generic iomap implementations
>>   - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
>>
>> The following callbacks(read_folio(), readahead(), writepages()) are
>> provided as placeholders and will be implemented in later patches.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Hi Zhang, looks good to me. Just a questions below:

Hi, Ojaswin! Thank you for the review of this series.

>> ---
>>  fs/ext4/ext4.h  |  7 +++++++
>>  fs/ext4/inode.c | 32 ++++++++++++++++++++++++++++++++
>>  2 files changed, 39 insertions(+)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 94283a991e5c..1e27d73d7427 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1972,6 +1972,7 @@ enum {
>>  	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
>>  	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
>>  	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
>> +	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
>>  };
>>  
>>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
>> @@ -2040,6 +2041,12 @@ static inline bool ext4_inode_orphan_tracked(struct inode *inode)
>>  		!list_empty(&EXT4_I(inode)->i_orphan);
>>  }
>>  
>> +/* Whether the inode pass through the iomap infrastructure for buffered I/O */
>> +static inline bool ext4_inode_buffered_iomap(struct inode *inode)
>> +{
>> +	return ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
>> +}
>> +
>>  /*
>>   * Codes for operating systems
>>   */
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index b1ef706987c3..178ac2be37b7 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3908,6 +3908,22 @@ const struct iomap_ops ext4_iomap_report_ops = {
>>  	.iomap_begin = ext4_iomap_begin_report,
>>  };
>>  
>> +static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void ext4_iomap_readahead(struct readahead_control *rac)
>> +{
>> +
>> +}
>> +
>> +static int ext4_iomap_writepages(struct address_space *mapping,
>> +				 struct writeback_control *wbc)
>> +{
>> +	return 0;
>> +}
>> +
>>  /*
>>   * For data=journal mode, folio should be marked dirty only when it was
>>   * writeably mapped. When that happens, it was already attached to the
>> @@ -3994,6 +4010,20 @@ static const struct address_space_operations ext4_da_aops = {
>>  	.swap_activate		= ext4_iomap_swap_activate,
>>  };
>>  
>> +static const struct address_space_operations ext4_iomap_aops = {
>> +	.read_folio		= ext4_iomap_read_folio,
>> +	.readahead		= ext4_iomap_readahead,
>> +	.writepages		= ext4_iomap_writepages,
>> +	.dirty_folio		= iomap_dirty_folio,
>> +	.bmap			= ext4_bmap,
>> +	.invalidate_folio	= iomap_invalidate_folio,
>> +	.release_folio		= iomap_release_folio,
>> +	.migrate_folio		= filemap_migrate_folio,
>> +	.is_partially_uptodate  = iomap_is_partially_uptodate,
>> +	.error_remove_folio	= generic_error_remove_folio,
>> +	.swap_activate		= ext4_iomap_swap_activate,
>> +};
> 
> So one question, for ->release_folio() we are using
> iomap_release_folio() instead of ext4_release_folio() here which doesnt
> make the jbd2_journal_try_to_free_bufferes() call. IIUC this function
> seems to be trying to clean up already checkpointed buffers.
> 
> I wanted to check if ->release_folio() can be called for folios with
> ext4 metadata buffers? (from my limited understanding of
> shrink_folio_list() -> filemap_release_folio() it seems we can) And if
> it can be called, is it okay to skip the
> jbd2_journal_try_to_free_buffers call?

Here, in ->release_folio(), folio->mapping points to inode->i_data (the
file's pagecache), not the block device's pagecache. ext4 metadata
resides in the block device's pagecache, which is at a different layer
than this release_folio callback. So we don't need to call
jbd2_journal_try_to_free_buffers() in the iomap path here.

Thanks,
Yi.

> 
> Regards,
> ojaswin
> 
>> +
>>  static const struct address_space_operations ext4_dax_aops = {
>>  	.writepages		= ext4_dax_writepages,
>>  	.dirty_folio		= noop_dirty_folio,
>> @@ -4015,6 +4045,8 @@ void ext4_set_aops(struct inode *inode)
>>  	}
>>  	if (IS_DAX(inode))
>>  		inode->i_mapping->a_ops = &ext4_dax_aops;
>> +	else if (ext4_inode_buffered_iomap(inode))
>> +		inode->i_mapping->a_ops = &ext4_iomap_aops;
>>  	else if (test_opt(inode->i_sb, DELALLOC))
>>  		inode->i_mapping->a_ops = &ext4_da_aops;
>>  	else
>> -- 
>> 2.52.0
>>

