Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795643079;
	b=LNmUGdCpeJBAxdg9XKPRdntbPI7H9KWnDXUFVYzI9ppWrC/8grlfeLRcPqTGD6VC4gCq
	 /iTv/RJbqUlICD3C2XNn1kICMQy6mhucE9gVbb8Qi5b+8dPWb9AQhG/1D6TrIZtSiP6pS
	 GiSqvb97ia8WAIzwF299l+9MJELyTCf4cVu5+nZl/tBQj2ItK2Z0ABuX+xIfyv50MLg2B
	 Mqk7MldcODzuGHav2kaK8wXmoWrAZl1OUPMTKnuRtVa/ckMDFNJhrLSU4SfQ51zvrYpM+
	 aRSCebBv7oTTuucF6JelUjTDwQaTF8Fgd7X/PwO8EGfpgjqEG/7xWjmJICuSwj0By/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795643079;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=82dIt7sLFrIoXpbqBhFx/9ZYCEU902S7j8lyKEQEm5Y=;
	b=fqrWufrvw3MVB6DqLXG3cNz2DLpUQxIno2PLqGkytjXsI/gryBhGueA+jS63gHuYvJxz
	 9Zl2vPBWGXKFlb3xSAkUz4jH//OZhwDO+W5OGYnb6oqYL/lgqJlc9pNntCxkN5rEuEVNP
	 N5cYT/7m7412TTe4pNth3zjbFOc18jbU9uGSs9cnQwQnexsX/YmSawkrlrKOpFvvPptg5
	 rNhtVMOEiD0IJOAU5ckPRu9DLP/VYwDNqbIpLY60iMLbLMT5IMswu5egM0XGin8Ty6t3V
	 J29mpAp0wqaq/JMBp+e93oT3AyzNwO9jnN2mExcQ/aV3/agnh20jEibW7+JgbbgJpfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="NFo/J3iE";
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D00E606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 21:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D00E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NFo/J3iE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795643079; x=1827179079;
  h=date:from:to:cc:subject:message-id;
  bh=g957cD+Z2D4e2C0SZf5Id5lE83FRw2LSJtX1PKrIbcI=;
  b=NFo/J3iEBV5ihQtSXW0TD56KN0S3D4L85SIChppnceAuaVWz6RvZBQYF
   i6hlMhZwTavpANxjsRbKM9Srob+oKJjVXiDvgTUkEqC/zAv1IVoOs/uVK
   Xf/sTWEQJ79TSzws2afFrB7THDtTwOKZB5typlM3Hho7oz5JFBc9s6h8n
   PEVQi0f5BzKq5Vt2h/FsBqJkhynREdprsylDWIzqyOfnQy/anfcx7xqNA
   FdpuFYxeUwnYgD/C8hBu+y6h96Wk9Afgy3cTdOaLjQxw62cmr5GwzeUqY
   qBDT//srbHrn3cL6aLnjO91zOWlDd+/i4LIqTkXZWHkPf5+IYajAymSwT
   A==;
X-CSE-ConnectionGUID: wbhCZt4lSH688oPhToLINw==
X-CSE-MsgGUID: NLZDC2ytTO6D5NaLF9y4Lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4619857"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4619857"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 13:44:38 -0800
X-CSE-ConnectionGUID: 4Yrb4jQcQCyscmFxeHVQ6w==
X-CSE-MsgGUID: H4APimBKQ0uxqqZRGobRVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="12112585"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 25 Nov 2026 13:44:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWKn4-00000001Siq-0FWb;
	Wed, 25 Nov 2026 21:44:34 +0000
Date: Thu, 26 Nov 2026 05:43:49 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu] BUILD SUCCESS WITH UNVERIFIED WARNING
 a268dccf53219d6f28e01d597115d3004b9d6e0b
Message-ID: <20261126054349.pdsci8Sa-lkp@intel.com>
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
branch HEAD: a268dccf53219d6f28e01d597115d3004b9d6e0b  ext4: avoid zero i_dtime wrap in ialloc-test on RTC-less VMs

Unverified Warning (likely false positive, kindly check if interested):

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

    fs/ext4/balloc-test.c:1385 test_read_block_bitmap_validates_csum() warn: passing zero to 'PTR_ERR'
    fs/ext4/balloc-test.c:1399 test_read_block_bitmap_validates_csum() warn: passing zero to 'PTR_ERR'
    fs/ext4/block_validity-test.c:497 bv_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/ialloc-test.c:1293 ialloc_test_read_ibitmap_uninit() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:1307 ialloc_test_read_ibitmap_errors() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:2368 ialloc_test_new_inode_errors() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:2574 ialloc_test_orphan_get() warn: passing zero to 'PTR_ERR'
    fs/ext4/ialloc-test.c:753 ialloc_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/indirect-test.c:372 ind_blk_ptrs() error: dereferencing freed memory 'bh' (line 371)
    fs/ext4/indirect-test.c:579 ind_test_init() error: dereferencing freed memory 'sbh' (line 577)
    fs/ext4/inline-test.c:1078 test_readpage_inline_link_and_iomap() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:1870 inode_test_get_inode_loc_variants() error: dereferencing freed memory 'iloc.bh' (line 1853)
    fs/ext4/inode-test.c:1893 inode_test_get_inode_loc_variants() warn: passing freed memory 'iloc.bh' (line 1874)
    fs/ext4/inode-test.c:1966 inode_test_iget_validation_and_modes() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:2842 inode_test_get_block_bread_and_walk_buffers() warn: passing zero to 'PTR_ERR'
    fs/ext4/inode-test.c:970 inode_test_setup() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/ioctl-test.c:373 ioctl_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/migrate-test.c:655 migrate_test_init() error: dereferencing freed memory 'sbh' (line 653)
    fs/ext4/mmp.c:122 read_mmp_block() error: we previously assumed '*bh' could be null (see line 115)
    fs/ext4/namei-test.c:1518 test_namei_check_dx_root_and_probe() warn: passing zero to 'PTR_ERR'
    fs/ext4/namei-test.c:899 test_namei_read_dirblock() warn: passing zero to 'PTR_ERR'
    fs/ext4/namei-test.c:944 test_namei_append_and_init_dir() warn: passing zero to 'PTR_ERR'
    fs/ext4/orphan-test.c:855 orphan_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/resize-test.c:737 resize_test_init() error: dereferencing freed memory 'sbh' (line 735)
    fs/ext4/super-test.c:314 super_test_init() error: 'sb' dereferencing possible ERR_PTR()
    fs/ext4/sysfs-test.c:201 sysfs_test_init() error: 'sb' dereferencing possible ERR_PTR()

Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-2200-20261124
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
|   `-- fs-ext4-sysfs-test.c-sysfs_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|-- i386-randconfig-2200-20261124
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
|   `-- fs-ext4-sysfs-test.c-sysfs_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|-- nios2-randconfig-2200-20261124
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
|   `-- fs-ext4-sysfs-test.c-sysfs_test_init()-error:sb-dereferencing-possible-ERR_PTR()
|-- openrisc-randconfig-2200-20261124
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
|   `-- fs-ext4-sysfs-test.c-sysfs_test_init()-error:sb-dereferencing-possible-ERR_PTR()
`-- xtensa-randconfig-2200-20261124
    |-- fs-ext4-balloc-test.c-test_read_block_bitmap_validates_csum()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-block_validity-test.c-bv_test_init()-error:sb-dereferencing-possible-ERR_PTR()
    |-- fs-ext4-ialloc-test.c-ialloc_test_init()-error:sb-dereferencing-possible-ERR_PTR()
    |-- fs-ext4-ialloc-test.c-ialloc_test_new_inode_errors()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-ialloc-test.c-ialloc_test_orphan_get()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-ialloc-test.c-ialloc_test_read_ibitmap_errors()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-ialloc-test.c-ialloc_test_read_ibitmap_uninit()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-indirect-test.c-ind_blk_ptrs()-error:dereferencing-freed-memory-bh-(line-)
    |-- fs-ext4-indirect-test.c-ind_test_init()-error:dereferencing-freed-memory-sbh-(line-)
    |-- fs-ext4-inline-test.c-test_readpage_inline_link_and_iomap()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-inode-test.c-inode_test_get_block_bread_and_walk_buffers()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-inode-test.c-inode_test_get_inode_loc_variants()-error:dereferencing-freed-memory-iloc.bh-(line-)
    |-- fs-ext4-inode-test.c-inode_test_get_inode_loc_variants()-warn:passing-freed-memory-iloc.bh-(line-)
    |-- fs-ext4-inode-test.c-inode_test_iget_validation_and_modes()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-inode-test.c-inode_test_setup()-error:sb-dereferencing-possible-ERR_PTR()
    |-- fs-ext4-ioctl-test.c-ioctl_test_init()-error:sb-dereferencing-possible-ERR_PTR()
    |-- fs-ext4-migrate-test.c-migrate_test_init()-error:dereferencing-freed-memory-sbh-(line-)
    |-- fs-ext4-mmp.c-read_mmp_block()-error:we-previously-assumed-bh-could-be-null-(see-line-)
    |-- fs-ext4-namei-test.c-test_namei_append_and_init_dir()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-namei-test.c-test_namei_check_dx_root_and_probe()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-namei-test.c-test_namei_read_dirblock()-warn:passing-zero-to-PTR_ERR
    |-- fs-ext4-orphan-test.c-orphan_test_init()-error:sb-dereferencing-possible-ERR_PTR()
    |-- fs-ext4-resize-test.c-resize_test_init()-error:dereferencing-freed-memory-sbh-(line-)
    |-- fs-ext4-super-test.c-super_test_init()-error:sb-dereferencing-possible-ERR_PTR()
    `-- fs-ext4-sysfs-test.c-sysfs_test_init()-error:sb-dereferencing-possible-ERR_PTR()

elapsed time: 2913m

configs tested: 120
configs skipped: 0

tested configs:
alpha        randconfig-2200-20261124    gcc-8.5.0  smatch
arc          randconfig-2000-20261124    gcc-8.5.0
arc          randconfig-2001-20261124    gcc-15.3.0
arc          randconfig-2002-20261124    gcc-13.5.0
arc          randconfig-2003-20261124    gcc-8.5.0
arc          randconfig-2004-20261124    gcc-13.5.0
arc          randconfig-2005-20261124    gcc-11.5.0
arc          randconfig-2200-20261124    gcc-8.5.0  smatch
arc         randconfig-r2108-20261124    gcc-8.5.0  cocci
arm          randconfig-2000-20261124    gcc-8.5.0
arm          randconfig-2001-20261124    clang-17
arm          randconfig-2002-20261124    clang-24
arm          randconfig-2200-20261124    clang-17   smatch
arm64        randconfig-2000-20261124    clang-24
arm64        randconfig-2001-20261124    gcc-8.5.0
arm64        randconfig-2002-20261124    clang-24
arm64        randconfig-2200-20261124    gcc-16.2.0 smatch
csky         randconfig-2200-20261124    gcc-15.3.0 smatch
csky        randconfig-r2304-20261124    gcc-16.2.0 sparse
hexagon      randconfig-2200-20261124    clang-24   smatch
i386         randconfig-2000-20261124    clang-22
i386         randconfig-2001-20261124    clang-22
i386         randconfig-2002-20261124    gcc-14
i386         randconfig-2003-20261124    clang-22
i386         randconfig-2004-20261124    gcc-14
i386         randconfig-2005-20261124    gcc-14
i386         randconfig-2100-20261124    gcc-14     cocci
i386         randconfig-2101-20261124    gcc-14     cocci
i386         randconfig-2102-20261124    clang-22   cocci
i386         randconfig-2103-20261124    gcc-14     cocci
i386         randconfig-2104-20261124    gcc-12     cocci
i386         randconfig-2105-20261124    gcc-14     cocci
i386         randconfig-2200-20261124    clang-22   smatch
i386         randconfig-2300-20261124    clang-22   sparse
i386         randconfig-2301-20261124    gcc-14     sparse
i386         randconfig-2302-20261124    clang-22   sparse
loongarch    randconfig-2000-20261124    clang-18
loongarch    randconfig-2001-20261124    gcc-12.5.0
loongarch    randconfig-2200-20261124    gcc-16.2.0 smatch
loongarch   randconfig-r2105-20261124    gcc-16.2.0 cocci
loongarch   randconfig-r2301-20261124    clang-24   sparse
m68k         randconfig-2200-20261124    gcc-10.5.0 smatch
microblaze   randconfig-2200-20261124    gcc-8.5.0  smatch
microblaze  randconfig-r2111-20261124    gcc-16.2.0 cocci
mips         randconfig-2000-20261124    clang-20
mips         randconfig-2001-20261124    clang-20
mips         randconfig-2002-20261124    clang-24
mips         randconfig-2200-20261124    clang-20   smatch
mips        randconfig-r2103-20261124    gcc-12.5.0 cocci
nios2        randconfig-2000-20261124    gcc-11.5.0
nios2        randconfig-2001-20261124    gcc-11.5.0
nios2        randconfig-2200-20261124    gcc-11.5.0 smatch
nios2       randconfig-r2300-20261124    gcc-10.5.0 sparse
nios2       randconfig-r2302-20261124    gcc-8.5.0  sparse
openrisc     randconfig-2000-20261124    gcc-16.2.0
openrisc     randconfig-2001-20261124    gcc-11.5.0
openrisc     randconfig-2002-20261124    gcc-16.2.0
openrisc     randconfig-2200-20261124    gcc-11.5.0 smatch
openrisc    randconfig-r2107-20261124    gcc-16.2.0 cocci
openrisc    randconfig-r2303-20261124    gcc-10.5.0 sparse
parisc       randconfig-2000-20261124    gcc-8.5.0
parisc       randconfig-2001-20261124    gcc-8.5.0
parisc       randconfig-2200-20261124    gcc-9.5.0  smatch
parisc      randconfig-r2104-20261124    gcc-12.5.0 cocci
parisc      randconfig-r2110-20261124    gcc-11.5.0 cocci
powerpc      randconfig-2000-20261124    clang-17
powerpc      randconfig-2001-20261124    gcc-10.5.0
powerpc      randconfig-2002-20261124    clang-24
powerpc      randconfig-2200-20261124    clang-21   smatch
powerpc64    randconfig-2000-20261124    clang-24
powerpc64    randconfig-2001-20261124    clang-22
powerpc64    randconfig-2002-20261124    clang-24
powerpc64    randconfig-2200-20261124    gcc-12.5.0 smatch
powerpc64   randconfig-r2100-20261124    clang-22   cocci
riscv        randconfig-2000-20261124    gcc-16.2.0
riscv        randconfig-2001-20261124    clang-24
riscv        randconfig-2002-20261124    clang-24
riscv        randconfig-2003-20261124    gcc-8.5.0
riscv        randconfig-2004-20261124    clang-22
riscv        randconfig-2005-20261124    clang-18
riscv        randconfig-2200-20261124    gcc-14.4.0 smatch
s390         randconfig-2000-20261124    clang-19
s390         randconfig-2001-20261124    gcc-14.4.0
s390         randconfig-2002-20261124    clang-24
s390         randconfig-2003-20261124    clang-24
s390         randconfig-2004-20261124    clang-24
s390         randconfig-2005-20261124    clang-24
s390         randconfig-2200-20261124    clang-24   smatch
s390        randconfig-r2109-20261124    clang-17   cocci
sh           randconfig-2000-20261124    gcc-9.5.0
sh           randconfig-2001-20261124    gcc-11.5.0
sh           randconfig-2002-20261124    gcc-16.2.0
sh           randconfig-2003-20261124    gcc-11.5.0
sh           randconfig-2004-20261124    gcc-16.2.0
sh           randconfig-2005-20261124    gcc-11.5.0
sh           randconfig-2200-20261124    gcc-16.2.0 smatch
sparc        randconfig-2000-20261124    gcc-16.2.0
sparc        randconfig-2001-20261124    gcc-15.3.0
sparc        randconfig-2200-20261124    gcc-11.5.0 smatch
sparc       randconfig-r2102-20261124    gcc-13.5.0 cocci
sparc64      randconfig-2000-20261124    clang-24
sparc64      randconfig-2001-20261124    gcc-8.5.0
sparc64      randconfig-2200-20261124    clang-24   smatch
sparc64     randconfig-r2101-20261124    gcc-8.5.0  cocci
sparc64     randconfig-r2305-20261124    gcc-12.5.0 sparse
um           randconfig-2000-20261124    gcc-14
um           randconfig-2001-20261124    gcc-14
um           randconfig-2200-20261124    gcc-14     smatch
x86_64       randconfig-2000-20261124    clang-22
x86_64       randconfig-2001-20261124    clang-22
x86_64       randconfig-2002-20261124    gcc-14
x86_64       randconfig-2003-20261124    clang-22
x86_64       randconfig-2004-20261124    gcc-14
x86_64       randconfig-2005-20261124    gcc-14
x86_64       randconfig-2200-20261124    gcc-14     smatch
x86_64       randconfig-2300-20261124    gcc-14     sparse
x86_64       randconfig-2301-20261124    gcc-14     sparse
x86_64       randconfig-2302-20261124    gcc-14     sparse
xtensa       randconfig-2200-20261124    gcc-9.5.0  smatch
xtensa      randconfig-r2106-20261124    gcc-8.5.0  cocci

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
