From: Coly Li <coyli@suse.de>
Subject: [PATCH][e2fsprogs] add -E option to mke2fs usage information
Date: Mon, 15 Oct 2007 22:19:11 +0800
Message-ID: <471376DF.5010705@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46665 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXJOOQv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 10:16:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-E option is missed from usage information of mke2fs. This patch adds -E option to usage
information, and names -E|-R as extended-option.
Now the usage information can be consistent with mke2fs.8.in.

Signed-off-by: Coly Li <coyli@suse.de>
---
 misc/mke2fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..128aa43 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -100,7 +100,7 @@ static void usage(void)
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
-	"[-r fs-revision] [-R options] [-qvSV]\n\tdevice [blocks-count]\n"),
+	"[-r fs-revision] [-E|-R extended-option[,...]] [-qvSV]\n\tdevice [blocks-count]\n"),
 		program_name);
 	exit(1);
 }

-- 
Coly Li
SuSE PRC Labs
