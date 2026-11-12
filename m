Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794512280;
	b=Bm9JYyEchXMnv8VllFk6hFn3ZMzDcqNx/31rfu1hbLuLItj5x1tilXqTFMZGAxt2I6+w
	 ng6UP9qyVzXt8toXfJQpt8BlJJzLFO2w4H5EsQMThWFKCz5LnnJWqXp2U2I+H5vF9Rgyt
	 xF+HOB1ZfFQQblH+X92STPByBfNaBOTh7ucz5wQ4cw4NN/mXM+T0WSnsaozg8h1830/MP
	 pHe3uexuU+PXWOmsk0OUc7uPaUHmdFs10kKR60RMZteFVMZsbsR7QMxGKe0qH51Ml753M
	 rjO9zBOmVUGBdHlXcM/SAO5kszW99I/NdRNHNpzJxLZJx7autEDs0WOwGg1lND4UDgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794512280;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=9t9o3HStro6dwwCfC9ZUy8fA2TnqgsoWOJGbtf6mFSk=;
	b=yENhVMlJ2uv4T4kvHZ2CJx36aV99wFidjL9Oyjq8QhDbjw6g9vtxGq6MByLvBO2U6NZn
	 t7PvBT0UJhOuv9ufvv4i/iYKvDrxglDAACUWbPOZkt8nN7yiQJMnn+X7r6aniba1piRV/
	 KvQZW+og4GPSY4ia+5YOM78VoG/CqllTAqeLruom/2Avy/QH95xheXN6KQpRC10F9vxxa
	 DcIThoqwbKwd2vZ7SfHqxX77ZF29wCMSes1BUX+tVQCqX0Ct0YXCltfIlORbGr5DWZhe+
	 yZL7g4OGOpUK7DDXVjKopgkKzYRz0cT1PnREmkmwq11W6Fstc4pis1Tc5JsBq6gJ5ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ul6Q4qiu;
	arc=none smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C20606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 19:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16C20606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ul6Q4qiu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794512279; x=1826048279;
  h=date:from:to:cc:subject:message-id;
  bh=2ZeUqdUDEEgJpyK3JJysJVFO8s+Na2eSILqQysD05Qk=;
  b=Ul6Q4qiuEaIQ28vh6iynXICwnIq5gatY/dCCO7wPcdR5dA1a9lt9bnIB
   1tAs5X3qI3zVFxFFKkE4RDdB8HGMWGPJQFXADWa1hm4gjW2/Z9dkPggqZ
   gWtYhKeRyZHS1qjhaE4P1sk+KH3plwmozyl9JMsVuNO62P8TkjJe+mlWq
   c8LA1CwdRJYFQGxtx4zO91BOLhBWA7lzL4UUiWR5p2b5yGuzYUh+WdXCj
   +vPWEEWW1wH4z4KSdTytehZ+pzX3lHip6U1xCFesSFswo6WtZrhu9Toxp
   FFgF/LQHcAGCaX0spGc4LRDZFVrltRK1+grNlEAig7DfvhMwNVaUchrVW
   g==;
X-CSE-ConnectionGUID: OkvFYF+/RJ6YINfFCedPXg==
X-CSE-MsgGUID: jIp44tdDTeetDhZitihPuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3218137"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3218137"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 11:37:59 -0800
X-CSE-ConnectionGUID: DlgxbB/wTvacdTWpnn7dTQ==
X-CSE-MsgGUID: 1pZKl0CkT3ieLWEBvzcDWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="9069281"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa001.fm.intel.com with ESMTP; 12 Nov 2026 11:37:57 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRacM-000000000vx-2zvs;
	Thu, 12 Nov 2026 19:37:54 +0000
Date: Thu, 12 Nov 2026 20:37:38 +0100
From: kernel test robot <lkp@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org
Subject: [tytso-ext4:pu 17/50] WARNING: modpost: vmlinux: EXPORT
 symbol 'ext4_free_group_clusters' version generation failed, symbol will not
 be versioned.
Message-ID: <202611122037.vD5jQNAi-lkp@intel.com>
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
config: i386-randconfig-2102-20261112 (https://download.01.org/0day-ci/archive/20261112/202611122037.vD5jQNAi-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261112/202611122037.vD5jQNAi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611122037.vD5jQNAi-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: vmlinux: symbol 'ext4_free_group_clusters' exported twice. Previous export was in vmlinux
ERROR: modpost: vmlinux: symbol 'ext4_free_group_clusters_set' exported twice. Previous export was in vmlinux
>> WARNING: modpost: vmlinux: EXPORT symbol 'ext4_free_group_clusters' version generation failed, symbol will not be versioned.
Is 'ext4_free_group_clusters' prototyped in <asm/asm-prototypes.h>?
WARNING: modpost: vmlinux: EXPORT symbol 'ext4_free_group_clusters_set' version generation failed, symbol will not be versioned.
Is 'ext4_free_group_clusters_set' prototyped in <asm/asm-prototypes.h>?

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
