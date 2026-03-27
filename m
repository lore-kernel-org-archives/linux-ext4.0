Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F3834DCEC
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620644; cv=none; b=oOhP9Qkd2VRSDXLGBhCjxP1zwq8bODZ1TJejkHjHj69cTp+KPcbdbal+LIbezjBQXlGHbni1AWOpe+9C6U0Oj5bEYKmNzYY5Mdd7SbpR9A6ElUZ8ZG0/MdhKtxLwFhwe7q3MFcTITL0k3qqTA5gcgFlO6u/g+JxeCPg/TPLzTTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620644; c=relaxed/simple;
	bh=bMsA3MA6Peb33XBs0Bbx4r/BgPyR0o2yQCN7J60oSbk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=W+eaUV18l7x2Lsx2vN98BOjmboYj3kanuANL9v+Rm1GCzWmfw7MK6ha0V27kk/S8MimYuFt50KLXuZTMYT2TV4xX4+Xm47SoOVS6c4yM6YGT1mtv6WRYCzOeZmuAr/7ltsGNPnZYKZzwMIcGOKMZeg4SsTpCYOMJ/+K+6CpUvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mjzEkRRq; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mjzEkRRq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774620642; x=1806156642;
  h=date:from:to:cc:subject:message-id;
  bh=bMsA3MA6Peb33XBs0Bbx4r/BgPyR0o2yQCN7J60oSbk=;
  b=mjzEkRRqkaGK/mKaQMineBB5RBJ8OLPaYcgSQTzfrhKiqt87ZUEnS9FY
   2h1huqH/VzF1SMwafRaVL6MnRMS/g9DI1JKXZNIs2wtcYzaMPqHucRdTh
   oGK4FnbQBp5Xyt884J27W4nYGEJhKwK6sTtblzf4/7nZhHBKNjS6kmpYS
   cV5odamSudj0D+zehJW/6KUc8A6e3IlGGLIijVD+uF7oDKvaeY6BBOM2H
   nzJfyPG2kx8aV9PZw4Ffp3IiGm2jaIPCIB47Yw/C8yF6v79jAh+nLgDBa
   xh21HaUPg5szQrF4oiZN7z2mS5V4FgdNq5DW2FCMUWgWFaKM8vYBm6CK2
   w==;
X-CSE-ConnectionGUID: 0ds01xt4TayUJz/rnNdsog==
X-CSE-MsgGUID: pOInMtvnTAqkOUlmvYT0zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75407288"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="75407288"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 07:10:42 -0700
X-CSE-ConnectionGUID: oKxIv6FHT5eCMiFgw1IBDQ==
X-CSE-MsgGUID: Tum9HR5nR2uUL9Eq1P4sYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="225330927"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 27 Mar 2026 07:10:40 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w67tV-00000000ALZ-2XTB;
	Fri, 27 Mar 2026 14:10:37 +0000
Date: Fri, 27 Mar 2026 22:10:22 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:dev] BUILD SUCCESS
 86709d389530941e5816505e3c12c757ceca374d
Message-ID: <202603272214.bmvtWrhN-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
branch HEAD: 86709d389530941e5816505e3c12c757ceca374d  ext4: avoid infinite loops caused by residual data

elapsed time: 975m

configs tested: 188
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260327    gcc-11.5.0
arc                   randconfig-001-20260327    gcc-8.5.0
arc                   randconfig-002-20260327    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260327    gcc-8.5.0
arm                   randconfig-002-20260327    clang-23
arm                   randconfig-002-20260327    gcc-8.5.0
arm                   randconfig-003-20260327    clang-18
arm                   randconfig-003-20260327    gcc-8.5.0
arm                   randconfig-004-20260327    gcc-11.5.0
arm                   randconfig-004-20260327    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260327    clang-23
arm64                 randconfig-002-20260327    clang-23
arm64                 randconfig-003-20260327    clang-23
arm64                 randconfig-004-20260327    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260327    clang-23
csky                  randconfig-002-20260327    clang-23
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260327    gcc-8.5.0
hexagon               randconfig-002-20260327    gcc-8.5.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260327    clang-20
i386        buildonly-randconfig-002-20260327    clang-20
i386        buildonly-randconfig-003-20260327    clang-20
i386        buildonly-randconfig-003-20260327    gcc-14
i386        buildonly-randconfig-004-20260327    clang-20
i386        buildonly-randconfig-005-20260327    clang-20
i386        buildonly-randconfig-006-20260327    clang-20
i386        buildonly-randconfig-006-20260327    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260327    clang-20
i386                  randconfig-002-20260327    clang-20
i386                  randconfig-003-20260327    clang-20
i386                  randconfig-004-20260327    clang-20
i386                  randconfig-005-20260327    clang-20
i386                  randconfig-006-20260327    clang-20
i386                  randconfig-007-20260327    clang-20
i386                  randconfig-011-20260327    gcc-14
i386                  randconfig-012-20260327    gcc-14
i386                  randconfig-013-20260327    gcc-14
i386                  randconfig-014-20260327    gcc-14
i386                  randconfig-015-20260327    gcc-14
i386                  randconfig-016-20260327    gcc-14
i386                  randconfig-017-20260327    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260327    gcc-8.5.0
loongarch             randconfig-002-20260327    gcc-8.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                  decstation_64_defconfig    gcc-15.2.0
mips                      pic32mzda_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260327    gcc-8.5.0
nios2                 randconfig-002-20260327    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260327    clang-18
parisc                randconfig-002-20260327    clang-18
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260327    clang-18
powerpc               randconfig-002-20260327    clang-18
powerpc64             randconfig-001-20260327    clang-18
powerpc64             randconfig-002-20260327    clang-18
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260327    gcc-12.5.0
riscv                 randconfig-002-20260327    gcc-12.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260327    gcc-12.5.0
s390                  randconfig-002-20260327    gcc-12.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260327    gcc-12.5.0
sh                    randconfig-002-20260327    gcc-12.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260327    gcc-14
sparc                 randconfig-002-20260327    gcc-14
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260327    gcc-14
sparc64               randconfig-002-20260327    gcc-14
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260327    gcc-14
um                    randconfig-002-20260327    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260327    clang-20
x86_64      buildonly-randconfig-002-20260327    clang-20
x86_64      buildonly-randconfig-003-20260327    clang-20
x86_64      buildonly-randconfig-004-20260327    clang-20
x86_64      buildonly-randconfig-005-20260327    clang-20
x86_64      buildonly-randconfig-006-20260327    clang-20
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260327    gcc-14
x86_64                randconfig-002-20260327    gcc-14
x86_64                randconfig-003-20260327    gcc-14
x86_64                randconfig-004-20260327    gcc-14
x86_64                randconfig-005-20260327    gcc-14
x86_64                randconfig-006-20260327    gcc-14
x86_64                randconfig-011-20260327    gcc-14
x86_64                randconfig-012-20260327    gcc-14
x86_64                randconfig-013-20260327    gcc-14
x86_64                randconfig-014-20260327    gcc-14
x86_64                randconfig-015-20260327    gcc-14
x86_64                randconfig-016-20260327    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260327    gcc-14
xtensa                randconfig-002-20260327    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
