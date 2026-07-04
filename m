Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A2217F33
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jul 2026 01:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783128775; cv=none; b=iEQF7rheEv0d0AkMfZlUO7ZPxqECL6I8PxLn6TFsbuT+4TBmG8LE/Q0fBCKsTLaCJe3cyWQsJYkBJ7C7QDJZtZbTIUQLOHoFbMqfbLSwtGGLUPe2ZbUf4SIIDrn822CSWk6ZqM8wesT97hM9aqigMzLUOMGQc/k7D3dL3ahink0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783128775; c=relaxed/simple;
	bh=PI6QHQ10gncI8iXr+eap0a9BBdLmaZP18K9Ipw+Rkzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMcIk8PDTlDRh7fKme/lal35uZqzCazKwLtJOBPAdbgwnDfE2JCAA2Z7FWxBFJulyzXV+gM3XACSN4UK01NjDoeYw+YJpvqwZBf4usWMwhJ4j02o3tUX04UzXMYjKQKzu2DfrJZ+orK0dfZ+vXONmykLYjtL4HW+vPOV2ccnqlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xl3byqru; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xl3byqru"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ca1479dfe0so12007275ad.1
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2026 18:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783128773; x=1783733573; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2mKH1GnYzZzalxj3rDwtaiSEPq9o/l0Xt0lGrmA5F2k=;
        b=Xl3byqruJVPtHR/FMZteUkSxqVZoENoexhKjP7yk2l0t0KOft+DWjzxBQPJ008mfQp
         OpcvDntDDn4r3NkyPJvGrGXbf4ygn5VfbwHUISZxENdZDJeNKV+/qdxpOkcImhyOiy5c
         FLLtAK2OHqeLOCGkdBSggL4CoA0zPQ0b0m3Yd8/xo1Ap1VFilEzz/lOmp2koWgYjcZpr
         VuekDZwgCA6J0b1PbA0kaYda+u6uHrJjzGnzqtNaejW8AChYJe1EVzvyFB9Sw1jLsUVv
         +gc/EcFh6LT5RN3KTuyA5jfHPd7W57EieAAa6kh6gGdcynbYB5TVFRCMgivfHLsmS/PS
         OxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783128773; x=1783733573;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mKH1GnYzZzalxj3rDwtaiSEPq9o/l0Xt0lGrmA5F2k=;
        b=diYXwjZ3KJkhhyOtSj+Lv7iHU+AjmhzFJR9o6oeeuTTVrjMI6DW43sLasbphPAEAnR
         RZHI1ahTN/hVGSalnXeFcDwfa/TF2EvkAtm8qQhA8AATqH1Xg1Iq3p6TqLS+pc1j1iyw
         hdCAm1SGKE7neHBrI1RO/AL+TAFgFreYPVZje4XS2U+zBM/w4mNQlz2Lna9EnW5Ibt8L
         wvDo78i1J3G+Vsu0S/ScsLjOMtiFlbxrdueWI2Rg8HxgCbLNUagT87MQYCoEZ++fLNt1
         OD72f76sojH86lHG72V6+KUYfZR7anEHGGjJNoTBos9YMPbaLz+OcyTo8k5JlIF+rb8Y
         lpjQ==
X-Gm-Message-State: AOJu0YxX/RzZdB3AZEJjFdpGVOml57fDDZLb2kmYabvxYuPILYRAiX3g
	k+PPUJWiJzLIVz9so9su7pWjndwDjlmmP+QCDqL2rroFXdH5YrZ/J63n
X-Gm-Gg: AfdE7cnMy5GXxH0zupx1goGzuXQUeB1KVHXbTJ7TA0ope4H6Zyhbj3BBV7hY9efRzrf
	JqRjfMBGvNh1HSleQ8A3ID8quglURZs2dEXGYjMXMhhtEZgPt3SlL17F+foivYq6MF8QQPoKfYD
	24z5sSDR09Rj2jPUtL1pBpq6puSCnE4db4kAg1Wq5jbZaJLu1Nrt5EVHYJygzh+ekt/dX4d7a70
	85eynoh6wDRfaK8XU4pyJSZbBvI3zG+GrHlf/skOSuPumhNK0cTcD+8R6jGynRgHPrg3D0twhv7
	GQF1/CqnzLiwBb3pX/dQiXpa/1HwhlT6VF3+3FFoBDeEiitEX/qKYkva1arncWkgaj5uD3VTygf
	jtPXxdOowfUUSjrZPwLe5KbzTicJO6rup0t9gIAR1vquHbc8+TuxjXnppzRovaBR55WLihc+HAy
	4CXpXXiwoiMiOPRHxU/lORxeK1mB+YVvG3
X-Received: by 2002:a17:902:e790:b0:2c8:1f58:55dd with SMTP id d9443c01a7336-2cbb808b0b0mr14513745ad.9.1783128773001;
        Fri, 03 Jul 2026 18:32:53 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6bd7611sm16419865ad.0.2026.07.03.18.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 18:32:52 -0700 (PDT)
Message-ID: <7e2c6b5f-6135-4772-9618-e064f8a59ee0@gmail.com>
Date: Sat, 4 Jul 2026 09:32:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, chengzhihao1@huawei.com, yangerkun@huawei.com
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-3-yizhang089@gmail.com>
 <qpxvjsdnq6jgigjnwzkxny6lms6gi6t4bq5l33rr2f6m6l4oum@5e6ayymrgcbd>
 <a54c9df2-63e6-41ad-b32f-54d2f0356d5c@gmail.com>
 <5xgyaw3ufsymz7tqoyrkwo64a2uup75hnuaudtrejozhb2qnox@owzep3gkgf2v>
 <89a20f31-39e5-4592-9bc5-d444b6c1c7f4@huaweicloud.com>
 <qbrrym4b6tsstu5lqdlxvwp67tvkfp4xufre6v7llan7xgiw3k@qieeaqvt75ns>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <qbrrym4b6tsstu5lqdlxvwp67tvkfp4xufre6v7llan7xgiw3k@qieeaqvt75ns>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/4/2026 12:01 AM, Jan Kara wrote:
> On Fri 03-07-26 11:39:03, Zhang Yi wrote:
>> On 7/3/2026 12:43 AM, Jan Kara wrote:
>>> On Thu 02-07-26 22:40:17, Zhang Yi wrote:
>>>> On 7/2/2026 5:53 PM, Jan Kara wrote:
>>>>> On Wed 01-07-26 22:20:05, yizhang089@gmail.com wrote:
>>>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>>>
>>>>>> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
>>>>>> buffers, but the conditions that lead to this are not obvious from the
>>>>>> code alone. Document this behavior to clarify the return value, so that
>>>>>> readers do not mistakenly assume that only holes result in a NULL
>>>>>> return.
>>>>>>
>>>>>> Also update the inline comment following the ext4_get_block() call to
>>>>>> reflect this: both holes and clean unwritten buffers fall through to the
>>>>>> "nothing to do" path.
>>>>>>
>>>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>>>> ---
>>>>>>    fs/ext4/inode.c | 6 +++++-
>>>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>>>> index c2c2d6ac7f3d..0b31fa873743 100644
>>>>>> --- a/fs/ext4/inode.c
>>>>>> +++ b/fs/ext4/inode.c
>>>>>> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
>>>>>>     * because it might have data in pagecache (eg, if called from ext4_zero_range,
>>>>>>     * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>>>>>>     * racing writeback can come later and flush the stale pagecache to disk.
>>>>>> + *
>>>>>> + * Return the loaded bh if it actually needs zeroing - in written, dirty
>>>>>> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
>>>>>> + * a clean unwritten block).
>>>>>>     */
>>>>>
>>>>> Great that you're adding this comment because when I was reading previous
>>>>> patch, I've spent like 10 minutes trying to figure that out :). But as far
>>>>> as I'm reading the code, ext4_load_tail_bh() will return the unwritten bh
>>>>> even if it is clean - map_bh() in _ext4_get_block() will set
>>>>> buffer_mapped() even for unwritten extent. What am I missing? BTW, it also
>>>>> seems to be ext4_load_tail_bh() could attempt to ext4_read_bh_lock() on
>>>>> unwritten bh if things align wrongly...
>>>>>
>>>>> 								Honza
>>>>
>>>> Thank you for the review!
>>>>
>>>> Please note the ext4_update_bh_state(bh, map.m_flags) call in
>>>> _ext4_get_block() — it restores the mapped flag back to unwritten. As a
>>>> result, the !buffer_mapped(bh) check will evaluate to true for a clean
>>>> unwritten block, the function will return NULL.
>>>
>>> Argh, right. But ext4_ext_map_blocks() sets both BH_Unwritten and BH_Mapped
>>> in the returned map->m_flags for unwritten extents. So I think my comment
>>> still applies.
>>
>> Because ext4_get_block() is called with create = 0, this is purely a
>> lookup operation. Therefore, in ext4_ext_map_blocks() ->
>> ext4_ext_handle_unwritten_extents(), only EXT4_MAP_UNWRITTEN is set,
>> and EXT4_MAP_MAPPED is not (please see the branch where
>> if (flags & EXT4_GET_BLOCKS_CREATE) == 0)). So at this point, whether
>> the lookup is served from the extent status cache or from the on-disk
>> query, it works correctly now.
> 
> Aah, now I remember. Yes, we have a catch in the mapping code like that.
> Thanks for reminding me again. Now back to my original question: So
> ext4_load_tail_bh() returns unwritten bh when it is dirty because someone
> must have called ext4_get_block() on it with EXT4_GET_BLOCKS_CREATE and at
> that point we set the BH_Mapped flag on it? 

Yes.

> Subtle... It would be worth to
> write this explanation to that comment as well.

OK, sure, I will add this in my next iteration.

> 
>>> Plus there's a very strange inconsistency between this and
>>> the lookup in extent status tree in ext4_map_blocks() where (as you
>>> indicate) we only set BH_Unwritten but *not* BH_Mapped. AFAICT there's
>>> something buggy in here :) Note that when we don't set BH_Mapped flag e.g.
>>> from ext4_get_block_unwritten() (which gets used when delalloc is disabled),
>>> then writes to unwritten extent will get lost because
>>> ext4_bio_write_folio() will just treat them as holes...
>>
>> In fact, there is no real problem here. For the write path that gets an
>> unwritten block, EXT4_GET_BLOCKS_UNWRIT_EXT and
>> EXT4_GET_BLOCKS_CREATE are always passed together. This ensures that
>> even if we find the unwritten extent in the extent status cache, we
>> still call ext4_map_create_blocks() (due to EXT4_GET_BLOCKS_CREATE)
>> and go through ext4_ext_handle_unwritten_extents(). Inside that
>> function, because the flags contain EXT4_GET_BLOCKS_UNWRIT_EXT,
>> EXT4_MAP_MAPPED is set. So for the write path, ext4_bio_write_folio()
>> still writes back correctly.
>>
>> That said, the semantic inconsistency between the lookup-only and
>> allocation paths has been bothering me for a while. I had to be very
>> careful about this when developing the buffered I/O iomap path, because
>> this semantics also differs from the iomap infrastructure. In iomap, for
>> an unwritten extent, IOMAP_UNWRITTEN and IOMAP_MAPPED are not set
>> simultaneously; IOMAP_MAPPED always represents a written extent. The
>> good news is that this conversion is not complicated.
>>
>> I asked an agent to look into the historical reasons, and here is what
>> he told me:
>>
>>    When ext4 introduced fallocate + delalloc in 2008-2009, it followed
>>    the XFS convention that "unwritten is not mapped." However, ext4's
>>    writeback path (mpage_da_submit_io) depended on BH_MAPPED to issue
>>    I/O, which meant that unwritten buffers would never be written out.
>>    Commit bf068ee266f9 was the first fix - it converted unwritten to
>>    mapped during the writepages stage. Commit 29fa89d08894 was the
>>    second fix - it made unwritten carry mapped at the write-begin stage.
>>    Commit 2a8964d63d50 was a revert patch - it cleared the unwritten
>>    flag in the create = 1 path to avoid duplicate get_block() calls.
>>
>>    Then the extent status cache was introduced in 2013. Commits
>>    a25a4e1a5d5d (Zheng Liu, 2013-02) and d100eef2440f (2013) added the
>>    ES-cache lookup path. In that path, ext4_es_is_unwritten returns
>>    EXT4_MAP_UNWRITTEN without EXT4_MAP_MAPPED - this was not a new
>>    design decision, but rather a continuation of the old 2009 convention
>>    that "unwritten is not mapped." Zheng Liu's commit message did not
>>    discuss whether MAPPED should be set at the same time; it only said
>>    "ext4_map_blocks needs to use this flag to determine the extent
>>    status." He was simply implementing the ES-cache lookup, and the
>>    status semantics followed the old implementation.
>>
>>    The comment in ext4_map_blocks() - which says "if blocks have been
>>    preallocated ext4_ext_map_blocks() returns with buffer head unmapped"
>>    - was inherited from Aneesh's 2009 code. It was not a new decision
>>    made in 2013.
>>
>> So my understanding is that this inconsistency in ext4_map_blocks() is
>> a historical legacy problem. There are many places where handling these
>> two flags is also semantically ambiguous. Some may treat those with the
>> BH_mapped flag set as written, such as ext4_load_tail_bh(). Therefore,
>> setting the mapped flag may cause many issues, and it can only be done
>> by setting the unwritten flag when performing a query. If I am wrong
>> about any of this, please correct me.
>>
>> Going forward, I think we should revisit and clearly redefine the
>> semantics of these two flags, and unify the behavior of ext4_get_block().
>> Otherwise, carrying this historical baggage will only hinder future
>> development. :-)
> 
> Yeah, frankly I think it would be good to cleanup. But as you say it is
> currently working correctly.
> 

Yes, this cleanup work requires checking many places, and there's no
rush to carry it out at the moment.

Thanks,
Yi.

