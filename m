Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3A72571DA;
	Sun, 24 May 2026 04:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779595587; cv=none; b=MMzHR+oIO1nZIO7l5dm3U6is7q04DH+UGC5vbrBV/lMGP/wwxHtg5VKtNUeSuu8SwSYxFGR+gwM8jlvkEOO0/oMsvou5CKKtVWJeu2Rq4ZLH/UmIx+uqhcTEqmV9KIb4P4L52LMqDL7DXfNpiilLNSgduT0vH0Te0MSSIPW0y5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779595587; c=relaxed/simple;
	bh=7VU11qu0E4m0F5qePq3+C4lzpxUlj6peGYKyIbyhMPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEDcfA/wSv28yDrznsrJj3z2c6jaMS6hYaGQNSS3JposN8kDCC/UWPMXaumexwz9z892AsNwbeMyuaIpspSSkDkOEP6FYd1QNi9sq5FOnKSdg3lBBQVvCMZwY8T9s1akdDUNysphpWHrxCUQyLQ22NPmOpuvMHwOnlS6dWT3H5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eSrmwEww; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eSrmwEww"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779595585; x=1811131585;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7VU11qu0E4m0F5qePq3+C4lzpxUlj6peGYKyIbyhMPM=;
  b=eSrmwEwweGzCRnMsGkr06042Gn2TZfu/jPv8D6kh9zJrPWTt1bm+lluw
   vH34saY3ScKbSTJVI9fsGhRgLajbOUBvdmLlycbhrpaLtZU1rnQ3Uy5X5
   Rugx8txJDUPXih/6WVxLQNyb9xjC9stGYNBJRCbNa8K196qL0dv1lfoCo
   NpthIC3C0Y2DHma8FKKUONtJpeJhF0m6Qh2xmkac+k91qRfMMdYQkCzdo
   S9zjI4g1G0RnKswZvLT/nWU3Hv8XKbNGEyMIp+2eIwRH4rwL/K+2OJgy+
   nvGpH/NeZXEQSFNinCLun9R8jE+AoFi6RM5p++wscLkWFqE2lEliLDiG+
   w==;
X-CSE-ConnectionGUID: Kgy7mP1ASa6/anrXFBZXPQ==
X-CSE-MsgGUID: DZSzj3tkTiy2vf4YRuAZhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11795"; a="91852859"
X-IronPort-AV: E=Sophos;i="6.24,165,1774335600"; 
   d="scan'208";a="91852859"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 21:06:24 -0700
X-CSE-ConnectionGUID: g3OT3OKsT/GnUCylcdoXHA==
X-CSE-MsgGUID: muY/wXCGRGGTQSU6cRSjdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,165,1774335600"; 
   d="scan'208";a="279389451"
Received: from lkp-server01.sh.intel.com (HELO 6ba8523b1a8f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 23 May 2026 21:06:23 -0700
Received: from kbuild by 6ba8523b1a8f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wR06W-000000000gn-1biU;
	Sun, 24 May 2026 04:06:20 +0000
Date: Sun, 24 May 2026 12:06:02 +0800
From: kernel test robot <lkp@intel.com>
To: Ashwin Gundarapu <linuxuser509@zohomail.in>, jack <jack@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext2: Remove deprecated DAX support
Message-ID: <202605241150.CHkeIFL0-lkp@intel.com>
References: <19e54c7cba1.5355cb8650862.622752146451851140@zohomail.in>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e54c7cba1.5355cb8650862.622752146451851140@zohomail.in>

Hi Ashwin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jack-fs/for_next]
[also build test WARNING on linus/master v7.1-rc4 next-20260522]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashwin-Gundarapu/ext2-Remove-deprecated-DAX-support/20260523-202224
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next
patch link:    https://lore.kernel.org/r/19e54c7cba1.5355cb8650862.622752146451851140%40zohomail.in
patch subject: [PATCH] ext2: Remove deprecated DAX support
config: i386-randconfig-141 (https://download.01.org/0day-ci/archive/20260524/202605241150.CHkeIFL0-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch: v0.5.0-9185-gbcc58b9c

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605241150.CHkeIFL0-lkp@intel.com/

smatch warnings:
fs/ext2/inode.c:1338 ext2_set_file_ops() warn: inconsistent indenting

vim +1338 fs/ext2/inode.c

^1da177e4c3f41 Linus Torvalds 2005-04-16  1333  
fb094c90748fbe Dan Williams   2017-12-21  1334  void ext2_set_file_ops(struct inode *inode)
fb094c90748fbe Dan Williams   2017-12-21  1335  {
fb094c90748fbe Dan Williams   2017-12-21  1336  	inode->i_op = &ext2_file_inode_operations;
fb094c90748fbe Dan Williams   2017-12-21  1337  	inode->i_fop = &ext2_file_operations;
fb094c90748fbe Dan Williams   2017-12-21 @1338      inode->i_mapping->a_ops = &ext2_aops;
fb094c90748fbe Dan Williams   2017-12-21  1339  }
fb094c90748fbe Dan Williams   2017-12-21  1340  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
