From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [Bisect] ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt
 inode bitmap
Date: Thu, 12 Jul 2018 19:08:26 -0400
Message-ID: <20180712230826.GB28610@thunk.org>
References: <20180706174324.GA3049@xps13.dannf>
 <20180707041018.GB3546@thunk.org>
 <20180710165143.GA20459@xps13.dannf>
 <20180710204329.GB20459@xps13.dannf>
 <b39169ad-2237-0a4f-e3d1-afc51ac10fa5@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dann frazier <dann.frazier@canonical.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        yanaijie@huawei.com, colin.king@canonical.com,
        kamal.mostafa@canonical.com
To: Ike Panhc <ike.pan@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b39169ad-2237-0a4f-e3d1-afc51ac10fa5@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> 
> Review console log and on each run I have filesystem rebuild. The problem
> is that mke2fs I am using is 1.44.3-rc2. I am now reseting the environment
> and re-test.
>

Could it be that you saw the error in ext4_validate_block_bitmap()?
The patch which I sent Dann only fixed the problem for inode bitmaps;
I noticed today that we need to fix it for block allocation bitmaps as
well.

						- Ted

commit 8d5a803c6a6ce4ec258e31f76059ea5153ba46ef
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Jul 12 19:08:05 2018 -0400

    ext4: check for allocation block validity with block group locked
    
    With commit 044e6e3d74a3: "ext4: don't update checksum of new
    initialized bitmaps" the buffer valid bit will get set without
    actually setting up the checksum for the allocation bitmap, since the
    checksum will get calculated once we actually allocate an inode or
    block.
    
    If we are doing this, then we need to (re-)check the verified bit
    after we take the block group lock.  Otherwise, we could race with
    another process reading and verifying the bitmap, which would then
    complain about the checksum being invalid.
    
    https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1780137
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Cc: stable@kernel.org

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e68cefe08261..aa52d87985aa 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -368,6 +368,8 @@ static int ext4_validate_block_bitmap(struct super_block *sb,
 		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
+	if (buffer_verified(bh))
+		goto verified;
 	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
 			desc, bh))) {
 		ext4_unlock_group(sb, block_group);
@@ -386,6 +388,7 @@ static int ext4_validate_block_bitmap(struct super_block *sb,
 		return -EFSCORRUPTED;
 	}
 	set_buffer_verified(bh);
+verified:
 	ext4_unlock_group(sb, block_group);
 	return 0;
 }
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index fb83750c1a14..e9d8e2667ab5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -90,6 +90,8 @@ static int ext4_validate_inode_bitmap(struct super_block *sb,
 		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
+	if (buffer_verified(bh))
+		goto verified;
 	blk = ext4_inode_bitmap(sb, desc);
 	if (!ext4_inode_bitmap_csum_verify(sb, block_group, desc, bh,
 					   EXT4_INODES_PER_GROUP(sb) / 8)) {
@@ -101,6 +103,7 @@ static int ext4_validate_inode_bitmap(struct super_block *sb,
 		return -EFSBADCRC;
 	}
 	set_buffer_verified(bh);
+verified:
 	ext4_unlock_group(sb, block_group);
 	return 0;
 }
