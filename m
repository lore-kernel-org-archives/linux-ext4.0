Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC8933ADB3
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 06:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787035985; cv=none; b=Df59PMRor0j33gFAA0Oht+LdQ/6M899qjsWgOVbjmP9QmZAmqivFCN2FpiggoGn5u+6ehkEF6BZEpim9EYKnHPCoisay80Qe6psVX8kwGBO8CYCsd4WzAekU56DGonx+lpRV7XHy5p0HNenml3VkAVeEOIR2wApgd7Pd3mR+N0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787035985; c=relaxed/simple;
	bh=XC4sWqZ9ODhQMGgKsvzyPz8PSgz9oPSEO9HadLjlyBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KUvB5SOTaTcoNVGcop9weae/P2UqrvU+oemTWBzC0VkUtK9uBLZxWgBG/rA4IBubpN5WcGekVk3yx2Q2B8ZsY2jMaWecU6r4wa3MxIH4kJ3G3ryyfK3vyek4VhDiR21abwnxDjURDfNj+DaT8zYp0sqZMFuQ38mtu2bz+MjT/H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrR2p5Qg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrR2p5Qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348F91F000E9;
	Tue, 18 Aug 2026 06:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787035984;
	bh=q0geMLCTBM+B9l7igyCKj+w+iItTVRFp3SK9R7gjqtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jrR2p5QgHiPE5K2LdLWG7c4x9fDun6O8ZbmPrEy3OrkVnztRzWxEqXg/0oEN+CZ2Y
	 2p2x32R347YN8OORW2VCJkZ38jYOOagyP6W2WXpNDujLvOH/Fkrvmh+OQKMTFNXYBX
	 2HhVsZQ/IkmdVSv8gZdzbgIqhJIMGAGqAe/C1TEa53P4Puc+tXx8evXFZSe/j2bKZt
	 reuw9GWGLjJGaakhIQmWFNxlepQfwPDGoQPQpqcZ5faQqxHOMHEvcMnc6m48gvNTJX
	 NXvQujzzNLqz1rBEI28RPLqnN7b4bOz4tDZREEiUYY+MsHSewx4d+JVvTFYJNjZtpb
	 0GhMEa2LgovxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4/064: add regression test for delalloc remount leak
Reply-To: sashiko-reviews@lists.linux.dev
To: guzebing <guzebing1612@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260818064023.2309786-1-guzebing1612@gmail.com>
References: <20260818064023.2309786-1-guzebing1612@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 06:53:03 +0000
Message-Id: <20260818065304.348F91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] The test is misplaced in the Linux kernel repository instead of th=
e standalone fstests repository.
- [High] Incorrect sysfs and procfs device path resolution for Device-Mappe=
r/LVM setups.
- [High] Test calls an undefined function `_check_dmesg_for`, leading to si=
lent false negatives.
- [Medium] Unsafe wait in cleanup routine can cause the test harness to blo=
ck indefinitely.
- [Low] Overridden `_cleanup` function leaks fstests temporary framework fi=
les.
--

--- Patch [1]: [PATCH] ext4/064: add regression test for delalloc remount l=
eak ---
commit dd8f7afb5b15cd0c26af3c7b7793de74e5f8db76
Author: guzebing <guzebing1612@gmail.com>
ext4/064: add regression test for delalloc remount leak

This commit adds an ext4 regression test to exercise rejected delalloc to
nodelalloc remounts while buffered writes and truncates are active. The
workload checks for leaked delayed allocation reservations during unmount.

Link: https://lore.kernel.org/linux-ext4/20260814034855.1573759-1-guzebing1=
612@gmail.com/

> diff --git a/tests/ext4/064 b/tests/ext4/064
> new file mode 100755
> index 0000000000000..5d43764c77687
> --- /dev/null
> +++ b/tests/ext4/064
> @@ -0,0 +1,216 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 guzebing.  All Rights Reserved.

[ ... ]

> +. ./common/preamble
> +_begin_fstest auto stress mount

[Severity: High]
Is this test file intended for the standalone fstests repository rather than
the Linux kernel tree?

The test framework dependencies, such as common/preamble, are not present in
the kernel repository. Tests submitted directly to the kernel tree usually
use the kselftest framework under tools/testing/selftests/.

[ ... ]

> +stop_workload()
> +{
> +	touch "$stop_file"
> +	if [ -n "$remounter_pid" ]; then
> +		wait "$remounter_pid" 2>/dev/null
> +		remounter_pid=3D
> +	fi
> +	if [ "${#writer_pids[@]}" -gt 0 ]; then
> +		wait "${writer_pids[@]}" 2>/dev/null

[Severity: Medium]
Will using wait without a timeout block the test runner indefinitely if a
workload enters an unkillable state?

Would it be safer to send a terminate signal to the background processes
before waiting for their termination?

> +		writer_pids=3D()
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
> +	rm -f "$stop_file" "$worker_error" "$worker_error".* \
> +		"$tmp.xfs_io_error".* "$remounter_error" "$remounter_count"
> +}

[Severity: Low]
Could overriding the default cleanup function without including the standard
rm -r -f $tmp.* command leave fstests framework temporary files in the
system temporary directory?

[ ... ]

> +sleep_msg_ratelimit_interval()
> +{
> +	local dev=3D$(_short_dev "$SCRATCH_DEV")
> +	local interval_file=3D/sys/fs/ext4/$dev/msg_ratelimit_interval_ms

[Severity: High]
Does _short_dev reliably resolve the correct sysfs and procfs entries on
setups using Device-Mapper or LVM?

The kernel exports ext4 sysfs entries using the underlying block device name
like dm-0, instead of the logical volume name that _short_dev returns. This
will also affect the procfs options_file check later in the test.

Would an fstests helper like _sysfs_dev be more appropriate here?

[ ... ]

> +_scratch_unmount || _fail "scratch filesystem unmount failed"
> +
> +warning=3D"i_reserved_data_blocks .* not cleared!"
> +if _check_dmesg_for "$warning"; then

[Severity: High]
Does _check_dmesg_for exist in the standard fstests framework?

If the shell evaluates an undefined function, it will return a command not
found error, causing this conditional check to silently evaluate to false
even when the delayed allocation reservation bug is triggered.

Should this use a standard check like:
if _dmesg_since_test_start | grep -qE "$warning"; then

> +	_dmesg_since_test_start | grep -E "$warning" >> "$seqres.full"
> +	_fail "delayed allocation reservations leaked during rejected remount"
> +fi

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818064023.2309=
786-1-guzebing1612@gmail.com?part=3D1
