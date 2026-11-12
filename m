Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794482631;
	b=5qItVo3h5hQ+3EwHzCkg4QpdoQw/tlxcVcX8F9KFzpj3FFvygKD6jwsRoMXSZDxN9zqG
	 M5mE3UxnIOreEwIfI5Fptq1W4cta3rZupdDL7qzqcKix2Ytd+Sesp2mKdjJEipdOjHXXw
	 MLooBRvTy8sIeY4VKISTVLHpATeYWTmGIbWPJbY86/uX0SS76fmm7GyrzhdjXN3ipjRS8
	 FjGK3xFI5SDyz+3BIKSv5rCa9ftXdShzLKSKrT851FZAwYD3l75cy1gPIulvYUvpU4+FL
	 k/wgI5xZ4eKUDcAANDq+WNscAJLyyTeT4fx0DAZQ7zl/Y0F1gpkEr8eeMw/XgW70jfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794482631;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=nMBTvbBA7eHJN3JXeG36EPrKOYEsdwPmI06+1RhD2+A=;
	b=ZWYtjxAPPrw/ow8OXcJk1XTngJbOWn51SVLm40+vVtY0+5mrAFrmVXJZAW7dtb0aONzi
	 iQgoh9sjXNaKcA5983r0SXi10LLLtZDSHABCu0shiSZYN+9IpHmsPc439e6KKmMocZXKs
	 u0z+y536ajqT7LfuDkI4is8yXvOUtbULxXtQ4HA9DVASAfs73dcrX7Ii0uVHxJhmGaviY
	 TFKDwqL9vo87soVuk3U++sQ9dKRfxEBJZLuNiAOl0E4dFSox1cUkVEWsFIzuNZGZNVzaf
	 +emf95Hk1a7BaqqkEM7Z4oD/PZ3rPig+VTt98j64djMq2pi1WawUJBhziPrtL1M+iYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jAaORurf;
	arc=none smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C38606A8B6
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 11:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89C38606A8B6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jAaORurf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794482630; x=1826018630;
  h=date:from:to:cc:subject:message-id;
  bh=lE+XMOaf+fB3xkJKnJUp7qtWnmBqzbofba09/MBSwbw=;
  b=jAaORurfFlosZPSU3cQ8RR14sKSqgfEauC73V8C01asul7B7YW7N/Lw9
   +O5kLa2RE8GFx1gDaCrBBSyIq7gbuFPFYs4R1QxlhUU4mWuzxLIJwIDI+
   0uHYlO3+vqKtLAfKMf9VEZB5Oew2o2pDh/ipZC8w5aE/7Y4h1L3XUjE7E
   MV5+pgSkkweJI850v3bEQs2oGJVqLRacv2Jo4u3b2O83V3z8dV6DxBnA6
   +/DD2HrwcAsTfHi1Sv/PPwV8571RBzZ+X8zWVoiAvDf5Qp/SiwtjMauDj
   NKvVzmWN18Q218S+gFRRRXvXi79Lo2N2usDwc7YprGhLvLrka2vKvVG5z
   w==;
X-CSE-ConnectionGUID: p/AEMKbdQzOvloNI9DLtfQ==
X-CSE-MsgGUID: A2Fmi3BcQzuINmyNVo51Nw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3158960"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3158960"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 03:23:47 -0800
X-CSE-ConnectionGUID: Yl31/VppQL2nInN4ddsjYw==
X-CSE-MsgGUID: wre3TtAsRdCFI3XIitlz5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="9069457"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 12 Nov 2026 03:23:44 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRSu5-000000000rX-33QU;
	Thu, 12 Nov 2026 11:23:41 +0000
Date: Thu, 12 Nov 2026 12:23:39 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 17/50] ERROR: modpost: vmlinux: symbol
 'ext4_free_group_clusters' exported twice. Previous export was in vmlinux
Message-ID: <202611121231.pfw7Gaun-lkp@intel.com>
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
config: s390-randconfig-2003-20261112 (https://download.01.org/0day-ci/archive/20261112/202611121231.pfw7Gaun-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261112/202611121231.pfw7Gaun-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611121231.pfw7Gaun-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: vmlinux: symbol 'ext4_free_group_clusters' exported twice. Previous export was in vmlinux
>> ERROR: modpost: vmlinux: symbol 'ext4_free_group_clusters_set' exported twice. Previous export was in vmlinux

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
