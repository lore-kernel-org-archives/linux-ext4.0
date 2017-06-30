From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ext4: xattr-in-inode support
Date: Fri, 30 Jun 2017 10:53:40 +0300
Message-ID: <20170630075340.jzksfxareq4a4t66@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: andreas.dilger@intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51353 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdF3Hx4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jun 2017 03:53:56 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Andreas Dilger,

The patch 2851a40a5d71: "ext4: xattr-in-inode support" from Jun 21,
2017, leads to the following static checker warning:

	fs/ext4/xattr.c:1333 ext4_xattr_inode_write()
	error: 'bh' dereferencing possible ERR_PTR()

fs/ext4/xattr.c
  1301          block = 0;
  1302          while (wsize < bufsize) {
  1303                  if (bh != NULL)
  1304                          brelse(bh);
  1305                  csize = (bufsize - wsize) > blocksize ? blocksize :
  1306                                                                  bufsize - wsize;
  1307                  bh = ext4_getblk(handle, ea_inode, block, 0);
  1308                  if (IS_ERR(bh)) {
  1309                          ret = PTR_ERR(bh);
  1310                          goto out;
                                ^^^^^^^^
This will cause an oops.

  1311                  }
  1312                  ret = ext4_journal_get_write_access(handle, bh);
  1313                  if (ret)
  1314                          goto out;
  1315  
  1316                  memcpy(bh->b_data, buf, csize);
  1317                  set_buffer_uptodate(bh);
  1318                  ext4_handle_dirty_metadata(handle, ea_inode, bh);
  1319  
  1320                  buf += csize;
  1321                  wsize += csize;
  1322                  block += 1;
  1323          }
  1324  
  1325          inode_lock(ea_inode);
  1326          i_size_write(ea_inode, wsize);
  1327          ext4_update_i_disksize(ea_inode, wsize);
  1328          inode_unlock(ea_inode);
  1329  
  1330          ext4_mark_inode_dirty(handle, ea_inode);
  1331  
  1332  out:
  1333          brelse(bh);
  1334  
  1335          return ret;
  1336  }

regards,
dan carpenter
