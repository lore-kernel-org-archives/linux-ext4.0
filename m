Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794540539;
	b=DiHABVsgCvrSjDTh9Y0GPQWWXRug8WCP9RDKDdmrZDsw7JDUlABm//ahlswxGEuwCiha
	 ywJK2j2K+s3yvuhCiaDwEBRina/iuYHp7JeFOQDH+Z+9lckohb3/6hCmfeskOlHxqsJvb
	 H8HiYNSfW8TpwVYmz3Fh1JjuN4h7A0SQNagZpLw16KmPeiL8ZucTiZMX72kzjW2yEbrYW
	 JN0ezPNmyjGMrxHu/CLJoc1dWBZ3MeYFfJTrvD2kjPP/T9+Opi18hpF5IyJW0eryGj2aH
	 Gm1wHlRW7mbhsWcZJqkJLksze37eRQeUgNN70D09iACY0G6evqTiOosYBwqep6IoWVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794540539;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=ZGUaiQStui/oBajhsUVUJ5o+FnF3+m5kPb6e9oWH/N4=;
	b=XUuaDfbhyNA3vh6jsxdSTpGH4ptXKVudF1W6SGvUxQ8VDj745Rz6s3f4MdeEku4H9plI
	 +WA8hyri6nEAwpDZhYiVpBya5yzIwoN+zctF81Rss1+hhHpneQ4lWZM7RWd+aFVNdYONU
	 bkS5D6BpXOWWB+9tTFFbrmPWA5+tfmyJprOjpJugwlmnBz0JvkiMA+5sMtLAbDLHWpOJc
	 RKJf/DAqFLPFh//GvM37z7/YokKQeTfJb9A7kwQ6/biRRMjdMafj22PegbgE88FW36ahX
	 aHKBYlI6hZiUQnKXe/+Ga1gTvCBk3dSgxgoW2aGC0hoRUGj974hp7JQv4p/YO3n9Qdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35124606A327;
	Fri, 13 Nov 2026 03:28:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35124606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jQjPy1VQbz1rqgT;
	Fri, 13 Nov 2026 11:28:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D822940595;
	Fri, 13 Nov 2026 11:28:48 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO_vg_Zqje6aEA--.20867S3;
	Fri, 13 Nov 2026 11:28:48 +0800 (CST)
Message-ID: <167a29b6-32cc-4d98-b664-4b1db1320609@huaweicloud.com>
Date: Fri, 13 Nov 2026 11:28:46 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] ext4: fix endio zeroout corruption by tracking
 to-be-converted unwritten IOs
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <fce5c384-3a18-4156-b0eb-a0d584b8b459@huaweicloud.com>
 <avVm8XuQbU4sSIF1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <avVm8XuQbU4sSIF1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXkO_vg_Zqje6aEA--.20867S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JFWUWFW5Aw4kKFWfGF1kAFb_yoWxGFWfpF
	Wa9F15Kr4Dt392krZ2yan0vw4Yvws3XrW3Wry5Ga1vyFn0gryIgF4xKayj9FyDKr4kGr1Y
	vr4jqryDCas8Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/12/2026 3:12 PM, Ojaswin Mujoo wrote:
> On Thu, Nov 12, 2026 at 11:33:35AM +0800, Zhang Yi wrote:
>> On 11/3/2026 2:26 AM, Ojaswin Mujoo wrote:
>>> There is a data corruption in the zeroout fallback
>>> ext4_split_extent_zeroout() when we encounter an error like ENOSPC
>>> while trying to perform endio extent splitting.
>>>
>>> The issue was discovered by Fedora coreos community while using 1kb
>>> blocks size on a 64kb pagesize arch like powerpc or aarch64 and the
>>> discussion can be found at [1].
>>>
>>> ** The Issue **
>>>
>>> The issue can be encountered as follows:
>>>
>>> 1. Make an FS with no reserved to root reserved blocks and fill it
>>>    completely.
>>> 2. Delete a file so that ext4_sb_info thinks there is free space but
>>>    mballoc doesnt have any (until txn is committed).
>>> 3. Now when endio kicks in it eventually reaches:
>>>
>>> ext4_handle_unwritten_extents
>>>   ext4_split_convert_extents
>>>     ext4_split_extent
>>>       ext4_split_extent_at
>>>         ext4_ext_insert_extent
>>>           ext4_new_meta_blocks  // extent tree split/grow needs a block
>>>             ext4_mb_new_blocks
>>>               ext4_claim_free_clusters  // thinks we have free space but mballoc
>>>                                            has none until txn commit frees it
>>>               ext4_mb_regular_allocator
>>>                 // return -ENOSPC
>>>     // ext4_split_extent fallsback to zeroout
>>>     ext4_split_extent_zeroout
>>>       // We try to zeroout surrounding unwritten ranges. This code has a bug
>>>          where we zero an unwritten extent which could have valid data on disk 
>>>          whose endio has not yet converted it
>>>
>>> The main issue is that zeroout assumes any unwritten extent is valid to
>>> zeroout but it could actually be a soon-to-be-converted extent holding
>>> valid data.
>>>
>>
>> Hi Ojaswin,
>>
>> Thank you for your analysis! This makes sense to me. I apologize for not
>> having considered this concurrent scenario earlier and for amplifying
>> the data loss issue.
>>
>>> ** The fix **
>>>
>>> The way this series fixes it is by per-inode tracking the no. of
>>> unwritten IOs that are submitted but not yet converted
>>> (ei->i_conv_pending_ios). If we end up in the zeroout fallback and see
>>> there are such IOs existing in the inode, then we don't zeroout and just
>>> return back the original error. More design notes can be found in
>>> subsequent patches.
>>>
>>
>> Regarding the solution, I agree that your approach looks like it can fix
>> this issue, and the idea is fairly straightforward. When zeroing out, if
>> there is other concurrent I/O, just fall back and return an error.
>> However, I've been thinking about it over the past few days, hoping to
>> find another simpler and more elegant solution, but that seems rather
>> difficult.
>>
>> First, due to the map range caching mechanism in the iomap writeback
>> path and for performance reasons, we probably can't go back to splitting
>> extents when issuing I/O as before. Moreover, the previous approach also
>> couldn't completely avoid zeroing the entire unwritten extent when the
>> I/O completes, so the problem already existed before. It just required
>> concurrency and had a very low probability. Therefore, I agree that we
>> need to address this problem head-on.
> 
> Hi Zhang, thank you so much for looking into this.
> 
> So I agree that it is a tricky issue to solve since we don't want to
> add too much complexity in the fast path. Actually the first prototype I
> did for this (back in sep before we started seeing this in distros) was
> becuase I was working on moving zeroout to the fast path rather than
> just a fallback and had hit this fairly easily there.
> 
> In the first prototype, I took the exact approach you discussed here. A
> new CONV_PENDING type for extent cache with all the plumbing to ensure
> we don't lose the status untill the conversion happens. What I reliased
> was that although this was a much more accurate fix, it needed lots of
> core changes to es layer, and I ran into several bugs where data got
> corrupted cause the status was getting lost or not in sync. I did manage
> to fix most of them but it somehow makes me a bit uncomfortable from the
> POV of a backport.
> 
> The patch for the inital version (v v rough and not cleaned up since
> Sep) can be found here [1]. 

Ha, it looks like we're thinking along the same lines, the
implementation of this POC is largely similar to what I had in mind.
Thank you for working on this. Feel free to reach out anytime to
discuss.  :)

> 
> I'll address your below ideas on how/if i implemented them in [1]
> 
>>
>>
>> Here's a rough idea I'd like to share:
>>
>> 1. Add an in-core extent status flag, something like
>>    EXTENT_STATUS_PENDING_WRITTEN.  Like EXTENT_STATUS_DELAYED, these
>>    entries would be must-keep.  The idea is to mark ranges for which
>>    we've submitted I/O over an unwritten extent but haven't done the
>>    conversion yet.  It would just be an extra flag on top of
>>    EXTENT_STATUS_UNWRITTEN; the zeroout paths would be the only thing
> 
> I added a CONV_PENDING es type rather than flag. I did start with the
> flag over UNWRITTEN approach but most places like merging logic care
> that the type rather than flag and which was causing us to merge
> UNWRITTEN and CONV_PENDING which we can't allow. So instead of modiying
> code around merging and other areas I just made CONV_PENDING a separate
> type.
> 

Yeah, it's also fine with me to make it a separate type, whichever is
clearer.

[...]

> I agree that in the long term es cache approach is definitely the way to
> move forward. I'm just wondering if it would be feasible to backport
> something like that. Then again if we want to backport only till 7.0,
> maybe it wont be that big of a deal. 
> 
> There are 2 approaches that I can see here:
> 1. USe this patch set's counter apprach as a stop gap, easy to backport
> solution which works but is a bit clumsy. With the immediate fix in
> place, we can take time to test and design the extent status approach
> correctly and land it as a feature rather than something that needs
> backport.
> 
> 2. Ditch the counter approach and just fix it in one shot with extent
> status approach like in [1].
> 
> I'm happy to work on either of the two, what do you think shall be the
> right way forward?
> 

Personally, although I still think this counting approach is a bit
hacky, I'm not opposed to using it to fix the problem first.

Best Regards,
Yi.

