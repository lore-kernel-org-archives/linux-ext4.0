From: Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [PATCH 2/2] ext4: acl: remove unneeded include of linux/capability.h
Date: Mon, 24 Mar 2014 08:22:12 +0100
Message-ID: <1395645732-26569-1-git-send-email-jsitnicki@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

acl.c has not been (directly) using the interface defined by
linux/capability.h header since commit 3bd858ab1c451725c07a
("Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid
check"). Remove it.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 fs/ext4/acl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index d40c8db..26e880e 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -7,7 +7,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/capability.h>
 #include <linux/fs.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
-- 
1.8.5.3
