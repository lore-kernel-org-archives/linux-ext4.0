From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH] ext4: remove static from struct match_token used in token2str
Date: Fri, 21 Sep 2012 22:21:00 -0300
Message-ID: <1348276860-21705-1-git-send-email-herton.krzesinski@canonical.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2IVBVH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 21:21:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no reason to use static there, and it will cause issues when
reading /proc/fs/ext4/<partition>/options concurrently.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: stable@vger.kernel.org # 3.4+
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

The problem is easy to reproduce, for example running:
$ cat /proc/fs/ext4/<partition>/options > options.txt
$ while diff /proc/fs/ext4/<partition>/options options.txt; do true; done
- And concurrently on another terminal:
$ while diff /proc/fs/ext4/<partition>/options options.txt; do true; done

One of the diff loops will get incomplete options contents because of
the issue, and exit.

I also believe the same problem is the cause of the following bug:
https://bugs.launchpad.net/bugs/1053019, that happened while running
test 234 from xfstests.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 41598ee..975405c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1748,7 +1748,7 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 
 static const char *token2str(int token)
 {
-	static const struct match_token *t;
+	const struct match_token *t;
 
 	for (t = tokens; t->token != Opt_err; t++)
 		if (t->token == token && !strchr(t->pattern, '='))
-- 
1.7.9.5

