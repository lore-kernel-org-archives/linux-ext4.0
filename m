Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794698062;
	b=M0dMBq6sA9bHsYaZp3ZPXTwvlrXHIWH/c6HWGZB/0sebQJzkEx6+PhUfZ4bwtAkCkE/T
	 FDZa/dYkn1D7bhOdI6ducCt61+qHpGtVlKA+mF75S8wOM21kkfGjA/9evUGH269voDQll
	 WVo7HxVZk6TqEX4f6AieCwpJZeRkrrXz1dt25PSVZxvAxjXjlSRe/SQErW6iSxm3FTQ45
	 vlJYM/0HLLGgbOWV3egdy1Lkv+ngtdQ28pidqhVLFiARoSlrvSBJ+C+Krr8YP3r4B90uL
	 9kv9mPwawCzDE2sjyjN3dFWQaIlttzgJL660mPpPpzZne58ixVm7Br1bLQ7ONLNLoLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698062;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=Z4NaXq+AzDXkzuOsjyDF+uJ1uShgpGI6CmGz4HaivCM=;
	b=tNGLS3Gi7roMKvdAP0PElHjQPGmvFQJbAt28NibANbSkTx/VVFHpZvm9niEvZl9ENHDu
	 0Y/78fYr/+8GbwDccN/MYblkVN2PyZts6gOIhEzqBtA4Hylj0z6/iTLzjI7XNRChDY+4C
	 m57aKoTVL+UKtAkqfqeYEoR/2XegtjqkI8xsp6aTI1PT7Bv5NK/1NLkdRA2pgQtx5utB6
	 WbHTpaH4rL4KQK+RVKI23horqNOeECAznLiaZ9MwinX1soJTpczZC6D/c+lccA2Ltc9E0
	 bbkp7POzOzpuToPd6Di/UYyWMZ5sIYqbBW8MakBJgQF6W+RRIWbCXcqoM5LnLp627QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Wh7sgxaC;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D10606A327
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 23:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86D10606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Wh7sgxaC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794698061; x=1826234061;
  h=date:from:to:cc:subject:message-id;
  bh=wVJchFX+8SEpzDxjl6SIDpGYN+7c5u8Ew59KAj/pbPQ=;
  b=Wh7sgxaCwj3OP1arRsz18qj9QUe89nbUVsOjQh//d1jqMEWF3EBefDdu
   ddkReZVEw/Sgq2AeuzQvIqaJ/lPeh751T7qOem8x0gamKkmEVaz55/vGJ
   2dbhtP8G1id+3M9tHThv15tohAh7m5NAR9mqCnTJ/nIo7cu0E0Eb34nET
   vMua2Le4R3mvAl+LWTO9bLAfwDAkVdZYoZdAN923h+uhB9tESoQ4/4vvR
   r2IdQ3CbyfbT/XjqF13FTIi0LIUycNHLXsUxc04uj+4vY9LLHv7y7ed9q
   CEyoRObH0nbk7Gq+26rqn8DAD6VjU5vfKkmY5J5VwrB7ka0IDbHkjlApt
   Q==;
X-CSE-ConnectionGUID: oQg/FwfJTZ6sa5OiYbFH7g==
X-CSE-MsgGUID: 4B9Kd6gpTq6RJeeW3zyvUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11966"; a="3328289"
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="3328289"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2026 15:14:20 -0800
X-CSE-ConnectionGUID: wpcGawngRBGOOsRz4ZeOig==
X-CSE-MsgGUID: zvfDb9SQRuu2Xlil+C2Crw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="9217586"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 14 Nov 2026 15:14:19 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSMwq-00000001672-21Wr;
	Sat, 14 Nov 2026 23:14:16 +0000
Date: Sun, 15 Nov 2026 07:13:36 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:ext4-kunit-tests] BUILD SUCCESS
 fcfa4aad26d0552f10c78e62dbf187757679f60f
Message-ID: <20261115071336.DW36fsLh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext4-kunit-tests
branch HEAD: fcfa4aad26d0552f10c78e62dbf187757679f60f  ext4: add KUnit tests for fs/ext4/dir.c

elapsed time: 3782m

configs tested: 151
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha        randconfig-2000-20261112    gcc-10.5.0
alpha        randconfig-2001-20261112    gcc-10.5.0
alpha        randconfig-2200-20261112    gcc-15.3.0 smatch
arc          randconfig-2000-20261112    gcc-8.5.0
arc          randconfig-2001-20261112    gcc-8.5.0
arc          randconfig-2002-20261112    gcc-8.5.0
arc          randconfig-2003-20261112    gcc-8.5.0
arc          randconfig-2004-20261112    gcc-8.5.0
arc          randconfig-2005-20261112    gcc-8.5.0
arc          randconfig-2200-20261112    gcc-8.5.0  smatch
arm          randconfig-2000-20261112    gcc-11.5.0
arm          randconfig-2001-20261112    gcc-11.5.0
arm          randconfig-2002-20261112    gcc-11.5.0
arm          randconfig-2200-20261112    gcc-10.5.0 smatch
arm         randconfig-r2303-20261112    gcc-16.2.0 sparse
arm64        randconfig-2000-20261112    gcc-11.5.0
arm64        randconfig-2001-20261112    gcc-11.5.0
arm64        randconfig-2002-20261112    gcc-11.5.0
arm64        randconfig-2200-20261112    clang-24   smatch
arm64       randconfig-r2309-20261112    clang-24   sparse
csky         randconfig-2000-20261112    gcc-16.2.0
csky         randconfig-2001-20261112    gcc-16.2.0
csky         randconfig-2200-20261112    gcc-11.5.0 smatch
csky        randconfig-r2102-20261112    gcc-8.5.0  cocci
csky        randconfig-r2106-20261112    gcc-16.2.0 cocci
csky        randconfig-r2110-20261112    gcc-16.2.0 cocci
hexagon      randconfig-2000-20261112    gcc-16.2.0
hexagon      randconfig-2001-20261112    gcc-16.2.0
hexagon      randconfig-2200-20261112    clang-22   smatch
hexagon     randconfig-r2307-20261112    clang-24   sparse
i386         randconfig-2000-20261112    gcc-14
i386         randconfig-2001-20261112    gcc-14
i386         randconfig-2002-20261112    gcc-14
i386         randconfig-2003-20261112    gcc-14
i386         randconfig-2004-20261112    gcc-14
i386         randconfig-2005-20261112    gcc-14
i386         randconfig-2100-20261112    clang-22   cocci
i386         randconfig-2101-20261112    clang-22   cocci
i386         randconfig-2102-20261112    clang-22   cocci
i386         randconfig-2103-20261112    clang-22   cocci
i386         randconfig-2104-20261112    clang-22   cocci
i386         randconfig-2105-20261112    clang-22   cocci
i386         randconfig-2200-20261112    gcc-14     smatch
i386         randconfig-2300-20261112    clang-22   sparse
i386         randconfig-2301-20261112    clang-22   sparse
i386         randconfig-2302-20261112    clang-22   sparse
i386        randconfig-r2107-20261112    gcc-16.2.0 cocci
i386        randconfig-r2109-20261112    gcc-16.2.0 cocci
loongarch    randconfig-2000-20261112    gcc-9.5.0
loongarch    randconfig-2001-20261112    gcc-9.5.0
loongarch    randconfig-2200-20261112    clang-24   smatch
loongarch   randconfig-r2302-20261112    gcc-16.2.0 sparse
loongarch   randconfig-r2305-20261112    gcc-16.2.0 sparse
m68k         randconfig-2000-20261112    gcc-10.5.0
m68k         randconfig-2001-20261112    gcc-10.5.0
m68k         randconfig-2200-20261112    gcc-14.4.0 smatch
m68k        randconfig-r2308-20261112    clang-24   sparse
m68k        randconfig-r2311-20261112    clang-24   sparse
microblaze   randconfig-2000-20261112    gcc-10.5.0
microblaze   randconfig-2001-20261112    gcc-10.5.0
microblaze   randconfig-2200-20261112    gcc-15.3.0 smatch
microblaze  randconfig-r2105-20261112    gcc-8.5.0  cocci
microblaze  randconfig-r2306-20261112    clang-24   sparse
mips         randconfig-2000-20261112    gcc-13.5.0
mips         randconfig-2001-20261112    gcc-13.5.0
mips         randconfig-2002-20261112    gcc-13.5.0
mips         randconfig-2200-20261112    gcc-13.5.0 smatch
nios2        randconfig-2000-20261112    gcc-9.5.0
nios2        randconfig-2001-20261112    gcc-9.5.0
nios2        randconfig-2200-20261112    gcc-11.5.0 smatch
openrisc     randconfig-2000-20261112    gcc-13.5.0
openrisc     randconfig-2001-20261112    gcc-13.5.0
openrisc     randconfig-2002-20261112    gcc-13.5.0
openrisc     randconfig-2200-20261112    gcc-16.2.0 smatch
openrisc    randconfig-r2111-20261112    gcc-16.2.0 cocci
parisc       randconfig-2000-20261112    gcc-9.5.0
parisc       randconfig-2001-20261112    gcc-9.5.0
parisc       randconfig-2200-20261112    gcc-8.5.0  smatch
powerpc      randconfig-2000-20261112    clang-17
powerpc      randconfig-2001-20261112    clang-17
powerpc      randconfig-2002-20261112    clang-17
powerpc      randconfig-2200-20261112    clang-24   smatch
powerpc     randconfig-r2100-20261112    gcc-8.5.0  cocci
powerpc64    randconfig-2000-20261112    clang-17
powerpc64    randconfig-2001-20261112    clang-17
powerpc64    randconfig-2002-20261112    clang-17
riscv        randconfig-2000-20261112    clang-19
riscv        randconfig-2001-20261112    clang-19
riscv        randconfig-2002-20261112    clang-19
riscv        randconfig-2003-20261112    clang-19
riscv        randconfig-2004-20261112    clang-19
riscv        randconfig-2005-20261112    clang-19
riscv        randconfig-2200-20261112    clang-24   smatch
riscv       randconfig-r2104-20261112    gcc-8.5.0  cocci
s390         randconfig-2000-20261112    clang-24
s390         randconfig-2001-20261112    clang-24
s390         randconfig-2002-20261112    clang-24
s390         randconfig-2003-20261112    clang-24
s390         randconfig-2004-20261112    clang-24
s390         randconfig-2005-20261112    clang-24
s390         randconfig-2200-20261112    clang-24   smatch
s390        randconfig-r2108-20261112    gcc-16.2.0 cocci
s390        randconfig-r2304-20261112    gcc-16.2.0 sparse
sh           randconfig-2000-20261112    gcc-16.2.0
sh           randconfig-2001-20261112    gcc-16.2.0
sh           randconfig-2002-20261112    gcc-16.2.0
sh           randconfig-2003-20261112    gcc-16.2.0
sh           randconfig-2004-20261112    gcc-16.2.0
sh           randconfig-2005-20261112    gcc-16.2.0
sh           randconfig-2200-20261112    gcc-16.2.0 smatch
sh          randconfig-r2310-20261112    clang-24   sparse
sparc        randconfig-2000-20261112    clang-24
sparc        randconfig-2001-20261112    clang-24
sparc        randconfig-2200-20261112    gcc-11.5.0 smatch
sparc       randconfig-r2101-20261112    gcc-8.5.0  cocci
sparc64      randconfig-2000-20261112    clang-24
sparc64      randconfig-2001-20261112    clang-24
sparc64      randconfig-2200-20261112    gcc-10.5.0 smatch
um           randconfig-2000-20261112    clang-24
um           randconfig-2001-20261112    clang-24
um           randconfig-2200-20261112    clang-20   smatch
um          randconfig-r2103-20261112    gcc-8.5.0  cocci
um          randconfig-r2300-20261112    gcc-16.2.0 sparse
um          randconfig-r2301-20261112    gcc-16.2.0 sparse
x86_64                          kexec    clang-22
x86_64       randconfig-2000-20261112    gcc-14
x86_64       randconfig-2001-20261112    gcc-14
x86_64       randconfig-2002-20261112    gcc-14
x86_64       randconfig-2003-20261112    gcc-14
x86_64       randconfig-2004-20261112    gcc-14
x86_64       randconfig-2005-20261112    gcc-14
x86_64       randconfig-2100-20261112    clang-22   cocci
x86_64       randconfig-2101-20261112    clang-22   cocci
x86_64       randconfig-2102-20261112    clang-22   cocci
x86_64       randconfig-2103-20261112    clang-22   cocci
x86_64       randconfig-2104-20261112    clang-22   cocci
x86_64       randconfig-2105-20261112    clang-22   cocci
x86_64       randconfig-2200-20261112    gcc-13     smatch
x86_64       randconfig-2300-20261112    clang-22   sparse
x86_64       randconfig-2301-20261112    clang-22   sparse
x86_64       randconfig-2302-20261112    clang-22   sparse
x86_64                       rhel-9.4    clang-22
x86_64                   rhel-9.4-bpf    clang-22
x86_64                  rhel-9.4-func    clang-22
x86_64            rhel-9.4-kselftests    clang-22
x86_64                 rhel-9.4-kunit    clang-22
x86_64                   rhel-9.4-ltp    clang-22
x86_64                  rhel-9.4-rust    clang-22
xtensa       randconfig-2000-20261112    gcc-16.2.0
xtensa       randconfig-2001-20261112    gcc-16.2.0
xtensa       randconfig-2200-20261112    gcc-13.5.0 smatch

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
