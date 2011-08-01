From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] ext4: prevent memory leaks from ext4_mb_init_backend() on error path
Date: Mon,  1 Aug 2011 09:13:18 -0400
Message-ID: <1312204398-12460-6-git-send-email-tytso@mit.edu>
References: <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
 <1312204398-12460-1-git-send-email-tytso@mit.edu>
Cc: Yu Jian <yujian@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40457 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1HANN0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 09:13:26 -0400
In-Reply-To: <1312204398-12460-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yu Jian <yujian@whamcloud.com>

In ext4_mb_init(), if the s_locality_group allocation fails it will
currently cause the allocations made in ext4_mb_init_backend() to
be leaked.  Moving the ext4_mb_init_backend() allocation after the
s_locality_group allocation avoids that problem.

Signed-off-by: Yu Jian <yujian@whamcloud.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8beccd8..c6c71af 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2465,12 +2465,6 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 		i++;
 	} while (i <= sb->s_blocksize_bits + 1);
 
-	/* init file for buddy data */
-	ret = ext4_mb_init_backend(sb);
-	if (ret != 0) {
-		goto out;
-	}
