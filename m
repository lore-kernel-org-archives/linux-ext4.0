Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CC342E007
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 20:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791490703; cv=none; b=nPT+5pCWP9UIbZtRIce9cus6+8b6o5obyirsbBIw4czpUtQ7PihFEv7qaga3wiXLxGeJ2c77hF5l3uW4e6+b8kaqI9bL2R9SdbmWyDn6Fa0+RQAJ9Bh3HeC2UG1J9FpQfAICCkUV/5n8DdgyOj4um9ctauv0/0cl5TvHGiRKjdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791490703; c=relaxed/simple;
	bh=OqKkZy0Pe5XOXtiLnAzJe9Z6aWGZTTtOcAjaqR8XfwI=;
	h=Date:From:To:Cc:Subject:Message-ID; b=TSGj6WjrrIhGEOpnm3KxUkPVz7+XQuQtfaIstLr8i37tunAwiTk4+yqqgj8IJLJUZTgrE7IUcQdAA7jSQ8Ur+C+AODhP0pJkuMXJFhGXH4l80bb8joHg/s99924byJYYM/aFDULl1PoXqAh582k3QbjwHX5WM7yS65+eP9ttXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I9MyqfMH; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I9MyqfMH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791490701; x=1823026701;
  h=date:from:to:cc:subject:message-id;
  bh=OqKkZy0Pe5XOXtiLnAzJe9Z6aWGZTTtOcAjaqR8XfwI=;
  b=I9MyqfMHSQMuMuBLcJmFu14adXcqj3DoVeY3FrL7C2NFXcSbwsia9PaM
   DPOcQQkwKjInqEJ3pMu4sKg/BzoT8FOLsojl9WCYJ1JZ25CTo/+j0pBn6
   rKSzRDgNhbq2rg4GRQ3G5CMBdSuKGU1qZnIwkzikbmKdve0SSjsroWvyQ
   6U06LmCO55pZ08OM3c5vyUoR8fSp6A/dBcqJHxXtQd9ftmcKYj/HLyLKE
   QCrJrHsjmE8Sh48r98YYpuPABxLNlA5wZPFPQhYy22UcBHU/4kRXypGuG
   1GBToeq5r7mlDIRPht8heWrLM9rwRe47MswowrZnyLG3qoe0ADzIPc27B
   A==;
X-CSE-ConnectionGUID: iUoBHEz7Q/e/PDP4tUT1mA==
X-CSE-MsgGUID: 7iFsYW70S/SavQUvU8be2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="172073"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="172073"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 13:18:20 -0700
X-CSE-ConnectionGUID: TiDCPErmS1C2El68qZHrJA==
X-CSE-MsgGUID: d4ne/9MbTne3F5fXDXWtVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="582152"
Received: from igk-lkp-server01.igk.intel.com (HELO d0de6c2a75a7) ([10.211.93.152])
  by orviesa010.jf.intel.com with ESMTP; 08 Oct 2026 13:18:18 -0700
Received: from kbuild by d0de6c2a75a7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEuZD-0000000061B-3Fpl;
	Thu, 08 Oct 2026 20:18:15 +0000
Date: Thu, 08 Oct 2026 22:18:04 +0200
From: kernel test robot <lkp@intel.com>
To: Zhang Yi <yi.zhang@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [tytso-ext4:dev 21/41] fs/ext4/inode.c:4002:24: sparse:
 sparse: symbol 'ext4_iomap_buffered_read_ops' was not declared. Should it be
 static?
Message-ID: <202610082225.lcsAyIiF-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   35aefefd7aba0801bab635b11943f932626be3b2
commit: e933fd1b6cd5322563d5caf283dabd9cd09bcef8 [21/41] ext4: implement buffered read path using iomap
config: arm-randconfig-r2308-20261008 (https://download.01.org/0day-ci/archive/20261008/202610082225.lcsAyIiF-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 16.1.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610082225.lcsAyIiF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610082225.lcsAyIiF-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/ext4/inode.c:4002:24: sparse: sparse: symbol 'ext4_iomap_buffered_read_ops' was not declared. Should it be static?

vim +/ext4_iomap_buffered_read_ops +4002 fs/ext4/inode.c

  3998	
  3999	static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_read_next,
  4000				      ext4_iomap_buffered_read_begin);
  4001	
> 4002	const struct iomap_ops ext4_iomap_buffered_read_ops = {
  4003		.iomap_next = ext4_iomap_buffered_read_next,
  4004	};
  4005	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
