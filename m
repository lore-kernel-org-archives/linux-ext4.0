Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793352653;
	b=X1ewT/Bm4PxkVies7x3ercwe0oji7qlmkmzVkmvjwXrrRuloLxEdcTeqqms20mQZ6n5e
	 FJTnowQN9V0iYyoP71InRkB4zA9UJyJiYDsFTv+FxUFQ4n5og/osFefuTWOviE0J/2Mz8
	 4JIRxH/t/Ifwz1wWMQJTHMFhvqK18so0S9FIEhUbgvmh2WsMCWbwoU46bMoS+Zgu8cDIr
	 r+yh9w4NOaBhhPo300qBD1EmQ6/gq6DFNtC1WRgDpHFTqD7NhQU3S/v+nf3AJeMyLA1lk
	 R+HI/+yLjmUxwPEuAmVP6k1HVRvJtkYTRPUJLcyi7sOyOYrCLVQCTSk4LYE7K0BcK3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793352653;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=HNXKYBhmAQ9bfMn5n/sXxMSjIE/K09hf1GNdOoWl/3g=;
	b=n62QEeu3smOcBdgpJG51j6eCj0Xwc9OuHxebLnnNJLWp+gqdYISuqC68iSVsmMMrwr8J
	 LJS1VzVif8N6hvJpN4LMdkD5Ixi7Imjlz4Dp9YE0O8ClZx7fZ8XSBxKHYx21RzgbLmhRu
	 EACc83mVRE8DcZD1Np+BmkBCIOSctpJQuyvxzPGyZPYd+nKIqt74eFHvsSY3a+5sK+qcY
	 0qhkJXU/6A0+HEZXsruooZd7gAh4yauZ7CeygO4TGWHHYR1IrT5tij/BFoAbVIHj/JTux
	 mYYxOYRzI9AbsP9Ae1IT0R2kHzJFn4jF2z93fljvHnTBnU1lKaKoGcO1OWlaQE6m44g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aBSp9XOz;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624AE606A31E
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 09:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 624AE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aBSp9XOz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793352651; x=1824888651;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KA6T5ZTNZh+Mqk9KGEzSR+v/dO2imHYN3H/mALE4ecw=;
  b=aBSp9XOzp2dD+u8jEAkweD3Hn8ILSooSguIYU4fi1LbC5u0JnaCo9PwN
   GTZwPg0QtAIVw+LGVK9O2b9ceUAVrTEDgAssCM+j/A64rhO016wVt2uzT
   hIlzVIZyXDrK8N2jdQc0QSDsGEDb1JCRw+cQHudub3CXGph+20s6/BSc6
   Oss9WZbdSKtctFZi+SYxb4HxBKDXrCh4VTJYObmY9HkQsSmiR+ozOUipa
   iIzWmesfqQoZkprsy2t+ZoZjFlrukHoWbQS5Zv5tjCwNw/aMfl7/eAWy2
   p1w0ECCNJgWj5eeWKTN126eHvfZq1W87IGgI7fk2beS0b8SOqwIbRRPje
   Q==;
X-CSE-ConnectionGUID: 26vUtaypRPG/1DMSykJXcg==
X-CSE-MsgGUID: JT1GYPaATX6N4mEIA5zGsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2105688"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2105688"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 02:30:50 -0700
X-CSE-ConnectionGUID: BcqvU1G1SSm/yNnuTrC3yg==
X-CSE-MsgGUID: FOjbRedcSSGJmVE1BjhqEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5714806"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 30 Oct 2026 02:30:48 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMiwf-00000000bXQ-2MsZ;
	Fri, 30 Oct 2026 09:30:45 +0000
Date: Fri, 30 Oct 2026 17:29:45 +0800
From: kernel test robot <lkp@intel.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	linux-ext4@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, tytso@mit.edu,
	jack@suse.cz, adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v13 08/11] ext4: dirdata feature
Message-ID: <202610301711.NaWjQ2jw-lkp@intel.com>
References: <20261029122413.230409-9-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029122413.230409-9-ablagodarenko@thelustrecollective.com>

Hi Artem,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8c4f6e3376348fc3162eed86a05b933921c8f9ed]

url:    https://github.com/intel-lab-lkp/linux/commits/Artem-Blagodarenko/ext4-validate-count-against-limit-in-ext4_dx_csum_verify-_set/20261029-122400
base:   8c4f6e3376348fc3162eed86a05b933921c8f9ed
patch link:    https://lore.kernel.org/r/20261029122413.230409-9-ablagodarenko%40thelustrecollective.com
patch subject: [PATCH v13 08/11] ext4: dirdata feature
config: arm-randconfig-1000-20261030 (https://download.01.org/0day-ci/archive/20261030/202610301711.NaWjQ2jw-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261030/202610301711.NaWjQ2jw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610301711.NaWjQ2jw-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/ext4/namei.c:39:
>> fs/ext4/ext4.h:2634:29: warning: field dh_hash within 'struct ext4_dirent_hash' is less aligned than 'struct ext4_dir_entry_hash' and is usually due to 'struct ext4_dirent_hash' being packed, which can lead to unaligned accesses [-Wunaligned-access]
    2634 |         struct ext4_dir_entry_hash      dh_hash;
         |                                         ^
   1 warning generated.


vim +2634 fs/ext4/ext4.h

ca153a95a4cb6a fs/ext4/ext4.h          Artem Blagodarenko 2026-10-29  2631  
ca153a95a4cb6a fs/ext4/ext4.h          Artem Blagodarenko 2026-10-29  2632  struct ext4_dirent_hash {
ca153a95a4cb6a fs/ext4/ext4.h          Artem Blagodarenko 2026-10-29  2633  	struct ext4_dirent_data_header	dh_header;
ca153a95a4cb6a fs/ext4/ext4.h          Artem Blagodarenko 2026-10-29 @2634  	struct ext4_dir_entry_hash	dh_hash;
ca153a95a4cb6a fs/ext4/ext4.h          Artem Blagodarenko 2026-10-29  2635  } __packed;
ac27a0ec112a08 include/linux/ext4_fs.h Dave Kleikamp      2006-10-11  2636  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
