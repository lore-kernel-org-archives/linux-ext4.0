Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6FB31AABF
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 02:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780109652; cv=none; b=sNVavoUfChEaaPrVHXkQC3Q1uuAbK+aiMfoDhWB/Ukxz1a2ifoNbGivwURVDp/wGPvwaJGoWvmB9EX3uuTFMdK8sDMjlKI0M+Uy+8zsY/GMgzgTQ3zd6IxRZ4hTWWTlM8V5m+HVVT1gYgdAqlj9CEuh1qiNJVKj86CBw8hZB70g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780109652; c=relaxed/simple;
	bh=1mJeKwsgVwO4E2kyY9URjfKf9unVfH4hzC1EeIJLkxk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=qJGFWBKro0OY5wyuwYJbBDcNpIqZ/nnuQNmM1bGqyrS73Dy+zoEPiwf46RDIXwsWdRsb/GFiLkbjyNVEsl/b8k3DvAFelTtBP78SKemGGtwZULg+N96YYk4Ov/RQgWJ2lvTrXoSCMpfzuLRi4Vfb+SBrbiv8QNe0u5pNRP15rI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fUpJXJO6; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fUpJXJO6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780109651; x=1811645651;
  h=date:from:to:cc:subject:message-id;
  bh=1mJeKwsgVwO4E2kyY9URjfKf9unVfH4hzC1EeIJLkxk=;
  b=fUpJXJO6hJ7BTO2SWB1hpZvCEaq8fjqJ53G3czrVJqIcY/jVC40mAdPX
   CXSG+SjHMropLIZ/uMwrX4g9bTQtTNPkwuHZAVbaN10o3PZ62FAr+d0du
   /O/nNe1QO0QLvE2pb2kj3dVIoF/2yajJTbL+z323VZMpMkH/8ct1ub6rH
   k0lhmKu5IS3RpwDcdp9zM5XLMz3yV2Ldagm3+5TCZifxKYa6wESOUcz7U
   Jwc8WTJS+PYVveZJ9FKIr/IBymUSOtzllP0UYFTQYKGxiD4ricfPV2qxK
   E2FqBT1tbKJQEYCR5EYcUp6AI4KH1VrzAqCrKDqo1YRqe+3hzdE67y9XL
   A==;
X-CSE-ConnectionGUID: +EQObME/SWmW/d5urRJWLw==
X-CSE-MsgGUID: xXxcLauQQq67B9EWtxIrag==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="98378982"
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="98378982"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 19:54:10 -0700
X-CSE-ConnectionGUID: PdBfSIBWRPmN002b7CuMaQ==
X-CSE-MsgGUID: RCBBfCGmSKurFRKfFWR3PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="281137740"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 29 May 2026 19:54:08 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wT9pt-000000007xi-1Pn8;
	Sat, 30 May 2026 02:54:05 +0000
Date: Sat, 30 May 2026 10:53:08 +0800
From: kernel test robot <lkp@intel.com>
To: "Guan-Chun Wu" <409411716@gms.tku.edu.tw>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>, Chen Hao Yu <edward062254@gmail.com>
Subject: [tytso-ext4:dev 1/5] ERROR: modpost: "ext4fs_dirhash"
 [fs/ext4/ext4-test.ko] undefined!
Message-ID: <202605301009.iWa1l3AV-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   87280ac61ae6ef27fc6ee78b733689754e425592
commit: a4841d91a7f57d38d3a63c18b4ce68ee5e06829b [1/5] ext4: add Kunit coverage for directory hash computation
config: x86_64-rhel-9.4-kunit (https://download.01.org/0day-ci/archive/20260530/202605301009.iWa1l3AV-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260530/202605301009.iWa1l3AV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605301009.iWa1l3AV-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "ext4fs_dirhash" [fs/ext4/ext4-test.ko] undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
