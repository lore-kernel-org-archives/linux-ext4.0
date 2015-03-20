From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: add a new spinlock i_raw_lock to protect the ext4's raw
 inode
Date: Fri, 20 Mar 2015 13:22:18 +0300
Message-ID: <20150320102218.GA29133@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45168 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbbCTKWd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Mar 2015 06:22:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore Ts'o,

The patch 202ee5df38b3: "ext4: add a new spinlock i_raw_lock to
protect the ext4's raw inode" from Apr 21, 2014, leads to the
following static checker warning:

	fs/ext4/inode.c:4359 ext4_do_update_inode()
	warn: we tested 'err' before and it was 'false'

fs/ext4/inode.c
  4351          ext4_inode_csum_set(inode, raw_inode, ei);
  4352          spin_unlock(&ei->i_raw_lock);
  4353          if (inode->i_sb->s_flags & MS_LAZYTIME)
  4354                  ext4_update_other_inodes_time(inode->i_sb, inode->i_ino,
  4355                                                bh->b_data);
  4356  
  4357          BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
  4358          rc = ext4_handle_dirty_metadata(handle, NULL, bh);
  4359          if (!err)
  4360                  err = rc;

That patch shifted things around so now we can just say:

		err = ext4_handle_dirty_metadata(handle, NULL, bh);

But my only concern is that should we check the error code?

  4361          ext4_clear_inode_state(inode, EXT4_STATE_NEW);
  4362          if (set_large_file) {
  4363                  BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get write access");
  4364                  err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
                        ^^^
We overwrite it if set_large_file is true.

  4365                  if (err)
  4366                          goto out_brelse;
  4367                  ext4_update_dynamic_rev(sb);
  4368                  EXT4_SET_RO_COMPAT_FEATURE(sb,
  4369                                             EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
  4370                  ext4_handle_sync(handle);
  4371                  err = ext4_handle_dirty_super(handle, sb);
  4372          }
  4373          ext4_update_inode_fsync_trans(handle, inode, need_datasync);
  4374  out_brelse:
  4375          brelse(bh);
  4376          ext4_std_error(inode->i_sb, err);
  4377          return err;
  4378  }

regards,
dan carpenter
