Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CF93B3C1C;
	Thu, 23 Apr 2026 01:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776908509; cv=none; b=bHBbH0/tCrHsgzxpb2bC5UQ9A7O/9/HcHM1aWLfsEDGXz/pSIdZbklGYObpOPDB0lLq2r76nG2lkBcqSOZMeEbhAnxMyR0buvmuQYEGMd08kDFctwhJyfp3hXi8F2VfNSS9bO0BeRZ9GQmXePkj4UhM+48g+CNiHLC6X6MO8Nzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776908509; c=relaxed/simple;
	bh=i2d3ewWl750sGmnliN4gogPVayZVkHMiLtF3AynF5Ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K/HKkbwcWIFDN0cMjfG5l1vDFfAXGvFqi4M1YoOHM7seif/4hXOFwBzT9yMH4nrXMctgd3GCAohAfcmTGUjh4uebdoJT5EVBvpRzaQmTmHiLHY2t+3QkqWSlhXEwg3hk/WByLZcIU0pNWNq+wq8PX9hVZ0WP60QKOP2TJvdASPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4g1Jgz67D9zYQtLc;
	Thu, 23 Apr 2026 09:40:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id B02A94058C;
	Thu, 23 Apr 2026 09:41:30 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with SMTP id _Ch0CgBXBb_HeOlpUG6JBQ--.26218S3;
	Thu, 23 Apr 2026 09:41:28 +0800 (CST)
Message-ID: <4c3abdbc-0805-4e19-98b9-5a5e06b5db40@huaweicloud.com>
Date: Thu, 23 Apr 2026 09:41:26 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/790: test post-EOF gap zeroing persistence
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com
References: <20260422015246.4132376-1-yi.zhang@huaweicloud.com>
 <aejLp-m2-0h6q0RE@bfoster>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aejLp-m2-0h6q0RE@bfoster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBXBb_HeOlpUG6JBQ--.26218S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw1rZryDuFyxAr18tF43Jrb_yoWxuF1kpa
	yrKF1Yyr1xKF47J3s29Fn0qr1F9w4rZr4Uur92qryjvr98Jr1IqFZFqr4jg3yxJrn3Cw4I
	vr4kGa43uw1jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 4/22/2026 9:22 PM, Brian Foster wrote:
> On Wed, Apr 22, 2026 at 09:52:46AM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Test that extending a file past a non-block-aligned EOF correctly
>> zero-fills the gap [old_EOF, block_boundary), and that this zeroing
>> persists through a filesystem shutdown+remount cycle.
>>
>> Stale data beyond EOF can persist on disk when append write data blocks
>> are flushed before the i_size metadata update, or when concurrent append
>> writeback and mmap writes persist non-zero data past EOF. Subsequent
>> post-EOF operations (append write, fallocate, truncate up) must
>> zero-fill and persist the gap to prevent exposing stale data.
>>
>> The test pollutes the file's last physical block (via FIEMAP + raw
>> device write) with a sentinel pattern beyond i_size, then performs each
>> extend operation and verifies the gap is zeroed both in memory and on
>> disk.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>> This is the case Jan Kara pointed out during my work on the ext4
>> buffered I/O to iomap conversion. This case is similar to generic/363,
>> but generic/363 doesn't provide persistent testing. For details:
>>
>>  https://lore.kernel.org/linux-ext4/jgotl7vzzuzm6dvz5zfgk6haodxvunb4hq556pzh4hqqwvnhxq@lr3jiedhqh7c/
>>
>>  tests/generic/790     | 155 ++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/790.out |   4 ++
>>  2 files changed, 159 insertions(+)
>>  create mode 100755 tests/generic/790
>>  create mode 100644 tests/generic/790.out
>>
>> diff --git a/tests/generic/790 b/tests/generic/790
>> new file mode 100755
>> index 00000000..5d8f61f9
>> --- /dev/null
>> +++ b/tests/generic/790
>> @@ -0,0 +1,155 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Huawei.  All Rights Reserved.
>> +#
>> +# FS QA Test No. 790
>> +#
>> +# Test that extending a file past a non-block-aligned EOF correctly zero-fills
>> +# the gap [old_EOF, block_boundary), and that this zeroing persists through a
>> +# filesystem shutdown+remount cycle.
>> +#
> 
> Nice test! This is a great idea.
> 
>> +# Stale data beyond EOF can persist on disk when:
>> +# 1) append write data blocks are flushed before the i_size metadata update,
>> +#    and the system crashes in this window.
> 
> Maybe it's wording or I'm missing something, but how would "append write
> data blocks" be flushed before i_size updates? Wouldn't writeback toss
> them or zero the post-eof range of a folio? Do you mean to refer to
> "on-disk size update" specifically (where I'm reading it as
> inode->i_isize)?

It's wording, I mean the "on-disk file size update", sorry for confusing.

> 
>> +# 2) concurrent append writeback and mmap writes persist non-zero data past EOF.
>> +#
>> +# Subsequent post-EOF operations (append write, fallocate, truncate up) must
>> +# zero-fill and persist the gap to prevent exposing stale data.
>> +#
>> +# The test pollutes the file's last physical block (via FIEMAP + raw device
>> +# write) with a sentinel pattern beyond i_size, then performs each extend
>> +# operation and verifies the gap is zeroed both in memory and on disk.
>> +#
> ...
>> +_test_eof_zeroing()
>> +{
>> +	local test_name="$1"
>> +	local extend_cmd="$2"
>> +	local file=$SCRATCH_MNT/testfile_${test_name}
>> +
>> +	echo "$test_name" | tee -a $seqres.full
>> +
>> +	# Compute non-block-aligned EOF offset
>> +	local gap_bytes=16
>> +	local eof_offset=$((blksz - gap_bytes))
>> +
>> +	# Step 1: Write one full block to ensure the filesystem allocates a
>> +	#         physical block for the file instead of using inline data.
>> +	$XFS_IO_PROG -f -c "pwrite -S 0x5a 0 $blksz" -c fsync \
>> +		"$file" >> $seqres.full 2>&1
>> +
>> +	# Step 2: Get physical block offset on device via FIEMAP
>> +	local phys_offset
>> +	phys_offset=$(_get_phys_offset "$file")
>> +	if [ -z "$phys_offset" ]; then
>> +		_fail "$test_name: failed to get physical block offset via fiemap"
>> +	fi
>> +
>> +	# Step 3: Truncate file to non-block-aligned size and fsync.
>> +	#         The on-disk region [eof_offset, blksz) may or may not be
>> +	#         zeroed by the filesystem at this point.
>> +	$XFS_IO_PROG -c "truncate $eof_offset" -c fsync \
>> +		"$file" >> $seqres.full 2>&1
>> +
>> +	# Step 4: Unmount and restore the physical block to all-0x5a on disk.
>> +	#         This bypasses the kernel's pagecache EOF-zeroing to ensure
>> +	#         the stale pattern is present on disk. Then remount.
>> +	_scratch_unmount
>> +	$XFS_IO_PROG -d -c "pwrite -S 0x5a $phys_offset $blksz" \
>> +		$SCRATCH_DEV >> $seqres.full 2>&1
>> +	_scratch_mount >> $seqres.full 2>&1
>> +
>> +	# Verify file size is still eof_offset after remount
>> +	local sz
>> +	sz=$(stat -c %s "$file")
>> +	if [ "$sz" -ne "$eof_offset" ]; then
>> +		_fail "$test_name: file size wrong after remount: $sz != $eof_offset"
>> +	fi
> 
> I was initially curious why we'd want to do this, but after further
> thought I wonder if it might make more sense to check file size against
> the extended size after the shutdown/mount cycle below (but before
> checking the gap range). That way we know the size update was
> logged/recovered correctly and we're about to read from a file range
> within eof. Hm?

Yeah, this check should be more necessary after the shutdown/mount
cycle.

> 
> Those couple nits aside this all looks pretty good to me.

Thank you for the review.

Best Regards,
Yi.

> 
> Brian
> 
>> +
>> +	# Step 5: Execute the extend operation.
>> +	$XFS_IO_PROG -c "$extend_cmd" "$file" >> $seqres.full 2>&1
>> +
>> +	# Step 6: Verify gap [eof_offset, blksz) is zeroed BEFORE shutdown
>> +	_check_gap_zero "$file" $eof_offset $gap_bytes "before shutdown" || return 1
>> +
>> +	# Step 7: Sync the extended range and shutdown the filesystem with
>> +	#         journal flush. This persists the file size extending, and
>> +	#         the filesystem should persist the zeroed data in the gap
>> +	#         range as well.
>> +	if [ "$extend_cmd" != "${extend_cmd#pwrite}" ]; then
>> +		$XFS_IO_PROG -c "sync_range -w $blksz $blksz" \
>> +			"$file" >> $seqres.full 2>&1
>> +	fi
>> +	_scratch_shutdown -f
>> +
>> +	# Step 8: Remount and verify gap is still zeroed
>> +	_scratch_cycle_mount
>> +	_check_gap_zero "$file" $eof_offset $gap_bytes "after shutdown+remount" || return 1
>> +}
>> +
>> +_scratch_mkfs >> $seqres.full 2>&1
>> +_scratch_mount
>> +
>> +blksz=$(_get_block_size $SCRATCH_MNT)
>> +
>> +# Test three variants of EOF-extending operations
>> +_test_eof_zeroing "append_write" "pwrite -S 0x42 $blksz $blksz"
>> +_test_eof_zeroing "truncate_up" "truncate $((blksz * 2))"
>> +_test_eof_zeroing "fallocate" "falloc $blksz $blksz"
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/generic/790.out b/tests/generic/790.out
>> new file mode 100644
>> index 00000000..e5e2cc09
>> --- /dev/null
>> +++ b/tests/generic/790.out
>> @@ -0,0 +1,4 @@
>> +QA output created by 790
>> +append_write
>> +truncate_up
>> +fallocate
>> -- 
>> 2.52.0
>>
>>

