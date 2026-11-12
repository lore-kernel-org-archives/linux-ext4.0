Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794501919;
	b=TjklteCs545wPCwi+nMiMPwvA6Gozrh4jcvucSxU5C5PTQy6/ybsdIZjnxtTNCVeSsAe
	 4oAIygq7v8Ph/p9XT/JpU/14IOQloV2Z+kZbl/IgPQJ06xy/SFck+BpHCf8qDWJO48up+
	 DTbVro7u8753tGVvegr7JbCsNR5b0Hq8hzmR8p2IiDq1l2nXnA92cYhIQY58ty0mOYJTi
	 4fJ/cjDHvc43QkpBHfWUl3NzzrW6t5fJw/MQTHAwS9frwFbKvehKex3t0W7JncChZ/qXi
	 UwGRFWJ47QsMAfwjSC8MR8zHDbNAOGUwTNeHUgV8jgL085wrJ4Bcdd9lojfqkpd1l4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794501919;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=7/ojOdEGI4A5G7GKccQvyhOtFFmOMehbVfb+nzLA2U0=;
	b=wxR3R6fTLsp/LE06AQ5n6w0t3mQWrzM3cfIqzcmm8OfNs1XJANQCngU4YS9/brPIuPvT
	 on0lu4WQDFzFOjxebtznrhreoxwYFAKlZP+QuOonPcf1ZO1GWJghcqtzEiq2g7bMbbur5
	 rJRoOxB+ZoRvcqmSM48VPy8pTYcaQ2QZwX81UJngkwE8pK75dB4IhnUrHxJqBbjEZr0mJ
	 xvo7idss8gWnHCJGgLfa9MYfcWQodc9jKubEOjS9Bw96xOQ6JfKQj1B3YFffU50y6xWzs
	 XGjjpjCfUdq6dJcxe9HXW7xDzFPwkp1ym6NFoG089l/uUG4i2mVfikxAf57BRPsDheQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Hywr3kxf;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3CD606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 16:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF3CD606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Hywr3kxf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794501918; x=1826037918;
  h=date:from:to:cc:subject:message-id;
  bh=cBRl84U5M2eCKBEA1lGOaS/+V/+E9CPIKjp0MGGkkQE=;
  b=Hywr3kxfMKE78PzGZMJjFyQTmNQUMgJKT9KiciRfZWYxqSjnGYjCfEHn
   GcvLHwUlF7BgfbOFEyIKrreDuzPMhy5Rwc94bs2KSIXHPA+FY8b0H/4t0
   iCznUKfD/eoidjSxoi1HbRfbL5z/iMe/5tnm2OXPCsoNM+BNmudcTRLuV
   1DWJQcZF7CBNyMgM5fUmqnl1yLrzlYINU07T18QkK5Kre4mCCpZYntRKg
   OY4K64T7tiqn/5Kfr6baxLgmywqq86rgd/hdKJJBXooD7YSO56kxPK+U+
   FYEblPMdggjMvMadyOYgUWPya11u++MQR4qIZXNMpzXIa23p2nS2TXOUa
   Q==;
X-CSE-ConnectionGUID: n06fzDOaTW6e80RUoL7jpw==
X-CSE-MsgGUID: RHSjiFKDSDSoVYAxsKFbbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3195601"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3195601"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 08:44:57 -0800
X-CSE-ConnectionGUID: 8t70ChWITc6RjPYLbxYjJg==
X-CSE-MsgGUID: 7OK7qJTfTeynNEVDJmlw6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="10430371"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa012.fm.intel.com with ESMTP; 12 Nov 2026 08:44:55 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRXuu-000000000v9-24vK;
	Thu, 12 Nov 2026 16:44:52 +0000
Date: Thu, 12 Nov 2026 17:44:29 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 16/50] fs/ext4/namei-test.c:2229:1: warning:
 the frame size of 1856 bytes is larger than 1536 bytes
Message-ID: <202611121731.hU760S80-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git pu
head:   246d715a48c25a74ac372dda5e10d8f69f89b50a
commit: 5fd9232f9345a5b0a0a0e9132dc439658d2a42db [16/50] ext4: enable full feature coverage in fs/ext4/.kunitconfig
config: xtensa-allmodconfig (https://download.01.org/0day-ci/archive/20261112/202611121731.hU760S80-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261112/202611121731.hU760S80-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611121731.hU760S80-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ext4/namei-test.c: In function 'test_namei_rename_and_exchange':
>> fs/ext4/namei-test.c:2229:1: warning: the frame size of 1856 bytes is larger than 1536 bytes [-Wframe-larger-than=]
    2229 | }
         | ^


vim +2229 fs/ext4/namei-test.c

171d9555beee6b Theodore Ts'o 2026-11-05  2082  
171d9555beee6b Theodore Ts'o 2026-11-05  2083  /*
171d9555beee6b Theodore Ts'o 2026-11-05  2084   * Test 14: Rename, overwrite rename, cross-directory subdirectory rename,
171d9555beee6b Theodore Ts'o 2026-11-05  2085   * RENAME_EXCHANGE (ext4_cross_rename), and slow symlink block initialization
171d9555beee6b Theodore Ts'o 2026-11-05  2086   * (ext4_init_symlink_block_test).
171d9555beee6b Theodore Ts'o 2026-11-05  2087   */
171d9555beee6b Theodore Ts'o 2026-11-05  2088  static void test_namei_rename_and_exchange(struct kunit *test)
171d9555beee6b Theodore Ts'o 2026-11-05  2089  {
171d9555beee6b Theodore Ts'o 2026-11-05  2090  	struct namei_test_ctx *ctx = test->priv;
171d9555beee6b Theodore Ts'o 2026-11-05  2091  	struct inode *root_dir = get_mock_inode(ctx, TEST_ROOT_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2092  	struct inode *dir1 = get_mock_inode(ctx, TEST_DIR_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2093  	struct inode *dir2 = get_mock_inode(ctx, TEST_DIR2_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2094  	struct inode *subdir = get_mock_inode(ctx, TEST_SUBDIR_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2095  	struct inode *file1 = get_mock_inode(ctx, TEST_FILE1_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2096  	struct inode *file2 = get_mock_inode(ctx, TEST_FILE2_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2097  	struct inode *symlink_inode = get_mock_inode(ctx, TEST_FILE3_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2098  	struct dentry d1_dentry, d2_dentry;
171d9555beee6b Theodore Ts'o 2026-11-05  2099  	struct dentry old_dentry, new_dentry, sub_dentry;
171d9555beee6b Theodore Ts'o 2026-11-05  2100  	struct buffer_head *bh;
171d9555beee6b Theodore Ts'o 2026-11-05  2101  	struct ext4_dir_entry_2 *de = NULL;
171d9555beee6b Theodore Ts'o 2026-11-05  2102  	const char *sym_target = "/very/long/symlink/target/path/for/ext4/test";
171d9555beee6b Theodore Ts'o 2026-11-05  2103  	struct fscrypt_str disk_link = {
171d9555beee6b Theodore Ts'o 2026-11-05  2104  		.name = (unsigned char *)sym_target,
171d9555beee6b Theodore Ts'o 2026-11-05  2105  		.len = strlen(sym_target) + 1,
171d9555beee6b Theodore Ts'o 2026-11-05  2106  	};
171d9555beee6b Theodore Ts'o 2026-11-05  2107  	int err;
171d9555beee6b Theodore Ts'o 2026-11-05  2108  
171d9555beee6b Theodore Ts'o 2026-11-05  2109  	ctx->es.s_feature_ro_compat |=
171d9555beee6b Theodore Ts'o 2026-11-05  2110  		cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
171d9555beee6b Theodore Ts'o 2026-11-05  2111  
171d9555beee6b Theodore Ts'o 2026-11-05  2112  	KUNIT_ASSERT_EQ(test, ext4_init_new_dir(NULL, root_dir, dir1), 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2113  	KUNIT_ASSERT_EQ(test, ext4_init_new_dir(NULL, root_dir, dir2), 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2114  	KUNIT_ASSERT_EQ(test, ext4_init_new_dir(NULL, dir1, subdir), 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2115  	set_nlink(dir1, 3); /* '.', '..', and subdir */
171d9555beee6b Theodore Ts'o 2026-11-05  2116  	set_nlink(dir2, 2);
171d9555beee6b Theodore Ts'o 2026-11-05  2117  
171d9555beee6b Theodore Ts'o 2026-11-05  2118  	init_mock_dentry(&d1_dentry, NULL, "dir1", dir1, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2119  	init_mock_dentry(&d2_dentry, NULL, "dir2", dir2, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2120  
171d9555beee6b Theodore Ts'o 2026-11-05  2121  	/* Invalid rename flags are rejected with -EINVAL */
171d9555beee6b Theodore Ts'o 2026-11-05  2122  	init_mock_dentry(&old_dentry, &d1_dentry, "f1", file1, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2123  	init_mock_dentry(&new_dentry, &d1_dentry, "f1_new", NULL, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2124  	KUNIT_EXPECT_EQ(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2125  		ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir1,
171d9555beee6b Theodore Ts'o 2026-11-05  2126  			&old_dentry, dir1, &new_dentry, ~0U), -EINVAL);
171d9555beee6b Theodore Ts'o 2026-11-05  2127  
171d9555beee6b Theodore Ts'o 2026-11-05  2128  	/* Add f1 and f2 in dir1, and subdir in dir1 */
171d9555beee6b Theodore Ts'o 2026-11-05  2129  	KUNIT_ASSERT_EQ(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2130  			ext4_add_entry_test(NULL, &old_dentry, file1), 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2131  	init_mock_dentry(&sub_dentry, &d1_dentry, "sub", subdir, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2132  	KUNIT_ASSERT_EQ(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2133  			ext4_add_entry_test(NULL, &sub_dentry, subdir), 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2134  
171d9555beee6b Theodore Ts'o 2026-11-05  2135  	/* 1) Same-directory rename: f1 -> f1_renamed */
171d9555beee6b Theodore Ts'o 2026-11-05  2136  	err = ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir1,
171d9555beee6b Theodore Ts'o 2026-11-05  2137  					       &old_dentry, dir1, &new_dentry,
171d9555beee6b Theodore Ts'o 2026-11-05  2138  					       0);
171d9555beee6b Theodore Ts'o 2026-11-05  2139  	KUNIT_ASSERT_EQ(test, err, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2140  	KUNIT_EXPECT_NULL(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2141  		ext4_find_entry_test(dir1, &old_dentry.d_name, &de, NULL));
171d9555beee6b Theodore Ts'o 2026-11-05  2142  	bh = ext4_find_entry_test(dir1, &new_dentry.d_name, &de, NULL);
171d9555beee6b Theodore Ts'o 2026-11-05  2143  	KUNIT_ASSERT_FALSE(test, IS_ERR_OR_NULL(bh));
171d9555beee6b Theodore Ts'o 2026-11-05  2144  	KUNIT_EXPECT_EQ(test, le32_to_cpu(de->inode), TEST_FILE1_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2145  	brelse(bh);
171d9555beee6b Theodore Ts'o 2026-11-05  2146  
171d9555beee6b Theodore Ts'o 2026-11-05  2147  	/* 2) Overwrite rename: f1_renamed overwrites existing f2 in dir1 */
171d9555beee6b Theodore Ts'o 2026-11-05  2148  	init_mock_dentry(&old_dentry, &d1_dentry, "f1_new", file1, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2149  	init_mock_dentry(&new_dentry, &d1_dentry, "f2", file2, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2150  	KUNIT_ASSERT_EQ(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2151  			ext4_add_entry_test(NULL, &new_dentry, file2), 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2152  	ctx->orphan_add_calls = 0;
171d9555beee6b Theodore Ts'o 2026-11-05  2153  	err = ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir1,
171d9555beee6b Theodore Ts'o 2026-11-05  2154  					       &old_dentry, dir1, &new_dentry,
171d9555beee6b Theodore Ts'o 2026-11-05  2155  					       0);
171d9555beee6b Theodore Ts'o 2026-11-05  2156  	KUNIT_ASSERT_EQ(test, err, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2157  	KUNIT_EXPECT_EQ(test, file2->i_nlink, 0U);
171d9555beee6b Theodore Ts'o 2026-11-05  2158  	KUNIT_EXPECT_EQ(test, ctx->orphan_add_calls, 1U);
171d9555beee6b Theodore Ts'o 2026-11-05  2159  	KUNIT_EXPECT_EQ(test, ctx->last_orphan_add_ino, TEST_FILE2_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2160  
171d9555beee6b Theodore Ts'o 2026-11-05  2161  	/* 3) Cross-directory subdir move: dir1/sub -> dir2/sub_moved */
171d9555beee6b Theodore Ts'o 2026-11-05  2162  	init_mock_dentry(&new_dentry, &d2_dentry, "sub_moved", NULL, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2163  	err = ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir1,
171d9555beee6b Theodore Ts'o 2026-11-05  2164  					       &sub_dentry, dir2, &new_dentry,
171d9555beee6b Theodore Ts'o 2026-11-05  2165  					       0);
171d9555beee6b Theodore Ts'o 2026-11-05  2166  	KUNIT_ASSERT_EQ(test, err, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2167  	KUNIT_EXPECT_EQ(test, dir1->i_nlink, 2U);
171d9555beee6b Theodore Ts'o 2026-11-05  2168  	KUNIT_EXPECT_EQ(test, dir2->i_nlink, 3U);
171d9555beee6b Theodore Ts'o 2026-11-05  2169  
171d9555beee6b Theodore Ts'o 2026-11-05  2170  	/* Verify subdir's '..' now points to dir2 */
171d9555beee6b Theodore Ts'o 2026-11-05  2171  	bh = map_and_get_dir_bh(ctx, subdir, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2172  	de = ext4_next_entry((struct ext4_dir_entry_2 *)bh->b_data,
171d9555beee6b Theodore Ts'o 2026-11-05  2173  			     TEST_BLK_SIZE);
171d9555beee6b Theodore Ts'o 2026-11-05  2174  	KUNIT_EXPECT_EQ(test, le32_to_cpu(de->inode), TEST_DIR2_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2175  
171d9555beee6b Theodore Ts'o 2026-11-05  2176  	/*
171d9555beee6b Theodore Ts'o 2026-11-05  2177  	 * 4) RENAME_EXCHANGE (ext4_cross_rename): exchange regular file
171d9555beee6b Theodore Ts'o 2026-11-05  2178  	 *    dir1/f2 with directory dir2/sub_moved across parents!
171d9555beee6b Theodore Ts'o 2026-11-05  2179  	 */
171d9555beee6b Theodore Ts'o 2026-11-05  2180  	init_mock_dentry(&old_dentry, &d1_dentry, "f2", file1, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2181  	init_mock_dentry(&new_dentry, &d2_dentry, "sub_moved", subdir,
171d9555beee6b Theodore Ts'o 2026-11-05  2182  			 &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2183  
171d9555beee6b Theodore Ts'o 2026-11-05  2184  	/* Cross-project RENAME_EXCHANGE and normal rename return -EXDEV */
171d9555beee6b Theodore Ts'o 2026-11-05  2185  	ext4_set_inode_flag(dir2, EXT4_INODE_PROJINHERIT);
171d9555beee6b Theodore Ts'o 2026-11-05  2186  	EXT4_I(dir2)->i_projid = make_kprojid(&init_user_ns, 77);
171d9555beee6b Theodore Ts'o 2026-11-05  2187  	KUNIT_EXPECT_EQ(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2188  		ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir1,
171d9555beee6b Theodore Ts'o 2026-11-05  2189  			&old_dentry, dir2, &new_dentry, RENAME_EXCHANGE),
171d9555beee6b Theodore Ts'o 2026-11-05  2190  		-EXDEV);
171d9555beee6b Theodore Ts'o 2026-11-05  2191  	KUNIT_EXPECT_EQ(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2192  		ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir1,
171d9555beee6b Theodore Ts'o 2026-11-05  2193  			&old_dentry, dir2, &new_dentry, 0),
171d9555beee6b Theodore Ts'o 2026-11-05  2194  		-EXDEV);
171d9555beee6b Theodore Ts'o 2026-11-05  2195  	ext4_clear_inode_flag(dir2, EXT4_INODE_PROJINHERIT);
171d9555beee6b Theodore Ts'o 2026-11-05  2196  	EXT4_I(dir2)->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
171d9555beee6b Theodore Ts'o 2026-11-05  2197  
171d9555beee6b Theodore Ts'o 2026-11-05  2198  	err = ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir1,
171d9555beee6b Theodore Ts'o 2026-11-05  2199  					       &old_dentry, dir2, &new_dentry,
171d9555beee6b Theodore Ts'o 2026-11-05  2200  					       RENAME_EXCHANGE);
171d9555beee6b Theodore Ts'o 2026-11-05  2201  	KUNIT_ASSERT_EQ(test, err, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2202  	KUNIT_EXPECT_EQ(test, dir1->i_nlink, 3U);
171d9555beee6b Theodore Ts'o 2026-11-05  2203  	KUNIT_EXPECT_EQ(test, dir2->i_nlink, 2U);
171d9555beee6b Theodore Ts'o 2026-11-05  2204  	de = ext4_next_entry((struct ext4_dir_entry_2 *)bh->b_data,
171d9555beee6b Theodore Ts'o 2026-11-05  2205  			     TEST_BLK_SIZE);
171d9555beee6b Theodore Ts'o 2026-11-05  2206  	KUNIT_EXPECT_EQ(test, le32_to_cpu(de->inode), TEST_DIR_INO);
171d9555beee6b Theodore Ts'o 2026-11-05  2207  
171d9555beee6b Theodore Ts'o 2026-11-05  2208  	/*
171d9555beee6b Theodore Ts'o 2026-11-05  2209  	 * Overwriting a target inode whose i_nlink == 0 returns -EFSCORRUPTED
171d9555beee6b Theodore Ts'o 2026-11-05  2210  	 * (in dir2, "sub_moved" now points to file1 after the exchange).
171d9555beee6b Theodore Ts'o 2026-11-05  2211  	 */
171d9555beee6b Theodore Ts'o 2026-11-05  2212  	init_mock_dentry(&old_dentry, &d1_dentry, "f2", subdir, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2213  	init_mock_dentry(&new_dentry, &d2_dentry, "sub_moved", file1, &ctx->sb);
171d9555beee6b Theodore Ts'o 2026-11-05  2214  	set_nlink(file1, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2215  	KUNIT_EXPECT_EQ(test,
171d9555beee6b Theodore Ts'o 2026-11-05  2216  		ext4_dir_inode_operations.rename(&nop_mnt_idmap, dir2,
171d9555beee6b Theodore Ts'o 2026-11-05  2217  			&new_dentry, dir2, &new_dentry, 0),
171d9555beee6b Theodore Ts'o 2026-11-05  2218  		-EFSCORRUPTED);
171d9555beee6b Theodore Ts'o 2026-11-05  2219  	set_nlink(file1, 1);
171d9555beee6b Theodore Ts'o 2026-11-05  2220  
171d9555beee6b Theodore Ts'o 2026-11-05  2221  	/* 5) Test ext4_init_symlink_block_test */
171d9555beee6b Theodore Ts'o 2026-11-05  2222  	err = ext4_init_symlink_block_test(NULL, symlink_inode, &disk_link);
171d9555beee6b Theodore Ts'o 2026-11-05  2223  	KUNIT_ASSERT_EQ(test, err, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2224  	KUNIT_EXPECT_EQ(test, symlink_inode->i_size,
171d9555beee6b Theodore Ts'o 2026-11-05  2225  			(loff_t)strlen(sym_target));
171d9555beee6b Theodore Ts'o 2026-11-05  2226  	bh = map_and_get_dir_bh(ctx, symlink_inode, 0);
171d9555beee6b Theodore Ts'o 2026-11-05  2227  	KUNIT_ASSERT_NOT_NULL(test, bh);
171d9555beee6b Theodore Ts'o 2026-11-05  2228  	KUNIT_EXPECT_STREQ(test, bh->b_data, sym_target);
171d9555beee6b Theodore Ts'o 2026-11-05 @2229  }
171d9555beee6b Theodore Ts'o 2026-11-05  2230  

:::::: The code at line 2229 was first introduced by commit
:::::: 171d9555beee6b445eb465dcbe657dd99ddf24b8 ext4: add KUnit tests for fs/ext4/namei.c

:::::: TO: Theodore Ts'o <tytso@mit.edu>
:::::: CC: Theodore Ts'o <tytso@mit.edu>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
