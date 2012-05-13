From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: dereference before check in ext4_move_extents()
Date: Sun, 13 May 2012 21:43:21 +0300
Message-ID: <20120513184321.GA16541@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:33093 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2EMSnh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 May 2012 14:43:37 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, going through some static checker warnings and reporting bugs.
These were introduced a long time ago.

The patch 748de6736c1e: "ext4: online defrag -- Add EXT4_IOC_MOVE_EXT 
ioctl" from Jun 17, 2009, leads to the following Smatch complaint:

fs/ext4/move_extent.c:1381 ext4_move_extents()
	 warn: variable dereferenced before check 'holecheck_path' (see line 1292)

fs/ext4/move_extent.c
  1291			ext_prev = ext_cur;
  1292			last_extent = mext_next_extent(orig_inode, holecheck_path,
                                                                   ^^^^^^^^^^^^^^
Dereferenced unconditionally inside the mext_next_extent() function.

  1293							&ext_cur);
  1294			if (last_extent < 0) {
  1295				ret1 = last_extent;
  1296				break;
  1297			}

	[snip]

  1376			double_down_write_data_sem(orig_inode, donor_inode);
  1377			if (ret1 < 0)
  1378				break;
  1379	
  1380			/* Decrease buffer counter */
  1381			if (holecheck_path)
                            ^^^^^^^^^^^^^^
Checked here.

  1382				ext4_ext_drop_refs(holecheck_path);
  1383			ret1 = get_ext_path(orig_inode, seq_start, &holecheck_path);

regards,
dan carpenter

