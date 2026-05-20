Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3848003D
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 02:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779245423; cv=none; b=hgPoVvPashRW6yTRqEMfigbLDbTREpO+6Z7X6gguk59P3OQdpX/7svMpo/KXI+hSlbiNKP5CUcYSAyj4+Vb2cRA7XcVodBP5rT3AaONcop3Wj0kzwc57lTy6OpC0Lsy1e/W3vzrFzrVgekmMxt1bhfExLYdDIfd6OjpBQN1gCYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779245423; c=relaxed/simple;
	bh=rIf1BZePprDazzVrrY4G6yrBhMlczOfEyID6WJd6pD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eIRoR9zMc8xQOABqNLcxCB7p27bhc1QWLzl+AJ1UtBAy+fJ0hv1iFFrpJcrJbugU92KwypJ+fNiXigSZUzNx4hSrdCK8u6w0VPG0WB7efr/QHB4fpkx3yD+g2wvfoKloDRIwRP0Oz7T61M+zBNXfiGCWjJ0wDF1KdVKYRSb3ao4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jDYyqVv3; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDYyqVv3"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-836ebdeb969so1981564b3a.3
        for <linux-ext4@vger.kernel.org>; Tue, 19 May 2026 19:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779245421; x=1779850221; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jX5g9eYxBvGu4vyTxEUAFz7H4bpv/vUCrQniZV0N4y8=;
        b=jDYyqVv36GShWovpNQtobgKCNZTBpiMGLVc+2A+8Qj2W4+l4SAXMwLijbr+xuRhhzj
         vLS6npSlVNVDvtpxdLvKQOSDPoqKvKMX+sys5+ZQCnpMTISsLknbUGiOJwXJ8qvZ1MiU
         rqI1WI60xGkmXRAh4OX+ZRF8J4Cni9VPCtEc/98PfW4bhGJEeOiK+MRrQCgOzc1N2g5i
         Ileds2WF0sNrFfvV/Vb9icOAPtLKxqT01eLrHZs7Sz9NCc+8Iy7pL+zdzMRoCic9okbx
         z5WRdPOI8nyNI6fjq9/OfdrOrvLovqoZewlmAbIm8IeOPnIZn9lFA7l7gg9N0mVj/JY5
         DxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779245421; x=1779850221;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jX5g9eYxBvGu4vyTxEUAFz7H4bpv/vUCrQniZV0N4y8=;
        b=YhlkUEoGvBk/JbNZKYXaIVEHa1qT6A6WAttuyjRZtiwKnrEIRTkXZCqJzVYiVJLtLe
         zTU1E2QMkkVvM4DR75jj3GCPNQwZYzpRXfcSSSrPtqhAUn6pzHBeGuP8TBTGnFeVNmT5
         4h8bj1diRitGptdQe/r3ESRPox4unnplq3jsoUtTFIgCo+9w560PWmn5ujUjxDCAv126
         rxtGLdwfVLBN06/e+pRNC0unh5rEf+LVO1yZXNYTREnOJhSvJHnJOnjxAEEWlqgMhIiO
         zZiDb2K6HBLc6U3PUM9gvZT8MWqcHHZ0dsitcllwnkimuTSG94cKtrfUy849Z6mVC+2c
         0INw==
X-Gm-Message-State: AOJu0YzxuboHN530u+GJ+X6LuPY00POs7xdh2n9cWbBF9IdSCXGw1KgJ
	Q8NmwN9/p33S/zVd0iKNubQUlotPQLYtSaULymjt5xmWEfO13hqmNBbL
X-Gm-Gg: Acq92OGvdisTjBE4wndS125O1JxhghH7xbzIJDNvOqoJuN5DzhXZvtawVTVy0Y4SrVT
	GtN4bCMDp/ZpNG3+PF4LqlBHwo3aq2yZopLoV8k3qpnHOCW/QYW7xVV7YtDhh2qqLSubEJJXfSF
	YEDMAFw6L31YQ524cQFQpdTGHnlqE5HN4j/5zD87XnqlhTLp7xOiIADTUxGDF8dG4NDIbvvO4bb
	l9Wp97kjLtRfk+03vZaLQnaSclLN4I8U3WpIfp+MRbBs8V0U9O7K5xn2Zrgw7CazkK/lEXHc4kb
	MaVaA9cVHdGngmRTyTkodEEs/LNTICyyDze/tPhysnEna/PSXWj9/Q5ekrJquh1BS0WQFt0gseG
	D3CUG4KSwFmMtkVMn/s4ItBI6/Jlo2YreTSHxFfvs5WEyg4cDbwAtS52UxMrw3RG/3j4Hc20PgF
	4wPkMeHu3OPCAV5cpspDIfWMP76PrCl/bT+I4HguSysKA=
X-Received: by 2002:a05:6a00:4ac2:b0:82c:66f2:1226 with SMTP id d2e1a72fcca58-83f33d5494bmr21377555b3a.38.1779245421287;
        Tue, 19 May 2026 19:50:21 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8413ac7b2b2sm35462b3a.14.2026.05.19.19.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 19:50:20 -0700 (PDT)
Message-ID: <51b3f8d5-b90f-49fe-b93e-171268db9ff8@gmail.com>
Date: Wed, 20 May 2026 10:49:50 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/23] ext4: add iomap address space operations for
 buffered I/O
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-5-yi.zhang@huaweicloud.com>
 <agwtJq5-B2E-t7zT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <236657df-71f2-446d-b44b-39865219a850@huaweicloud.com>
 <agyVb1U0US8PVgqo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <agyVb1U0US8PVgqo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/2026 12:53 AM, Ojaswin Mujoo wrote:
> On Tue, May 19, 2026 at 08:35:51PM +0800, Zhang Yi wrote:
>> On 5/19/2026 5:28 PM, Ojaswin Mujoo wrote:
>>> On Mon, May 11, 2026 at 03:23:24PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> Introduce initial support for iomap in the buffered I/O path for regular
>>>> files on ext4.
>>>>
>>>>    - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
>>>>      inode uses iomap instead of buffer_head for buffered I/O
>>>>    - Add helper ext4_inode_buffered_iomap() to check the flag
>>>>    - Add new address space operations ext4_iomap_aops with callbacks that
>>>>      will use generic iomap implementations
>>>>    - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
>>>>
>>>> The following callbacks(read_folio(), readahead(), writepages()) are
>>>> provided as placeholders and will be implemented in later patches.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>>
>>> Hi Zhang, looks good to me. Just a questions below:
>>
>> Hi, Ojaswin! Thank you for the review of this series.
>>
>>>> ---
>>>>   fs/ext4/ext4.h  |  7 +++++++
>>>>   fs/ext4/inode.c | 32 ++++++++++++++++++++++++++++++++
>>>>   2 files changed, 39 insertions(+)
>>>>
>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>> index 94283a991e5c..1e27d73d7427 100644
>>>> --- a/fs/ext4/ext4.h
>>>> +++ b/fs/ext4/ext4.h
>>>> @@ -1972,6 +1972,7 @@ enum {
>>>>   	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
>>>>   	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
>>>>   	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
>>>> +	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
>>>>   };
>>>>   
>>>>   #define EXT4_INODE_BIT_FNS(name, field, offset)				\
>>>> @@ -2040,6 +2041,12 @@ static inline bool ext4_inode_orphan_tracked(struct inode *inode)
>>>>   		!list_empty(&EXT4_I(inode)->i_orphan);
>>>>   }
>>>>   
>>>> +/* Whether the inode pass through the iomap infrastructure for buffered I/O */
>>>> +static inline bool ext4_inode_buffered_iomap(struct inode *inode)
>>>> +{
>>>> +	return ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
>>>> +}
>>>> +
>>>>   /*
>>>>    * Codes for operating systems
>>>>    */
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index b1ef706987c3..178ac2be37b7 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -3908,6 +3908,22 @@ const struct iomap_ops ext4_iomap_report_ops = {
>>>>   	.iomap_begin = ext4_iomap_begin_report,
>>>>   };
>>>>   
>>>> +static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
>>>> +{
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static void ext4_iomap_readahead(struct readahead_control *rac)
>>>> +{
>>>> +
>>>> +}
>>>> +
>>>> +static int ext4_iomap_writepages(struct address_space *mapping,
>>>> +				 struct writeback_control *wbc)
>>>> +{
>>>> +	return 0;
>>>> +}
>>>> +
>>>>   /*
>>>>    * For data=journal mode, folio should be marked dirty only when it was
>>>>    * writeably mapped. When that happens, it was already attached to the
>>>> @@ -3994,6 +4010,20 @@ static const struct address_space_operations ext4_da_aops = {
>>>>   	.swap_activate		= ext4_iomap_swap_activate,
>>>>   };
>>>>   
>>>> +static const struct address_space_operations ext4_iomap_aops = {
>>>> +	.read_folio		= ext4_iomap_read_folio,
>>>> +	.readahead		= ext4_iomap_readahead,
>>>> +	.writepages		= ext4_iomap_writepages,
>>>> +	.dirty_folio		= iomap_dirty_folio,
>>>> +	.bmap			= ext4_bmap,
>>>> +	.invalidate_folio	= iomap_invalidate_folio,
>>>> +	.release_folio		= iomap_release_folio,
>>>> +	.migrate_folio		= filemap_migrate_folio,
>>>> +	.is_partially_uptodate  = iomap_is_partially_uptodate,
>>>> +	.error_remove_folio	= generic_error_remove_folio,
>>>> +	.swap_activate		= ext4_iomap_swap_activate,
>>>> +};
>>>
>>> So one question, for ->release_folio() we are using
>>> iomap_release_folio() instead of ext4_release_folio() here which doesnt
>>> make the jbd2_journal_try_to_free_bufferes() call. IIUC this function
>>> seems to be trying to clean up already checkpointed buffers.
>>>
>>> I wanted to check if ->release_folio() can be called for folios with
>>> ext4 metadata buffers? (from my limited understanding of
>>> shrink_folio_list() -> filemap_release_folio() it seems we can) And if
>>> it can be called, is it okay to skip the
>>> jbd2_journal_try_to_free_buffers call?
>>
>> Here, in ->release_folio(), folio->mapping points to inode->i_data (the
>> file's pagecache), not the block device's pagecache. ext4 metadata
>> resides in the block device's pagecache, which is at a different layer
>> than this release_folio callback. So we don't need to call
>> jbd2_journal_try_to_free_buffers() in the iomap path here.
> 
> Hi Yi,
> 
> Thanks for clarify and yes, thats what I was missing! So this
> ->release_folio() is only for data folios. So I guess the
> jbd2_journal_try_to_free_buffers() is mostly to handle data=journal
> case?

Yes, that's my understanding as well. Meanwhile, the comment for the
jbd2_journal_try_to_free_buffers() function looks quite outdated and
needs to be updated.

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 4885903bbd10..239bcf88ed1c 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2139,38 +2139,23 @@ static void __jbd2_journal_unfile_buffer(struct 
journal_head *jh)
  }

  /**
- * jbd2_journal_try_to_free_buffers() - try to free page buffers.
+ * jbd2_journal_try_to_free_buffers() - try to free folio buffers.
   * @journal: journal for operation
   * @folio: Folio to detach data from.
   *
- * For all the buffers on this page,
- * if they are fully written out ordered data, move them onto BUF_CLEAN
- * so try_to_free_buffers() can reap them.
+ * For each buffer_head on @folio, if the buffer has a journal_head but
+ * is not attached to a running or committing transaction, try to remove
+ * it from the checkpoint list.  This is needed for data=journal mode
+ * where data buffers are journaled: once they are checkpointed, the
+ * journal_head can be detached and the buffer freed.  If any buffer is
+ * still attached to a transaction, the folio cannot be released and we
+ * bail out.  Otherwise we call try_to_free_buffers() to detach all
+ * buffer_heads from the folio.
   *
- * This function returns non-zero if we wish try_to_free_buffers()
- * to be called. We do this if the page is releasable by 
try_to_free_buffers().
- * We also do it if the page has locked or dirty buffers and the caller 
wants
- * us to perform sync or async writeout.
+ * For data=ordered and writeback modes, data buffers never have
+ * journal_heads, so this degenerates to a plain try_to_free_buffers().
   *
- * This complicates JBD locking somewhat.  We aren't protected by the
- * BKL here.  We wish to remove the buffer from its committing or
- * running transaction's ->t_datalist via __jbd2_journal_unfile_buffer.
- *
- * This may *change* the value of transaction_t->t_datalist, so anyone
- * who looks at t_datalist needs to lock against this function.
- *
- * Even worse, someone may be doing a jbd2_journal_dirty_data on this
- * buffer.  So we need to lock against that.  jbd2_journal_dirty_data()
- * will come out of the lock with the buffer dirty, which makes it
- * ineligible for release here.
- *
- * Who else is affected by this?  hmm...  Really the only contender
- * is do_get_write_access() - it could be looking at the buffer while
- * journal_try_to_free_buffer() is changing its state.  But that
- * cannot happen because we never reallocate freed data as metadata
- * while the data is part of a transaction.  Yes?
- *
- * Return false on failure, true on success
+ * Return: true if the folio's buffers were freed, false otherwise
   */
  bool jbd2_journal_try_to_free_buffers(journal_t *journal, struct folio 
*folio)
  {

Thanks,
Yi.



