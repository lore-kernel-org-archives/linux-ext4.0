Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F179318A6A8;
	Thu, 28 May 2026 04:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941817; cv=none; b=PfqSueGj7F0P5rx3jITirtT68ns5Em3rAIknt9mKkDm6GdWrD9mkpUc9Hadt7Y1rIDuSwRVGSkWO+OyYhipYE+PUj5466sU//7TtFOWAli9Xh6RPPqZQkIhx/S+yB/g2mFVcqZzAMUhTmgkPCeiam8vFVpp0Jjyq6jzNP9X0qo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941817; c=relaxed/simple;
	bh=L4St+FeXkXL/CJdEJFoCqIStllzTlH7334r8dmo789o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYhhvR5x6/Xi00qn4L4X6z3ULde+gCbadU6V28l2zAqyllShF0xUOdnL8aSXZIlsW6K4jKG51P1jh1C0FprxMbvezqOmJNoYXVxRvopwKGjT5gdijpnYyLerxVSbIOMeYhw67KFc0aYF5px55/mNC0660LofteDvqNK/KzHUu74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H9LbwsVH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H9LbwsVH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779941814; x=1811477814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L4St+FeXkXL/CJdEJFoCqIStllzTlH7334r8dmo789o=;
  b=H9LbwsVHVVeVgyzwBNJbY20vQmOOzsZtb9MR8IzyWFjdigfPqVFP9135
   QnFDx/8DGabiwGJi3cqwH4+ZgjQlrdp2Gx6DJtkWaMQaw1WXAdVyBnLMJ
   U7rwSt2FWI3q4XSaZL2n9AhIUViYg/GnnhRbHJZTACi2M59a5PtG7DVNG
   BYff/DjXZHNpqiYNQgjjudxi97HxjRapB1zsaE5XA10/vx8WEnjME8VY1
   MpltaPUt220d4N9cBIlMwEfQvPTmG0p3FYWP9teC28gTYQaULbMwG+7vk
   OTjE8MD21u30T2J2C9fC3Hbi66ezy7mPDElCvGEEH8zNOZ6waqqJj3/Bq
   A==;
X-CSE-ConnectionGUID: CPUSeRHjTd2EITxIAEUcxA==
X-CSE-MsgGUID: eQmcLA3qT6KcArMUODyPTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="92168850"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="92168850"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 21:16:53 -0700
X-CSE-ConnectionGUID: 1yDSCXzvSZW0xfvYbEyPlg==
X-CSE-MsgGUID: fvL5Fjy3SKup3T9Q/9LH7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="280553178"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 27 May 2026 21:16:52 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSSAr-000000005Ws-1TsX;
	Thu, 28 May 2026 04:16:49 +0000
Date: Thu, 28 May 2026 12:16:32 +0800
From: kernel test robot <lkp@intel.com>
To: Ashwin Gundarapu <linuxuser509@zohomail.in>, jack <jack@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ext2: Remove deprecated DAX support
Message-ID: <202605281203.e91xvDyr-lkp@intel.com>
References: <19e5aa07c9b.3a2e576d130187.5289857983023045470@zohomail.in>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e5aa07c9b.3a2e576d130187.5289857983023045470@zohomail.in>

Hi Ashwin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jack-fs/for_next]
[also build test WARNING on linus/master v7.1-rc5 next-20260527]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashwin-Gundarapu/ext2-Remove-deprecated-DAX-support/20260524-233631
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next
patch link:    https://lore.kernel.org/r/19e5aa07c9b.3a2e576d130187.5289857983023045470%40zohomail.in
patch subject: [PATCH v4] ext2: Remove deprecated DAX support
config: arm-randconfig-r071-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281203.e91xvDyr-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
smatch: v0.5.0-9185-gbcc58b9c

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281203.e91xvDyr-lkp@intel.com/

smatch warnings:
fs/ext2/inode.c:1251 ext2_setsize() warn: inconsistent indenting

vim +1251 fs/ext2/inode.c

737f2e93b9724a3 Nicholas Piggin   2010-05-27  1236  
2c27c65ed0696f0 Christoph Hellwig 2010-06-04  1237  static int ext2_setsize(struct inode *inode, loff_t newsize)
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1238  {
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1239  	int error;
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1240  
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1241  	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1242  	    S_ISLNK(inode->i_mode)))
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1243  		return -EINVAL;
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1244  	if (ext2_inode_is_fast_symlink(inode))
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1245  		return -EINVAL;
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1246  	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1247  		return -EPERM;
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1248  
562c72aa57c36b1 Christoph Hellwig 2011-06-24  1249  	inode_dio_wait(inode);
562c72aa57c36b1 Christoph Hellwig 2011-06-24  1250  
737f2e93b9724a3 Nicholas Piggin   2010-05-27 @1251  			error = block_truncate_page(inode->i_mapping,
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1252  								newsize, ext2_get_block);
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1253  	if (error)
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1254  		return error;
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1255  
70f3bad8c3154ba Jan Kara          2021-04-12  1256  	filemap_invalidate_lock(inode->i_mapping);
2c27c65ed0696f0 Christoph Hellwig 2010-06-04  1257  	truncate_setsize(inode, newsize);
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1258  	__ext2_truncate_blocks(inode, newsize);
70f3bad8c3154ba Jan Kara          2021-04-12  1259  	filemap_invalidate_unlock(inode->i_mapping);
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1260  
5cdc59fce617a2e Jeff Layton       2023-10-04  1261  	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
^1da177e4c3f415 Linus Torvalds    2005-04-16  1262  	if (inode_needs_sync(inode)) {
b0439bbc29f0201 Jan Kara          2026-03-26  1263  		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
c37650161a53c01 Christoph Hellwig 2010-10-06  1264  		sync_inode_metadata(inode, 1);
^1da177e4c3f415 Linus Torvalds    2005-04-16  1265  	} else {
^1da177e4c3f415 Linus Torvalds    2005-04-16  1266  		mark_inode_dirty(inode);
^1da177e4c3f415 Linus Torvalds    2005-04-16  1267  	}
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1268  
737f2e93b9724a3 Nicholas Piggin   2010-05-27  1269  	return 0;
^1da177e4c3f415 Linus Torvalds    2005-04-16  1270  }
^1da177e4c3f415 Linus Torvalds    2005-04-16  1271  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
