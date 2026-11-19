Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104479;
	b=PzleFJYhVnISeJ8L9wBXUSHSOyXoZfAfjW0kO5Q6r9hlt3Rmy95CFHS5HjXHXERcbTrt
	 FKfzQMAXDCZeDkmhGkUsl8UjQaSpmkD/Tk/B1MCeX2Ve0IJvbOkC0MQt3UjsdLYYyOnY/
	 T6lWj2ieh66wo16oWEbf+WlDDlImBOR3mLtbUosdAt1YvNytPnq2flsPX1YGCVKJPvvI6
	 TAgvZik68d3U3WOlesUH6TN9ANsutkLBUEK3itF+VbA6dnpln0a2e8gSXlmrc1RHA3bgw
	 zty57Xyc1wTF0qH5/dL5aFeSSVAT87BPWCzHCmL7Nt3m3H159yo4lVXd53ANnxLdGfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104479;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xtzj8RzgL9YsS5tuXt/oMbvpA5f4GuoILMg9ox9LDLs=;
	b=QQoEVJNtsx/WqiYfmjZ3J0zuCOH9LIXYa0Ygg53wWmnjUwTL3zu86LgAseBuo1A7jdqz
	 vC978olYDMXzGJTsbyrDhHjfPqrMmQMbIDt/td22oc79y22UegG26P2Z8UgC3qLvRhlde
	 Cz4S8OUKMMd5U0wLjSNBkLqWwpzhQETazrc8dpAoy8Si+67zuz9k1TCt0r+iXsAIzKvmB
	 hFomhfe5BStccSLEq89iP2IaZ4umpU5f+J0fJZUjJ6F3zYEYhPnYbbePjgIXG46nDa08J
	 ZXT63OxCQwxXBvckfht8U3CcQ5TGYjP4rNrBcKrNK9K6UedJtHZ+cXNQpn3EAVDhYCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i/fXb9UF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36247606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/fXb9UF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23961F000C6;
	Thu, 19 Nov 2026 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104478;
	bh=xtzj8RzgL9YsS5tuXt/oMbvpA5f4GuoILMg9ox9LDLs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=i/fXb9UFqaAcq/c5YkiulqXex2G0gL41ixyuxKC6H/lECzxSUsA92zGUewDwvmmO2
	 mOPMf7Q5CLEZ+hsScgxSiEjpJLA8HTqq1qS1N62wPfW8qICrBDVs2rdb6p3osIVpfT
	 u2oFnr13Dv/SUO3rP/PGHHZMLMt86ePRzTBUug3lMxLSl6iPp1nhFGPWrRy7ERS9An
	 1sleZ5vkPNlF7frkbqjF+U8BnSU4Tb36jBDdX+pZwDKQqKbEWFCZi9zZWMz0KZ3tV0
	 UmrnmqIjSMUKt0XkiUHy6T79HaNNYOJa8ZHo3qN5e8dT5/HAWz9BjAI24Qm0G8FF4a
	 djXKX4/9aoQSg==
Message-ID: <sashiko-outbox-223475@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 11/26] ext4: add KUnit tests for fs/ext4/orphan.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-12-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-12-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:07:58 +0000
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
- [Low] ext4: locked superblock and memory leak in orphan_test_init() on
  OOM
--

commit 793a4f2e9db580fb201beeb33032333df8328513
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/orphan.c

This commit adds the ext4_orphan_test KUnit test suite to exercise ext4
orphan inode tracking, orphan file management, and mount-time orphan
recovery.

> diff --git a/fs/ext4/orphan-test.c b/fs/ext4/orphan-test.c
> new file mode 100644
> index 0000000000000..bd60976a840d2
> --- /dev/null
> +++ b/fs/ext4/orphan-test.c
[ ... ]
> +static int orphan_test_init(struct kunit *test)
> +{
[ ... ]
> +	sb =3D sget_fc(fc, NULL, set_anon_super_fc);
> +	put_fs_context(fc);
> +	if (IS_ERR(sb)) {
> +		err =3D PTR_ERR(sb);
> +		free_percpu(ctx->bdev.bd_stats);
> +		kfree(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
[ ... ]
> +	for (g =3D 0; g < ORPHAN_TEST_NGROUPS; g++) {
> +		struct orphan_test_ibitmap *ibm =3D &ctx->ibitmaps[g];
> +
> +		ctx->grp_infos[g] =3D kunit_kzalloc(test,
> +						  sizeof(*ctx->grp_infos[g]),
> +						  GFP_KERNEL);
> +		KUNIT_ASSERT_NOT_NULL(test, ctx->grp_infos[g]);

[Severity: Low]
Does KUNIT_ASSERT_NOT_NULL() leak sb, ctx->bdev.bd_stats, and ctx if
kunit_kzalloc() fails here?

sget_fc() returns with sb->s_umount write-locked, and
orphan_test_cleanup_action is not registered until the end of
orphan_test_init().  Aborting here exits the KUnit kthread with
sb->s_umount held and leaves sb on super_blocks, unlike the root_inode
failure paths below that call deactivate_locked_super(sb),
free_percpu(), and kfree(ctx) before aborting.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D11
