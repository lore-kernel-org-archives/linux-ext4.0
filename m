Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794454430;
	b=yKiphP2HnwdsqsaQBBwEyzwHKKOyeNcR4Md8LtzDp81onTOe63E5Nl7maR1+vJyyzS82
	 Q03UMi+awsNHoSCnO79olcxaIoPzmLeg7O0In2570/c3vv0tf/nexERTYFIEQvhMmK7EE
	 NCwUMeGWEuM3gdToKT59s/CBUqAlyYJK7xdR0YyomwXb6bDHb9/dgyeJzWA59zB9QlG92
	 mfgwAALxo1KkBn6rXczmoqfihe7HMFpMF8iyg4z54Maj6WObSCGdnkf7p1FOnX36sP9uA
	 08DW+BrCDUcOrZYhYsGNWHDwnySxP9+/okVGi2+K9SEfa7ejn9oAfQNW1AYiqfiA0Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794454430;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=F6+7ZlIp4itBJtPDKgD6D6d0/yQu4/YAUF6Hgt2dgJo=;
	b=BxOOpxXDyXTYLQn8e9pzrRYFzVn1aQH0TGTEjJCiMBUscZbL8e2DkC0+DbmTpe1xyxqv
	 BrhXpy9GMOG0+rFkzVyfjzRHQR5zvTiXlTvq/Bwqzbj4kRAJJJ+xXghhY24I0xH0obf89
	 BDEMZ5ULwRa+haNQREQ6FcBSYFa959PcqDzTf9MEf9HTT00Tevz8pvTr1k7AYrJdUCM5o
	 gHBEMfhoLxBG+2XBc3TPGCcjek7ac17+2AQHWBR4BcPthOduJ/l1Rcod7umIlAIhRfcys
	 ZcJsGBVPLXU/rbAj0rFBMacrlshPizZBYg72wWU6h8d7vkHaIRtYwQBDJG+3T6zA7mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16062606A321;
	Thu, 12 Nov 2026 03:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16062606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jQ5Z15wz5z20Nk;
	Thu, 12 Nov 2026 11:32:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B5B41409C7;
	Thu, 12 Nov 2026 11:33:37 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCn4O+PM_VqRVcZEA--.64899S3;
	Thu, 12 Nov 2026 11:33:37 +0800 (CST)
Message-ID: <fce5c384-3a18-4156-b0eb-a0d584b8b459@huaweicloud.com>
Date: Thu, 12 Nov 2026 11:33:35 +0800
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
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCn4O+PM_VqRVcZEA--.64899S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JFWUZFyDtrWfGF18AFyrJFb_yoWfXr47pF
	sIkF15Jr4kt34Ik393A3W2qr1Yvws3GFW3WrW3GFWjyFy5XryFgr47KFWj9Fyv9rs7CFya
	vF4Yv34UCas8uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
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

On 11/3/2026 2:26 AM, Ojaswin Mujoo wrote:
> There is a data corruption in the zeroout fallback
> ext4_split_extent_zeroout() when we encounter an error like ENOSPC
> while trying to perform endio extent splitting.
> 
> The issue was discovered by Fedora coreos community while using 1kb
> blocks size on a 64kb pagesize arch like powerpc or aarch64 and the
> discussion can be found at [1].
> 
> ** The Issue **
> 
> The issue can be encountered as follows:
> 
> 1. Make an FS with no reserved to root reserved blocks and fill it
>    completely.
> 2. Delete a file so that ext4_sb_info thinks there is free space but
>    mballoc doesnt have any (until txn is committed).
> 3. Now when endio kicks in it eventually reaches:
> 
> ext4_handle_unwritten_extents
>   ext4_split_convert_extents
>     ext4_split_extent
>       ext4_split_extent_at
>         ext4_ext_insert_extent
>           ext4_new_meta_blocks  // extent tree split/grow needs a block
>             ext4_mb_new_blocks
>               ext4_claim_free_clusters  // thinks we have free space but mballoc
>                                            has none until txn commit frees it
>               ext4_mb_regular_allocator
>                 // return -ENOSPC
>     // ext4_split_extent fallsback to zeroout
>     ext4_split_extent_zeroout
>       // We try to zeroout surrounding unwritten ranges. This code has a bug
>          where we zero an unwritten extent which could have valid data on disk 
>          whose endio has not yet converted it
> 
> The main issue is that zeroout assumes any unwritten extent is valid to
> zeroout but it could actually be a soon-to-be-converted extent holding
> valid data.
> 

Hi Ojaswin,

Thank you for your analysis! This makes sense to me. I apologize for not
having considered this concurrent scenario earlier and for amplifying
the data loss issue.

> ** The fix **
> 
> The way this series fixes it is by per-inode tracking the no. of
> unwritten IOs that are submitted but not yet converted
> (ei->i_conv_pending_ios). If we end up in the zeroout fallback and see
> there are such IOs existing in the inode, then we don't zeroout and just
> return back the original error. More design notes can be found in
> subsequent patches.
> 

Regarding the solution, I agree that your approach looks like it can fix
this issue, and the idea is fairly straightforward. When zeroing out, if
there is other concurrent I/O, just fall back and return an error.
However, I've been thinking about it over the past few days, hoping to
find another simpler and more elegant solution, but that seems rather
difficult.

First, due to the map range caching mechanism in the iomap writeback
path and for performance reasons, we probably can't go back to splitting
extents when issuing I/O as before. Moreover, the previous approach also
couldn't completely avoid zeroing the entire unwritten extent when the
I/O completes, so the problem already existed before. It just required
concurrency and had a very low probability. Therefore, I agree that we
need to address this problem head-on.


Here's a rough idea I'd like to share:

1. Add an in-core extent status flag, something like
   EXTENT_STATUS_PENDING_WRITTEN.  Like EXTENT_STATUS_DELAYED, these
   entries would be must-keep.  The idea is to mark ranges for which
   we've submitted I/O over an unwritten extent but haven't done the
   conversion yet.  It would just be an extra flag on top of
   EXTENT_STATUS_UNWRITTEN; the zeroout paths would be the only thing
   looking at it, and everywhere else the entry would still behave like
   a normal unwritten extent.  We'd have to drop the flag whenever the
   entry changes state, and also when the I/O or the conversion fails.

2. When submitting I/O, once we know the actual range being submitted,
   we'd split the existing unwritten extent status entry and add a
   pending-written entry for that subrange.  Then, when the I/O
   completes, or when fallocate and similar paths want to split an
   unwritten extent, we could check the extent status tree for the range
   we're about to zero; if there's a pending-written entry there, we'd
   just skip the zeroout fallback and return the original error.

3. We'd need to set the pending-written entry under i_data_sem.  Since
   ext4_split_extent_zeroout() already runs under i_data_sem, that
   should be enough to avoid the race.

4. One thing to be careful about: a pending-written entry is still
   unwritten, but it shouldn't be merged with a normal unwritten entry.

Some advantages I see:

1. We don't need to add anything to struct ext4_inode_info.

2. We don't need a new lock, and we avoid things like
   EXT4_GET_BLOCKS_NO_CONV_ACC for paths that don't account for
   themselves, as well as walking ioend/iovec at I/O completion just to
   keep a count.  I think the code would be a bit easier to follow.

3. Random I/O into preallocated files seems pretty common, so tracking
   at per-extent (or more precisely, per-range) granularity should give
   better exclusion than a per-inode counter and hopefully reduce the
   chance of writeback/conversion failures.

A few disadvantages I'm a bit worried about:

1. We'd have to audit all the ext4_es_cache_extent() callers for
   conflicts, and all ext4_es_remove_extent()/ext4_es_insert_extent()
   call sites, to make sure pending-written entries don't get dropped or
   overwritten. I'm not sure yet whether this is definitely feasible.

2. It changes the core semantics of the extent status tree, so it's
   quite a bit more code and work, and probably not something for
   stable.  I see it more as a long-term fix.

What do you think?

Thanks,
Yi.

> For direct IO, ext4_iomap_begin() is called once per mapping and has no
> way to account something only once per dio. So we first fix it in a
> simple way by relying on inode->i_dio_count which is already
> incremented/decremented once per dio. The last patch optimizes this by
> moving dio accounting to i_conv_pending_ios as well, by using a custom
> ext4_iomap_next() (needed because we want to increment once per
> dio). Since iomap_next() infra was added in 7.2+ this can't be
> backported so kept this approach separate.
> 
> There are other approaches considered like completely disabling zeroout
> (not ideal as it's a useful fallback) or tracking the conv_pending ranges
> in extent cache (this is an intrusive change) however the current
> approach was chosen as a middle ground to balance complexity vs
> accuracy of accounting.
> 
> ** Backport Notes **
> 
> This issue seems to have existed ever since we had the zeroout logic
> however this was never encountered until we moved extent splitting from
> writeback time to endio time in commit:
> 
> ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O") (merged
> in 7.0)
> 
> which changed the dioread_nolock writeback/dio path to submit I/O
> without pre-splitting extents, deferring the split to endio. This means
> multiple concurrent writes can share a single unwritten extent, and a
> failed split on one of them could zeroout data belonging to another,
> which exposes this issue in the zeroout logic. 
> 
> Note that the issue in zeroout was always present but the above patch
> just uncovered it. However, for the purpose of backports, I've used this
> patch. Seeing how we never saw this issue before this, hopefully just
> backporting it till 7.0 should be fine.
> 
> ** Testing **
> 
> I've tested -g quick for various configurations to catch any obvious
> issues or counter leaks, saw no regressions. I'll continue to test for
> auto group. I've also added some new tests to hit this regression which
> I'll post soon.
> 
> [1] https://github.com/coreos/fedora-coreos-tracker/issues/2234
> 
> Thoughts and suggestions welcome.
> 
> Regards,
> ojaswin
> 
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
> Ojaswin Mujoo (8):
>       ext4: add extra_flags param to ext4_convert_unwritten_extents()
>       ext4: fix endio zeroout corruption by tracking unwritten to-be-converted IOs
>       ext4: add tracing for i_conv_pending_ios tracking
>       ext4: don't zeroout if we have inflight unwritten IOs in non buffered-iomap path
>       ext4: don't zeroout if we have inflight direct IOs
>       ext4: make sure zero range WRITE_ZEROES uses NO_CONV_ACC flag
>       ext4: don't zeroout if we have inflight unwritten IOs in buffered iomap path
>       ext4: optimize inflight dio tracking for zeroout
> 
>  fs/ext4/ext4.h              |  29 +++++++--
>  fs/ext4/extents-test.c      |   2 +
>  fs/ext4/extents.c           | 117 ++++++++++++++++++++++++++++-------
>  fs/ext4/file.c              |  14 ++++-
>  fs/ext4/inode.c             | 146 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/ext4/page-io.c           |  27 +++++++-
>  fs/ext4/super.c             |  12 ++++
>  include/trace/events/ext4.h |  25 ++++++++
>  8 files changed, 342 insertions(+), 30 deletions(-)
> ---
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
> change-id: 20261023-ext4-endio-zero-bug-ec627ae61f39
> 
> Best regards,

