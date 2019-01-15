Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20369 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbfAONmH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 15 Jan 2019 08:42:07 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0FB24A6DE0
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 13:42:07 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.205.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 753BC608FA
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 13:42:06 +0000 (UTC)
From: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Subject: [PATCH 2/2] e2fsprogs: fix potential memory leak in path_append()
Date: Tue, 15 Jan 2019 14:42:03 +0100
Message-Id: <20190115134203.11448-2-lczerner@redhat.com>
In-Reply-To: <20190115134203.11448-1-lczerner@redhat.com>
References: <20190115134203.11448-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If realloc() fails in path_append() we will lose a memory pointed to by
target->path. Fix it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/create_inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 05aa6363..cedbba52 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -704,10 +704,12 @@ struct file_info {
 static errcode_t path_append(struct file_info *target, const char *file)
 {
 	if (strlen(file) + target->path_len + 1 > target->path_max_len) {
+		void *p;
 		target->path_max_len *= 2;
-		target->path = realloc(target->path, target->path_max_len);
-		if (!target->path)
+		p = realloc(target->path, target->path_max_len);
+		if (p == NULL)
 			return EXT2_ET_NO_MEMORY;
+		target->path = p;
 	}
 	target->path_len += sprintf(target->path + target->path_len, "/%s",
 				    file);
-- 
2.20.1
