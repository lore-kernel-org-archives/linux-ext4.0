Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138848;
	b=VwjTv3+yBVhaz4fFLb2vAmBsnuUSPiTrATwk2knCAQqkXtrP8gdbxptu6euXVxg0VVuF
	 2o8pvhYlZ6h6tGP+GHIhysgJz21//1lRYvp+lkXARvmKGPCch34+Ocx0zXxhge8csotE6
	 CwmtA/84o7ecOE9vCJhEPu86bNKODZp+I36h1PIE/ozkwYfLulrq2QX27zswLaM1nJthO
	 Impw4621PiyQj8OkKP+CpON5msMqpKlaqq9QuvO8vtsnrnT+HGB0ih8O9al9T6ocsADz7
	 VYWl1lC7D7DDxsGNQjMdeRiW1lJSJo3r44dWY80C+UiPNajplxCYma3q+swFW/EKlvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138848;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EUwFUSJuhRc04ksOMCV2ok59zBEADdLysSL4MRhGdMs=;
	b=Lk6p7OzVoxnF4GokTDNVf57FmiYB03b/oizl/ku4xXOU2Ah/nOer1cEBaY8/+AXNVJbc
	 2KYYyFgD2KxClHfYSVvToZnrdy3VljNVBrXlYPWugRM5AQ4peh1UO3l7ar9QPXodAKP0K
	 BprriWkBBxr1GK4ApBj2l4Lyj8DvUTR4B4EMlxUxIW8wmvoWTLJTqEotvjX+4aMWsmREV
	 QNUccVQTEK97HZGQ9he95P+hIZ0GpVn1TduHjPuLK1kSUiF2EG16BFMTHMYszNQNVl/Xe
	 099ILyKmY1Taq+D9kcexhuIplmz4BgNPncA0ltJCzu7WOYlxhKU9NHs+H7ZxWt5CMWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Yr9qF1/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A97606A31D
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 22:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yr9qF1/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744E51F01825;
	Tue, 27 Oct 2026 22:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793138847;
	bh=EUwFUSJuhRc04ksOMCV2ok59zBEADdLysSL4MRhGdMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yr9qF1/ATI9dE6ZBming/HSpze5fmisiYEShkbuvO2TIbZmc6T1aAxEQ+EY0wbwx7
	 EsQ8Q+OIiwzdICeRgvbHLXI77p4wujCLiym1oV6O8tRzkNpKRWq0UblUZ3oOrscOR4
	 8T1mD6LvE3rXdAHqwzmAAqYs+YQzyT5z3eXL1op2Fn4dSL8fZoEM8pIm5znZai3sZ7
	 tBapBdAyaaqO4R2bg073Ynq/sZSvVYr/0p3B0WFLxvsWgcSEB4K3jwJ5Itbp3N0i6T
	 FzIDDI//6m/OKrtpERZhL3BJIF+XKN7eIpwIOgORH0qvPAprGwgJSpWYaEVST417gh
	 8GQbYTyYJ9CtQ==
Message-ID: <sashiko-outbox-187143@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] Documentation: iomap: update docs to reflect
 iomap_iter_next model
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027215326.2693300-6-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
 <20261027215326.2693300-6-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 22:07:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] Documentation: iomap: wrong callback typedef names in design.rst
- [Low] Documentation: iomap: stale iomap_ops references and wrong typedef =
names
--

commit fea07d10310ef7888be3709ed8abf2f597ada915
Author: Joanne Koong <joannelkoong@gmail.com>

Documentation: iomap: update docs to reflect iomap_iter_next model

This commit updates the iomap documentation in design.rst, operations.rst,
and porting.rst to replace references to struct iomap_ops and its
iomap_begin and iomap_end callbacks with the new iomap_iter_next_fn
callback model.

[Severity: Low]
In Documentation/filesystems/iomap/design.rst at lines 379-385 (under the
iomap_iter_next section), the newly added code block documents the callback
typedef prototypes passed to iomap_iter_next() as iomap_begin_fn and
iomap_end_fn.

However, in include/linux/iomap.h at lines 221-232 and 352, the actual
typedefs defined and accepted by iomap_iter_next() are named
iomap_iter_begin_fn and iomap_iter_end_fn.

Should design.rst use iomap_iter_begin_fn and iomap_iter_end_fn here to
match include/linux/iomap.h?

[Severity: Low]
A few places in the updated documentation still refer to iomap ops structs
even though struct iomap_ops (along with per-operation structures such as
xfs_*_iomap_ops in fs/xfs/xfs_iomap.c) was removed in favor of passing
iomap_iter_next_fn callbacks directly:

1. In Documentation/filesystems/iomap/design.rst at line 462 (under the end
section), the text still states that "iomap ops for reads are not likely to
need to supply this function."

2. In Documentation/filesystems/iomap/porting.rst at lines 91-100 (under
 the "How Do I Convert a Filesystem?" section), the guide still advises
breaking the begin function up into "per-operation iomap ops" (citing XFS
as an example) and creating "separate mapping functions and iomap ops for
write operations."

3. In Documentation/filesystems/iomap/operations.rst at lines 714-715
(under the fsdax Deduplication section), dax_remap_file_range_prep() is
still documented as being called "with their own iomap read ops", whereas
dax_remap_file_range_prep() in include/linux/dax.h at line 277 now takes an
iomap_iter_next_fn callback (and "iomap read ops" can be confused with
struct iomap_read_ops).

Should these remaining references to iomap ops be updated to refer to
per-operation iomap_iter_next_fn callbacks and mapping functions instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027215326.2693=
300-1-joannelkoong@gmail.com?part=3D5
