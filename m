Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AC427732
	for <linux-ext4@vger.kernel.org>; Sat,  6 Jun 2026 02:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780711405; cv=none; b=ccXF0YNRZ6mul0srhIAYQJREt2yJTAnWFiud2CSD6hrk8enxaTWudd1EiZ3bN6bXSh4TQVddZb+sh3NXRXsduUs2Xfh4H6OvEE3crZDdUH1ufILXCeSuitj9lyDmbtSnyAtJiu158xTAeo72okooPy2+nCDoRT4Tg/AKt9/7EXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780711405; c=relaxed/simple;
	bh=yoXBCdqedr1jO0C9AsmS2hY+nc4maICoJxsF/yu+jek=;
	h=Date:From:To:Cc:Subject:Message-ID; b=lb7CKVYfPpK+/FFpcobQgRWPGi+Vka+tYWL29p64pzt3SOpy5rsUs3v3jnb1YSCUphsiNPLoawbxw8DBEOWRZytV7ggf2fkpus/kSRZwM/DZx31IolBSwg7MYhXAaS9+F9AzkkUqTMIu6R50QVXwyoO0ObD44dMts5hSwRSkD7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j9aC7aoG; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j9aC7aoG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780711403; x=1812247403;
  h=date:from:to:cc:subject:message-id;
  bh=yoXBCdqedr1jO0C9AsmS2hY+nc4maICoJxsF/yu+jek=;
  b=j9aC7aoGTfuWbIw/TAIQVuq8xddA8Rb8n9beA0aXGONRREwpxTG9oyvt
   4D3AMLv2r9/7+6gbzecN2gtGfaQfB7tx2gJvcDcQg+9m5jgOxd242UNge
   NsQHRNvSp5dvTSCWDWcD99x71lVGRwUs3Y97uBR4yU0XQs3c3ybNhirKE
   h97erCin87rs3kMoMr4fD5cjYFNE3L6HHcZAs6y59KbTLrsX4oClvKfVH
   4GAvEQQO7egRenHz1VBUPZqrFs5SMYGUwOW9dSILzHD0MsXnVUErYF3pu
   2zCreKpSJdjsEuaRFtqStD+j/uw8RP83Ud8etgzz8M0glhbMqsiV53wpz
   Q==;
X-CSE-ConnectionGUID: Bj0ZAw+4S8alEc+BqUzn2A==
X-CSE-MsgGUID: dYW9bcXHTRiQDttxVLiudw==
X-IronPort-AV: E=McAfee;i="6800,10657,11808"; a="106984303"
X-IronPort-AV: E=Sophos;i="6.24,189,1774335600"; 
   d="scan'208";a="106984303"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2026 19:03:23 -0700
X-CSE-ConnectionGUID: C7bpU9BdRgGkefp6zTbeXw==
X-CSE-MsgGUID: cXD/3oRRRt+UFCF8S4bUGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,189,1774335600"; 
   d="scan'208";a="268683352"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 05 Jun 2026 19:03:21 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wVgNb-00000000Geq-1Mz2;
	Sat, 06 Jun 2026 02:03:19 +0000
Date: Sat, 06 Jun 2026 10:03:02 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:dev] BUILD SUCCESS
 3ca1d19c1971ac4f25478eafb741e726bf2d5954
Message-ID: <202606061053.QGTCGv1e-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
branch HEAD: 3ca1d19c1971ac4f25478eafb741e726bf2d5954  ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers

elapsed time: 1717m

configs tested: 180
configs skipped: 15

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260605    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260605    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                                 defconfig    clang-23
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260605    gcc-13.4.0
arm                            randconfig-002    gcc-15.2.0
arm                   randconfig-002-20260605    gcc-8.5.0
arm                            randconfig-003    clang-23
arm                   randconfig-003-20260605    clang-23
arm                            randconfig-004    gcc-13.4.0
arm                   randconfig-004-20260605    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260605    gcc-9.5.0
arm64                 randconfig-002-20260605    gcc-10.5.0
arm64                 randconfig-003-20260605    gcc-11.5.0
arm64                 randconfig-004-20260605    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260605    gcc-16.1.0
csky                  randconfig-002-20260605    gcc-9.5.0
hexagon                          allmodconfig    clang-23
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260605    clang-20
hexagon               randconfig-002-20260605    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260605    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260605    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260605    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260605    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260605    gcc-12
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260605    gcc-14
i386                                defconfig    clang-22
i386                  randconfig-001-20260605    clang-20
i386                  randconfig-002-20260605    clang-20
i386                  randconfig-003-20260605    gcc-14
i386                  randconfig-004-20260605    gcc-14
i386                  randconfig-005-20260605    clang-20
i386                  randconfig-006-20260605    gcc-14
i386                  randconfig-007-20260605    clang-20
i386                  randconfig-011-20260605    clang-22
i386                  randconfig-012-20260605    clang-22
i386                  randconfig-013-20260605    clang-22
i386                  randconfig-014-20260605    clang-22
i386                  randconfig-015-20260605    clang-22
i386                  randconfig-016-20260605    clang-22
i386                  randconfig-017-20260605    clang-22
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260605    clang-18
loongarch             randconfig-002-20260605    gcc-16.1.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260605    gcc-8.5.0
nios2                 randconfig-002-20260605    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260605    gcc-14.3.0
parisc                randconfig-002-20260605    gcc-12.5.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260605    gcc-8.5.0
powerpc               randconfig-002-20260605    gcc-8.5.0
powerpc64             randconfig-001-20260605    clang-23
powerpc64             randconfig-002-20260605    gcc-8.5.0
riscv                             allnoconfig    gcc-15.2.0
riscv                               defconfig    clang-23
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260605    gcc-8.5.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260605    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-18
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260605    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260605    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-16.1.0
sh                    randconfig-001-20260605    gcc-16.1.0
sh                             randconfig-002    gcc-14.3.0
sh                    randconfig-002-20260605    gcc-10.5.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260605    gcc-15.2.0
sparc                 randconfig-002-20260605    gcc-16.1.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-23
sparc64               randconfig-001-20260605    clang-23
sparc64               randconfig-002-20260605    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260605    clang-19
um                    randconfig-002-20260605    clang-23
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260605    gcc-14
x86_64               buildonly-randconfig-002    clang-20
x86_64      buildonly-randconfig-002-20260605    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260605    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260605    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260605    gcc-14
x86_64               buildonly-randconfig-006    clang-20
x86_64      buildonly-randconfig-006-20260605    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260605    clang-22
x86_64                randconfig-002-20260605    clang-22
x86_64                randconfig-003-20260605    clang-22
x86_64                randconfig-004-20260605    gcc-13
x86_64                randconfig-005-20260605    clang-22
x86_64                randconfig-006-20260605    gcc-14
x86_64                randconfig-011-20260605    clang-22
x86_64                randconfig-012-20260605    gcc-14
x86_64                randconfig-013-20260605    clang-22
x86_64                randconfig-014-20260605    clang-22
x86_64                randconfig-015-20260605    gcc-14
x86_64                randconfig-016-20260605    clang-22
x86_64                randconfig-071-20260605    gcc-14
x86_64                randconfig-072-20260605    gcc-14
x86_64                randconfig-073-20260605    clang-20
x86_64                randconfig-074-20260605    gcc-14
x86_64                randconfig-075-20260605    gcc-12
x86_64                randconfig-076-20260605    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                           alldefconfig    gcc-16.1.0
xtensa                            allnoconfig    gcc-15.2.0
xtensa                randconfig-001-20260605    gcc-8.5.0
xtensa                randconfig-002-20260605    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
