From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v3 0/3] Add XIP support to ext4
Date: Tue, 17 Dec 2013 14:18:25 -0500
Message-ID: <cover.1387307259.git.matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab3LQTSj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Dec 2013 14:18:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For v3, we've addressed the problem with unwritten extents that Dave
Chinner pointed out.  Rather than testing bh_unwritten() as he suggested,
I opted for checking !buffer_mapped() as block_read_full_page() in
fs/buffer.c does.  While I'm in that function I renamed the buffer_head
from 'tmp' to 'bh' to follow normal usage.

I also folded the "ext4: Add xip hole punching" patch into the main
"Add XIP functionality" patch since otherwise we're introducing broken
functionality in the middle of the series.

Matthew Wilcox (2):
  Fix XIP fault vs truncate race
  xip: Add xip_zero_page_range

Ross Zwisler (1):
  ext4: Add XIP functionality

 Documentation/filesystems/ext4.txt |  2 +
 Documentation/filesystems/xip.txt  |  3 ++
 fs/Kconfig                         |  2 +-
 fs/ext4/Kconfig                    | 11 +++++
 fs/ext4/Makefile                   |  1 +
 fs/ext4/ext4.h                     |  4 +-
 fs/ext4/file.c                     | 17 ++++++++
 fs/ext4/inode.c                    | 86 +++++++++++++++++++++++++++-----------
 fs/ext4/namei.c                    | 11 ++++-
 fs/ext4/super.c                    | 36 +++++++++++++++-
 fs/ext4/xip.c                      | 78 ++++++++++++++++++++++++++++++++++
 fs/ext4/xip.h                      | 24 +++++++++++
 include/linux/fs.h                 |  8 ++++
 mm/filemap_xip.c                   | 55 ++++++++++++++++--------
 14 files changed, 289 insertions(+), 49 deletions(-)
 create mode 100644 fs/ext4/xip.c
 create mode 100644 fs/ext4/xip.h

-- 
1.8.4.rc3

