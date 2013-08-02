From: Piotr Sarna <p.sarna@partner.samsung.com>
Subject: [PATCH 1/2] ext4: fix handling of nodelalloc parameter
Date: Fri, 02 Aug 2013 14:03:46 +0200
Message-ID: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, b.zolnierkie@samsung.com,
	Piotr Sarna <p.sarna@partner.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 26092bf ("ext4: use a table-driven handler for mount options")
introduced buggy handling of nodelalloc parameter in mount command.

After explicitly using delalloc or nodelalloc parameter in mount command,
MOPT_EXPLICIT flag is set. After that, a test ensures that "data=journal"
and "delalloc" parameters are not simultaneously activated.
Unluckily, the mentioned test reports a bug in both situations:
- "data=journal,delalloc"
- "data=journal,nodelalloc"
whereas the second one is perfectly legal and acceptable.

A simple solution to this problem is in setting EXPLICIT_DELALLOC flag
properly. This patch ensures that EXPLICIT_DELALLOC flag is set only
if "delalloc" parameter was used, and not set in case of "nodelalloc".

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 94cc84d..10f9bb0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1467,7 +1467,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
 		return -1;
 	if (m->flags & MOPT_EXPLICIT)
-		set_opt2(sb, EXPLICIT_DELALLOC);
+		if (m->flags & MOPT_SET)
+			set_opt2(sb, EXPLICIT_DELALLOC);
 	if (m->flags & MOPT_CLEAR_ERR)
 		clear_opt(sb, ERRORS_MASK);
 	if (token == Opt_noquota && sb_any_quota_loaded(sb)) {
-- 
1.7.9.5
