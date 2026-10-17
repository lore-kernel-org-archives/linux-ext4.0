Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F88023EA83
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2026 19:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792265809; cv=none; b=KJ06av85TEuKI6wbD3gVjV7fPZZc5W8hCwnxgep5B46ByYGq2Px5oc+fOdEasTRLz6JK2yO/NYaWQIpOF2IwfAo4q1SqkfIHXB+zbBFfLTAfYWMbyiZpS09U1Y/XzYbS0E1emngvASet+BBhBW8tzSjcn0CYLMu3qCRwAlu0MvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792265809; c=relaxed/simple;
	bh=Oq16Wi+1gYADIIL3T4XPxusZOcdRpra2WI9ysryPNXM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=WRqkbRe3NwY/E2jiMo5dlaCrn+wYpGdtpQJlDxAbz/i7/ZSbsujX6KzTxRD6iXa274KdPWUVbgrqH8z/w0NhF3q17WIziIJY/MkLbZMKsgNpj+XmkerMG3lCvwqBW/jJ4LTSwBggZ3AATUh2kw8z4jVu+5FJzRNlo0krgnLvsDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YHCgcvwp; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YHCgcvwp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792265807; x=1823801807;
  h=date:from:to:cc:subject:message-id;
  bh=Oq16Wi+1gYADIIL3T4XPxusZOcdRpra2WI9ysryPNXM=;
  b=YHCgcvwpaMfoL5yoOddONZiAoMe8pMMRAhFt4IeJZH9/THd/GRTziVR9
   G3mkjJb97owJvsGeb6p5/zxEc6QC4eqWMZk2HOf+trHOohNypBPdeUGek
   5Iq6tBe3sx5DcqNNl3P3pd6BMxFwfigiBfsGG5DdYtphRhdsiu3k6CT0a
   buSS4OeWVne/NBEdpo1NGpW80VYlVeUl/X4388cxkJM//iogvePyUVC6h
   0twoEKdiprIJoRj5sPeVf71Y75zYAy2zigZIxDXrK3N++EQ4rG7ozxELr
   hh1o5RylaFCcckr2X9b03rCch1SrKXC0/Q/iswdnmwe/w0Y9DSr7EpR1F
   Q==;
X-CSE-ConnectionGUID: opOQgc7vTRma3dJVnmDbWQ==
X-CSE-MsgGUID: pDrtEe38R4eyb053sH+VMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11938"; a="903333"
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="903333"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2026 12:36:47 -0700
X-CSE-ConnectionGUID: LCupapa9T+uce+tRwWK2Tg==
X-CSE-MsgGUID: j3ST/QkGTGWxhetYYO5uwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="2126626"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 17 Oct 2026 12:36:45 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIACx-00000000Jey-18A9;
	Sat, 17 Oct 2026 19:36:43 +0000
Date: Sun, 18 Oct 2026 03:36:08 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:dev] BUILD SUCCESS WITH UNVERIFIED WARNING
 8c4f6e3376348fc3162eed86a05b933921c8f9ed
Message-ID: <202610180302.wi6abBJT-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
branch HEAD: 8c4f6e3376348fc3162eed86a05b933921c8f9ed  ext4: introduce a mount option for iomap buffered I/O path

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202610160314.PLMEXaOJ-lkp@intel.com

    fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? 'ret'

Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-2200-20261016
|   `-- fs-ext4-inode.c-ext4_iomap_writepages()-warn:missing-error-code-ret
`-- x86_64-randconfig-2200-20261016
    `-- fs-ext4-inode.c-ext4_iomap_writepages()-warn:missing-error-code-ret

elapsed time: 1809m

configs tested: 352
configs skipped: 2

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2304-20261016    gcc-11.5.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261017    gcc-10.5.0
arc                   randconfig-1001-20261017    gcc-10.5.0
arc                   randconfig-2000-20261016    gcc-8.5.0
arc                   randconfig-2001-20261016    gcc-8.5.0
arc                         vdk_hs38_defconfig    gcc-16.1.0
arm                               alldefconfig    gcc-16.1.0
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                        aspeed_g4_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                       footbridge_defconfig    clang-24
arm                         multi_v5_defconfig    clang-24
arm                        netwinder_defconfig    gcc-16.1.0
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20261017    gcc-10.5.0
arm                   randconfig-1001-20261017    gcc-10.5.0
arm                   randconfig-1002-20261017    gcc-10.5.0
arm                   randconfig-1003-20261017    gcc-10.5.0
arm                   randconfig-2000-20261016    gcc-8.5.0
arm                   randconfig-2001-20261016    gcc-8.5.0
arm                  randconfig-r2101-20261015    clang-24   cocci
arm                  randconfig-r2110-20261016    gcc-8.5.0  cocci
arm                  randconfig-r2305-20261016    gcc-11.5.0 sparse
arm                          socfpga_defconfig    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261017    clang-24
arm64                 randconfig-1000-20261018    gcc-14.3.0
arm64                 randconfig-1001-20261017    clang-24
arm64                 randconfig-1001-20261018    gcc-14.3.0
arm64                 randconfig-1002-20261017    clang-24
arm64                 randconfig-1002-20261018    gcc-14.3.0
arm64                 randconfig-1003-20261017    clang-24
arm64                 randconfig-1003-20261018    gcc-14.3.0
arm64                 randconfig-2000-20261016    gcc-12.5.0
arm64                 randconfig-2000-20261016    gcc-13.4.0
arm64                 randconfig-2001-20261016    clang-18
arm64                 randconfig-2001-20261016    gcc-12.5.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261017    clang-24
csky                  randconfig-1000-20261018    gcc-14.3.0
csky                  randconfig-1001-20261017    clang-24
csky                  randconfig-1001-20261018    gcc-14.3.0
csky                  randconfig-2000-20261016    gcc-12.5.0
csky                  randconfig-2000-20261016    gcc-16.1.0
csky                  randconfig-2001-20261016    gcc-12.5.0
csky                 randconfig-r2102-20261015    gcc-12.5.0 cocci
csky                 randconfig-r2103-20261016    gcc-16.1.0 cocci
csky                 randconfig-r2108-20261016    gcc-16.1.0 cocci
csky                 randconfig-r2109-20261015    gcc-10.5.0 cocci
csky                 randconfig-r2109-20261016    gcc-16.1.0 cocci
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261017    clang-21
hexagon               randconfig-1000-20261018    clang-21
hexagon               randconfig-1001-20261017    clang-21
hexagon               randconfig-1001-20261018    clang-21
hexagon               randconfig-2000-20261016    clang-22
hexagon               randconfig-2000-20261016    gcc-12.5.0
hexagon               randconfig-2001-20261016    clang-22
hexagon               randconfig-2001-20261016    gcc-12.5.0
hexagon              randconfig-r2106-20261016    gcc-8.5.0  cocci
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261017    gcc-14
i386        buildonly-randconfig-1001-20261017    gcc-14
i386        buildonly-randconfig-1002-20261017    gcc-14
i386        buildonly-randconfig-1003-20261017    gcc-14
i386        buildonly-randconfig-1004-20261017    gcc-14
i386        buildonly-randconfig-1005-20261017    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261017    clang-22
i386                  randconfig-1001-20261017    clang-22
i386                  randconfig-1002-20261017    clang-22
i386                  randconfig-1003-20261017    clang-22
i386                  randconfig-1004-20261017    clang-22
i386                  randconfig-1005-20261017    clang-22
i386                  randconfig-1006-20261017    clang-22
i386                  randconfig-1007-20261017    clang-22
i386                  randconfig-1008-20261017    clang-22
i386                  randconfig-1009-20261017    clang-22
i386                  randconfig-1010-20261017    clang-22
i386                  randconfig-1011-20261017    clang-22
i386                  randconfig-1012-20261017    clang-22
i386                  randconfig-1013-20261017    clang-22
i386                  randconfig-2000-20261016    gcc-8.5.0
i386                  randconfig-2001-20261016    gcc-8.5.0
i386                  randconfig-2100-20261016    clang-22   cocci
i386                  randconfig-2101-20261016    clang-22   cocci
i386                  randconfig-2102-20261016    clang-22   cocci
i386                  randconfig-2103-20261016    clang-22   cocci
i386                  randconfig-2104-20261016    clang-22   cocci
i386                  randconfig-2105-20261016    clang-22   cocci
i386                  randconfig-2200-20261016    clang-22   smatch
i386                  randconfig-2300-20261016    clang-22   sparse
i386                  randconfig-2300-20261016    gcc-14     sparse
i386                  randconfig-2301-20261016    clang-22   sparse
i386                  randconfig-2302-20261016    clang-22   sparse
i386                 randconfig-r2301-20261016    gcc-14     sparse
i386                 randconfig-r2308-20261016    gcc-14     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261017    clang-21
loongarch             randconfig-1000-20261018    clang-21
loongarch             randconfig-1001-20261017    clang-21
loongarch             randconfig-1001-20261018    clang-21
loongarch             randconfig-2000-20261016    gcc-11.5.0
loongarch             randconfig-2000-20261016    gcc-16.1.0
loongarch             randconfig-2001-20261016    clang-18
loongarch             randconfig-2001-20261016    gcc-11.5.0
loongarch            randconfig-r2108-20261015    clang-24   cocci
loongarch            randconfig-r2301-20261016    gcc-11.5.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                 randconfig-r2304-20261016    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2104-20261016    gcc-8.5.0  cocci
microblaze           randconfig-r2106-20261016    gcc-14.3.0 cocci
microblaze           randconfig-r2300-20261016    gcc-16.1.0 sparse
microblaze           randconfig-r2306-20261016    gcc-16.1.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                   cavium_octeon_defconfig    clang-24
mips                   cavium_octeon_defconfig    gcc-16.1.0
mips                            ip30_defconfig    clang-24
mips                      loongson2k_defconfig    clang-24
mips                 randconfig-r2110-20261016    gcc-10.5.0 cocci
mips                 randconfig-r2200-20261016    clang-24   smatch
mips                 randconfig-r2302-20261016    clang-17   sparse
mips                    sb1250_swarm_defconfig    clang-24
mips                    sb1250_swarm_defconfig    gcc-16.1.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261017    clang-21
nios2                 randconfig-1000-20261018    clang-21
nios2                 randconfig-1001-20261017    clang-21
nios2                 randconfig-1001-20261018    clang-21
nios2                 randconfig-2000-20261016    gcc-11.5.0
nios2                 randconfig-2000-20261016    gcc-8.5.0
nios2                 randconfig-2001-20261016    gcc-11.5.0
nios2                randconfig-r2107-20261016    gcc-8.5.0  cocci
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2100-20261016    gcc-16.1.0 cocci
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261017    gcc-15.2.0
parisc                randconfig-1000-20261018    clang-24
parisc                randconfig-1001-20261017    gcc-15.2.0
parisc                randconfig-1001-20261018    clang-24
parisc                randconfig-2000-20261016    gcc-11.5.0
parisc                randconfig-2000-20261016    gcc-8.5.0
parisc                randconfig-2001-20261016    gcc-10.5.0
parisc                randconfig-2001-20261016    gcc-11.5.0
parisc               randconfig-r2202-20261016    gcc-8.5.0  smatch
parisc               randconfig-r2305-20261016    gcc-11.5.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                       chrp32_defconfig    clang-24
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261017    gcc-15.2.0
powerpc               randconfig-1000-20261018    clang-24
powerpc               randconfig-1001-20261017    gcc-15.2.0
powerpc               randconfig-1001-20261018    clang-24
powerpc              randconfig-r2103-20261015    clang-21   cocci
powerpc              randconfig-r2105-20261016    gcc-8.5.0  cocci
powerpc              randconfig-r2111-20261016    gcc-8.5.0  cocci
powerpc                     socrates_defconfig    gcc-16.1.0
powerpc                      tqm8548_defconfig    clang-24
powerpc64             randconfig-1000-20261017    gcc-15.2.0
powerpc64             randconfig-1000-20261018    clang-24
powerpc64             randconfig-1001-20261017    gcc-15.2.0
powerpc64             randconfig-1001-20261018    clang-24
powerpc64            randconfig-r2101-20261016    gcc-16.1.0 cocci
powerpc64            randconfig-r2307-20261016    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261017    clang-19
riscv                 randconfig-1000-20261018    clang-17
riscv                 randconfig-1001-20261017    clang-19
riscv                 randconfig-1001-20261018    clang-17
riscv                 randconfig-2000-20261016    clang-24
riscv                 randconfig-2000-20261016    gcc-16.1.0
riscv                 randconfig-2001-20261016    clang-24
riscv                 randconfig-2001-20261016    gcc-16.1.0
riscv                randconfig-r2111-20261016    clang-17   cocci
riscv                randconfig-r2300-20261016    gcc-11.5.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261017    clang-19
s390                  randconfig-1000-20261018    clang-17
s390                  randconfig-1001-20261017    clang-19
s390                  randconfig-1001-20261018    clang-17
s390                  randconfig-2000-20261016    clang-24
s390                  randconfig-2000-20261016    gcc-16.1.0
s390                  randconfig-2001-20261016    gcc-16.1.0
s390                  randconfig-2001-20261016    gcc-8.5.0
s390                 randconfig-r2201-20261016    clang-24   smatch
s390                        zfcpdump_defconfig    gcc-16.1.0
sh                                alldefconfig    gcc-16.1.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                          ap325rxa_defconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                  kfr2r09-romimage_defconfig    clang-24
sh                           lboxre2_defconfig    gcc-16.1.0
sh                             migor_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261017    clang-19
sh                    randconfig-1000-20261018    clang-17
sh                    randconfig-1001-20261017    clang-19
sh                    randconfig-1001-20261018    clang-17
sh                    randconfig-2000-20261016    gcc-16.1.0
sh                    randconfig-2001-20261016    gcc-12.5.0
sh                    randconfig-2001-20261016    gcc-16.1.0
sh                           rsk7264_defconfig    gcc-16.1.0
sh                           rsk7269_defconfig    clang-24
sh                            sh2007_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261017    gcc-15.2.0
sparc                 randconfig-1000-20261018    clang-24
sparc                 randconfig-1001-20261017    gcc-15.2.0
sparc                 randconfig-1001-20261018    clang-24
sparc                 randconfig-2000-20261016    gcc-12.5.0
sparc                 randconfig-2000-20261016    gcc-16.1.0
sparc                 randconfig-2001-20261016    gcc-12.5.0
sparc                randconfig-r2102-20261016    gcc-16.1.0 cocci
sparc                randconfig-r2310-20261016    gcc-8.5.0  sparse
sparc                        sparc32_defconfig    clang-24
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261017    gcc-15.2.0
sparc64               randconfig-1000-20261018    clang-24
sparc64               randconfig-1001-20261017    gcc-15.2.0
sparc64               randconfig-1001-20261018    clang-24
sparc64               randconfig-2000-20261016    clang-24
sparc64               randconfig-2000-20261016    gcc-12.5.0
sparc64               randconfig-2001-20261016    clang-24
sparc64               randconfig-2001-20261016    gcc-12.5.0
sparc64              randconfig-r2104-20261016    gcc-8.5.0  cocci
sparc64              randconfig-r2105-20261016    gcc-8.5.0  cocci
sparc64              randconfig-r2201-20261016    gcc-12.5.0 smatch
sparc64              randconfig-r2311-20261016    clang-21   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261017    gcc-15.2.0
um                    randconfig-1000-20261018    clang-24
um                    randconfig-1001-20261017    gcc-15.2.0
um                    randconfig-1001-20261018    clang-24
um                    randconfig-2000-20261016    clang-17
um                    randconfig-2000-20261016    gcc-12.5.0
um                    randconfig-2001-20261016    gcc-12.5.0
um                    randconfig-2001-20261016    gcc-14
um                   randconfig-r2107-20261016    gcc-8.5.0  cocci
um                   randconfig-r2309-20261016    gcc-14     sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261017    gcc-14
x86_64      buildonly-randconfig-1001-20261017    gcc-14
x86_64      buildonly-randconfig-1002-20261017    gcc-14
x86_64      buildonly-randconfig-1003-20261017    gcc-14
x86_64      buildonly-randconfig-1004-20261017    gcc-14
x86_64      buildonly-randconfig-1005-20261017    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261017    gcc-14
x86_64                randconfig-1001-20261017    gcc-14
x86_64                randconfig-1002-20261017    gcc-14
x86_64                randconfig-1003-20261017    gcc-14
x86_64                randconfig-1004-20261017    gcc-14
x86_64                randconfig-1005-20261017    gcc-14
x86_64                randconfig-1006-20261017    clang-22
x86_64                randconfig-1007-20261017    clang-22
x86_64                randconfig-1008-20261017    clang-22
x86_64                randconfig-1009-20261017    clang-22
x86_64                randconfig-1010-20261017    clang-22
x86_64                randconfig-1011-20261017    clang-22
x86_64                randconfig-1012-20261017    clang-22
x86_64                randconfig-1013-20261017    clang-22
x86_64                randconfig-1014-20261017    clang-22
x86_64                randconfig-1015-20261017    clang-22
x86_64                randconfig-1016-20261017    clang-22
x86_64                randconfig-1017-20261017    clang-22
x86_64                randconfig-2100-20261016    clang-22   cocci
x86_64                randconfig-2101-20261016    clang-22   cocci
x86_64                randconfig-2102-20261016    clang-22   cocci
x86_64                randconfig-2103-20261016    clang-22   cocci
x86_64                randconfig-2104-20261016    clang-22   cocci
x86_64                randconfig-2105-20261016    clang-22   cocci
x86_64                randconfig-2200-20261016    gcc-14     smatch
x86_64                randconfig-2300-20261016    clang-22   sparse
x86_64                randconfig-2301-20261016    clang-22   sparse
x86_64                randconfig-2302-20261016    clang-22   sparse
x86_64               randconfig-r2100-20261015    gcc-14     cocci
x86_64               randconfig-r2303-20261016    clang-22   sparse
x86_64               randconfig-r2303-20261016    gcc-11.5.0 sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261017    gcc-15.2.0
xtensa                randconfig-1000-20261018    clang-24
xtensa                randconfig-1001-20261017    gcc-15.2.0
xtensa                randconfig-1001-20261018    clang-24
xtensa                randconfig-2000-20261016    gcc-12.5.0
xtensa                randconfig-2001-20261016    gcc-10.5.0
xtensa                randconfig-2001-20261016    gcc-12.5.0
xtensa               randconfig-r2302-20261016    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
