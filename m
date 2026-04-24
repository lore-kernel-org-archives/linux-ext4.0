Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A6C3C3C13
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2026 13:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777036165; cv=none; b=mCDKPa3PJGA09z+H9x32FytuYwi93GeBlWhUcJk/mexTcBKoYimi9IHSDxvOOnoua0PX21aDKTeH550j42TR5meHLj3WqsiiPsWTvpF/Y3ruUTbhyvwNKbMoll0OnWYDuJxm852ANZKCi2Tftv43ab4mAt6RQltwlof7AzsIz4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777036165; c=relaxed/simple;
	bh=v7t8xXDgnZ5P6NVjO2NjHdjf7n2TcaW0th9RWKtWbjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWijdF5kHw1+dVYPcGbH0ymC0Cv8liwL5jUx4sIx0frXqygUDYpdaU9/DLR7WEaKX3EfIk31f8EV6Aw8QCgYaIgbYk1x4203EF/TpUZWV3EAF5UJbpsy9Ca+jq8Xnq2y16F/VRQfUr0Wg288UaWYg4LNal/CieL8qvFuze2qZNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vyn85yB1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vyn85yB1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777036163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkpmNTHWhcFsfPJowXveyVB0qmZ+N6Tg3EfaNJNZceY=;
	b=Vyn85yB1aT/+kOD2LdtRzGgvCNNlySMEEGS6KCDwWsbGPYvwjR0RumaSwBlqAiB0IuXKhI
	xWkK5Z/CbK09UHPK3CeXbuyPrMwv0zWptNOnx9tfTU3kV3hm35gFThuvfipGbBCjpg4+tL
	IwW1bwmUkDEfPSYJaXRJVw8e/lsfiG8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-sIsZSpHANaOxAhPLV8ykyw-1; Fri,
 24 Apr 2026 09:09:18 -0400
X-MC-Unique: sIsZSpHANaOxAhPLV8ykyw-1
X-Mimecast-MFC-AGG-ID: sIsZSpHANaOxAhPLV8ykyw_1777036156
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A4D319560BD;
	Fri, 24 Apr 2026 13:09:16 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.73])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F59E1800446;
	Fri, 24 Apr 2026 13:09:14 +0000 (UTC)
Date: Fri, 24 Apr 2026 09:09:12 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
	yizhang089@gmail.com, yangerkun@huawei.com
Subject: Re: [PATCH v2] generic/790: test post-EOF gap zeroing persistence
Message-ID: <aetreLr6tt1Vb-GJ@bfoster>
References: <20260424092228.1396658-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424092228.1396658-1-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Apr 24, 2026 at 05:22:28PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Test that extending a file past a non-block-aligned EOF correctly
> zero-fills the gap [old_EOF, block_boundary), and that this zeroing
> persists through a filesystem shutdown+remount cycle.
> 
> Stale data beyond EOF can persist on disk when append write data blocks
> are flushed before the on-disk file size update, or when concurrent
> append writeback and mmap writes persist non-zero data past EOF.
> Subsequent post-EOF operations (append write, fallocate, truncate up)
> must zero-fill and persist the gap to prevent exposing stale data.
> 
> The test pollutes the file's last physical block (via FIEMAP + raw
> device write) with a sentinel pattern beyond i_size, then performs each
> extend operation and verifies the gap is zeroed both in memory and on
> disk.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
> v1->v2:
>  - Add _require_no_realtime to prevent testing on XFS realtime devices,
>    where file data may reside on $SCRATCH_RTDEV.
>  - Add _exclude_fs btrfs since FIEMAP returns logical addresses, not
>    physical device offsets, writing to these offsets on $SCRATCH_DEV
>    would corrupt the filesystem in multi-device setups. Besides, since
>    btrfs doesn't support shutdown right now, we can support it later.
>  - Add -v flag to od in _check_gap_zero() to prevent line folding of
>    identical consecutive lines.
>  - Add expected_new_sz parameter to _test_eof_zeroing(), verify file
>    size was not rolled back after shutdown+remount cycle, and also drop
>    the unnecessary file size check before the shutdown as well.
>  - Clarify the comment regarding when stale data beyond EOF can persist.
> 

Thanks for the tweaks. This all LGTM from a review standpoint. I gave it
a quick test on latest master and I see a few failures in a couple runs:

- On XFS (mkfs defaults) I saw one unexpected i_size failure and one
  zeroing failure, both on write extension fwiw.
- On ext4 I saw a few unexpected i_size failures (both with mkfs
  defaults and 1k block size).

I haven't dug into anything beyond that. Does this match what you're
seeing on current kernels or are these unexpected failures?

Brian

>  tests/generic/790     | 164 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/790.out |   4 ++
>  2 files changed, 168 insertions(+)
>  create mode 100755 tests/generic/790
>  create mode 100644 tests/generic/790.out
> 
> diff --git a/tests/generic/790 b/tests/generic/790
> new file mode 100755
> index 00000000..2adc06f8
> --- /dev/null
> +++ b/tests/generic/790
> @@ -0,0 +1,164 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Huawei.  All Rights Reserved.
> +#
> +# FS QA Test No. 790
> +#
> +# Test that extending a file past a non-block-aligned EOF correctly zero-fills
> +# the gap [old_EOF, block_boundary), and that this zeroing persists through a
> +# filesystem shutdown+remount cycle.
> +#
> +# Stale data beyond EOF can persist on disk when:
> +# 1) append write data blocks are flushed before the on-disk file size update,
> +#    and the system crashes in this window.
> +# 2) concurrent append writeback and mmap writes persist non-zero data past EOF.
> +#
> +# Subsequent post-EOF operations (append write, fallocate, truncate up) must
> +# zero-fill and persist the gap to prevent exposing stale data.
> +#
> +# The test pollutes the file's last physical block (via FIEMAP + raw device
> +# write) with a sentinel pattern beyond i_size, then performs each extend
> +# operation and verifies the gap is zeroed both in memory and on disk.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw shutdown
> +
> +. ./common/filter
> +
> +_require_scratch
> +_require_block_device $SCRATCH_DEV
> +_require_no_realtime
> +_require_scratch_shutdown
> +_require_metadata_journaling $SCRATCH_DEV
> +
> +# FIEMAP on Btrfs returns logical addresses within the filesystem's address
> +# space, not physical device offsets. Writing to these offsets on $SCRATCH_DEV
> +# would corrupt the filesystem in multi-device setups.
> +_exclude_fs btrfs
> +
> +_require_xfs_io_command "fiemap"
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "pwrite"
> +_require_xfs_io_command "truncate"
> +_require_xfs_io_command "sync_range"
> +
> +# Check that gap region [offset, offset+nbytes) is entirely zero
> +_check_gap_zero()
> +{
> +	local file="$1"
> +	local offset="$2"
> +	local nbytes="$3"
> +	local label="$4"
> +	local data
> +	local stripped
> +
> +	data=$(od -A n -t x1 -v -j $offset -N $nbytes "$file" 2>/dev/null)
> +
> +	# Remove whitespace and check if any byte is non-zero
> +	stripped=$(printf '%s' "$data" | tr -d ' \n\t')
> +	if [ -n "$stripped" ] && ! echo "$stripped" | grep -qE "^0+$"; then
> +		echo "FAIL: non-zero data in gap [$offset,$((offset + nbytes))) $label"
> +		_hexdump -N $((offset + nbytes)) "$file"
> +		return 1
> +	fi
> +	return 0
> +}
> +
> +# Get the physical block offset (in bytes) of the file's first block on device
> +_get_phys_offset()
> +{
> +	local file="$1"
> +	local fiemap_output
> +	local phys_blk
> +
> +	fiemap_output=$($XFS_IO_PROG -r -c "fiemap -v" "$file" 2>/dev/null)
> +	phys_blk=$(echo "$fiemap_output" | _filter_xfs_io_fiemap | head -1 | awk '{print $3}')
> +	if [ -z "$phys_blk" ]; then
> +		echo ""
> +		return
> +	fi
> +	# Convert 512-byte blocks to bytes
> +	echo $((phys_blk * 512))
> +}
> +
> +_test_eof_zeroing()
> +{
> +	local test_name="$1"
> +	local extend_cmd="$2"
> +	local expected_new_sz="$3"
> +	local file=$SCRATCH_MNT/testfile_${test_name}
> +
> +	echo "$test_name" | tee -a $seqres.full
> +
> +	# Compute non-block-aligned EOF offset
> +	local gap_bytes=16
> +	local eof_offset=$((blksz - gap_bytes))
> +
> +	# Step 1: Write one full block to ensure the filesystem allocates a
> +	#         physical block for the file instead of using inline data.
> +	$XFS_IO_PROG -f -c "pwrite -S 0x5a 0 $blksz" -c fsync \
> +		"$file" >> $seqres.full 2>&1
> +
> +	# Step 2: Get physical block offset on device via FIEMAP
> +	local phys_offset
> +	phys_offset=$(_get_phys_offset "$file")
> +	if [ -z "$phys_offset" ]; then
> +		_fail "$test_name: failed to get physical block offset via fiemap"
> +	fi
> +
> +	# Step 3: Truncate file to non-block-aligned size and fsync.
> +	#         The on-disk region [eof_offset, blksz) may or may not be
> +	#         zeroed by the filesystem at this point.
> +	$XFS_IO_PROG -c "truncate $eof_offset" -c fsync \
> +		"$file" >> $seqres.full 2>&1
> +
> +	# Step 4: Unmount and restore the physical block to all-0x5a on disk.
> +	#         This bypasses the kernel's pagecache EOF-zeroing to ensure
> +	#         the stale pattern is present on disk. Then remount.
> +	_scratch_unmount
> +	$XFS_IO_PROG -d -c "pwrite -S 0x5a $phys_offset $blksz" \
> +		$SCRATCH_DEV >> $seqres.full 2>&1
> +	_scratch_mount >> $seqres.full 2>&1
> +
> +	# Step 5: Execute the extend operation.
> +	$XFS_IO_PROG -c "$extend_cmd" "$file" >> $seqres.full 2>&1
> +
> +	# Step 6: Verify gap [eof_offset, blksz) is zeroed BEFORE shutdown
> +	_check_gap_zero "$file" $eof_offset $gap_bytes "before shutdown" || return 1
> +
> +	# Step 7: Sync the extended range and shutdown the filesystem with
> +	#         journal flush. This persists the file size extending, and
> +	#         the filesystem should persist the zeroed data in the gap
> +	#         range as well.
> +	if [ "$extend_cmd" != "${extend_cmd#pwrite}" ]; then
> +		$XFS_IO_PROG -c "sync_range -w $blksz $blksz" \
> +			"$file" >> $seqres.full 2>&1
> +	fi
> +	_scratch_shutdown -f
> +
> +	# Step 8: Remount and verify gap is still zeroed
> +	_scratch_cycle_mount
> +
> +	# Verify file size was not rolled back after shutdown+remount
> +	local sz
> +	sz=$(stat -c %s "$file")
> +	if [ "$sz" -ne "$expected_new_sz" ]; then
> +		_fail "$test_name: file size rolled back after shutdown+remount: $sz != $expected_new_sz"
> +	fi
> +
> +	_check_gap_zero "$file" $eof_offset $gap_bytes "after shutdown+remount" || return 1
> +}
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +blksz=$(_get_block_size $SCRATCH_MNT)
> +
> +# Test three variants of EOF-extending operations
> +_test_eof_zeroing "append_write" "pwrite -S 0x42 $blksz $blksz" $((blksz * 2))
> +_test_eof_zeroing "truncate_up" "truncate $((blksz * 2))" $((blksz * 2))
> +_test_eof_zeroing "fallocate" "falloc $blksz $blksz" $((blksz * 2))
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/790.out b/tests/generic/790.out
> new file mode 100644
> index 00000000..e5e2cc09
> --- /dev/null
> +++ b/tests/generic/790.out
> @@ -0,0 +1,4 @@
> +QA output created by 790
> +append_write
> +truncate_up
> +fallocate
> -- 
> 2.52.0
> 

