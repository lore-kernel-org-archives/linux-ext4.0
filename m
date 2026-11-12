Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794467977;
	b=F9mfKWYDs+FhVNNmvddEznbmS5mb2Kh4624tJEv5u/JRPIjA1SmWSa1tC1DgHiNCESt3
	 KOt/teFHqR2fmaYi6I//9uLR6jKw1xUV3uAbH85bNYH7qC5vfaIu5xxlvAhqzWbnPWDd1
	 MeWFrTExKmdLyUhH+lk7i+Cp8TE5J9FvNluGq2MNwtqvGqfN6JxgVoLnYAt+x2jNRG1qW
	 2f76ZIp2b6rlOlgGzv2VGtXzHkW8tqOmurTEr3t7yETW8MHzUrbMCtM1mu2XwC295hxeV
	 2smdi0OHg8W3ulOy9Hs9VtdUgI9Dzx47bjHtvLGoNrx1+n3b2kjuFgx/o/f5G6zkEmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794467977;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=utccmveJUZlutpJzias17ZyngswVt6NfE9B8Pn+3Jno=;
	b=Rw3lmd0WrXTKDYICxIZxeNMeNDwIAZKuuW/tQ3tDQ8OrDrS1jT37ku9F4QCI9orlfH9X
	 l0O/EoH+rmhbmkZ2DR1+bwVuJRuE0fNUx5BqnPgdirDmcQw3bQsw1BUN+fRCo9b9v9ZFk
	 tHDc2eT/7pUoWNqE90UZnw4VDvKsbvsHLKF2K2tVlHRa6pIMlnvXokQSIoRm03fAF2LhU
	 fUXY9r4cWl7aLchqr2LCYBe1tXSkaKyLM05Wl68K3oqT5LFBmxd/YyoPrKwM8w38WKE3A
	 ifJBcXV+OD1Navm86jfnJXqgi+M9VOM+3bzwnPrhXXAl8bIvmm+DiSxBQ6qXMon82+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EicyCxGb;
	arc=none smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14569606A894
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14569606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EicyCxGb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794467976; x=1826003976;
  h=date:from:to:cc:subject:message-id;
  bh=413pykpZ8NYV4MQuipWqMU7OGbgG2bok1dBlTX1HZ/A=;
  b=EicyCxGbOSD2ADwf9AujvxHzb9FQovtZWYPvAE83DZ/cazllRQNCwT8o
   X5+iNSUAHr61rQPqWlkZtrCXCDi137S1S3BYmjB8FXdwzfzQzx/KsoCRz
   TMi9In8GuL3VA02AHHy3HCDzUOvSSSWaax7CblO4vg1hSCHjDB16huMam
   3tyG/0IB6phfawdxnY0AIUP4IWa3FA9UbCm+Wg91lQUQ+3hBmQXeeEY7y
   NF352gAjMrmoJK2nC9enakgmtShM2cvtCiH/nQFBz79Qb/VOemCCVPJbd
   DW7vaDEuexNkQXG8yG5l8ddHwW7VdmgeRw8GWrodgbQAWB8/2Efuix7uV
   g==;
X-CSE-ConnectionGUID: N15VW3T9S9SHKDAc88uo9w==
X-CSE-MsgGUID: Bu4iX/k3Q2+ds5G6q44UiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3263992"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3263992"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:19:36 -0800
X-CSE-ConnectionGUID: InL3gvDPTlerpsiVbfy3bQ==
X-CSE-MsgGUID: NRBwPHA+QOyMIpcwEWHiWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="8753155"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 11 Nov 2026 23:19:35 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRP5o-000000000pp-2ErD;
	Thu, 12 Nov 2026 07:19:32 +0000
Date: Thu, 12 Nov 2026 08:18:48 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 17/50] fs/ext4/super-test.c:219:6: warning:
 unused variable 'i'
Message-ID: <202611120832.HRTiXytu-lkp@intel.com>
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
head:   246d715a48c25a74ac372dda5e10d8f69f89b50a
commit: 1cec1055be7fc2b602f1cde94d772ec822ad6d74 [17/50] ext4: add KUnit tests for fs/ext4/super.c
config: parisc-randconfig-2001-20261112 (https://download.01.org/0day-ci/archive/20261112/202611120832.HRTiXytu-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261112/202611120832.HRTiXytu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611120832.HRTiXytu-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ext4/super-test.c: In function 'super_test_cleanup':
>> fs/ext4/super-test.c:219:6: warning: unused variable 'i' [-Wunused-variable]
     219 |  int i;
         |      ^


vim +/i +219 fs/ext4/super-test.c

   216	
   217	static void super_test_cleanup(struct super_test_ctx *ctx)
   218	{
 > 219		int i;
   220	
   221		active_super_test = NULL;
   222		ctx->sbi.s_journal = NULL;
   223	
   224		if (ctx->journal_inode) {
   225			iput(ctx->journal_inode);
   226			ctx->journal_inode = NULL;
   227		}
   228	
   229		ext4_flex_groups_free_test(&ctx->sbi);
   230	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
