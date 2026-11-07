Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794080509;
	b=2BX2D6ykjyvgc0eZYNVceXwG2jbYc9u2CloU+E6n/IwitErRVpZeXEWQq9lNc3EEJOLz
	 ndoiSFoAskKwf2gkYiR5Z892yX+5WrkZVGYzSVdvFUXY/MSFO1ZlrnwCz0kHFAk/d1C3I
	 SCWMYKcExSx3gdvH2LHUzkE8KIKQD4eaRoCSnasgTwzHdMV7TlwmZmfKttZIKOFa5EbxZ
	 lVQRIgrk49Jvbv/0FGDiSe3reics1qpv6Lq67MBQsHvWQ10ibw1ibFkZoOkKbxXIl72sG
	 6d+RdhwemOOj3KPka1BpMT7HYEsY9lNSkMlm57iPKTpx0pHwD413xEr0FJaretmxJcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794080509;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qnftm6u+eC3YobhsZ/4+9VFEGILn9zMUVuerFczfIfk=;
	b=j1clyXzG4EQ5gi5pYCcIPR+gSkcNiBwbHY6lIpdF/fQ8dhEPeljfx6KUuUAkmeDET3Cg
	 dAVYtaMnc2GrdeRn74531JyDdf6uGuRJDcTW+L97kAepz2YSx0w/vzvuB1qTbUSv/vrLi
	 vnKUnvJu3T9n4Cmu242ADQxlqHW5sgJVKhLMci2SIM+4siS1RUph48lQIgQQHFQIZ3/II
	 uQP758Yk5xbu8V85E7mglu/7r6EKEsyp4DM28h1FLrVmgGGaTQI+kNYZt2mDmZrB2lgdp
	 bJneShL7B0d8zkMc4QsAS/Tn3x/iUTZEDUayZN2M/LLmo+GYUc7vzC6ZXPrfsiR+gPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNgMMoxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42F0606A32E
	for <linux-ext4@vger.kernel.org>; Sat,  7 Nov 2026 19:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNgMMoxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8081F0089F;
	Sat,  7 Nov 2026 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080508;
	bh=qnftm6u+eC3YobhsZ/4+9VFEGILn9zMUVuerFczfIfk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LNgMMoxgYlOtWIKgR+ZQ6io7bCVRu598baokqcl4p6yRzA6pJaHs60UNsXn4QWBxF
	 0JBZsbBJqIeLw9uRynT6aPfZ/92B/LNq4EIDunGuRrHHo07ULkVQOIsPiLF9/2DGoH
	 tWHNmymH23s/9cMwbzyC7Y8RhSRv/C4taZxDHB7mcsJ0FMJx9sF8k+awHP/at3IbaF
	 VKiCxKf8gXnWMMCMKP64ISG0q8VAsa1VHhd3GgnJSnUgYi58boLWJui6g/Wos+xS/x
	 ooXa3d9CS5w5Q3GBks1hbrgLPwpCv2oVSlOeYZxehY7BOi1QdB68xjQ3uFPohxWGTl
	 hPtaOyllQqBfg==
Message-ID: <sashiko-outbox-203218@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: test reserved GID block allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahaj Chaudhari" <sahaj123.sc@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261107193050.330685-1-sahaj123.sc@gmail.com>
References: <20261012112109.3363168-1-sahaj123.sc@gmail.com>
 <20261107193050.330685-1-sahaj123.sc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 19:41:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] ext4/309: hardcoded ^has_journal and unchecked mkfs/tune2fs
  break test
- [Low] ext4/309: unverified su -g/-G support and unchecked space-fill
  step
--

commit 6c6eb6186b8e8ccb5609d413ece36c644ad760e0
Author: Sahaj Chaudhari <sahaj123.sc@gmail.com>

ext4: test reserved GID block allocation

This commit adds xfstests test ext4/309 to verify that a user whose primary
and supplementary group matches the superblock s_resgid can allocate blocks
from the reserved pool after ordinary free space is exhausted.

Link: https://lore.kernel.org/r/20261008065651.3517824-1-sahaj123.sc@gmail.=
com

> diff --git a/tests/ext4/309 b/tests/ext4/309
> new file mode 100755
> index 0000000000000..3bd120091202b
> --- /dev/null
> +++ b/tests/ext4/309
> @@ -0,0 +1,63 @@

[ ... ]

> +MKFS_OPTIONS=3D"-m 10 -N 1024 -O ^has_journal $MKFS_OPTIONS" \
> +	_scratch_mkfs_sized $((16 * 1024 * 1024)) 4096 >>"$seqres".full 2>&1
> +"$TUNE2FS_PROG" -u 0 -g "$RESGID" "$SCRATCH_DEV" >>"$seqres".full 2>&1
> +_scratch_mount

[Severity: Medium]
Can formatting with -O ^has_journal here cause _scratch_mount to fail when
journal mount options are configured?

In __ext4_fill_super(), ext4 rejects mounting a journal-less filesystem
whenever any journal mount option (such as data=3Dordered, data=3Djournal,
data=3Dwriteback, or commit=3D) is passed, which is not filtered out by
_exclude_scratch_mount_option.

Also, appending caller mkfs options after -m 10 -N 1024 -O ^has_journal lets
a preset such as -m 0 override the 10% reserved pool and cause the final
fallocate to fail.  Neither _scratch_mkfs_sized nor tune2fs checks its exit
status with _fail, so if mkfs fails on conflicting options (for example
-J size=3D... with -O ^has_journal), the test mounts the stale filesystem l=
eft
on the scratch device and fails when 16M does not fill it.

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

[Severity: Low]
What happens if su does not support -g and -G, or if $qa_user cannot
traverse the scratch mount point?

The -g and -G flags are specific to util-linux su and are not checked before
use.  Because the pwrite step does not verify that any data was written and
the first falloc check treats any non-zero exit status from su as space
exhaustion, an early su or permission failure falls through to the final
step and fails with "reserved GID failed to allocate a block".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107193050.3306=
85-1-sahaj123.sc@gmail.com?part=3D1
