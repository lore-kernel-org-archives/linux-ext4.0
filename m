From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] ext2/super: Fix a possible sleep-in-atomic bug in parse_options
Date: Sat,  7 Oct 2017 09:20:46 +0800
Message-ID: <1507339246-13067-1-git-send-email-baijiaju1990@163.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
To: viro@zeniv.linux.org.uk, jack@suse.com, sagi@grimberg.me,
        james.smart@broadcom.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The kernel may sleep under a spinlock, and the function call path is:
ext2_remount
  parse_options
    match_int
      match_number (lib/parser.c)
        kmalloc(GFP_KERNEL) --> may sleep

To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.
This bug is found by my static analysis tool and my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 lib/parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/parser.c b/lib/parser.c
index 3278958..bc6e2ce 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -133,7 +133,7 @@ static int match_number(substring_t *s, int *result, int base)
 	long val;
 	size_t len = s->to - s->from;
 
-	buf = kmalloc(len + 1, GFP_KERNEL);
+	buf = kmalloc(len + 1, GFP_ATOMIC);
 	if (!buf)
 		return -ENOMEM;
 	memcpy(buf, s->from, len);
-- 
1.7.9.5
