From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 6/6] ext4: remove unused #include <linux/version.h>
Date: Sun, 13 Dec 2009 22:06:38 +0800
Message-ID: <1260713198-1652-1-git-send-email-weiyi.huang@gmail.com>
Cc: linux-ext4@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38688 "HELO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753462AbZLMOGz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Dec 2009 09:06:55 -0500
Received: by pwj9 with SMTP id 9so1447536pwj.21
        for <linux-ext4@vger.kernel.org>; Sun, 13 Dec 2009 06:06:55 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  fs/ext4/block_validity.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 fs/ext4/block_validity.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 4df8621..a60ab9a 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/pagemap.h>
-#include <linux/version.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include "ext4.h"
-- 
1.6.1.3

