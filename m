From: Gioh Kim <gioh.kim@lge.com>
Subject: [PATCHv2 3/3] jbd/jbd2: allocate buffer-cache for superblock inode
 in non-movable area
Date: Tue, 19 Aug 2014 15:54:09 +0900
Message-ID: <53F2F491.50208@lge.com>
References: <53F2F3E6.1030901@lge.com>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <53F2F3E6.1030901@lge.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


A long-lasting buffer-cache can distrub page migration so that
it must be allocated from non-movable area.

The journal_init_inode is creating a buffer-cache for superblock journaling.
The superblock exists until system shutdown so that the buffer-cache
for the superblock would also exist for a long time
and it can distrub page migration.

This patch make the buffer-cache be allocated from non-movable area
not to distrub page migration.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 06fe11e..a9f8aaf 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -886,7 +886,7 @@ journal_t * journal_init_inode (struct inode *inode)
                goto out_err;
        }

-       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+       bh = __getblk_gfp(journal->j_dev, blocknr, journal->j_blocksize, 0);
        if (!bh) {
                printk(KERN_ERR
                       "%s: Cannot get buffer for journal superblock\n",
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 67b8e30..0461998 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1237,7 +1237,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
                goto out_err;
        }

-       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+       bh = __getblk_gfp(journal->j_dev, blocknr, journal->j_blocksize, 0);
        if (!bh) {
                printk(KERN_ERR
                       "%s: Cannot get buffer for journal superblock\n",
--
1.7.9.5

