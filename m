From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 17/25] mke2fs: Do not let -t or -T be specified more than once
Date: Fri, 16 Sep 2011 15:49:32 -0500
Message-ID: <1316206180-6375-18-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46735 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In addition to not making since, it causes a memory leak
when fs_type gets overwritten.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/mke2fs.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 437b495..e30c070 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1445,9 +1445,19 @@ profile_error:
 			super_only = 1;
 			break;
 		case 't':
+			if (fs_type) {
+				com_err(program_name, 0, 
+					_("The -t option may only be used once"));
+				exit(1);
+			}
 			fs_type = strdup(optarg);
 			break;
 		case 'T':
+			if (usage_types) {
+				com_err(program_name, 0, 
+					_("The -T option may only be used once"));
+				exit(1);
+			}
 			usage_types = strdup(optarg);
 			break;
 		case 'U':
-- 
1.7.4.1

