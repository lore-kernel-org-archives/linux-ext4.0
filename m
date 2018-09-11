From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH v2 2/3] ext4: fix to detect failure of
 dquot_initialize in project ioctl
Date: Wed, 12 Sep 2018 08:57:17 +0900
Message-ID: <1536710238-16858-2-git-send-email-wshilong1991@gmail.com>
References: <1536710238-16858-1-git-send-email-wshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, wshilong@ddn.com, dchinner@redhat.com
To: linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1536710238-16858-1-git-send-email-wshilong1991@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

We return most failure of dquota_initialize() except
inode evict, this could make a bit sense, for example
we allow file removal even quota files are broken?

But it dosen't make sense to allow setting project
if quota files etc are broken.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
v1->v2:
based it on one patchset, to make reviewers happy.
---
 fs/ext4/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f81102bd3203..781dd699bd7b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -359,7 +359,9 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 		brelse(iloc.bh);
 	}
 
-	dquot_initialize(inode);
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
 
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
-- 
2.17.1
