From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 4/6] ext4: Provide ext4_issue_zeroout()
Date: Wed, 14 Oct 2015 21:18:38 +0800
Message-ID: <201510142156.s6DA4V23%fengguang.wu@intel.com>
References: <1444822227-29984-5-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64489 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbbJNNT1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Oct 2015 09:19:27 -0400
Content-Disposition: inline
In-Reply-To: <1444822227-29984-5-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

[auto build test WARNING on v4.3-rc5 -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Jan-Kara/ext4-Punch-hole-and-DAX-fixes/20151014-193637
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/extents.c:3124:44: sparse: incorrect type in argument 2 (different base types)
   fs/ext4/extents.c:3124:44:    expected unsigned int [unsigned] [usertype] lblk
   fs/ext4/extents.c:3124:44:    got restricted __le32 [usertype] ee_block

vim +3124 fs/ext4/extents.c

  3108	
  3109		if (ee_len == 0)
  3110			return 0;
  3111	
  3112		return ext4_es_insert_extent(inode, ee_block, ee_len, ee_pblock,
  3113					     EXTENT_STATUS_WRITTEN);
  3114	}
  3115	
  3116	/* FIXME!! we need to try to merge to left or right after zero-out  */
  3117	static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
  3118	{
  3119		ext4_fsblk_t ee_pblock;
  3120		unsigned int ee_len;
  3121	
  3122		ee_len    = ext4_ext_get_actual_len(ex);
  3123		ee_pblock = ext4_ext_pblock(ex);
> 3124		return ext4_issue_zeroout(inode, ex->ee_block, ee_pblock, ee_len);
  3125	}
  3126	
  3127	/*
  3128	 * ext4_split_extent_at() splits an extent at given block.
  3129	 *
  3130	 * @handle: the journal handle
  3131	 * @inode: the file inode
  3132	 * @path: the path to the extent

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
