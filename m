From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 0/3 V4] e2fsprogs/debugfs: do sparse copy when src is a sparse file
Date: Mon, 26 Aug 2013 14:22:01 +0800
Message-ID: <1377498124-25842-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>,
	<darrick.wong@oracle.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:59881 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3HZG03 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Aug 2013 02:26:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=== V4:
* Add a free(buf) in debugfs.c to fix a potential memory leak issue.

* Add the contrib/populate-extfs.sh to populate the ext2/3/4 filesystem
  from a given directory.

=== V3: 
* Use BUFSIZ (which is 8192 on Linux systems) for the max argument
  length as Ted suggested.

* Use ext2fs_get_memzero() and move it out of the while loop to get a
  better performance as Darrick suggested.

=== V2: 
* Use 64K for the IO_BUFSIZE and use malloc() to allocate the memory for 
  the buffer respect to Darrick's comments.

* Use calloc() and memcmp() to check the sparse block as Darrick
  suggested.

* Adjust the frame and remove a few un-needed code as Darrick
  suggested.

=== V1: 
* There are two patches, one is used for fixing the max length of the 
  argument, the other one is for sparsing copy when src is a sparse
  file.

// Robert

Robert Yang (3):
  debugfs.c: the max length of debugfs argument is too short
  debugfs.c: do sparse copy when src is a sparse file
  contrib/populate-extfs.sh: use debugfs to populate extX fs

 contrib/populate-extfs.sh | 105 ++++++++++++++++++++++++++++++++++++++++++++++
 debugfs/debugfs.c         |  68 +++++++++++++++++++++++++++---
 2 files changed, 168 insertions(+), 5 deletions(-)
 create mode 100755 contrib/populate-extfs.sh

-- 
1.8.1.2

