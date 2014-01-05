From: jon ernst <jonernst07@gmail.com>
Subject: [PATCH 1/1] handle e2image offset value better
Date: Sun, 5 Jan 2014 04:42:42 +0000
Message-ID: <CAGW2f1ES7Gji4hXEeMzCSdH3VabXU7SeD-4cg4GL6K9ArugwHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: jon ernst <jonernst07@gmail.com>
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62503 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaAEEmn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Jan 2014 23:42:43 -0500
Received: by mail-qa0-f53.google.com with SMTP id j5so1857116qaq.5
        for <linux-ext4@vger.kernel.org>; Sat, 04 Jan 2014 20:42:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

current e2image cannot handle offset value as 0.

For example,
e2image -aro   0 /dev/sda7 ~/e2image7
will return usage()
but
e2image -aro   1 /dev/sda7 ~/e2image7
is fine.


Signed-off-by: "Jon Ernst" <jonernst07@gmail.com>
---
 misc/e2image.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 74515c8..af97d7a 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1485,9 +1485,11 @@ int main (int argc, char ** argv)
             break;
         case 'o':
             source_offset = strtoull(optarg, NULL, 0);
+            move_mode = 1;
             break;
         case 'O':
             dest_offset = strtoull(optarg, NULL, 0);
+            move_mode = 1;
             break;
         case 'p':
             show_progress = 1;
@@ -1498,10 +1500,7 @@ int main (int argc, char ** argv)
         default:
             usage();
         }
-    if (optind == argc - 1 &&
-        (source_offset || dest_offset))
-            move_mode = 1;
-    else if (optind != argc - 2 )
+    if ((optind != argc - 2 ) && (move_mode))
         usage();

     if (all_data && !img_type) {
-- 
1.8.3.2
