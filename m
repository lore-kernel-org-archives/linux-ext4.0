Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795774832;
	b=k5/KWw1zTbiUWW3pvndHMeOT11zA3tcfumTOIkAq38Yf8KwzabJN1XQ26pI4Mvvjdhpz
	 IOUduxZDRCSJZY/2PX6c6zc1976Ii2YLfTloDzT4t7C2sCzSRJlnl4qYbepU0WfSUq/Zo
	 NFheBqyfgYzmHKBiNr4+/pg9sFTZkJawTh9L/arxN5tr2D1NLBT0lih3ttB49leXwXV4o
	 EBM3iVYuoFQ0Zy5QueXEpecCyytXZOgYz+U6fHmL0EQce1DYN2X/4veVXUaBjV+6UGgCx
	 yfjjxtvXztys2FolS7JMiz3h6V3jtWqnD0zqDYqxP6jHfzkYx5A6ZrIzRkG3G3Riuaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795774832;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=wzLkp2f27OBw1I/dj8Kr6KqbXy8Z1+AaPbtqiAVVLRY=;
	b=lWvSqOPvDlQTJcQLG/XRzQ6r9gdXMaNCmh6hLQVCTE/TcQ5av/ZGuFj0tb4qjApQDRbb
	 KVp6KttWR/Nr4dDIYVjgh2e6omfdMNed0jQhwz+/xhTxaNQr4lTS2P2B/+SvdHitJRAcc
	 9DU0wextyxKurtI2aDfFpYFAEwgOQPzzViUBZNcNqIkAlOtRrJ/FpRNLt2CZcc4j2Tgtx
	 pqfqN0XvlknUmFflJQL2vI9awnE6nmHCopnAW6yiPrh8PMTd+tGhA3cSXWQboa26AejOT
	 HNmhlLPjHf4rAahL4kHOz/wUk2jO1eKz/+5Rf8gLqTHHJKpbmOIKfhrIL2ow2MeJzpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PyfUOayq;
	arc=none smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A159606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 10:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A159606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PyfUOayq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795774832; x=1827310832;
  h=date:from:to:cc:subject:message-id;
  bh=JXk1vWP5oizTIm9oAgb4mj/fDzSttosQJx6010r5qxM=;
  b=PyfUOayqr7VJzzn0pqzXdjmP7Lx/7YLOTwuwmU1H1bLYg0WSJ/dHVWJm
   ZqXCmd/647FFmAXXptrPMgUegWkJzxjVBFsNn/d2Wcn6e38ix/QXFn2Ne
   gIvlcdKvO6u6u6eGqtlZMJRABNWYSKhr8BlaJ+jC9pi6qP5p6+iBbJDXV
   QDKEZFb4pHaGtOBbtmeagcTavDroqURgiZR6MB59lFeKrx9sNVQnim3fO
   H05rweIFZWoq+3kFxGUP/OnmyzORBv6KNAg/X7bvrnp5EH9X0rh95bNGy
   2f6Fg1I9gUD38xsVRkQVnpYH4Flq5Sry5Qw6xARpV91t/2EInXsQvQK/O
   A==;
X-CSE-ConnectionGUID: Jv+gMAdeTv2bW5iEW0e11Q==
X-CSE-MsgGUID: y3UxB0rDTBWrSf2j3/bWQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="4529303"
X-IronPort-AV: E=Sophos;i="6.27,236,1787036400"; 
   d="scan'208";a="4529303"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 02:20:31 -0800
X-CSE-ConnectionGUID: mBSzj508R4ONoC6NssLaow==
X-CSE-MsgGUID: u5ND3DjaTyeyYmOOUu/HmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,236,1787036400"; 
   d="scan'208";a="12370546"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 27 Nov 2026 02:20:29 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWt46-00000001Vpc-39cQ;
	Fri, 27 Nov 2026 10:20:26 +0000
Date: Fri, 27 Nov 2026 18:19:56 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:dev] BUILD SUCCESS
 aceadbccd428fb8e6593b27a3091d961f80225d1
Message-ID: <20261127181956.Nx9mZKl9-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
branch HEAD: aceadbccd428fb8e6593b27a3091d961f80225d1  ext4: don't track metadata buffers on an inode during fast commit replay

elapsed time: 845m

configs tested: 487
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261126    gcc-13.5.0
alpha                 randconfig-2001-20261126    gcc-13.5.0
alpha                 randconfig-2200-20261126    gcc-9.5.0  smatch
alpha                randconfig-r2107-20261126    gcc-14     cocci
alpha                randconfig-r2108-20261126    gcc-11.5.0 cocci
alpha                randconfig-r2111-20261126    gcc-14.4.0 cocci
alpha                randconfig-r2302-20261126    gcc-11.5.0 sparse
alpha                randconfig-r2302-20261126    gcc-15.3.0 sparse
alpha                randconfig-r2307-20261126    gcc-12.5.0 sparse
alpha                randconfig-r2308-20261126    gcc-8.5.0  sparse
alpha                randconfig-r2310-20261126    gcc-10.5.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                      nsimosci_hs_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261127    gcc-8.5.0
arc                   randconfig-1001-20261127    gcc-8.5.0
arc                   randconfig-2000-20261126    gcc-9.5.0
arc                   randconfig-2001-20261126    gcc-9.5.0
arc                   randconfig-2002-20261126    gcc-9.5.0
arc                   randconfig-2003-20261126    gcc-9.5.0
arc                   randconfig-2004-20261126    gcc-9.5.0
arc                   randconfig-2005-20261126    gcc-9.5.0
arc                   randconfig-2200-20261126    gcc-8.5.0  smatch
arc                  randconfig-r2106-20261126    gcc-14     cocci
arc                  randconfig-r2108-20261126    gcc-14     cocci
arc                  randconfig-r2110-20261126    gcc-14     cocci
arc                  randconfig-r2111-20261126    gcc-14     cocci
arc                  randconfig-r2309-20261126    gcc-12.5.0 sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                      am200epdkit_defconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                             dove_defconfig    gcc-16.2.0
arm                    milbeaut_m10v_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261127    gcc-8.5.0
arm                   randconfig-1001-20261127    gcc-8.5.0
arm                   randconfig-1002-20261127    gcc-8.5.0
arm                   randconfig-1003-20261127    gcc-8.5.0
arm                   randconfig-2000-20261126    gcc-11.5.0
arm                   randconfig-2001-20261126    gcc-11.5.0
arm                   randconfig-2002-20261126    gcc-11.5.0
arm                   randconfig-2200-20261126    gcc-8.5.0  smatch
arm                  randconfig-r2100-20261126    gcc-8.5.0  cocci
arm                  randconfig-r2101-20261126    clang-24   cocci
arm                  randconfig-r2105-20261126    gcc-8.5.0  cocci
arm                  randconfig-r2107-20261126    gcc-14     cocci
arm                  randconfig-r2110-20261126    gcc-11.5.0 cocci
arm                  randconfig-r2111-20261126    gcc-11.5.0 cocci
arm                  randconfig-r2301-20261126    clang-18   sparse
arm                  randconfig-r2304-20261126    clang-24   sparse
arm                  randconfig-r2309-20261126    gcc-12.5.0 sparse
arm                  randconfig-r2310-20261126    gcc-12.5.0 sparse
arm                         realview_defconfig    gcc-16.2.0
arm                          s5pv210_defconfig    gcc-16.2.0
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261127    gcc-8.5.0
arm64                 randconfig-1001-20261127    gcc-8.5.0
arm64                 randconfig-1002-20261127    gcc-8.5.0
arm64                 randconfig-1003-20261127    gcc-8.5.0
arm64                 randconfig-2000-20261126    gcc-11.5.0
arm64                 randconfig-2001-20261126    gcc-11.5.0
arm64                 randconfig-2002-20261126    gcc-11.5.0
arm64                 randconfig-2200-20261126    clang-24   smatch
arm64                randconfig-r2101-20261126    gcc-8.5.0  cocci
arm64                randconfig-r2103-20261126    clang-24   cocci
arm64                randconfig-r2107-20261126    gcc-10.5.0 cocci
arm64                randconfig-r2107-20261126    gcc-15.3.0 cocci
arm64                randconfig-r2109-20261126    gcc-11.5.0 cocci
arm64                randconfig-r2300-20261126    clang-24   sparse
arm64                randconfig-r2300-20261126    gcc-16.2.0 sparse
arm64                randconfig-r2301-20261126    clang-20   sparse
arm64                randconfig-r2308-20261126    clang-22   sparse
arm64                randconfig-r2308-20261126    clang-24   sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261127    gcc-8.5.0
csky                  randconfig-1001-20261127    gcc-8.5.0
csky                  randconfig-2000-20261126    gcc-13.5.0
csky                  randconfig-2001-20261126    gcc-13.5.0
csky                  randconfig-2200-20261126    gcc-13.5.0 smatch
csky                 randconfig-r2100-20261126    gcc-9.5.0  cocci
csky                 randconfig-r2102-20261126    clang-24   cocci
csky                 randconfig-r2102-20261126    gcc-14.4.0 cocci
csky                 randconfig-r2103-20261126    gcc-13     cocci
csky                 randconfig-r2107-20261126    gcc-10.5.0 cocci
csky                 randconfig-r2110-20261126    gcc-10.5.0 cocci
csky                 randconfig-r2111-20261126    gcc-10.5.0 cocci
csky                 randconfig-r2300-20261126    clang-20   sparse
csky                 randconfig-r2304-20261126    gcc-12.5.0 sparse
csky                 randconfig-r2306-20261126    gcc-12.5.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261127    gcc-9.5.0
hexagon               randconfig-1001-20261127    gcc-9.5.0
hexagon               randconfig-2000-20261126    gcc-13.5.0
hexagon               randconfig-2001-20261126    gcc-13.5.0
hexagon               randconfig-2200-20261126    clang-17   smatch
hexagon              randconfig-r2102-20261126    gcc-13     cocci
hexagon              randconfig-r2104-20261126    gcc-8.5.0  cocci
hexagon              randconfig-r2106-20261126    gcc-10.5.0 cocci
hexagon              randconfig-r2108-20261126    gcc-10.5.0 cocci
hexagon              randconfig-r2108-20261126    gcc-14.4.0 cocci
hexagon              randconfig-r2302-20261126    gcc-9.5.0  sparse
hexagon              randconfig-r2305-20261126    gcc-16.2.0 sparse
hexagon              randconfig-r2307-20261126    gcc-12.5.0 sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261127    clang-22
i386        buildonly-randconfig-1001-20261127    clang-22
i386        buildonly-randconfig-1002-20261127    clang-22
i386        buildonly-randconfig-1003-20261127    clang-22
i386        buildonly-randconfig-1004-20261127    clang-22
i386        buildonly-randconfig-1005-20261127    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261127    clang-22
i386                  randconfig-1001-20261127    clang-22
i386                  randconfig-1002-20261127    clang-22
i386                  randconfig-1003-20261127    clang-22
i386                  randconfig-1004-20261127    clang-22
i386                  randconfig-1005-20261127    clang-22
i386                  randconfig-1006-20261127    clang-22
i386                  randconfig-2000-20261126    clang-22
i386                  randconfig-2001-20261126    clang-22
i386                  randconfig-2002-20261126    clang-22
i386                  randconfig-2003-20261126    clang-22
i386                  randconfig-2004-20261126    clang-22
i386                  randconfig-2005-20261126    clang-22
i386                  randconfig-2100-20261126    clang-22   cocci
i386                  randconfig-2101-20261126    clang-22   cocci
i386                  randconfig-2102-20261126    clang-22   cocci
i386                  randconfig-2103-20261126    clang-22   cocci
i386                  randconfig-2104-20261126    clang-22   cocci
i386                  randconfig-2105-20261126    clang-22   cocci
i386                  randconfig-2200-20261126    gcc-14     smatch
i386                  randconfig-2300-20261126    gcc-14     sparse
i386                  randconfig-2301-20261126    gcc-14     sparse
i386                  randconfig-2302-20261126    gcc-14     sparse
i386                 randconfig-r2100-20261126    gcc-13     cocci
i386                 randconfig-r2102-20261126    clang-18   cocci
i386                 randconfig-r2110-20261126    gcc-14     cocci
i386                 randconfig-r2110-20261126    gcc-14.4.0 cocci
i386                 randconfig-r2300-20261126    gcc-12.5.0 sparse
i386                 randconfig-r2302-20261126    clang-24   sparse
i386                 randconfig-r2302-20261126    gcc-16.2.0 sparse
i386                 randconfig-r2306-20261126    clang-22   sparse
i386                 randconfig-r2309-20261126    clang-22   sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261127    gcc-9.5.0
loongarch             randconfig-1001-20261127    gcc-9.5.0
loongarch             randconfig-2000-20261126    gcc-12.5.0
loongarch             randconfig-2001-20261126    gcc-12.5.0
loongarch             randconfig-2200-20261126    gcc-14.4.0 smatch
loongarch            randconfig-r2101-20261126    clang-24   cocci
loongarch            randconfig-r2101-20261126    gcc-13     cocci
loongarch            randconfig-r2102-20261126    clang-24   cocci
loongarch            randconfig-r2106-20261126    gcc-11.5.0 cocci
loongarch            randconfig-r2107-20261126    gcc-11.5.0 cocci
loongarch            randconfig-r2108-20261126    gcc-10.5.0 cocci
loongarch            randconfig-r2301-20261126    gcc-16.2.0 sparse
loongarch            randconfig-r2307-20261126    gcc-10.5.0 sparse
loongarch            randconfig-r2307-20261126    gcc-8.5.0  sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                         m5407c3_defconfig    gcc-16.2.0
m68k                             q40_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261126    gcc-13.5.0
m68k                  randconfig-2001-20261126    gcc-13.5.0
m68k                 randconfig-r2104-20261126    gcc-8.5.0  cocci
m68k                 randconfig-r2105-20261126    gcc-14.4.0 cocci
m68k                 randconfig-r2106-20261126    gcc-14.4.0 cocci
m68k                 randconfig-r2108-20261126    gcc-15.3.0 cocci
m68k                 randconfig-r2301-20261126    gcc-15.3.0 sparse
m68k                 randconfig-r2302-20261126    gcc-12.5.0 sparse
m68k                 randconfig-r2304-20261126    gcc-9.5.0  sparse
m68k                 randconfig-r2311-20261126    gcc-12.5.0 sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261126    gcc-13.5.0
microblaze            randconfig-2001-20261126    gcc-13.5.0
microblaze            randconfig-2200-20261126    gcc-9.5.0  smatch
microblaze           randconfig-r2100-20261126    clang-24   cocci
microblaze           randconfig-r2102-20261126    gcc-8.5.0  cocci
microblaze           randconfig-r2103-20261126    gcc-9.5.0  cocci
microblaze           randconfig-r2105-20261126    gcc-8.5.0  cocci
microblaze           randconfig-r2108-20261126    gcc-11.5.0 cocci
microblaze           randconfig-r2301-20261126    gcc-12.5.0 sparse
microblaze           randconfig-r2305-20261126    gcc-9.5.0  sparse
microblaze           randconfig-r2308-20261126    gcc-12.5.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                        bmips_be_defconfig    gcc-16.2.0
mips                      decstation_defconfig    gcc-16.2.0
mips                  decstation_r4k_defconfig    gcc-16.2.0
mips                             gpr_defconfig    gcc-16.2.0
mips                            ip27_defconfig    gcc-16.2.0
mips                            ip30_defconfig    gcc-16.2.0
mips                         maltaup_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261126    gcc-16.2.0
mips                  randconfig-2001-20261126    gcc-16.2.0
mips                  randconfig-2002-20261126    gcc-16.2.0
mips                 randconfig-r2101-20261126    gcc-8.5.0  cocci
mips                 randconfig-r2101-20261126    gcc-9.5.0  cocci
mips                 randconfig-r2106-20261126    gcc-14     cocci
mips                 randconfig-r2301-20261126    gcc-9.5.0  sparse
mips                 randconfig-r2303-20261126    clang-20   sparse
mips                 randconfig-r2306-20261126    gcc-12.5.0 sparse
mips                 randconfig-r2307-20261126    clang-22   sparse
nios2                             alldefconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261127    gcc-9.5.0
nios2                 randconfig-1001-20261127    gcc-9.5.0
nios2                 randconfig-2000-20261126    gcc-12.5.0
nios2                 randconfig-2001-20261126    gcc-12.5.0
nios2                 randconfig-2200-20261126    gcc-9.5.0  smatch
nios2                randconfig-r2101-20261126    gcc-8.5.0  cocci
nios2                randconfig-r2105-20261126    gcc-9.5.0  cocci
nios2                randconfig-r2107-20261126    gcc-14     cocci
nios2                randconfig-r2110-20261126    gcc-15.3.0 cocci
nios2                randconfig-r2308-20261126    gcc-10.5.0 sparse
nios2                randconfig-r2309-20261126    clang-18   sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc              randconfig-2000-20261126    gcc-16.2.0
openrisc              randconfig-2001-20261126    gcc-16.2.0
openrisc              randconfig-2002-20261126    gcc-16.2.0
openrisc              randconfig-2200-20261126    gcc-9.5.0  smatch
openrisc             randconfig-r2100-20261126    clang-18   cocci
openrisc             randconfig-r2100-20261126    gcc-14.4.0 cocci
openrisc             randconfig-r2101-20261126    clang-18   cocci
openrisc             randconfig-r2109-20261126    gcc-10.5.0 cocci
openrisc             randconfig-r2109-20261126    gcc-15.3.0 cocci
openrisc             randconfig-r2300-20261126    gcc-9.5.0  sparse
openrisc             randconfig-r2303-20261126    gcc-16.2.0 sparse
openrisc             randconfig-r2306-20261126    gcc-10.5.0 sparse
openrisc             randconfig-r2310-20261126    clang-24   sparse
openrisc             randconfig-r2311-20261126    gcc-10.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                 generic-32bit_defconfig    gcc-16.2.0
parisc                randconfig-1000-20261127    gcc-12.5.0
parisc                randconfig-1001-20261127    gcc-12.5.0
parisc                randconfig-2000-20261126    gcc-12.5.0
parisc                randconfig-2001-20261126    gcc-12.5.0
parisc                randconfig-2200-20261126    gcc-15.3.0 smatch
parisc               randconfig-r2104-20261126    clang-18   cocci
parisc               randconfig-r2107-20261126    gcc-11.5.0 cocci
parisc               randconfig-r2111-20261126    gcc-10.5.0 cocci
parisc               randconfig-r2111-20261126    gcc-14     cocci
parisc               randconfig-r2305-20261126    gcc-15.3.0 sparse
parisc               randconfig-r2306-20261126    gcc-12.5.0 sparse
parisc               randconfig-r2307-20261126    clang-18   sparse
parisc               randconfig-r2310-20261126    clang-18   sparse
parisc               randconfig-r2310-20261126    gcc-12.5.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                    bluestone_defconfig    gcc-16.2.0
powerpc                      ksi8560_defconfig    gcc-16.2.0
powerpc                      mpc512x_defconfig    gcc-16.2.0
powerpc                  mpc834x_itx_defconfig    gcc-16.2.0
powerpc                          ps3_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261127    gcc-12.5.0
powerpc               randconfig-1001-20261127    gcc-12.5.0
powerpc               randconfig-2000-20261126    clang-24
powerpc               randconfig-2001-20261126    clang-24
powerpc               randconfig-2002-20261126    clang-24
powerpc               randconfig-2200-20261126    clang-24   smatch
powerpc              randconfig-r2100-20261126    gcc-8.5.0  cocci
powerpc              randconfig-r2101-20261126    gcc-14.4.0 cocci
powerpc              randconfig-r2103-20261126    clang-18   cocci
powerpc              randconfig-r2104-20261126    gcc-14.4.0 cocci
powerpc              randconfig-r2106-20261126    gcc-15.3.0 cocci
powerpc              randconfig-r2109-20261126    gcc-10.5.0 cocci
powerpc              randconfig-r2304-20261126    clang-18   sparse
powerpc              randconfig-r2304-20261126    gcc-16.2.0 sparse
powerpc              randconfig-r2305-20261126    clang-18   sparse
powerpc              randconfig-r2305-20261126    gcc-11.5.0 sparse
powerpc              randconfig-r2311-20261126    gcc-12.5.0 sparse
powerpc                          wii_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261127    gcc-12.5.0
powerpc64             randconfig-1001-20261127    gcc-12.5.0
powerpc64             randconfig-2000-20261126    clang-24
powerpc64             randconfig-2001-20261126    clang-24
powerpc64             randconfig-2002-20261126    clang-24
powerpc64             randconfig-2200-20261126    clang-24   smatch
powerpc64            randconfig-r2104-20261126    clang-24   cocci
powerpc64            randconfig-r2104-20261126    gcc-9.5.0  cocci
powerpc64            randconfig-r2105-20261126    gcc-8.5.0  cocci
powerpc64            randconfig-r2307-20261126    clang-24   sparse
powerpc64            randconfig-r2307-20261126    gcc-12.5.0 sparse
powerpc64            randconfig-r2308-20261126    clang-18   sparse
powerpc64            randconfig-r2310-20261126    clang-22   sparse
powerpc64            randconfig-r2311-20261126    clang-18   sparse
powerpc64            randconfig-r2311-20261126    clang-22   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                     nommu_k210_defconfig    gcc-16.2.0
riscv                 randconfig-2000-20261126    gcc-10.5.0
riscv                 randconfig-2001-20261126    gcc-10.5.0
riscv                 randconfig-2002-20261126    gcc-10.5.0
riscv                 randconfig-2003-20261126    gcc-10.5.0
riscv                 randconfig-2004-20261126    gcc-10.5.0
riscv                 randconfig-2005-20261126    gcc-10.5.0
riscv                 randconfig-2200-20261126    gcc-8.5.0  smatch
riscv                randconfig-r2110-20261126    gcc-11.5.0 cocci
riscv                randconfig-r2303-20261126    gcc-9.5.0  sparse
riscv                randconfig-r2309-20261126    clang-24   sparse
riscv                randconfig-r2309-20261126    gcc-8.5.0  sparse
riscv                randconfig-r2310-20261126    gcc-12.5.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                  randconfig-2000-20261126    clang-24
s390                  randconfig-2001-20261126    clang-24
s390                  randconfig-2002-20261126    clang-24
s390                  randconfig-2003-20261126    clang-24
s390                  randconfig-2004-20261126    clang-24
s390                  randconfig-2005-20261126    clang-24
s390                  randconfig-2200-20261126    gcc-16.2.0 smatch
s390                 randconfig-r2102-20261126    gcc-8.5.0  cocci
s390                 randconfig-r2105-20261126    clang-24   cocci
s390                 randconfig-r2108-20261126    gcc-14     cocci
s390                 randconfig-r2109-20261126    gcc-14.4.0 cocci
s390                 randconfig-r2110-20261126    gcc-14     cocci
s390                 randconfig-r2111-20261126    gcc-15.3.0 cocci
s390                 randconfig-r2303-20261126    gcc-12.5.0 sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.2.0
sh                         edosk7705_defconfig    gcc-16.2.0
sh                           polaris_defconfig    gcc-16.2.0
sh                    randconfig-2000-20261126    gcc-9.5.0
sh                    randconfig-2001-20261126    gcc-9.5.0
sh                    randconfig-2002-20261126    gcc-9.5.0
sh                    randconfig-2003-20261126    gcc-9.5.0
sh                    randconfig-2004-20261126    gcc-9.5.0
sh                    randconfig-2005-20261126    gcc-9.5.0
sh                    randconfig-2200-20261126    gcc-16.2.0 smatch
sh                   randconfig-r2103-20261126    gcc-8.5.0  cocci
sh                   randconfig-r2108-20261126    gcc-14     cocci
sh                   randconfig-r2300-20261126    gcc-15.3.0 sparse
sh                   randconfig-r2303-20261126    clang-24   sparse
sh                   randconfig-r2303-20261126    gcc-11.5.0 sparse
sh                   randconfig-r2304-20261126    clang-20   sparse
sh                   randconfig-r2311-20261126    gcc-8.5.0  sparse
sh                           rsk7264_defconfig    gcc-16.2.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                 randconfig-1000-20261127    gcc-14
sparc                 randconfig-1001-20261127    gcc-14
sparc                 randconfig-2000-20261126    gcc-8.5.0
sparc                 randconfig-2001-20261126    gcc-8.5.0
sparc                 randconfig-2200-20261126    gcc-13.5.0 smatch
sparc                randconfig-r2104-20261126    gcc-8.5.0  cocci
sparc                randconfig-r2106-20261126    gcc-11.5.0 cocci
sparc                randconfig-r2107-20261126    gcc-14.4.0 cocci
sparc                randconfig-r2110-20261126    gcc-10.5.0 cocci
sparc                randconfig-r2300-20261126    clang-18   sparse
sparc                randconfig-r2303-20261126    clang-18   sparse
sparc                randconfig-r2304-20261126    gcc-15.3.0 sparse
sparc                randconfig-r2305-20261126    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261127    gcc-14
sparc64               randconfig-1001-20261127    gcc-14
sparc64               randconfig-2000-20261126    gcc-8.5.0
sparc64               randconfig-2001-20261126    gcc-8.5.0
sparc64               randconfig-2200-20261126    gcc-12.5.0 smatch
sparc64              randconfig-r2103-20261126    gcc-14.4.0 cocci
sparc64              randconfig-r2106-20261126    gcc-14     cocci
sparc64              randconfig-r2301-20261126    clang-24   sparse
sparc64              randconfig-r2302-20261126    clang-20   sparse
sparc64              randconfig-r2306-20261126    clang-24   sparse
sparc64              randconfig-r2310-20261126    gcc-8.5.0  sparse
sparc64              randconfig-r2311-20261126    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261127    gcc-14
um                    randconfig-1001-20261127    gcc-14
um                    randconfig-2000-20261126    gcc-8.5.0
um                    randconfig-2001-20261126    gcc-8.5.0
um                    randconfig-2200-20261126    gcc-12     smatch
um                   randconfig-r2100-20261126    clang-24   cocci
um                   randconfig-r2102-20261126    gcc-9.5.0  cocci
um                   randconfig-r2103-20261126    gcc-8.5.0  cocci
um                   randconfig-r2104-20261126    gcc-13     cocci
um                   randconfig-r2105-20261126    clang-18   cocci
um                   randconfig-r2105-20261126    clang-24   cocci
um                   randconfig-r2109-20261126    gcc-14     cocci
um                   randconfig-r2304-20261126    gcc-11.5.0 sparse
um                   randconfig-r2305-20261126    clang-20   sparse
um                   randconfig-r2306-20261126    gcc-8.5.0  sparse
um                   randconfig-r2308-20261126    gcc-12.5.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261127    gcc-14
x86_64      buildonly-randconfig-1001-20261127    gcc-14
x86_64      buildonly-randconfig-1002-20261127    gcc-14
x86_64      buildonly-randconfig-1003-20261127    gcc-14
x86_64      buildonly-randconfig-1004-20261127    gcc-14
x86_64      buildonly-randconfig-1005-20261127    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261127    gcc-14
x86_64                randconfig-1001-20261127    gcc-14
x86_64                randconfig-1002-20261127    gcc-14
x86_64                randconfig-1003-20261127    gcc-14
x86_64                randconfig-1004-20261127    gcc-14
x86_64                randconfig-1005-20261127    gcc-14
x86_64                randconfig-2000-20261126    clang-22
x86_64                randconfig-2001-20261126    clang-22
x86_64                randconfig-2002-20261126    clang-22
x86_64                randconfig-2003-20261126    clang-22
x86_64                randconfig-2004-20261126    clang-22
x86_64                randconfig-2005-20261126    clang-22
x86_64                randconfig-2100-20261126    gcc-14     cocci
x86_64                randconfig-2101-20261126    gcc-14     cocci
x86_64                randconfig-2102-20261126    gcc-14     cocci
x86_64                randconfig-2103-20261126    gcc-14     cocci
x86_64                randconfig-2104-20261126    gcc-14     cocci
x86_64                randconfig-2105-20261126    gcc-14     cocci
x86_64                randconfig-2200-20261126    clang-22   smatch
x86_64                randconfig-2300-20261126    gcc-14     sparse
x86_64                randconfig-2301-20261126    gcc-14     sparse
x86_64                randconfig-2302-20261126    gcc-14     sparse
x86_64               randconfig-r2100-20261126    gcc-8.5.0  cocci
x86_64               randconfig-r2103-20261126    gcc-8.5.0  cocci
x86_64               randconfig-r2109-20261126    gcc-11.5.0 cocci
x86_64               randconfig-r2301-20261126    gcc-11.5.0 sparse
x86_64               randconfig-r2303-20261126    gcc-15.3.0 sparse
x86_64               randconfig-r2305-20261126    clang-24   sparse
x86_64               randconfig-r2306-20261126    clang-18   sparse
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
xtensa                        common_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261127    gcc-14
xtensa                randconfig-1001-20261127    gcc-14
xtensa                randconfig-2000-20261126    gcc-13.5.0
xtensa                randconfig-2001-20261126    gcc-13.5.0
xtensa                randconfig-2200-20261126    gcc-11.5.0 smatch
xtensa               randconfig-r2102-20261126    gcc-8.5.0  cocci
xtensa               randconfig-r2105-20261126    gcc-13     cocci
xtensa               randconfig-r2106-20261126    gcc-10.5.0 cocci
xtensa               randconfig-r2111-20261126    gcc-11.5.0 cocci
xtensa               randconfig-r2300-20261126    gcc-11.5.0 sparse
xtensa               randconfig-r2302-20261126    clang-18   sparse
xtensa               randconfig-r2309-20261126    gcc-10.5.0 sparse
xtensa               randconfig-r2311-20261126    gcc-12.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
