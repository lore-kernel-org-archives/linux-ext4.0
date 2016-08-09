From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] fsck: fix strange logic
Date: Tue,  9 Aug 2016 14:12:56 -0600
Message-ID: <1470773576-18604-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:60773 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbcHIUNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Aug 2016 16:13:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

llvm warns about the confusingly written comparison:

                              !strncmp(argv[i+1], "-", 1) == 0) {
    misc/fsck.c:1178 col 9: warning: logical not is only applied to
      the left hand side of comparison [-Wlogical-not-parentheses]
    misc/fsck.c:1178 col 9: note: add parentheses after the '!' to
      evaluate the comparison first
    misc/fsck.c:1178 col 9: note: add parentheses around left hand
      side expression to silence this warning

It makes sense to simplify this to a character comparison
rather than using strncmp() to check only one character.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 misc/fsck.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/fsck.c b/misc/fsck.c
index 826aaeb..4f918b7 100644
--- a/misc/fsck.c
+++ b/misc/fsck.c
@@ -1174,8 +1174,8 @@ static void PRS(int argc, char *argv[])
 						progress_fd = 0;
 					else
 						goto next_arg;
-				} else if ((i+1) < argc &&
-					   !strncmp(argv[i+1], "-", 1) == 0) {
+				} else if (argc > i + 1 &&
+					   argv[i + 1][0] == '-') {
 					progress_fd = string_to_int(argv[i]);
 					if (progress_fd < 0)
 						progress_fd = 0;
-- 
2.4.5

