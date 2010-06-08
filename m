From: shenghui <crosslonelyover@gmail.com>
Subject: [PATCH] Documentation/filesystems/xip.txt: clarify the statement: The
	block device option is mandatory for execute-in-place
Date: Tue, 8 Jun 2010 16:37:04 +0800
Message-ID: <AANLkTik9UM9ta3r7ZNt8Z-CNS6Vz-aIWb_qewgECFfoe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

      The origin text in xip.txt said:
" The block device operation is optional, these block devices support it as of
  today:
  - dcssblk: s390 dcss block device driver
"

      While in fs/ext2/xip.c, we can get the following code:
  65void ext2_xip_verify_sb(struct super_block *sb)
  66{
  67        struct ext2_sb_info *sbi = EXT2_SB(sb);
  68
  69        if ((sbi->s_mount_opt & EXT2_MOUNT_XIP) &&
  70            !sb->s_bdev->bd_disk->fops->direct_access) {
  71                sbi->s_mount_opt &= (~EXT2_MOUNT_XIP);
  72                ext2_msg(sb, KERN_WARNING,
  73                             "warning: ignoring xip option - "
  74                             "not supported by bdev");
  75        }
  76}

        While the statement in the origin text may be against other
block devices, I get confused at first, so I modify the statement
to make it more clear.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>

---
 Documentation/filesystems/xip.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/xip.txt
b/Documentation/filesystems/xip.txt
index 0466ee5..bef4120 100644
--- a/Documentation/filesystems/xip.txt
+++ b/Documentation/filesystems/xip.txt
@@ -35,8 +35,7 @@ is performed. A struct block_device reference is
used to address the device,
 and a sector_t argument is used to identify the individual block. As an
 alternative, memory technology devices can be used for this.

-The block device operation is optional, these block devices support it as of
-today:
+The block device operation is mandatory for execute-in-place, these
block devices support it as of today:
 - dcssblk: s390 dcss block device driver

 An address space operation named get_xip_mem is used to retrieve references
-- 
1.7.0.1


-- 


Thanks and Best Regards,
shenghui
