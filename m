From: Gioh Kim <gioh.kim@lge.com>
Subject: [PATCH 0/2] new API to allocate buffer-cache for superblock in non-movable
 area
Date: Tue, 22 Jul 2014 14:18:47 +0900
Message-ID: <53CDF437.4090306@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

This patch try to solve problem that a long-lasting page cache of
ext4 superblock disturbs page migration.

I've been testing CMA feature on my ARM-based platform
and found some pages for page caches cannot be migrated.
Some of them are page caches of superblock of ext4 filesystem.

Current ext4 reads superblock with sb_bread(). sb_bread() allocates page
from movable area. But the problem is that ext4 hold the page until
it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.

I introduce a new API for allocating page from non-movable area.
It is useful for ext4 and others that want to hold page cache for a long time.

I have 2 patchs:

1. Patch 1/2: introduce a new API that create page cache from non-movable area
2. Patch 2/2: have ext4 use the new API to read superblock

This patchset is based on linux-next-20140717.

Thanks a lot.

Gioh Kim (2):
 fs/buffer.c: allocate buffer cache from non-movable area
 ext4: allocate buffer-cache for superblock in non-movable area

 fs/buffer.c                 |   39 ++++++++++++++++++++++++++++++++-------
 fs/ext4/super.c             |    6 +++---
 include/linux/buffer_head.h |    8 ++++++++
 3 files changed, 43 insertions(+), 10 deletions(-)
