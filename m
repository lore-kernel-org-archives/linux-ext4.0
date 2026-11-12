Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457692;
	b=V4g4oSgZCFJ7wqnlw3jjuAAlNcW2aLUYyUQeNP0NnD0PZU7BrjQ8cx7cQ78mBMkaMg4M
	 ucX4id5/CikVeZPvCmxFfuJ7D9UWWUJzsIOGgIvex+4I8Zjp7q32I60i3qtWrrXQ2OA0s
	 qKPaZ/Q9D0/GuguUVro+lqGGWAHRbXQMW9bjiP98CbvIDX5buEs9LFrDUFyEdvCnCQVeW
	 ZmTV3ud9IzDNIOxmuKS04n8N7Xg5eGbjTvQr9vZsNv5uQEZZDCNPIuiRuhJrCd8WiJCvs
	 fINwjTgJwKyNTlNDYYeB+A7iNGFX6ei8rrzH9JtvA5Dq6JEK5GmyIZ14pw4k1EuvDCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457692;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ym/Jp01tIDfTLZC5bAYoURWSnCJ4PkEKCLPWMt8ratE=;
	b=lgtyqX41R7r/7yq9zgwC8DY3i1ecXA+gyHFqmADeaosgG2AsuACyQombvOqK3CFwzKgg
	 afiGe7/VEdVEb9foEOkmpvvxgCTIw09PBdQqD9gKIYvk5RBenWtBUmQVeL1tbny8KEhib
	 L+WZpl+mJsYpUtgefRC9z25eeVpPWYdSnMeOHAL36CcQlgY3KGTpBpB8Gzic+JntOOE6u
	 tZ+wQ29r6EFOXMoYWnFksSQGqxHh+GqgOmA5FwSCJQtC7QaxqTbDBZWU7yQG5vKQrgz6+
	 pzzYMDDrFWQbirzqm0dkX/557Hu8CYzyn6x0RoQhtcc3XmqYV1pBlggjmUwVjy6IKyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOXRKTMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BD2606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOXRKTMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829E91F00A05;
	Thu, 12 Nov 2026 04:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457692;
	bh=ym/Jp01tIDfTLZC5bAYoURWSnCJ4PkEKCLPWMt8ratE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=oOXRKTMk6qvnwNxuuumkvrXNqDN0J0uE+tag+cZjzsWV9uNTq9Yt1mdfBcQWKbLK0
	 iKBVI574+vSrWpWSk33c0Kw3aFmrEWYox3DOoljTnyY3kbUWqrna30tnEpUImsYdUz
	 wsF2a9mJsW8PUMvDwYNCDlfyf47CntDXCNyLGejzV/s+AiFOeuUoaTszuc9LAS3cEB
	 r6ABdTwixnXzQ8EFvZygYZ2/kPEl0J2CIanB4B1DxTe491PjNcTxQTmCqzxNK/EYXq
	 wIZKuQi5YyIEt1voTKvWTSueQeI4uyWmzfnhtsEPsj82AjI1Bv9XRUHuxHcpWSgUNf
	 4Q5s3UgZSC/+A==
Message-ID: <sashiko-outbox-210337@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/27] ext4: add KUnit tests for fs/ext4/extents.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-3-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-3-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:28:12 +0000
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
- [Low] ext4: use-after-free of sb->s_bdev after deactivate_super() in
  extents_kunit_exit()
- [Low] ext4: stale i_es_tree entries and warnings in extents-test.c
  KUnit tests
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Medium] ext4: data block leak in ext4_ext_map_blocks() on -ENOMEM
  extent insert [1]
--

commit 228dbe39d61604db8aef3d32655ec0608aa3210f
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/extents.c

This commit expands the ext4_extents_test KUnit suite in
fs/ext4/extents-test.c to cover extent tree initialization, validation,
navigation, insertion, merging, removal, block mapping, shifting, swapping,
and fast-commit replay helpers, while adding KUnit static stubs for metadata
and block allocation helpers.

> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index c3836ecb89f9c..7056481862188 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
[ ... ]
> @@ -142,33 +182,201 @@ static struct file_system_type ext_fs_type =3D {
[ ... ]
>  static void extents_kunit_exit(struct kunit *test)
>  {
>  	struct ext4_sb_info *sbi;
> +	struct super_block *sb;
> =20
>  	if (!k_ctx.k_ei)
>  		return;
> =20
> -	sbi =3D k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
> +	sb =3D k_ctx.k_ei->vfs_inode.i_sb;
> +	sbi =3D sb->s_fs_info;
> +
> +	if (k_ctx.k_ei2) {
> +		ext_cleanup_inode(&k_ctx.k_ei2->vfs_inode);
> +		kfree(k_ctx.k_ei2);
> +	}
> +	ext_cleanup_inode(&k_ctx.k_ei->vfs_inode);
> +
> +	percpu_counter_destroy(&sbi->s_freeclusters_counter);
> +	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
>  	ext4_es_unregister_shrinker(sbi);
> -	deactivate_super(sbi->s_sb);
> +	deactivate_super(sb);
> +
> +	kfree(k_ctx.meta_blocks);
> +	kfree(sbi->s_es);
> +	kfree(sb->s_bdev->bd_mapping);
> +	kfree(sb->s_bdev);
>  	kfree(sbi);

[Severity: Low]
Can dereferencing sb->s_bdev after deactivate_super(sb) cause a
use-after-free?

deactivate_super(sb) drops the final active and passive references on sb
via kill_anon_super() and put_super(), queuing sb for RCU and workqueue
destruction (destroy_super_work() -> kfree(sb)).  Freeing
sb->s_bdev->bd_mapping and sb->s_bdev before calling deactivate_super(sb),
as the error path in extents_kunit_init() does, avoids reading from sb
after its reference count reaches zero.

[ ... ]

> +static void test_convert_to_initialized_abut_neighbors(struct kunit *tes=
t)
> +{
> +	struct inode *inode =3D &k_ctx.k_ei->vfs_inode;
> +	struct ext4_extent_header *eh =3D ext_inode_hdr(inode);
> +	struct ext4_extent *ex;
> +	struct ext4_map_blocks map =3D {};
> +	int ret;
> +
> +	EXT4_SB(inode->i_sb)->s_extent_max_zeroout_kb =3D 0;
> +	ext_reset_tree(inode);
> +
> +	/*
> +	 * Setup: [10, 12) @ 100 (written), [12, 16) @ 102 (unwritten),
> +	 * [16, 18) @ 106 (written).
> +	 */
> +	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 2, 100, false, 0), 0);
> +	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 12, 4, 102, true, 0), 0);
> +	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 16, 2, 106, false, 0), 0);
> +	KUNIT_EXPECT_EQ(test, le16_to_cpu(eh->eh_entries), 3);
> +
> +	/*
> +	 * Convert head of unwritten extent [12, 14): transfers 2 blocks to
> +	 * left neighbor [10, 12) -> [10, 14) written, [14, 16) unwritten.
> +	 */
> +	map.m_lblk =3D 12;
> +	map.m_len =3D 2;
> +	map.m_flags =3D 0;
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ret =3D ext4_ext_map_blocks(NULL, inode, &map, EXT4_GET_BLOCKS_CREATE);
> +	up_write(&EXT4_I(inode)->i_data_sem);
[ ... ]
> +static void test_ext_fast_commit_replay(struct kunit *test)
> +{
> +	struct inode *inode =3D &k_ctx.k_ei->vfs_inode;
> +	struct ext4_extent_header *eh =3D ext_inode_hdr(inode);
> +	struct ext4_extent *ex;
> +	int err;
> +
> +	ext_reset_tree(inode);
> +	/* Start with unwritten extent [10, 20) @ 100 */
> +	KUNIT_ASSERT_EQ(test, ext_insert_one(inode, 10, 10, 100, true, 0), 0);
> +
> +	/* Replay update converting middle [12, 16) to written @ 102 */
> +	err =3D ext4_ext_replay_update_ex(inode, 12, 4, 0, 102);

[Severity: Low]
Do test_ext_fast_commit_replay() and
test_convert_to_initialized_abut_neighbors() leave stale unwritten entries
in i_es_tree that trigger ext4_es_cache_extent() conflict warnings?

In test_ext_fast_commit_replay(), EXT4_FC_REPLAY is not set in
EXT4_SB(inode->i_sb)->s_mount_state.  The first ext4_ext_replay_update_ex()
call invokes ext4_find_extent(..., 0) -> ext4_cache_extents(), which caches
[10, 20) as unwritten in i_es_tree before converting [12, 16) to written in
the extent tree.  Later calls to ext4_ext_replay_update_ex(),
ext4_ext_replay_shrink_inode(), and ext4_ext_replay_set_iblocks() then try
to cache the converted written extents over the stale unwritten entry in
i_es_tree, logging ext4_warning_inode() conflict messages and causing
ext4_ext_replay_set_iblocks() -> ext4_map_blocks() to hit the stale cache
instead of reading the extent tree.

Similarly, test_convert_to_initialized_abut_neighbors() calls
ext4_ext_map_blocks() directly without EXT4_EX_NOCACHE, bypassing
ext4_map_blocks() where i_es_tree is normally updated via
ext4_es_insert_extent(), so the second ext4_ext_map_blocks() call also hits
an ext4_es_cache_extent() conflict warning on [10, 14).

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6c018bcc01187..efbee7aaa95dc 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
[ ... ]
> @@ -1332,7 +1339,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, =
struct inode *inode,
>  	if (newblock =3D=3D 0)
>  		return err;
> =20
> -	bh =3D sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
> +	bh =3D ext4_ext_getblk(inode, newblock, __GFP_MOVABLE | GFP_NOFS);
>  	if (unlikely(!bh))
>  		return -ENOMEM;

[Severity: Medium]
This problem wasn't introduced by this patch, but does
ext4_ext_map_blocks() leak newly allocated data blocks [1] when
ext4_ext_insert_extent() fails with -ENOMEM?

Memory allocations in ext4_ext_insert_extent(), such as in
ext4_ext_create_new_leaf(), happen before the new extent is inserted into
the tree.  However, the error path in ext4_ext_map_blocks() only calls
ext4_free_blocks() when err is -EDQUOT or -ENOSPC, leaving the unreferenced
blocks allocated in the block bitmap and charged to inode->i_blocks and
quota on -ENOMEM:

fs/ext4/extents.c:ext4_ext_map_blocks() {
    ...
	path =3D ext4_ext_insert_extent(handle, inode, path, &newex, flags);
	if (IS_ERR(path)) {
		err =3D PTR_ERR(path);
		if (allocated_clusters && (err =3D=3D -EDQUOT || err =3D=3D -ENOSPC)) {
			...
			ext4_free_blocks(handle, inode, NULL, newblock,
					 EXT4_C2B(sbi, allocated_clusters),
					 fb_flags);
		}
		goto out;
	}
    ...
}

[1] https://sashiko.dev/#/bug/linux-d55bdb55-6626-49d1-965d-23a09e7996e3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D2
