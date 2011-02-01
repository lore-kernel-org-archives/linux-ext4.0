From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] mke2fs: Simple man page nodiscard option correction
Date: Tue,  1 Feb 2011 17:56:41 +0100
Message-ID: <1296579401-27203-1-git-send-email-lczerner@redhat.com>
Cc: tytso@MIT.EDU, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1BAQ4t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Feb 2011 11:56:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is not true that 'nodiscard' is set as default, so remove this
sentence. The default is 'discard' and it is properly documented in man
page.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 2eead17..4a3b0c3 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -247,7 +247,7 @@ zeroed. This significantly speeds up filesystem initialization. This is set
 as default.
 .TP
 .BI nodiscard
-Do not attempt to discard blocks at mkfs time. This is the default.
+Do not attempt to discard blocks at mkfs time.
 .RE
 .TP
 .BI \-f " fragment-size"
-- 
1.7.2.3

