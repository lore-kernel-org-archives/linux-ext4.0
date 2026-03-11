Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0EB2C21C7
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 06:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773210786; cv=none; b=Fz86qX5Y8MfbJPMoAZ3Ce5ipnh6/SyJmwliT39LuIsA3e6iBkFQVgO3psk/fPAbnzFNUcGxc5c3GPkUsRQPs/uhuGzX+F9+e3od8FnVcBnkAPlTeeeGOaF8LvfPZpxqe3xoAfrjjrD8BXcR0Lc0/dYuTVDUDKNJMF06CDL/yxq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773210786; c=relaxed/simple;
	bh=hy2z2Qb/U5FcKACRjb1ntc8ME6okKkGmpDdfG9prsxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwmT46s0BliDbfnY2hHcHhftebAd0OVZuLNu56W4/e9WeXHon80p9DquhneIAWHsomxTx/I/Dfm3/HnywOM0A7eaBy9KlSkZ76vQkm0800Oxs9j5sSLWNNsHjRMXnwfsUX83W7RMaCnkWYZLSwgouSk5n6BTIrQkVUeNHrIuLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E7lLBxcr; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E7lLBxcr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773210784; x=1804746784;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hy2z2Qb/U5FcKACRjb1ntc8ME6okKkGmpDdfG9prsxU=;
  b=E7lLBxcr4vyAfG971Jis3Qu6Az7FMSrx/WRtXfWN559TxpHdlsMEgkAd
   Q/y7XUC2Db7mXd16UnA38RFuo8NZpS40EjU7Eiu+5f3gRVoqyZxEOrlib
   WNdaqzZKRqI7ybQyYOHFfdF9xJBWbGJ77NuRu/cG60a0miB3DViMbuOx1
   ibVt35qE4wfgaZktETp10dSkIjvCNkXCaZfpf904YIoWUgDuzW04xWnIh
   GcZ/nWKv7QClFrKTcoXPw2phAoTOnGAhvVQ6FmIV1ABSdIgxM4Yd0zcYk
   fq0E2EtUFJYkOhYEAPpwuLj+hrirGxGmCnPIzSDtFuQVt6mD8EGLAdmbj
   g==;
X-CSE-ConnectionGUID: qzEvC8fhR2qLT+ptrv9qoA==
X-CSE-MsgGUID: U9sRH5NNRWq9PCCzvrD86A==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="77876638"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="77876638"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 23:33:04 -0700
X-CSE-ConnectionGUID: WKkg2C9bRVaSUyh2hELVZw==
X-CSE-MsgGUID: 08z9iToyRRu9rbP6rvp6BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="220311560"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 10 Mar 2026 23:33:00 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0D7r-000000000oL-1IxT;
	Wed, 11 Mar 2026 06:32:59 +0000
Date: Wed, 11 Mar 2026 14:32:12 +0800
From: kernel test robot <lkp@intel.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, jack@suse.cz
Subject: Re: [PATCH -next 3/8] ext4: fix extents-test.c is not compiled when
 EXT4_KUNIT_TESTS=M
Message-ID: <202603111416.j2HqVIhj-lkp@intel.com>
References: <20260310130412.3156753-4-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310130412.3156753-4-yebin@huaweicloud.com>

Hi Ye,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260309]

url:    https://github.com/intel-lab-lkp/linux/commits/Ye-Bin/ext4-fix-mballoc-test-c-is-not-compiled-when-EXT4_KUNIT_TESTS-M/20260310-225016
base:   next-20260309
patch link:    https://lore.kernel.org/r/20260310130412.3156753-4-yebin%40huaweicloud.com
patch subject: [PATCH -next 3/8] ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
config: sh-defconfig (https://download.01.org/0day-ci/archive/20260311/202603111416.j2HqVIhj-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260311/202603111416.j2HqVIhj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603111416.j2HqVIhj-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ext4/extents.c:187:5: warning: no previous prototype for '__ext4_ext_dirty' [-Wmissing-prototypes]
     187 | int __ext4_ext_dirty(const char *where, unsigned int line,
         |     ^~~~~~~~~~~~~~~~
>> fs/ext4/extents.c:3147:5: warning: no previous prototype for 'ext4_ext_zeroout' [-Wmissing-prototypes]
    3147 | int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
         |     ^~~~~~~~~~~~~~~~


vim +/__ext4_ext_dirty +187 fs/ext4/extents.c

   180	
   181	/*
   182	 * could return:
   183	 *  - EROFS
   184	 *  - ENOMEM
   185	 *  - EIO
   186	 */
 > 187	int __ext4_ext_dirty(const char *where, unsigned int line,
   188			     handle_t *handle, struct inode *inode,
   189			     struct ext4_ext_path *path)
   190	{
   191		int err;
   192	
   193		KUNIT_STATIC_STUB_REDIRECT(__ext4_ext_dirty, where, line, handle, inode,
   194					   path);
   195	
   196		WARN_ON(!rwsem_is_locked(&EXT4_I(inode)->i_data_sem));
   197		if (path->p_bh) {
   198			ext4_extent_block_csum_set(inode, ext_block_hdr(path->p_bh));
   199			/* path points to block */
   200			err = __ext4_handle_dirty_metadata(where, line, handle,
   201							   inode, path->p_bh);
   202			/* Extents updating done, re-set verified flag */
   203			if (!err)
   204				set_buffer_verified(path->p_bh);
   205		} else {
   206			/* path points to leaf/index in inode body */
   207			err = ext4_mark_inode_dirty(handle, inode);
   208		}
   209		return err;
   210	}
   211	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
