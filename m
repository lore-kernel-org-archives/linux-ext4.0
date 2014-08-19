From: Gioh Kim <gioh.kim@lge.com>
Subject: [PATCHv2 2/3] ext4: allocate buffer-cache for superblock in non-movable
 area
Date: Tue, 19 Aug 2014 15:53:23 +0900
Message-ID: <53F2F463.9000703@lge.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53F2F3E6.1030901@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


A buffer-cache for superblock is disturbing page migration,
because the buffer-cache is not released until unmount.
The buffer-cache must be allocated from non-movable area.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..13d7770 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3435,7 +3435,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
                logical_sb_block = sb_block;
        }

-       if (!(bh = sb_bread(sb, logical_sb_block))) {
+       if (!(bh = sb_bread_gfp(sb, logical_sb_block, 0))) {
                ext4_msg(sb, KERN_ERR, "unable to read superblock");
                goto out_fail;
        }
@@ -3645,7 +3645,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
                brelse(bh);
                logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
                offset = do_div(logical_sb_block, blocksize);
-               bh = sb_bread(sb, logical_sb_block);
+               bh = sb_bread_gfp(sb, logical_sb_block, 0);
                if (!bh) {
                        ext4_msg(sb, KERN_ERR,
                               "Can't read superblock on 2nd try");
@@ -3867,7 +3867,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)

        for (i = 0; i < db_count; i++) {
                block = descriptor_loc(sb, logical_sb_block, i);
-               sbi->s_group_desc[i] = sb_bread(sb, block);
+               sbi->s_group_desc[i] = sb_bread_gfp(sb, block, 0);
                if (!sbi->s_group_desc[i]) {
                        ext4_msg(sb, KERN_ERR,
                               "can't read group descriptor %d", i);
--
1.7.9.5
