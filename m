Return-Path: <SRS0=T+aA=MK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39812 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeI1XQF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2018 19:16:05 -0400
Received: by mail-yw1-f67.google.com with SMTP id v1-v6so2896442ywv.6
        for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2018 09:51:28 -0700 (PDT)
Date: Fri, 28 Sep 2018 12:51:24 -0400
From: Eric Whitney <enwlinux@gmail.com>
To: kbuild test robot <lkp@intel.com>
Cc: Eric Whitney <enwlinux@gmail.com>, kbuild-all@01.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 3/6] ext4: fix reserved cluster accounting at delayed
 write time
Message-ID: <20180928165124.cqj2qoexk47ybk64@localhost.localdomain>
References: <20180912160802.29369-4-enwlinux@gmail.com>
 <201809140819.sO5sZZB9%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201809140819.sO5sZZB9%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* kbuild test robot <lkp@intel.com>:
> Hi Eric,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on ext4/dev]
> [also build test ERROR on v4.19-rc3 next-20180913]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Whitney/ext4-rework-bigalloc-reserved-cluster-accounting/20180914-053634
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> config: x86_64-randconfig-s4-09140719 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> Note: the linux-review/Eric-Whitney/ext4-rework-bigalloc-reserved-cluster-accounting/20180914-053634 HEAD efc30d747afd91b3bd9eb7fd218d0d1f7613c5a0 builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    fs//ext4/inode.c: In function 'ext4_insert_delayed_block':
> >> fs//ext4/inode.c:1816:33: error: 'ext4_es_is_delonly' undeclared (first use in this function); did you mean 'ext4_es_is_delayed'?
>       if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
>                                     ^~~~~~~~~~~~~~~~~~
>                                     ext4_es_is_delayed
>    fs//ext4/inode.c:1816:33: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +1816 fs//ext4/inode.c
> 
>   1782	
>   1783	/*
>   1784	 * ext4_insert_delayed_block - adds a delayed block to the extents status
>   1785	 *                             tree, incrementing the reserved cluster/block
>   1786	 *                             count or making a pending reservation
>   1787	 *                             where needed
>   1788	 *
>   1789	 * @inode - file containing the newly added block
>   1790	 * @lblk - logical block to be added
>   1791	 *
>   1792	 * Returns 0 on success, negative error code on failure.
>   1793	 */
>   1794	static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
>   1795	{
>   1796		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>   1797		int ret;
>   1798		bool allocated = false;
>   1799	
>   1800		/*
>   1801		 * If the cluster containing lblk is shared with a delayed,
>   1802		 * written, or unwritten extent in a bigalloc file system, it's
>   1803		 * already been accounted for and does not need to be reserved.
>   1804		 * A pending reservation must be made for the cluster if it's
>   1805		 * shared with a written or unwritten extent and doesn't already
>   1806		 * have one.  Written and unwritten extents can be purged from the
>   1807		 * extents status tree if the system is under memory pressure, so
>   1808		 * it's necessary to examine the extent tree if a search of the
>   1809		 * extents status tree doesn't get a match.
>   1810		 */
>   1811		if (sbi->s_cluster_ratio == 1) {
>   1812			ret = ext4_da_reserve_space(inode);
>   1813			if (ret != 0)   /* ENOSPC */
>   1814				goto errout;
>   1815		} else {   /* bigalloc */
> > 1816			if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
>   1817				if (!ext4_es_scan_clu(inode,
>   1818						      &ext4_es_is_mapped, lblk)) {
>   1819					ret = ext4_clu_mapped(inode,
>   1820							      EXT4_B2C(sbi, lblk));
>   1821					if (ret < 0)
>   1822						goto errout;
>   1823					if (ret == 0) {
>   1824						ret = ext4_da_reserve_space(inode);
>   1825						if (ret != 0)   /* ENOSPC */
>   1826							goto errout;
>   1827					} else {
>   1828						allocated = true;
>   1829					}
>   1830				} else {
>   1831					allocated = true;
>   1832				}
>   1833			}
>   1834		}
>   1835	
>   1836		ret = ext4_es_insert_delayed_block(inode, lblk, allocated);
>   1837	
>   1838	errout:
>   1839		return ret;
>   1840	}
>   1841	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


Hi-

Please pardon the delay - I'm just back from vacation.

Thanks for catching this.  Although this patch series isn't functionally
bisectable (in the sense that ext4 won't function correctly during a
bisection within this patch series - unavoidably, all six patches are
required for the code to work), failing compilation after a patch needs
to be fixed.  It is, in the v3 I've just posted, by simply moving the
definition of ext4_es_is_delonly() one patch earlier in the sequence.

Thanks for the testing!
Eric
