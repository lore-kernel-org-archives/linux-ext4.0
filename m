From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH] ext4: remove useless s_dirt assignment
Date: Mon, 19 Mar 2012 14:50:48 +0200
Message-ID: <1332161448-1355-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Clean-up ext4 a tiny bit by removing useless s_dirt assignment in
'ext4_fill_super()' because a bit later we anyway call 'ext4_setup_super()'
which writes the superblock to the media unconditionally.

I would not bother removing the assignment, but I am prepare the code for
further s_dirt clean-ups.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c1f5111..d280bb6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3415,7 +3415,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #else
 		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
-		sb->s_dirt = 1;
 	}
 
 	/* Handle clustersize */
-- 
1.7.7.6

