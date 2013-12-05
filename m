From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/4] ext4: Add XIP functionality
Date: Thu,  5 Dec 2013 13:02:44 -0700
Message-ID: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60450 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab3LEUC6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Dec 2013 15:02:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series addresses the comments received from the first revision.

We didn't change our use of ext4_get_block() to ext4_map_blocks() because it
seems like we would need to add code to deal with journal entries, similar to
what is done in _ext4_get_block().  This seemed more complicated than using a
temporary struct buffer_head on the stack - please let us know if you
disagree.

Matthew Wilcox (3):
  Fix XIP fault vs truncate race
  xip: Add xip_zero_page_range
  ext4: Add xip hole punching

Ross Zwisler (1):
  ext4: Add XIP functionality

 Documentation/filesystems/ext4.txt |    2 +
 Documentation/filesystems/xip.txt  |    3 ++
 fs/Kconfig                         |    2 +-
 fs/ext4/Kconfig                    |   11 +++++
 fs/ext4/Makefile                   |    1 +
 fs/ext4/ext4.h                     |    4 +-
 fs/ext4/file.c                     |   17 +++++++
 fs/ext4/inode.c                    |   86 +++++++++++++++++++++++++-----------
 fs/ext4/namei.c                    |   11 ++++-
 fs/ext4/super.c                    |   36 ++++++++++++++-
 fs/ext4/xip.c                      |   78 ++++++++++++++++++++++++++++++++
 fs/ext4/xip.h                      |   24 ++++++++++
 include/linux/fs.h                 |    8 ++++
 mm/filemap_xip.c                   |   55 +++++++++++++++--------
 14 files changed, 289 insertions(+), 49 deletions(-)
 create mode 100644 fs/ext4/xip.c
 create mode 100644 fs/ext4/xip.h

-- 
1.7.10.4

