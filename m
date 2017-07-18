From: Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH v2 1/2] e2p: Fix segfault in e2p_os2string.
Date: Tue, 18 Jul 2017 14:48:22 -0700
Message-ID: <20170718214823.22649-2-abuchbinder@google.com>
References: <20170718192919.32406-1-abuchbinder@google.com>
 <20170718214823.22649-1-abuchbinder@google.com>
Cc: Adam Buchbinder <abuchbinder@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34209 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753180AbdGRVse (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 17:48:34 -0400
Received: by mail-pf0-f173.google.com with SMTP id q85so17406197pfq.1
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 14:48:34 -0700 (PDT)
In-Reply-To: <20170718214823.22649-1-abuchbinder@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Passing in a negative integer would lead to a segfault, and
a crafted filesystem image could trigger that.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 lib/e2p/ostype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/e2p/ostype.c b/lib/e2p/ostype.c
index 7f088446..c5fd8ab3 100644
--- a/lib/e2p/ostype.c
+++ b/lib/e2p/ostype.c
@@ -30,7 +30,7 @@ char *e2p_os2string(int os_type)
         const char	*os;
 	char 		*ret;
 
-	if (os_type <= EXT2_OS_LITES)
+	if (os_type >= 0 && os_type <= EXT2_OS_LITES)
 		os = os_tab[os_type];
 	else
 		os = "(unknown os)";
-- 
2.14.0.rc0.284.gd933b75aa4-goog
