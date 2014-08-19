From: Gioh Kim <gioh.kim@lge.com>
Subject: [PATCHv2 0/3] new APIs to allocate buffer-cache with user specific
 flag
Date: Tue, 19 Aug 2014 15:51:18 +0900
Message-ID: <53F2F3E6.1030901@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Cc: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
	=?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

This patch try to solve problem that a long-lasting page caches of
ext4 superblock and journaling of superblock disturb page migration.

I've been testing CMA feature on my ARM-based platform
and found that two page caches cannot be migrated.
They are page caches of superblock of ext4 filesystem and its journaling data.

Current ext4 reads superblock with sb_bread() that allocates page
from movable area. But the problem is that ext4 hold the page until
it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
And also the journaling data for the superblock cannot be migreated.

I introduce a new API that allocates page cache with specific flag passed by an argument.
The API user can set flag to zero if the user wants to allocate page cache from non-movable area.

It is useful for ext4/ext3 and others that want to hold page cache for a long time.

I have 3 patchs:

1. Patch 1/3: introduce a new API that create page cache with allocation flag
2. Patch 2/3: have ext4 use the new API to read superblock
3. Patch 3/3: have jbd/jbd2 use the new API to make journaling of superblock

This patchset is based on linux-next-20140814.

Thanks a lot.

Gioh Kim (3):
 fs/buffer.c: allocate buffer cache with user specific flag
 ext4: allocate buffer-cache for superblock in non-movable area
 jbd-jbd2-allocate-buffer-cache-for-superblock-inode-.patch

 fs/buffer.c                 |   52 +++++++++++++++++++++++++++++---------------
 fs/ext4/super.c             |    6 ++---
 fs/jbd/journal.c            |    2 -
 fs/jbd2/journal.c           |    2 -
 include/linux/buffer_head.h |   12 +++++++++-
 5 files changed, 51 insertions(+), 23 deletions(-)
