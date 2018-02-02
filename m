From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] ext4: report delalloc reserve as non-free in statfs mangled
 by project quota
Date: Fri, 02 Feb 2018 13:40:05 +0300
Message-ID: <151756800585.979296.13086151972011935611.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This reserved space isn't committed yet but cannot be used for allocations.
For userspace it has no difference from used space. XFS already does this.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Fixes: 689c958cbe6b ("ext4: add project quota support")
---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5de959fb0244..13ce97b9e820 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5227,7 +5227,8 @@ static int ext4_statfs_project(struct super_block *sb,
 		 dquot->dq_dqb.dqb_bsoftlimit :
 		 dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
 	if (limit && buf->f_blocks > limit) {
-		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;
+		curblock = (dquot->dq_dqb.dqb_curspace +
+			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
 		buf->f_blocks = limit;
 		buf->f_bfree = buf->f_bavail =
 			(buf->f_blocks > curblock) ?
