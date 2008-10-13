From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] ext4 : Fix Kconfig typo for ext4dev
Date: Mon, 13 Oct 2008 18:30:57 +0530
Message-ID: <ea11fea30810130600w1883334ag8af2fd424906799@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Tso" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:61485 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbYJMNA7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 09:00:59 -0400
Received: by ti-out-0910.google.com with SMTP id b6so903727tic.23
        for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 06:00:57 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Looks like there is one more instance where ext4dev should be changed
to ext4 because the module name will be "ext4" unless EXT4DEV_COMPAT
is selected.


Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
---
 fs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index f54a157..b013642 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -160,7 +160,7 @@ config EXT4_FS
 	  filesystem initially.

 	  To compile this file system support as a module, choose M here. The
-	  module will be called ext4dev.
+	  module will be called ext4.

 	  If unsure, say N.

-- 
1.5.4.3

Thanks -
Manish
