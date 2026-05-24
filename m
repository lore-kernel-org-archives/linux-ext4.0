Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3464118DB35;
	Sun, 24 May 2026 01:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779586031; cv=none; b=uzNl/5OvnITja38h4hRgDZW7TUp4vlfubEeuKSjyyMvLsl6hekEfhMv3e2sS7KvlD/Ey31ALLcaKZMIBowHDMK8gQYIWlxXSJj0QJWbwGGTEYpa97wy8CH1VqNvSRijEmZx6FrcowiAXQdx2qmxElQ8QvgTUK2w0OrcwtGhynPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779586031; c=relaxed/simple;
	bh=w4/DKiC93rbZ/2BN1B0jXfV4Pdn5Ww9+WLlZv3ykrMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNxyd1V4BDvCKVdINnFQrBzXWsY2bNuAv+EN6Sma3iZAdGWaSGt3BKGXXIwkFf/pdC9imLLmPxQjFLZUoaABdOsyHf+VLLrrTodKB9azPu52Ljlj190xdQtclS/sEkE8hlFENyy4AGo5ksJtt586aDmGYfwFYkdEGeFPTbJ1Y8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QTu8fa0O; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QTu8fa0O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779586028; x=1811122028;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w4/DKiC93rbZ/2BN1B0jXfV4Pdn5Ww9+WLlZv3ykrMQ=;
  b=QTu8fa0OsXntycYE+PKdeU29M/v17pJH1Lk5SMNBABoE97cwNtShVZ5I
   vbRdVb60WabcZW+b/CyTazxZ3OvLNroYlFfq9RxDeGg38HvpP54FoHdu3
   jjz12EiIwouptR/4YhcUDZjbHxmZ96NTgb0BjCDtNEW+Y8p00pNl1n2pp
   3LZDtW6gpGcmSu3EPTgtdNd2nlTz1Y21aRregclWc1p8lm5ylVksEaUjc
   U8vEtaMYHgbd2WtD1cAXbjpa/p9sdm6Lf6Oxk+hhLYliQH2iawPS5HMJN
   CKkjMKJAL8KCrVSZLZaqw2yIdQUckbLQGdkVAAqxP2KG+cAaJAAZp6xFY
   Q==;
X-CSE-ConnectionGUID: I6eGVbwoSzK2S0w9tMsM2A==
X-CSE-MsgGUID: voFbhaVITHSbKNvk621vig==
X-IronPort-AV: E=McAfee;i="6800,10657,11795"; a="79607434"
X-IronPort-AV: E=Sophos;i="6.24,165,1774335600"; 
   d="scan'208";a="79607434"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 18:27:07 -0700
X-CSE-ConnectionGUID: BIv9M++JTp2Sj2gJ52js1Q==
X-CSE-MsgGUID: UTZajSRZQre4aYWDyU6PXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,165,1774335600"; 
   d="scan'208";a="265105510"
Received: from lkp-server01.sh.intel.com (HELO 6ba8523b1a8f) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 23 May 2026 18:27:05 -0700
Received: from kbuild by 6ba8523b1a8f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wQxcN-000000000XR-2tDN;
	Sun, 24 May 2026 01:27:03 +0000
Date: Sun, 24 May 2026 09:26:05 +0800
From: kernel test robot <lkp@intel.com>
To: Ashwin Gundarapu <linuxuser509@zohomail.in>, jack <jack@suse.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext2: Remove deprecated DAX support
Message-ID: <202605240952.dIQvDsdW-lkp@intel.com>
References: <19e54c7cba1.5355cb8650862.622752146451851140@zohomail.in>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e54c7cba1.5355cb8650862.622752146451851140@zohomail.in>

Hi Ashwin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jack-fs/for_next]
[also build test WARNING on linus/master v7.1-rc4 next-20260522]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashwin-Gundarapu/ext2-Remove-deprecated-DAX-support/20260523-202224
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next
patch link:    https://lore.kernel.org/r/19e54c7cba1.5355cb8650862.622752146451851140%40zohomail.in
patch subject: [PATCH] ext2: Remove deprecated DAX support
config: riscv-nommu_virt_defconfig (https://download.01.org/0day-ci/archive/20260524/202605240952.dIQvDsdW-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260524/202605240952.dIQvDsdW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605240952.dIQvDsdW-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:838:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     838 |         insb(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:108:53: note: expanded from macro 'insb'
     108 | #define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from fs/ext2/inode.c:28:
   In file included from include/linux/pagemap.h:11:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:846:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     846 |         insw(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:109:53: note: expanded from macro 'insw'
     109 | #define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from fs/ext2/inode.c:28:
   In file included from include/linux/pagemap.h:11:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:854:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     854 |         insl(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:110:53: note: expanded from macro 'insl'
     110 | #define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from fs/ext2/inode.c:28:
   In file included from include/linux/pagemap.h:11:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:863:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     863 |         outsb(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:122:55: note: expanded from macro 'outsb'
     122 | #define outsb(addr, buffer, count) __outsb(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from fs/ext2/inode.c:28:
   In file included from include/linux/pagemap.h:11:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:872:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     872 |         outsw(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:123:55: note: expanded from macro 'outsw'
     123 | #define outsw(addr, buffer, count) __outsw(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from fs/ext2/inode.c:28:
   In file included from include/linux/pagemap.h:11:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:881:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     881 |         outsl(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:124:55: note: expanded from macro 'outsl'
     124 | #define outsl(addr, buffer, count) __outsl(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from fs/ext2/inode.c:28:
   In file included from include/linux/pagemap.h:11:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
>> fs/ext2/inode.c:792:23: warning: unused variable 'sbi' [-Wunused-variable]
     792 |         struct ext2_sb_info *sbi = EXT2_SB(inode->i_sb);
         |                              ^~~
   8 warnings generated.


vim +/sbi +792 fs/ext2/inode.c

a686cd898bd999f Martin J. Bligh      2007-10-16  785  
25f4e70291a3097 Christoph Hellwig    2016-09-19  786  static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
c039b9979272634 Goldwyn Rodrigues    2019-10-18  787  		unsigned flags, struct iomap *iomap, struct iomap *srcmap)
25f4e70291a3097 Christoph Hellwig    2016-09-19  788  {
25f4e70291a3097 Christoph Hellwig    2016-09-19  789  	unsigned int blkbits = inode->i_blkbits;
25f4e70291a3097 Christoph Hellwig    2016-09-19  790  	unsigned long first_block = offset >> blkbits;
25f4e70291a3097 Christoph Hellwig    2016-09-19  791  	unsigned long max_blocks = (length + (1 << blkbits) - 1) >> blkbits;
8cf037a8b22f71c Dan Williams         2017-08-30 @792  	struct ext2_sb_info *sbi = EXT2_SB(inode->i_sb);
25f4e70291a3097 Christoph Hellwig    2016-09-19  793  	bool new = false, boundary = false;
25f4e70291a3097 Christoph Hellwig    2016-09-19  794  	u32 bno;
25f4e70291a3097 Christoph Hellwig    2016-09-19  795  	int ret;
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  796) 	bool create = flags & IOMAP_WRITE;
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  797) 
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  798) 	/*
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  799) 	 * For writes that could fill holes inside i_size on a
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  800) 	 * DIO_SKIP_HOLES filesystem we forbid block creations: only
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  801) 	 * overwrites are permitted.
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  802) 	 */
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  803) 	if ((flags & IOMAP_DIRECT) &&
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  804) 	    (first_block << blkbits) < i_size_read(inode))
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  805) 		create = 0;
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  806) 
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  807) 	/*
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  808) 	 * Writes that span EOF might trigger an IO size update on completion,
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  809) 	 * so consider them to be dirty for the purposes of O_DSYNC even if
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  810) 	 * there is no other metadata changes pending or have been made here.
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  811) 	 */
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  812) 	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  813) 		iomap->flags |= IOMAP_F_DIRTY;
25f4e70291a3097 Christoph Hellwig    2016-09-19  814  
25f4e70291a3097 Christoph Hellwig    2016-09-19  815  	ret = ext2_get_blocks(inode, first_block, max_blocks,
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  816) 			&bno, &new, &boundary, create);
25f4e70291a3097 Christoph Hellwig    2016-09-19  817  	if (ret < 0)
a686cd898bd999f Martin J. Bligh      2007-10-16  818  		return ret;
a686cd898bd999f Martin J. Bligh      2007-10-16  819  
25f4e70291a3097 Christoph Hellwig    2016-09-19  820  	iomap->flags = 0;
d5bfccdf38d094f Christoph Hellwig    2016-10-03  821  	iomap->offset = (u64)first_block << blkbits;
de2051147771017 Christoph Hellwig    2021-11-29  822          iomap->bdev = inode->i_sb->s_bdev;
25f4e70291a3097 Christoph Hellwig    2016-09-19  823  
25f4e70291a3097 Christoph Hellwig    2016-09-19  824  	if (ret == 0) {
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  825) 		/*
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  826) 		 * Switch to buffered-io for writing to holes in a non-extent
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  827) 		 * based filesystem to avoid stale data exposure problem.
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  828) 		 */
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  829) 		if (!create && (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT))
fb5de4358e1aa47 Ritesh Harjani (IBM  2023-04-21  830) 			return -ENOTBLK;
25f4e70291a3097 Christoph Hellwig    2016-09-19  831  		iomap->type = IOMAP_HOLE;
19fe5f643f89f29 Andreas Gruenbacher  2017-10-01  832  		iomap->addr = IOMAP_NULL_ADDR;
25f4e70291a3097 Christoph Hellwig    2016-09-19  833  		iomap->length = 1 << blkbits;
25f4e70291a3097 Christoph Hellwig    2016-09-19  834  	} else {
25f4e70291a3097 Christoph Hellwig    2016-09-19  835  		iomap->type = IOMAP_MAPPED;
19fe5f643f89f29 Andreas Gruenbacher  2017-10-01  836  		iomap->addr = (u64)bno << blkbits;
25f4e70291a3097 Christoph Hellwig    2016-09-19  837  		iomap->length = (u64)ret << blkbits;
25f4e70291a3097 Christoph Hellwig    2016-09-19  838  		iomap->flags |= IOMAP_F_MERGED;
25f4e70291a3097 Christoph Hellwig    2016-09-19  839  	}
25f4e70291a3097 Christoph Hellwig    2016-09-19  840  
25f4e70291a3097 Christoph Hellwig    2016-09-19  841  	if (new)
25f4e70291a3097 Christoph Hellwig    2016-09-19  842  		iomap->flags |= IOMAP_F_NEW;
25f4e70291a3097 Christoph Hellwig    2016-09-19  843  	return 0;
a686cd898bd999f Martin J. Bligh      2007-10-16  844  }
a686cd898bd999f Martin J. Bligh      2007-10-16  845  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
