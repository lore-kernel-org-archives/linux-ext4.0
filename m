Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457565;
	b=KwsPK+upZZZNt5RkU54YrvFhxWmUMIfNN8X3jhVHNCp6IgoaCTLoIV/csAA/UcvID3gQ
	 9QmpzjuERfXo5ciZZxqfI1sjsAGV/Wj4d5Op8cyi9gSEgfpYlvyyuQbt1I7NlMjfAUSn1
	 xmCkQZRC6F/UBPwUhXsGj8WykvZa2oOcuh7dXWiQVJLMAMrQTjrhr9g49EY5hvUWN7RHN
	 rM67ZCwCi28CTha+Z89WEpWTSZtPEwM7XzwZh4DA1CcZx+hQQPgNSJ0TIvQntuf6pFvuw
	 aJDw1VPujiiXzx2Bt0mXSGATPNUpgUfp7ixfle3UbyInX4h6BLD/NMx+4QCDdtQ5BrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457565;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f80XaERHSYK7ttf3zlqxu8tPEGq2RUqUhyMEnhVjesI=;
	b=k3h1oJqY8hg9yLvNAqafqz9aGzbu+RmmWg+rfvZk0wEgL0Q8XZjD+Dxk/qV2xTCNcQso
	 tboGGQPmm4gVC6UZobPGrYVB7J5FT69omSh1pR6T7M72H+BlmOVBaO69N6+IHXtpxjV2j
	 mzAq0CBVu3zggQF3dB23JonAjeVP/q6EXf4lsIoeJM3zUJBNJDlMFO1+UTt3WxAMJKqQ1
	 YPloxBkUVvHLpylywKuHNEkd7DUiFs6UCC70Ty6RLDwKL8CLaO6GydFLVFinvf+aZgRSb
	 i0V+1JtjGOsayywKm/bGPm2b22iIoJExRNY58A5xKGo283yLS3kshiJfdOG/TdsZAhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XLftr+x9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97180606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XLftr+x9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3781F00A05;
	Thu, 12 Nov 2026 04:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457565;
	bh=f80XaERHSYK7ttf3zlqxu8tPEGq2RUqUhyMEnhVjesI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=XLftr+x9AISLxuA3p+OKg1XS154vkJdjOEbxdZUgbmOd6PcI0xNbJwd10pvpJ+5za
	 ztdu8WTt036QIzW/9H/ti8iVrFVSs3ymE9h9EvDT5JcoPJOBCNRlp/M+3sGF7OztRO
	 BtkuqlEn9rOZSY/iqNCLGikeYg9x41F1GaCWdrwzkl6Wkim084tNrI8XqXsX21ZsQP
	 hLNStqAmMIXAEycfHhQeewA4Q4lHxZ4K708o4G2KQM72JDc3myGeIycCFjkVH0ZsyJ
	 dB2xmUb6tVtxx+l29UbUoacL3881IlPbHHmaV49U/Bhds4Ni1tsSa7udgEgvODH2RX
	 9bVxDcVanz3wg==
Message-ID: <sashiko-outbox-210334@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/27] ext4: expand KUnit tests for fs/ext4/mballoc.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-7-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-7-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:26:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [Medium] ext4: test_mb_good_group() and test_mb_prefetch() fail on
  16K/64K PAGE_SIZE
- [Low] ext4: unpinned per-CPU locality group lookups across sleeps in
  mballoc-test.c
- [Low] ext4: unaligned __u32 accesses in mb_set_bits() and
  mb_test_and_clear_bits()
- [Low] ext4: test_mb_regular_allocator() step 3 skips CR_BEST_AVAIL_LEN
  trimming
- [Low] ext4: missing bb_free update in
  test_mb_simple_and_aligned_scan()
- [Low] ext4: unused *_test() wrapper functions in fs/ext4/mballoc.c
--

commit 72a0b9666c2cc1afd5fa22724c492669c1b39ccf
Author: Theodore Ts'o <tytso@mit.edu>

ext4: expand KUnit tests for fs/ext4/mballoc.c

This commit expands the ext4_mballoc_test KUnit suite in
fs/ext4/mballoc-test.c with 25 new parameterized tests and exports the
corresponding helper wrappers from fs/ext4/mballoc.c.

> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index d31780075c21e..402f4efdf25a4 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c

[ ... ]

> @@ -949,6 +1008,1747 @@ static void test_mb_mark_used_cost(struct kunit *=
test)
>  	ext4_mb_unload_buddy_test(&e4b);
>  }
> =20
> +static void test_mb_bit_ops(struct kunit *test)
> +{
> +	u8 *buf;
> +	void *unaligned;
> +	int bit, i;
> +
> +	buf =3D kunit_kzalloc(test, 128, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
> +
> +	/*
> +	 * Use an unaligned pointer (offset by 3 bytes) to exercise
> +	 * mb_correct_addr_and_bit() on 64-bit/32-bit architectures.
> +	 */
> +	unaligned =3D buf + 3;

[ ... ]

> +	/* Multi-word unaligned range spanning head bits, 32-bit words, and tai=
l */
> +	mb_set_bits(unaligned, 5, 75);
> +	KUNIT_EXPECT_EQ(test, mb_find_next_bit_test(unaligned, 256, 0), 5);
> +	KUNIT_EXPECT_EQ(test, mb_find_next_zero_bit_test(unaligned, 256, 5), 80=
);
> +	/* Clamping when no zero bit exists before max */
> +	KUNIT_EXPECT_EQ(test, mb_find_next_zero_bit_test(unaligned, 50, 5), 50);
> +
> +	/* Clear a sub-range across 32-bit boundaries */
> +	mb_clear_bits_test(unaligned, 13, 50);
> +	for (i =3D 0; i < 100; i++) {
> +		int expected =3D (i >=3D 5 && i < 13) || (i >=3D 63 && i < 80);
> +
> +		KUNIT_EXPECT_EQ(test, !!mb_test_bit_test(i, unaligned), expected);
> +	}
> +}
> +
> +static void test_mb_test_and_clear_bits(struct kunit *test)
> +{
> +	u8 *buf;
> +	void *bm;
> +	int ret, i;
> +
> +	buf =3D kunit_kzalloc(test, 128, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
> +	bm =3D buf + 3;
> +
> +	/* Case 1: All bits in range [5, 85) are set -> returns -1 and clears a=
ll */
> +	memset(buf, 0xff, 128);
> +	ret =3D mb_test_and_clear_bits_test(bm, 5, 80);

[Severity: Low]
Does passing buf + 3 to mb_set_bits() and mb_test_and_clear_bits_test()
cause misaligned 32-bit accesses?

Unlike the single-bit helpers that align the base address via
mb_correct_addr_and_bit(), mb_set_bits() and mb_test_and_clear_bits() take
a 32-bit word fast path when (cur & 31) =3D=3D 0 && (len - cur) >=3D 32 and
dereference __u32 *addr =3D bm + (cur >> 3) directly.  When cur reaches 32,
addr is buf + 7, which triggers UBSAN alignment warnings under
CONFIG_UBSAN_ALIGNMENT or alignment faults on strict-alignment
architectures.

[ ... ]

> +static void test_mb_good_group(struct kunit *test)
> +{
> +	struct super_block *sb =3D (struct super_block *)test->priv;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct ext4_buddy e4b;
> +	struct ext4_allocation_context ac =3D {};
> +	struct ext4_group_info *grp1, *grp2;
> +	int ret;
> +
> +	if (sb->s_blocksize > PAGE_SIZE)
> +		kunit_skip(test, "blocksize exceeds pagesize");
> +
> +	/* Initialize group 1 buddy cache so bb_fragments and orders are popula=
ted */
> +	ret =3D ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	ext4_mb_unload_buddy_test(&e4b);

[ ... ]

> +	/*
> +	 * Test ext4_mb_good_group_nolock on uninitialized group 2:
> +	 * At inexpensive CR_POWER2_ALIGNED, it skips initializing group 2 and =
returns 0.
> +	 * At expensive CR_GOAL_LEN_SLOW (with STRICT_CHECK), it initializes gr=
oup 2
> +	 * and returns 1.
> +	 */
> +	grp2 =3D ext4_get_group_info(sb, 2);
> +	KUNIT_ASSERT_NOT_NULL(test, grp2);
> +	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp2));
> +
> +	ac.ac_criteria =3D CR_POWER2_ALIGNED;\n> +	ret =3D ext4_mb_good_group_n=
olock_test(&ac, 2, CR_POWER2_ALIGNED);
> +	KUNIT_EXPECT_EQ(test, ret, 0);
> +	KUNIT_EXPECT_TRUE(test, EXT4_MB_GRP_NEED_INIT(grp2));

[Severity: Medium]
Will test_mb_good_group() and test_mb_prefetch() fail on 16K or 64K
PAGE_SIZE kernels?

ext4_mb_init_cache() initializes groups_per_folio =3D
DIV_ROUND_UP(folio_size(folio) / blocksize, 2) consecutive groups at once
whenever a buddy-cache folio is populated.  When blocksize is 1K on a 16K
page kernel, or 1K/4K on a 64K page kernel, groups_per_folio is at least
8, so loading group 1's buddy (or calling ext4_mb_prefetch_fini() on
groups [0, 2) in test_mb_prefetch()) also initializes group 2 on folio 0
and clears EXT4_GROUP_INFO_NEED_INIT_BIT on grp2, causing the
EXT4_MB_GRP_NEED_INIT(grp2) expectations in both tests to fail.

[ ... ]

> +static void test_mb_simple_and_aligned_scan(struct kunit *test)
> +{
> +	struct super_block *sb =3D (struct super_block *)test->priv;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct ext4_buddy e4b;
> +	struct ext4_allocation_context ac =3D {};
> +	struct inode *inode;
> +	int ret;
> +
> +	if (sb->s_blocksize > PAGE_SIZE)
> +		kunit_skip(test, "blocksize exceeds pagesize");
> +
> +	inode =3D mbt_alloc_test_inode(test, sb, S_IFREG);
> +
> +	/*
> +	 * Mark cluster 0 used in group 1 so:
> +	 * - order 3 buddy [8, 16) is the first order-3 buddy
> +	 * - first 16-cluster stripe [0, 16) is not completely free, so
> +	 *   stripe-aligned scan must skip to cluster 16.
> +	 */
> +	mbt_ctx_mark_used(sb, TEST_GOAL_GROUP, 0, 1);
> +
> +	ret =3D ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
> +	KUNIT_ASSERT_EQ(test, ret, 0);

[Severity: Low]
Does marking cluster 0 used here without decrementing
ext4_get_group_info(sb, TEST_GOAL_GROUP)->bb_free trigger a false bitmap
corruption error?

When ext4_mb_load_buddy_test() calls ext4_mb_generate_buddy(), the bitmap
free count is 1 less than grp->bb_free, which logs an inconsistency error
via ext4_grp_locked_error() and sets EXT4_GROUP_INFO_BBITMAP_CORRUPT on
TEST_GOAL_GROUP.

[ ... ]

> +static void test_mb_regular_allocator(struct kunit *test)
> +{

[ ... ]

> +	/*
> +	 * 3. MB_OPTIMIZE_SCAN with CR_BEST_AVAIL_LEN goal length trimming:
> +	 * Make group 2 the only group with free blocks, fragmented into two
> +	 * 8-cluster chunks [0, 8) and [16, 24) so largest_free_order =3D 3
> +	 * and avg_fragment_size =3D 8.
> +	 * Note: group 2 may have already been prefetched during step 2, so
> +	 * mark its blocks used via mb_mark_used_test on the loaded buddy.
> +	 */

[ ... ]

> +	memset(&ac, 0, sizeof(ac));
> +	ac.ac_sb =3D sb;
> +	ac.ac_inode =3D inode;
> +	ac.ac_status =3D AC_STATUS_CONTINUE;
> +	ac.ac_flags =3D EXT4_MB_HINT_DATA;
> +	ac.ac_g_ex.fe_group =3D 0;
> +	ac.ac_g_ex.fe_len =3D 16;
> +	ac.ac_orig_goal_len =3D 16;
> +	ac.ac_o_ex.fe_len =3D 8;
> +
> +	ret =3D ext4_mb_regular_allocator_test(&ac);

[Severity: Low]
Does setting ac_o_ex.fe_len =3D 8 prevent ext4_mb_scan_groups_best_avail()
from trimming ac_g_ex.fe_len down to 8 at CR_BEST_AVAIL_LEN?

In ext4_mb_scan_groups_best_avail(), order =3D fls(16) - 1 =3D 4 and min_or=
der
starts at 4 - 3 =3D 1, but because (1 << min_order) < ac->ac_o_ex.fe_len, it
clamps min_order to fls(8) =3D 4:

fs/ext4/mballoc.c:ext4_mb_scan_groups_best_avail() {
    ...
	order =3D fls(ac->ac_g_ex.fe_len) - 1;
    ...
	min_order =3D order - sbi->s_mb_best_avail_max_trim_order;
	if (min_order < 0)
		min_order =3D 0;
	if (1 << min_order < ac->ac_o_ex.fe_len)
		min_order =3D fls(ac->ac_o_ex.fe_len);

	for (i =3D order; i >=3D min_order; i--) {
    ...
}

As a result, the loop only checks i =3D 4 (fe_len =3D 16) and never trims to
i =3D 3 (fe_len =3D 8), so the allocation only succeeds after falling back =
to
CR_GOAL_LEN_SLOW and ext4_mb_try_best_found().  Setting ac_o_ex.fe_len <=3D=
 4
would allow min_order <=3D 3 so CR_BEST_AVAIL_LEN trims fe_len to 8.

[ ... ]

> +static void test_mb_group_pa_lifecycle(struct kunit *test)
> +{
> +	struct super_block *sb =3D (struct super_block *)test->priv;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct inode *inode1, *inode2;
> +	struct ext4_allocation_request ar =3D {};
> +	struct ext4_group_info *grp;
> +	ext4_fsblk_t blk1, blk2;
> +	int err =3D 0, discarded;
> +
> +	if (sb->s_blocksize > PAGE_SIZE)
> +		kunit_skip(test, "blocksize exceeds pagesize");
> +
> +	inode1 =3D mbt_alloc_test_inode(test, sb, S_IFREG);
> +	inode2 =3D mbt_alloc_test_inode(test, sb, S_IFREG);
> +	inode2->i_ino =3D 13;
> +
> +	/* Small files (<=3D s_mb_stream_request) use locality group PA (MB_GRO=
UP_PA) */
> +	i_size_write(inode1, sb->s_blocksize);
> +	i_size_write(inode2, sb->s_blocksize);
> +
> +	ar.inode =3D inode1;
> +	ar.logical =3D 0;
> +	ar.len =3D 1;
> +	ar.goal =3D ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
> +	ar.flags =3D EXT4_MB_HINT_DATA;
> +
> +	blk1 =3D ext4_mb_new_blocks(NULL, &ar, &err);
> +	KUNIT_ASSERT_EQ(test, err, 0);
> +	KUNIT_EXPECT_EQ(test, blk1, ext4_group_first_block_no(sb, TEST_GOAL_GRO=
UP));
> +
> +	/* Second small file allocation reuses the locality group PA */
> +	ar.inode =3D inode2;
> +	ar.logical =3D 0;
> +	ar.len =3D 1;
> +	ar.goal =3D ext4_group_first_block_no(sb, TEST_GOAL_GROUP);
> +	blk2 =3D ext4_mb_new_blocks(NULL, &ar, &err);
> +	KUNIT_ASSERT_EQ(test, err, 0);
> +	KUNIT_EXPECT_EQ(test, blk2, blk1 + EXT4_C2B(sbi, 1));
> +
> +	/* Discard all group preallocations and verify free count is restored */
> +	discarded =3D ext4_mb_discard_preallocations_test(sb, 0);
> +	rcu_barrier();
> +	KUNIT_EXPECT_EQ(test, discarded, (int)sbi->s_mb_group_prealloc - 2);
> +
> +	grp =3D ext4_get_group_info(sb, TEST_GOAL_GROUP);
> +	KUNIT_EXPECT_EQ(test, grp->bb_free, EXT4_CLUSTERS_PER_GROUP(sb) - 2);
> +}
> +
> +static void test_mb_lg_list_trim(struct kunit *test)
> +{
> +	struct super_block *sb =3D (struct super_block *)test->priv;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct ext4_locality_group *lg;
> +	struct inode *inode;
> +	struct ext4_buddy e4b;
> +	struct ext4_prealloc_space *pa;
> +	int i, ret, count =3D 0;
> +	int order =3D fls(15) - 1; /* pa_free =3D 15 -> order 3 */
> +
> +	if (sb->s_blocksize > PAGE_SIZE)
> +		kunit_skip(test, "blocksize exceeds pagesize");
> +
> +	inode =3D mbt_alloc_test_inode(test, sb, S_IFREG);
> +	sbi->s_mb_group_prealloc =3D 16;
> +
> +	ret =3D ext4_mb_load_buddy_test(sb, TEST_GOAL_GROUP, &e4b);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +
> +	/*
> +	 * Create 9 locality-group PAs in bucket order 3 (each of length 16 with
> +	 * 1 cluster used -> pa_free =3D 15). When the 9th PA is added via
> +	 * ext4_mb_release_context -> ext4_mb_add_n_trim, lg_prealloc_count > 8
> +	 * triggers ext4_mb_discard_lg_preallocations() to trim the list to 5!
> +	 */
> +	for (i =3D 0; i < 9; i++) {
> +		struct ext4_allocation_context ac =3D {};
> +		struct ext4_free_extent ex =3D {
> +			.fe_group =3D TEST_GOAL_GROUP,
> +			.fe_start =3D i * 32,
> +			.fe_len =3D 16,
> +		};
> +
> +		ac.ac_sb =3D sb;
> +		ac.ac_inode =3D inode;
> +		ac.ac_flags =3D EXT4_MB_HINT_DATA | EXT4_MB_HINT_GROUP_ALLOC;
> +		ac.ac_lg =3D raw_cpu_ptr(sbi->s_locality_groups);
> +		mutex_lock(&ac.ac_lg->lg_mutex);
> +
> +		ret =3D ext4_mb_pa_alloc_test(&ac);
> +		if (ret) {
> +			mutex_unlock(&ac.ac_lg->lg_mutex);
> +			ext4_mb_unload_buddy_test(&e4b);
> +			KUNIT_ASSERT_EQ(test, ret, 0);
> +		}
> +
> +		ext4_lock_group(sb, TEST_GOAL_GROUP);
> +		mb_mark_used_test(&e4b, &ex);
> +		ext4_unlock_group(sb, TEST_GOAL_GROUP);
> +
> +		ac.ac_status =3D AC_STATUS_FOUND;
> +		ac.ac_o_ex.fe_len =3D 1;
> +		ac.ac_b_ex =3D ex;
> +		ac.ac_f_ex =3D ex;
> +		ext4_mb_new_preallocation_test(&ac);
> +		/* Release context updates pa_free to 15 and runs ext4_mb_add_n_trim */
> +		ext4_mb_release_context_test(&ac);
> +	}
> +
> +	ext4_mb_unload_buddy_test(&e4b);
> +
> +	lg =3D raw_cpu_ptr(sbi->s_locality_groups);
> +	spin_lock(&lg->lg_prealloc_lock);
> +	list_for_each_entry(pa, &lg->lg_prealloc_list[order], pa_node.lg_list)
> +		count++;
> +	spin_unlock(&lg->lg_prealloc_lock);
> +
> +	KUNIT_EXPECT_EQ(test, count, 5);
> +}

[Severity: Low]
Can CPU migration across sleeping calls cause test_mb_group_pa_lifecycle()
and test_mb_lg_list_trim() to use different per-CPU sbi->s_locality_groups
instances?

Both tests run in a preemptible KUnit kthread and call sleeping functions
(ext4_mb_new_blocks(), mutex_lock(), and ext4_mb_pa_alloc_test()).  If the
kthread migrates CPUs between the two ext4_mb_new_blocks() calls in
test_mb_group_pa_lifecycle(), the second call looks up the new CPU's
empty lg_prealloc_list instead of reusing the first PA.  Similarly,
test_mb_lg_list_trim() re-evaluates raw_cpu_ptr(sbi->s_locality_groups) on
each loop iteration and again when counting lg_prealloc_list[order], so a
migration splits the 9 PAs across per-CPU lists and fails the count =3D=3D 5
check.

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 0f73fb826dbf4..46ba07e017a31 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c

[ ... ]

> +void mb_regenerate_buddy_test(struct ext4_buddy *e4b)
> +{
> +	mb_regenerate_buddy(e4b);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(mb_regenerate_buddy_test);

[ ... ]

> +void ext4_mb_measure_extent_test(struct ext4_allocation_context *ac,
> +				 struct ext4_free_extent *ex,
> +				 struct ext4_buddy *e4b)
> +{
> +	ext4_mb_measure_extent(ac, ex, e4b);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_measure_extent_test);

[ ... ]

> +bool ext4_mb_use_preallocated_test(struct ext4_allocation_context *ac)
> +{
> +	return ext4_mb_use_preallocated(ac);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_use_preallocated_test);

[ ... ]

> +void ext4_mb_pa_put_free_test(struct ext4_allocation_context *ac)
> +{
> +	ext4_mb_pa_put_free(ac);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_pa_put_free_test);
> +
> +void ext4_mb_generate_from_pa_test(struct super_block *sb, void *bitmap,
> +				   ext4_group_t group)
> +{
> +	ext4_mb_generate_from_pa(sb, bitmap, group);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_generate_from_pa_test);
> +
> +int ext4_mb_discard_group_preallocations_test(struct super_block *sb,
> +					      ext4_group_t group, int *busy)
> +{
> +	return ext4_mb_discard_group_preallocations(sb, group, busy);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_mb_discard_group_preallocations_test);

[Severity: Low]
This isn't a bug, but mb_regenerate_buddy_test(),
ext4_mb_measure_extent_test(), ext4_mb_use_preallocated_test(),
ext4_mb_pa_put_free_test(), and
ext4_mb_discard_group_preallocations_test() have no callers in
fs/ext4/mballoc-test.c.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D6
