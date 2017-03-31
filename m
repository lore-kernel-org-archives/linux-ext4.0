From: Justin Bronder <jsbronder@cold-front.org>
Subject: [PATCH] Fix metadata_csum typo in ext4 man page
Date: Fri, 31 Mar 2017 10:24:39 -0400
Message-ID: <20170331142439.25698-1-jsbronder@cold-front.org>
Cc: Justin Bronder <jsbronder@cold-front.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37313 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755318AbdCaOYw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 31 Mar 2017 10:24:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Justin Bronder <jsbronder@cold-front.org>
---
 misc/ext4.5.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index d7bd863..c1e67ab 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -693,7 +693,7 @@ ext4, 3.6
 ext4, 3.8
 .IP "\fBsparse_super2\fR" 2in
 ext4, 3.16
-.IP "\fBmetdata_csum\fR" 2in
+.IP "\fBmetadata_csum\fR" 2in
 ext4, 3.18
 .IP "\fBencrypt\fR" 2in
 ext4, 4.1
-- 
2.10.2
