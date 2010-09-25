From: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 04/10] Fs: ext4: block_validity: added space around = sign
Date: Sat, 25 Sep 2010 14:31:55 -0400
Message-ID: <1285439521-2557-4-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0IYSc4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Sep 2010 14:32:56 -0400
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tracey Dent <Tdent48227@gmail.com>

Added space around = sign. Checkpatch.pl detected the issue

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/block_validity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 3db5084..25e9f52 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -156,7 +156,7 @@ int ext4_setup_system_zone(struct super_block *sb)
 	if (EXT4_SB(sb)->system_blks.rb_node)
 		return 0;
 
-	for (i=0; i < ngroups; i++) {
+	for (i = 0; i < ngroups; i++) {
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
-- 
1.7.3

