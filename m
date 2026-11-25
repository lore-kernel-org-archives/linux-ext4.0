Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629557;
	b=gcO9zsOS1/TCYc/mw4xsxwPmJVGl1jI7GucvteV6zUemxrfNBr+hDEogfJUE9n/oESmt
	 1Jh9+vr0yaW9i4yXupeMQPDqm2tuloryeR7T+sEeZjddfpkEAjhYXcPRT/tP6quJ+AupR
	 bQUK6jWZ1/Kt6tM3UUAls3C1IEv+5ZQYMyOBsHFR70zBtjHP1QKGyd1KlICJfQctk6dgp
	 SRES81ixtV/XnHBkGHIXnjrrm2dgKFVKutiEWJ82QD0oNAdbelwueABooOdmEuzBo9GGi
	 5j91zB/3HrITVbDF/f8LzDKefTDR7Xdontr3UgdiUZMIIvIAD8yOR56EzDzPJ01U3PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629557;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=tj3svyRH79ns9vggL+rhHTfAezewbARIYweC/Uo3nEE=;
	b=HZiM+bGOwbe1vUOnVQhov+ZSE8DqsFIZuo2SBygZ6DPaFOk+1kddtDdDHvIFne0w58jD
	 Ixym3NnuRVnN/Em1jNo5GqR3tlZc5m/ST+BVp65tIq8XYArs0aBcNBFlVZPfog/jAPdxn
	 bGEfipLRnoBY9FddawbGe+774cyFK2ROlYfut1bcaoh5wxPnf4JLyo62mWLWruUO/4iuI
	 b3bsN4iH9lMSjfHNbbRi5TYu4F+RYPN7xs6Iqw46Fnf5yXgedmlJSQ8PbXQDztYH7ublg
	 OBOK8F5a3horDrPWC05y92elM2He5//PS/3ZGikF9Uo9jmsPEUyTcMajA9xySMJxUxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="Jv+p/UrP";
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D6D606A330
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 17:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3D6D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Jv+p/UrP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795629556; x=1827165556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wSgyRuFWzKiJgk6KDlG9IQ8UVmbFTW2rs/stKcnF2hg=;
  b=Jv+p/UrP9MAbOq8pF9hIxAS2HpNBnnhwEz+3SBHzKp64UMTlQNHXBKDC
   vmvYRv2+HtUCwA/trmHoAg8pp0zIhMG3YN473SSfCJnGEvLY3JBD0yDdL
   5jHd3IezU631rwb7uCUkNQsI8nyfwp2FilGNXB8jZ46moA8ZMEyOn2HUm
   qrkjT5YpXnuKTCXYJqCVYPL8yoKYuNdDUtnl9/y/h9g2Cjo5uWaBwLBfb
   VnzwbYnoB9iXOX+GUe2O4Tywmi/bodwOBfXNqo/yWvi0X2TkQObcZkEb6
   psnft1MUOl/hLT/HtjUSIyQXslPLhEiGHwC39z0LFv6xcC8tup8CXSNhV
   Q==;
X-CSE-ConnectionGUID: m/yCOSkVRKCI2aEDu2LJXQ==
X-CSE-MsgGUID: KSypTrtcT56LNIWSdpeKRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4462376"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4462376"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 09:59:15 -0800
X-CSE-ConnectionGUID: b6g6o16sSziElsYiflcf/A==
X-CSE-MsgGUID: bz1FLTcZTgqonjOMC4JBzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="13597395"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 25 Nov 2026 09:59:14 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWHGw-00000001SGO-3u2B;
	Wed, 25 Nov 2026 17:59:10 +0000
Date: Thu, 26 Nov 2026 01:58:17 +0800
From: kernel test robot <lkp@intel.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, jack@suse.cz
Subject: Re: [PATCH v2 2/2] ext4: protect ext4_acquire_dquot against freezing
Message-ID: <20261126015002.1lcIDaq1-lkp@intel.com>
References: <20261125111055.3672233-3-yebin@huaweicloud.com>
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
In-Reply-To: <20261125111055.3672233-3-yebin@huaweicloud.com>

Hi Ye,

kernel test robot noticed the following build errors:

[auto build test ERROR on tytso-ext4/dev]
[also build test ERROR on linus/master v7.4-rc4]
[cannot apply to brauner-vfs/vfs.all next-20261124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ye-Bin/quota-Forbid-Q_XGETQUOTA-and-Q_XGETNEXTQUOTA-for-frozen-filesystem/20261125-191054
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
patch link:    https://lore.kernel.org/r/20261125111055.3672233-3-yebin%40huaweicloud.com
patch subject: [PATCH v2 2/2] ext4: protect ext4_acquire_dquot against freezing
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261126/20261126015002.1lcIDaq1-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126015002.1lcIDaq1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126015002.1lcIDaq1-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/ext4/super.c: In function 'ext4_write_dquot':
>> fs/ext4/super.c:7165:13: error: 'freeze_protected' undeclared (first use in this function); did you mean 'freeze_processes'?
    7165 |         if (freeze_protected)
         |             ^~~~~~~~~~~~~~~~
         |             freeze_processes
   fs/ext4/super.c:7165:13: note: each undeclared identifier is reported only once for each function it appears in


vim +7165 fs/ext4/super.c

  7144	
  7145	static int ext4_write_dquot(struct dquot *dquot)
  7146	{
  7147		int ret, err;
  7148		handle_t *handle;
  7149		struct inode *inode;
  7150	
  7151		inode = dquot_to_inode(dquot);
  7152		handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
  7153					    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
  7154		if (IS_ERR(handle))
  7155			return PTR_ERR(handle);
  7156		ret = dquot_commit(dquot);
  7157		if (ret < 0)
  7158			ext4_error_err(dquot->dq_sb, -ret,
  7159				       "Failed to commit dquot type %d",
  7160				       dquot->dq_id.type);
  7161		err = ext4_journal_stop(handle);
  7162		if (!ret)
  7163			ret = err;
  7164	
> 7165		if (freeze_protected)
  7166			sb_end_intwrite(dquot->dq_sb);
  7167	
  7168		return ret;
  7169	}
  7170	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
