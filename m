Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518EC3CEB85
	for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776864179; cv=none; b=S6ayVfESNw4dzG1gcV/BMqRdgWLAEe8JCD/Dzb1No8bUaoJIYhl1WSglc6Ota3QHpAQtLiExz5JvbC2hNUm18h6BHWzkB9PMT8sh3y/x83+FXYeV4v95Co94qT/ZaA+ZOKNCfFDStPkjhwRIv5hBJHJ/RQ9vrvD8wBYEk7mC55I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776864179; c=relaxed/simple;
	bh=sTbTl1ZyqHMDwGo0rU8YM51F5iFis9FwO8WjmorfwmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOcd6LVnTk7EFrxCvhRBTrs0E92M+bcdYhrzx4RTcBZVTplCiHHN+KWSpGBjd8HTMuMaXhIL2JpEOMvHyPy9pXn0Zzm8yaPDcNsMFMbpcsP99LGhE6//GJzjIPFvHXBlwT0x9GUf1qrUvDgZhpvzs9ycSa662bczlrywsZX2PoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HgkX+nbB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgkX+nbB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776864177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99lpaYvrEMn1O3IXIzKhH6DKTKViuZzIem8oOh6SGRU=;
	b=HgkX+nbBxrGR9plNkB2wFUiVUTuzu7zujClxyesAAgTzNJUBQK/TnVnAy3Pd6dcedJ8+O0
	MyEvP4FSiOHQmOnqDejR19syUBF/I7sCoNhGu0S91e0dd0/hXrQjkoTrWA/Z2ld+pU7b2z
	YTNxqN7mnAXUmRqSoaRG509kV5wxdQw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-Uhp1U9AIMkOWiK6O9CQbFg-1; Wed,
 22 Apr 2026 09:22:54 -0400
X-MC-Unique: Uhp1U9AIMkOWiK6O9CQbFg-1
X-Mimecast-MFC-AGG-ID: Uhp1U9AIMkOWiK6O9CQbFg_1776864172
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80B6B1955F18;
	Wed, 22 Apr 2026 13:22:51 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.73])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8C0F19560AB;
	Wed, 22 Apr 2026 13:22:49 +0000 (UTC)
Date: Wed, 22 Apr 2026 09:22:47 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
	yizhang089@gmail.com, yangerkun@huawei.com
Subject: Re: [PATCH] generic/790: test post-EOF gap zeroing persistence
Message-ID: <aejLp-m2-0h6q0RE@bfoster>
References: <20260422015246.4132376-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422015246.4132376-1-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Apr 22, 2026 at 09:52:46AM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Test that extending a file past a non-block-aligned EOF correctly
> zero-fills the gap [old_EOF, block_boundary), and that this zeroing
> persists through a filesystem shutdown+remount cycle.
> 
> Stale data beyond EOF can persist on disk when append write data blocks
> are flushed before the i_size metadata update, or when concurrent append
> writeback and mmap writes persist non-zero data past EOF. Subsequent
> post-EOF operations (append write, fallocate, truncate up) must
> zero-fill and persist the gap to prevent exposing stale data.
> 
> The test pollutes the file's last physical block (via FIEMAP + raw
> device write) with a sentinel pattern beyond i_size, then performs each
> extend operation and verifies the gap is zeroed both in memory and on
> disk.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
> This is the case Jan Kara pointed out during my work on the ext4
> buffered I/O to iomap conversion. This case is similar to generic/363,
> but generic/363 doesn't provide persistent testing. For details:
> 
>  https://lore.kernel.org/linux-ext4/jgotl7vzzuzm6dvz5zfgk6haodxvunb4hq556pzh4hqqwvnhxq@lr3jiedhqh7c/
> 
>  tests/generic/790     | 155 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/790.out |   4 ++
>  2 files changed, 159 insertions(+)
>  create mode 100755 tests/generic/790
>  create mode 100644 tests/generic/790.out
> 
> diff --git a/tests/generic/790 b/tests/generic/790
> new file mode 100755
> index 00000000..5d8f61f9
> --- /dev/null
> +++ b/tests/generic/790
> @@ -0,0 +1,155 @@
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

Nice test! This is a great idea.

> +# Stale data beyond EOF can persist on disk when:
> +# 1) append write data blocks are flushed before the i_size metadata update,
> +#    and the system crashes in this window.

Maybe it's wording or I'm missing something, but how would "append write
data blocks" be flushed before i_size updates? Wouldn't writeback toss
them or zero the post-eof range of a folio? Do you mean to refer to
"on-disk size update" specifically (where I'm reading it as
inode->i_isize)?

> +# 2) concurrent append writeback and mmap writes persist non-zero data past EOF.
> +#
> +# Subsequent post-EOF operations (append write, fallocate, truncate up) must
> +# zero-fill and persist the gap to prevent exposing stale data.
> +#
> +# The test pollutes the file's last physical block (via FIEMAP + raw device
> +# write) with a sentinel pattern beyond i_size, then performs each extend
> +# operation and verifies the gap is zeroed both in memory and on disk.
> +#
...
> +_test_eof_zeroing()
> +{
> +	local test_name="$1"
> +	local extend_cmd="$2"
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
> +	# Verify file size is still eof_offset after remount
> +	local sz
> +	sz=$(stat -c %s "$file")
> +	if [ "$sz" -ne "$eof_offset" ]; then
> +		_fail "$test_name: file size wrong after remount: $sz != $eof_offset"
> +	fi

I was initially curious why we'd want to do this, but after further
thought I wonder if it might make more sense to check file size against
the extended size after the shutdown/mount cycle below (but before
checking the gap range). That way we know the size update was
logged/recovered correctly and we're about to read from a file range
within eof. Hm?

Those couple nits aside this all looks pretty good to me.

Brian

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
> +	_check_gap_zero "$file" $eof_offset $gap_bytes "after shutdown+remount" || return 1
> +}
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +blksz=$(_get_block_size $SCRATCH_MNT)
> +
> +# Test three variants of EOF-extending operations
> +_test_eof_zeroing "append_write" "pwrite -S 0x42 $blksz $blksz"
> +_test_eof_zeroing "truncate_up" "truncate $((blksz * 2))"
> +_test_eof_zeroing "fallocate" "falloc $blksz $blksz"
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
> 

