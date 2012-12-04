From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ext4:dev 40/60] fs/ext4/inode.c:1953 __ext4_journalled_writepage()
 error: potential NULL dereference 'page_bufs'.
Date: Tue, 4 Dec 2012 14:10:27 +0300
Message-ID: <20121204111011.GD22569@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <fengguang.wu@intel.com>, kbuild@01.org,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tao Ma <boyu.mt@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47937 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2LDLKo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 06:10:44 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tao,

FYI, there are new smatch warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   e9f49e454264c1cdd793552bfeb44f337508201b
commit: 97bb0f99e9d2b047c7a6010771c41d5f0d2ed80c [40/60] ext4: add journalled write support for inline data

+ fs/ext4/inode.c:1953 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.

git remote update ext4
git checkout 97bb0f99e9d2b047c7a6010771c41d5f0d2ed80c
vim +1953 +/page_bufs fs/ext4/inode.c

62e086be Aneesh Kumar K.V 2009-06-14  1937  	unlock_page(page);
62e086be Aneesh Kumar K.V 2009-06-14  1938  
62e086be Aneesh Kumar K.V 2009-06-14  1939  	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
62e086be Aneesh Kumar K.V 2009-06-14  1940  	if (IS_ERR(handle)) {
62e086be Aneesh Kumar K.V 2009-06-14  1941  		ret = PTR_ERR(handle);
62e086be Aneesh Kumar K.V 2009-06-14  1942  		goto out;
62e086be Aneesh Kumar K.V 2009-06-14  1943  	}
62e086be Aneesh Kumar K.V 2009-06-14  1944  
441c8508 Curt Wohlgemuth  2011-08-13  1945  	BUG_ON(!ext4_handle_valid(handle));
441c8508 Curt Wohlgemuth  2011-08-13  1946  
97bb0f99 Tao Ma           2012-12-02  1947  	if (ext4_has_inline_data(inode) && inode_bh) {

If we have inline data but inode_bh is NULL then it will lead to a
NULL dereference.  Btw, smatch will still complain about this even
after we fix the code.

97bb0f99 Tao Ma           2012-12-02  1948  		ret = ext4_journal_get_write_access(handle, inode_bh);
97bb0f99 Tao Ma           2012-12-02  1949  
97bb0f99 Tao Ma           2012-12-02  1950  		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
97bb0f99 Tao Ma           2012-12-02  1951  
97bb0f99 Tao Ma           2012-12-02  1952  	} else {
97bb0f99 Tao Ma           2012-12-02 @1953  		ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
97bb0f99 Tao Ma           2012-12-02  1954  					do_journal_get_write_access);
97bb0f99 Tao Ma           2012-12-02  1955  
97bb0f99 Tao Ma           2012-12-02  1956  		err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
97bb0f99 Tao Ma           2012-12-02  1957  					write_end_fn);
97bb0f99 Tao Ma           2012-12-02  1958  	}
62e086be Aneesh Kumar K.V 2009-06-14  1959  
62e086be Aneesh Kumar K.V 2009-06-14  1960  	if (ret == 0)
62e086be Aneesh Kumar K.V 2009-06-14  1961  		ret = err;

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
