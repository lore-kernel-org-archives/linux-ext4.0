From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 0/2 V3] e2fsprogs/debugfs: do sparse copy when src is a sparse file
Date: Mon, 29 Jul 2013 17:06:23 +0800
Message-ID: <1375088785-30653-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>,
	<darrick.wong@oracle.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:57121 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3G2JIu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 05:08:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

* BTW., we are trying to use the debugfs to create an ext2/ext3/ext4
  image based on a given directory or file, which is similar to genext2fs,
  please vist here for the script you are interested in it: 

  https://gist.github.com/robertlinux/6034499

  It is an external shell script at the moment, the performance is not good,
  so we are going to: 
  - Integrate this function into mke2fs in C language.
  - Add a [-d <directory>] option to specify the initial directory in mke2fs

  I'm not sure whether such a patch is acceptable or not, please feel free to
  give your comments.

Robert Yang
Wind River System

Robert Yang (2):
  debugfs.c: the max length of debugfs argument is too short
  debugfs.c: do sparse copy when src is a sparse file

 debugfs/debugfs.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 62 insertions(+), 5 deletions(-)

-- 
1.8.1.2

