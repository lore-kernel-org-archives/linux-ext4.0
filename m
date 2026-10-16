Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA7B3E3D9E
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 07:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137535; cv=none; b=fw6BWmnCC5zK9tzFLJ2T9v+1GIjvRQ851oaniCuQuuKgupOegt0tt/Xv2ErQatI/TK2nGjZe2gqx7Ic0TSc3vJzjGj/BWavohs78viznHp1m24Z+gOfzABN3ElQ0Gz8L0ctSoabZ+L1K7zWAMCcElcuS10NSGRKUz284y+yOk4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137535; c=relaxed/simple;
	bh=jCRKt2XU89OMC7gBAdYHQaXDL9OB2wG2XOum1jG4I6g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CMtmhleWTzkTcIwt2VdH0XrASzEfQ9l27qINoyEQSox9pdRa66Uh3NDYgIyHE1lJbvzz89K5VxXTcNwJGiYBnD0d2KlvT4nooH7CyMHrB/Jm3mRs1kUATUrJEuq0ryZu68O2RzqQR0tJlxIRTesBlleRgBgjNyPpCPydgglD5uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UvW2yjKy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UvW2yjKy"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a021c809e3so57596355e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 00:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792137532; x=1792742332; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RdDTPL+e3DfNdEsfD+HIy5AjVm5FA/QQsbvM5foi09A=;
        b=UvW2yjKyAQFdFj5I6+6thGq1GeDM14K2GqakXpHT6Bo+QUouPZVjdLb5HYV51jPOwh
         W9beg+JgD8lNdd8adSxmCScjSbqZ55VVCsFHoMppnyj8CLWG1hhkZNzOcZFiUpyaec1e
         AjAG5fRLZkWP6aBQhnnbp2BOkf5mXAzhoxfIZ6XUUc7g8slya9gFCNflBazlK2VsotlU
         ziKMrRlvP5kiqlAicWid7AHzTdKynHPiUJtzV5xABgGFL3Gl+mULy+NGuNDYumARMr2x
         SJmq+R7hlNHg6elKlOrM8cc8pfx2sHrAbPops7nTJXcL+yOgsWl6JsZVO/Xm/PVVeEXM
         Murw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792137532; x=1792742332;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RdDTPL+e3DfNdEsfD+HIy5AjVm5FA/QQsbvM5foi09A=;
        b=Am2StU8zjgE3wLCxOEby0k/N2Z4Wt1Mq0MPX7MtHTcSldVMmJ46N7IA6TKR9p1a/HD
         ySmvIi/XZNbPqMhnP26NsncblWJbLAAlZlB5ZW6RGKbqZdvfJPbU8FOjV9KY3SlUBUiA
         fJy5423CwgHTjaXB6F2s/uIWCURMm3jheC67Ab5kM6ohDq/Ki7659drQ8wwM37BkuQ3z
         9kehmxw1sMq0h2XHgZ+mqBBx61HcPoTE5O1qDH7yD8oPjgxwK1PUWYYut6rH34cAWmj8
         FjVW14NuXY/5YZUauygmLturZaiXrnSHysRjugb16mNuKyQHeJ4p32WULqEeAmNaRhaB
         K+2Q==
X-Forwarded-Encrypted: i=1; AKwUvBz7o9rtGwdQwSBFuOSVIVPPDEkff2KKsRRGvA+BgrP0rK0q0je/ShGXBi4T43Yvkym0r1ZYZBSDwQCO@vger.kernel.org
X-Gm-Message-State: AFq9FYIgq+LKFrmiZLPhsWpDLkfjYak2a/PlpZLWMosbJMFREOVAZhV+
	vwLDHe7aeQzeGTYRmi2phWPHRPGFkHndd1PNNiTsFkO5NwX1/MLyGKVc
X-Gm-Gg: AYBFou3sOc1NUEQnq6gtI2tv1SsjKcZpCvHJao7CO0z36pepIihs3cZc2ArxgnEG3QA
	/Tz0jv68OVSMkHenTtoMhRNMe5o2Ne6raYPnJq6wPIvrHD177H0mVkUPU/6p4nnroK+bPlWAiZ6
	QxFJiYeATC0auaszOwTQeQucXVkMIIb40Wn5TJ/wSPkGTtPT3fUHqqAaIQOVVTLtE+y+45NWJWy
	5no1HTM6jFcNde4yULrIQV/e0yiYHARDm5D7C0r16HLFfiH6N0w87oqkd+v6JZPuOFbwM5pT4rE
	s1xUnxPkY7RQYLWVJPBO/w7oyFE7kbiAvm3OLtbK3bEUQWabZGezUOYT+2ErukJQSe86FuU8XEO
	g3JN3Bu/fPe2oO0NTkE424N9iudEFvX/U6z17P1SOfXcR60xlndDn5rlt0CFcvvHFr+6RLx49oF
	5cdo/iF34t21pD/FOYV0RsqLRm37jUIaIJqZEJ7LC42iq/LI9bxm7T+cc5+nJrbkdsL/I=
X-Received: by 2002:a05:600c:698d:b0:4a1:97c6:d2b4 with SMTP id 5b1f17b1804b1-4a197c6d614mr360351215e9.15.1792137531460;
        Fri, 16 Oct 2026 00:58:51 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8a9ea3bsm30374275e9.0.2026.10.16.00.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 00:58:50 -0700 (PDT)
Date: Fri, 16 Oct 2026 10:58:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: oe-kbuild@lists.linux.dev, Zhang Yi <yi.zhang@huawei.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: [tytso-ext4:dev 40/41] fs/ext4/inode.c:4518 ext4_iomap_writepages()
 warn: missing error code? 'ret'
Message-ID: <atHZN9YIl8T2E0tK@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   8c4f6e3376348fc3162eed86a05b933921c8f9ed
commit: bdcbb0f19e921c7ea3241f55922032dff23d1d26 [40/41] ext4: partially enable iomap for the buffered I/O path of regular files
config: x86_64-randconfig-2200-20261016 (https://download.01.org/0day-ci/archive/20261016/202610160314.PLMEXaOJ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/

New smatch warnings:
fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? 'ret'

vim +/ret +4518 fs/ext4/inode.c

a304299a40d92c Zhang Yi 2026-10-09  4488  static int ext4_iomap_writepages(struct address_space *mapping,
a304299a40d92c Zhang Yi 2026-10-09  4489  				 struct writeback_control *wbc)
a304299a40d92c Zhang Yi 2026-10-09  4490  {
a2e096bf59634f Zhang Yi 2026-10-09  4491  	struct inode *inode = mapping->host;
a2e096bf59634f Zhang Yi 2026-10-09  4492  	struct super_block *sb = inode->i_sb;
a2e096bf59634f Zhang Yi 2026-10-09  4493  	long nr = wbc->nr_to_write;
a2e096bf59634f Zhang Yi 2026-10-09  4494  	int alloc_ctx, ret;
a2e096bf59634f Zhang Yi 2026-10-09  4495  	struct iomap_writepage_ctx wpc = {
a2e096bf59634f Zhang Yi 2026-10-09  4496  		.inode = inode,
a2e096bf59634f Zhang Yi 2026-10-09  4497  		.wbc = wbc,
a2e096bf59634f Zhang Yi 2026-10-09  4498  		.ops = &ext4_writeback_ops,
a2e096bf59634f Zhang Yi 2026-10-09  4499  	};
a2e096bf59634f Zhang Yi 2026-10-09  4500  
a2e096bf59634f Zhang Yi 2026-10-09  4501  	ret = ext4_emergency_state(sb);
a2e096bf59634f Zhang Yi 2026-10-09  4502  	if (unlikely(ret))
a2e096bf59634f Zhang Yi 2026-10-09  4503  		return ret;
a2e096bf59634f Zhang Yi 2026-10-09  4504  
53fe71a6bcad0f Zhang Yi 2026-10-09  4505  	/*
53fe71a6bcad0f Zhang Yi 2026-10-09  4506  	 * Submit the pending zeroed EOF block range if the entire
53fe71a6bcad0f Zhang Yi 2026-10-09  4507  	 * writeback range lies beyond it.
53fe71a6bcad0f Zhang Yi 2026-10-09  4508  	 */
53fe71a6bcad0f Zhang Yi 2026-10-09  4509  	ext4_iomap_wb_submit_zeroed_eof(inode, wbc);
53fe71a6bcad0f Zhang Yi 2026-10-09  4510  
a2e096bf59634f Zhang Yi 2026-10-09  4511  	alloc_ctx = ext4_writepages_down_read(sb);
bdcbb0f19e921c Zhang Yi 2026-10-09  4512  	/*
bdcbb0f19e921c Zhang Yi 2026-10-09  4513  	 * Does ext4_change_inode_journal_flag() change the inode's
bdcbb0f19e921c Zhang Yi 2026-10-09  4514  	 * buffered I/O path?
bdcbb0f19e921c Zhang Yi 2026-10-09  4515  	 */
bdcbb0f19e921c Zhang Yi 2026-10-09  4516  	if (!ext4_inode_buffered_iomap(inode)) {
bdcbb0f19e921c Zhang Yi 2026-10-09  4517  		ext4_writepages_up_read(sb, alloc_ctx);
bdcbb0f19e921c Zhang Yi 2026-10-09 @4518  		return ret;

Either return 0 or an error code here, but not ret.

bdcbb0f19e921c Zhang Yi 2026-10-09  4519  	}
bdcbb0f19e921c Zhang Yi 2026-10-09  4520  
a2e096bf59634f Zhang Yi 2026-10-09  4521  	trace_ext4_writepages(inode, wbc);
a2e096bf59634f Zhang Yi 2026-10-09  4522  	ret = iomap_writepages(&wpc);
a2e096bf59634f Zhang Yi 2026-10-09  4523  	trace_ext4_writepages_result(inode, wbc, ret, nr - wbc->nr_to_write);
a2e096bf59634f Zhang Yi 2026-10-09  4524  	ext4_writepages_up_read(sb, alloc_ctx);
a2e096bf59634f Zhang Yi 2026-10-09  4525  
a2e096bf59634f Zhang Yi 2026-10-09  4526  	return ret;
a304299a40d92c Zhang Yi 2026-10-09  4527  }

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

