From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:dev 68/75] include/trace/events/ext4.h:484:1: error: macro
 "DEFINE_EVENT" requires 4 arguments, but only 3 given
Date: Sun, 30 Dec 2012 00:33:49 +0800
Message-ID: <50df1b6d.jLf9SqkSRJbKbQF1%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab2L2QgY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 11:36:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   b977f3efba01c959b5e47f65e65dba81ef3c4cbe
commit: fdd2c03289562245422d920645990ba3e4165034 [68/75] ext4: split off ext4_journalled_invalidatepage()
config: make ARCH=x86_64 allmodconfig

Note: the ext4/dev HEAD b977f3e builds fine.
      It only hurts bisectibility.

All error/warnings:

In file included from fs/ext4/super.c:55:0:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
In file included from include/trace/define_trace.h:79:0,
                 from include/trace/events/ext4.h:2173,
                 from fs/ext4/super.c:55:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
In file included from include/trace/ftrace.h:89:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/ext4.h:2173,
                 from fs/ext4/super.c:55:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
In file included from include/trace/ftrace.h:139:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/ext4.h:2173,
                 from fs/ext4/super.c:55:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
In file included from include/trace/ftrace.h:296:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/ext4.h:2173,
                 from fs/ext4/super.c:55:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
In file included from include/trace/ftrace.h:356:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/ext4.h:2173,
                 from fs/ext4/super.c:55:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
In file included from include/trace/ftrace.h:404:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/ext4.h:2173,
                 from fs/ext4/super.c:55:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
--
In file included from fs/ext4/extents.c:47:0:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
--
In file included from fs/ext4/inode.c:46:0:
include/trace/events/ext4.h:484:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:480:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:480:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
include/trace/events/ext4.h:490:1: error: macro "DEFINE_EVENT" requires 4 arguments, but only 3 given
include/trace/events/ext4.h:486:1: warning: data definition has no type or storage class [enabled by default]
include/trace/events/ext4.h:486:1: warning: type defaults to 'int' in declaration of 'DEFINE_EVENT' [-Wimplicit-int]
fs/ext4/inode.c: In function 'ext4_invalidatepage':
fs/ext4/inode.c:2883:2: error: implicit declaration of function 'trace_ext4_invalidatepage' [-Werror=implicit-function-declaration]
fs/ext4/inode.c: In function 'ext4_journalled_invalidatepage':
fs/ext4/inode.c:2902:2: error: implicit declaration of function 'trace_ext4_journalled_invalidatepage' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

vim +/DEFINE_EVENT +484 include/trace/events/ext4.h

0562e0ba Jiaying Zhang 2011-03-21  472  	),
0562e0ba Jiaying Zhang 2011-03-21  473  
0562e0ba Jiaying Zhang 2011-03-21  474  	TP_printk("dev %d,%d ino %lu page_index %lu offset %lu",
0562e0ba Jiaying Zhang 2011-03-21  475  		  MAJOR(__entry->dev), MINOR(__entry->dev),
0562e0ba Jiaying Zhang 2011-03-21  476  		  (unsigned long) __entry->ino,
a9c667f8 Lukas Czerner 2011-06-06  477  		  (unsigned long) __entry->index, __entry->offset)
0562e0ba Jiaying Zhang 2011-03-21 @478  );
0562e0ba Jiaying Zhang 2011-03-21  479  
fdd2c032 Jan Kara      2012-12-25 @480  DEFINE_EVENT(ext4_invalidatepage_op, ext4_invalidatepage
fdd2c032 Jan Kara      2012-12-25  481  	TP_PROTO(struct page *page, unsigned long offset),
fdd2c032 Jan Kara      2012-12-25  482  
fdd2c032 Jan Kara      2012-12-25  483  	TP_ARGS(page, offset)
fdd2c032 Jan Kara      2012-12-25 @484  );
fdd2c032 Jan Kara      2012-12-25  485  
fdd2c032 Jan Kara      2012-12-25  486  DEFINE_EVENT(ext4_invalidatepage_op, ext4_journalled_invalidatepage
fdd2c032 Jan Kara      2012-12-25  487  	TP_PROTO(struct page *page, unsigned long offset),

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
