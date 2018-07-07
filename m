From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [Bisect] ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt
 inode bitmap
Date: Sat, 7 Jul 2018 00:10:18 -0400
Message-ID: <20180707041018.GB3546@thunk.org>
References: <20180706174324.GA3049@xps13.dannf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        yanaijie@huawei.com, colin.king@canonical.com,
        kamal.mostafa@canonical.com, ike.pan@canonical.com
To: dann frazier <dann.frazier@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706174324.GA3049@xps13.dannf>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 06, 2018 at 11:43:24AM -0600, dann frazier wrote:
> Hi,
>   We're seeing a regression triggered by the stress-ng[*] "chdir" test
> that I've bisected to:
> 
> 044e6e3d74a3 ext4: don't update checksum of new initialized bitmaps
> 
> So far we've only seen failures on servers based on HiSilicon's family
> of ARM64 SoCs (D05/Hi1616 SoC, D06/Hi1620 SoC). On these systems it is
> very reproducible.

Thanks for the report.  Can you verify whether or not this patch fixes
things for you?

					- Ted

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index da6c10c1e37a..1cfb74bc4dca 100644
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
