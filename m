Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586113;
	b=p2Jsx1cPHR4WMQzOpqCzZ9zip+ArZpXnjEGlnS5fY0KYBHdi96ge3hopdqSfX08pkKSN
	 2s/3DT57yaYrjf+8t2NGcahAAeJK9RAFsAVTxTf17OSgmcSQhz8jq8NzIpaSYLWNjgfY6
	 0Rnl4KkQOY/V0Gq6MMvWHgHIH9xqtzK0RpUUUpLF88/mr+Dii68PWGqZfKim3ZB+KUZNL
	 Xbyfe2oV7KK4aecm1FIIee/X3IWeNrLyTWbf1Pt3iijosolIup8aIP374HoJofbsxxzde
	 43Duvpob3jA0lDAN5I5peU2AURkB6Kcafvw5RZ+NntUPh3Pxu+LEABNy3nGpOJHDtJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586113;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=EDdssnUz7cYEnU39VyJG+RI1tHJSlahm2aFijqeuv5k=;
	b=ccBSMHsJ4405bxZyQIL/XhUuOGRkczcB5qDn95QBdQUAIevluEcl4mLFQawSZb9cjsun
	 FSz7CPbYz1XVs9VXyy3Hy19WyqvcyNdED8LhnUzci1w+cpvd1L46uvmgwlHLvx68xlrEV
	 f9mX1fwot6XbP3hgW6L39Rh0iRwonnzZTziYdOdn/RVfM2esUhaamECtua62vIsrnB7Ms
	 DkRZOPO7CwOZdvPNznOeR5XDEaLjh9rAvRbHhG7rqVWdwFClTQjSHIQmxAWRTb2jMVerV
	 UJ4puyTuhC8psZWCmO6tkCTTvM0QEnrhbV+y6mxJE5EANzkbGA0pDMLwbCjtIopF6wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TPcrau+h;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B16606A332
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 16:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55B16606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TPcrau+h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794586114; x=1826122114;
  h=date:from:to:cc:subject:message-id;
  bh=VDWPkvypHirzwuQA0Zvwf0QkORxXF+OUttWZCuXcNwc=;
  b=TPcrau+hCSgGK8Bpa6XsDMWf8l3SuCvuYvmJRHSkOLJiok9QAKdZvXH8
   2sxHFfu6NEGWjTeM2uPC/mc9t/H/bJcwsZIzKYgIuGkl6N1JlfU5TekpY
   882q6xTiu8PaasOqM0eMzr3hT72sB+xefESQpvXWKFl3mUosf5DFqjnsB
   1X7r00YuRV8EMarfSbsgmP2qLAwW1xZix1QzhhLyBNSOsmn0ctYC7X02a
   Qb2SEcoQsvER8qAr0RdCt9ETMXULTCnAq6syLxjpBETkMN5rBhJG1IS1U
   fFMCwaRP/JVPvu7K8g8zVaIFx0IxhIZcKCwXLinys8xADklmVV+mrOp/4
   w==;
X-CSE-ConnectionGUID: 5CWIEqPzQQu3lD9MmSdztQ==
X-CSE-MsgGUID: Ztx3pB7/TXKMAjWsLvJW8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3426891"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3426891"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 08:08:33 -0800
X-CSE-ConnectionGUID: k8XKgO0XS+yrfHdmmmI/yQ==
X-CSE-MsgGUID: uZQFKuRKRzeqcasQhbniNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9117385"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 13 Nov 2026 08:08:31 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRtpE-000000013Dt-3hK5;
	Fri, 13 Nov 2026 16:08:28 +0000
Date: Sat, 14 Nov 2026 00:07:39 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 9/50] fs/ext4/fast_commit-test.c:1145:1:
 warning: the frame size of 1476 bytes is larger than 1280 bytes
Message-ID: <202611132301.FRexPvKk-lkp@intel.com>
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
commit: 781558b8eddee2d9384ea3f0ed4901b8b329cb24 [9/50] ext4: add KUnit tests for fs/ext4/fast_commit.c
config: csky-allmodconfig (https://download.01.org/0day-ci/archive/20261113/202611132301.FRexPvKk-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611132301.FRexPvKk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611132301.FRexPvKk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ext4/fast_commit-test.c: In function 'test_fc_init_and_eligibility':
>> fs/ext4/fast_commit-test.c:1145:1: warning: the frame size of 1476 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    1145 | }
         | ^


vim +1145 fs/ext4/fast_commit-test.c

  1067	
  1068	/* =========================================================================
  1069	 * 1. Initialization, Eligibility, and Snapshot Stat Helpers
  1070	 * =========================================================================
  1071	 */
  1072	
  1073	static void test_fc_init_and_eligibility(struct kunit *test)
  1074	{
  1075		struct fc_test_ctx *ctx = test->priv;
  1076		struct super_block *sb = ctx->sb;
  1077		struct inode *inode = get_mock_inode(ctx, TEST_FILE1_INO);
  1078		struct ext4_inode_info *ei = EXT4_I(inode);
  1079		journal_t tmp_journal = {};
  1080		atomic64_t max_stat = ATOMIC64_INIT(0);
  1081		int snap_err = EXT4_FC_SNAP_ERR_NONE;
  1082	
  1083		/*
  1084		 * 1) ext4_fc_init sets j_fc_replay_callback unconditionally, but sets
  1085		 *    j_fc_cleanup_callback only when JOURNAL_FAST_COMMIT is enabled.
  1086		 */
  1087		clear_opt2(sb, JOURNAL_FAST_COMMIT);
  1088		ext4_fc_init(sb, &tmp_journal);
  1089		KUNIT_EXPECT_NOT_NULL(test, tmp_journal.j_fc_replay_callback);
  1090		KUNIT_EXPECT_NULL(test, tmp_journal.j_fc_cleanup_callback);
  1091	
  1092		set_opt2(sb, JOURNAL_FAST_COMMIT);
  1093		ext4_fc_init(sb, &tmp_journal);
  1094		KUNIT_EXPECT_NOT_NULL(test, tmp_journal.j_fc_replay_callback);
  1095		KUNIT_EXPECT_NOT_NULL(test, tmp_journal.j_fc_cleanup_callback);
  1096	
  1097		/* 2) ext4_fc_init_inode clears state and resets ranges */
  1098		ei->i_fc_lblk_start = 42;
  1099		ei->i_fc_lblk_len = 10;
  1100		ext4_set_inode_state(inode, EXT4_STATE_FC_COMMITTING);
  1101		ext4_set_inode_state(inode, EXT4_STATE_FC_REQUEUE);
  1102		ext4_fc_init_inode(inode);
  1103		KUNIT_EXPECT_EQ(test, ei->i_fc_lblk_start, 0U);
  1104		KUNIT_EXPECT_EQ(test, ei->i_fc_lblk_len, 0U);
  1105		KUNIT_EXPECT_FALSE(test,
  1106				   ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING));
  1107		KUNIT_EXPECT_FALSE(test,
  1108				   ext4_test_inode_state(inode, EXT4_STATE_FC_REQUEUE));
  1109		KUNIT_EXPECT_TRUE(test, list_empty(&ei->i_fc_list));
  1110		KUNIT_EXPECT_TRUE(test, list_empty(&ei->i_fc_dilist));
  1111		KUNIT_EXPECT_NULL(test, ei->i_fc_snap);
  1112	
  1113		/* 3) ext4_fc_disabled and ext4_fc_eligible transitions */
  1114		KUNIT_EXPECT_FALSE(test, ext4_fc_disabled_test(sb));
  1115		KUNIT_EXPECT_TRUE(test, ext4_fc_eligible_test(sb));
  1116	
  1117		ctx->sbi->s_mount_state |= EXT4_FC_REPLAY;
  1118		KUNIT_EXPECT_TRUE(test, ext4_fc_disabled_test(sb));
  1119		KUNIT_EXPECT_FALSE(test, ext4_fc_eligible_test(sb));
  1120		ctx->sbi->s_mount_state &= ~EXT4_FC_REPLAY;
  1121	
  1122		ext4_set_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
  1123		KUNIT_EXPECT_FALSE(test, ext4_fc_disabled_test(sb));
  1124		KUNIT_EXPECT_FALSE(test, ext4_fc_eligible_test(sb));
  1125		ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
  1126	
  1127		clear_opt2(sb, JOURNAL_FAST_COMMIT);
  1128		KUNIT_EXPECT_TRUE(test, ext4_fc_disabled_test(sb));
  1129		KUNIT_EXPECT_FALSE(test, ext4_fc_eligible_test(sb));
  1130		set_opt2(sb, JOURNAL_FAST_COMMIT);
  1131	
  1132		/* 4) ext4_fc_set_snap_err preserves first error */
  1133		ext4_fc_set_snap_err_test(&snap_err, EXT4_FC_SNAP_ERR_ES_MISS);
  1134		KUNIT_EXPECT_EQ(test, snap_err, (int)EXT4_FC_SNAP_ERR_ES_MISS);
  1135		ext4_fc_set_snap_err_test(&snap_err, EXT4_FC_SNAP_ERR_NOMEM);
  1136		KUNIT_EXPECT_EQ(test, snap_err, (int)EXT4_FC_SNAP_ERR_ES_MISS);
  1137	
  1138		/* 5) ext4_fc_snap_stats_update_max monotonically updates max */
  1139		ext4_fc_snap_stats_update_max_test(&max_stat, 100);
  1140		KUNIT_EXPECT_EQ(test, atomic64_read(&max_stat), 100LL);
  1141		ext4_fc_snap_stats_update_max_test(&max_stat, 50);
  1142		KUNIT_EXPECT_EQ(test, atomic64_read(&max_stat), 100LL);
  1143		ext4_fc_snap_stats_update_max_test(&max_stat, 250);
  1144		KUNIT_EXPECT_EQ(test, atomic64_read(&max_stat), 250LL);
> 1145	}
  1146	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
