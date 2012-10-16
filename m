From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 02/10] ext4: block_validity: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:42:57 +0530
Message-ID: <1350414785-7848-2-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed checkpatch.pl reported issue

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/block_validity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/block_validity.c b/linux-3.7-rc1/fs/ext4/block_validity.c
index 3f11656..d04018a 100644
--- a/linux-3.7-rc1/fs/ext4/block_validity.c
+++ b/linux-3.7-rc1/fs/ext4/block_validity.c
@@ -154,7 +154,7 @@ int ext4_setup_system_zone(struct super_block *sb)
 	if (EXT4_SB(sb)->system_blks.rb_node)
 		return 0;
 
-	for (i=0; i < ngroups; i++) {
+	for (i = 0; i < ngroups; i++) {
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
-- 
1.7.7.3
