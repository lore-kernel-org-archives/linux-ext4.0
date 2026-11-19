Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795106326;
	b=hZ/VePq2jLuRBtWHKvARYkEUr8ZWBhYB0+xs8ByUXVE0HXffqwNXAAem0IkXBaCv7/0f
	 2Nx+yTsUU+OD/joAgMTVGfr7Ui/lnqsNWn16KPna5T5TTj2mwqyhj9aCMqJ0OEsYhr9hQ
	 +ATkiQO2o22FV3SSGfFxVseAsDAFq5U8bZH+FXmLAVN+9cKuXDdN5TWs+R9LC8YS/KWgm
	 2l3ZdUpCiWhIjfz8L+cCAzExuyyC/1Yt66lER+XfdKQS7bDXFWUaoQfOrWlqCJ1VO2Qfv
	 NGj/folreG+GuNnsQkQH/6WMxYe0LbB/Vej9QgVGtP3xJBLXwlte99Kbxep0x3aJpkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795106326;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=wHufvgTPhQuiImZR0aGXtSTnm+U9ragHvM3NfX3VD3w=;
	b=N/TwMGSDKX8ekKrABIxmeKC3jYWiUy/9ym1FRf9xyhpSFYebeduG3QlzHfhdcPDvlFOc
	 8Q0PGrp/LW/R7G7EqwpHEY8kqBQNPsEqfA/WJ2ZtnWUrG4Vq44xx/E6uSL9wp8dRhKtWI
	 k4qK+8bDGp/0pZ9yw+C5T0wgst/yqQKb9sQHHKVGJL6/hXuDYLaxLDagih4ik0dFsvWuM
	 Y6+7KRn/FkCMu3VXa1k2/prZqNHbq1JZ1GDTnRJ4pA1efcVgx3G2lMauq5V5ddaf4gPSK
	 6Kz8jHPDTr8VWGCyiKlD/ojcyd5Mau0cN39cmPiy26K21K8pSfFm5cBVp2VUpFVvGMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Kilf1gFD;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA57606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:38:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DA57606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Kilf1gFD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795106326; x=1826642326;
  h=date:from:to:cc:subject:message-id;
  bh=6uKhfBuO1jKDJqWO2D2L5EDcWf/tdAQNcYBpL0ehZAY=;
  b=Kilf1gFDBH3YGVkY+bWbneQoGU/oja6FfI0Vv890DkZBnZh7K5GeeU5W
   o4sPeKI+nNzLV/6I407Mrw1aKRj4HiXPHvAmLXWlOj8FEu7oy+gpKQqjn
   arPloM89IoPgLQGgpyasjItgGrVDc7BIJSIFIp+bZRtiwaBnFToc3au1o
   3rkwj3aYQxNzC9bQA8aDhlwgKpmxv6gujDzCLA1LXT6A4qJDW91gvfDt0
   v7ToNNulKxhhX9fioe/VK7aySTpjRWFASu9vbR8oF10FSyfRIlD/n+xzh
   nF4qL8AFjgs5Nu/hfx+QlQhOeDUfsAU999aPpnCkYy3yC8KCUxhwU/FNN
   w==;
X-CSE-ConnectionGUID: rjgVPgQ8RsGhfGYeT8qoOA==
X-CSE-MsgGUID: sl2BZAjgSYugGsKqp6/zCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3971127"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3971127"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 08:38:46 -0800
X-CSE-ConnectionGUID: O9h4vHkXQVutUrJMlRUgWw==
X-CSE-MsgGUID: sI7IOHtnQ8eKSsRprfEOzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10691956"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 19 Nov 2026 08:38:44 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xU59m-000000003ob-09A2;
	Thu, 19 Nov 2026 16:38:42 +0000
Date: Thu, 19 Nov 2026 17:38:16 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 58/62]
 arch/x86/include/asm/atomic64_32.h:122:34: sparse: sparse: cast truncates
 bits from constant value (123456789abcdef0 becomes 9abcdef0)
Message-ID: <20261119173257.cCOWLqed-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git pu
head:   4e6ed47a66cbed0752ef5cca4238d74d01a39cfa
commit: 87ed4088802281144836939e671cdea045849b88 [58/62] ext4: use atomic iversion accessors in swap_inode_data()
config: i386-randconfig-2302-20261119 (https://download.01.org/0day-ci/archive/20261119/20261119173257.cCOWLqed-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261119/20261119173257.cCOWLqed-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261119173257.cCOWLqed-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/ext4/ioctl-test.c: note: in included file (through arch/x86/include/asm/atomic.h, include/linux/atomic.h, include/linux/cpumask.h, arch/x86/include/asm/paravirt.h, ...):
>> arch/x86/include/asm/atomic64_32.h:122:34: sparse: sparse: cast truncates bits from constant value (123456789abcdef0 becomes 9abcdef0)
>> arch/x86/include/asm/atomic64_32.h:122:34: sparse: sparse: cast truncates bits from constant value (fedcba9876543210 becomes 76543210)

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
