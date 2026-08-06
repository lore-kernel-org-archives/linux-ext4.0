Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A042494806
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 19:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786045163; cv=none; b=Jx81kzHKfXYOi7eCrJs4iecixzSUsBDpoKehH3SLHkQBQGSRVlenN7/92O6xqsOlpQwiNApeQ78DU6y5XdRSTgaZkH4zE58DABnbTTVXrfTnajYWxAR6c2TJCSRSWYzpfEgWBB8E17KHakwrwy7wBot5r/u/sQCq6cNnylByqQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786045163; c=relaxed/simple;
	bh=giezZmsqiLauXkPCTFWRurjuGp5FRhjfFndOvTRAdQk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=NLiGghV/krnFLb4k5QJFkv/l2QmmoioBML8pOJdTfY1fLH8t+S0rEDLNkPJAkANKmDE3cd+O4pue5uIcXTAbRcgfk/Fpr1rKsz9dpeNTi/yI99T0TXr0puaX3kvmG0TRYPYGRh7BDF9sgKSOLIgV/bPllWHuXxj0iDt6C7ZilMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bTRtePPN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bTRtePPN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786045162; x=1817581162;
  h=date:from:to:cc:subject:message-id;
  bh=giezZmsqiLauXkPCTFWRurjuGp5FRhjfFndOvTRAdQk=;
  b=bTRtePPNxGXsQsP85+mo167mZpONb+9Bv54eElGIK4jk3PpktwUJaYsP
   uhFoE59P/0xWRvwwKgs9UnyJpxX/Vd3zaDoYCJNX9V0OsmshocM17iqBp
   zNOif9ek2WrLqteS92tbOF8pVcFoHXMOK2Ac9ePvAt7p6EyhCwggTzvaj
   G9WYvSzWjA30adFYq92GwW28lxGNiz5anhNxEh/CjMj1SEEp0rmMgYEtp
   5wK1S/gybFK7DjfoBhQ7FkLbAyoFmUZCi5hMy6u3k9MFEoiwKp7aDtFh4
   27guhXnfLxZFcNcVxPnWNSNY9aW6w75V0qW3v0NIXgQS3Y7Kf3wiEIw9w
   w==;
X-CSE-ConnectionGUID: DbagW73pQ82v7eoAtO7FNA==
X-CSE-MsgGUID: QYHxiVieQb2SosrlaNNm3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="86418511"
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="86418511"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 12:39:21 -0700
X-CSE-ConnectionGUID: sfryLZ3vSRaVj71yJ6fzpg==
X-CSE-MsgGUID: W5jDltIvSG2uIGFReR7ILw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="258869500"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Aug 2026 12:39:13 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ws3vq-00000000G5L-1vVd;
	Thu, 06 Aug 2026 19:39:10 +0000
Date: Fri, 07 Aug 2026 03:38:26 +0800
From: kernel test robot <lkp@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>
Subject: [tytso-ext4:dev 54/56] fs/ext4/inode.c:3711:29: warning:
 unused variable 'bpg'
Message-ID: <202608070336.Nq0yndDZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   d77b9f1b037ed1e9102d7b200bfc90f74e1c84bf
commit: 0db01f3b86bb23f9bc7a757e3a850963c615887e [54/56] ext4: teach ext4_meta_trans_blocks() about number of allocated extents
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20260807/202608070336.Nq0yndDZ-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260807/202608070336.Nq0yndDZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608070336.Nq0yndDZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ext4/inode.c: In function 'ext4_iomap_alloc':
>> fs/ext4/inode.c:3711:29: warning: unused variable 'bpg' [-Wunused-variable]
    3711 |                         int bpg = EXT4_BLOCKS_PER_GROUP(inode->i_sb);
         |                             ^~~


vim +/bpg +3711 fs/ext4/inode.c

  3680	
  3681	static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
  3682				    unsigned int flags)
  3683	{
  3684		handle_t *handle;
  3685		int ret, dio_credits, m_flags = 0, retries = 0;
  3686		bool force_commit = false;
  3687	
  3688		if (flags & IOMAP_NOWAIT)
  3689			return -EAGAIN;
  3690	
  3691		/*
  3692		 * Trim the mapping request to the maximum value that we can map at
  3693		 * once for direct I/O.
  3694		 */
  3695		if (map->m_len > DIO_MAX_BLOCKS)
  3696			map->m_len = DIO_MAX_BLOCKS;
  3697	
  3698		/*
  3699		 * journal credits estimation for atomic writes. We call
  3700		 * ext4_map_blocks(), to find if there could be a mixed mapping. If yes,
  3701		 * then let's assume the no. of pextents required can be m_len i.e.
  3702		 * every alternate block can be unwritten and hole.
  3703		 */
  3704		if (flags & IOMAP_ATOMIC) {
  3705			unsigned int orig_mlen = map->m_len;
  3706	
  3707			ret = ext4_map_blocks(NULL, inode, map, 0);
  3708			if (ret < 0)
  3709				return ret;
  3710			if (map->m_len < orig_mlen) {
> 3711				int bpg = EXT4_BLOCKS_PER_GROUP(inode->i_sb);
  3712	
  3713				map->m_len = orig_mlen;
  3714				dio_credits = ext4_meta_trans_blocks(inode, map->m_len,
  3715								     map->m_len, 0);
  3716			} else {
  3717				dio_credits = ext4_chunk_trans_blocks(inode,
  3718								      map->m_len);
  3719			}
  3720		} else {
  3721			dio_credits = ext4_chunk_trans_blocks(inode, map->m_len);
  3722		}
  3723	
  3724	retry:
  3725		/*
  3726		 * Either we allocate blocks and then don't get an unwritten extent, so
  3727		 * in that case we have reserved enough credits. Or, the blocks are
  3728		 * already allocated and unwritten. In that case, the extent conversion
  3729		 * fits into the credits as well.
  3730		 */
  3731		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS, dio_credits);
  3732		if (IS_ERR(handle))
  3733			return PTR_ERR(handle);
  3734	
  3735		/*
  3736		 * DAX and direct I/O are the only two operations that are currently
  3737		 * supported with IOMAP_WRITE.
  3738		 */
  3739		WARN_ON(!(flags & (IOMAP_DAX | IOMAP_DIRECT)));
  3740		if (flags & IOMAP_DAX)
  3741			m_flags = EXT4_GET_BLOCKS_CREATE_ZERO;
  3742		/*
  3743		 * We use i_size instead of i_disksize here because delalloc writeback
  3744		 * can complete at any point during the I/O and subsequently push the
  3745		 * i_disksize out to i_size. This could be beyond where direct I/O is
  3746		 * happening and thus expose allocated blocks to direct I/O reads.
  3747		 */
  3748		else if (EXT4_LBLK_TO_B(inode, map->m_lblk) >= i_size_read(inode))
  3749			m_flags = EXT4_GET_BLOCKS_CREATE;
  3750		else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
  3751			m_flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
  3752	
  3753		if (flags & IOMAP_ATOMIC)
  3754			ret = ext4_map_blocks_atomic_write(handle, inode, map, m_flags,
  3755							   &force_commit);
  3756		else
  3757			ret = ext4_map_blocks(handle, inode, map, m_flags);
  3758	
  3759		/*
  3760		 * We cannot fill holes in indirect tree based inodes as that could
  3761		 * expose stale data in the case of a crash. Use the magic error code
  3762		 * to fallback to buffered I/O.
  3763		 */
  3764		if (!m_flags && !ret)
  3765			ret = -ENOTBLK;
  3766	
  3767		ext4_journal_stop(handle);
  3768		if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
  3769			goto retry;
  3770	
  3771		/*
  3772		 * Force commit the current transaction if the allocation spans a mixed
  3773		 * mapping range. This ensures any pending metadata updates (like
  3774		 * unwritten to written extents conversion) in this range are in
  3775		 * consistent state with the file data blocks, before performing the
  3776		 * actual write I/O. If the commit fails, the whole I/O must be aborted
  3777		 * to prevent any possible torn writes.
  3778		 */
  3779		if (ret > 0 && force_commit) {
  3780			int ret2;
  3781	
  3782			ret2 = ext4_force_commit(inode->i_sb);
  3783			if (ret2)
  3784				return ret2;
  3785		}
  3786	
  3787		return ret;
  3788	}
  3789	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
