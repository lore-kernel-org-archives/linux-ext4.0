Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794613432;
	b=Rg0eWyEj81FKurALY5/O28GxSxXtdOSt6s20CYPA54s2cQoAACSXrohh3HX0O41Im3JL
	 MAou7L2CoPaeQIKphkVeeLb5eA1eiGdIiRMwNcttpPldlit9V62XP0iW8N3jsJRJb059e
	 GfHtlFBHr20nbLwtOqq6ZAEWCfs4rGwEkjR8ADpmtrXuXX0lVUwjQxWp8p1VmE8xWPjhY
	 g86lFoY3sAfzLalkv5c4y3ehbOHQabNlIdTSgp5eKX13YCrJHOVAzyy4Hj3fI09cSloow
	 MKZeoiX141GMvaxQBX1JR7SLn6kIAtcEs1OsY0jwjxHFpwTk8iVxDP4iWtJ6gAoI/1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794613432;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=n07C+W9dkrNvAD7n46BORviz7GTMZGWe2LVp7sd53mg=;
	b=fFdlYxbhRAF+izmJCbDN1mAShLnKAjNo2JMELSeNZfmoQXvwygZKqa9zj2laKI8spjuC
	 9EszD8Jid3CJqFohwDTd1DGz4aCCJFNyfLb0i7lhX8qAe61thd/zN7+DwoXZOSL3N7QBJ
	 uDEmLtjt+cN87sHuVlKSbjIySHu2gdBD0NsONyc4OWVePlJhRi8hq6Av3faWmZtLByL75
	 Nu660PaIMUizLSCqQtydFiVxaOdB2eIczMADE3zvrWU3PbKhnycscp7sWHCnnXYW3JM8D
	 zoG0s7Gncp0pGozjNQRu82C99l60Dy/fg1/ALv1zozDqrwH4sFaH2YDJLSmsKGE1OyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YC0ElAAu;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8FC606A327
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 23:43:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F8FC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YC0ElAAu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794613429; x=1826149429;
  h=date:from:to:cc:subject:message-id;
  bh=8l9odOf5cL+qpZK9Js4bFkO760a6XJudtxR/+rUrz7s=;
  b=YC0ElAAu66eA8HoJZHYwZ8xRzMdysda5w6p90MbmMVTVVGSvjPh7K9yb
   wTaDNCjPCrTHGxiOAtrBEHAS4yyqPxOiIKltcM6cThNN9x4tcEN3mnJGD
   9+1xKPX42QEKprW3dqqazEjf1zQNDQns9/yTgErFQDDI6FYZI4gasHvVi
   OXndy25grzS4hOpCu9dcXYkACkbmd8ExxSL+crYZxfdj0rUn14FGWelKT
   QTOUoyjnMHzZJsG7pFowhuMb06nmn13WXQN+6U8OgO6e7vr2zEKMIdgBq
   PGcTgwMWFZ6SweIIS0kJaYxiTbA9CghzsZYMt+rmbbNwHx4BCLnardUUC
   A==;
X-CSE-ConnectionGUID: CCzPGGH/Q9SL/ydqzk0XaQ==
X-CSE-MsgGUID: LqaLx9cUQLeP/Vq5eOkQkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3306311"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3306311"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 15:43:48 -0800
X-CSE-ConnectionGUID: VF2L4DMiSR2j2RR5dDzk6g==
X-CSE-MsgGUID: 1KOmr/JYRRi39W0S86dtKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9364782"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2026 15:43:47 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xS0vo-000000014Rn-2Qms;
	Fri, 13 Nov 2026 23:43:44 +0000
Date: Sat, 14 Nov 2026 07:42:59 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:ext4-kunit-tests-merge] BUILD SUCCESS WITH
 WARNING dcc7bd2c6faf98be5a218685b4b969e95df06143
Message-ID: <20261114074259.3oFm7KyU-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext4-kunit-tests-merge
branch HEAD: dcc7bd2c6faf98be5a218685b4b969e95df06143  Merge tag 'v7.4-rc2' into ext4-kunit-tests-merge

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202611132233.Y7jJpjlY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611140347.nhCPe9Sx-lkp@intel.com

    fs/ext4/namei-test.c:2229:1: warning: the frame size of 1288 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/namei-test.c:2229:1: warning: the frame size of 1904 bytes is larger than 1536 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 1600 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 1632 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 1684 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 1828 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 1832 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 2000 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 2112 bytes is larger than 2048 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 2144 bytes is larger than 1536 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 2336 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 2880 bytes is larger than 2048 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 3008 bytes is larger than 2048 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 3328 bytes is larger than 2048 bytes [-Wframe-larger-than=]
    fs/ext4/xattr-test.c:1663:1: warning: the frame size of 3608 bytes is larger than 2048 bytes [-Wframe-larger-than=]

Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- arc-allmodconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- arc-allyesconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- arm64-allmodconfig
|   |-- fs-ext4-fast_commit-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_fc_init_and_eligibility
|   |-- fs-ext4-fast_commit-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_fc_replay_inode_and_dentries
|   |-- fs-ext4-namei-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_namei_rename_and_exchange
|   `-- fs-ext4-xattr-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_xattr_credits_usage_expand_and_delete
|-- arm-allyesconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- csky-allmodconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- microblaze-allyesconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- mips-allmodconfig
|   |-- fs-ext4-namei-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- mips-allyesconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- openrisc-allmodconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- powerpc-allmodconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- s390-allyesconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- sh-allmodconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- sh-allyesconfig
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- sparc64-allmodconfig
|   |-- fs-ext4-fast_commit-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_fc_replay_inode_and_dentries
|   `-- fs-ext4-namei-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_namei_rename_and_exchange
|-- um-allmodconfig
|   |-- fs-ext4-fast_commit-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_fc_init_and_eligibility
|   |-- fs-ext4-fast_commit-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_fc_replay_inode_and_dentries
|   |-- fs-ext4-namei-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_namei_rename_and_exchange
|   `-- fs-ext4-xattr-test.c:warning:stack-frame-size-()-exceeds-limit-()-in-test_xattr_credits_usage_expand_and_delete
|-- um-allyesconfig
|   |-- fs-ext4-namei-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- x86_64-rhel-9.4-kunit
|   `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
`-- xtensa-allyesconfig
    |-- fs-ext4-namei-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
    `-- fs-ext4-xattr-test.c:warning:the-frame-size-of-bytes-is-larger-than-bytes

elapsed time: 2371m

configs tested: 110
configs skipped: 2

tested configs:
alpha                    allnoconfig    gcc-16.2.0
alpha                   allyesconfig    gcc-16.2.0
alpha                      defconfig    gcc-16.2.0
arc                     allmodconfig    clang-24
arc                      allnoconfig    gcc-16.2.0
arc                     allyesconfig    clang-24
arc                        defconfig    gcc-16.2.0
arc         randconfig-1000-20261113    gcc-10.5.0
arc         randconfig-1001-20261113    gcc-10.5.0
arm                      allnoconfig    gcc-16.2.0
arm                     allyesconfig    clang-24
arm                        defconfig    gcc-16.2.0
arm         randconfig-1000-20261113    gcc-10.5.0
arm         randconfig-1001-20261113    gcc-10.5.0
arm         randconfig-1002-20261113    gcc-10.5.0
arm         randconfig-1003-20261113    gcc-10.5.0
arm64                   allmodconfig    clang-24
arm64                    allnoconfig    gcc-16.2.0
arm64                      defconfig    gcc-16.2.0
csky                    allmodconfig    gcc-16.2.0
csky                     allnoconfig    gcc-16.2.0
csky                       defconfig    gcc-16.2.0
hexagon                 allmodconfig    gcc-16.2.0
hexagon                  allnoconfig    gcc-16.2.0
hexagon                    defconfig    gcc-16.2.0
hexagon     randconfig-1000-20261114    clang-24
hexagon     randconfig-1001-20261114    clang-24
i386                    allmodconfig    clang-22
i386                     allnoconfig    gcc-16.2.0
i386                    allyesconfig    clang-22
i386                       defconfig    gcc-16.2.0
i386        randconfig-1000-20261113    clang-22
i386        randconfig-1001-20261113    clang-22
i386        randconfig-1002-20261113    clang-22
i386        randconfig-1003-20261113    clang-22
i386        randconfig-1004-20261113    clang-22
i386        randconfig-1005-20261113    clang-22
i386        randconfig-1006-20261113    clang-22
loongarch               allmodconfig    clang-24
loongarch                allnoconfig    gcc-16.2.0
loongarch   randconfig-1000-20261114    clang-24
loongarch   randconfig-1001-20261114    clang-24
m68k                    allmodconfig    gcc-16.2.0
m68k                     allnoconfig    gcc-16.2.0
m68k                    allyesconfig    clang-24
microblaze               allnoconfig    gcc-16.2.0
microblaze              allyesconfig    gcc-16.2.0
mips                    allmodconfig    gcc-16.2.0
mips                     allnoconfig    gcc-16.2.0
mips                    allyesconfig    gcc-16.2.0
nios2                   allmodconfig    clang-20
nios2                    allnoconfig    clang-24
nios2       randconfig-1000-20261114    clang-24
nios2       randconfig-1001-20261114    clang-24
openrisc                allmodconfig    clang-20
openrisc                 allnoconfig    clang-24
parisc                  allmodconfig    gcc-16.2.0
parisc                   allnoconfig    clang-24
parisc                  allyesconfig    clang-17
parisc      randconfig-1000-20261114    gcc-8.5.0
parisc      randconfig-1001-20261114    gcc-8.5.0
powerpc                 allmodconfig    gcc-16.2.0
powerpc                  allnoconfig    clang-24
powerpc     randconfig-1000-20261114    gcc-8.5.0
powerpc     randconfig-1001-20261114    gcc-8.5.0
powerpc64   randconfig-1000-20261114    gcc-8.5.0
powerpc64   randconfig-1001-20261114    gcc-8.5.0
riscv                   allmodconfig    clang-24
riscv                    allnoconfig    clang-24
riscv                   allyesconfig    clang-24
s390                    allmodconfig    clang-17
s390                     allnoconfig    clang-24
s390                    allyesconfig    gcc-16.2.0
sh                      allmodconfig    gcc-16.2.0
sh                       allnoconfig    clang-24
sh                      allyesconfig    clang-17
sh                         defconfig    gcc-14
sparc                    allnoconfig    clang-24
sparc64                 allmodconfig    clang-20
sparc64                    defconfig    gcc-14
um                      allmodconfig    clang-17
um                       allnoconfig    clang-24
um                      allyesconfig    gcc-16.2.0
um                         defconfig    gcc-14
um                    i386_defconfig    gcc-14
um                  x86_64_defconfig    gcc-14
x86_64                   allnoconfig    clang-24
x86_64                     defconfig    gcc-14
x86_64                         kexec    clang-22
x86_64      randconfig-1000-20261114    gcc-14
x86_64      randconfig-1001-20261114    gcc-14
x86_64      randconfig-1002-20261114    gcc-14
x86_64      randconfig-1003-20261114    gcc-14
x86_64      randconfig-1004-20261114    gcc-14
x86_64      randconfig-1005-20261114    gcc-14
x86_64      randconfig-1006-20261113    clang-22
x86_64      randconfig-1007-20261113    clang-22
x86_64      randconfig-1008-20261113    clang-22
x86_64      randconfig-1009-20261113    clang-22
x86_64      randconfig-1010-20261113    clang-22
x86_64      randconfig-1011-20261113    clang-22
x86_64                      rhel-9.4    clang-22
x86_64                  rhel-9.4-bpf    gcc-14
x86_64                 rhel-9.4-func    clang-22
x86_64           rhel-9.4-kselftests    clang-22
x86_64                rhel-9.4-kunit    gcc-14
x86_64                  rhel-9.4-ltp    gcc-14
x86_64                 rhel-9.4-rust    clang-22
xtensa                   allnoconfig    clang-24
xtensa                  allyesconfig    clang-20

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
