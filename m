From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: serialize unaligned asynchronous DIO
Date: Tue, 27 May 2014 17:17:08 +0300
Message-ID: <20140527141708.GA2842@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36861 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaE0ORb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2014 10:17:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Namjae Jeon,

The patch 00532604c72e: "ext4: introduce new i_write_mutex to protect
fallocate" from May 26, 2014, leads to the following static checker
warning:

	fs/ext4/file.c:195 ext4_file_write_iter()
	warn: 'mutex:&EXT4_Iinode->i_write_mutex' is sometimes locked here and sometimes unlocked.

fs/ext4/file.c
   104          mutex_lock(&EXT4_I(inode)->i_write_mutex);
   105  
   106          /*
   107           * Unaligned direct AIO must be serialized; see comment above
   108           * In the case of O_APPEND, assume that we must always serialize
   109           */
   110          if (o_direct &&
   111              ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
   112              !is_sync_kiocb(iocb) &&
   113              (file->f_flags & O_APPEND ||
   114               ext4_unaligned_aio(inode, from, pos))) {
   115                  unaligned_direct_aio = true;
   116                  ext4_unwritten_wait(inode);
   117          }
   118  
   119          mutex_lock(&inode->i_mutex);
   120          if (file->f_flags & O_APPEND)
   121                  iocb->ki_pos = pos = i_size_read(inode);
   122  
   123          /*
   124           * If we have encountered a bitmap-format file, the size limit
   125           * is smaller than s_maxbytes, which is for extent-mapped files.
   126           */
   127          if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
   128                  struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
   129  
   130                  if ((pos > sbi->s_bitmap_maxbytes) ||
   131                      (pos == sbi->s_bitmap_maxbytes && length > 0)) {
   132                          mutex_unlock(&inode->i_mutex);
   133                          ret = -EFBIG;

We want to always unlock on this path but it only unlocks when
"unaligned_direct_aio" is true.

   134                          goto errout;
   135                  }
   136  

[ snip ]

   192  errout:
   193          if (unaligned_direct_aio)
   194                  mutex_unlock(&EXT4_I(inode)->i_write_mutex);
   195          return ret;
   196  }


regards,
dan carpenter
