From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/4] ext4: fix possible use-after-free ext4_remove_li_request()
Date: Mon,  9 May 2011 17:57:10 +0200
Message-ID: <1304956630-20384-4-git-send-email-lczerner@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1EIP5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 11:57:45 -0400
In-Reply-To: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to take reference to the s_li_request after we take a mutex,
because it might be freed since then, hence result in accessing old
already freed memory. Also we should protect the whole
ext4_remove_li_request() because ext4_li_info might be in the process of
being freed in ext4_lazyinit_thread().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c379af6..6a8e48f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2721,14 +2721,16 @@ static void ext4_remove_li_request(struct ext4_li_request *elr)
 
 static void ext4_unregister_li_request(struct super_block *sb)
 {
-	struct ext4_li_request *elr = EXT4_SB(sb)->s_li_request;
