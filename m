From: Mathieu Malaterre <malat@debian.org>
Subject: [PATCH] =?UTF-8?q?ext4:=20make=20function=20=E2=80=98ext4=5Fgetfs?= =?UTF-8?q?map=5Ffind=5Ffixed=5Fmetadata=E2=80=99=20static?=
Date: Sat,  5 May 2018 22:04:52 +0200
Message-ID: <20180505200452.18962-1-malat@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Mathieu Malaterre <malat@debian.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since function ‘ext4_getfsmap_find_fixed_metadata’ can be made static,
make it so. Remove the following gcc warning (W=1):

  fs/ext4/fsmap.c:405:5: warning: no previous prototype for ‘ext4_getfsmap_find_fixed_metadata’ [-Wmissing-prototypes]

Signed-off-by: Mathieu Malaterre <malat@debian.org>
---
 fs/ext4/fsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index e871c4bf18e9..4b99e2db95b8 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -402,8 +402,8 @@ static void ext4_getfsmap_free_fixed_metadata(struct list_head *meta_list)
 }
 
 /* Find all the fixed metadata in the filesystem. */
-int ext4_getfsmap_find_fixed_metadata(struct super_block *sb,
-				      struct list_head *meta_list)
+static int ext4_getfsmap_find_fixed_metadata(struct super_block *sb,
+					     struct list_head *meta_list)
 {
 	struct ext4_group_desc *gdp;
 	ext4_group_t agno;
-- 
2.11.0
