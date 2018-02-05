From: Wang Long <wanglong19@meituan.com>
Subject: [PATCH] jbd2: remove duplicate `\n` in jbd_debug
Date: Mon,  5 Feb 2018 21:21:21 +0800
Message-ID: <1517836881-31775-1-git-send-email-wanglong19@meituan.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanglong19@meituan.com
To: tytso@mit.edu, jack@suse.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The current jbd_debug output as the following:

```
[180397.891399] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 718): JBD2: Submit 4 IOs

[180397.891417] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 821): JBD2: commit phase 3

[180397.899183] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 863): JBD2: commit phase 4

[180397.899189] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 886): JBD2: commit phase 5

[180397.900321] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 923): JBD2: commit phase 6

[180397.900327] fs/jbd2/commit.c: (jbd2_journal_commit_transaction, 1092): JBD2: commit phase 7
```

Every jbd_debug call in kernel will append `\n` in its
fmt argument, so remove duplicate `\n`

Signed-off-by: Wang Long <wanglong19@meituan.com>
---
 fs/jbd2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 3fbf48e..93016bb 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -114,7 +114,7 @@ void __jbd2_debug(int level, const char *file, const char *func,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
+	printk(KERN_DEBUG "%s: (%s, %u): %pV", file, func, line, &vaf);
 	va_end(args);
 }
 EXPORT_SYMBOL(__jbd2_debug);
-- 
1.8.3.1
