Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794667425;
	b=HROv2J6MDYWts8K2LkKEzP4El9yopIJo5izPxCiy8nNf/5jAFmAtZ/PZCWdvB1aekmL2
	 FRCIUS8tOj9keOMGhm6bcuZjrgvydQRFcJRBElj0mpkaSqNOlmyW+/Gg/Kk5Xs74XCh7v
	 nbINhSny8hSJJMVv8edu4cxzWFe59KiK8aZOm433sa8qQZzFWy94sxohBFlt9HGkVuKNa
	 asMoZABMsWXhYQv95gP+8DzeL1cTK7mai7QjYoIe3Wp4yF3haWl3wKtkLLORd+ffypKnq
	 kXQr2XqFpqv9tFG0YW+IiTmzEwSt8fEe5GdGNSpNzxOlNSpe6Ats53cKlnzGPLgZtVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794667425;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=D2yN8XSK8IRukjQFMJzTOXwYoMwXpmWiF1CmFkNggBg=;
	b=0vlcGd6mrDeMux6rNHDSwSvFZoKXSj2GSqws9EVGYWjyaiPBekxj8b4fxRB4VLZpRKPZ
	 4hf90qkHKoE0lt5wT1U1jEheaT6FCbEX7w3aLJd9s8aquQYrM9UZGXlG5D2DWTag6JxCe
	 4dUiNUHD3cMm38AcT52yMH9woPcdMKCao1gzM7iljADcHAYpWrJq9FJ6x0/wx2Qe8pQp5
	 EmwgY/CKqq8Nl9EFUQxPCHO6uswSonV2EUogukk+m/uUw8o2LeVkcponEe6l86zNL4kSp
	 IdF85yu9vuzgxFfXpu5hJwMZc0KTMYGF2U3G4IKzosVbBFbyt4WujSYm1zY+LUv6AIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MiY05kss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A65606A327;
	Sat, 14 Nov 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MiY05kss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA751F000C4;
	Sat, 14 Nov 2026 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794667425;
	bh=D2yN8XSK8IRukjQFMJzTOXwYoMwXpmWiF1CmFkNggBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MiY05kssgGDY+mAaJPSyTcYqNHN0cM5BpJs9wQ7XHnrlN0sZCASWK/KbGAELVFp5n
	 0AN7XursgxBdZndX3iOOsnlXNAv210xf8sVmg4jT2ASBGKQvw6dgu8gqqst9NPhu3i
	 d6ZXLCw3HCUFzBsFUsqetXmOuFQpeI6FZ5henbXuBopYZ0g2UdJKi06N09BYZmX52E
	 iehm7VBLo6D0i8KUUNAKSa4Ef2pPxJuQc77CfsCcLMEpsCjVF4+pr0Vc2NOB01hBky
	 cDOw99Y1Zic3HvO2x2viaZIexbHLsqChDW7523NlKywsMVZRu1c6us7j4aPzw8hzjn
	 ldYXFgsRSv6tQ==
Date: Sat, 14 Nov 2026 22:43:34 +0800
From: Zorro Lang <zlang@kernel.org>
To: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Cc: fstests@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3] ext4: test reserved GID block allocation
Message-ID: <avhzI91nfjzFf04P@zlang-mailbox>
Mail-Followup-To: Sahaj Chaudhari <sahaj123.sc@gmail.com>, 
	fstests@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
References: <20261110182040.798390-1-sahaj123.sc@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110182040.798390-1-sahaj123.sc@gmail.com>

On Tue, Nov 10, 2026 at 11:50:40PM +0530, Sahaj Chaudhari wrote:
> Create a small ext4 filesystem with a nonzero reserved block pool and a
> reserved GID stored in the superblock. Fill ordinary free space as an
> unprivileged user outside that group, verify that another allocation is
> denied, then verify that the same user can allocate a block with the
> reserved group as its primary and only supplementary group.
> 
> This exercises loading s_resgid from the superblock rather than overriding
> it with a resgid mount option, and detects the regression fixed by:
> 
> commit c87abbab6147 ("ext4: fix incorrect function call when initializing s_resgid")
> 
> Link: https://lore.kernel.org/r/20261008065651.3517824-1-sahaj123.sc@gmail.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
> ---
> Changes since v2:
> - Use fsgqa2 instead of root for the fill group, and require it explicitly.
> - Do not inherit external MKFS_OPTIONS; exclude journal-dependent mount
>   options for the test's no-journal filesystem.
> - Check tune2fs and su -g/-G support, and use the validated su executable
>   consistently.
> - Require the fill operation to write data and reach ENOSPC; check that
>   ordinary allocation also fails specifically with ENOSPC.
> - Let the check harness unmount scratch and finish with _exit 0.
> - Add Jan Kara's Reviewed-by.

Thanks, this version looks good to me now.

Reviewed-by: Zorro Lang <zlang@kernel.org>

> 
> Testing:
> - ./check ext4/309 in isolated x86-64 QEMU with fresh TEST_DEV and
>   SCRATCH_DEV images passes on the fixed kernel and fails specifically
>   at reserved-GID allocation on the pre-c87abbab6147 kernel.
> - Both filesystems pass e2fsck -fn after each run.
> - bash -n and git diff --check pass. Validation is limited to ext4/309,
>   not the full xfstests suite.
> 
>  tests/ext4/309     | 75 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/309.out |  2 ++
>  2 files changed, 77 insertions(+)
>  create mode 100755 tests/ext4/309
>  create mode 100644 tests/ext4/309.out
> 
> diff --git a/tests/ext4/309 b/tests/ext4/309
> new file mode 100755
> index 00000000..e5dcd215
> --- /dev/null
> +++ b/tests/ext4/309
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Sahaj Chaudhari.  All Rights Reserved.
> +#
> +# FS QA Test No. 309
> +#
> +# Verify that the ext4 reserved GID can allocate blocks after ordinary
> +# free space is exhausted.
> +#
> +. ./common/preamble
> +_begin_fstest auto enospc quick
> +
> +_exclude_fs ext2
> +_exclude_fs ext3
> +_exclude_scratch_mount_option "resuid=" "resgid=" "data=" \
> +	"data_err=abort" "commit=" "journal_async_commit" "journal_checksum"
> +
> +_fixed_by_kernel_commit c87abbab6147 \
> +	"ext4: fix incorrect function call when initializing s_resgid"
> +
> +_require_scratch
> +_require_command "$TUNE2FS_PROG" tune2fs
> +_require_xfs_io_command "falloc"
> +_require_user
> +_require_group
> +RES_GROUP=$qa_group
> +_require_group fsgqa2
> +FILL_GROUP=fsgqa2
> +SU_PROG=$(command -v su) || _notrun "su utility required"
> +"$SU_PROG" -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" \
> +	-c true >/dev/null 2>&1 ||
> +	_notrun "su with -g and -G support required"
> +
> +echo "Silence is golden"
> +
> +RESGID=$(_cat_group | awk -F: -v group="$RES_GROUP" \
> +	'$1 == group { print $3 }')
> +FILLGID=$(_cat_group | awk -F: -v group="$FILL_GROUP" \
> +	'$1 == group { print $3 }')
> +[ "$RESGID" != "$FILLGID" ] || _notrun "reserved and fill groups are identical"
> +[ "$(id -u "$qa_user")" -ne 0 ] || _notrun "test user is root"
> +TEST_FILE="$SCRATCH_MNT/ext4_resgid.fill"
> +
> +MKFS_OPTIONS="-m 10 -N 1024 -O ^has_journal" \
> +	_scratch_mkfs_sized $((16 * 1024 * 1024)) 4096 >>"$seqres".full 2>&1
> +"$TUNE2FS_PROG" -u 0 -g "$RESGID" "$SCRATCH_DEV" >>"$seqres".full 2>&1 ||
> +	_fail "could not set scratch filesystem reserved GID"
> +_scratch_mount
> +
> +touch "$TEST_FILE"
> +chmod 0666 "$TEST_FILE"
> +
> +FILL_OUTPUT=$("$SU_PROG" -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" \
> +	"$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 16M' '$TEST_FILE'" 2>&1)
> +FILL_STATUS=$?
> +printf '%s\n' "$FILL_OUTPUT" >>"$seqres".full
> +printf '%s\n' "$FILL_OUTPUT" | grep -q "pwrite: No space left on device" ||
> +	_fail "space-fill operation did not reach ENOSPC (status $FILL_STATUS)"
> +FILL_SIZE=$(_get_filesize "$TEST_FILE") ||
> +	_fail "could not determine space-fill file size"
> +[ "$FILL_SIZE" -gt 0 ] || _fail "space-fill operation wrote no data"
> +
> +if ALLOC_OUTPUT=$("$SU_PROG" -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" \
> +	"$qa_user" -c "$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" 2>&1); then
> +	_fail "ordinary user allocated from the reserved pool"
> +fi
> +printf '%s\n' "$ALLOC_OUTPUT" >>"$seqres".full
> +printf '%s\n' "$ALLOC_OUTPUT" | grep -q "fallocate: No space left on device" ||
> +	_fail "ordinary allocation failed for a reason other than ENOSPC"
> +
> +"$SU_PROG" -s /bin/bash -g "$RES_GROUP" -G "$RES_GROUP" "$qa_user" -c \
> +	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
> +	>>"$seqres".full 2>&1 || _fail "reserved GID failed to allocate a block"
> +
> +_exit 0
> diff --git a/tests/ext4/309.out b/tests/ext4/309.out
> new file mode 100644
> index 00000000..56330d65
> --- /dev/null
> +++ b/tests/ext4/309.out
> @@ -0,0 +1,2 @@
> +QA output created by 309
> +Silence is golden
> 
> base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
> -- 
> 2.43.0
> 
