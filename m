Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585156;
	b=YLhNSRCtbsfUqdygeEABfFpggnfrmGMb3tZ/kueqdqiBIem21GClYxfip0rEwMDgZpNA
	 1Q4RSQlBR3EeJolWQ3OtMcloeyr7YVcgMVxLN1apsjsAmUc3ZXnbiFq812aaQjSUxloi8
	 nruTTrNL4OUlvqyGny9HchtFuhW+H2hVeOZyXNnOP5jqmbXVl2liGsyz078siZWlm9Sw3
	 f2d6Ymk/JauPJrgjCimMCAzLuF4EN07U/d1pJeLZmkjv/IYArAbjJiVtnBfCbcuXKP6xx
	 uBrOo9Gp/nt07xn+HUgoZEMV8tR/2cMclkWcomJY04bg6jc4JSxgr5/0RaPp0FoSYDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lvJEIAzxhx4aClIkQStB5aXHjKuf32oyj5/ld6IIsOQ=;
	b=nUTZDe+Rsn3E6yHQQ7q7Kvtz0Be83SmXRWdltjI0DZVzA6CEyySfeHI8WVqNxUSUjE5N
	 mZDnUC4AiW8KN1uu+aM5RF4P0X9QStbhuxH9Fc8ugFRFcVN5HnLrnOIpYgy4gzNG/oPF4
	 IWeqUryvXpCMMlClRs4ypX7EKFqtvCWOoh0TBcDqJydLG8AUcisUmFU7J3qgrTujgSZsT
	 d6fvzHVar/kLzQDjoJWKzC1ZbCkJfgbq1TMVVTn/S2/8hcjVMixruCTQmU0qX2ofZnFWH
	 A+x21CIqC/uicUINarSkIMns466/sx8JXi/1GrjhwhRh1aWQU4v58MSH7yOXbWWyk7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWn6tswR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2D1606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 05:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWn6tswR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05731F000CA;
	Wed, 25 Nov 2026 05:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795585156;
	bh=lvJEIAzxhx4aClIkQStB5aXHjKuf32oyj5/ld6IIsOQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LWn6tswRuMyYUjSIV3ili3O2jSji8EgKlzI+KlWciIHqXAvL6gl9hMiznwpOJSaWU
	 k7OTiDkImiffUcQPMuqsoiNyEqPDCJUHmRBcqfQQxdUrHpR8zwJMzjPapLXHNN5fOr
	 Lsrp8DLV/E2x2ZSWQIcv8l2a9Nxga3eVU02GRyxL5jKpdRAQDgTGnk3m0spgAS/eCI
	 6fq9XvvuVbfiNgFpg5oFI2toqQjQLOaF3t0pFH/gAlm5EI1AgP4+8L6421rq2dg0y2
	 ILSDAN1jLSsu9V0ZSlW0nDqwNaTNXePEup6wIg36jQqoO68a2smEMJPmQxM0uadMWb
	 t7X9jxTSKq8jg==
Message-ID: <sashiko-outbox-232619@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125051909.61227-1-arzuagapozosergio@gmail.com>
References: <20261125045143.53035-1-arzuagapozosergio@gmail.com>
 <20261125051909.61227-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 05:39:15 +0000
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
- [High] ext4: ea_inode refcount leak in ext4_xattr_block_set() when
  new_bh =3D=3D bs->bh
- [Low] selftests/ext4: flat main() and manual TAP plan in
  ext4_xattr_journal_credits
--

commit 772b6f10e7b839b9e96f3998c77f31c8ed924efa
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

ext4: bound xattr journal credits to transaction limit

This commit drops obsolete ea_inode removal credits from
__ext4_xattr_set_credits(), bounds xattr credit estimates against the
JBD2 transaction limit, drops the provisional ea_inode reference when
reusing a cached xattr block, and adds an ext4 selftest.

Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b9650..0a955a6e0912d 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c

[ ... ]

> @@ -2109,6 +2090,18 @@ ext4_xattr_block_set(handle_t *handle, struct inod=
e *inode,
>  								   new_bh);
>  				if (error)
>  					goto cleanup_dquot;
> +				if (ea_inode &&
> +				    !(bs->bh && s->base =3D=3D bs->bh->b_data)) {
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
Does this leak an on-disk reference on ea_inode when a cloned xattr block
matches bs->bh itself in ea_block_cache (new_bh =3D=3D bs->bh)?

ext4_xattr_value_same() returns 0 whenever s->here->e_value_inum is set, so
overwriting an existing ea_inode-backed attribute with the same value still
enters ext4_xattr_block_set(), where ext4_xattr_inode_lookup_create() finds
the existing ea_inode and increments its on-disk refcount.  When bs->bh is
shared (h_refcount > 1) or its mb_cache entry is busy, clone_block clears
s->here->e_value_inum in s->base so ext4_xattr_set_entry() does not drop the
existing reference, then writes the same ea_inode->i_ino back into s->base
and ext4_xattr_block_cache_find() returns new_bh =3D=3D bs->bh:

fs/ext4/xattr.c:ext4_xattr_block_set() {
    ...
		if (new_bh) {
			/* We found an identical block in the cache. */
			if (new_bh =3D=3D bs->bh)
				ea_bdebug(new_bh, "keeping");
			else {
    ...
}

Because the new_bh =3D=3D bs->bh branch skips the else block and bs->bh =3D=
=3D new_bh
also skips ext4_xattr_release_block(), the provisional reference on ea_inode
is never decremented, leaving the ea_inode and its data blocks permanently
allocated on disk.  Moving this ea_inode drop after the if (new_bh =3D=3D b=
s->bh)
/ else block (still inside if (new_bh)) would cover both cases.

> diff --git a/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_=
credits.c b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_cre=
dits.c
> new file mode 100644
> index 0000000000000..85dd28d62bcf3
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credits=
.c
> @@ -0,0 +1,243 @@

[ ... ]

> +static void report_setup_error(const char *what, unsigned int skip_count)
> +{
> +	int saved_errno =3D errno;
> +	unsigned int i;
> +
> +	ksft_test_result_error("setup %s: %s\n", what,
> +			       strerror(saved_errno));
> +	for (i =3D 0; i < skip_count; i++)
> +		ksft_test_result_skip("setup failed\n");
> +}

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
Could this test use kselftest_harness.h (FIXTURE(), FIXTURE_SETUP(),
FIXTURE_TEARDOWN(), and TEST_F() with ASSERT_*/EXPECT_*) instead of a flat
main() that chains checks with boolean flags and pads the TAP plan via
report_setup_error()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125051909.6122=
7-1-arzuagapozosergio@gmail.com?part=3D1
