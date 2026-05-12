Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0421342509;
	Tue, 12 May 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609376; cv=none; b=KPq+XVRPDFCWHazyTpcJBzCyGeAgMofr88qqlcH0+vIA7WdabAzafWI3h+YKmoePBlCn8zx8aGi0uQOnBH87UyeENeOGcYKCexH+grUa8GhA7i2tYQc/gVWRLf168pJSuu1Wy4cK61V43dcazVDFseXAR4e4ggsz70wFkU20FkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609376; c=relaxed/simple;
	bh=NSlA8PXwaSQBg9lRU0nicIqgs5LnnxiwnlmBNMi6WY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lw5qzI4KUbfSS6n0JBkH8+F52EkvQ9T66v09DtFyynSJiHe8qRBBjxW+BZ9QyVB4WQmxK3X+p4pkS9HI9NlbWW2UaSqDMCclWIkygKkkgkymLPZMROPUN8zcfAl+bZwfrvZ2dtQdiIixeUHwpvqJQUv+sP0Cq1lIfBVKa9LEQ4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0VkP0b5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0VkP0b5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC46DC2BCC7;
	Tue, 12 May 2026 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778609375;
	bh=NSlA8PXwaSQBg9lRU0nicIqgs5LnnxiwnlmBNMi6WY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E0VkP0b5V95lhkKdR2N5aMoqVD85Idh3sajRyX4B+aoVPS8KwZvGe4exOrMTw/mvW
	 lcEVmjAZ0M9/U0fS+ZB3+o4jXPtK/f/ay370CQfmYALauVY8k6v/+yQqe5hTWvwthP
	 9RkwFZMEZjcVIhSN8yk39O/LF3KkNvbqo2j1YuH3b1ScsQyATbop+esKoYwk3iiqE5
	 AauiT7mX9rO8As179KanRivV+JxycQciVQbvh72mmS1+9ftrKRwlnzMq8rC8Sf6XsS
	 X5i1rxKg4Wd2Xyk2fhs+nrt2yRzZRg6McFesdNlk6X7EsoH6J6KdltcsMscctTVoE8
	 gUHsk7uFfoEpw==
Date: Tue, 12 May 2026 11:09:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, fstests@vger.kernel.org,
	zlang@kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
	yizhang089@gmail.com, yangerkun@huawei.com
Subject: Re: [PATCH v3] generic/790: test post-EOF gap zeroing persistence
Message-ID: <20260512180935.GB9544@frogsfrogsfrogs>
References: <20260428085750.1072612-1-yi.zhang@huaweicloud.com>
 <afHqVR7WwYgawwVm@bfoster>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afHqVR7WwYgawwVm@bfoster>

On Wed, Apr 29, 2026 at 07:24:05AM -0400, Brian Foster wrote:
> On Tue, Apr 28, 2026 at 04:57:50PM +0800, Zhang Yi wrote:
> > From: Zhang Yi <yi.zhang@huawei.com>
> > 
> > Test that extending a file past a non-block-aligned EOF correctly
> > zero-fills the gap [old_EOF, block_boundary), and that this zeroing
> > persists through a filesystem shutdown+remount cycle.
> > 
> > Stale data beyond EOF can persist on disk when append write data blocks
> > are flushed before the on-disk file size update, or when concurrent
> > append writeback and mmap writes persist non-zero data past EOF.
> > Subsequent post-EOF operations (append write, fallocate, truncate up)
> > must zero-fill and persist the gap to prevent exposing stale data.
> > 
> > The test pollutes the file's last physical block (via FIEMAP + raw
> > device write) with a sentinel pattern beyond i_size, then performs each
> > extend operation and verifies the gap is zeroed both in memory and on
> > disk.

Hmm.  So this test fails on ext4, which apparently doesn't persist the
isize update, which seems like a reasonable behaveior.

It also complains about seeing the 0x5a pattern on xfs, which surprises
me a little.  Is that a bug in xfs, and is someone working on that?

--D

> > 
> > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > v2->v3:
> >  - Add error check for the raw device pwrite, a failed pwrite would
> >    silently leave the test continuing with an unpolluted block,
> >    producing false-positive passes.
> >  - Add sync_range -a to wait until the extending I/O completes and to
> >    ensure file size update is persisted before shutdown, preventing
> >    unexpected file size errors.
> > v1->v2:
> >  - Add _require_no_realtime to prevent testing on XFS realtime devices,
> >    where file data may reside on $SCRATCH_RTDEV.
> >  - Add _exclude_fs btrfs since FIEMAP returns logical addresses, not
> >    physical device offsets, writing to these offsets on $SCRATCH_DEV
> >    would corrupt the filesystem in multi-device setups. Besides, since
> >    btrfs doesn't support shutdown right now, we can support it later.
> >  - Add -v flag to od in _check_gap_zero() to prevent line folding of
> >    identical consecutive lines.
> >  - Add expected_new_sz parameter to _test_eof_zeroing(), verify file
> >    size was not rolled back after shutdown+remount cycle, and also drop
> >    the unnecessary file size check before the shutdown as well.
> >  - Clarify the comment regarding when stale data beyond EOF can persist.
> > 
> >  tests/generic/790     | 168 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/790.out |   4 +
> >  2 files changed, 172 insertions(+)
> >  create mode 100755 tests/generic/790
> >  create mode 100644 tests/generic/790.out
> > 
> > diff --git a/tests/generic/790 b/tests/generic/790
> > new file mode 100755
> > index 00000000..6daf3793
> > --- /dev/null
> > +++ b/tests/generic/790
> > @@ -0,0 +1,168 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Huawei.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 790
> > +#
> > +# Test that extending a file past a non-block-aligned EOF correctly zero-fills
> > +# the gap [old_EOF, block_boundary), and that this zeroing persists through a
> > +# filesystem shutdown+remount cycle.
> > +#
> > +# Stale data beyond EOF can persist on disk when:
> > +# 1) append write data blocks are flushed before the on-disk file size update,
> > +#    and the system crashes in this window.
> > +# 2) concurrent append writeback and mmap writes persist non-zero data past EOF.
> > +#
> > +# Subsequent post-EOF operations (append write, fallocate, truncate up) must
> > +# zero-fill and persist the gap to prevent exposing stale data.
> > +#
> > +# The test pollutes the file's last physical block (via FIEMAP + raw device
> > +# write) with a sentinel pattern beyond i_size, then performs each extend
> > +# operation and verifies the gap is zeroed both in memory and on disk.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw shutdown
> > +
> > +. ./common/filter
> > +
> > +_require_scratch
> > +_require_block_device $SCRATCH_DEV
> > +_require_no_realtime
> > +_require_scratch_shutdown
> > +_require_metadata_journaling $SCRATCH_DEV
> > +
> > +# FIEMAP on Btrfs returns logical addresses within the filesystem's address
> > +# space, not physical device offsets. Writing to these offsets on $SCRATCH_DEV
> > +# would corrupt the filesystem in multi-device setups.
> > +_exclude_fs btrfs
> > +
> > +_require_xfs_io_command "fiemap"
> > +_require_xfs_io_command "falloc"
> > +_require_xfs_io_command "pwrite"
> > +_require_xfs_io_command "truncate"
> > +_require_xfs_io_command "sync_range"
> > +
> > +# Check that gap region [offset, offset+nbytes) is entirely zero
> > +_check_gap_zero()
> > +{
> > +	local file="$1"
> > +	local offset="$2"
> > +	local nbytes="$3"
> > +	local label="$4"
> > +	local data
> > +	local stripped
> > +
> > +	data=$(od -A n -t x1 -v -j $offset -N $nbytes "$file" 2>/dev/null)
> > +
> > +	# Remove whitespace and check if any byte is non-zero
> > +	stripped=$(printf '%s' "$data" | tr -d ' \n\t')
> > +	if [ -n "$stripped" ] && ! echo "$stripped" | grep -qE "^0+$"; then
> > +		echo "FAIL: non-zero data in gap [$offset,$((offset + nbytes))) $label"
> > +		_hexdump -N $((offset + nbytes)) "$file"
> > +		return 1
> > +	fi
> > +	return 0
> > +}
> > +
> > +# Get the physical block offset (in bytes) of the file's first block on device
> > +_get_phys_offset()
> > +{
> > +	local file="$1"
> > +	local fiemap_output
> > +	local phys_blk
> > +
> > +	fiemap_output=$($XFS_IO_PROG -r -c "fiemap -v" "$file" 2>/dev/null)
> > +	phys_blk=$(echo "$fiemap_output" | _filter_xfs_io_fiemap | head -1 | awk '{print $3}')
> > +	if [ -z "$phys_blk" ]; then
> > +		echo ""
> > +		return
> > +	fi
> > +	# Convert 512-byte blocks to bytes
> > +	echo $((phys_blk * 512))
> > +}
> > +
> > +_test_eof_zeroing()
> > +{
> > +	local test_name="$1"
> > +	local extend_cmd="$2"
> > +	local expected_new_sz="$3"
> > +	local file=$SCRATCH_MNT/testfile_${test_name}
> > +
> > +	echo "$test_name" | tee -a $seqres.full
> > +
> > +	# Compute non-block-aligned EOF offset
> > +	local gap_bytes=16
> > +	local eof_offset=$((blksz - gap_bytes))
> > +
> > +	# Step 1: Write one full block to ensure the filesystem allocates a
> > +	#         physical block for the file instead of using inline data.
> > +	$XFS_IO_PROG -f -c "pwrite -S 0x5a 0 $blksz" -c fsync \
> > +		"$file" >> $seqres.full 2>&1
> > +
> > +	# Step 2: Get physical block offset on device via FIEMAP
> > +	local phys_offset
> > +	phys_offset=$(_get_phys_offset "$file")
> > +	if [ -z "$phys_offset" ]; then
> > +		_fail "$test_name: failed to get physical block offset via fiemap"
> > +	fi
> > +
> > +	# Step 3: Truncate file to non-block-aligned size and fsync.
> > +	#         The on-disk region [eof_offset, blksz) may or may not be
> > +	#         zeroed by the filesystem at this point.
> > +	$XFS_IO_PROG -c "truncate $eof_offset" -c fsync \
> > +		"$file" >> $seqres.full 2>&1
> > +
> > +	# Step 4: Unmount and restore the physical block to all-0x5a on disk.
> > +	#         This bypasses the kernel's pagecache EOF-zeroing to ensure
> > +	#         the stale pattern is present on disk. Then remount.
> > +	_scratch_unmount
> > +	$XFS_IO_PROG -d -c "pwrite -S 0x5a $phys_offset $blksz" \
> > +		$SCRATCH_DEV >> $seqres.full 2>&1
> > +	if [ $? -ne 0 ]; then
> > +		_fail "$test_name: failed to inject stale data on disk"
> > +	fi
> > +	_scratch_mount >> $seqres.full 2>&1
> > +
> > +	# Step 5: Execute the extend operation.
> > +	$XFS_IO_PROG -c "$extend_cmd" "$file" >> $seqres.full 2>&1
> > +
> > +	# Step 6: Verify gap [eof_offset, blksz) is zeroed BEFORE shutdown
> > +	_check_gap_zero "$file" $eof_offset $gap_bytes "before shutdown" || return 1
> > +
> > +	# Step 7: Sync the extended range and shutdown the filesystem with
> > +	#         journal flush. This persists the file size extending, and
> > +	#         the filesystem should persist the zeroed data in the gap
> > +	#         range as well.
> > +	if [ "$extend_cmd" != "${extend_cmd#pwrite}" ]; then
> > +		$XFS_IO_PROG -c "sync_range -w $blksz $blksz" \
> > +			-c "sync_range -a $blksz $blksz" \
> > +			"$file" >> $seqres.full 2>&1
> > +	fi
> > +	_scratch_shutdown -f
> > +
> > +	# Step 8: Remount and verify gap is still zeroed
> > +	_scratch_cycle_mount
> > +
> > +	# Verify file size was not rolled back after shutdown+remount
> > +	local sz
> > +	sz=$(stat -c %s "$file")
> > +	if [ "$sz" -ne "$expected_new_sz" ]; then
> > +		_fail "$test_name: file size rolled back after shutdown+remount: $sz != $expected_new_sz"
> > +	fi
> > +
> > +	_check_gap_zero "$file" $eof_offset $gap_bytes "after shutdown+remount" || return 1
> > +}
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +blksz=$(_get_block_size $SCRATCH_MNT)
> > +
> > +# Test three variants of EOF-extending operations
> > +_test_eof_zeroing "append_write" "pwrite -S 0x42 $blksz $blksz" $((blksz * 2))
> > +_test_eof_zeroing "truncate_up" "truncate $((blksz * 2))" $((blksz * 2))
> > +_test_eof_zeroing "fallocate" "falloc $blksz $blksz" $((blksz * 2))
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/790.out b/tests/generic/790.out
> > new file mode 100644
> > index 00000000..e5e2cc09
> > --- /dev/null
> > +++ b/tests/generic/790.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 790
> > +append_write
> > +truncate_up
> > +fallocate
> > -- 
> > 2.52.0
> > 
> 
> 
