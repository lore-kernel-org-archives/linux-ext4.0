Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795583396;
	b=TzOyDBXDhywCZOIeEwFvfj8H8nkRYO9gJnTtr475XbNDavE2s1p4So02/aaklP5ZlwM5
	 Ck0Dj2QHw7xntZhCSQqd9UqoZMDtnP+job5Xe6mFqCumHDPe8ucvo77JYsRnjwUkvQeQU
	 UslY4MChXLqWHTIEnteA5TuKbX3Rnr28t0K20/KZn292EPMKOSPlzrinaqJqMx27D++TW
	 AnUb5gjxtTbl9V0X08yaCxbgoeQ3d/6mpzeHa3nuGLeZ4znpEJQTAYrUV1rX7t7C+nn2y
	 uuRu3AfLWTWTA3ptOtEwN9vwiB3C9qnAmjSXs+kUHZUk0NMOgBKKgkhPX3uWASZ3Utg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795583396;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PRaOkfhkQ1h8JOde7G3bNmM2SUFSYZK13lEBU6XiAxw=;
	b=gjAJaMymbD5ZQEfeIQT6zOGCkj1a6Ok40a4EWQSZa+zD5HVPjjOf1Dk5iftmkp/24LD/
	 Mb9Nz/gJKVFXkO83wNTj3P9bROczfkgMh0wIMaMV3iWwb7I5Bb/EKbbMoNoq94cuzBCLs
	 K7eAYKRfXj92xRJD5UgOl0yMkXojXS7p4Ks1HaEvT7H+BfxsPtyuQvFg6AAJW/kaLx3cz
	 Zn9B5KK/ZsuAMCIIQOnypPtHT9yq744P0mvX5/lnRAIfJW+41PNIAYWhMb9aOEe+k1h5F
	 GukCu1Ar2xeVQanuZqcD4tL9/BvrHKfb3GQxuY+65VwWylKmBpYrJuK/RUV/PQZP/KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFHa1bBe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FB1606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 05:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFHa1bBe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EB51F000C6;
	Wed, 25 Nov 2026 05:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795583395;
	bh=PRaOkfhkQ1h8JOde7G3bNmM2SUFSYZK13lEBU6XiAxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cFHa1bBe1VhFcQbI49qs7LFNC4NM4TlxZUxvHqnrRb/15M8+SW6TTxn+sM6MRvLjL
	 gXWBRMyiHN2P4FXX76braE1hU3GdTqBlm09E0YHu5Ai6A2r7E3Yj68IWmb/Jz7xVbi
	 EpHl/oFZvwcNoKwky9pGzDHjnJsouTxmOd3T/N0hC+HKxrqq+vdzyG3tkNvKwgPbu0
	 424gxCX5bc26WyaquDhRqoJud/m4Kig8rsusKHN7a7XhkfnjO8g7lefP0cuhmHspjs
	 JSD79Q2EkXikcz4YqOsCzQ1sMQ6gg4CZ7mf5kF1Zu7+kY2LgGXYi6eUDtDAoqZQe4W
	 +G88OqpZLmbDg==
Message-ID: <sashiko-outbox-232602@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125045143.53035-1-arzuagapozosergio@gmail.com>
References: <20261122093732.136895-1-arzuagapozosergio@gmail.com>
 <20261125045143.53035-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 05:09:55 +0000
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
- [High] ext4: double dec_ref of ea_inode in ext4_xattr_block_set()
- [Low] selftests/ext4: flat main() and magic number in
  ext4_xattr_journal_credits
--

commit 4a8d7681896524501769fc05104b7297b7732a84
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

ext4: bound xattr journal credits to transaction limit

This commit removes the journal credit reservation for freeing an old
ea_inode, bounds the xattr credit estimate against the maximum JBD2
transaction buffers, drops the provisional ea_inode reference when reusing
a cached xattr block, and adds an ext4 kselftest.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b9650..b8e1d50179240 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c

[ ... ]

> @@ -2109,6 +2090,17 @@ ext4_xattr_block_set(handle_t *handle, struct inod=
e *inode,
>  								   new_bh);
>  				if (error)
>  					goto cleanup_dquot;
> +				if (ea_inode) {
> +					/* The reused block already holds this reference. */
> +					error =3D ext4_xattr_inode_dec_ref(handle,
> +									 ea_inode);
> +					if (error)
> +						ext4_warning_inode(ea_inode,
> +								   "dec ref error=3D%d",
> +								   error);
> +					ext4_put_ea_inode(ea_inode);
> +					ea_inode =3D NULL;
> +				}
>  			}
>  			mb_cache_entry_touch(ea_block_cache, ce);
>  			mb_cache_entry_put(ea_block_cache, ce);

[Severity: High]
Does this decrement ea_inode's reference count twice when an unshared
bs->bh (h_refcount =3D=3D 1) is modified in-place and then matches an exist=
ing
block in ea_block_cache (new_bh !=3D bs->bh)?

In the in-place modification path, ext4_xattr_set_entry() writes
ea_inode->i_ino into bs->bh->b_data before jumping to inserted: with
ea_inode still non-NULL:

fs/ext4/xattr.c:ext4_xattr_block_set() {
    ...
		if (header(s->base)->h_refcount =3D=3D cpu_to_le32(1)) {
    ...
			ea_bdebug(bs->bh, "modifying in-place");
			error =3D ext4_xattr_set_entry(i, s, handle, inode,
					     ea_inode, true /* is_block */);
    ...
			goto inserted;
		}
    ...
	if (bs->bh && bs->bh !=3D new_bh) {
		ext4_xattr_release_block(handle, inode, bs->bh,
					 0 /* extra_credits */);
	}
}

When ext4_xattr_block_cache_find() returns a cached new_bh !=3D bs->bh, this
new block drops ea_inode's reference count once, and
ext4_xattr_release_block() -> ext4_xattr_inode_dec_ref_all() on the
in-place modified bs->bh drops it a second time. If new_bh held the only
other reference to ea_inode, its reference count drops to 0 and ea_inode is
freed on disk while new_bh still references it.

Guarding the decrement here with !(bs->bh && s->base =3D=3D bs->bh->b_data)=
, or
releasing and clearing ea_inode right after the in-place
ext4_xattr_set_entry() succeeds, would avoid the double decrement.

[ ... ]

> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cre=
dits.c
> new file mode 100644
> index 0000000000000..3b4bb726db03e
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.c
> @@ -0,0 +1,241 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/xattr.h>
> +#include <unistd.h>
> +
> +#include "../../kselftest.h"
> +
> +#define LARGE_VALUE_SIZE 65296
> +#define FILLER_VALUE_SIZE 4
> +#define TEST_COUNT 10

[ ... ]

> +int main(int argc, char **argv)
> +{
> +	char path[4096], shared_a[4096], shared_b[4096];
> +	char *value =3D NULL, *expected =3D NULL, *readback =3D NULL;
> +	char target_new[64];
> +	static const char small_value[] =3D "small-xattr";
> +	char small_value_readback[sizeof(small_value)];
> +	char target_old =3D 0x11;
> +	int fd, path_len, shared_len;
> +	bool created =3D false, replaced =3D false, shared_ready =3D false;
> +	bool shared_replaced =3D false;
> +	int ret;

[Severity: Low]
This isn't a bug, but could this test use kselftest_harness.h
(FIXTURE()/TEST_F() with ASSERT_*/EXPECT_*) instead of a flat main() with
cascading state booleans and manual skip counts? Also, is there a specific
reason for choosing 65296 for LARGE_VALUE_SIZE that could be documented in
a comment?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125045143.5303=
5-1-arzuagapozosergio@gmail.com?part=3D1
