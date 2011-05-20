From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/4 v2] ext4: fix possible use-after-free ext4_remove_li_request()
Date: Fri, 20 May 2011 13:20:42 +0200
Message-ID: <1305890442-16361-4-git-send-email-lczerner@redhat.com>
References: <1305890442-16361-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934708Ab1ETLU7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 07:20:59 -0400
In-Reply-To: <1305890442-16361-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to take reference to the s_li_request after we take a mutex,
because it might be freed since then, hence result in accessing old
already freed memory. Also we should protect the whole
ext4_remove_li_request() because ext4_li_info might be in the process of
being freed in ext4_lazyinit_thread().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
[v2]: Add reviewed by Eric Sandeen
 fs/ext4/super.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 72df905..f4d3333 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2720,14 +2720,16 @@ static void ext4_remove_li_request(struct ext4_li_request *elr)
 
 static void ext4_unregister_li_request(struct super_block *sb)
 {
-	struct ext4_li_request *elr = EXT4_SB(sb)->s_li_request;
