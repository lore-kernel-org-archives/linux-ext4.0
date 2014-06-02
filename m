From: Benno Schulenberg <bensberg@justemail.net>
Subject: [PATCH 4/4] e2fsck: sort the abbreviations better
Date: Mon,  2 Jun 2014 21:48:44 +0200
Message-ID: <1401738524-11455-4-git-send-email-bensberg@justemail.net>
References: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:56760 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbaFBTx5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2014 15:53:57 -0400
In-Reply-To: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This makes it easier for translators to look up what they've done.

Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
---
 e2fsck/message.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 6c1d0bf..9c1433f 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -116,17 +116,17 @@ static const char *abbrevs[] = {
 	N_("Bbitmap"),
 	N_("ccompress"),
 	N_("Cconflicts with some other fs @b"),
-	N_("iinode"),
-	N_("Iillegal"),
-	N_("jjournal"),
-	N_("Ddeleted"),
 	N_("ddirectory"),
+	N_("Ddeleted"),
 	N_("eentry"),
 	N_("E@e '%Dn' in %p (%i)"),
 	N_("ffilesystem"),
 	N_("Ffor @i %i (%Q) is"),
 	N_("ggroup"),
 	N_("hHTREE @d @i"),
+	N_("iinode"),
+	N_("Iillegal"),
+	N_("jjournal"),
 	N_("llost+found"),
 	N_("Lis a link"),
 	N_("mmultiply-claimed"),
-- 
1.7.0.4

