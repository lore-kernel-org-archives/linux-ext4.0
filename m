Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A353D75D6;
	Tue, 28 Apr 2026 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777367357; cv=none; b=nDULmUKZiPVDG0hi8msNJ//dxPEW8eWHLuRig8mbtxCeKVycuMbO1Jz2bWzHo6ATU2OHqd1iN6RGuWe2zp/Wz9RVqQm2bIO65mDfvRSoEv3DhzUSpXSXkaMuFxJXwi906bJXMjA5wz13SdRaep7DLHY+hgv1atMLbNTHSRi1C8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777367357; c=relaxed/simple;
	bh=7dO8kxAqwen6ZwLHZwgZ8a1/uMCPwzCYzicWNCW6+0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BV0g3y78MbVO43wrwcfwr9yjxmyyeQuO1fRUOeYuw1G9S++2kXO1aZSCKqLu2oGAtMVOP65kBG07M6c8z30/oa3XZWYc4n+ZGEi6+rvKSdu7jNwwAmydjVNHrloC7TbuGqX4i5apEEbqAQ0ZCdz1jEfcqR+My1GyKE1Y6xYMiUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g4Z1P0y0SzKHMZd;
	Tue, 28 Apr 2026 16:51:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1C93540561;
	Tue, 28 Apr 2026 16:52:23 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAHz1pDdfBpnJRfAQ--.9999S3;
	Tue, 28 Apr 2026 16:52:20 +0800 (CST)
Message-ID: <3349cfbe-8ffe-4032-8ba9-7f6cf037c020@huaweicloud.com>
Date: Tue, 28 Apr 2026 16:52:18 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] generic/790: test post-EOF gap zeroing persistence
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com
References: <20260424092228.1396658-1-yi.zhang@huaweicloud.com>
 <aetreLr6tt1Vb-GJ@bfoster>
 <038228d9-8058-43e0-8be9-b8afc9e8397c@huaweicloud.com>
 <ae9euwyg53TRutsK@bfoster>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ae9euwyg53TRutsK@bfoster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHz1pDdfBpnJRfAQ--.9999S3
X-Coremail-Antispam: 1UD129KBjvAXoW3uF13ZFykWr15JFWrur4xXrb_yoW8JF1DWo
	WfWrW7Xw18Cry8AFn0kayqqryj9anYgF18JFWY9rW5J3WYqa1UCr1xAw18Ja9akr1j9FWD
	Ja4kKrnxZrWUXF1fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUU5K7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 4/27/2026 9:03 PM, Brian Foster wrote:
> On Sat, Apr 25, 2026 at 11:06:27AM +0800, Zhang Yi wrote:
>> On 4/24/2026 9:09 PM, Brian Foster wrote:
>>> On Fri, Apr 24, 2026 at 05:22:28PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> Test that extending a file past a non-block-aligned EOF correctly
>>>> zero-fills the gap [old_EOF, block_boundary), and that this zeroing
>>>> persists through a filesystem shutdown+remount cycle.
>>>>
>>>> Stale data beyond EOF can persist on disk when append write data blocks
>>>> are flushed before the on-disk file size update, or when concurrent
>>>> append writeback and mmap writes persist non-zero data past EOF.
>>>> Subsequent post-EOF operations (append write, fallocate, truncate up)
>>>> must zero-fill and persist the gap to prevent exposing stale data.
>>>>
>>>> The test pollutes the file's last physical block (via FIEMAP + raw
>>>> device write) with a sentinel pattern beyond i_size, then performs each
>>>> extend operation and verifies the gap is zeroed both in memory and on
>>>> disk.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>> v1->v2:
>>>>  - Add _require_no_realtime to prevent testing on XFS realtime devices,
>>>>    where file data may reside on $SCRATCH_RTDEV.
>>>>  - Add _exclude_fs btrfs since FIEMAP returns logical addresses, not
>>>>    physical device offsets, writing to these offsets on $SCRATCH_DEV
>>>>    would corrupt the filesystem in multi-device setups. Besides, since
>>>>    btrfs doesn't support shutdown right now, we can support it later.
>>>>  - Add -v flag to od in _check_gap_zero() to prevent line folding of
>>>>    identical consecutive lines.
>>>>  - Add expected_new_sz parameter to _test_eof_zeroing(), verify file
>>>>    size was not rolled back after shutdown+remount cycle, and also drop
>>>>    the unnecessary file size check before the shutdown as well.
>>>>  - Clarify the comment regarding when stale data beyond EOF can persist.
>>>>
>>>
>>> Thanks for the tweaks. This all LGTM from a review standpoint. I gave it
>>> a quick test on latest master and I see a few failures in a couple runs:
>>>
>>> - On XFS (mkfs defaults) I saw one unexpected i_size failure and one
>>>   zeroing failure, both on write extension fwiw.
>>
>> Previously, I only discovered the zeroing failure of append write. This
>> is because xfs_file_write_checks() -> xfs_file_write_zero_eof() only
>> zeroes the gap range in the page cache, without providing any
>> synchronous or asynchronous persistence (instead, truncate up does
>> synchronously writeback in xfs_vn_setattr_size(), and ext4 achieves
>> persistence via asynchronous writeback in data=ordered mode). So I think
>> this is a XFS problem.
>>
> 
> Ah Ok.. the truncate flush has been there for a while to combat the NULL
> files problem, and the zeroing check ties into that. I suspect the
> reason we don't see this often is typical ascending offset writeback
> order, whereas this test is doing a targeted sync range of a later
> offset in the file (i.e. technically not overlapping with the range that
> was zeroed internally).

Yes, this use case is quite rare.

> 
> I guess the simple thing to do there would be to similarly flush on
> write extension. I'd want to think about that just a bit because we
> haven't historically flushed there and I know the zeroing improvements
> I've made in iomap have caused a couple performance regressions along
> the way related to aggressive flushing that had to be fixed.

I am also concerned that synchronous write-back might introduce
performance regressions. Although the probability is relatively low
(I'm not sure), perhaps some users who use post-EOF writing will
complain.

In this corner case, ext4+iomap also encountered the same dilemma, as it
can no longer use data=ordered to achieve asynchronous persistence.

FYI, the current approach of ext4+iomap is to submit an I/O immediately
after zeroing the EOF block, but it does not wait for the I/O to
complete. In the subsequent endio process, it waits for this zero I/O to
complete before updating i_disksize beyond the end of the gap.

Best Regards,
Yi

> 
> Maybe this is less of an issue now, but regardless if my assumptions are
> correct here than I agree this isn't a test issue.
> 
>> Regarding the i_size failure, I did not directly reproduce this issue.
>> After analysis, I believe it is because the test case did not include
>> the -a option in sync_range, meaning it did not wait for IO writeback
>> completion and file size update persistence. I reproduced this issue by
>> adding a delay in the XFS end IO path. This is a problem with the test
>> case, and I will fix it in v3. Thank you for pointing this out.
>>
> 
> Makes sense. It will be interesting to see if we can still reproduce the
> above issue with this change.
> 
>>> - On ext4 I saw a few unexpected i_size failures (both with mkfs
>>>   defaults and 1k block size).
>>>
>>
>> This is an ext4 issue on the shutdown path. Since ext4 set the shutdown
>> flag too early, it was unable to write back ordered zero data when
>> flushing the journal, which led to a journal abort and prevented the file
>> size update from being persisted. I have submitted a patch to fix this
>> issue. Please see below link for details.
>>
>>  https://lore.kernel.org/linux-ext4/20260424104201.1930823-1-yi.zhang@huaweicloud.com/
>>
> 
> Ok, thanks.
> 
> Brian
> 
>> Thanks
>> Yi.
>>
>>> I haven't dug into anything beyond that. Does this match what you're
>>> seeing on current kernels or are these unexpected failures?
>>>
>>> Brian
>>>
>>>>  tests/generic/790     | 164 ++++++++++++++++++++++++++++++++++++++++++
>>>>  tests/generic/790.out |   4 ++
>>>>  2 files changed, 168 insertions(+)
>>>>  create mode 100755 tests/generic/790
>>>>  create mode 100644 tests/generic/790.out
>>>>
>>>> diff --git a/tests/generic/790 b/tests/generic/790
>>>> new file mode 100755
>>>> index 00000000..2adc06f8
>>>> --- /dev/null
>>>> +++ b/tests/generic/790
>>>> @@ -0,0 +1,164 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright (c) 2026 Huawei.  All Rights Reserved.
>>>> +#
>>>> +# FS QA Test No. 790
>>>> +#
>>>> +# Test that extending a file past a non-block-aligned EOF correctly zero-fills
>>>> +# the gap [old_EOF, block_boundary), and that this zeroing persists through a
>>>> +# filesystem shutdown+remount cycle.
>>>> +#
>>>> +# Stale data beyond EOF can persist on disk when:
>>>> +# 1) append write data blocks are flushed before the on-disk file size update,
>>>> +#    and the system crashes in this window.
>>>> +# 2) concurrent append writeback and mmap writes persist non-zero data past EOF.
>>>> +#
>>>> +# Subsequent post-EOF operations (append write, fallocate, truncate up) must
>>>> +# zero-fill and persist the gap to prevent exposing stale data.
>>>> +#
>>>> +# The test pollutes the file's last physical block (via FIEMAP + raw device
>>>> +# write) with a sentinel pattern beyond i_size, then performs each extend
>>>> +# operation and verifies the gap is zeroed both in memory and on disk.
>>>> +#
>>>> +. ./common/preamble
>>>> +_begin_fstest auto quick rw shutdown
>>>> +
>>>> +. ./common/filter
>>>> +
>>>> +_require_scratch
>>>> +_require_block_device $SCRATCH_DEV
>>>> +_require_no_realtime
>>>> +_require_scratch_shutdown
>>>> +_require_metadata_journaling $SCRATCH_DEV
>>>> +
>>>> +# FIEMAP on Btrfs returns logical addresses within the filesystem's address
>>>> +# space, not physical device offsets. Writing to these offsets on $SCRATCH_DEV
>>>> +# would corrupt the filesystem in multi-device setups.
>>>> +_exclude_fs btrfs
>>>> +
>>>> +_require_xfs_io_command "fiemap"
>>>> +_require_xfs_io_command "falloc"
>>>> +_require_xfs_io_command "pwrite"
>>>> +_require_xfs_io_command "truncate"
>>>> +_require_xfs_io_command "sync_range"
>>>> +
>>>> +# Check that gap region [offset, offset+nbytes) is entirely zero
>>>> +_check_gap_zero()
>>>> +{
>>>> +	local file="$1"
>>>> +	local offset="$2"
>>>> +	local nbytes="$3"
>>>> +	local label="$4"
>>>> +	local data
>>>> +	local stripped
>>>> +
>>>> +	data=$(od -A n -t x1 -v -j $offset -N $nbytes "$file" 2>/dev/null)
>>>> +
>>>> +	# Remove whitespace and check if any byte is non-zero
>>>> +	stripped=$(printf '%s' "$data" | tr -d ' \n\t')
>>>> +	if [ -n "$stripped" ] && ! echo "$stripped" | grep -qE "^0+$"; then
>>>> +		echo "FAIL: non-zero data in gap [$offset,$((offset + nbytes))) $label"
>>>> +		_hexdump -N $((offset + nbytes)) "$file"
>>>> +		return 1
>>>> +	fi
>>>> +	return 0
>>>> +}
>>>> +
>>>> +# Get the physical block offset (in bytes) of the file's first block on device
>>>> +_get_phys_offset()
>>>> +{
>>>> +	local file="$1"
>>>> +	local fiemap_output
>>>> +	local phys_blk
>>>> +
>>>> +	fiemap_output=$($XFS_IO_PROG -r -c "fiemap -v" "$file" 2>/dev/null)
>>>> +	phys_blk=$(echo "$fiemap_output" | _filter_xfs_io_fiemap | head -1 | awk '{print $3}')
>>>> +	if [ -z "$phys_blk" ]; then
>>>> +		echo ""
>>>> +		return
>>>> +	fi
>>>> +	# Convert 512-byte blocks to bytes
>>>> +	echo $((phys_blk * 512))
>>>> +}
>>>> +
>>>> +_test_eof_zeroing()
>>>> +{
>>>> +	local test_name="$1"
>>>> +	local extend_cmd="$2"
>>>> +	local expected_new_sz="$3"
>>>> +	local file=$SCRATCH_MNT/testfile_${test_name}
>>>> +
>>>> +	echo "$test_name" | tee -a $seqres.full
>>>> +
>>>> +	# Compute non-block-aligned EOF offset
>>>> +	local gap_bytes=16
>>>> +	local eof_offset=$((blksz - gap_bytes))
>>>> +
>>>> +	# Step 1: Write one full block to ensure the filesystem allocates a
>>>> +	#         physical block for the file instead of using inline data.
>>>> +	$XFS_IO_PROG -f -c "pwrite -S 0x5a 0 $blksz" -c fsync \
>>>> +		"$file" >> $seqres.full 2>&1
>>>> +
>>>> +	# Step 2: Get physical block offset on device via FIEMAP
>>>> +	local phys_offset
>>>> +	phys_offset=$(_get_phys_offset "$file")
>>>> +	if [ -z "$phys_offset" ]; then
>>>> +		_fail "$test_name: failed to get physical block offset via fiemap"
>>>> +	fi
>>>> +
>>>> +	# Step 3: Truncate file to non-block-aligned size and fsync.
>>>> +	#         The on-disk region [eof_offset, blksz) may or may not be
>>>> +	#         zeroed by the filesystem at this point.
>>>> +	$XFS_IO_PROG -c "truncate $eof_offset" -c fsync \
>>>> +		"$file" >> $seqres.full 2>&1
>>>> +
>>>> +	# Step 4: Unmount and restore the physical block to all-0x5a on disk.
>>>> +	#         This bypasses the kernel's pagecache EOF-zeroing to ensure
>>>> +	#         the stale pattern is present on disk. Then remount.
>>>> +	_scratch_unmount
>>>> +	$XFS_IO_PROG -d -c "pwrite -S 0x5a $phys_offset $blksz" \
>>>> +		$SCRATCH_DEV >> $seqres.full 2>&1
>>>> +	_scratch_mount >> $seqres.full 2>&1
>>>> +
>>>> +	# Step 5: Execute the extend operation.
>>>> +	$XFS_IO_PROG -c "$extend_cmd" "$file" >> $seqres.full 2>&1
>>>> +
>>>> +	# Step 6: Verify gap [eof_offset, blksz) is zeroed BEFORE shutdown
>>>> +	_check_gap_zero "$file" $eof_offset $gap_bytes "before shutdown" || return 1
>>>> +
>>>> +	# Step 7: Sync the extended range and shutdown the filesystem with
>>>> +	#         journal flush. This persists the file size extending, and
>>>> +	#         the filesystem should persist the zeroed data in the gap
>>>> +	#         range as well.
>>>> +	if [ "$extend_cmd" != "${extend_cmd#pwrite}" ]; then
>>>> +		$XFS_IO_PROG -c "sync_range -w $blksz $blksz" \
>>>> +			"$file" >> $seqres.full 2>&1
>>>> +	fi
>>>> +	_scratch_shutdown -f
>>>> +
>>>> +	# Step 8: Remount and verify gap is still zeroed
>>>> +	_scratch_cycle_mount
>>>> +
>>>> +	# Verify file size was not rolled back after shutdown+remount
>>>> +	local sz
>>>> +	sz=$(stat -c %s "$file")
>>>> +	if [ "$sz" -ne "$expected_new_sz" ]; then
>>>> +		_fail "$test_name: file size rolled back after shutdown+remount: $sz != $expected_new_sz"
>>>> +	fi
>>>> +
>>>> +	_check_gap_zero "$file" $eof_offset $gap_bytes "after shutdown+remount" || return 1
>>>> +}
>>>> +
>>>> +_scratch_mkfs >> $seqres.full 2>&1
>>>> +_scratch_mount
>>>> +
>>>> +blksz=$(_get_block_size $SCRATCH_MNT)
>>>> +
>>>> +# Test three variants of EOF-extending operations
>>>> +_test_eof_zeroing "append_write" "pwrite -S 0x42 $blksz $blksz" $((blksz * 2))
>>>> +_test_eof_zeroing "truncate_up" "truncate $((blksz * 2))" $((blksz * 2))
>>>> +_test_eof_zeroing "fallocate" "falloc $blksz $blksz" $((blksz * 2))
>>>> +
>>>> +# success, all done
>>>> +status=0
>>>> +exit
>>>> diff --git a/tests/generic/790.out b/tests/generic/790.out
>>>> new file mode 100644
>>>> index 00000000..e5e2cc09
>>>> --- /dev/null
>>>> +++ b/tests/generic/790.out
>>>> @@ -0,0 +1,4 @@
>>>> +QA output created by 790
>>>> +append_write
>>>> +truncate_up
>>>> +fallocate
>>>> -- 
>>>> 2.52.0
>>>>
>>
> 

