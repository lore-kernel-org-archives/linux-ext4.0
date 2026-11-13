Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582828;
	b=r5O79Ovqn4MjXuBFdOHYHtnbNCXjkeqNjQPqLIsSe/lRQg8IRvmATzeydBd023LO38f5
	 2Qz96f4SpSh2eQsjf2qkAPl7mHeCDG0D0YM0BQr+M57wFoVIKsciJK4BoaykbvH2uk8fg
	 B5K+SbeQZPiMhPRTOtXKOBec1d2sD3+Cfejy//ygb+MLi64XKdmvimc80ZbkRZX+SWxmE
	 LNOyK8FFcNJJ16pTa9E9mSn/LLDntvd8u88RVVb+HcBHwab5YafXX1DNCzSnG+thzAujI
	 9RdeF0JW/LWQX0i5wWeOf/Vb7kQ1BREE6G9UyuiqlalTC3HhOnfTqJB2L9ZnZRMtILw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582828;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:Cc:
	 Subject:Message-ID:User-Agent;
	bh=ORA10z0A5rcNMVuBLaLTMamIf7t5aL++QT5nczvir5s=;
	b=GVJgX3r+RidUgMOTjClXd47/j+dH1PS5rEkCasj50LJSo9D5KzR3IIoiCFYh52tfiPYW
	 pUIg0Gq0j9cWjXAC9A2H6lBbjXRA1EPmpxgbhg0VDcZLKi7nZ8N3ga/4j9r7JYUKhdLDC
	 dcRxjumm2S6zIvV940PlOre//VU3q1s2XzDE1v2SR6aG0dgzztDjjJILKUdHVcYzpx9Pg
	 QcAtiuscHAf4H4OXFm44EzScb+BdeblljdMcyiFIuQTw+BvpcMs9VTJpyWbg+taGk7awg
	 b6MA9kX8V6Ya3WCg6ZGqPXIClDykJs4aevH1mA0bj0qSse7jhzgXZcgTjAicv8g9pPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="LHF7b5g/";
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4043F606A327
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 15:13:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4043F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LHF7b5g/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794582827; x=1826118827;
  h=date:from:cc:subject:message-id;
  bh=kBIEUENtSH0kzb64ENzAWKHGbuRrlpwKL/HjwH3dObg=;
  b=LHF7b5g/7VD3QNpYcZQqY7+fssvq8JKg7QhZhjpm+9ggzxNzbZCRX536
   +MDW4YUuhosU+qJdlzPCEEgy3cu0GPcv9FITU7MhthPzTqgaCs4/b0g75
   w++hAqIGF3r/ZDuRb16q1JPOvz3O6sDELSlWXUIkMsu99xo4xqVKH4coG
   htG+QR9CkwkNCsKbhKidE2JjaMPKkDEtZTpl9G4QUs7xh41kdOpR0n9Nd
   LtYlazIe378CHomddYfQCoXZ1LQjCIp/KWjxT8j5AUAKQUcaFfdwBllnI
   7gqOVwIjxjOZK/E80ftjWwnKowc7r0YtMPHPiifqZpUYKSdMtn8B1Q94T
   g==;
X-CSE-ConnectionGUID: xg863FvAQvCvl3enfUyLJA==
X-CSE-MsgGUID: Z18rpT7zTTa85BfG8eYMDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3265099"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3265099"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 07:13:46 -0800
X-CSE-ConnectionGUID: NnAzFCD3Snebr8kNNEt63A==
X-CSE-MsgGUID: vTEzr6eMT9ip09K3NG9ztg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9265418"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 13 Nov 2026 07:13:44 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRsyE-0000000136n-0ORl;
	Fri, 13 Nov 2026 15:13:42 +0000
Date: Fri, 13 Nov 2026 23:12:11 +0800
From: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>
Subject: [tytso-ext4:ext4-kunit-tests-merge 26/26]
 fs/ext4/xattr-test.c:1663:1: warning: the frame size of 2112 bytes is larger
 than 2048 bytes
Message-ID: <202611132233.Y7jJpjlY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext4-kunit-tests-merge
head:   dcc7bd2c6faf98be5a218685b4b969e95df06143
commit: dcc7bd2c6faf98be5a218685b4b969e95df06143 [26/26] Merge tag 'v7.4-rc2' into ext4-kunit-tests-merge
config: x86_64-rhel-9.4-kunit (https://download.01.org/0day-ci/archive/20261113/202611132233.Y7jJpjlY-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611132233.Y7jJpjlY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611132233.Y7jJpjlY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ext4/xattr-test.c: In function 'test_xattr_credits_usage_expand_and_delete':
>> fs/ext4/xattr-test.c:1663:1: warning: the frame size of 2112 bytes is larger than 2048 bytes [-Wframe-larger-than=]
    1663 | }
         | ^


vim +1663 fs/ext4/xattr-test.c

64b5dfde9364204 Theodore Ts'o 2026-11-05  1538  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1539  /*
64b5dfde9364204 Theodore Ts'o 2026-11-05  1540   * Test 10: ext4_get_inode_usage(), credit calculation, handle credit check,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1541   * ext4_expand_extra_isize_ea(), and ext4_xattr_delete_inode().
64b5dfde9364204 Theodore Ts'o 2026-11-05  1542   */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1543  static void test_xattr_credits_usage_expand_and_delete(struct kunit *test)
64b5dfde9364204 Theodore Ts'o 2026-11-05  1544  {
64b5dfde9364204 Theodore Ts'o 2026-11-05  1545  	struct xattr_test_ctx *ctx = test->priv;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1546  	struct inode *inode = &ctx->primary.ei.vfs_inode;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1547  	struct ext4_inode *raw = (struct ext4_inode *)ctx->primary.raw_buf;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1548  	journal_t fake_journal = {
64b5dfde9364204 Theodore Ts'o 2026-11-05  1549  		.j_revoke_records_per_block = 64,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1550  	};
64b5dfde9364204 Theodore Ts'o 2026-11-05  1551  	handle_t fake_handle = {
64b5dfde9364204 Theodore Ts'o 2026-11-05  1552  		.h_reserved = 1,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1553  		.h_journal = &fake_journal,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1554  		.h_total_credits = 1,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1555  	};
64b5dfde9364204 Theodore Ts'o 2026-11-05  1556  	const size_t large_len = 1000;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1557  	char *large_val;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1558  	char val28[28];
64b5dfde9364204 Theodore Ts'o 2026-11-05  1559  	char buf[64];
64b5dfde9364204 Theodore Ts'o 2026-11-05  1560  	qsize_t usage = 0;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1561  	int credits_create, credits_replace, credits_out = -1;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1562  	int ret;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1563  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1564  	large_val = kunit_kmalloc(test, large_len, GFP_KERNEL);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1565  	KUNIT_ASSERT_NOT_NULL(test, large_val);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1566  	memset(large_val, 'L', large_len);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1567  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1568  	/*
64b5dfde9364204 Theodore Ts'o 2026-11-05  1569  	 * 1. Credit calculation and insufficient handle credits check
64b5dfde9364204 Theodore Ts'o 2026-11-05  1570  	 */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1571  	credits_create = __ext4_xattr_set_credits(&ctx->sb, inode, NULL,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1572  						  100, true);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1573  	KUNIT_EXPECT_GT(test, credits_create, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1574  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1575  	ext4_set_feature_ea_inode(&ctx->sb);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1576  	credits_create = __ext4_xattr_set_credits(&ctx->sb, inode, NULL,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1577  						  1500, true);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1578  	credits_replace = __ext4_xattr_set_credits(&ctx->sb, inode, NULL,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1579  						   1500, false);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1580  	KUNIT_EXPECT_GT(test, credits_replace, credits_create);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1581  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1582  	/* Without a journal (s_journal == NULL), credits_out is 0 */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1583  	ret = ext4_xattr_set_credits(inode, 1500, true, &credits_out);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1584  	KUNIT_EXPECT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1585  	KUNIT_EXPECT_EQ(test, credits_out, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1586  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1587  	/* With s_journal set, ext4_xattr_set_credits() returns credits_create */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1588  	ctx->sbi.s_journal = &fake_journal;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1589  	ret = ext4_xattr_set_credits(inode, 1500, true, &credits_out);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1590  	ctx->sbi.s_journal = NULL;
64b5dfde9364204 Theodore Ts'o 2026-11-05  1591  	KUNIT_EXPECT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1592  	KUNIT_EXPECT_EQ(test, credits_out, credits_create);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1593  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1594  	/* Handle with only 1 buffer credit (< credits) fails with -ENOSPC */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1595  	ret = ext4_xattr_set_handle(&fake_handle, inode, EXT4_XATTR_INDEX_USER,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1596  				    "k", "v", 1, XATTR_CREATE);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1597  	KUNIT_EXPECT_EQ(test, ret, -ENOSPC);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1598  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1599  	/*
64b5dfde9364204 Theodore Ts'o 2026-11-05  1600  	 * 2. ext4_expand_extra_isize_ea():
64b5dfde9364204 Theodore Ts'o 2026-11-05  1601  	 * Put "keep" (4B -> 24B total) and "evict" (28B -> 52B total) in
64b5dfde9364204 Theodore Ts'o 2026-11-05  1602  	 * ibody (88B usable, leaving 12B free).
64b5dfde9364204 Theodore Ts'o 2026-11-05  1603  	 * First expand i_extra_isize from 32 -> 40 (8 bytes <= 12B free):
64b5dfde9364204 Theodore Ts'o 2026-11-05  1604  	 * shifts ibody entries in-place without allocating an external block.
64b5dfde9364204 Theodore Ts'o 2026-11-05  1605  	 * Then expand i_extra_isize from 40 -> 72 (32 bytes > 4B free):
64b5dfde9364204 Theodore Ts'o 2026-11-05  1606  	 * "keep" (24 + 4 = 28 < 32) is too small alone, so "evict" (52 + 4 >= 32)
64b5dfde9364204 Theodore Ts'o 2026-11-05  1607  	 * is moved to an external xattr block while "keep" stays in ibody!
64b5dfde9364204 Theodore Ts'o 2026-11-05  1608  	 */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1609  	ext4_clear_feature_ea_inode(&ctx->sb);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1610  	ret = ext4_xattr_set(inode, EXT4_XATTR_INDEX_USER, "keep",
64b5dfde9364204 Theodore Ts'o 2026-11-05  1611  			     "1234", 4, XATTR_CREATE);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1612  	KUNIT_ASSERT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1613  	memset(val28, 'E', sizeof(val28));
64b5dfde9364204 Theodore Ts'o 2026-11-05  1614  	ret = ext4_xattr_set(inode, EXT4_XATTR_INDEX_USER, "evict",
64b5dfde9364204 Theodore Ts'o 2026-11-05  1615  			     val28, sizeof(val28), XATTR_CREATE);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1616  	KUNIT_ASSERT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1617  	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_file_acl, 0ULL);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1618  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1619  	/* In-place ibody shift (32 -> 40) */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1620  	ret = ext4_expand_extra_isize_ea(inode, 40, raw, NULL);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1621  	KUNIT_ASSERT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1622  	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_extra_isize, (u16)40);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1623  	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_file_acl, 0ULL);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1624  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1625  	/* Eviction of "evict" to external block (40 -> 72) */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1626  	ret = ext4_expand_extra_isize_ea(inode, 72, raw, NULL);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1627  	KUNIT_ASSERT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1628  	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_extra_isize, (u16)72);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1629  	KUNIT_EXPECT_NE(test, EXT4_I(inode)->i_file_acl, 0ULL);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1630  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1631  	/* Both "keep" (in ibody) and "evict" (in external block) remain readable */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1632  	KUNIT_EXPECT_EQ(test,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1633  			ext4_xattr_ibody_get(inode, EXT4_XATTR_INDEX_USER,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1634  					     "keep", buf, sizeof(buf)),
64b5dfde9364204 Theodore Ts'o 2026-11-05  1635  			4);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1636  	KUNIT_EXPECT_EQ(test,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1637  			ext4_xattr_get(inode, EXT4_XATTR_INDEX_USER,
64b5dfde9364204 Theodore Ts'o 2026-11-05  1638  				       "evict", buf, sizeof(buf)),
64b5dfde9364204 Theodore Ts'o 2026-11-05  1639  			28);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1640  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1641  	/*
64b5dfde9364204 Theodore Ts'o 2026-11-05  1642  	 * 3. ext4_get_inode_usage() and ext4_xattr_delete_inode():
64b5dfde9364204 Theodore Ts'o 2026-11-05  1643  	 * Add a 1000-byte EA inode attribute ("large_ea") and check that
64b5dfde9364204 Theodore Ts'o 2026-11-05  1644  	 * ext4_get_inode_usage() accounts for 1 (parent inode) + 1 (EA inode)
64b5dfde9364204 Theodore Ts'o 2026-11-05  1645  	 * = 2 inodes, and ext4_xattr_delete_inode() frees the external block
64b5dfde9364204 Theodore Ts'o 2026-11-05  1646  	 * and drops the EA inode reference to 0.
64b5dfde9364204 Theodore Ts'o 2026-11-05  1647  	 */
64b5dfde9364204 Theodore Ts'o 2026-11-05  1648  	ext4_set_feature_ea_inode(&ctx->sb);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1649  	ret = ext4_xattr_set(inode, EXT4_XATTR_INDEX_USER, "large_ea",
64b5dfde9364204 Theodore Ts'o 2026-11-05  1650  			     large_val, large_len, XATTR_CREATE);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1651  	KUNIT_ASSERT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1652  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1653  	down_read(&EXT4_I(inode)->xattr_sem);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1654  	ret = ext4_get_inode_usage(inode, &usage);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1655  	up_read(&EXT4_I(inode)->xattr_sem);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1656  	KUNIT_ASSERT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1657  	KUNIT_EXPECT_EQ(test, usage, (qsize_t)2);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1658  
64b5dfde9364204 Theodore Ts'o 2026-11-05  1659  	ret = ext4_xattr_delete_inode(NULL, inode, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1660  	KUNIT_ASSERT_EQ(test, ret, 0);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1661  	KUNIT_EXPECT_EQ(test, EXT4_I(inode)->i_file_acl, 0ULL);
64b5dfde9364204 Theodore Ts'o 2026-11-05  1662  	KUNIT_EXPECT_EQ(test, ctx->ea_inodes[0].ei.vfs_inode.i_nlink, 0U);
64b5dfde9364204 Theodore Ts'o 2026-11-05 @1663  }
64b5dfde9364204 Theodore Ts'o 2026-11-05  1664  

:::::: The code at line 1663 was first introduced by commit
:::::: 64b5dfde9364204d0284d8800174ba8bb23d963f ext4: add KUnit tests for fs/ext4/xattr.c

:::::: TO: Theodore Ts'o <tytso@mit.edu>
:::::: CC: Theodore Ts'o <tytso@mit.edu>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
