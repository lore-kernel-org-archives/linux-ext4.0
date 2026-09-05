Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2841DB95E;
	Sat,  5 Sep 2026 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788622071; cv=none; b=F2G8Ouq8iIVLvbO5qtEujZU8cWx6/nMirxkkycxPIw/0pGFCJc2foUPQxuE0o07szXpbaNbFI+GDmv6fW/YOGf/xjERqEXnldmL1OA6Y4Pw0F4WXq7LGI58lvcX+OraUwCYJ8iWwLMOpMT2KTEcn39EglxfbvR8EW/hwLRWF3D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788622071; c=relaxed/simple;
	bh=vexV5TrXBWoM+LeN6AQYn7G4o2gJcaFgRMjaxOsaVLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoYHJ/DYJkwcmMtyU0Rq4/kZ7dZpUHNKCdCWiDyG/im9GT5lZQCaUgwwCFn+0j3dOpPvHxRA0ZenYh5nf5r96ApWczudPoXUnzoGDqLyQuS4leeksYPEKiw1wjTlSgnssA10C03nbXxU6ZiMeN2zMZSnIyPwpe9YgF69d4k95PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kbd1P03C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kbd1P03C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533C61F00A3A;
	Sat,  5 Sep 2026 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788622069;
	bh=oXPG3E443mg49yOdoHTq867QOSJXqVGeFOpEPuUsAkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kbd1P03CNB03Z9DGT6VZTB+RRKrZE9rZHIobK1IeerC858ziwtqnln5ErtW8dFJvA
	 nlobbnSgk4tPLFckYoI28KYsHdnQ+CkLslJUerRyme+a+yiIw/bgk/FYEcyofnUUN9
	 l6J32ReYkRm8MjbhUuKi7SaRJn05o8xw4qzqbbh0IIgM7HuY8y1G51ryZpkvf1wIZ1
	 3HdHRBPGzDWVM+jmq9tVt6inHwplECuxWcsnxhNoVb+qFVBPqaK2uEXeHFpxjCVQLd
	 CtKXsrgoxUbI6/Z696L6LJx54RZYQlB17RT+hk0wBRfcNmPgcDBZCYI00EXsErVwMv
	 JvND2sS/MxkkQ==
Date: Sat, 5 Sep 2026 23:27:43 +0800
From: Zorro Lang <zlang@kernel.org>
To: guzebing <guzebing1612@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4/064: add regression test for delalloc remount leak
Message-ID: <apvzcUIAmWlBgJht@zlang-mailbox>
Mail-Followup-To: guzebing <guzebing1612@gmail.com>, 
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20260818064023.2309786-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818064023.2309786-1-guzebing1612@gmail.com>

On Tue, Aug 18, 2026 at 02:40:23PM +0800, guzebing wrote:
> A delalloc filesystem rejects a remount with nodelalloc, but ext4 used to
> apply the option change before rejecting the remount.  Concurrent buffered
> writes and truncates can observe the transient nodelalloc state and fail to
> release delayed allocation reservations.  The leaked reservations are then
> reported when the inodes are evicted during unmount.
> 
> Add an ext4 regression test that starts concurrent write/truncate workers and
> an expected-failing remount,nodelalloc worker, stops them after a short stress
> window, and checks dmesg for leaked delayed allocation reservations.
> 
> The proposed kernel fix is still under review:
> https://lore.kernel.org/linux-ext4/20260814034855.1573759-1-guzebing1612@gmail.com/
> 
> Local validation showed that the test fails without the proposed kernel fix,
> with i_reserved_data_blocks not cleared warnings during unmount, and passes
> with the proposed fix applied.
> 
> Signed-off-by: guzebing <guzebing1612@gmail.com>
> ---
>  tests/ext4/064     | 216 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/064.out |   2 +
>  2 files changed, 218 insertions(+)
>  create mode 100755 tests/ext4/064
>  create mode 100644 tests/ext4/064.out
> 
> diff --git a/tests/ext4/064 b/tests/ext4/064
> new file mode 100755
> index 00000000..5d43764c
> --- /dev/null
> +++ b/tests/ext4/064
> @@ -0,0 +1,216 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 guzebing.  All Rights Reserved.
> +#
> +# FS QA Test No. ext4/064

Did you write this line manually? Please remove "ext4/" part, or the tools/mvtest
can't match this line.

> +#
> +# Exercise rejected delalloc to nodelalloc remounts while buffered writes and
> +# truncates are active.  A remount used to clear EXT4_MOUNT_DELALLOC before
> +# rejecting the transition, so a concurrent truncate could fail to release
> +# delayed allocation reservations.  The leaked inode reservation is reported
> +# when the inode is evicted during unmount.
> +#
> +# This is a regression test for the issue fixed by the proposed patch:
> +# "ext4: reject delalloc to nodelalloc remount before applying options"
> +# https://lore.kernel.org/linux-ext4/20260814034855.1573759-1-guzebing1612@gmail.com/

_fixed_by_fs_commit ext4 xxxxxxxxxxxx \
    "ext4: reject delalloc to nodelalloc remount before applying options"

> +#
> +. ./common/preamble
> +_begin_fstest auto stress mount
> +
> +writer_pids=()
> +remounter_pid=
> +stop_file=$tmp.stop
> +worker_error=$tmp.worker_error
> +remounter_error=$tmp.remounter_error
> +remounter_count=$tmp.remounter_count
> +
> +stop_workload()
> +{
> +	touch "$stop_file"
> +	if [ -n "$remounter_pid" ]; then
> +		wait "$remounter_pid" 2>/dev/null
> +		remounter_pid=
> +	fi
> +	if [ "${#writer_pids[@]}" -gt 0 ]; then
> +		wait "${writer_pids[@]}" 2>/dev/null
> +		writer_pids=()
> +	fi
> +}
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	stop_workload
> +	cd /
> +	_is_dir_mountpoint "$SCRATCH_MNT" >/dev/null &&
> +		_scratch_unmount >/dev/null 2>&1

fstests/check automatically unmounts scratch and runs fsck at the end of each
test. You don't need to invoke _scratch_unmount in _cleanup unless an extra
unmount is explicitly required.

> +	rm -f "$stop_file" "$worker_error" "$worker_error".* \
> +		"$tmp.xfs_io_error".* "$remounter_error" "$remounter_count"

The original `rm -r -f $tmp.*` can remove all these files.

> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_exclude_fs ext2
> +_exclude_fs ext3
> +_exclude_scratch_mount_option "data=journal" "dax" "nodelalloc"
> +_require_check_dmesg
> +_require_scratch_size $((2 * 1024 * 1024))
> +_require_xfs_io_command "pwrite"
> +_require_xfs_io_command "truncate"
> +
> +record_worker_error()
> +{
> +	local command=$1
> +	local file=$2
> +	local err=$3
> +	local log=$worker_error.$BASHPID
> +
> +	{
> +		echo "worker failed:"
> +		echo "  command: $command"
> +		echo "  file: $file"
> +		echo "  stderr:"
> +		if [ -s "$err" ]; then
> +			sed 's/^/    /' "$err"
> +		else
> +			echo "    <empty>"
> +		fi
> +	} > "$log"
> +	touch "$worker_error"
> +}
> +
> +write_truncate_loop()
> +{
> +	local file=$1
> +	local err=$tmp.xfs_io_error.$BASHPID
> +
> +	while [ ! -e "$stop_file" ]; do
> +		$XFS_IO_PROG -f -c "pwrite -q 0 32m" "$file" \
> +			>/dev/null 2>"$err" || {
> +			record_worker_error \
> +				'xfs_io -f -c "pwrite -q 0 32m"' "$file" "$err"
> +			break
> +		}
> +		$XFS_IO_PROG -c "truncate 256k" "$file" \
> +			>/dev/null 2>"$err" || {
> +			record_worker_error \
> +				'xfs_io -c "truncate 256k"' "$file" "$err"
> +			break
> +		}
> +	done
> +	rm -f "$err"
> +}
> +
> +log_worker_errors()
> +{
> +	local log
> +
> +	test -e "$worker_error" || return 0
> +
> +	echo "write/truncate worker failure details:" >> "$seqres.full"
> +	for log in "$worker_error".*; do
> +		test -f "$log" || continue
> +		cat "$log" >> "$seqres.full"
> +	done
> +}
> +
> +remount_loop()
> +{
> +	local count=0
> +
> +	while [ ! -e "$stop_file" ]; do
> +		# This remount is expected to fail.  The bug is that ext4 used
> +		# to expose the transient nodelalloc state before failing it.
> +		if $MOUNT_PROG -o remount,nodelalloc "$SCRATCH_DEV" "$SCRATCH_MNT" \
> +			>/dev/null 2>&1; then
> +			echo "delalloc to nodelalloc remount unexpectedly succeeded" \
> +				> "$remounter_error"
> +			touch "$stop_file"
> +			break
> +		fi
> +		count=$((count + 1))
> +	done
> +	echo "$count" > "$remounter_count"
> +}
> +
> +log_remount_result()
> +{
> +	local remounts=0
> +
> +	if [ -s "$remounter_count" ]; then
> +		read -r remounts < "$remounter_count"
> +	fi
> +	echo "rejected remounts: $remounts" >> "$seqres.full"
> +
> +	if [ -s "$remounter_error" ]; then
> +		echo "remount worker failure details:" >> "$seqres.full"
> +		sed 's/^/  /' "$remounter_error" >> "$seqres.full"
> +	fi
> +}
> +
> +sleep_msg_ratelimit_interval()
> +{
> +	local dev=$(_short_dev "$SCRATCH_DEV")
> +	local interval_file=/sys/fs/ext4/$dev/msg_ratelimit_interval_ms

_require_fs_sysfs msg_ratelimit_interval_ms ?

> +	local interval_ms=0
> +	local sleep_secs
> +
> +	if [ -r "$interval_file" ]; then
> +		read -r interval_ms < "$interval_file"
> +	fi
> +	case "$interval_ms" in
> +	''|*[!0-9]*)
> +		interval_ms=0
> +		;;
> +	esac
> +
> +	sleep_secs=$(((interval_ms + 999) / 1000 + 1))
> +	# Repeated expected remount failures can consume ext4's message
> +	# ratelimit budget.  Wait one interval plus one second before
> +	# unmount so "i_reserved_data_blocks .* not cleared!" is not
> +	# filtered out by the ratelimit.
> +	echo "sleeping ${sleep_secs}s for ext4 msg ratelimit interval" \
> +		"(${interval_ms}ms)" >> "$seqres.full"
> +	sleep "$sleep_secs"
> +}
> +
> +echo "Silence is golden"
> +
> +_scratch_mkfs >> "$seqres.full" 2>&1
> +_scratch_mount -o delalloc

If this test needs specific mount options, I recommend either unsetting
MOUNT_OPTIONS or setting it to the options you need, then removing above
`_exclude_scratch_mount_option ...`.

> +
> +options_file=/proc/fs/ext4/$(_short_dev "$SCRATCH_DEV")/options

_require_fs_sysfs options ?

> +grep -qw delalloc "$options_file" ||
> +	_fail "scratch filesystem is not mounted with delalloc"
> +
> +for ((i = 0; i < 16; i++)); do
> +	write_truncate_loop "$SCRATCH_MNT/file-$i" &
> +	writer_pids+=("$!")
> +done
> +
> +remount_loop &
> +remounter_pid=$!
> +
> +runtime=$((30 * TIME_FACTOR))
> +sleep "$runtime"
> +
> +stop_workload
> +log_worker_errors
> +log_remount_result
> +
> +sleep_msg_ratelimit_interval
> +_scratch_unmount || _fail "scratch filesystem unmount failed"

In general, we don't need to call _scratch_unmount explicitly unless it's part
of the test steps. Could an unmount failure be one of the issues caused by
this bug?

> +
> +warning="i_reserved_data_blocks .* not cleared!"
> +if _check_dmesg_for "$warning"; then
> +	_dmesg_since_test_start | grep -E "$warning" >> "$seqres.full"
> +	_fail "delayed allocation reservations leaked during rejected remount"
> +fi

fstests/check calls _check_dmesg at the end of each test case. What is the full
dmesg line you want to check? Is it already covered by the default check
patterns below:

        grep -E -q -e "kernel BUG at" \
             -e "WARNING:" \
             -e "\bBUG:" \
             -e "Oops:" \
             -e "possible recursive locking detected" \
             -e "(INFO|ERR): suspicious RCU usage" \
             -e "INFO: possible circular locking dependency detected" \
             -e "general protection fault:" \
             -e "BUG .* remaining" \
             -e "oom-kill" \
             -e "UBSAN:" \
             $seqres.dmesg

> +test ! -e "$remounter_error" ||
> +	_fail "delalloc to nodelalloc remount unexpectedly succeeded"
> +test ! -e "$worker_error" || _fail "write/truncate worker failed"
> +
> +# success, all done
> +status=0
> +exit

_exit 0

Thanks,
Zorro

> diff --git a/tests/ext4/064.out b/tests/ext4/064.out
> new file mode 100644
> index 00000000..d9076546
> --- /dev/null
> +++ b/tests/ext4/064.out
> @@ -0,0 +1,2 @@
> +QA output created by 064
> +Silence is golden
> 
> base-commit: acb6d4cb84205a8e3f19ca470cfcf7bf6d93a509
> -- 
> 2.20.1
> 
