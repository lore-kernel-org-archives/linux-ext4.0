Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794472239;
	b=CiB0P0bZzovpd9JXENeKZhdap+1BL9Gc2gs5D5qtcpQc2zNHBy6kNUWyEe5wJOyDYAGo
	 kx4Fk6gLzV5WSKiCcx5+KM+ylMv5mpH0iPOOPdjj8Iusy5MUy0CWQnZsN7yh0WJw5O23U
	 Q2ezCDKX7jI043Ttb61PV9MWQXw/eKZau+ABMwYMJyg1b2CiDKM7NFlA1kiKNQWDTfz+O
	 v94Kcweu3MLRTIxN6KF9iW4PxQXXPTJnGyyDm+Qr7fYcJ+jiaxCAur7odezIxkgLK0yw1
	 W13lSY6wlOBOU5hHk/jYMcQlQIHZ25RY4twysIXV/reOPp6A6liqPtFb4v2nD70NQlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794472239;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=3ttdl4uS6vb9HZYMMShzXdvnlciviGDehqbfbQ5BCqM=;
	b=YOxCDlCk8h2cHQNOzR9K4pXVKDi3hCzWre282Z48XKq8I4rGsBOS4pIlRJ3JDE2h2XTw
	 Ul7R13YZf9NMbYdLmSghg2OwXHXWgs3AYCuByUPB3D169GN8xH8PRHyGWZCGtE78QUE9L
	 1F3zStdDwIybi7UnvttQR4q1mAeEwqEu2YkACtgvLGsXuQvkdoYHa2cwMB7trR38aSrnH
	 Igy/w9x6D1dqYPED3+lMDH2Ble07DVSFYpx9KPTMsjbFuf1bA/fZs3gDoQF1pVlIWbb9S
	 3aNNXYAP1tJCIDq+BZ6mgm5YErBUu2Pe7XAL9uj4UnoHiv2+n+fXoeyCOii72iqsldQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EoCEJ4WY;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46870606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 08:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46870606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EoCEJ4WY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794472238; x=1826008238;
  h=date:from:to:cc:subject:message-id;
  bh=OIdUg0Px0CN0kxD/tVsSuCpgrxbMkd9n4yuwwEnAzdM=;
  b=EoCEJ4WYMAxF9t+E31lToq9TZyNkXZzCdenm7x6oK/XdXlVGFCHWfnIf
   s1980jpceOAaEr8HO3emhdFCZ+u7k5cSls+w/4sZeGMiKoBsIjmhFY0Da
   I+bAXNce9MmfPFGeBXL0ELTJYGupgiQP2GkYIYOHwXZ6UkeEskrpztXwz
   Fs/hPmqskN4X4w6TxrFi8d5THDQY9EBmIe4kESV8eDbzaEd5oFvcuye6G
   bTjZSo9J1fyH/KbcBsw7jeKMW7JFTP+wmCQhMCNh6GSbfk+sFO79KtUOX
   a9++w5xee6N0277Do10M0jv2ZvDuWKt5fYzAl6DuJ5IiVwsAIFE3yltDV
   A==;
X-CSE-ConnectionGUID: 8iBnTPm1Q3mX3xh5DnvmHg==
X-CSE-MsgGUID: MMFDPLUpRZWdEEbsPRs5Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3244437"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3244437"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 00:30:38 -0800
X-CSE-ConnectionGUID: 87xmXpO9TyGXH/njHPbwEQ==
X-CSE-MsgGUID: PTE3krhjR++hJKYDIfom0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="8556262"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 12 Nov 2026 00:30:36 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRQCX-000000000qB-3vFU;
	Thu, 12 Nov 2026 08:30:33 +0000
Date: Thu, 12 Nov 2026 09:29:54 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 4/50] fs/ext4/xattr-test.c:1531:13: warning:
 stack frame size (2912) exceeds limit (2048) in
 'test_xattr_credits_usage_expand_and_delete'
Message-ID: <202611120955.8LvZI7rV-lkp@intel.com>
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
commit: 64b5dfde9364204d0284d8800174ba8bb23d963f [4/50] ext4: add KUnit tests for fs/ext4/xattr.c
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20261112/202611120955.8LvZI7rV-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261112/202611120955.8LvZI7rV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611120955.8LvZI7rV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ext4/xattr-test.c:1531:13: warning: stack frame size (2912) exceeds limit (2048) in 'test_xattr_credits_usage_expand_and_delete' [-Wframe-larger-than]
    1531 | static void test_xattr_credits_usage_expand_and_delete(struct kunit *test)
         |             ^
   1 warning generated.


vim +/test_xattr_credits_usage_expand_and_delete +1531 fs/ext4/xattr-test.c

  1526	
  1527	/*
  1528	 * Test 10: ext4_get_inode_usage(), credit calculation, handle credit check,
  1529	 * ext4_expand_extra_isize_ea(), and ext4_xattr_delete_inode().
  1530	 */
> 1531	static void test_xattr_credits_usage_expand_and_delete(struct kunit *test)
  1532	{
  1533		struct xattr_test_ctx *ctx = test->priv;
  1534		struct inode *inode = &ctx->primary.ei.vfs_inode;
  1535		struct ext4_inode *raw = (struct ext4_inode *)ctx->primary.raw_buf;
  1536		journal_t fake_journal = {
  1537			.j_revoke_records_per_block = 64,
  1538		};
  1539		handle_t fake_handle = {
  1540			.h_reserved = 1,
  1541			.h_journal = &fake_journal,
  1542			.h_total_credits = 1,
  1543		};
  1544		const size_t large_len = 1000;
  1545		char *large_val;
  1546		char val28[28];
  1547		char buf[64];
  1548		qsize_t usage = 0;
  1549		int credits_create, credits_replace, credits_out = -1;
  1550		int ret;
  1551	
  1552		large_val = kunit_kmalloc(test, large_len, GFP_KERNEL);
  1553		KUNIT_ASSERT_NOT_NULL(test, large_val);
  1554		memset(large_val, 'L', large_len);
  1555	
  1556		/*
  1557		 * 1. Credit calculation and insufficient handle credits check
  1558		 */
  1559		credits_create = __ext4_xattr_set_credits(&ctx->sb, inode, NULL,
  1560							  100, true);
  1561		KUNIT_EXPECT_GT(test, credits_create, 0);
  1562	
  1563		ext4_set_feature_ea_inode(&ctx->sb);
  1564		credits_create = __ext4_xattr_set_credits(&ctx->sb, inode, NULL,
  1565							  1500, true);
  1566		credits_replace = __ext4_xattr_set_credits(&ctx->sb, inode, NULL,
  1567							   1500, false);
  1568		KUNIT_EXPECT_GT(test, credits_replace, credits_create);
  1569	
  1570		/* Without a journal (s_journal == NULL), credits_out is 0 */
  1571		ret = ext4_xattr_set_credits(inode, 1500, true, &credits_out);
  1572		KUNIT_EXPECT_EQ(test, ret, 0);
  1573		KUNIT_EXPECT_EQ(test, credits_out, 0);
  1574	
  1575		/* With s_journal set, ext4_xattr_set_credits() returns credits_create */
  1576		ctx->sbi.s_journal = &fake_journal;
  1577		ret = ext4_xattr_set_credits(inode, 1500, true, &credits_out);
  1578		ctx->sbi.s_journal = NULL;
  1579		KUNIT_EXPECT_EQ(test, ret, 0);
  1580		KUNIT_EXPECT_EQ(test, credits_out, credits_create);
  1581	
  1582		/* Handle with only 1 buffer credit (< credits) fails with -ENOSPC */
  1583		ret = ext4_xattr_set_handle(&fake_handle, inode, EXT4_XATTR_INDEX_USER,
  1584					    "k", "v", 1, XATTR_CREATE);
  1585		KUNIT_EXPECT_EQ(test, ret, -ENOSPC);
  1586	
  1587		/*
  1588		 * 2. ext4_expand_extra_isize_ea():
  1589		 * Put "keep" (4B -> 24B total) and "evict" (28B -> 52B total) in
  1590		 * ibody (88B usable, leaving 12B free).
  1591		 * First expand i_extra_isize from 32 -> 40 (8 bytes <= 12B free):
  1592		 * shifts ibody entries in-place without allocating an external block.
  1593		 * Then expand i_extra_isize from 40 -> 72 (32 bytes > 4B free):
  1594		 * "keep" (24 + 4 = 28 < 32) is too small alone, so "evict" (52 + 4 >= 32)
  1595		 * is moved to an external xattr block while "keep" stays in ibody!
  1596		 */
  1597		ext4_clear_feature_ea_inode(&ctx->sb);
  1598		ret = ext4_xattr_set(inode, EXT4_XATTR_INDEX_USER, "keep",
  1599				     "1234", 4, XATTR_CREATE);
  1600		KUNIT_ASSERT_EQ(test, ret, 0);
  1601		memset(val28, 'E', sizeof(val28));
  1602		ret = ext4_xattr_set(inode, EXT4_XATTR_INDEX_USER, "evict",
  1603				     val28, sizeof(val28), XATTR_CREATE);
  1604		KUNIT_ASSERT_EQ(test, ret, 0);
  1605		KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_file_acl, 0ULL);
  1606	
  1607		/* In-place ibody shift (32 -> 40) */
  1608		ret = ext4_expand_extra_isize_ea(inode, 40, raw, NULL);
  1609		KUNIT_ASSERT_EQ(test, ret, 0);
  1610		KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_extra_isize, (u16)40);
  1611		KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_file_acl, 0ULL);
  1612	
  1613		/* Eviction of "evict" to external block (40 -> 72) */
  1614		ret = ext4_expand_extra_isize_ea(inode, 72, raw, NULL);
  1615		KUNIT_ASSERT_EQ(test, ret, 0);
  1616		KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_extra_isize, (u16)72);
  1617		KUNIT_EXPECT_NE(test, EXT4_I(inode)->i_file_acl, 0ULL);
  1618	
  1619		/* Both "keep" (in ibody) and "evict" (in external block) remain readable */
  1620		KUNIT_EXPECT_EQ(test,
  1621				ext4_xattr_ibody_get(inode, EXT4_XATTR_INDEX_USER,
  1622						     "keep", buf, sizeof(buf)),
  1623				4);
  1624		KUNIT_EXPECT_EQ(test,
  1625				ext4_xattr_get(inode, EXT4_XATTR_INDEX_USER,
  1626					       "evict", buf, sizeof(buf)),
  1627				28);
  1628	
  1629		/*
  1630		 * 3. ext4_get_inode_usage() and ext4_xattr_delete_inode():
  1631		 * Add a 1000-byte EA inode attribute ("large_ea") and check that
  1632		 * ext4_get_inode_usage() accounts for 1 (parent inode) + 1 (EA inode)
  1633		 * = 2 inodes, and ext4_xattr_delete_inode() frees the external block
  1634		 * and drops the EA inode reference to 0.
  1635		 */
  1636		ext4_set_feature_ea_inode(&ctx->sb);
  1637		ret = ext4_xattr_set(inode, EXT4_XATTR_INDEX_USER, "large_ea",
  1638				     large_val, large_len, XATTR_CREATE);
  1639		KUNIT_ASSERT_EQ(test, ret, 0);
  1640	
  1641		down_read(&EXT4_I(inode)->xattr_sem);
  1642		ret = ext4_get_inode_usage(inode, &usage);
  1643		up_read(&EXT4_I(inode)->xattr_sem);
  1644		KUNIT_ASSERT_EQ(test, ret, 0);
  1645		KUNIT_EXPECT_EQ(test, usage, (qsize_t)2);
  1646	
  1647		ret = ext4_xattr_delete_inode(NULL, inode, 0);
  1648		KUNIT_ASSERT_EQ(test, ret, 0);
  1649		KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_file_acl, 0ULL);
  1650		KUNIT_EXPECT_EQ(test, ctx->ea_inodes[0].ei.vfs_inode.i_nlink, 0U);
  1651	}
  1652	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
