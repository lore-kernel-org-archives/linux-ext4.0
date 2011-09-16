From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/25] fsck: fix -C option parsing
Date: Fri, 16 Sep 2011 15:49:18 -0500
Message-ID: <1316206180-6375-4-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46726 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab1IPUto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:44 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The i++; statement is unreachable; fix same as commit
f1c2eaac535bd9172a35ce39b6d8f392321f274d in util-linux

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/fsck.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/fsck.c b/misc/fsck.c
index fe9426e..9345233 100644
--- a/misc/fsck.c
+++ b/misc/fsck.c
@@ -1179,8 +1179,8 @@ static void PRS(int argc, char *argv[])
 					if (progress_fd < 0)
 						progress_fd = 0;
 					else {
+						++i;
 						goto next_arg;
-						i++;
 					}
 				}
 				break;
-- 
1.7.4.1

