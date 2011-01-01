From: Dan Carpenter <error27@gmail.com>
Subject: smatch stuff: -next: null dereference in ext4_readdir()
Date: Sat, 1 Jan 2011 16:40:13 +0300
Message-ID: <20110101134013.GI1886@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51828 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1AANkj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Jan 2011 08:40:39 -0500
Received: by wyb28 with SMTP id 28so12295047wyb.19
        for <linux-ext4@vger.kernel.org>; Sat, 01 Jan 2011 05:40:38 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

There is a NULL dereference introduced in linux-next "ext4: Use
ext4_error_file() to print the pathname to the corrupted inode"

fs/ext4/dir.c +170 ext4_readdir(59) error: potential null derefence 'bh'.
   168                  if (!bh) {
   169                          if (!dir_has_error) {
   170                                  EXT4_ERROR_FILE(filp, bh->b_blocknr,
                                                              ^^^^^^^^^^^^^
	"bh" is null here.

   171                                                  "directory contains a "
   172                                                  "hole at offset %Lu",
   173                                             (unsigned long long) filp->f_pos);
   174                                  dir_has_error = 1;

regards,
dan carpenter
