Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103262;
	b=PjexDLHFn/2Ody5z74rdU6rnFHTw2RMF/lqib3pd+3dnVCQs0uZKOa1XN2DzD8TPVs9X
	 s8E4tIweaEcRP5bAYaxzGUrZOoLrZwj3bRthpihhtzKWZGP0IkeRW9xnH9rY3V2m57/Wl
	 a17gnrJuw9j34MViBm7fCvPBlcncltyfJthZv+Iq18mNxZYTihXJcRb3ozf/fq7qzM4C5
	 ikR8VMkxbuelj4ZkDKStHhn2zQUZhDOncbQ3/GI8rU96UEQ/RyygnRtP1hP9MXKB/G5x2
	 0WcIIFfMaqzgcuUnLPotS4pMY3T2x5P1ub7w0fQaQYyB8DOH9ugmm2+2d3Xw5eAS9vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103262;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=XqkD6FEff53Jjz7W685vkgslIFy+FvhoUIYmSzSLEJA=;
	b=4k5Tx0SdbIol5x7pCg/1/o63trf36MoUDDf9qmCNtr7K/1jYJFRTshBKvLyS2Xm09DjZ
	 LyCK8DfH26MPBc2nWmEMaHBY0czITxgHyBzA9bPQl6K6Iea8lfq4+ovqkPD1YJDF5SrYL
	 4nzJNFHDKzkIBO9NB/cCXJqbLUuPfUG7hdOlovVYPlqYfCMmQgIsUjAGWDzI35pbZ5yX3
	 QDIJhivWytgIy0cqr1i9D+BxYM79EIAhrwGndDXJZuqs28IPS1X6LtsQnCFusdOSouBvc
	 iQYRYMsqBKY7YNr3j6pOGmM8KaBGBVpSBe2CkNwFw+fAlY+5L90uiQibgkjQ+Xlfa8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=corUhgzJ;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0C260A2611
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 15:47:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E0C260A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=corUhgzJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795103261; x=1826639261;
  h=date:from:to:cc:subject:message-id;
  bh=Y48iTwvBBfbcIGSmIJZ280zNfnFvbSZwSImEARbk+eY=;
  b=corUhgzJw5tTYgvIOhFKeUDIIq81vuTFPhxfEL+z5YRjeFNpjHyZQifV
   pmwOWScbCzk6H6zoQwBTdZjqhHzOOQud5z7W83P3vKyVJAK1zM9ECim9Y
   nff3xadNY6ZIEtmfIvn/vuGuXUyxh0gpb2QFLRGoHJvbBfl4rQSVRrnV7
   zlW0qnzN00iOWzzEKbqAcSB7VX25o1DycQTU1WGdx30VkVpYjCGBuj1Df
   FaZiYZpOtolyiN7InvRg2kg+PtD4mrr2jn5g91Czb75ZlrnB0mQIGM6RP
   rBnP4LubxMPST7CxtDoMM5iAhrm+eLJ5WGqZQJ+84rlFgeeM1xwurUGnY
   g==;
X-CSE-ConnectionGUID: Dyelwl/lQy+mabYYsO5foQ==
X-CSE-MsgGUID: ofp+EfMZTmOwxkgrjf/PCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3965194"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3965194"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 07:47:40 -0800
X-CSE-ConnectionGUID: 3HCRVHBPToCwhGXCn9RqJA==
X-CSE-MsgGUID: 87FT5LY2SxqvJCZ+xnRnng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10369879"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 19 Nov 2026 07:47:39 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xU4MJ-000000003o5-2GE9;
	Thu, 19 Nov 2026 15:47:35 +0000
Date: Thu, 19 Nov 2026 16:47:21 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:test 9/26]
 arch/x86/include/asm/atomic64_32.h:122:34: sparse: sparse: cast truncates
 bits from constant value (f11335577 becomes 11335577)
Message-ID: <20261119163935.Eg68iXGt-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git test
head:   f39b6beaed1c1cd9cd503d548008710ba2b9d9e6
commit: ea68739b04998227f615097d2b1f94605979c539 [9/26] ext4: expand KUnit tests for fs/ext4/inode.c
config: i386-randconfig-2302-20261119 (https://download.01.org/0day-ci/archive/20261119/20261119163935.Eg68iXGt-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261119/20261119163935.Eg68iXGt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261119163935.Eg68iXGt-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/ext4/inode-test.c: note: in included file (through arch/x86/include/asm/atomic.h, include/linux/atomic.h, include/linux/cpumask.h, arch/x86/include/asm/paravirt.h, ...):
>> arch/x86/include/asm/atomic64_32.h:122:34: sparse: sparse: cast truncates bits from constant value (f11335577 becomes 11335577)
>> arch/x86/include/asm/atomic64_32.h:122:34: sparse: sparse: cast truncates bits from constant value (2cafebabe becomes cafebabe)

vim +122 arch/x86/include/asm/atomic64_32.h

1a3b1d89eded68 Brian Gerst    2010-01-07  118  
7aab7aa4b4bed2 Peter Zijlstra 2023-01-26  119  static __always_inline void arch_atomic64_set(atomic64_t *v, s64 i)
a7e926abc3adfb Luca Barbieri  2010-02-24  120  {
a7e926abc3adfb Luca Barbieri  2010-02-24  121  	unsigned high = (unsigned)(i >> 32);
a7e926abc3adfb Luca Barbieri  2010-02-24 @122  	unsigned low = (unsigned)i;
224788b63a2e42 Josh Poimboeuf 2025-03-02  123  	alternative_atomic64(set,
224788b63a2e42 Josh Poimboeuf 2025-03-02  124  			     /* no output */,
224788b63a2e42 Josh Poimboeuf 2025-03-02  125  			     ASM_INPUT("S" (v), "b" (low), "c" (high)),
224788b63a2e42 Josh Poimboeuf 2025-03-02  126  			     "eax", "edx", "memory");
a7e926abc3adfb Luca Barbieri  2010-02-24  127  }
1a3b1d89eded68 Brian Gerst    2010-01-07  128  

:::::: The code at line 122 was first introduced by commit
:::::: a7e926abc3adfbd2e5e20d2b46177adb4e313915 x86-32: Rewrite 32-bit atomic64 functions in assembly

:::::: TO: Luca Barbieri <luca@luca-barbieri.com>
:::::: CC: H. Peter Anvin <hpa@zytor.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
