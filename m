Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F7B3C4557
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780048358; cv=none; b=uHa7BDLbEyUUO3R285+vPePM1lLBVrfsOYk0m9OxHPxr3ffGiU21kByL1hjzD5PH84Gmp6CU6JQ8jI4NB5ipj7W1a4bADcZS3RUpnHSOwitvTT6y8cRKnIDAoIa5Qeppa//1oBgOwkW6L+w4P/+8QqYN7C3YWr4q9XWxbJWFEQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780048358; c=relaxed/simple;
	bh=ck9JID+OU0b9TcMOwwP8J6YZEgRKtvBtPTyFrEazzV8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=hDkA4D3+nk2j/yYldLMfSGFb295wbMT/lWjHYBmbraqxziV4oCN8M9RF/JDB5G1NHEDQM23baDLUyeC6NW+U1bEYA/VdxKpNFR52ZaA6pivmZqNUJ/zqTMv50xehPbcn4JQ/hStA2i/CUWg7GVRn0TBUHUs+WnITvJKRZnYnIuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H2xApzYo; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H2xApzYo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780048356; x=1811584356;
  h=date:from:to:cc:subject:message-id;
  bh=ck9JID+OU0b9TcMOwwP8J6YZEgRKtvBtPTyFrEazzV8=;
  b=H2xApzYocXQrp6QtxYndw+tOXQPZ8hc4X0sTZWPFc/61wPQL5n6kN2Aj
   6ues890hzq7rJwcaIf9dTPc8EFQ6bIdF4G2LykokaUyLAR+FAEkuWH6XP
   CWJ5Ox6mAxbAWqGsrk2ldDa/4pVYvdxjkvlKqtC6rC6iXkx0gMzQ83fER
   y3Bqbkk77EdSoMbaywB2pmu1CdF7/jjsAdVe3HFfJuz03SY22WvzNKRgu
   zziqiLM8qK+0ktFNlMPjQXbfkBZPqGWHDV7sREy6yR9JC8r8cmAyd2SIN
   fB6y+inXOx1GZjfs3h+udrMOL5+ujrLKU1OIRk1n4FJPG59lYf7GEc02g
   Q==;
X-CSE-ConnectionGUID: tJl69GQcSFW9X/YODXYkfA==
X-CSE-MsgGUID: wiDfy062QjS7+8bSWo3NTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="91583908"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="91583908"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 02:52:36 -0700
X-CSE-ConnectionGUID: ndmyYakyTIOQa1vne2FB+g==
X-CSE-MsgGUID: WI0H80itQDyAeQrzCVjqOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="247900339"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by fmviesa005.fm.intel.com with ESMTP; 29 May 2026 02:52:34 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSttI-000000000r5-1MJg;
	Fri, 29 May 2026 09:52:32 +0000
Date: Fri, 29 May 2026 11:52:10 +0200
From: kernel test robot <lkp@intel.com>
To: "Guan-Chun Wu" <409411716@gms.tku.edu.tw>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>, Chen Hao Yu <edward062254@gmail.com>
Subject: [tytso-ext4:dev 1/5] ERROR: modpost: "ext4fs_dirhash"
 [fs/ext4/ext4-test.ko] undefined!
Message-ID: <202605291142.INrrPtVc-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   87280ac61ae6ef27fc6ee78b733689754e425592
commit: a4841d91a7f57d38d3a63c18b4ce68ee5e06829b [1/5] ext4: add Kunit coverage for directory hash computation
config: x86_64-rhel-9.4-kunit (https://download.01.org/0day-ci/archive/20260529/202605291142.INrrPtVc-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605291142.INrrPtVc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605291142.INrrPtVc-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "ext4fs_dirhash" [fs/ext4/ext4-test.ko] undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
