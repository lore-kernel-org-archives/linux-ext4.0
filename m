From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 0/5] lseek SEEK_HOLE / SEEK_DATA fix and switch to iomap
Date: Mon, 26 Jun 2017 16:25:13 +0200
Message-ID: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here is an updated version of the lseek and iomap patches.  Changes:

 * Some cleanups to iomap_seek_{hole,data}_actor.

 * GFS2 patches omitted for now; those can be discussed later.

 * Per request, lseek and iomap patches posted in a single patch queue.

Thanks,
Andreas

Andreas Gruenbacher (5):
  vfs: Add page_cache_seek_hole_data helper
  ext4: Switch to page_cache_seek_hole_data
  xfs: Switch to page_cache_seek_hole_data
  vfs: Add iomap_seek_hole_data helper
  xfs: Switch to iomap for SEEK_HOLE / SEEK_DATA

 fs/buffer.c                 | 125 +++++++++++++++++++++++++
 fs/ext4/file.c              | 144 +++--------------------------
 fs/iomap.c                  |  91 ++++++++++++++++++
 fs/xfs/xfs_file.c           | 218 +++-----------------------------------------
 include/linux/buffer_head.h |   2 +
 include/linux/iomap.h       |   3 +
 6 files changed, 248 insertions(+), 335 deletions(-)

-- 
2.7.5
