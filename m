Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730414AbeLTTPY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Dec 2018 14:15:24 -0500
Date: Thu, 20 Dec 2018 22:14:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Subject: [bug report] ext4: avoid declaring fs inconsistent due to invalid
 file handles
Message-ID: <20181220191428.GA4895@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore Ts'o,

The patch 6e74cde1f494: "ext4: avoid declaring fs inconsistent due to
invalid file handles" from Dec 19, 2018, leads to the following
static checker warning:

	fs/ext4/inode.c:4841 __ext4_iget()
	warn: bitwise AND condition is false here

fs/ext4/inode.c
  4825  struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
  4826                            ext4_iget_flags flags, const char *function,
  4827                            unsigned int line)
  4828  {
  4829          struct ext4_iloc iloc;
  4830          struct ext4_inode *raw_inode;
  4831          struct ext4_inode_info *ei;
  4832          struct inode *inode;
  4833          journal_t *journal = EXT4_SB(sb)->s_journal;
  4834          long ret;
  4835          loff_t size;
  4836          int block;
  4837          uid_t i_uid;
  4838          gid_t i_gid;
  4839          projid_t i_projid;
  4840  
  4841          if (((flags & EXT4_IGET_NORMAL) &&
                      ^^^^^^^^^^^^^^^^^^^^^^^^

EXT4_IGET_NORMAL is zero so this condition is never true.  Is this
something which will depend on the CONFIG_ options or is it supposed
to be flags == EXT4_IGET_NORMAL?  I don't know.

  4842               (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)) ||
  4843              (ino < EXT4_ROOT_INO) ||
  4844              (ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
  4845                  if (flags & EXT4_IGET_HANDLE)
  4846                          return ERR_PTR(-ESTALE);
  4847                  __ext4_error(sb, function, line,
  4848                               "inode #%lu: comm %s: iget: illegal inode #",
  4849                               ino, current->comm);
  4850                  return ERR_PTR(-EFSCORRUPTED);
  4851          }
  4852  
  4853          inode = iget_locked(sb, ino);
  4854          if (!inode)

regards,
dan carpenter
