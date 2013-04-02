From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: fold ext4_generic_write_end() into ext4_write_end()
Date: Tue, 2 Apr 2013 11:11:44 +0300
Message-ID: <20130402081144.GA11441@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, kbuild@01.org
To: wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48881 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3DBINm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2013 04:13:42 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Zheng Liu,

The patch 31e4045fda81: "ext4: fold ext4_generic_write_end() into 
ext4_write_end()" from Mar 26, 2013, leads to the following warning:
"fs/ext4/inode.c:1169 ext4_write_end()
	 warn: unsigned 'copied' is never less than zero."


  1110  static int ext4_write_end(struct file *file,
  1111                            struct address_space *mapping,
  1112                            loff_t pos, unsigned len, unsigned copied,

copied is unsigned.

  1113                            struct page *page, void *fsdata)
  1114  {
  1115          handle_t *handle = ext4_journal_current_handle();
  1116          struct inode *inode = mapping->host;
  1117          int ret = 0, ret2;
  1118          int i_size_changed = 0;
  1119  
  1120          trace_ext4_write_end(inode, pos, len, copied);
  1121          if (ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE)) {
  1122                  ret = ext4_jbd2_file_inode(handle, inode);
  1123                  if (ret) {
  1124                          unlock_page(page);
  1125                          page_cache_release(page);
  1126                          goto errout;
  1127                  }
  1128          }
  1129  
  1130          if (ext4_has_inline_data(inode))
  1131                  copied = ext4_write_inline_data_end(inode, pos, len,
  1132                                                      copied, page);
  1133          else
  1134                  copied = block_write_end(file, mapping, pos,
  1135                                           len, copied, page, fsdata);

I don't think these functions return negative error codes.

  1136  
  1137          /*
  1138           * No need to use i_size_read() here, the i_size
  1139           * cannot change under us because we hole i_mutex.
  1140           *
  1141           * But it's important to update i_size while still holding page lock:
  1142           * page writeout could otherwise come in and zero beyond i_size.
  1143           */
  1144          if (pos + copied > inode->i_size) {
  1145                  i_size_write(inode, pos + copied);
  1146                  i_size_changed = 1;
  1147          }
  1148  
  1149          if (pos + copied > EXT4_I(inode)->i_disksize) {
  1150                  /* We need to mark inode dirty even if
  1151                   * new_i_size is less that inode->i_size
  1152                   * but greater than i_disksize. (hint delalloc)
  1153                   */
  1154                  ext4_update_i_disksize(inode, (pos + copied));
  1155                  i_size_changed = 1;
  1156          }
  1157          unlock_page(page);
  1158          page_cache_release(page);
  1159  
  1160          /*
  1161           * Don't mark the inode dirty under page lock. First, it unnecessarily
  1162           * makes the holding time of page lock longer. Second, it forces lock
  1163           * ordering of page lock and transaction start for journaling
  1164           * filesystems.
  1165           */
  1166          if (i_size_changed)
  1167                  ext4_mark_inode_dirty(handle, inode);
  1168  
  1169          if (copied < 0)
  1170                  ret = copied;

copied is never less than zero because it's unsigned.

regards,
dan carpenter

