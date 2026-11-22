Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795338594;
	b=hn/bceE7s2h2EZXY+XULtmUivO54SKvUFhe/WElA6GD9WkMNHw7GDC/fC0wsWVxpZopq
	 /3naT64X6Wwu1Ud06w9cvkLTw6T3f1afCTKWxJ1mKT7my843uaGbYOSjP0GqfJJ9zzRL2
	 5Lwr3bDXZP8+qEyA9HUTmiTL8QXWqUK+RMsi0VF73rAPW1asB+1fIxx9gFuqfxDeb/eHj
	 B93qfFOaolGicxrdf/Jz0wGja9ovKUp0lAZtwjViCltUZUOjmKT9o4V/vGgHEFFDdI9BV
	 9eZrOK+6GDTilSKV4KoiIpYEWcM1V/GpvdJYIPFnVKO1zH2AZWir5wQmnacPCI6KS/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795338594;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UHzISjqdWCjaOX/7plVNfZlEnab3SebVQWpKS9H0FdI=;
	b=4MmKY/cxwSFn29q8wN2ndWtOHmYv1oDwd0M7anlRJIdx+32IXLctW9SRS4HFE73FKeSg
	 uNbZCXUR30nWG97oy5hMWzXrfEGBT8myCfE00ImyvG4eD3xtmfLmqnxCobZ4t/2cKaaWH
	 ScQhwBCzh4OT8GQSI7D6rbm1xjEy2br5iniLsXpQsp6NRSU+0VSLaMz1lIypYjBCemnXg
	 LkTASpehYyzKODYSdWNEU+J9yLPVIvcZUQ7kdOReNSxglRabW2MqY3zkEoN08/MRm5nhm
	 fbyn0bN41KMRrSMwhqaRa0r/fl6bKqrlE2cAumG0rZp1Zv5QL/Wf0Zs279BeoyQUSmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=imhZ17hU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32AA606A320
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 09:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=imhZ17hU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CD61F000C0;
	Sun, 22 Nov 2026 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795338593;
	bh=UHzISjqdWCjaOX/7plVNfZlEnab3SebVQWpKS9H0FdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=imhZ17hUcHAgVq0p7Ytjw7tXml9DMdM7hF67Uk/sPxlGPqZI/BV/+8hynu1W75laY
	 cl4EijB1nMVqDMb7vEa64xxrPtiNNENaOO1352Gbyh+iuveYw24VkVRZuuRd5XduBV
	 DXDA0aKgb5QlSXy/iw7gwj5C7HuXeuXYUWnB+S8AlSZgfKcgIDRrGRbwIpDDoXosz3
	 jIDIp1kHDhLZuERzcjQwa0FF2WxqfIFuLPL8OK6jqGWYL8o41RzpEqUAedg8h0V48R
	 Sc2dCHgYvgSEwueMqvSIUNOqqSWE9oqNQKKbf8XC2G8KqFnON/IwOzkwlr75mT4ioX
	 zGvPgf8pxcOLQ==
Message-ID: <sashiko-outbox-227843@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261122084939.129223-1-arzuagapozosergio@gmail.com>
References: <20261122075355.81772-1-arzuagapozosergio@gmail.com>
 <20261122084939.129223-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 09:09:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] ext4: missing xattr block lookup in ext4_xattr_set_handle()
  credit check
- [Low] ext4: patch changelog and test checklist included in commit
  message
- [Low] selftests: ext4: tautological value check in main() after E2BIG
  setxattr()
- [Low] selftests: ext4: missing .gitignore and non-standard reporting
  in main()
--

commit d21a4fa912d1237c90e910dcdee358a0869f3cfa
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

ext4: bound xattr journal credits to transaction limit

This commit refines ext4 xattr journal credit estimation by charging for
old ea_inode reference drops only when an existing ea_inode attribute is
replaced, bounds the requested credits against the maximum JBD2
transaction buffer limit, and adds an ext4 kselftest.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

>     Changes in v2:
>     - Include the default revoke descriptor blocks in the JBD2 credit lim=
it.
>     - Do not charge the current transaction for deferred ea_inode truncat=
ion.
>     - Correct selftest registration and use kselftest result reporting.
>     - Use user.* attributes and skip when required mount support is
>       unavailable.
>     - Reuse the validated xattr block buffer during the locked credit che=
ck.
>    =20
>     Tests:
>     - make defconfig
>     - make -j2 fs/ext4/xattr.o fs/jbd2/transaction.o
>     - make -C tools/testing/selftests/filesystems/ext4 clean all
>     - sh -n tools/testing/selftests/filesystems/ext4/
>       ext4_xattr_journal_credits.sh
>     - scripts/checkpatch.pl --strict --no-tree: 0 errors; two environment=
 or
>       tree warnings for the Fixes commit lookup and new selftest MAINTAIN=
ERS
>       coverage.
>     - Built and booted the patched x86_64 kernel in a QEMU/KVM guest.
>     - The EXT4 selftest passed all 8 cases as guest root on a 1 KiB-block
>       ea_inode filesystem with a 1 MiB journal. e2fsck -fn passed after
>       the guest unmounted it.
>     - The host kselftest runner correctly reported KSFT_SKIP because it c=
annot
>       mount the disposable filesystem without root privileges.

[Severity: Low]
This isn't a bug, but the patch revision changelog ("Changes in v2:") and
the build/checkpatch checklist ("Tests:") belong below the "---" tearline
so they are not recorded in the permanent git commit log.

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b9650..0249dc1375386 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
[ ... ]
> @@ -2415,6 +2383,30 @@ ext4_xattr_set_handle(handle_t *handle, struct ino=
de *inode, int name_index,
>  		error =3D ext4_xattr_block_find(inode, &i, &bs);
>  	if (error)
>  		goto cleanup;
> +
> +	/* Check journal credits under write lock using the old ea_inode state.=
 */
> +	if (ext4_handle_valid(handle)) {
> +		struct ext4_xattr_entry *entry =3D NULL;
> +		bool old_ea_inode =3D false;
> +		int credits;
> +
> +		if (!is.s.not_found)
> +			entry =3D is.s.here;
> +		else if (!bs.s.not_found)
> +			entry =3D bs.s.here;
> +		if (entry && entry->e_value_inum &&
> +		    !(flags & XATTR_CREATE))
> +			old_ea_inode =3D true;
> +		credits =3D __ext4_xattr_set_credits(inode->i_sb, inode, bs.bh,
> +						   value_len,
> +						   flags & XATTR_CREATE,
> +						   old_ea_inode);
> +		if (jbd2_handle_buffer_credits(handle) < credits) {
> +			error =3D -ENOSPC;
> +			goto cleanup;
> +		}
> +		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
> +	}

[Severity: Medium]
Does this underestimate the required credits in ext4_xattr_set_handle()
when the target attribute is found in the inode body?

When !is.s.not_found, ext4_xattr_block_find() is not called, so bs.bh is
NULL even if EXT4_I(inode)->i_file_acl is present (unlike
ext4_xattr_set_credits(), which falls back to ext4_xattr_get_block() when
!bs.bh).  Passing bs.bh =3D=3D NULL to __ext4_xattr_set_credits() omits the
per-ea_inode credits for cloning a shared external xattr block.

If an external xattr block containing ea_inode references was attached
after ext4_xattr_set_credits() dropped xattr_sem, and the new value no
longer fits in the inode body, ext4_xattr_ibody_set() returns -ENOSPC and
falls back to ext4_xattr_block_find() and ext4_xattr_block_set().  Cloning
that shared external xattr block in ext4_xattr_inode_inc_ref_all() can
then run out of handle buffer credits and trigger the WARN_ON_ONCE() in
jbd2_journal_dirty_metadata().

> diff --git a/tools/testing/selftests/filesystems/ext4/Makefile b/tools/te=
sting/selftests/filesystems/ext4/Makefile
> new file mode 100644
> index 0000000000000..90569a1ccef38
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +TEST_GEN_PROGS_EXTENDED :=3D ext4_xattr_journal_credits
> +TEST_PROGS :=3D ext4_xattr_journal_credits.sh
> +
> +include ../../lib.mk
> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cre=
dits.c
> new file mode 100644
> index 0000000000000..92a6a8f7937bc
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.c
[ ... ]
> +	fd =3D open(path, O_CREAT | O_EXCL | O_RDWR, 0600);
> +	if (fd < 0) {
> +		failed_test =3D "create test file";
> +		saved_errno =3D errno;
> +		goto out;
> +	}

[Severity: Low]
This isn't a bug, but tools/testing/selftests/filesystems/ext4/ is missing
a .gitignore entry for the generated ext4_xattr_journal_credits binary.
Also, in main(), both setup failures (open(), close(), malloc()) and test
failures jump to out: and abort via ksft_exit_fail_msg() rather than using
kselftest_harness.h (FIXTURE / TEST_F) or distinguishing setup errors with
ksft_test_result_error() from test failures with ksft_test_result_fail().

[ ... ]

> +	memset(value, 0xa5, LARGE_VALUE_SIZE);
> +	value[0] =3D 2;
> +	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, XATTR_REPLACE) =
< 0) {
> +		failed_test =3D "replace large ea_inode xattr";
> +		saved_errno =3D errno;
> +		goto out;
> +	}
> +	ksft_test_result_pass("large xattr replacement\n");
> +
> +	if (getxattr(path, large_name, readback, LARGE_VALUE_SIZE) !=3D
> +	    LARGE_VALUE_SIZE || memcmp(value, readback, LARGE_VALUE_SIZE)) {
> +		failed_test =3D "verify replaced xattr";
> +		saved_errno =3D errno;
> +		goto out;
> +	}
> +	ksft_test_result_pass("replacement readback\n");
> +
> +	errno =3D 0;
> +	if (setxattr(path, large_name, value, LARGE_VALUE_SIZE, XATTR_CREATE) !=
=3D
> +	    -1 || errno !=3D EEXIST) {
> +		failed_test =3D "XATTR_CREATE on an existing name should return EEXIST=
";
> +		saved_errno =3D errno;
> +		goto out;
> +	}
> +	ksft_test_result_pass("XATTR_CREATE semantics\n");
> +
> +	errno =3D 0;
> +	if (setxattr(path, large_name, value, OVERSIZED_VALUE_SIZE,
> +		     XATTR_REPLACE) !=3D -1 || errno !=3D E2BIG) {
> +		failed_test =3D "oversized replacement should return E2BIG";
> +		saved_errno =3D errno;
> +		goto out;
> +	}
> +	if (getxattr(path, large_name, readback, LARGE_VALUE_SIZE) !=3D
> +	    LARGE_VALUE_SIZE || memcmp(value, readback, LARGE_VALUE_SIZE)) {
> +		failed_test =3D "oversized replacement changed the old value";
> +		saved_errno =3D errno;
> +		goto out;
> +	}
> +	ksft_test_result_pass("oversized replacement rejected without changing =
value\n");

[Severity: Low]
Does the oversized replacement check in main() actually test whether the
stored value was preserved?

value is not modified after the preceding XATTR_REPLACE write (and the
trailing bytes between LARGE_VALUE_SIZE and OVERSIZED_VALUE_SIZE are left
uninitialized from malloc()), so value[0..LARGE_VALUE_SIZE - 1] already
matches the attribute on disk and memcmp(value, readback,
LARGE_VALUE_SIZE) would pass even if setxattr() had overwritten the
attribute.

In addition, OVERSIZED_VALUE_SIZE is 65537 (XATTR_SIZE_MAX + 1), which VFS
setxattr_copy() rejects with -E2BIG before reaching ext4_xattr_set() or
ext4_xattr_set_credits().  Also, in the readback checks, if getxattr()
succeeds but memcmp() fails, errno is not set by memcmp(), so saved_errno
captures a stale errno from an earlier syscall.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122084939.1292=
23-1-arzuagapozosergio@gmail.com?part=3D1
