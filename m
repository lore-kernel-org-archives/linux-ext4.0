Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8832C342530
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 02:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773197094; cv=none; b=IiRAH8HXDVOsQKNXX5csDsRJqi4zyCuz4bAB6zjEJvzAx0l3gb+643N8WVXN4XYHpyBdhs9N79PHq8J+vFhj+a5sJ6tpHh7/qz8TAdD2RzBDhWrydUsvzOzAxAfDPKlGHz9xl4m4wJx3obNNGZb9nRtHhI7s8TvY3Wjs13iZJ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773197094; c=relaxed/simple;
	bh=aw7376Y+5fry1SPxrRsCeviGdshoDjNPD8dYCjwKLVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uk1ySU6XySQm169fUifNxcrb8GwrN+Un0GbMyTDMDzLoBq40taA3zhIebTpk/y4kHZTaCYDWyUgtiRmBP61nGTIwaG2JSaF2fKiMdna6zgI6AOKd3a4wCeR5aFDOc0uq2eD7NoYM9zidW8jAj1Sg5UYBmd/9InXSEYbRxRYeliY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bwt89s1J; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bwt89s1J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773197091; x=1804733091;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aw7376Y+5fry1SPxrRsCeviGdshoDjNPD8dYCjwKLVA=;
  b=bwt89s1JFX2S+uAWrDjItjaEOgBavMR3xXpGzz66EAU2BJkBIFVYYw5F
   bOYXgZ7MqbzdY4ukJQCbMGal6h/iv1F7GXkJbZFds2QnARUgi2ziJrHxj
   SInESG5qv1VhB7NX0cSfUS+S3LQV1RBOdhMK78bU0sulls+iTgqY35r+u
   NM3iR2S9GeQdmAbHpI56rv+ASpdVWFNXJ0+vyCQmtP87mw5D/x2iqJotn
   9jQ5UbmZE3iKfYuXnChS3AuYDzCy4mO//tHLvaGgkwi6roQ1O4eDJPV4d
   ti3KR5tnAkFXUVMi3XLPsjHO6GqMeODtUqXVPWFAenKB/pLaXUmFxakxS
   A==;
X-CSE-ConnectionGUID: J07aDc0IRgy3+msO6NwOLQ==
X-CSE-MsgGUID: v25G8mlIRaaeRO7hz+3fZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="74134162"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="74134162"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 19:44:51 -0700
X-CSE-ConnectionGUID: C98uoD5xRxmWjqykstzOGQ==
X-CSE-MsgGUID: k5iiteuBRwmwOE7a45V+ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="219442196"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 10 Mar 2026 19:44:50 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w09Z0-000000000bZ-2HrH;
	Wed, 11 Mar 2026 02:44:46 +0000
Date: Wed, 11 Mar 2026 10:44:45 +0800
From: kernel test robot <lkp@intel.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, jack@suse.cz
Subject: Re: [PATCH -next 1/8] ext4: fix mballoc-test.c is not compiled when
 EXT4_KUNIT_TESTS=M
Message-ID: <202603111026.Utt3pe7W-lkp@intel.com>
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
config: sh-defconfig (https://download.01.org/0day-ci/archive/20260311/202603111026.Utt3pe7W-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260311/202603111026.Utt3pe7W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603111026.Utt3pe7W-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ext4/mballoc.c:4088:1: warning: no previous prototype for 'ext4_mb_mark_context' [-Wmissing-prototypes]
    4088 | ext4_mb_mark_context(handle_t *handle, struct super_block *sb, bool state,
         | ^~~~~~~~~~~~~~~~~~~~


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
