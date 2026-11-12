Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491993;
	b=wDmO97yxN4aXFrQz95tfi/Ruy/ZO3d6CM+8zmPoqtSM0kP3dc3RPbUE9Ah3BYktYrR99
	 7cTQpc3bhaeszIJorOLsFlp3LX2ezvIH3f/UG4UrSyzQUJangfrGsszzdiKeXUhY9HYnS
	 EaBIz9MXIfGvBM28s5MAWy92oO7UNAF7nZ6ufeLgqzjnPVWs0xL5fKZtcDwmiurMGcltd
	 s5E3iVB3oOaI0ASxvXZ3qt+m5vEfBFX50Fi1vFljNLqc/RpPtr31iLwAJSAW42BnpwJcs
	 9lg4ndESXriQPeiUvFVSokSW6+yyi6yUuICP8XS9UMaSdft4KQykk+BEYhg310Cq8+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491993;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=sXMon5ptlVBDPOtcDHNO53xu0lbZNgWaEvakWp58sJw=;
	b=MVF9aS8gYWPXpU2RdkLHBEgrTXE52/iKlT8ff7M0T9GAG2FGWyetJDFB9sUhPSoX0oNH
	 D4uGx2JJAeguZEyxkTwK5ju7pZYihWUrHNHeWX8VLMuaQC0SkLyfsGkM6Pov64UY+/8YZ
	 rweenI1teA5vJVTpm4UvNGHIcY6ZCZpLFN+2KdnQQU+63WK8d61Y1E7Lk5zJegyi/FM0g
	 MsyuvaE5r3kq1oz2pGWI4AsZjooaYTWY8snr20y3W+t9a3GQrl8yeK6mjlp8QyB7CF7Kw
	 izXsdYRhYbzPSZF8yN1XBjyaUuUzHGPn1wYyVGwer1cpackuldoxGd5iAyw8BEsQnOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DvkxDeiG;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F85B606A32E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 13:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F85B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DvkxDeiG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794491992; x=1826027992;
  h=date:from:to:cc:subject:message-id;
  bh=jXKAhNTHnDtiyKDD6ukmiQ5mcE6FuLY9tDVcUgQiHyE=;
  b=DvkxDeiGJDLEYJuXwQQX7c8kkGh8CwXkJzq3T/P6ULm08MLYrLqZbAhv
   QTM4brEyN3fakYyPka2igl3VgrVCs3uX7NkIdpNh5XlUfSrhK1ckGNpKh
   guSQxviO+XXZV4IFAAdsBMBD3ZNrdVAwb9cy+DGHckiMP9OvZGSoLo1OZ
   Z/nmn0l88BCLcacMw8IPr1/zbXQZrhehoDXTSeY2HDb4J0d5hh6vog+pb
   bt6tAoqKoT1ZDeYi6fN6AFyBNsTrkQCZRTmmHPOYtwm6z7jG+VOYKVkgb
   aoZYtc1C+J9loj7eywe7hD0Ncvod0t0kx7VQ+tn5d9TS1Yi2lzq9V5fD+
   g==;
X-CSE-ConnectionGUID: uCWxIpzaTYi3iXbal8BSSw==
X-CSE-MsgGUID: MV+BxbnARQ6TH3iLEGqQ8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3285405"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3285405"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 05:59:52 -0800
X-CSE-ConnectionGUID: daz4IbiHQHiJxVWWc8fPgA==
X-CSE-MsgGUID: QLtnzx+XSf2tQPwXnzDlgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="9230133"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 12 Nov 2026 05:59:51 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRVLA-000000000tH-1JtV;
	Thu, 12 Nov 2026 13:59:48 +0000
Date: Thu, 12 Nov 2026 14:59:24 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 4/50] fs/ext4/xattr-test.c:854:9: sparse:
 sparse: incorrect type in initializer (different base types)
Message-ID: <202611121411.rRCBX7mS-lkp@intel.com>
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
config: m68k-randconfig-r2311-20261112 (https://download.01.org/0day-ci/archive/20261112/202611121411.rRCBX7mS-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261112/202611121411.rRCBX7mS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611121411.rRCBX7mS-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/ext4/xattr-test.c:854:9: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long left_value @@     got restricted __le32 const __left @@
   fs/ext4/xattr-test.c:854:9: sparse:     expected long long left_value
   fs/ext4/xattr-test.c:854:9: sparse:     got restricted __le32 const __left
>> fs/ext4/xattr-test.c:854:9: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long right_value @@     got restricted __le32 const __right @@
   fs/ext4/xattr-test.c:854:9: sparse:     expected long long right_value
   fs/ext4/xattr-test.c:854:9: sparse:     got restricted __le32 const __right
   fs/ext4/xattr-test.c:999:9: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long left_value @@     got restricted __le32 const __left @@
   fs/ext4/xattr-test.c:999:9: sparse:     expected long long left_value
   fs/ext4/xattr-test.c:999:9: sparse:     got restricted __le32 const __left
   fs/ext4/xattr-test.c:999:9: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long right_value @@     got restricted __le32 const __right @@
   fs/ext4/xattr-test.c:999:9: sparse:     expected long long right_value
   fs/ext4/xattr-test.c:999:9: sparse:     got restricted __le32 const __right

vim +854 fs/ext4/xattr-test.c

   784	
   785	/*
   786	 * Test 3: In-inode (ibody) get/set, flags validation, EXT4_STATE_NEW handling,
   787	 * superblock feature update, and identical-value fastpath.
   788	 */
   789	static void test_xattr_ibody_basic_and_flags(struct kunit *test)
   790	{
   791		struct xattr_test_ctx *ctx = test->priv;
   792		struct inode *inode = &ctx->primary.ei.vfs_inode;
   793		struct ext4_inode *raw_inode = (struct ext4_inode *)ctx->primary.raw_buf;
   794		char long_name[260];
   795		char buf[32];
   796		unsigned int prev_dirty;
   797		int ret;
   798	
   799		/* Fresh inode without EXT4_STATE_XATTR returns -ENODATA */
   800		ret = ext4_xattr_get(inode, EXT4_XATTR_INDEX_USER, "missing",
   801				     buf, sizeof(buf));
   802		KUNIT_EXPECT_EQ(test, ret, -ENODATA);
   803	
   804		/* Parameter validation: NULL name -> -EINVAL, >255 name -> -ERANGE */
   805		ret = ext4_xattr_set_handle(NULL, inode, EXT4_XATTR_INDEX_USER,
   806					    NULL, "v", 1, 0);
   807		KUNIT_EXPECT_EQ(test, ret, -EINVAL);
   808	
   809		memset(long_name, 'x', sizeof(long_name) - 1);
   810		long_name[sizeof(long_name) - 1] = '\0';
   811		ret = ext4_xattr_set_handle(NULL, inode, EXT4_XATTR_INDEX_USER,
   812					    long_name, "v", 1, 0);
   813		KUNIT_EXPECT_EQ(test, ret, -ERANGE);
   814	
   815		/* Forced shutdown check on get and set */
   816		set_bit(EXT4_FLAGS_SHUTDOWN, &ctx->sbi.s_ext4_flags);
   817		KUNIT_EXPECT_EQ(test,
   818				ext4_xattr_get(inode, EXT4_XATTR_INDEX_USER, "k",
   819					       buf, sizeof(buf)),
   820				-EIO);
   821		KUNIT_EXPECT_EQ(test,
   822				ext4_xattr_set_handle(NULL, inode,
   823						      EXT4_XATTR_INDEX_USER, "k",
   824						      "v", 1, 0),
   825				-EIO);
   826		clear_bit(EXT4_FLAGS_SHUTDOWN, &ctx->sbi.s_ext4_flags);
   827	
   828		/* XATTR_REPLACE on non-existent attribute returns -ENODATA */
   829		ret = ext4_xattr_set_handle(NULL, inode, EXT4_XATTR_INDEX_USER,
   830					    "no_such", "val", 3, XATTR_REPLACE);
   831		KUNIT_EXPECT_EQ(test, ret, -ENODATA);
   832	
   833		/* Deleting non-existent attribute without XATTR_REPLACE succeeds (0) */
   834		ret = ext4_xattr_set_handle(NULL, inode, EXT4_XATTR_INDEX_USER,
   835					    "no_such", NULL, 0, 0);
   836		KUNIT_EXPECT_EQ(test, ret, 0);
   837	
   838		/*
   839		 * Verify EXT4_STATE_NEW causes ext4_xattr_set_handle() to zero the raw
   840		 * inode and clear EXT4_STATE_NEW.
   841		 */
   842		memset(raw_inode, 0x5a, TEST_INODE_SIZE);
   843		ext4_set_inode_state(inode, EXT4_STATE_NEW);
   844		KUNIT_EXPECT_FALSE(test,
   845				   ext4_has_feature_xattr(&ctx->sb));
   846	
   847		ret = ext4_xattr_set_handle(NULL, inode, EXT4_XATTR_INDEX_USER,
   848					    "key1", "hello", 5, XATTR_CREATE);
   849		KUNIT_ASSERT_EQ(test, ret, 0);
   850		KUNIT_EXPECT_EQ(test,
   851				ext4_test_inode_state(inode, EXT4_STATE_NEW), 0);
   852		KUNIT_EXPECT_NE(test,
   853				ext4_test_inode_state(inode, EXT4_STATE_XATTR), 0);
 > 854		KUNIT_EXPECT_EQ(test, IHDR(inode, raw_inode)->h_magic,
   855				cpu_to_le32(EXT4_XATTR_MAGIC));
   856		/* Setting first xattr enables EXT4_FEATURE_COMPAT_EXT_ATTR on sb */
   857		KUNIT_EXPECT_TRUE(test, ext4_has_feature_xattr(&ctx->sb));
   858	
   859		/* XATTR_CREATE on existing attribute returns -EEXIST */
   860		ret = ext4_xattr_set_handle(NULL, inode, EXT4_XATTR_INDEX_USER,
   861					    "key1", "other", 5, XATTR_CREATE);
   862		KUNIT_EXPECT_EQ(test, ret, -EEXIST);
   863	
   864		/* Query length (NULL buffer), too small buffer (-ERANGE), and read */
   865		ret = ext4_xattr_get(inode, EXT4_XATTR_INDEX_USER, "key1", NULL, 0);
   866		KUNIT_EXPECT_EQ(test, ret, 5);
   867	
   868		ret = ext4_xattr_get(inode, EXT4_XATTR_INDEX_USER, "key1", buf, 4);
   869		KUNIT_EXPECT_EQ(test, ret, -ERANGE);
   870	
   871		memset(buf, 0, sizeof(buf));
   872		ret = ext4_xattr_get(inode, EXT4_XATTR_INDEX_USER, "key1",
   873				     buf, sizeof(buf));
   874		KUNIT_EXPECT_EQ(test, ret, 5);
   875		KUNIT_EXPECT_MEMEQ(test, buf, "hello", 5);
   876	
   877		/* Direct ext4_xattr_ibody_get() check */
   878		memset(buf, 0, sizeof(buf));
   879		ret = ext4_xattr_ibody_get(inode, EXT4_XATTR_INDEX_USER, "key1",
   880					   buf, sizeof(buf));
   881		KUNIT_EXPECT_EQ(test, ret, 5);
   882		KUNIT_EXPECT_MEMEQ(test, buf, "hello", 5);
   883	
   884		/*
   885		 * Setting the exact same value triggers the ext4_xattr_value_same()
   886		 * fastpath and skips dirtying the inode location.
   887		 */
   888		prev_dirty = ctx->mark_iloc_dirty_calls;
   889		ret = ext4_xattr_set_handle(NULL, inode, EXT4_XATTR_INDEX_USER,
   890					    "key1", "hello", 5, XATTR_REPLACE);
   891		KUNIT_EXPECT_EQ(test, ret, 0);
   892		KUNIT_EXPECT_EQ(test, ctx->mark_iloc_dirty_calls, prev_dirty);
   893	}
   894	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
