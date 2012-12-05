From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:dev 56/60] fs/ext4/xattr.h:423: warning:
 'ext4_convert_inline_data' defined but not used
Date: Wed, 05 Dec 2012 15:32:29 +0800
Message-ID: <50bef88d.UVMD9uz/9ZafVmES%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <boyu.mt@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:18896 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LEHdK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 02:33:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   48e12537cdeb606c35896ae84f06f241ef4fc303
commit: 13a8e346f5cfcb867d84b0c2bdb14276abc5e362 [56/60] ext4: let fallocate handle inline data correctly
config: make ARCH=avr32 atngw100_defconfig

All warnings:

In file included from include/uapi/linux/param.h:4,
                 from include/linux/timex.h:63,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
                 from include/linux/srcu.h:32,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:738,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from include/linux/pagemap.h:7,
                 from include/linux/buffer_head.h:13,
                 from include/linux/jbd2.h:27,
                 from fs/ext4/dir.c:25:
arch/avr32/include/asm/param.h:6:1: warning: "HZ" redefined
In file included from arch/avr32/include/asm/param.h:4,
                 from include/uapi/linux/param.h:4,
                 from include/linux/timex.h:63,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
                 from include/linux/srcu.h:32,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:738,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from include/linux/pagemap.h:7,
                 from include/linux/buffer_head.h:13,
                 from include/linux/jbd2.h:27,
                 from fs/ext4/dir.c:25:
arch/avr32/include/uapi/asm/param.h:6:1: warning: this is the location of the previous definition
fs/ext4/xattr.h:423: warning: 'ext4_convert_inline_data' defined but not used
--
In file included from include/uapi/linux/param.h:4,
                 from include/linux/timex.h:63,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
                 from include/linux/srcu.h:32,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:738,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from include/linux/pagemap.h:7,
                 from fs/ext4/namei.c:28:
arch/avr32/include/asm/param.h:6:1: warning: "HZ" redefined
In file included from arch/avr32/include/asm/param.h:4,
                 from include/uapi/linux/param.h:4,
                 from include/linux/timex.h:63,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
                 from include/linux/srcu.h:32,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:738,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from include/linux/pagemap.h:7,
                 from fs/ext4/namei.c:28:
arch/avr32/include/uapi/asm/param.h:6:1: warning: this is the location of the previous definition
fs/ext4/xattr.h:423: warning: 'ext4_convert_inline_data' defined but not used
fs/ext4/namei.c: In function 'ext4_rename':
fs/ext4/namei.c:3026: warning: 'parent_de' may be used uninitialized in this function

vim +423 +/ext4_convert_inline_data fs/ext4/xattr.h

4c1faa2e Tao Ma        2012-12-05  407  }
5215dfb2 Tao Ma        2012-12-05  408  
5215dfb2 Tao Ma        2012-12-05  409  static inline int ext4_inline_data_fiemap(struct inode *inode,
5215dfb2 Tao Ma        2012-12-05  410  					  struct fiemap_extent_info *fieinfo,
5215dfb2 Tao Ma        2012-12-05  411  					  int *has_inline)
5215dfb2 Tao Ma        2012-12-05  412  {
5215dfb2 Tao Ma        2012-12-05  413  	return 0;
5215dfb2 Tao Ma        2012-12-05  414  }
b4cc3dab Tao Ma        2012-12-05  415  
b4cc3dab Tao Ma        2012-12-05  416  static inline void ext4_inline_data_truncate(struct inode *inode,
b4cc3dab Tao Ma        2012-12-05  417  					     int *has_inline)
b4cc3dab Tao Ma        2012-12-05  418  {
b4cc3dab Tao Ma        2012-12-05  419  	return;
b4cc3dab Tao Ma        2012-12-05  420  }
b4cc3dab Tao Ma        2012-12-05  421  
13a8e346 Tao Ma        2012-12-05  422  static int ext4_convert_inline_data(struct inode *inode)
13a8e346 Tao Ma        2012-12-05 @423  {
13a8e346 Tao Ma        2012-12-05  424  	return 0;
13a8e346 Tao Ma        2012-12-05  425  }
03010a33 Theodore Ts'o 2008-10-10  426  # endif  /* CONFIG_EXT4_FS_XATTR */
ac27a0ec Dave Kleikamp 2006-10-11  427  
03010a33 Theodore Ts'o 2008-10-10  428  #ifdef CONFIG_EXT4_FS_SECURITY
617ba13b Mingming Cao  2006-10-11  429  extern int ext4_init_security(handle_t *handle, struct inode *inode,
2a7dba39 Eric Paris    2011-02-01  430  			      struct inode *dir, const struct qstr *qstr);
ac27a0ec Dave Kleikamp 2006-10-11  431  #else

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
