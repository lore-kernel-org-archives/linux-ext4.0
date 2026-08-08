Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0950E18DB1F
	for <linux-ext4@vger.kernel.org>; Sat,  8 Aug 2026 05:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786165278; cv=none; b=uD6prdowD3VKWbHjoFSu9cEARwHWi0dhEQl0oqXdGzt8Kdy7DsleN3gzlfCnLZQRfamJcx+z5oCiR9AWreSBdC+//wCPn7pdtyB8AYZ4+68wuNnqGmOiqCuhB1B69k0PlPulvCkpYlBll96E6LGuRMT7HNQg3qvvpvM+UGhe+Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786165278; c=relaxed/simple;
	bh=A+M0XfIatVvUxQwQt+Mf9uz8c2DVyguZF0LtvqOlFaU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=tBVoGkU9/K2AhaNIA3Bf6dkLaxovuJ/3sRsgtWzXO15b/Xn/4w6I0uSFpeV40DkvJ58yDpg52NwooH5gQx0KTmyim/3Ic7xEGlZPai+WKm6a+P85/DUF6qapuOH/DdgnaeUZEHJ+CIpYCMsvycI/6c7q2lBZGnnEj+IfXi/PamU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IAhOgEXT; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IAhOgEXT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786165276; x=1817701276;
  h=date:from:to:cc:subject:message-id;
  bh=A+M0XfIatVvUxQwQt+Mf9uz8c2DVyguZF0LtvqOlFaU=;
  b=IAhOgEXThPRAn+CAd9/K3XSWGVWHQJn0OI9ZKAEgzdUVjgRcUqcJZH3I
   19ewtAVybKKtXhYNIVE3+R/hGbQoHLQm51gVTa7u1baL6uFCNxB6x97a+
   UCR1il8xVMYZVoosDzWLyoXJTuWTV7cuCTJYjNIcOtZTDRfYikR8K7fLS
   zSgy320WMIaThvQsESGYgRrTmt/3w/C3OtOEPbilc5ZkpHhYbgcgbtT7Q
   ySxhb7X1H4RM3OoYB+SHHmpLdNDBSx3P4pCcVf7eHaz1WI/9BeInotQn2
   VlyHgn4+bbzCnNy3kHsi+eQ+kbkpO+6+bT/avCY+P78Sx4BY5FhU8gh3N
   g==;
X-CSE-ConnectionGUID: v3FC723eS220PDO58aU0ZA==
X-CSE-MsgGUID: LiCaAVg4Tb2/HqVeePjQGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11868"; a="86648430"
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="86648430"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 22:01:15 -0700
X-CSE-ConnectionGUID: Iv3gb6yURr2YMyfEoVqqOQ==
X-CSE-MsgGUID: gqjr7JrUQ86okzrcjzi2Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="259256621"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 07 Aug 2026 22:01:14 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wsZBH-00000000JlB-3Wnt;
	Sat, 08 Aug 2026 05:01:11 +0000
Date: Sat, 08 Aug 2026 13:00:52 +0800
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [tytso-ext4:dev] BUILD SUCCESS
 9091c97be34083587a75db174aab51551d8e8543
Message-ID: <202608081338.WVFuPqxb-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
branch HEAD: 9091c97be34083587a75db174aab51551d8e8543  ext4: fix estimate extent index blocks in ext4_ext_index_trans_blocks()

elapsed time: 813m

configs tested: 15
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
alpha           defconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
loongarch       defconfig    clang-24
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
openrisc   virt_defconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
parisc          defconfig    gcc-16.1.0
sh              defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
