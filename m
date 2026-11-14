Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630804;
	b=XfiKviwrufAXvvBAXytRCudZKaLLBtUl7wYgzaITQBlOH+zVFY50DPAgHZ2wkMoZIZ2p
	 0USiGak9vILs+/hr81o2VK8IAnY1utbMCVMGveiazmayso7z97o63DptasjZOvg0yzt3T
	 sy1qXPO2F4cbPQQd5JSJMW/TlWjcQ8vHqbuArSylU58TjUCVimjG80WsjvCioOgybrw9D
	 3KIQAhQbvK0ZN0aBcg+XZcRtO3Ve4VklCNGczCO2+YxqpE/AMxwwxD12fX8dKN8Ug1YW0
	 i7U/QK0c7isWjk3+PegHQdIAMdlq4MFDoy24jW4vtq8kO83wdU1kLpLE+1XKVXyvjCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630804;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=3Ka3Oq0r2UE3z1AB9Pkv+qO9+9TfOvmaHQqb6hixyac=;
	b=o6+5wT92rd/+8jtxjs1IEimB34Rsjd9xPeQagbKu3Cs67taS3Tu1lq2xKcb+gHRAt2+e
	 /9VozaIsslvwml2HFe3XPlU3ysssbzzLS7Cun8ogAhix8zwcWprsDFj38P+8OB0B3eKn0
	 MxbUTltqm6s2ouMRNxZkit8ZQRP4ZujYrUIuZZijMPY6Q/87tTUhqHPNrhnp2+0OP/ATe
	 ZZP1WeVOg3SJ0Ty7HK4oUzG7Og5KI6FLjfn13b8+9EzRz8oYkdtJ4N/w4wc6aGJywISDw
	 ghxheZrw/hvv0hL9J8y6ozYioA/SbLT0Acn+BgH9iR0lmO1lj1xynOBFkB3QRQ7SvBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="We/1fuml";
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8993A606A333
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 04:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8993A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=We/1fuml
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794630804; x=1826166804;
  h=date:from:to:cc:subject:message-id;
  bh=vPnl/SvJ8WfbVuK6DD+7In+UkY9NQ3XE4d/iFMD3TK4=;
  b=We/1fumlsn3QOA3GVmnciaf8SQYwu+hmsAl9TO7j8JlH+Eg9wF0cb570
   FHnDd98KJcBAkL5qBIUX5+TuWX0pkHFJwtEhRBPKNlrC/YSGQh+vdgGqJ
   ucMp8y+DjGseWapitYeHLqA4R87glArBpVcTNW45aXbGai+rzRVNIR9lP
   aDFfkFCZjnSku6TauLWw8rhe9MgIA0TAnLv8/Zd7eiUsqWIhFBKQoe7aJ
   vsBo6ZMVvwRnZ5Lje+a6O/U97edP561X/rKTA8MLL4eYxeJHIdO2IS/3c
   iu1WS3BiwbGX6KYAy1qo1ZtVfPDpXJfnsarBs1u6AQ67tuWAtk4M4pxv5
   g==;
X-CSE-ConnectionGUID: R+Z/9cISRgi/F0mlgQEanA==
X-CSE-MsgGUID: hPDo18rFSHuBg2c6vMjJMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3339114"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3339114"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 20:33:23 -0800
X-CSE-ConnectionGUID: NDgJWq8NTb2Jkxb7Ji8tyg==
X-CSE-MsgGUID: /RN2PvujRnu9b6rWHOBTsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9426684"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 13 Nov 2026 20:33:22 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xS5S3-000000014s1-19Aa;
	Sat, 14 Nov 2026 04:33:19 +0000
Date: Sat, 14 Nov 2026 12:32:54 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu] BUILD REGRESSION
 246d715a48c25a74ac372dda5e10d8f69f89b50a
Message-ID: <20261114123254.UZJGpmlh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git pu
branch HEAD: 246d715a48c25a74ac372dda5e10d8f69f89b50a  ext4: don't stop EXT4_IOC_GET_ES_CACHE at uncached ranges

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202611120832.HRTiXytu-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611120955.8LvZI7rV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121135.jzI3FOoM-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121210.BAKJYVMv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121231.pfw7Gaun-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121301.e18GS9gn-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121359.SOSwSLzQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121411.rRCBX7mS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121426.SgPY0H6k-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121719.IZvD7hCQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611121731.hU760S80-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611122037.vD5jQNAi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611132301.FRexPvKk-lkp@intel.com

    ERROR: modpost: fs/ext4/ext4-test.ko: symbol '__aeabi_uldivmod' undefined!
    ERROR: modpost: vmlinux: symbol 'ext4_free_group_clusters' exported twice. Previous export was in vmlinux
    ERROR: modpost: vmlinux: symbol 'ext4_free_group_clusters_set' exported twice. Previous export was in vmlinux
    WARNING: modpost: vmlinux: EXPORT symbol 'ext4_free_group_clusters' version generation failed, symbol will not be versioned.
    fs/ext4/fast_commit-test.c:1073:13: warning: stack frame size (2768) exceeds limit (2048) in 'test_fc_init_and_eligibility' [-Wframe-larger-than]
    fs/ext4/fast_commit-test.c:1145:1: warning: the frame size of 1476 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/fast_commit-test.c:1145:1: warning: the frame size of 1568 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/namei-test.c:2229:1: warning: the frame size of 1856 bytes is larger than 1536 bytes [-Wframe-larger-than=]
    fs/ext4/super-test.c:219:13: warning: unused variable 'i' [-Wunused-variable]
    fs/ext4/super-test.c:219:6: warning: unused variable 'i' [-Wunused-variable]
    fs/ext4/xattr-test.c:1531:13: warning: stack frame size (2912) exceeds limit (2048) in 'test_xattr_credits_usage_expand_and_delete' [-Wframe-larger-than]

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202611120950.nMRMGeTV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611121115.YR7OUKaU-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611121345.GzlyODjR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611121546.H3A7xN6R-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611121755.hiQrKm5X-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611121910.d33i7NZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611122133.ht0OzBhV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611122336.ExhSFMb8-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611130041.1uHWqikL-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611130228.aW3mg17U-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611130427.OFf1j9Zw-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611130636.RHu0VHtY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611130855.6s6Vd9xj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202611131055.VwNypygU-lkp@intel.com

    fs/ext4/balloc-test.c:1346 test_read_block_bitmap_validates_csum() warn: passing zero to 'PTR_ERR'
    fs/ext4/block_validity-test.c:486 bv_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/ialloc-test.c:1284 ialloc_test_read_ibitmap_uninit() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:1298 ialloc_test_read_ibitmap_errors() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:2336 ialloc_test_new_inode_errors() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:2542 ialloc_test_orphan_get() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:756 ialloc_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/indirect-test.c:367 ind_blk_ptrs() error: dereferencing freed memory 'bh' (line 366)
    fs/ext4/indirect-test.c:578 ind_test_init() error: dereferencing freed memory 'sbh' (line 576)
    fs/ext4/inline-test.c:1020 test_readpage_inline_link_and_iomap() warn: passing zero to 'PTR_ERR'
    fs/ext4/inline-test.c:1034 test_readpage_inline_link_and_iomap() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:1820 inode_test_get_inode_loc_variants() error: dereferencing freed memory 'iloc.bh' (line 1803)
    fs/ext4/inode-test.c:1831 inode_test_get_inode_loc_variants() error: dereferencing freed memory 'iloc.bh' (line 1814)
    fs/ext4/inode-test.c:1843 inode_test_get_inode_loc_variants() warn: passing freed memory 'iloc.bh' (line 1824)
    fs/ext4/inode-test.c:1854 inode_test_get_inode_loc_variants() warn: passing freed memory 'iloc.bh' (line 1835)
    fs/ext4/inode-test.c:1916 inode_test_iget_validation_and_modes() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:1927 inode_test_iget_validation_and_modes() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:2791 inode_test_get_block_bread_and_walk_buffers() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:2802 inode_test_get_block_bread_and_walk_buffers() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:949 inode_test_setup() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/inode-test.c:957 inode_test_setup() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/ioctl-test.c:370 ioctl_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/migrate-test.c:575 migrate_test_init() error: dereferencing freed memory 'sbh' (line 573)
    fs/ext4/mmp.c:122 read_mmp_block() error: we previously assumed '*bh' could be null (see line 115)
    fs/ext4/namei-test.c:1470 test_namei_check_dx_root_and_probe() warn: passing zero to 'PTR_ERR'
    fs/ext4/namei-test.c:898 test_namei_read_dirblock() warn: passing zero to 'PTR_ERR'
    fs/ext4/namei-test.c:943 test_namei_append_and_init_dir() warn: passing zero to 'PTR_ERR'
    fs/ext4/orphan-test.c:855 orphan_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/resize-test.c:740 resize_test_init() error: dereferencing freed memory 'sbh' (line 738)
    fs/ext4/super-test.c:312 super_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/sysfs-test.c:200 sysfs_test_init() error: 'sb' dereferencing possible ERR_PTR()

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r2100-20261112
|   `-- fs-ext4-super-test.c:warning:unused-variable-i
|-- arm-randconfig-2000-20261112
|   `-- ERROR:fs-ext4-ext4-test.ko:symbol-__aeabi_uldivmod-undefined
|-- csky-allmodconfig
|   `-- fs-ext4-fast_commit-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- i386-randconfig-2004-20261112
|   `-- fs-ext4-super-test.c:warning:unused-variable-i
|-- i386-randconfig-2102-20261112
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters-exported-twice.-Previous-export-was-in-vmlinux
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters_set-exported-twice.-Previous-export-was-in-vmlinux
|   |-- fs-ext4-super-test.c:warning:unused-variable-i
|   `-- WARNING:modpost:vmlinux:EXPORT-symbol-ext4_free_group_clusters-version-generation-failed-symbol-will-not-be-versioned.
|-- loongarch-allyesconfig
|   |-- fs-ext4-fast_commit-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_fc_init_and_eligibility
|   `-- fs-ext4-xattr-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_xattr_credits_usage_expand_and_delete
|-- m68k-randconfig-r2311-20261112
|   |-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-left_value-got-restricted-__le16-const-__left
|   |-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-right_value-got-restricted-__le16-const-__right
|   |-- fs-ext4-xattr-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-left_value-got-restricted-__le32-const-__left
|   `-- fs-ext4-xattr-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-right_value-got-restricted-__le32-const-__right
|-- mips-allyesconfig
|   `-- fs-ext4-fast_commit-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- parisc-randconfig-1001-20261114
|   `-- fs-ext4-super-test.c:warning:unused-variable-i
|-- parisc-randconfig-2001-20261112
|   `-- fs-ext4-super-test.c:warning:unused-variable-i
|-- parisc-randconfig-r2103-20261112
|   `-- fs-ext4-super-test.c:warning:unused-variable-i
|-- parisc-randconfig-r2310-20261112
|   |-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-left_value-got-restricted-__le16-const-__left
|   `-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-right_value-got-restricted-__le16-const-__right
|-- powerpc-randconfig-2200-20261112
|   |-- fs-ext4-balloc-test.c-test_read_block_bitmap_validates_csum()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-block_validity-test.c-bv_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|   |-- fs-ext4-ialloc-test.c-ialloc_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|   |-- fs-ext4-ialloc-test.c-ialloc_test_new_inode_errors()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-ialloc-test.c-ialloc_test_orphan_get()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-ialloc-test.c-ialloc_test_read_ibitmap_errors()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-ialloc-test.c-ialloc_test_read_ibitmap_uninit()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-indirect-test.c-ind_blk_ptrs()-error:dereferencing-freed-memory-bh-(line-)
|   |-- fs-ext4-indirect-test.c-ind_test_init()-error:dereferencing-freed-memory-sbh-(line-)
|   |-- fs-ext4-inline-test.c-test_readpage_inline_link_and_iomap()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-inode-test.c-inode_test_get_block_bread_and_walk_buffers()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-inode-test.c-inode_test_get_inode_loc_variants()-error:dereferencing-freed-memory-iloc.bh-(line-)
|   |-- fs-ext4-inode-test.c-inode_test_get_inode_loc_variants()-warn:passing-freed-memory-iloc.bh-(line-)
|   |-- fs-ext4-inode-test.c-inode_test_iget_validation_and_modes()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-inode-test.c-inode_test_setup()-error:sb-dereferencing-possible-ERR_PTR()
|   |-- fs-ext4-ioctl-test.c-ioctl_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|   |-- fs-ext4-migrate-test.c-migrate_test_init()-error:dereferencing-freed-memory-sbh-(line-)
|   |-- fs-ext4-mmp.c-read_mmp_block()-error:we-previously-assumed-bh-could-be-null-(see-line-)
|   |-- fs-ext4-namei-test.c-test_namei_append_and_init_dir()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-namei-test.c-test_namei_check_dx_root_and_probe()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-namei-test.c-test_namei_read_dirblock()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-orphan-test.c-orphan_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|   |-- fs-ext4-resize-test.c-resize_test_init()-error:dereferencing-freed-memory-sbh-(line-)
|   |-- fs-ext4-super-test.c-super_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|   |-- fs-ext4-super-test.c:warning:unused-variable-i
|   `-- fs-ext4-sysfs-test.c-sysfs_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|-- s390-randconfig-2003-20261112
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters-exported-twice.-Previous-export-was-in-vmlinux
|   `-- ERROR:vmlinux:symbol-ext4_free_group_clusters_set-exported-twice.-Previous-export-was-in-vmlinux
|-- s390-randconfig-r2305-20261112
|   |-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-left_value-got-restricted-__le16-const-__left
|   |-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-right_value-got-restricted-__le16-const-__right
|   |-- fs-ext4-fsmap-test.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-base-types):
|   |-- fs-ext4-indirect-test.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-base-types):
|   |-- fs-ext4-migrate-test.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-base-types):
|   |-- fs-ext4-mmp-test.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-base-types):
|   |-- fs-ext4-move_extent-test.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-base-types):
|   `-- fs-ext4-resize-test.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-base-types):
|-- sh-randconfig-2000-20261112
|   `-- fs-ext4-super-test.c:warning:unused-variable-i
|-- sparc64-randconfig-2200-20261112
|   |-- fs-ext4-inline-test.c-test_readpage_inline_link_and_iomap()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-inode-test.c-inode_test_get_block_bread_and_walk_buffers()-warn:passing-zero-to-PTR_ERR
|   |-- fs-ext4-inode-test.c-inode_test_get_inode_loc_variants()-error:dereferencing-freed-memory-iloc.bh-(line-)
|   |-- fs-ext4-inode-test.c-inode_test_get_inode_loc_variants()-warn:passing-freed-memory-iloc.bh-(line-)
|   |-- fs-ext4-inode-test.c-inode_test_iget_validation_and_modes()-warn:passing-zero-to-PTR_ERR
|   `-- fs-ext4-inode-test.c-inode_test_setup()-error:sb-dereferencing-possible-ERR_PTR()
|-- sparc64-randconfig-r2303-20261112
|   |-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-left_value-got-restricted-__le16-const-__left
|   |-- fs-ext4-extents-test.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-long-long-right_value-got-restricted-__le16-const-__right
|   `-- fs-ext4-super-test.c:warning:unused-variable-i
|-- um-randconfig-2001-20261112
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters-exported-twice.-Previous-export-was-in-vmlinux
|   `-- ERROR:vmlinux:symbol-ext4_free_group_clusters_set-exported-twice.-Previous-export-was-in-vmlinux
|-- x86_64-randconfig-2005-20261112
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters-exported-twice.-Previous-export-was-in-vmlinux
|   `-- ERROR:vmlinux:symbol-ext4_free_group_clusters_set-exported-twice.-Previous-export-was-in-vmlinux
|-- x86_64-randconfig-2103-20261112
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters-exported-twice.-Previous-export-was-in-vmlinux
|   `-- ERROR:vmlinux:symbol-ext4_free_group_clusters_set-exported-twice.-Previous-export-was-in-vmlinux
|-- x86_64-randconfig-2104-20261112
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters-exported-twice.-Previous-export-was-in-vmlinux
|   `-- ERROR:vmlinux:symbol-ext4_free_group_clusters_set-exported-twice.-Previous-export-was-in-vmlinux
|-- x86_64-randconfig-2105-20261112
|   |-- ERROR:vmlinux:symbol-ext4_free_group_clusters-exported-twice.-Previous-export-was-in-vmlinux
|   `-- ERROR:vmlinux:symbol-ext4_free_group_clusters_set-exported-twice.-Previous-export-was-in-vmlinux
`-- xtensa-allmodconfig
    `-- fs-ext4-namei-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes

elapsed time: 2661m

configs tested: 90
configs skipped: 0

tested configs:
alpha        randconfig-2000-20261112    gcc-13.5.0
alpha        randconfig-2001-20261112    gcc-8.5.0
arc          randconfig-2000-20261112    gcc-8.5.0
arc          randconfig-2001-20261112    gcc-8.5.0
arc          randconfig-2002-20261112    gcc-8.5.0
arc          randconfig-2003-20261112    gcc-11.5.0
arc          randconfig-2004-20261112    gcc-13.5.0
arc          randconfig-2005-20261112    gcc-15.3.0
arc          randconfig-2200-20261112    gcc-8.5.0  smatch
arm          randconfig-2200-20261112    gcc-10.5.0 smatch
arm         randconfig-r2308-20261112    clang-24   sparse
arm64        randconfig-2200-20261112    clang-24   smatch
arm64       randconfig-r2100-20261112    gcc-14.4.0 cocci
csky        randconfig-r2300-20261112    gcc-10.5.0 sparse
hexagon     randconfig-r2102-20261112    clang-17   cocci
i386         randconfig-2000-20261112    gcc-13
i386         randconfig-2001-20261112    gcc-14
i386         randconfig-2002-20261112    gcc-14
i386         randconfig-2003-20261112    clang-22
i386         randconfig-2004-20261112    gcc-14
i386         randconfig-2005-20261112    clang-22
i386         randconfig-2100-20261112    gcc-14     cocci
i386         randconfig-2101-20261112    gcc-14     cocci
i386         randconfig-2102-20261112    clang-22   cocci
i386         randconfig-2103-20261112    gcc-14     cocci
i386         randconfig-2104-20261112    clang-22   cocci
i386         randconfig-2105-20261112    clang-22   cocci
i386         randconfig-2300-20261112    clang-22   sparse
i386         randconfig-2301-20261112    clang-22   sparse
i386         randconfig-2302-20261112    gcc-14     sparse
i386        randconfig-r2105-20261112    clang-22   cocci
loongarch    randconfig-2200-20261112    clang-24   smatch
loongarch   randconfig-r2104-20261112    clang-24   cocci
loongarch   randconfig-r2302-20261112    gcc-16.2.0 sparse
m68k         randconfig-2000-20261112    gcc-16.2.0
m68k         randconfig-2001-20261112    gcc-10.5.0
m68k         randconfig-2200-20261112    gcc-14.4.0 smatch
microblaze   randconfig-2000-20261112    gcc-9.5.0
microblaze   randconfig-2001-20261112    gcc-8.5.0
microblaze   randconfig-2200-20261112    gcc-15.3.0 smatch
mips        randconfig-r2301-20261112    clang-24   sparse
parisc       randconfig-2200-20261112    gcc-8.5.0  smatch
parisc      randconfig-r2101-20261112    gcc-10.5.0 cocci
parisc      randconfig-r2103-20261112    gcc-14.4.0 cocci
parisc      randconfig-r2310-20261112    gcc-9.5.0  sparse
powerpc      randconfig-2200-20261112    clang-24   smatch
powerpc     randconfig-r2307-20261112    gcc-14.4.0 sparse
powerpc     randconfig-r2309-20261112    gcc-8.5.0  sparse
powerpc64   randconfig-r2311-20261112    gcc-15.3.0 sparse
s390         randconfig-2000-20261112    gcc-16.2.0
s390         randconfig-2001-20261112    clang-17
s390         randconfig-2002-20261112    gcc-12.5.0
s390         randconfig-2003-20261112    gcc-10.5.0
s390         randconfig-2004-20261112    gcc-12.5.0
s390         randconfig-2005-20261112    clang-24
s390         randconfig-2200-20261112    clang-24   smatch
s390        randconfig-r2305-20261112    clang-24   sparse
sh           randconfig-2000-20261112    gcc-9.5.0
sh           randconfig-2001-20261112    gcc-15.3.0
sh           randconfig-2002-20261112    gcc-9.5.0
sh           randconfig-2003-20261112    gcc-16.2.0
sh           randconfig-2004-20261112    gcc-16.2.0
sh           randconfig-2005-20261112    gcc-16.2.0
sparc        randconfig-2000-20261112    gcc-8.5.0
sparc        randconfig-2001-20261112    gcc-11.5.0
sparc64      randconfig-2000-20261112    clang-24
sparc64      randconfig-2001-20261112    gcc-8.5.0
sparc64      randconfig-2200-20261112    gcc-10.5.0 smatch
sparc64     randconfig-r2303-20261112    clang-21   sparse
um           randconfig-2000-20261112    clang-24
um           randconfig-2001-20261112    clang-24
x86_64       randconfig-2000-20261112    gcc-14
x86_64       randconfig-2001-20261112    gcc-14
x86_64       randconfig-2002-20261112    clang-22
x86_64       randconfig-2003-20261112    clang-22
x86_64       randconfig-2004-20261112    clang-22
x86_64       randconfig-2005-20261112    clang-22
x86_64       randconfig-2100-20261112    clang-22   cocci
x86_64       randconfig-2101-20261112    gcc-14     cocci
x86_64       randconfig-2102-20261112    gcc-14     cocci
x86_64       randconfig-2103-20261112    gcc-12     cocci
x86_64       randconfig-2104-20261112    clang-22   cocci
x86_64       randconfig-2105-20261112    clang-22   cocci
x86_64       randconfig-2200-20261112    gcc-13     smatch
x86_64       randconfig-2300-20261112    gcc-14     sparse
x86_64       randconfig-2301-20261112    gcc-12     sparse
x86_64       randconfig-2302-20261112    clang-22   sparse
xtensa       randconfig-2200-20261112    gcc-13.5.0 smatch
xtensa      randconfig-r2304-20261112    gcc-16.2.0 sparse
xtensa      randconfig-r2306-20261112    gcc-8.5.0  sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
