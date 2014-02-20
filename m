From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH V5 0/3] ext4: increase mbcache scalability
Date: Thu, 20 Feb 2014 11:37:39 -0700
Message-ID: <1392921462-75500-1-git-send-email-tmac@hp.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
Cc: aswin@hp.com, T Makphaibulchoke <tmac@hp.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374108934-50550-1-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The patch consists of three parts.

The first part changes the implementation of both the block and hash chains of
an mb_cache from list_head to hlist_bl_head and also introduces new members,
including a spinlock to mb_cache_entry, as required by the second part.

The second part introduces higher degree of parallelism to the usages of the
mb_cache and mb_cache_entries and impacts all ext filesystems.

The third part of the patch further increases the scalablity of an ext4
filesystem by having each ext4 fielsystem allocate and use its own private
mbcache structure, instead of sharing a single mcache structures across all
ext4 filesystems, and increases the size of its mbcache hash tables.

Here are some of the benchmark results with the changes.

Using ram disk, there seems to be no peformance differences with aim7 for all
workloads on all platforms tested.

With regular disk filesystems with inode size of 128 bytes, forcing the uses
of external xattr, there seems to be some good peformance increases with
some of the aim7's workloads on all platforms tested.

Here are some of the performance improvement on aim7 with 2000 users.

On a 20 core macine, there is no performance differences.

On a 60 core machine:

---------------------------
|             | % increase |
---------------------------
| alltests    |     74.69  |
---------------------------
| custom      |     77.1   |
---------------------------
| disk        |    125.02  |
---------------------------
| fserver     |    113.22  |
---------------------------
| new_dbase   |     21.17  |
---------------------------
| new_fserve  |     70.31  |
---------------------------
| shared      |     52.56  |
---------------------------

On a 80 core machine:

---------------------------
|             | % increase |
---------------------------
| custom      |     74.29  |
---------------------------
| disk        |     61.01  |
---------------------------
| fserver     |     11.59  |
---------------------------
| new_fserver |     32.76  |
---------------------------

The changes have been tested with ext4 xfstests to verify that no regression
has been introduced.

Changed in v5:
        - New performance data
	- New diff summary

Changed in v4:
        - New performance data
	- New diff summary
	- New patch architecture

Changed in v3:
	- New idff summary

Changed in v2:
        - New performance data
	- New diff summary

T Makphaibulchoke (3):
  fs/mbcache.c change block and index hash chain to hlist_bl_node
  mbcache: decoupling the locking of local from global data
  ext4: each filesystem creates and uses its own mb_cache

 fs/ext4/ext4.h          |   1 +
 fs/ext4/super.c         |  24 ++-
 fs/ext4/xattr.c         |  51 ++---
 fs/ext4/xattr.h         |   6 +-
 fs/mbcache.c            | 540 ++++++++++++++++++++++++++++++++++--------------
 include/linux/mbcache.h |  12 +-
 6 files changed, 441 insertions(+), 193 deletions(-)

-- 
1.7.11.3
