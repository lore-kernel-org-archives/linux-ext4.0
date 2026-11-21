Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795241713;
	b=wRnlcxPxZHWCPoSDFw7Pp40+xuHpYkhsM/7qZN0Z4N/uDFMYNbbTa5z+Svzpn6keXYru
	 a+ep2+eV9jiq8bB4eJVf5MybvOwv9935SEtRH3TvihMuLzB2+RvrtRRWSMM6mOiPub+oZ
	 r/AeEkB0ILqTeEqwmO7emKsinqdsv2sgYda1lHUyDDkzYDUUhD8FH5Hd7mOssdmesormc
	 9M5mNNemExYY2nEVRHrwISphxbiuc82JU767FMo5IeBXw7enR/PrSPwH2iKM/4ZZJfWBC
	 5FH5qMF9XOe57lyE7qrv46qr1qE/sVIZ8EpWGHV8tM9/+1ODSkPBHb4+3C58DP6nP4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795241713;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=P+F4/mF5CKN+zX3rvO8yExcYxU2OjlTVQ1XGxAH4JPY=;
	b=UQWzhtxm5oBTP0TVEXRbqRcm+ARF5AhZthlcyyLEpxIosERChpw1NF4hWmz4gslK+AKp
	 0Uz61gsVGpLjUJujzomzjYJRCchJTaLF3vs/dqLMr0wNJ2Prp4zoMNzHZiQmh6PNdZufK
	 1PtiP3Pah47n73WhDqry6bnHt0F0vdZWn0IlLKYuKZXZjHdgKh+hL+eFEV5pOmdS2SIEh
	 l1NqE1l0vG+LbK4gmbPAtCSkpw9g9sW1I4ITBvsrFCEFwAImExp5kQpcCziUU+gNcMyr5
	 SyR/SAcHrIiQ/r6hANurj4jAJWnaGJZ6w6kPhqyj2f27ZoxMVLAsdZCDPeRR0kU9vwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L8r5n+z6;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02069606A32C
	for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2026 06:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02069606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L8r5n+z6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795241714; x=1826777714;
  h=date:from:to:cc:subject:message-id;
  bh=qCPgpvpzM69q/6a6rnUfFWbVVSPU9BGMYkzt5CGjUDY=;
  b=L8r5n+z6+DRQNDcu7Cl/KMKnooIncloeCAZIMGZGt4n9ayiqzF0vaq1z
   rfVG429M/zz6xE3HyxO++HgIEuFMZ/nTi9jii9bVFwxXyjKrP0E5dEOBj
   kxaEOvGD5/Ztr+tLgq6hZf3xov0vVueWwYkHokLuMXhtHlkURaaz9ggQe
   s3EwP+JOnW9XzqLLCoq6qtomy41b5tMtGxxdHB69ox8yRTWqU4UL1B++d
   qu3ctcqT65GFtmDvXjFiATA6jgDxt/bK9Zk/BH/fEOSJCIdazaF7HdtUF
   ia4tGP8TQEoi9Mg1xH3mPjzN3dTH2HZL4CnnSE6JBPMvc2xQgp1r0qiF5
   g==;
X-CSE-ConnectionGUID: ZAEKeYzZTVeulCk3kw7Ycw==
X-CSE-MsgGUID: Wpr38t9nRViv3RtikNKQBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4110489"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4110489"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 22:15:13 -0800
X-CSE-ConnectionGUID: /N1Pm3FdQaKiif3qcEwhbQ==
X-CSE-MsgGUID: 49U20wybSRSadhcHfKk/fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="12690069"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 20 Nov 2026 22:15:10 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUeNQ-00000001Jbd-2kYd;
	Sat, 21 Nov 2026 06:15:08 +0000
Date: Sat, 21 Nov 2026 14:14:52 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:test] BUILD REGRESSION
 f39b6beaed1c1cd9cd503d548008710ba2b9d9e6
Message-ID: <20261121141452.irIR8PVM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git test
branch HEAD: f39b6beaed1c1cd9cd503d548008710ba2b9d9e6  ext4: add KUnit tests for fs/ext4/dir.c

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/20261119153312.JoLTih25-lkp@intel.com

    fs/ext4/mballoc-test.c:2177:14-19: ERROR: reference preceded by free on line 2174
    fs/ext4/mballoc-test.c:2190:14-19: ERROR: reference preceded by free on line 2187

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r2101-20261119
|   `-- fs-ext4-mballoc-test.c:ERROR:reference-preceded-by-free-on-line
|-- i386-randconfig-2105-20261119
|   `-- fs-ext4-mballoc-test.c:ERROR:reference-preceded-by-free-on-line
`-- i386-randconfig-2302-20261119
    |-- arch-x86-include-asm-atomic64_32.h:sparse:sparse:cast-truncates-bits-from-constant-value-(2cafebabe-becomes-cafebabe)
    `-- arch-x86-include-asm-atomic64_32.h:sparse:sparse:cast-truncates-bits-from-constant-value-(f11335577-becomes-)

elapsed time: 1509m

configs tested: 99
configs skipped: 0

tested configs:
alpha       randconfig-2200-20261119    gcc-12.5.0 smatch
arc         randconfig-2000-20261119    gcc-14.4.0
arc         randconfig-2001-20261119    gcc-16.2.0
arc         randconfig-2002-20261119    gcc-14.4.0
arc         randconfig-2003-20261119    gcc-16.2.0
arc         randconfig-2004-20261119    gcc-14.4.0
arc         randconfig-2005-20261119    gcc-12.5.0
arc        randconfig-r2101-20261119    gcc-15.3.0 cocci
arc        randconfig-r2307-20261119    gcc-8.5.0  sparse
arm        randconfig-r2100-20261119    gcc-10.5.0 cocci
arm64       randconfig-2200-20261119    clang-17   smatch
csky        randconfig-2000-20261119    gcc-16.2.0
csky        randconfig-2001-20261119    gcc-16.2.0
csky        randconfig-2200-20261119    gcc-16.2.0 smatch
csky       randconfig-r2105-20261119    gcc-13.5.0 cocci
hexagon     randconfig-2000-20261119    clang-17
hexagon     randconfig-2001-20261119    clang-24
hexagon     randconfig-2200-20261119    clang-17   smatch
i386        randconfig-2000-20261119    gcc-14
i386        randconfig-2001-20261119    gcc-14
i386        randconfig-2002-20261119    gcc-14
i386        randconfig-2003-20261119    clang-22
i386        randconfig-2004-20261119    gcc-14
i386        randconfig-2005-20261119    gcc-14
i386        randconfig-2100-20261119    gcc-14     cocci
i386        randconfig-2101-20261119    gcc-14     cocci
i386        randconfig-2102-20261119    gcc-14     cocci
i386        randconfig-2103-20261119    clang-22   cocci
i386        randconfig-2104-20261119    clang-22   cocci
i386        randconfig-2105-20261119    clang-22   cocci
i386        randconfig-2300-20261119    gcc-13     sparse
i386        randconfig-2301-20261119    gcc-14     sparse
i386        randconfig-2302-20261119    clang-22   sparse
i386       randconfig-r2104-20261119    clang-22   cocci
loongarch   randconfig-2000-20261119    clang-24
loongarch   randconfig-2001-20261119    gcc-16.2.0
m68k        randconfig-2200-20261119    gcc-9.5.0  smatch
mips        randconfig-2000-20261119    gcc-8.5.0
mips        randconfig-2001-20261119    clang-24
mips        randconfig-2002-20261119    clang-21
mips        randconfig-2200-20261119    clang-24   smatch
mips       randconfig-r2107-20261119    clang-24   cocci
nios2       randconfig-2000-20261119    gcc-8.5.0
nios2       randconfig-2001-20261119    gcc-11.5.0
nios2       randconfig-2200-20261119    gcc-11.5.0 smatch
openrisc    randconfig-2000-20261119    gcc-16.2.0
openrisc    randconfig-2001-20261119    gcc-16.2.0
openrisc    randconfig-2002-20261119    gcc-16.2.0
openrisc    randconfig-2200-20261119    gcc-16.2.0 smatch
openrisc   randconfig-r2111-20261119    gcc-16.2.0 cocci
parisc      randconfig-2000-20261119    gcc-16.2.0
parisc      randconfig-2001-20261119    gcc-10.5.0
parisc     randconfig-r2309-20261119    gcc-15.3.0 sparse
parisc     randconfig-r2311-20261119    gcc-16.2.0 sparse
powerpc     randconfig-2200-20261119    gcc-13.5.0 smatch
powerpc64   randconfig-2200-20261119    clang-24   smatch
powerpc64  randconfig-r2103-20261119    gcc-8.5.0  cocci
riscv      randconfig-r2109-20261119    clang-24   cocci
riscv      randconfig-r2310-20261119    gcc-16.2.0 sparse
s390        randconfig-2000-20261119    gcc-8.5.0
s390        randconfig-2001-20261119    clang-24
s390        randconfig-2002-20261119    clang-24
s390        randconfig-2003-20261119    gcc-8.5.0
s390        randconfig-2004-20261119    clang-22
s390        randconfig-2005-20261119    clang-20
s390       randconfig-r2308-20261119    clang-24   sparse
sh          randconfig-2000-20261119    gcc-14.4.0
sh          randconfig-2001-20261119    gcc-16.2.0
sh          randconfig-2002-20261119    gcc-14.4.0
sh          randconfig-2003-20261119    gcc-16.2.0
sh          randconfig-2004-20261119    gcc-14.4.0
sh          randconfig-2005-20261119    gcc-12.5.0
sparc       randconfig-2000-20261119    gcc-14.4.0
sparc       randconfig-2001-20261119    gcc-16.2.0
sparc       randconfig-2200-20261119    gcc-8.5.0  smatch
sparc      randconfig-r2106-20261119    gcc-14.4.0 cocci
sparc      randconfig-r2306-20261119    gcc-8.5.0  sparse
sparc64     randconfig-2000-20261119    gcc-8.5.0
sparc64     randconfig-2001-20261119    gcc-9.5.0
sparc64     randconfig-2200-20261119    gcc-13.5.0 smatch
sparc64    randconfig-r2102-20261119    gcc-8.5.0  cocci
sparc64    randconfig-r2110-20261119    clang-20   cocci
um          randconfig-2000-20261119    gcc-13
um          randconfig-2001-20261119    clang-21
um          randconfig-2200-20261119    clang-24   smatch
x86_64      randconfig-2000-20261119    gcc-14
x86_64      randconfig-2001-20261119    clang-22
x86_64      randconfig-2002-20261119    clang-22
x86_64      randconfig-2003-20261119    gcc-14
x86_64      randconfig-2004-20261119    gcc-14
x86_64      randconfig-2005-20261119    clang-22
x86_64      randconfig-2200-20261119    clang-22   smatch
x86_64      randconfig-2300-20261119    clang-22   sparse
x86_64      randconfig-2301-20261119    clang-22   sparse
x86_64      randconfig-2302-20261119    gcc-14     sparse
x86_64     randconfig-r2108-20261119    clang-22   cocci
xtensa      randconfig-2000-20261119    gcc-12.5.0
xtensa      randconfig-2001-20261119    gcc-8.5.0
xtensa      randconfig-2200-20261119    gcc-14.4.0 smatch

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
