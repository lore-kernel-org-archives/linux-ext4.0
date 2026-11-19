Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104800;
	b=tV2Tp2bTcn/3wEbxc6xQpBpiqU+VKzPRmCopjzHTrTiSWB3gpoTC77DjJKz45INA8GAO
	 xQjvHQSSBqk2J2n5Zb5Mp61GRhgITghL2llq7qjWLpNTl/p6nW7362UZRm/GkOOjiFNII
	 taYi6WrAdHE2/2cMT+Fs1f51Xvp7Ch24Fz1h1aW0N0EzYOsb7QSOBcJyo0SJ8ZzdPWMy8
	 ccST9x7YSSi//WhBfW0R5PwWGJhdnNgqEGHnPB2tT8GaVIlvYi+NS84ry3Cb0J4puWwkS
	 rC1pik+6QbqdonBa4Fti5SS1g/kvv4mNd0FYJZkMmHGmx9hYo+RwLM/lcuE06+vajfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104800;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lDF8mIZ5H2EamfvOvpgrtEfqVw1ehUb1jTyPzIRzXts=;
	b=ZqsmPPBgwkBxvXCNSZiHeQxhyE6yhGE7yJpFE+IBE5IhGWMK9joVYSdPr3uDJ46WZScL
	 ElvXDgoprU2Qa1suS0YX2zr/4bJn1dExfNX6xkK5gAZA90KckqJGVWwFYV0F980GrFtVx
	 ZHeqvYlo008KgP+738OTJnQQCiwsf2NH9cNP1xscyFgwKHLEf7Zrg1DsfEMjQYp63htb7
	 Rv5CiB+VhJ5s4Eq28+f0fRdCeT09zFTWRau9U7oaGz+tTJHvCa2gEFMbJgC7PH3Vgn4R8
	 z4w+kECLr2PYX3ZJ7oWR3qogKIoCf1qfPTT4mh8+wRQQAqxYg0eUpOZjxiWoeKMy6yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrOIOky1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B83606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrOIOky1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9FD1F000C4;
	Thu, 19 Nov 2026 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104800;
	bh=lDF8mIZ5H2EamfvOvpgrtEfqVw1ehUb1jTyPzIRzXts=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RrOIOky1PvrTjc4LGYZDjkfgI4Qjb8hWdyGa6xrLqmjTy+JAEef7Bu70++n+ggFRW
	 65X5WFERQBH7X38elvmhH337cI5EohjF92LpoK0mgl6Xj2qELjJChVpE3LqIYAk3Gi
	 RCZ24aagjhazmH9Og7yQSDqQ+7J010Aj8Bhwa5BVB0yvoaNpx7r+IxYlRJLyq7rRVj
	 y7yYpMmuGJErl+nVI07vpFX1eIzc3F/TWcd4pfmA8hCLFhyxyb0nwZ7uU+DkvkSLEw
	 RgdmgTQTdjfMy5PbgJrwvvIOsOAey1ILgYC3PJlOUN7IVH3VZdCQjJ7fNy+RPY9Lxq
	 2DbOqn9ozwJFg==
Message-ID: <sashiko-outbox-223496@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 09/26] ext4: add KUnit tests for fs/ext4/ialloc.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-10-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-10-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:13:19 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] ext4: leak of ctx and locked sb in ialloc_test_init() on
  allocation failure
--

commit 1c66a229567b11dc0a2eee47f9e0bdd4aba440b8
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/ialloc.c

This commit adds the ext4_ialloc_test KUnit test suite in
fs/ext4/ialloc-test.c along with static stub hooks and symbol exports to
exercise inode allocation, freeing, bitmap management, and group selection
heuristics in fs/ext4/ialloc.c.

> diff --git a/fs/ext4/ialloc-test.c b/fs/ext4/ialloc-test.c
> new file mode 100644
> index 0000000000000..c68b60c959614
> --- /dev/null
> +++ b/fs/ext4/ialloc-test.c

[ ... ]

> +static int ialloc_test_init(struct kunit *test)
> +{

[ ... ]

> +	ctx =3D kzalloc_obj(*ctx);
> +	KUNIT_ASSERT_NOT_NULL(test, ctx);
> +	test->priv =3D ctx;
> +
> +	fc =3D fs_context_for_mount(&ialloc_test_fs_type, 0);
> +	if (IS_ERR(fc)) {
> +		err =3D PTR_ERR(fc);
> +		kfree(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
> +	sb =3D sget_fc(fc, NULL, set_anon_super_fc);
> +	put_fs_context(fc);
> +	if (IS_ERR(sb)) {
> +		err =3D PTR_ERR(sb);
> +		kfree(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
> +	ctx->sb =3D sb;

[ ... ]

> +	/* Wire RCU-indexed group_info and flex_groups tables */
> +	for (g =3D 0; g < IALLOC_TEST_NGROUPS; g++) {
> +		struct ialloc_test_blk *iblk, *bblk;
> +		u32 free_inos =3D (g =3D=3D 0) ? IALLOC_TEST_BG0_FREE_INODES :
> +					   IALLOC_TEST_INODES_PER_GRP;
> +
> +		ctx->grp_infos[g] =3D kunit_kzalloc(test,
> +						  sizeof(*ctx->grp_infos[g]),
> +						  GFP_KERNEL);
> +		KUNIT_ASSERT_NOT_NULL(test, ctx->grp_infos[g]);

[Severity: Low]
Does KUNIT_ASSERT_NOT_NULL() leak ctx and leave sb active with s_umount
write-locked if kunit_kzalloc() fails?

ialloc_test_cleanup() is not registered until kunit_add_action_or_reset()
at the end of ialloc_test_init(), so aborting here skips the
deactivate_locked_super(sb) and kfree(ctx) cleanup that the subsequent
error paths in this function perform.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D9
