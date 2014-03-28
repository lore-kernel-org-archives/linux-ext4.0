From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: refactor ext4_fallocate code
Date: Fri, 28 Mar 2014 11:04:32 +0300
Message-ID: <20140328080432.GC25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: lczerner@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25025 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaC1IE6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Mar 2014 04:04:58 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Lukas Czerner,

The patch f6a7718e9581: "ext4: refactor ext4_fallocate code" from Mar
18, 2014, leads to the following static checker warning:

	fs/ext4/extents.c:4926 ext4_fallocate()
	warn: we tested 'ret' before and it was 'false'

fs/ext4/extents.c
  4916          ret = ext4_alloc_file_blocks(file, lblk, max_blocks, flags, mode);
  4917          if (ret)
                    ^^^
Checked.

  4918                  goto out;
  4919  
  4920          handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
  4921          if (IS_ERR(handle))
  4922                  goto out;
  4923  
  4924          tv = inode->i_ctime = ext4_current_time(inode);
  4925  
  4926          if (!ret && new_size) {
                    ^^^^
Known.

  4927                  if (new_size > i_size_read(inode)) {
  4928                          i_size_write(inode, new_size);
  4929                          inode->i_mtime = tv;
  4930                  }
  4931                  if (new_size > EXT4_I(inode)->i_disksize)
  4932                          ext4_update_i_disksize(inode, new_size);
  4933          } else if (!ret && !new_size) {
                           ^^^^
Known.

  4934                  /*
  4935                  * Mark that we allocate beyond EOF so the subsequent truncate
  4936                  * can proceed even if the new size is the same as i_size.
  4937                  */
  4938                  if ((offset + len) > i_size_read(inode))
  4939                          ext4_set_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
  4940          }

regards,
dan carpenter
