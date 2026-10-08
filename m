Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E125547075
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 07:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445624; cv=none; b=X8VpUOGJBvBg20QaXKUQFs0Mz4dMDPWRkrldUjYdnosSRX1s8qEVUKbh82Nvqo77OwKVzFs3qWVy91TgdboBQkIm2ZPy8vgGd2iaLEtH/sJtTEMUyAQ07zTQAEhhMua6PQa5wlaIhRSCueX0DTqHXdv+45uY02yBcQEnXp2lOUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445624; c=relaxed/simple;
	bh=8Qq9Lw8WUa+kjTyRj2GbXRds+UuXiwQfglJjBDI6Yxw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IcX32C8ZX0kqxqvlpJPpI6SQWS9V+JfuxS+JcdfSUeDir0E6QKuziG16OEBWRgKqbshVgrR4dYAlVNnz8oIB1djf9cpHTmzhsIPDoaLp3irpMsBhyAgWbVNm+nq3E3+cPfNCM+3/VVelcYOzV51OtXlYy7s5VJ6WefMQ/txxMKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0s2/UKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0s2/UKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C244B1F000FF;
	Thu,  8 Oct 2026 07:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791445623;
	bh=8Qq9Lw8WUa+kjTyRj2GbXRds+UuXiwQfglJjBDI6Yxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a0s2/UKcUSgK2xy5vAKbkqNb0F2zHNuzY0SBuGGwtauFMV8EzNCIWxr1CfGHc/N4E
	 6sMEvGOvmeOFgLwOCQ092qtiMAfFiPr2obl1b6jPVsTSx4zMwhFhaM/aJ0XvbG5nfl
	 cXePVRHhCrU8Hq/zz24QvPXf5lsxoHFsx9Cc1LyfxaDLZyxWCG3gyrcanSLueWP86t
	 gMC93FqksQxmqwqSDzXBKKveCX32HAN2ePcwuZwzMldVEM+quylwJZtcQS66F3CIUe
	 p3b9+4JlRqrba6LIEPPCwL8sRlpNtWy/rI3lTaO/++GwZomXyzWbFO5cXdefKhr1QB
	 /Q5skYpVU64xA==
Message-ID: <sashiko-outbox-163781@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: test reads after a failed zeroout of an unwritten
 extent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261008-ext4-zeroout-eio-test-v1-1-9bb66deaf646@samsung.com>
References: <20261008-ext4-zeroout-eio-test-v1-1-9bb66deaf646@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 07:47:02 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] fs/ext4: Script submitted to wrong repository (fstests vs kernel)
- [Medium] ext4/xfstests: Typo in _require_scratch_ext4_feature_enabled fun=
ction call
--

commit 15df6b5040afb28bc9e8fcc362919219d21014ba
Author: Daejun Park <daejun7.park@samsung.com>

ext4: test reads after a failed zeroout of an unwritten extent

This commit adds a new test script to verify that reading blocks from an
unwritten extent returns zeroes after a failed zeroout operation. It uses
dm-error to simulate the failure and ensures ext4 doesn't cache the unzeroed
blocks.

Link: https://lore.kernel.org/r/20261008-ext4-fc-zeroout-v2-1-55cab1e24fa3@=
samsung.com

> diff --git a/tests/ext4/309 b/tests/ext4/309
> new file mode 100755
> index 0000000000000..1fafd58263577
> --- /dev/null
> +++ b/tests/ext4/309
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Samsung Electronics Co., Ltd. All Rights Reserved.
> +#
> +# FS QA Test No. 309
[ ... ]
> +. ./common/preamble
> +_begin_fstest auto quick rw prealloc eio

[Severity: Medium]
Does this script belong in the fstests repository instead of the Linux kern=
el
tree?=20

The use of the common preamble and _begin_fstest demonstrates a dependency
on the xfstests framework. Applying this patch to the kernel tree will
result in a non-functional script with unresolved dependencies.

[ ... ]
> +_require_scratch
> +_require_dm_target error
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fiemap"
> +_require_scratch_ext4_feature_enabled "extent"

[Severity: Medium]
Is there a typo in this function call?

The function _require_scratch_ext4_feature_enabled does not appear to exist
and should likely be _require_scratch_ext4_feature. This requirement check
will fail silently (printing an error but continuing execution), potentially
causing the test to run on unsupported configurations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-ext4-zeroo=
ut-eio-test-v1-1-9bb66deaf646@samsung.com?part=3D1
