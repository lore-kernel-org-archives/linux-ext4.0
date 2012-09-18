From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: convert file system to meta_bg if needed during resizing
Date: Tue, 18 Sep 2012 14:46:35 +0300
Message-ID: <20120918114634.GA12383@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Fengguang Wu <fengguang.wu@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:20323 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab2IRLqg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Sep 2012 07:46:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore Ts'o,

The patch 1c6bd7173d66: "ext4: convert file system to meta_bg if 
needed during resizing" from Sep 13, 2012, leads to the following 
warning:
fs/ext4/resize.c:1829 ext4_convert_meta_bg()
	 error: potential NULL dereference 'ei'.

  1770  static int ext4_convert_meta_bg(struct super_block *sb, struct inode *inode)
  1771  {
  1772          handle_t *handle;
  1773          struct ext4_sb_info *sbi = EXT4_SB(sb);
  1774          struct ext4_super_block *es = sbi->s_es;
  1775          struct ext4_inode_info *ei = 0;
                                        ^^^^^^
Sparse is going to complain.  Not sure why Fengguang hasn't emailed you.

  1776          ext4_fsblk_t nr;
  1777          int i, ret, err = 0;
  1778          int credits = 1;
  1779  
  1780          ext4_msg(sb, KERN_INFO, "Converting file system to meta_bg");
  1781          if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_RESIZE_INODE)) {
  1782                  if (es->s_reserved_gdt_blocks) {
  1783                          ext4_error(sb, "Unexpected non-zero "
  1784                                     "s_reserved_gdt_blocks");
  1785                          return -EPERM;
  1786                  }
  1787                  if (!inode) {
  1788                          ext4_error(sb, "Unexpected NULL resize_inode");
  1789                          return -EPERM;
  1790                  }
  1791                  ei = EXT4_I(inode);
                        ^^^^^^^^^^^^^^^^^^
We only set "ei" if EXT4_FEATURE_COMPAT_RESIZE_INODE.

  1792  
  1793                  /* Do a quick sanity check of the resize inode */
  1794                  if (inode->i_blocks != 1 << (inode->i_blkbits - 9))
  1795                          goto invalid_resize_inode;
  1796                  for (i = 0; i < EXT4_N_BLOCKS; i++) {
  1797                          if (i == EXT4_DIND_BLOCK) {
  1798                                  if (ei->i_data[i])
  1799                                          continue;
  1800                                  else
  1801                                          goto invalid_resize_inode;
  1802                          }
  1803                          if (ei->i_data[i])
  1804                                  goto invalid_resize_inode;
  1805                  }
  1806                  credits += 3;   /* block bitmap, bg descriptor, resize inode */
  1807          }
  1808  
  1809          handle = ext4_journal_start_sb(sb, credits);
  1810          if (IS_ERR(handle))
  1811                  return PTR_ERR(handle);
  1812  
  1813          err = ext4_journal_get_write_access(handle, sbi->s_sbh);
  1814          if (err)
  1815                  goto errout;
  1816  
  1817          EXT4_CLEAR_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_RESIZE_INODE);
  1818          EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
  1819          sbi->s_es->s_first_meta_bg =
  1820                  cpu_to_le32(num_desc_blocks(sb, sbi->s_groups_count));
  1821  
  1822          err = ext4_handle_dirty_super(handle, sb);
  1823          if (err) {
  1824                  ext4_std_error(sb, err);
  1825                  goto errout;
  1826          }
  1827  
  1828          if (inode) {
  1829                  nr = le32_to_cpu(ei->i_data[EXT4_DIND_BLOCK]);
                                         ^^^^^^^^^^
Null deref.  Perhaps inode implies EXT4_FEATURE_COMPAT_RESIZE_INODE?

  1830                  ext4_free_blocks(handle, inode, NULL, nr, 1,
  1831                                   EXT4_FREE_BLOCKS_METADATA |
  1832                                   EXT4_FREE_BLOCKS_FORGET);
  1833                  ei->i_data[EXT4_DIND_BLOCK] = 0;
  1834                  inode->i_blocks = 0;
  1835  
  1836                  err = ext4_mark_inode_dirty(handle, inode);
  1837                  if (err)
  1838                          ext4_std_error(sb, err);
  1839          }

regards,
dan carpenter

