Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1AF1D5CD1
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773199622; cv=none; b=Ms2Gr/YtbvGgEhivDO9L4f8HWLpiE4pKblzQP6iTVkkbXhe/ZCNBCrgidstO1ug0mmVKM2AG4g9BAUu2ABjlfJCoaTKUyPDaQx0WTGgjNZHbGysXIXzYBnrch0b6oB38jAp4CWZ7Sp4IXoFJFAPx2w7iW80ld8IaZ4WkmPohUM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773199622; c=relaxed/simple;
	bh=AJBTfxINtheN/kJnfQUnsO6pz/49DSj4auccYIkYnN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LN8p21I12Zq9Kk7sV5lZnu0zRjJiX+rC5eDVNvDyrWTQtQp+5aowdqRWVKfKuKXPDqSPzuLgh/06ccV0niCmU66OU5Jyu5x7K8WcROSmrY1Rckjwzr87UjRlGeNfj1xXMJSTdURlwbnOx29l8EC1fGqB7uArmukbogdK/MKUpuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iP49S4FH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iP49S4FH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773199621; x=1804735621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AJBTfxINtheN/kJnfQUnsO6pz/49DSj4auccYIkYnN4=;
  b=iP49S4FHBACF+uyXLqULh2KtGacIMT4RCvFLtKdZDTOflKdJSOR43ked
   whRmp6zon0pSjc+oyoYt0KkqaNMwZa3V1XpCQslDeMnnrPe2/4JoEEsB2
   J7+3GCFKZNFvUmujgKvcWwrvakPi9uPTeV3E36RzKI92H6B9euM/CQSl9
   8nP3TF/Vjk4r+RIyJ8BiYoJXZzYTRV2Yb/BX04ziF75zC2yEkhg24Kccj
   nzok1NALg1Dv3C4fv3AceLleZXcMHR1zapziiuaaWAV37zs4SgQzpNoR2
   AOQ7ly5tVlN9Mo18e2E5evnU8jwEdXQPj2eDUzMp9m+Jmyn/X4noY0JZS
   w==;
X-CSE-ConnectionGUID: s5VaBOllRUyqlWMeP0HSFQ==
X-CSE-MsgGUID: I7BorB/HTcuV1km49VVnoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="85613365"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="85613365"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 20:27:00 -0700
X-CSE-ConnectionGUID: 3JuFAnyESMO8ZhPgW4vaqA==
X-CSE-MsgGUID: fEXgHjYoTbqs3iIL4zjWwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="222870403"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 10 Mar 2026 20:26:58 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0ADn-000000000eP-2Z5T;
	Wed, 11 Mar 2026 03:26:55 +0000
Date: Wed, 11 Mar 2026 11:26:46 +0800
From: kernel test robot <lkp@intel.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, jack@suse.cz
Subject: Re: [PATCH -next 1/8] ext4: fix mballoc-test.c is not compiled when
 EXT4_KUNIT_TESTS=M
Message-ID: <202603111133.Ll6eI2uT-lkp@intel.com>
References: <20260310130412.3156753-2-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310130412.3156753-2-yebin@huaweicloud.com>

Hi Ye,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260309]

url:    https://github.com/intel-lab-lkp/linux/commits/Ye-Bin/ext4-fix-mballoc-test-c-is-not-compiled-when-EXT4_KUNIT_TESTS-M/20260310-225016
base:   next-20260309
patch link:    https://lore.kernel.org/r/20260310130412.3156753-2-yebin%40huaweicloud.com
patch subject: [PATCH -next 1/8] ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
config: um-defconfig (https://download.01.org/0day-ci/archive/20260311/202603111133.Ll6eI2uT-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 7d47b695929cc7f85eeb0f87d0189adc04c1c629)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260311/202603111133.Ll6eI2uT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603111133.Ll6eI2uT-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ext4/mballoc.c:4088:1: warning: no previous prototype for function 'ext4_mb_mark_context' [-Wmissing-prototypes]
    4088 | ext4_mb_mark_context(handle_t *handle, struct super_block *sb, bool state,
         | ^
   fs/ext4/mballoc.c:4087:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    4087 | int
         | ^
         | static 
   1 warning generated.


vim +/ext4_mb_mark_context +4088 fs/ext4/mballoc.c

c9de560ded61faa Alex Tomas 2008-01-29  4084  
c431d3867e0a825 Kemeng Shi 2023-09-29  4085  #define EXT4_MB_BITMAP_MARKED_CHECK 0x0001
c431d3867e0a825 Kemeng Shi 2023-09-29  4086  #define EXT4_MB_SYNC_UPDATE 0x0002
74bd22ec0285256 Ye Bin     2026-03-10  4087  int
c431d3867e0a825 Kemeng Shi 2023-09-29 @4088  ext4_mb_mark_context(handle_t *handle, struct super_block *sb, bool state,
c431d3867e0a825 Kemeng Shi 2023-09-29  4089  		     ext4_group_t group, ext4_grpblk_t blkoff,
c431d3867e0a825 Kemeng Shi 2023-09-29  4090  		     ext4_grpblk_t len, int flags, ext4_grpblk_t *ret_changed)
f9e2d95a4532185 Kemeng Shi 2023-09-29  4091  {
f9e2d95a4532185 Kemeng Shi 2023-09-29  4092  	struct ext4_sb_info *sbi = EXT4_SB(sb);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4093  	struct buffer_head *bitmap_bh = NULL;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4094  	struct ext4_group_desc *gdp;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4095  	struct buffer_head *gdp_bh;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4096  	int err;
c431d3867e0a825 Kemeng Shi 2023-09-29  4097  	unsigned int i, already, changed = len;
bdefd689b7ff0ea Kemeng Shi 2023-09-29  4098  
bdefd689b7ff0ea Kemeng Shi 2023-09-29  4099  	KUNIT_STATIC_STUB_REDIRECT(ext4_mb_mark_context,
bdefd689b7ff0ea Kemeng Shi 2023-09-29  4100  				   handle, sb, state, group, blkoff, len,
bdefd689b7ff0ea Kemeng Shi 2023-09-29  4101  				   flags, ret_changed);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4102  
c431d3867e0a825 Kemeng Shi 2023-09-29  4103  	if (ret_changed)
c431d3867e0a825 Kemeng Shi 2023-09-29  4104  		*ret_changed = 0;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4105  	bitmap_bh = ext4_read_block_bitmap(sb, group);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4106  	if (IS_ERR(bitmap_bh))
f9e2d95a4532185 Kemeng Shi 2023-09-29  4107  		return PTR_ERR(bitmap_bh);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4108  
c431d3867e0a825 Kemeng Shi 2023-09-29  4109  	if (handle) {
c431d3867e0a825 Kemeng Shi 2023-09-29  4110  		BUFFER_TRACE(bitmap_bh, "getting write access");
c431d3867e0a825 Kemeng Shi 2023-09-29  4111  		err = ext4_journal_get_write_access(handle, sb, bitmap_bh,
c431d3867e0a825 Kemeng Shi 2023-09-29  4112  						    EXT4_JTR_NONE);
c431d3867e0a825 Kemeng Shi 2023-09-29  4113  		if (err)
c431d3867e0a825 Kemeng Shi 2023-09-29  4114  			goto out_err;
c431d3867e0a825 Kemeng Shi 2023-09-29  4115  	}
c431d3867e0a825 Kemeng Shi 2023-09-29  4116  
f9e2d95a4532185 Kemeng Shi 2023-09-29  4117  	err = -EIO;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4118  	gdp = ext4_get_group_desc(sb, group, &gdp_bh);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4119  	if (!gdp)
f9e2d95a4532185 Kemeng Shi 2023-09-29  4120  		goto out_err;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4121  
c431d3867e0a825 Kemeng Shi 2023-09-29  4122  	if (handle) {
c431d3867e0a825 Kemeng Shi 2023-09-29  4123  		BUFFER_TRACE(gdp_bh, "get_write_access");
c431d3867e0a825 Kemeng Shi 2023-09-29  4124  		err = ext4_journal_get_write_access(handle, sb, gdp_bh,
c431d3867e0a825 Kemeng Shi 2023-09-29  4125  						    EXT4_JTR_NONE);
c431d3867e0a825 Kemeng Shi 2023-09-29  4126  		if (err)
c431d3867e0a825 Kemeng Shi 2023-09-29  4127  			goto out_err;
c431d3867e0a825 Kemeng Shi 2023-09-29  4128  	}
c431d3867e0a825 Kemeng Shi 2023-09-29  4129  
f9e2d95a4532185 Kemeng Shi 2023-09-29  4130  	ext4_lock_group(sb, group);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4131  	if (ext4_has_group_desc_csum(sb) &&
f9e2d95a4532185 Kemeng Shi 2023-09-29  4132  	    (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))) {
f9e2d95a4532185 Kemeng Shi 2023-09-29  4133  		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4134  		ext4_free_group_clusters_set(sb, gdp,
f9e2d95a4532185 Kemeng Shi 2023-09-29  4135  			ext4_free_clusters_after_init(sb, group, gdp));
f9e2d95a4532185 Kemeng Shi 2023-09-29  4136  	}
f9e2d95a4532185 Kemeng Shi 2023-09-29  4137  
c431d3867e0a825 Kemeng Shi 2023-09-29  4138  	if (flags & EXT4_MB_BITMAP_MARKED_CHECK) {
f9e2d95a4532185 Kemeng Shi 2023-09-29  4139  		already = 0;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4140  		for (i = 0; i < len; i++)
f9e2d95a4532185 Kemeng Shi 2023-09-29  4141  			if (mb_test_bit(blkoff + i, bitmap_bh->b_data) ==
f9e2d95a4532185 Kemeng Shi 2023-09-29  4142  					state)
f9e2d95a4532185 Kemeng Shi 2023-09-29  4143  				already++;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4144  		changed = len - already;
c431d3867e0a825 Kemeng Shi 2023-09-29  4145  	}
f9e2d95a4532185 Kemeng Shi 2023-09-29  4146  
f9e2d95a4532185 Kemeng Shi 2023-09-29  4147  	if (state) {
f9e2d95a4532185 Kemeng Shi 2023-09-29  4148  		mb_set_bits(bitmap_bh->b_data, blkoff, len);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4149  		ext4_free_group_clusters_set(sb, gdp,
f9e2d95a4532185 Kemeng Shi 2023-09-29  4150  			ext4_free_group_clusters(sb, gdp) - changed);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4151  	} else {
f9e2d95a4532185 Kemeng Shi 2023-09-29  4152  		mb_clear_bits(bitmap_bh->b_data, blkoff, len);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4153  		ext4_free_group_clusters_set(sb, gdp,
f9e2d95a4532185 Kemeng Shi 2023-09-29  4154  			ext4_free_group_clusters(sb, gdp) + changed);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4155  	}
f9e2d95a4532185 Kemeng Shi 2023-09-29  4156  
f9e2d95a4532185 Kemeng Shi 2023-09-29  4157  	ext4_block_bitmap_csum_set(sb, gdp, bitmap_bh);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4158  	ext4_group_desc_csum_set(sb, group, gdp);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4159  	ext4_unlock_group(sb, group);
c431d3867e0a825 Kemeng Shi 2023-09-29  4160  	if (ret_changed)
c431d3867e0a825 Kemeng Shi 2023-09-29  4161  		*ret_changed = changed;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4162  
f9e2d95a4532185 Kemeng Shi 2023-09-29  4163  	if (sbi->s_log_groups_per_flex) {
f9e2d95a4532185 Kemeng Shi 2023-09-29  4164  		ext4_group_t flex_group = ext4_flex_group(sbi, group);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4165  		struct flex_groups *fg = sbi_array_rcu_deref(sbi,
f9e2d95a4532185 Kemeng Shi 2023-09-29  4166  					   s_flex_groups, flex_group);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4167  
f9e2d95a4532185 Kemeng Shi 2023-09-29  4168  		if (state)
f9e2d95a4532185 Kemeng Shi 2023-09-29  4169  			atomic64_sub(changed, &fg->free_clusters);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4170  		else
f9e2d95a4532185 Kemeng Shi 2023-09-29  4171  			atomic64_add(changed, &fg->free_clusters);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4172  	}
f9e2d95a4532185 Kemeng Shi 2023-09-29  4173  
c431d3867e0a825 Kemeng Shi 2023-09-29  4174  	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4175  	if (err)
f9e2d95a4532185 Kemeng Shi 2023-09-29  4176  		goto out_err;
c431d3867e0a825 Kemeng Shi 2023-09-29  4177  	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4178  	if (err)
f9e2d95a4532185 Kemeng Shi 2023-09-29  4179  		goto out_err;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4180  
c431d3867e0a825 Kemeng Shi 2023-09-29  4181  	if (flags & EXT4_MB_SYNC_UPDATE) {
f9e2d95a4532185 Kemeng Shi 2023-09-29  4182  		sync_dirty_buffer(bitmap_bh);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4183  		sync_dirty_buffer(gdp_bh);
c431d3867e0a825 Kemeng Shi 2023-09-29  4184  	}
f9e2d95a4532185 Kemeng Shi 2023-09-29  4185  
f9e2d95a4532185 Kemeng Shi 2023-09-29  4186  out_err:
f9e2d95a4532185 Kemeng Shi 2023-09-29  4187  	brelse(bitmap_bh);
f9e2d95a4532185 Kemeng Shi 2023-09-29  4188  	return err;
f9e2d95a4532185 Kemeng Shi 2023-09-29  4189  }
c9de560ded61faa Alex Tomas 2008-01-29  4190  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
