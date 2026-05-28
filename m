Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200B836E478;
	Thu, 28 May 2026 08:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=103.117.158.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956801; cv=pass; b=EtI9au1EmVt9IWhwlZvJ68ElRQ/v2QPvZ6/ibEPEIMmVn3l+jHRYSxe+s7jHUKnfrj2bCw7TWsc+fqIg7Wg/ufWY/N6U9rg2Oc3GJNAWTNtCFZAjqtuxjtRWHequJRRx7SFQuQivO9yaNii8AXg9MncPfu2jgFo0icI69+aScAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956801; c=relaxed/simple;
	bh=/1NS+gkl7GjjY8ICVeuimsM8GB8gzdwrRtRRYetgFFg=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=cDlReh7ZJ0UyLcnBfsZaNRQqB8wY2nEmPjTlopRx/nJqxHarKF/h66usFAf0zPV9XwMOwuqCkNxzNZXfoXe+hA+O9aGq4AOhvsr0Dzk4Zx9X9CmRr+SF+zAyqPxOX+PIH1mTeqn8X+yQi79+BsJS6ALeYRYLfBxvALPH5azieVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in; spf=pass smtp.mailfrom=zohomail.in; dkim=pass (1024-bit key) header.d=zohomail.in header.i=linuxuser509@zohomail.in header.b=r0VV0Meo; arc=pass smtp.client-ip=103.117.158.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.in header.i=linuxuser509@zohomail.in header.b="r0VV0Meo"
ARC-Seal: i=1; a=rsa-sha256; t=1779956775; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=c/2YKrJKJV9nvuTGmv6roYVQmojKGuz5qRF8W4kLcf36dNTiukEJMi+gg+6Oh3197I1V3sXzxVQSf1EDtwhPXVUMWM0cWmwDS7sR4AU1BbKzOrba6yE6rKuWAbgULufitXYWVGiseV1DX8A0NRy2l8zhyJsef6SUF3ZA0f+CF6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1779956775; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=u02RJ/VBMYB77bElnPcqjbbt4TJaP39IGuZGLZTk5z4=; 
	b=Wwf+0YIfKj87kkiUC3NUT2iUkPUwxDo53s6hdRs/nncNWvMHTt0HmnZop3QiereQayeu525bZDLkOZsjbBET1U0gAfuJ3CsHATHTPBsVl+1n0Wflowm3XiI31COzpcXoF6KzLeO3DUHwk5xxoMJ3TMd0YIbWF+KTYdilVjp63uw=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=linuxuser509@zohomail.in;
	dmarc=pass header.from=<linuxuser509@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779956775;
	s=zoho; d=zohomail.in; i=linuxuser509@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=u02RJ/VBMYB77bElnPcqjbbt4TJaP39IGuZGLZTk5z4=;
	b=r0VV0MeoEKdxmXOvPs+YPRrNyLzRIfNcDjZfDWHloiPAeA2LNko1x/QO9wkpkrpj
	pWagdDUiy+T+yufNVyZcB39gMvdzFDRn7lTrzag5iOdZmsM/iNL/5/xQ0KEJLJfqizL
	GKZTE+Yb2tCj3U0c8jZhkpuSBYy+5f3xq/52+mTI=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1779956774306351.5153761474652; Thu, 28 May 2026 13:56:14 +0530 (IST)
Received: from  [106.192.19.160] by mail.zoho.in
	with HTTP;Thu, 28 May 2026 13:56:14 +0530 (IST)
Date: Thu, 28 May 2026 13:56:14 +0530
From: Ashwin Gundarapu <linuxuser509@zohomail.in>
To: "kernel test robot" <lkp@intel.com>
Cc: "jack" <jack@suse.com>, "oe-kbuild-all" <oe-kbuild-all@lists.linux.dev>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19e6db0f597.25d55d43200914.4102954258751814923@zohomail.in>
In-Reply-To: <202605281203.e91xvDyr-lkp@intel.com>
References: <19e5aa07c9b.3a2e576d130187.5289857983023045470@zohomail.in> <202605281203.e91xvDyr-lkp@intel.com>
Subject: Re: [PATCH v4] ext2: Remove deprecated DAX support
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

This indentation warning is from pre-existing code (originally written in 2010) that my patch did not touch. I prefer to keep this patch focused solely on removing deprecated DAX support. A separate cleanup patch can be submitted later if desired.
Regards,
Ashwin Gundarapu

From: kernel test robot <lkp@intel.com>
To: "Ashwin Gundarapu"<linuxuser509@zohomail.in>, "jack"<jack@suse.com>
Cc: <oe-kbuild-all@lists.linux.dev>, "linux-ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.kernel.org>
Date: Thu, 28 May 2026 09:46:32 +0530
Subject: Re: [PATCH v4] ext2: Remove deprecated DAX support

 > Hi Ashwin, 
 >  
 > kernel test robot noticed the following build warnings: 
 >  
 > [auto build test WARNING on jack-fs/for_next] 
 > [also build test WARNING on linus/master v7.1-rc5 next-20260527] 
 > [If your patch is applied to the wrong git tree, kindly drop us a note. 
 > And when submitting patch, we suggest to use '--base' as documented in 
 > https://git-scm.com/docs/git-format-patch#_base_tree_information] 
 >  
 > url: https://github.com/intel-lab-lkp/linux/commits/Ashwin-Gundarapu/ext2-Remove-deprecated-DAX-support/20260524-233631 
 > base: https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next 
 > patch link: https://lore.kernel.org/r/19e5aa07c9b.3a2e576d130187.5289857983023045470%40zohomail.in 
 > patch subject: [PATCH v4] ext2: Remove deprecated DAX support 
 > config: arm-randconfig-r071-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281203.e91xvDyr-lkp@intel.com/config) 
 > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261) 
 > smatch: v0.5.0-9185-gbcc58b9c 
 >  
 > If you fix the issue in a separate patch/commit (i.e. not just a new version of 
 > the same patch/commit), kindly add following tags 
 > | Reported-by: kernel test robot <lkp@intel.com> 
 > | Closes: https://lore.kernel.org/oe-kbuild-all/202605281203.e91xvDyr-lkp@intel.com/ 
 >  
 > smatch warnings: 
 > fs/ext2/inode.c:1251 ext2_setsize() warn: inconsistent indenting 
 >  
 > vim +1251 fs/ext2/inode.c 
 >  
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1236 
 > 2c27c65ed0696f0 Christoph Hellwig 2010-06-04  1237  static int ext2_setsize(struct inode *inode, loff_t newsize) 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1238  { 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1239      int error; 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1240 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1241      if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) || 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1242          S_ISLNK(inode->i_mode))) 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1243          return -EINVAL; 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1244      if (ext2_inode_is_fast_symlink(inode)) 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1245          return -EINVAL; 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1246      if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1247          return -EPERM; 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1248 
 > 562c72aa57c36b1 Christoph Hellwig 2011-06-24  1249      inode_dio_wait(inode); 
 > 562c72aa57c36b1 Christoph Hellwig 2011-06-24  1250 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27 @1251              error = block_truncate_page(inode->i_mapping, 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1252                                  newsize, ext2_get_block); 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1253      if (error) 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1254          return error; 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1255 
 > 70f3bad8c3154ba Jan Kara          2021-04-12  1256      filemap_invalidate_lock(inode->i_mapping); 
 > 2c27c65ed0696f0 Christoph Hellwig 2010-06-04  1257      truncate_setsize(inode, newsize); 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1258      __ext2_truncate_blocks(inode, newsize); 
 > 70f3bad8c3154ba Jan Kara          2021-04-12  1259      filemap_invalidate_unlock(inode->i_mapping); 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1260 
 > 5cdc59fce617a2e Jeff Layton       2023-10-04  1261      inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode)); 
 > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1262      if (inode_needs_sync(inode)) { 
 > b0439bbc29f0201 Jan Kara          2026-03-26  1263          mmb_sync(&EXT2_I(inode)->i_metadata_bhs); 
 > c37650161a53c01 Christoph Hellwig 2010-10-06  1264          sync_inode_metadata(inode, 1); 
 > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1265      } else { 
 > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1266          mark_inode_dirty(inode); 
 > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1267      } 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1268 
 > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1269      return 0; 
 > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1270  } 
 > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1271 
 >  
 > -- 
 > 0-DAY CI Kernel Test Service 
 > https://github.com/intel/lkp-tests/wiki 
 >  
 > 

