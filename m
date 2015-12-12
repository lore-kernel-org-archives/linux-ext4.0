From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4 crypto: add ciphertext_access mount option
Date: Sat, 12 Dec 2015 17:24:56 +0300
Message-ID: <20151212142456.GA24945@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41904 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbLLOZF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Dec 2015 09:25:05 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore Ts'o,

The patch 843848f73114: "ext4 crypto: add ciphertext_access mount
option" from Dec 10, 2015, leads to the following static checker
warning:

	fs/ext4/inode.c:3349 ext4_direct_IO()
	warn: we tested '(()->type & (1 << 0)) == (1 << 0)' before and it was 'false'

fs/ext4/inode.c
  3336  static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
  3337                                loff_t offset)
  3338  {
  3339          struct file *file = iocb->ki_filp;
  3340          struct inode *inode = file->f_mapping->host;
  3341          size_t count = iov_iter_count(iter);
  3342          ssize_t ret;
  3343  
  3344          if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode)) {
  3345                  if (iov_iter_rw(iter) == WRITE)
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^
Checked.

  3346                          return 0;
  3347                  if (test_opt(inode->i_sb, CIPHERTEXT_ACCESS) &&
  3348                      capable(CAP_SYS_ADMIN)) {
  3349                          if (iov_iter_rw(iter) == WRITE)
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^
Checked again but we know that it's not true.

  3350                                  return -EPERM;
  3351                  } else
  3352                          return 0;
  3353          }

regards,
dan carpenter
