From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] resize: bigalloc_check() should have return type void
Date: Mon, 25 Feb 2013 16:55:08 +0100
Message-ID: <1361807708-15871-5-git-send-email-jack@suse.cz>
References: <1361807708-15871-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab3BYPzP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 10:55:15 -0500
In-Reply-To: <1361807708-15871-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 resize/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 4cbfe69..b648a15 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -147,7 +147,7 @@ static void determine_fs_stride(ext2_filsys fs)
 #endif
 }
 
-static bigalloc_check(ext2_filsys fs, int force)
+static void bigalloc_check(ext2_filsys fs, int force)
 {
 	if (!force && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
-- 
1.7.1

