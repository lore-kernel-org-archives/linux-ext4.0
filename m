Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0212F747A
	for <linux-ext4@vger.kernel.org>; Sat, 25 Jul 2026 11:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784979104; cv=none; b=Uj6su8H7Pc0eZBtG+tF6JHTo58Oa/DtlcFS9LIYgnnSMeG6z8elwshERZhshDXpCgI5UPw+VPmXB51rg6nXLN6RSh/dox9i9f2YLQU7KdbtIdrcE844HXT8++3pflaB2GHCmOrMdg2n1OASufgxTO0kdpsxXX0Pcou51a33WIaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784979104; c=relaxed/simple;
	bh=hKqakJ/Elrhz84uDN7ngGcNoo1hqem3nnBFpN1BUScQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=XKxr62mw2oL7XoCbMTjHCpg8LGRj9QJwLUlEP+qfaRD/j9ABrDESHqnlGTCil2pklBJBbZBRK6/mdGekkocZn+XkPYLApmdoRnqVBjinYI1fWudnhKP6aV4QmLjR/989vUi8kICIRUh5m6MvzNpsDMcqXkPuGyMqj9bGznIHi1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hZN43QkT; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hZN43QkT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784979102; x=1816515102;
  h=date:from:to:cc:subject:message-id;
  bh=hKqakJ/Elrhz84uDN7ngGcNoo1hqem3nnBFpN1BUScQ=;
  b=hZN43QkTe/z7j5wWMvOSphRgd5uvy7ep/WdZ42LS1UPcLMrb0jhTkH+1
   o1JtgvOY3JhYLxenBj4txzAfA97CVHEEEyfaMnBkPwQ75m/vXzIdJLGA/
   1Bof79H2H3JAWxkHDpShNc+O29+EMe6wEDiv6vh3vcHcrkOWMPRczJOn/
   DNgiYJQoFTl1p7GbChDEz+RlMN44cLPR428KklIEAd3+L/J4lptY+i0f0
   RHb29jsYETGWWcA/U0K+94if7uVw2gTf8zDQGvdesD/JoGyMOGbOejYaC
   pmcDACCsV05MCKyhuHbD+5ROfo0xFYIqbkbf280cM6KyMkA8wOnWn+3KE
   g==;
X-CSE-ConnectionGUID: IysO7xQ9Sf+pGa5reXZbmA==
X-CSE-MsgGUID: Jvuu2/r4QRWtEpo6kGrd2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="85638024"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="85638024"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 04:31:42 -0700
X-CSE-ConnectionGUID: k8brVa7xQbivhbMkt0rD2Q==
X-CSE-MsgGUID: 8XWUACjsR/KzA1LpsaDEug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="256294368"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 25 Jul 2026 04:31:40 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnabO-00000000beC-2eNC;
	Sat, 25 Jul 2026 11:31:35 +0000
Date: Sat, 25 Jul 2026 19:30:38 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:dev] BUILD SUCCESS
 97e211ad1a34a5a979558a037619b9e633ca8620
Message-ID: <202607251927.joRS6fR1-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
branch HEAD: 97e211ad1a34a5a979558a037619b9e633ca8620  jbd2: align h_type and h_line_no in the handle structure on byte boundaries

elapsed time: 1271m

configs tested: 68
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260725    gcc-11.5.0
arc                  randconfig-002-20260725    gcc-8.5.0
arm                  randconfig-001-20260725    gcc-8.5.0
arm                  randconfig-002-20260725    clang-21
arm                  randconfig-003-20260725    gcc-10.5.0
arm                  randconfig-004-20260725    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260725    gcc-9.5.0
csky                 randconfig-002-20260725    gcc-16.1.0
hexagon              randconfig-001-20260725    clang-17
hexagon              randconfig-002-20260725    clang-24
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260725    clang-22
i386       buildonly-randconfig-002-20260725    gcc-14
i386       buildonly-randconfig-003-20260725    clang-22
i386       buildonly-randconfig-004-20260725    clang-22
i386       buildonly-randconfig-005-20260725    gcc-14
i386       buildonly-randconfig-006-20260725    gcc-14
i386                 randconfig-001-20260725    clang-22
i386                 randconfig-002-20260725    gcc-14
i386                 randconfig-003-20260725    gcc-14
i386                 randconfig-004-20260725    gcc-12
i386                 randconfig-005-20260725    clang-22
i386                 randconfig-006-20260725    gcc-14
i386                 randconfig-007-20260725    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260725    gcc-16.1.0
loongarch            randconfig-002-20260725    gcc-13.4.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260725    gcc-11.5.0
nios2                randconfig-002-20260725    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260725    gcc-10.5.0
parisc               randconfig-002-20260725    gcc-12.5.0
powerpc                    mpc5200_defconfig    clang-24
powerpc              randconfig-001-20260725    gcc-9.5.0
powerpc              randconfig-002-20260725    gcc-15.2.0
powerpc64            randconfig-001-20260725    clang-17
powerpc64            randconfig-002-20260725    clang-24
riscv                         randconfig-001    gcc-13.4.0
riscv                randconfig-001-20260725    gcc-8.5.0
riscv                randconfig-002-20260725    gcc-8.5.0
s390                 randconfig-001-20260725    gcc-10.5.0
s390                 randconfig-002-20260725    gcc-16.1.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260725    gcc-16.1.0
sh                   randconfig-002-20260725    gcc-11.5.0
sparc                randconfig-001-20260725    gcc-16.1.0
sparc                randconfig-002-20260725    gcc-8.5.0
sparc64              randconfig-001-20260725    gcc-8.5.0
sparc64              randconfig-002-20260725    gcc-10.5.0
um                   randconfig-001-20260725    gcc-14
x86_64               randconfig-071-20260725    gcc-14
x86_64               randconfig-072-20260725    gcc-14
x86_64               randconfig-073-20260725    gcc-14
x86_64               randconfig-074-20260725    gcc-14
x86_64               randconfig-075-20260725    gcc-14
x86_64               randconfig-076-20260725    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
