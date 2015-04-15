From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4 crypto: enforce context consistency
Date: Wed, 15 Apr 2015 22:10:07 +0300
Message-ID: <20150415191007.GA32654@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50331 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbbDOTKZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2015 15:10:25 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore Ts'o,

The patch faac02be2843: "ext4 crypto: enforce context consistency"
from Apr 12, 2015, leads to the following static checker warning:

	fs/ext4/namei.c:1646 ext4_lookup()
	error: 'inode' dereferencing possible ERR_PTR()

fs/ext4/namei.c
  1638                  inode = ext4_iget_normal(dir->i_sb, ino);
  1639                  if (inode == ERR_PTR(-ESTALE)) {

We normally check ext4_iget() against -ESTALE, but then we changed this
to ext4_iget_normal() which returns several error values.

  1640                          EXT4_ERROR_INODE(dir,
  1641                                           "deleted inode referenced: %u",
  1642                                           ino);
  1643                          return ERR_PTR(-EIO);
  1644                  }
  1645                  if (ext4_encrypted_inode(dir) &&
  1646                      (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
  1647                       S_ISLNK(inode->i_mode)) &&
  1648                      !ext4_is_child_context_consistent_with_parent(dir,
  1649                                                                    inode)) {
  1650                          iput(inode);
  1651                          ext4_warning(inode->i_sb,
  1652                                       "Inconsistent encryption contexts: %lu/%lu\n",
  1653                                       (unsigned long) dir->i_ino,
  1654                                       (unsigned long) inode->i_ino);
  1655                          return ERR_PTR(-EPERM);
  1656                  }

regards,
dan carpenter
