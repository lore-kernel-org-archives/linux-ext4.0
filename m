From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: add journalled write support for inline data
Date: Wed, 14 Jan 2015 12:52:05 +0300
Message-ID: <20150114095205.GA13096@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: boyu.mt@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26222 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbANJvb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jan 2015 04:51:31 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Tao Ma,

The patch 3fdcfb668fd7: "ext4: add journalled write support for
inline data" from Dec 10, 2012, leads to the following static checker
warning:

	fs/ext4/inode.c:1574 __ext4_journalled_writepage()
	warn: missing error code here? 'ext4_journalled_write_inline_data()' failed.

fs/ext4/inode.c
  1556  static int __ext4_journalled_writepage(struct page *page,
  1557                                         unsigned int len)
  1558  {
  1559          struct address_space *mapping = page->mapping;
  1560          struct inode *inode = mapping->host;
  1561          struct buffer_head *page_bufs = NULL;
  1562          handle_t *handle = NULL;
  1563          int ret = 0, err = 0;
  1564          int inline_data = ext4_has_inline_data(inode);
  1565          struct buffer_head *inode_bh = NULL;
  1566  
  1567          ClearPageChecked(page);
  1568  
  1569          if (inline_data) {
  1570                  BUG_ON(page->index != 0);
  1571                  BUG_ON(len > ext4_get_max_inline_size(inode));
  1572                  inode_bh = ext4_journalled_write_inline_data(inode, len, page);
  1573                  if (inode_bh == NULL)
  1574                          goto out;

Should we set an error code if we do a goto out?  Really, this would be
more readable if it were a direct return.  "return 0;" and
"return -ESOMETHING;" are easy to understand and obviously deliberate
but "goto out;" is ambiguous and a more complicated way of achieving the
same result.

  1575          } else {
  1576                  page_bufs = page_buffers(page);
  1577                  if (!page_bufs) {
  1578                          BUG();
  1579                          goto out;
  1580                  }
  1581                  ext4_walk_page_buffers(handle, page_bufs, 0, len,
  1582                                         NULL, bget_one);
  1583          }
  1584          /* As soon as we unlock the page, it can go away, but we have
  1585           * references to buffers so we are safe */
  1586          unlock_page(page);
  1587  
  1588          handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
  1589                                      ext4_writepage_trans_blocks(inode));
  1590          if (IS_ERR(handle)) {
  1591                  ret = PTR_ERR(handle);
  1592                  goto out;
  1593          }
  1594  
  1595          BUG_ON(!ext4_handle_valid(handle));
  1596  
  1597          if (inline_data) {
  1598                  BUFFER_TRACE(inode_bh, "get write access");
  1599                  ret = ext4_journal_get_write_access(handle, inode_bh);
  1600  
  1601                  err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
  1602  
  1603          } else {
  1604                  ret = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
  1605                                               do_journal_get_write_access);
  1606  
  1607                  err = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
  1608                                               write_end_fn);
  1609          }
  1610          if (ret == 0)
  1611                  ret = err;
  1612          EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
  1613          err = ext4_journal_stop(handle);
  1614          if (!ret)
  1615                  ret = err;
  1616  
  1617          if (!ext4_has_inline_data(inode))
  1618                  ext4_walk_page_buffers(NULL, page_bufs, 0, len,
  1619                                         NULL, bput_one);
  1620          ext4_set_inode_state(inode, EXT4_STATE_JDATA);
  1621  out:
  1622          brelse(inode_bh);
  1623          return ret;
  1624  }

regards,
dan carpenter
