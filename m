From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/25] mke2fs: remove impossible tests for null usage_types
Date: Fri, 16 Sep 2011 15:49:19 -0500
Message-ID: <1316206180-6375-5-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46728 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab1IPUto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:44 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

parse_fs_type explicitly sets usage_types if it is null,
so there is no need to test for null later.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/mke2fs.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index abcfbf0..437b495 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1029,15 +1029,12 @@ static char **parse_fs_type(const char *fs_type,
 	if (!usage_types)
 		usage_types = size_type;
 
-	parse_str = malloc(usage_types ? strlen(usage_types)+1 : 1);
+	parse_str = malloc(strlen(usage_types)+1);
 	if (!parse_str) {
 		free(list.list);
 		return 0;
 	}
-	if (usage_types)
-		strcpy(parse_str, usage_types);
-	else
-		*parse_str = '\0';
+	strcpy(parse_str, usage_types);
 
 	if (ext_type)
 		push_string(&list, ext_type);
-- 
1.7.4.1

