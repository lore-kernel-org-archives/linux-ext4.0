From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 5/6 linux-next] ext4: remove unused definition
Date: Wed, 24 Aug 2016 22:03:19 +0200
Message-ID: <1472069000-18897-6-git-send-email-fabf@skynet.be>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

MAX_32_NUM isn't used in ext4

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 10686fd..5a708c87 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -19,8 +19,6 @@
 #include "ext4_jbd2.h"
 #include "ext4.h"
 
-#define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
-
 /**
  * Swap memory between @a and @b for @len bytes.
  *
-- 
2.8.1
