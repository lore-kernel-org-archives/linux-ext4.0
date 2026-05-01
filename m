Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C241B35C
	for <linux-ext4@vger.kernel.org>; Fri,  1 May 2026 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777654001; cv=none; b=Pj8zejMy7zsDS33FlBGKLYcnKl2B8ro4iLRGdpOdnpP7U6KnKFBVYAYsia1QXs6lGlMDsxt20YKHo/jWNJh0+46SZAEMHkA7aR4WPxY67m9lVf44Bu2+IPMmwKhhZlRCtJThVw8thg+GZlqBJ4Db1nxq/NpH+7oxL/YSIsikEB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777654001; c=relaxed/simple;
	bh=nS1JEwXuSEMQqIwqn6vvKmnnkPh11+Um6cYYeSU7MmU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oILMSfj54vueyf7hDOXzcb8h/w+7SbMCOr2RXPoQZ63Stg9FFnrwyPMJgWRgxC8FJackdovlGJAi9PWHSlud0HH/L3gT8cV93poXGFBzpqmFXk3bVpCIrrzGe+NGlVHXlE81F7pYd+SgESLvo8qkLnSXDnEt2uBP7JvQKOLxFNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBdPtMCN; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBdPtMCN"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ab46931cf1so20555925ad.0
        for <linux-ext4@vger.kernel.org>; Fri, 01 May 2026 09:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777653990; x=1778258790; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEk9+tR6w5DSSU4GT6TPKec767CGUcJqj2tfyjWPJDs=;
        b=cBdPtMCNCoDLD9dSw62+ORKmFEy5bakT+Gs/uSHu4Pi7H7MZuJxWUUzleU1cywu1k+
         89pqFiejLHBBFqWjnJG6lPsAbJ8xFke2ift0KiJiSyEz/OXIvQ/rssSxgN24WRPWECwN
         QVfnK+FFZczt4HIm2kok0o7n6sUR6DrENwZRzXUbS9Ww2qEk3Vx1asC0gbjWveTb+9gL
         gGzPGz9AlnvBDX6E2xEm7dA2/9/1bFaWcTFv159b62JO3nLR4qoEvo6ToqrBl3fFVyVC
         /0Rl21sLBiPY+Tv1oZ6FQzCXnje/83VLHgRimbGCXSJx6PWWn4wH+fG/Cya0G34vTezd
         1RLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777653990; x=1778258790;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TEk9+tR6w5DSSU4GT6TPKec767CGUcJqj2tfyjWPJDs=;
        b=gfB9IrqD0wGAOKg8zLFXuwi1Ejfza5aW86O2BXXU3XzITpWKc5gTkr6gdt175Ve25x
         87Gt7Glaa8eEO58OLF9+9RchG4kfEfDvYMH0349mSEj2g4z8U8F2FiExtBLoFkWSejio
         XbiUTfmBBUmWGfm/xI6rGlGbtt92yWGS5JDyHzEdTzoVnmoWIzmWip5/DY0BUPDQJDu4
         lbMiYDGO1fPtT3DGW84iH9pX8chVArm0bk0SCTD/SG6Zhm06eGJHCzPD+N1GLZ4mmbXN
         ag3354x+qvGVpSyz/1yMSNH08M/7B3Yv3psIFdjKIYyRQGdFQiPpOk6+/LecCOy4sCgu
         0lVQ==
X-Forwarded-Encrypted: i=1; AFNElJ/S/5QLvLTYBkAMaNwih2ssLNoR/ufMPGlVffcrJZzAL5lB/VIoqTaxnc7HTENdzlAiRnnExxSuK+6q@vger.kernel.org
X-Gm-Message-State: AOJu0YzynLR8NCqYLu0QpF3OtzY1mmd6VOHHsb/7/5gzT6fqYn61IC3b
	NBGlQmntkEBgNQbvaTWz1qnh1kXvgtkw0IO5Cu/AtThy+kLjXyyvwZOY
X-Gm-Gg: AeBDieszU+EWsxGd0W1hIDP0r2F1lVEAEnVtCv9ajkpuLxJ4tLjxrohWlAN/7j43KI7
	Ny7exlWT+D4bziLWmCi8m1qF8ed4W6NyRiKJYxTgpIamB2dhIWASBstAxQUsSAGuvsBrAVPDmqg
	15Z/bFDsoHSHbT8BilCGllHAZ88NefXBMe6QH3uGRwP/p3Xtg97GNxJwPsLH87n2NfTDgLCwuS8
	slQKCAQHFW2E5ZXulWkFb1nqyL6LkAk2Diew6u+m6/4/VXzNLz20TQN1xDMsjeGo7niV/w48Cr0
	6xrsJcyqHNrD1LfOE3Oz2K/oHMwYmP0TatgDFhAQzd7lY1VvoD57XRO/3B1VT1PfQFxWSxQsDrG
	MEuNzucawrBatG25vcCCBPlTXv7kgyQXW+7wjSPEM4w60XkvdhszfbyqU+3cuZzIZkMxkbqKdqk
	AeYI+UhcyL6kvl3B/PyMh/gtw5r6aZr6o=
X-Received: by 2002:a17:903:8ce:b0:2b4:68c9:302a with SMTP id d9443c01a7336-2b9a44bec2cmr67906645ad.17.1777653989961;
        Fri, 01 May 2026 09:46:29 -0700 (PDT)
Received: from zlang-mailbox ([218.69.128.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaae29dsm26749955ad.19.2026.05.01.09.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 09:46:29 -0700 (PDT)
From: Zorro Lang <zorro.lang@gmail.com>
X-Google-Original-From: Zorro Lang <zlang@kernel.org>
Date: Sat, 2 May 2026 00:46:21 +0800
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, bfoster@redhat.com, jack@suse.cz, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com
Subject: Re: [PATCH v3] generic/790: test post-EOF gap zeroing persistence
Message-ID: <afTXtkrW_6m-0Os3@zlang-mailbox>
Mail-Followup-To: Zhang Yi <yi.zhang@huaweicloud.com>, 
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	bfoster@redhat.com, jack@suse.cz, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com
References: <20260428085750.1072612-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428085750.1072612-1-yi.zhang@huaweicloud.com>

On Tue, Apr 28, 2026 at 04:57:50PM +0800, Zhang Yi wrote:
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
> v2->v3:
>  - Add error check for the raw device pwrite, a failed pwrite would
>    silently leave the test continuing with an unpolluted block,
>    producing false-positive passes.
>  - Add sync_range -a to wait until the extending I/O completes and to
>    ensure file size update is persisted before shutdown, preventing
>    unexpected file size errors.
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
>  tests/generic/790     | 168 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/790.out |   4 +
>  2 files changed, 172 insertions(+)
>  create mode 100755 tests/generic/790
>  create mode 100644 tests/generic/790.out
> 
> diff --git a/tests/generic/790 b/tests/generic/790
> new file mode 100755
> index 00000000..6daf3793
> --- /dev/null
> +++ b/tests/generic/790
> @@ -0,0 +1,168 @@
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

Add "fiemap" and "prealloc" groups, I'll do that when I merge it.

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
> +	if [ $? -ne 0 ]; then
> +		_fail "$test_name: failed to inject stale data on disk"
> +	fi
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
> +			-c "sync_range -a $blksz $blksz" \
> +			"$file" >> $seqres.full 2>&1
> +	fi
> +	_scratch_shutdown -f

Wow, the usage of sync_range in step#7 is impressive !

Reviewed-by: Zorro Lang <zlang@kernel.org>

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
