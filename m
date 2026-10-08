Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A8A30F927
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 10:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455376; cv=none; b=j1MqeurNBPxu2lrNNCnMecsBGTOKxID3rrUjTIUOGA13CbLI3+t1YPWb55F8WHsSFgvbbDCCjRWI18DmZeXNEkxnvKz0WnMtGg+RsuLaXWPNfZY4+qcJ9Ir6rNglhYya7ycw7bLhUQl2QmPA6kLainnL9vzq9r0vYHDBf35hB+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455376; c=relaxed/simple;
	bh=+G+dv9PTr07JINdhwXmHjVUA+8Ge6kBvW3u9xYjY0UI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ihO73hqiIXx1TpdL4OMQa7XeTXaXafIjzpfyB/6qy7q4ZjHoF2k/YGA723tJR+xghpGeJOSm5Sbh6AmzDjsQeUz+99rY5WmN6CeCOSx6yCMDxzsL//6ewH/3/nbgOG+tJ5uJG9RE7425qz69qXsdgJHZXb3Rjbv4hyiNsubixiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hd94XVNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hd94XVNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32321F000FF;
	Thu,  8 Oct 2026 10:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791455374;
	bh=xbc4H0jYSexfdoLasFL4I/fHlkIhlisdjhCQ2wTu7uw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hd94XVNhhn79LgT8QlK+m9f9q1b6REOvZdc6oDjZb9h+5B67GRggawQBoYG+qkxZm
	 nOW8UFZV4YHr/3kAqqxSozgQoGckLOvOvzEiFX1M7YAESgWiGQBD7A6XD28GLLO7/C
	 COTDowiSOZQ+8EDpJzkCT/F3PGGPomUe3/e5sYYuEO+b1Ww7/xLyi/JEU/lZbm550E
	 UiOIyNGD2Fu+1Zs31AtfH6kFBzeFgUOiNm3WqwM3kREDV+lmbRVsAq3Y0em9c8NH2M
	 zbb7I1e3cALyunvQwcRXh6A/fCxbHVY20Kb6ra7TJo2IPTBl0glorwUwhqXdYKL/Pz
	 O0hTLJro9tgPA==
Message-ID: <sashiko-outbox-164015@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] generic: test that preallocated blocks still read
 zeroes after I/O errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261008-ext4-zeroout-eio-test-v2-1-883ac28de4cf@samsung.com>
References: <20261008-ext4-zeroout-eio-test-v2-1-883ac28de4cf@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 10:29:34 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] tests/generic: missing _set_fs_sysfs_attr definition
- [Low] bash: unquoted $FSTYP in test expression risks syntax error
--

commit 1313e327b3473925cf67777d9fc9f5d95ae058fc
Author: Daejun Park <daejun7.park@samsung.com>

generic: test that preallocated blocks still read zeroes after I/O errors

This commit adds a new fstest to verify that when I/O to a portion of a
preallocated extent fails, the remainder of the extent still reads back
as zeroes. It reproduces an ext4 issue where failed zeroouts left blocks
cached as written, returning stale disk contents.

Link: https://lore.kernel.org/r/20261008-ext4-fc-zeroout-v2-1-55cab1e24fa3@=
samsung.com

> diff --git a/tests/generic/806 b/tests/generic/806
> new file mode 100755
> index 0000000000000..8991b6e59254a
> --- /dev/null
> +++ b/tests/generic/806

[ ... ]

> +_require_scratch
> +_require_dm_target error
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fiemap"
> +test $FSTYP =3D ext4 && _require_scratch_ext4_feature_enabled "extent"

[Severity: Low]
Is it possible for the $FSTYP variable to be empty or unset when this
expression in tests/generic/806 is evaluated? If so, this unquoted test
risks an invalid syntax error. Would it be safer to wrap the variable in
double quotes?

[ ... ]

> +do_mount
> +
> +# ext4 zeroes out the rest of the extent if the whole extent fits in
> +# extent_max_zeroout_kb, which mount resets.
> +test $FSTYP =3D ext4 && _set_fs_sysfs_attr $DMERROR_DEV \
> +	extent_max_zeroout_kb $((nblks * blksz / 1024))

[Severity: Medium]
Does this code call an undefined function? A codebase search indicates that
_set_fs_sysfs_attr is not defined anywhere in the test framework. When this
script executes during an ext4 run, will this cause a 'command not found'
error, leaving the extent_max_zeroout_kb attribute at its default value and
silently failing to configure the test environment?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-ext4-zeroo=
ut-eio-test-v2-1-883ac28de4cf@samsung.com?part=3D1
