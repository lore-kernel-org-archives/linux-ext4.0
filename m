Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491331;
	b=Hib26MiYIclaNdY3NiL9plgtGqsDEz608roQYTX+EY66BSMs/FyCVPyUch1EVFJ2qDky
	 83hOGN2NswKFF6/eYtCUTNysUcw9h8bkn0DeNAqklQboGkr94L1YM3V7GJA3xAZ3Z/u8S
	 oCV35P6fyuWp82vmy8vtKhV8gXc1AEYhv5DQCfWJNThz3VlzI5Ko1Eb9sFIBRh7sQbyB9
	 WFoXBcT8ij2vv46DRm29i6CjhquDg/xY614LBi05mWSCb2ibI+okv0xp2j7OAFFlFnhGD
	 tMdNab/Ht8ytfIJE/4dQT1S+pDk7WRCOWOZk3fp72O/DUwe6+bvquYS4RLDjvwxcSzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491331;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=FhLHD+aursl9S7rg8JY7lsFF78TbfiMCMHRpNez3BFw=;
	b=W/wWUYaKHkLISrXWpWb2Qc7AwK6rSJxfjqFGkE03oNcXx/uz/aanzELHSFbTYIGkVGlK
	 YDE1Pvas00Z8ms2+g8S6FT6ESw9EwnOa4If30IRL6ybhbICw2cBua/j8pPRjGxbCaYPlS
	 KRVX+1oYH16N9Kw9O53W0rEomTfjvAlsXDSrXYstCesA9rL8EQDVdABt5XNaRMLZXXfkM
	 310CTN6tRsA6GHoN/IYqcD8rLen0D0xCJFYCsQl0Fa4QynlzETTBm9EAezq964jp8RMO3
	 lqawqIck/W/6fwRtci7S1a+egIC7AWoorj0Cro42T7qwDN1jMXBBksFONiuyA8+fnyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZBD8adyR;
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5CD606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 13:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A5CD606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZBD8adyR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794491330; x=1826027330;
  h=date:from:to:cc:subject:message-id;
  bh=KEHMJvRNWkXH373wKpVpi8GGf2Sm+0uRF3Mz65Gvh+w=;
  b=ZBD8adyRHOwfBYJ4CRPk1iLavPW7VLbe8oXRlBhwNfqv1thGHInluBob
   R+MhfMIFQ5b8qvYQ/XrX1HLUWRHQG6e5kNzwkr/HzyarCM/Ec4sdIPZeA
   EYZwJB26aLaAglpNQYD846qvhM4Xy2nHvtVZqY89cEEO0dQuHzF5Eva1h
   AvHe2IwOoxZZo1LIoiYZMM5M4c0eB1dhDklQhiQXpb8FXj5UYgUIxWCKv
   U3/Xj/+v/T8eficbV6vFN/PdBYpzmu+jipA9I3FHXzLYR8d2urLDni7E2
   L348yitobnUlM3qgPVOaf1tJFFwLAx+KSbsRyv/lZeFx/8EeghyUdmsb9
   g==;
X-CSE-ConnectionGUID: RrHrI5N5QWygmo7PNZ+PyA==
X-CSE-MsgGUID: jSJkNnhgQemtAWvfLJUPSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3187688"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3187688"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 05:48:50 -0800
X-CSE-ConnectionGUID: xjE0oVBIRe6hbdVZC4BalQ==
X-CSE-MsgGUID: LjnGeu1/QpWpODDaiwWbHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="8994344"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 12 Nov 2026 05:48:49 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRVAU-000000000t4-0mjV;
	Thu, 12 Nov 2026 13:48:46 +0000
Date: Thu, 12 Nov 2026 14:48:32 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 21/50] fs/ext4/migrate-test.c:462:9: sparse:
 sparse: incompatible types in comparison expression (different base types):
Message-ID: <202611121426.SgPY0H6k-lkp@intel.com>
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
commit: dd357969500928cd46fd524d98194afaaeb18d0b [21/50] ext4: add KUnit tests for fs/ext4/migrate.c
config: s390-randconfig-r2305-20261112 (https://download.01.org/0day-ci/archive/20261112/202611121426.SgPY0H6k-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261112/202611121426.SgPY0H6k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611121426.SgPY0H6k-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/ext4/migrate-test.c:462:9: sparse: sparse: incompatible types in comparison expression (different base types):
   fs/ext4/migrate-test.c:462:9: sparse:    struct disk_stats [noderef] __percpu *
   fs/ext4/migrate-test.c:462:9: sparse:    void *
   fs/ext4/migrate-test.c:711:9: sparse: sparse: restricted __le16 degrades to integer
   fs/ext4/migrate-test.c:711:9: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long right_value @@     got restricted __le16 const __right @@
   fs/ext4/migrate-test.c:947:17: sparse: sparse: restricted __le32 degrades to integer
   fs/ext4/migrate-test.c:947:17: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long left_value @@     got restricted __le32 const __left @@
   fs/ext4/migrate-test.c:969:17: sparse: sparse: restricted __le32 degrades to integer
   fs/ext4/migrate-test.c:969:17: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long left_value @@     got restricted __le32 const __left @@
   fs/ext4/migrate-test.c:974:17: sparse: sparse: restricted __le32 degrades to integer
   fs/ext4/migrate-test.c:974:17: sparse: sparse: incorrect type in initializer (different base types) @@     expected long long left_value @@     got restricted __le32 const __left @@
   fs/ext4/migrate-test.c: note: in included file:
   fs/ext4/ext4.h:3708:33: sparse: sparse: cast truncates bits from constant value (100000063 becomes 63)

vim +462 fs/ext4/migrate-test.c

   443	
   444	static int migrate_test_init(struct kunit *test)
   445	{
   446		struct migrate_test_ctx *ctx;
   447		struct fs_context *fc;
   448		struct super_block *sb;
   449		struct ext4_sb_info *sbi;
   450		struct buffer_head *sbh;
   451		struct inode *root_inode;
   452		int ret;
   453	
   454		ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
   455		KUNIT_ASSERT_NOT_NULL(test, ctx);
   456		INIT_LIST_HEAD(&ctx->blks);
   457		ctx->device_blocks = MIGRATE_TEST_TOTAL_BLKS;
   458		ctx->next_alloc_pblk = 900;
   459		test->priv = ctx;
   460	
   461		ctx->bdev.bd_stats = alloc_percpu(struct disk_stats);
 > 462		KUNIT_ASSERT_NOT_NULL(test, ctx->bdev.bd_stats);
   463	
   464		ctx->bh_folio = folio_alloc(GFP_KERNEL, 0);
   465		if (!ctx->bh_folio) {
   466			free_percpu(ctx->bdev.bd_stats);
   467			ctx->bdev.bd_stats = NULL;
   468			KUNIT_FAIL_AND_ABORT(test, "folio_alloc failed");
   469		}
   470	
   471		fc = fs_context_for_mount(&migrate_test_fs_type, 0);
   472		if (IS_ERR(fc)) {
   473			folio_put(ctx->bh_folio);
   474			ctx->bh_folio = NULL;
   475			free_percpu(ctx->bdev.bd_stats);
   476			ctx->bdev.bd_stats = NULL;
   477			KUNIT_FAIL_AND_ABORT(test, "fs_context_for_mount failed: %ld",
   478					     PTR_ERR(fc));
   479		}
   480		sb = sget_fc(fc, NULL, migrate_test_set_super);
   481		put_fs_context(fc);
   482		if (IS_ERR(sb)) {
   483			folio_put(ctx->bh_folio);
   484			ctx->bh_folio = NULL;
   485			free_percpu(ctx->bdev.bd_stats);
   486			ctx->bdev.bd_stats = NULL;
   487			KUNIT_FAIL_AND_ABORT(test, "sget_fc failed: %ld", PTR_ERR(sb));
   488		}
   489		ctx->sb = sb;
   490		up_write(&sb->s_umount);
   491	
   492		ret = kunit_add_action_or_reset(test, migrate_test_cleanup_action, ctx);
   493		KUNIT_ASSERT_EQ(test, ret, 0);
   494	
   495		sbi = &ctx->sbi;
   496		sb->s_fs_info = sbi;
   497		sb->s_op = &migrate_test_sops;
   498		sb->s_flags |= SB_ACTIVE;
   499		sb->s_blocksize = MIGRATE_TEST_BLK_SIZE;
   500		sb->s_blocksize_bits = MIGRATE_TEST_BLK_BITS;
   501		sb->s_magic = EXT4_SUPER_MAGIC;
   502		sb->s_maxbytes = MAX_LFS_FILESIZE;
   503		INIT_LIST_HEAD(&sb->s_inodes);
   504	#ifdef CONFIG_FS_ENCRYPTION
   505		sb->s_cop = &ext4_cryptops;
   506	#endif
   507	
   508		strscpy(sb->s_id, "ext4_migrate_kunit", sizeof(sb->s_id));
   509		inode_init_once(&ctx->bd_inode);
   510		ctx->bd_inode.i_sb = sb;
   511		ctx->bd_inode.i_blkbits = MIGRATE_TEST_BLK_BITS;
   512		ctx->bd_inode.i_mapping = &ctx->bd_inode.i_data;
   513		ctx->bd_inode.i_data.host = &ctx->bd_inode;
   514		ctx->bdev_disk.part0 = &ctx->bdev;
   515		ctx->bdev_disk.queue = &ctx->bdev_queue;
   516		ctx->bdev.bd_disk = &ctx->bdev_disk;
   517		ctx->bdev.bd_queue = &ctx->bdev_queue;
   518		ctx->bdev.bd_mapping = &ctx->bd_inode.i_data;
   519		bdev_clear_flag(&ctx->bdev, BD_READ_ONLY);
   520		sb->s_bdev = &ctx->bdev;
   521	
   522		sbi->s_sb = sb;
   523		sbi->s_blockgroup_lock = &ctx->bgl;
   524		bgl_lock_init(&ctx->bgl);
   525		INIT_WORK(&sbi->s_sb_upd_work, migrate_test_sb_upd_work);
   526		timer_setup(&sbi->s_err_report, migrate_test_err_timer, 0);
   527		spin_lock_init(&sbi->s_error_lock);
   528		spin_lock_init(&sbi->s_md_lock);
   529		spin_lock_init(&sbi->s_bdev_wb_lock);
   530		spin_lock_init(&sbi->s_es_lock);
   531		INIT_LIST_HEAD(&sbi->s_es_list);
   532		mutex_init(&sbi->s_fc_lock);
   533		INIT_LIST_HEAD(&sbi->s_fc_q[FC_Q_MAIN]);
   534		INIT_LIST_HEAD(&sbi->s_fc_q[FC_Q_STAGING]);
   535		INIT_LIST_HEAD(&sbi->s_fc_dentry_q[FC_Q_MAIN]);
   536		INIT_LIST_HEAD(&sbi->s_fc_dentry_q[FC_Q_STAGING]);
   537		ratelimit_state_init(&sbi->s_err_ratelimit_state, 5 * HZ, 10);
   538		ratelimit_state_init(&sbi->s_warning_ratelimit_state, 5 * HZ, 10);
   539		ratelimit_state_init(&sbi->s_msg_ratelimit_state, 5 * HZ, 10);
   540	
   541		ret = percpu_init_rwsem(&sbi->s_writepages_rwsem);
   542		KUNIT_ASSERT_EQ(test, ret, 0);
   543		ctx->rwsem_inited = true;
   544	
   545		ret = percpu_counter_init(&sbi->s_freeclusters_counter, 4096,
   546					  GFP_KERNEL);
   547		KUNIT_ASSERT_EQ(test, ret, 0);
   548		ret = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0, GFP_KERNEL);
   549		KUNIT_ASSERT_EQ(test, ret, 0);
   550		ret = percpu_counter_init(&sbi->s_freeinodes_counter, 200, GFP_KERNEL);
   551		KUNIT_ASSERT_EQ(test, ret, 0);
   552		ctx->counters_inited = true;
   553	
   554		ret = ext4_es_register_shrinker(sbi);
   555		KUNIT_ASSERT_EQ(test, ret, 0);
   556		ctx->es_shrinker_inited = true;
   557	
   558		sbi->s_blocks_per_group = MIGRATE_TEST_BLOCKS_PER_GRP;
   559		sbi->s_clusters_per_group = MIGRATE_TEST_BLOCKS_PER_GRP;
   560		sbi->s_cluster_ratio = 1;
   561		sbi->s_cluster_bits = 0;
   562		sbi->s_groups_count = MIGRATE_TEST_NGROUPS;
   563		sbi->s_inodes_per_group = MIGRATE_TEST_INODES_PER_GRP;
   564		sbi->s_inode_size = MIGRATE_TEST_INODE_SIZE;
   565		sbi->s_inodes_per_block = MIGRATE_TEST_BLK_SIZE /
   566					  MIGRATE_TEST_INODE_SIZE;
   567		sbi->s_first_ino = 11;
   568		sbi->s_mount_state = EXT4_VALID_FS;
   569		set_opt(sb, ERRORS_CONT);
   570	
   571		sbh = migrate_get_or_create_bh(ctx, MIGRATE_TEST_FIRST_DATA_BLK);
   572		KUNIT_ASSERT_NOT_NULL(test, sbh);
   573		brelse(sbh);
   574		sbi->s_sbh = sbh;
   575		ctx->es = (struct ext4_super_block *)sbh->b_data;
   576		sbi->s_es = ctx->es;
   577	
   578		ctx->es->s_magic = cpu_to_le16(EXT4_SUPER_MAGIC);
   579		ctx->es->s_rev_level = cpu_to_le32(EXT4_DYNAMIC_REV);
   580		ctx->es->s_first_data_block = cpu_to_le32(MIGRATE_TEST_FIRST_DATA_BLK);
   581		ctx->es->s_blocks_per_group = cpu_to_le32(MIGRATE_TEST_BLOCKS_PER_GRP);
   582		ctx->es->s_clusters_per_group =
   583			cpu_to_le32(MIGRATE_TEST_BLOCKS_PER_GRP);
   584		ctx->es->s_inodes_per_group = cpu_to_le32(MIGRATE_TEST_INODES_PER_GRP);
   585		ctx->es->s_inodes_count = cpu_to_le32(MIGRATE_TEST_NGROUPS *
   586						      MIGRATE_TEST_INODES_PER_GRP);
   587		ctx->es->s_inode_size = cpu_to_le16(MIGRATE_TEST_INODE_SIZE);
   588		ctx->es->s_checksum_type = EXT4_CRC32C_CHKSUM;
   589		generate_random_uuid(ctx->es->s_uuid);
   590		ext4_blocks_count_set(ctx->es, MIGRATE_TEST_TOTAL_BLKS);
   591		ext4_set_feature_extents(sb);
   592		ext4_set_feature_64bit(sb);
   593		ext4_set_feature_metadata_csum(sb);
   594		sbi->s_csum_seed = ext4_chksum(~0, ctx->es->s_uuid,
   595					       sizeof(ctx->es->s_uuid));
   596		ext4_superblock_csum_set(sb);
   597	
   598		root_inode = migrate_make_test_inode(test, EXT4_ROOT_INO,
   599						     S_IFDIR | 0755);
   600		sb->s_root = d_make_root(root_inode);
   601		KUNIT_ASSERT_NOT_NULL(test, sb->s_root);
   602	
   603		active_migrate_test = test;
   604		kunit_activate_static_stub(test, ext4_sb_bread, migrate_sb_bread_stub);
   605		kunit_activate_static_stub(test, ext4_ext_getblk,
   606					   migrate_ext_getblk_stub);
   607		kunit_activate_static_stub(test, __ext4_ext_dirty,
   608					   migrate_ext_dirty_stub);
   609		kunit_activate_static_stub(test, __ext4_handle_dirty_metadata,
   610					   migrate_handle_dirty_metadata_stub);
   611		kunit_activate_static_stub(test, __ext4_mark_inode_dirty,
   612					   migrate_mark_inode_dirty_stub);
   613		kunit_activate_static_stub(test, __ext4_new_inode,
   614					   migrate_new_inode_stub);
   615		kunit_activate_static_stub(test, ext4_mb_new_blocks,
   616					   migrate_mb_new_blocks_stub);
   617		kunit_activate_static_stub(test, ext4_free_blocks,
   618					   migrate_free_blocks_stub);
   619	
   620		return 0;
   621	}
   622	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
