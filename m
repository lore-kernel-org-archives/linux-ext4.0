Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EEC296BC1
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784725008; cv=none; b=GnXAmlluP1BgWvR4iD1PAztK++JwS9t5WZrW8/KTg8qNsQLNFOqtebq1fi0N4feYTgzwm3OEAKg7ZffXZspW7iWTD1ubBLUxul8TRtZh5ISrV6uxI3rMCMw+VJ1PPkSX48/uAzy9Q/97QvtLTtI7SoAPthdDzsVyX+7ZqedBJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784725008; c=relaxed/simple;
	bh=/Cq5AEg84Z1ItBCBDmZ9kSOzbZx5QmToEVLnmwbBciw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+VwRelzciaqxy3D/dzZjSbCp08V3faubAvhW+QCnI5+e2fxRGyLh4a9M/3CoYShOFFwAgazNQmET2f4o+84hC3xJQvUnB/QSxHVT/jEJ6PszUGNI/EK6D7Iz6KW8br52D0ky3t9FU90gY6OP3uYgNaee8jTOCYp95VfCErABG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMxb7e1C; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMxb7e1C"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84a2dcede83so12192214b3a.3
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 05:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784725005; x=1785329805; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hoYz7PU3lcsGlze6W99YgGlNU5BmFlJ0ejlYyLev+bI=;
        b=MMxb7e1CyYMQHjnP67k7MicoMh7kvjiYWFi8GolPxtvRt7/RsUkWhLXvAKJSouRE8z
         LitdU0ussqkS0wBRvJxJcTRHtdTrc7gHSRNRiaL/lx6nR7IKZcT03mSDF3O5SIiUjUM1
         hBQyjsZ+TV90C8rBr258rw/21dRsw5f7ez3pyC/T9UbBkUXe47PUMXpeDIytnMKYOknd
         tp7e4PgnKaK/gtesF1gzZRRfGaw+s13BAVPeczAgkd4ZNZvHRa9RrmXgejwIU320u7BY
         /gaUQbtBwodKt0OczR8cbqvi5QGlofvuQwZ3V92bensDUS1414tk4x+efoweOkjYDJea
         B1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784725005; x=1785329805;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hoYz7PU3lcsGlze6W99YgGlNU5BmFlJ0ejlYyLev+bI=;
        b=NxvjWT6aVFSjR5Kn1sAqVSAP1Y4XJm5ww0CJNNk6In11dPybtAtP3+ftngBvWnxJYp
         2GgGekFMFiH4ykPMRAPqfcmmdWY3fZdm7GdnqVQZzgoqbBy4RV00lxO+Nyoo5O/YhE3C
         Wuq+otZ157MC4MP9RzLbpLNw0SOdFfG+LJeg3yZNeJ2PftgK3XhhrAADo0dFIlndED4g
         2KBUTsIcq5BVOtZxRBWxQN/HtTRvvjwqprWzEWgDn8yobPtOkjTv1REoAFvGCnu8xv4A
         Ds3XO6DEyDg6xI1bdFIjNLHF8R3pX2g72yn6gnHgeZaw9kMsdhR77J8HCK65mjWv59ew
         jO+A==
X-Gm-Message-State: AOJu0YxOJUYUggLBLskRyHqmyhkqtZhNyunCCt0uJn2aujxrVbk72beh
	/A9N1tFUKoBj8K63BMdxnuSNmUoCKK3/5KISteu+GwbGjsLK9Pjc+VOC
X-Gm-Gg: AR+sD10oU82NcDY4g5Kk6hq5WD/SapJLtc30hRhPiP5obrfkyJDOer+QeJscbv6uoSo
	apm07p9qzI0cDXLEar/Zm0n/2rCxdon5EhmY1Rzn9QBpgpYjNrY9u21gjANSXhc9bylCt5u9hRG
	J/VR8cXHf1VYbG47wb8KCX4vAqyHOwEcGFjNa7dNmd8VsFQwWBFh12S5Ob8sZjEZxILgNf/D/wI
	pUBBnCYqUvp6iXWCSeC9OYot3gFFOhAvK01Vx20+bWL6BouZ/QUeztHo0k7l4UiSwaiHDvq9cKK
	3SWmHOwkAXbPAn2jUW97mxsb5kwfErZe2XoWUq+rmGiOfw+MmZUQoiKV7q7KxzRdbjIOkq06ZHw
	AAf7bbrTIZU9wvzpIZ7BuDmXRGChUiz84RrFLUBl7htAfi9AXTVaR5N4UiZdAB4jcjCcjA+L5KL
	/H3skjq7QH0Wxdb8ow9Ht40w==
X-Received: by 2002:a05:6a00:420e:b0:848:5c00:fa91 with SMTP id d2e1a72fcca58-84c294d4b53mr22231586b3a.38.1784725005250;
        Wed, 22 Jul 2026 05:56:45 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17285deasm1326935b3a.19.2026.07.22.05.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 05:56:44 -0700 (PDT)
Message-ID: <86f0fec6-c84c-4f86-b1f6-1ab7fda20658@gmail.com>
Date: Wed, 22 Jul 2026 20:56:36 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: cache full extents during mapping lookup
To: changfengnan <changfengnan@bytedance.com>,
 Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com
References: <20260720075133.50539-1-changfengnan@bytedance.com>
 <8c443e8f-178f-4411-9027-320a14a40c80@huaweicloud.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.61b2aa58.70d3.491a.bf4d.2ab068c26e69@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.61b2aa58.70d3.491a.bf4d.2ab068c26e69@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/22/2026 11:00 AM, changfengnan wrote:
> 
>> From: "Zhang Yi"<yi.zhang@huaweicloud.com>
>> Date:  Tue, Jul 21, 2026, 15:43
>> Subject:  Re: [PATCH] ext4: cache full extents during mapping lookup
>> To: "Fengnan Chang"<changfengnan@bytedance.com>
>> Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>
>> On 7/20/2026 3:51 PM, Fengnan Chang wrote:
>>> The extent status (ES) tree and extent tree leaf buffers are reclaimed
>>> independently.  An ES entry can be reclaimed while the leaf buffer remains
>>> cached with BH_Verified set.
>>>   
>>> When this happens, ext4_es_lookup_extent() misses.  Since the leaf buffer
>>> is already verified, __read_extent_tree_block() returns it without calling
>>> ext4_cache_extents().  ext4_ext_map_blocks() returns the part of the extent
>>> covered by the request, and ext4_map_query_blocks() caches only that range.
>>> Reads to other blocks in the same extent then keep missing the ES tree and
>>> walking the extent tree.
>>>   
>>> Cache the full extent in ext4_ext_map_blocks() before the returned mapping
>>> is limited to the requested range.  Check the ES tree under the read lock
>>> first.  If the full extent is not there, ext4_es_cache_extent() checks
>>> again under the write lock before inserting it.
>>>   
>>> Do not do this when ext4_ext_map_blocks() is called with
>>> EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE.  NOCACHE paths can change extent
>>> mappings, so caching ranges outside the request can leave stale ES entries.
>>> Cache both written and unwritten extents, as ext4_cache_extents() does.
>>>   
>>> Tested with fio 4K random direct reads using libaio at iodepth 128 on a
>>> 128 GiB file with 208 on-disk extents.  The results are averages of three
>>> 10-second runs:
>>>   
>>>                   before reclaim    after reclaim
>>>    unpatched        419.6k IOPS       274.6k IOPS
>>>    patched          426.1k IOPS       423.7k IOPS
>>>   
>>> Average completion latency went from 303.02 to 462.78 us without the patch,
>>> and from 298.36 to 300.07 us with the patch.
>>>   
>>> No latency regression was seen in A/B test.
>>>   
>>> Suggested-by: Jan Kara <jack@suse.cz>
>>> Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
>>> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
>>   
>> Thank you for the patch! This overall looks good to me, just some minor
>> suggestions below.
>>   
>>> ---
>>>   fs/ext4/extents.c        |  9 +++++++++
>>>   fs/ext4/extents_status.c | 33 +++++++++++++++++++++++++++++++++
>>>   fs/ext4/extents_status.h |  3 +++
>>>   3 files changed, 45 insertions(+)
>>>   
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index 91c97af64b317..f43dd9c3bc44e 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -4310,6 +4310,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>>                   ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
>>>                   ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
>>>                   unsigned short ee_len;
>>> +                unsigned int status;
>>>   
>>>   
>>>                   /*
>>> @@ -4317,6 +4318,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>>                    * we split out initialized portions during a write.
>>>                    */
>>>                   ee_len = ext4_ext_get_actual_len(ex);
>>> +                status = ext4_ext_is_unwritten(ex) ?
>>> +                         EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>>>   
>>>                   trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
>>>   
>>> @@ -4328,6 +4331,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>>                           ext_debug(inode, "%u fit into %u:%d -> %llu\n",
>>>                                     map->m_lblk, ee_block, ee_len, newblock);
>>>   
>>> +                        if (!(flags & (EXT4_GET_BLOCKS_CREATE |
>>> +                                       EXT4_EX_NOCACHE)))
>>> +                                ext4_es_cache_extent_if_missing(inode, ee_block,
>>> +                                                                ee_len, ee_start,
>>> +                                                                status);
>>   
>> After this patch, I think the calls to ext4_es_cache_extent() in
>> ext4_map_query_blocks_next_in_leaf() and ext4_map_query_blocks() can
>> also be replaced with this helper.
>>   
>>> +
>>>                           /*
>>>                            * If the extent is initialized check whether the
>>>                            * caller wants to convert it to unwritten.
>>> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
>>> index 6e4a191e82191..83fe2068ab656 100644
>>> --- a/fs/ext4/extents_status.c
>>> +++ b/fs/ext4/extents_status.c
>>> @@ -1082,6 +1082,39 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>>>                              ext4_es_pblock(&chkes), ext4_es_status(&chkes));
>>>   }
>>>   
>>> +/*
>>> + * Avoid taking i_es_lock for writing if the entire extent is already cached.
>>> + * ext4_es_cache_extent() rechecks under the write lock if the cache changes
>>> + * after this read-side check.
>>> + */
>>> +void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t lblk,
>>   
>> I'd prefer to move this logic into ext4_es_cache_extent() and add a
>> parameter(e.g., read_search) to control whether to do pre-search unbder
>> the read lock. If the extent is likely to already exist on the status
>> tree, we can pass 1. Sounds good?
> 
> ext4_es_cache_extent add a parameter  to control whether to do pre-search
> sounds good.
> I have some questions about when to perform a pre-search.
> Are you meaning that a pre-search should also be performed when
> ext4_map_query_blocks_next_in_leaf and ext4_map_query_blocks call
> ext4_es_cache_extent ?
> ext4_map_query_blocks_next_in_leaf is ok , but I think it only makes sense
> to perform a pre-search for ext4_es_cache_extent in ext4_map_query_blocks
> when in extent mode, because in extent mode, the entire leaf is cached, so
> it’s likely that the extent already exists—but this isn’t the case in indirect mode.
> Right ?

Yes.

> 
> I’d like to make the following change:
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91c97af64b317..2ffb5027aa1ee 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -537,12 +537,12 @@ static void ext4_cache_extents(struct inode *inode,
>   
>                   if (prev && (prev != lblk))
>                           ext4_es_cache_extent(inode, prev, lblk - prev, ~0,
> -                                             EXTENT_STATUS_HOLE);
> +                                             EXTENT_STATUS_HOLE, false);
>   
>                   if (ext4_ext_is_unwritten(ex))
>                           status = EXTENT_STATUS_UNWRITTEN;
>                   ext4_es_cache_extent(inode, lblk, len,
> -                                     ext4_ext_pblock(ex), status);
> +                                     ext4_ext_pblock(ex), status, false);
>                   prev = lblk + len;
>           }
>   }
> @@ -4239,7 +4239,8 @@ static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
>   insert_hole:
>           /* Put just found gap into cache to speed up subsequent requests */
>           ext_debug(inode, " -> %u:%u\n", hole_start, len);
> -        ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE);
> +        ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE,
> +                             false);
>   
>           /* Update hole_len to reflect hole size after lblk */
>           if (hole_start != lblk)
> @@ -4310,6 +4311,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>                   ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
>                   ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
>                   unsigned short ee_len;
> +                unsigned int status;
>   
>   
>                   /*
> @@ -4317,6 +4319,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>                    * we split out initialized portions during a write.
>                    */
>                   ee_len = ext4_ext_get_actual_len(ex);
> +                status = ext4_ext_is_unwritten(ex) ?
> +                         EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>   
>                   trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
>   
> @@ -4328,6 +4332,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>                           ext_debug(inode, "%u fit into %u:%d -> %llu\n",
>                                     map->m_lblk, ee_block, ee_len, newblock);
>   
> +                        if (!(flags & (EXT4_GET_BLOCKS_CREATE |
> +                                       EXT4_EX_NOCACHE)))
> +                                ext4_es_cache_extent(inode, ee_block, ee_len,
> +                                                     ee_start, status,
> +                                                     true);
> +
>                           /*
>                            * If the extent is initialized check whether the
>                            * caller wants to convert it to unwritten.
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..5a03878b06160 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1023,7 +1023,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>    */
>   void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>                             ext4_lblk_t len, ext4_fsblk_t pblk,
> -                          unsigned int status)
> +                          unsigned int status, bool pre_search)
>   {
>           struct extent_status *es;
>           struct extent_status chkes, newes;
> @@ -1043,6 +1043,21 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>   
>           BUG_ON(end < lblk);
>   
> +        /*
> +         * Avoid taking i_es_lock for writing if the entire extent is already
> +         * cached. The write-locked search below rechecks after a miss.
> +         */
> +        if (pre_search) {
> +                read_lock(&EXT4_I(inode)->i_es_lock);
> +                es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
> +                if (es && es->es_lblk <= lblk && ext4_es_end(es) >= end &&
> +                    !__es_check_extent_status(es, status, NULL)) {
> +                        read_unlock(&EXT4_I(inode)->i_es_lock);
> +                        return;
> +                }
> +                read_unlock(&EXT4_I(inode)->i_es_lock);
> +        }
> +
>           write_lock(&EXT4_I(inode)->i_es_lock);
>           es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
>           if (es && es->es_lblk <= end) {
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index f3396cf32b446..c2da72e3c82ba 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -139,7 +139,7 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>                                     bool delalloc_reserve_used);
>   extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>                                    ext4_lblk_t len, ext4_fsblk_t pblk,
> -                                 unsigned int status);
> +                                 unsigned int status, bool pre_search);
>   extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>                                     ext4_lblk_t len);
>   extern void ext4_es_find_extent_range(struct inode *inode,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b2..341b7c649e133 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -523,7 +523,7 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
>   
>           if (retval <= 0) {
>                   ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -                                     map->m_pblk, status);
> +                                     map->m_pblk, status, true);
>                   return map->m_len;
>           }
>   
> @@ -546,11 +546,11 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
>                           status == status2) {
>                   ext4_es_cache_extent(inode, map->m_lblk,
>                                        map->m_len + map2.m_len, map->m_pblk,
> -                                     status);
> +                                     status, true);
>                   map->m_len += map2.m_len;
>           } else {
>                   ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -                                     map->m_pblk, status);
> +                                     map->m_pblk, status, true);
>           }
>   
>           return map->m_len;
> @@ -562,6 +562,8 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
>           unsigned int status;
>           int retval;
>           unsigned int orig_mlen = map->m_len;
> +        bool pre_search = ext4_test_inode_flag(inode,
> +                                              EXT4_INODE_EXTENTS);
>   
>           flags &= EXT4_EX_QUERY_FILTER;
>           if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> @@ -593,7 +595,7 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
>                   status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>                                   EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>                   ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -                                     map->m_pblk, status);
> +                                     map->m_pblk, status, pre_search);

It would be helpful to add a comment here. Otherwise, this looks good to
me.

Thanks,
Yi.

>           } else {
>                   retval = ext4_map_query_blocks_next_in_leaf(handle, inode, map,
>                                                               orig_mlen);
> -- 
> 
>>   
>> Thanks,
>> Yi.
>>   
>>> +                                     ext4_lblk_t len, ext4_fsblk_t pblk,
>>> +                                     unsigned int status)
>>> +{
>>> +        struct extent_status *es;
>>> +        ext4_lblk_t end;
>>> +        bool cached;
>>> +
>>> +        if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
>>> +                return;
>>> +
>>> +        if (!len)
>>> +                return;
>>> +
>>> +        end = lblk + len - 1;
>>> +        if (WARN_ON_ONCE(end < lblk))
>>> +                return;
>>> +
>>> +        read_lock(&EXT4_I(inode)->i_es_lock);
>>> +        es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
>>> +        cached = es && es->es_lblk <= lblk && ext4_es_end(es) >= end &&
>>> +                 !__es_check_extent_status(es, status, NULL);
>>> +        read_unlock(&EXT4_I(inode)->i_es_lock);
>>> +
>>> +        if (!cached)
>>> +                ext4_es_cache_extent(inode, lblk, len, pblk, status);
>>> +}
>>> +
>>>   /*
>>>    * ext4_es_lookup_extent() looks up an extent in extent status tree.
>>>    *
>>> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
>>> index f3396cf32b446..d8fab84911352 100644
>>> --- a/fs/ext4/extents_status.h
>>> +++ b/fs/ext4/extents_status.h
>>> @@ -140,6 +140,9 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>>>   extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>>>                                    ext4_lblk_t len, ext4_fsblk_t pblk,
>>>                                    unsigned int status);
>>> +void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t lblk,
>>> +                                     ext4_lblk_t len, ext4_fsblk_t pblk,
>>> +                                     unsigned int status);
>>>   extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>>>                                     ext4_lblk_t len);
>>>   extern void ext4_es_find_extent_range(struct inode *inode,
>>   
> 

