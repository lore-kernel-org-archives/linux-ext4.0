From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-e2fsprogs] remove bogus "-e" option from filefrag manpage
Date: Fri,  5 Jun 2009 18:13:28 +0800
Message-ID: <1244196808-9768-1-git-send-email-bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:55906 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZFEKNc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 06:13:32 -0400
Received: by pzk1 with SMTP id 1so760179pzk.33
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jun 2009 03:13:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

filefrag doesn't support "-e" option, so clean it up in the manpage.
---
 misc/filefrag.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/filefrag.8.in b/misc/filefrag.8.in
index ccaa4a6..681fe9a 100644
--- a/misc/filefrag.8.in
+++ b/misc/filefrag.8.in
@@ -5,7 +5,7 @@ filefrag \- report on file fragmentation
 .SH SYNOPSIS
 .B filefrag
 [
-.B \-besvx
+.B \-bsvx
 ]
 [
 .I files...
-- 
1.6.2.GIT

