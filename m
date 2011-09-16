From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 20/25] test_icount: fclose() before exit
Date: Fri, 16 Sep 2011 15:49:35 -0500
Message-ID: <1316206180-6375-21-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46757 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just to be tidy.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 tests/progs/test_icount.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tests/progs/test_icount.c b/tests/progs/test_icount.c
index 777a812..017cc4d 100644
--- a/tests/progs/test_icount.c
+++ b/tests/progs/test_icount.c
@@ -289,6 +289,8 @@ static int source_file(const char *cmd_file, int sci_idx)
 			exit_status++;
 		}
 	}
+	if (f != stdin)
+		fclose(f);
 	return exit_status;
 }
 
-- 
1.7.4.1

