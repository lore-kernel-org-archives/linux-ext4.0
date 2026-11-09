Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239662;
	b=024SA7HTNXH8qlJS6qhBcPzwmmQgu+LYLCZ1JKv9vmFPTqA2d64mw2B2mspUDnjnD+c1
	 PoLHh1ZdYJC0FOkl3KJ1X5BJu55AEAGFiAmAyDGuYBqUUDvCn50fOb6fP6ZcDOzRnUtnJ
	 z75yMuhFXF/zPsieZdSTn7Xy+0GDI3mX/afYpLMv333NjOTeZRkgrmVQMSd3G7PV6za2I
	 VxtzC9ew2ZFpV90Uo4nVfJwfxvynMp5YfwNstMKx9o53EQ+3Abp9VmA+ivnIDbV9Qj7YI
	 p1qjUt+m5z4lwa+e+ZWLG5nt+xAgjENxjMk73kj6M2ESoOnzM6zotaSv2I4faNdCAig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239662;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=fvc6AsWebAVm0Y5nYl9x7FMY4SazPQJ9Oe9925Ax9H4=;
	b=y0+C2kRK0XyVCfrlcJPNxN4n7o0/VJOyR7kT5ZGwgDFzTM4Jk8mmQzo6eL+JQhKKPis6
	 Qo4sCCt/Z/UBDehQEmKTeSFC2MWf16VwyxDEXtU2ZkDrpm1ib8rgjn0eC1oMb/SzM0SpR
	 eW+lNjuTOVOC0K4KAUxkL6DVZw1Iq+DPitvBulnVw/q4muzKXzy/CeGVje876/TkhxFJH
	 7jGdkQL3kUPWfszqBoTgP4vDG0vz/NB+MkhFSWqTkaXsli4neRpP9QMXlVCDzR13uW9Bb
	 OwgIbVMwmO4dE6em9XDrlIbA/zjRQ+7mthzahz7KO5gTHoQuplJwPdz685EXcixE+CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4ayiCAB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F27606EEA3;
	Mon,  9 Nov 2026 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4ayiCAB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE861F008BD;
	Mon,  9 Nov 2026 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794239662;
	bh=fvc6AsWebAVm0Y5nYl9x7FMY4SazPQJ9Oe9925Ax9H4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R4ayiCABG9XXTAlFlkEg2y6/uAtH4AAx1ylJNHNhNb6Z7D3ZTvfpXZFKxe2sBUkhQ
	 6p8RrZITmHG3uQPGvs5wNebW/i4FwzjgRON7Wg1UmE4QPOwfsSeJcIkIvWHrYFSe1a
	 o0cQ2ixqRJ9G/6EBX8tjTiHQbXzZ2rygFNgeGoUfGLQ0yBsiiPDgjX3MDx79yTaxrL
	 /LA321RX1bzsCyc5/Cdsrckw5uSD522SB0QO0ldJRaYC5ESDPv/ECZXkvYSYwqJfUG
	 o8+T+CpfgvbzYXqZcwEGeWe4X7l9MUkZCzJ7e6ICRAm01g30JFo1SUrtPoKtrmY65R
	 eMVP1IoNAFPSA==
Date: Mon, 9 Nov 2026 23:54:11 +0800
From: Zorro Lang <zlang@kernel.org>
To: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Cc: fstests@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: test reserved GID block allocation
Message-ID: <avHdSRfwGNfhSfne@zlang-mailbox>
Mail-Followup-To: Sahaj Chaudhari <sahaj123.sc@gmail.com>, 
	fstests@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
References: <20261012112109.3363168-1-sahaj123.sc@gmail.com>
 <20261107193050.330685-1-sahaj123.sc@gmail.com>
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
In-Reply-To: <20261107193050.330685-1-sahaj123.sc@gmail.com>

On Sun, Nov 08, 2026 at 01:00:50AM +0530, Sahaj Chaudhari wrote:
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
> Use su and xfs_io for the credential changes and allocations instead of
> adding a dedicated C helper. Exclude mount options that override the
> reserved IDs and skip configurations without the required users, groups
> or fallocate support.
> 
> Link: https://lore.kernel.org/r/20261008065651.3517824-1-sahaj123.sc@gmail.com
> Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
> ---
> Changes since v1:
> - Replace the C helper and its build registration with su and xfs_io,
>   following Jan's and Zorro's suggestions.
> - Set both primary and supplementary groups explicitly, and compare
>   ordinary and reserved-GID allocations using the same unprivileged UID.
> - Exclude resuid/resgid mount overrides; leave _user_do unchanged.
> 
> Review:
> https://lore.kernel.org/all/j2dthue3fzup753jrndn6kh44qfvihx2bylmiwcoxubnrxpgdk@zx6shyx3hbb6/
> https://lore.kernel.org/all/aurRSqrRkEfyp6M7@zlang-mailbox/
> 
> Testing:
> - Exact ./check ext4/309 in x86-64 QEMU: ordinary allocation is denied
>   after filling free space; reserved-GID allocation succeeds on the fixed
>   kernel. The pre-c87abbab6147 kernel fails at the reserved-GID allocation
>   as expected. Both TEST_DEV and SCRATCH_DEV pass e2fsck -fn afterward.
> - Exact ./check ext4/309 passes natively on an AM642 ARM64 board running
>   6.12.57-ti-gd00ea986335d; both loop-backed filesystems pass e2fsck -fn.
> - Validation is limited to ext4/309, not the full xfstests suite.
> 
>  tests/ext4/309     | 63 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/309.out |  2 ++
>  2 files changed, 65 insertions(+)
>  create mode 100755 tests/ext4/309
>  create mode 100644 tests/ext4/309.out
> 
> diff --git a/tests/ext4/309 b/tests/ext4/309
> new file mode 100755
> index 00000000..3bd12009
> --- /dev/null
> +++ b/tests/ext4/309
> @@ -0,0 +1,63 @@
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
> +_exclude_scratch_mount_option "resuid=" "resgid="
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
> +_require_group root
> +FILL_GROUP=root

Is "root" necessary? xfstests doesn't typically use root group this way.
If you need two test users or groups, you can use "fsgqa2" or other
accounts in addition to the default "fsgqa". Refer to generic/698 for
an example.

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
> +MKFS_OPTIONS="-m 10 -N 1024 -O ^has_journal $MKFS_OPTIONS" \

This test already imposes fairly strict mkfs options on its own, so I don't
think it's necessary to inherit external MKFS_OPTIONS. It adds little value
and can easily cause mkfs to fail and abort the test I think.

> +	_scratch_mkfs_sized $((16 * 1024 * 1024)) 4096 >>"$seqres".full 2>&1
> +"$TUNE2FS_PROG" -u 0 -g "$RESGID" "$SCRATCH_DEV" >>"$seqres".full 2>&1
> +_scratch_mount
> +
> +touch "$TEST_FILE"
> +chmod 0666 "$TEST_FILE"
> +
> +su -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" -c \
> +	"$XFS_IO_PROG -f -c 'pwrite 0 16M' '$TEST_FILE'" \
> +	>>"$seqres".full 2>&1
> +
> +if su -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" -c \
> +	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
> +	>>"$seqres".full 2>&1; then
> +	_fail "ordinary user allocated from the reserved pool"
> +fi
> +
> +su -s /bin/bash -g "$RES_GROUP" -G "$RES_GROUP" "$qa_user" -c \
> +	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
> +	>>"$seqres".full 2>&1 || _fail "reserved GID failed to allocate a block"
> +
> +_scratch_unmount

If this's a part of test steps, we can remove this line.

> +status=0
> +exit

_exit 0

Thanks,
Zorro

> diff --git a/tests/ext4/309.out b/tests/ext4/309.out
> new file mode 100644
> index 00000000..56330d65
> --- /dev/null
> +++ b/tests/ext4/309.out
> @@ -0,0 +1,2 @@
> +QA output created by 309
> +Silence is golden
> -- 
> 2.43.0
