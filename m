From: Drew Davenport <ddavenport@google.com>
Subject: [PATCH] e2fsprogs: Make -U option consistent between tune2fs and
 mke2fs
Date: Thu, 13 Apr 2017 12:47:02 -0700
Message-ID: <20170413194702.GA41849@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34116 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdDMTrZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Apr 2017 15:47:25 -0400
Received: by mail-pf0-f171.google.com with SMTP id c198so32768662pfc.1
        for <linux-ext4@vger.kernel.org>; Thu, 13 Apr 2017 12:47:25 -0700 (PDT)
Received: from google.com ([2620:0:1000:1301:4dba:d534:8e36:9af8])
        by smtp.gmail.com with ESMTPSA id 140sm43942753pfa.58.2017.04.13.12.47.23
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 13 Apr 2017 12:47:23 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow "null", "clear", "random", or "time" for the -U option for
mke2fs, which are already allowed options for tune2fs.

Signed-off-by: Drew Davenport <ddavenport@google.com>
---
 misc/mke2fs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 49c6e94d..b8d078a0 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2914,7 +2914,14 @@ int main (int argc, char *argv[])
 	 * Parse or generate a UUID for the filesystem
 	 */
 	if (fs_uuid) {
-		if (uuid_parse(fs_uuid, fs->super->s_uuid) !=0) {
+		if ((strcasecmp(fs_uuid, "null") == 0) ||
+		    (strcasecmp(fs_uuid, "clear") == 0)) {
+			uuid_clear(fs->super->s_uuid);
+		} else if (strcasecmp(fs_uuid, "time") == 0) {
+			uuid_generate_time(fs->super->s_uuid);
+		} else if (strcasecmp(fs_uuid, "random") == 0) {
+			uuid_generate(fs->super->s_uuid);
+		} else if (uuid_parse(fs_uuid, fs->super->s_uuid) != 0) {
 			com_err(device_name, 0, "could not parse UUID: %s\n",
 				fs_uuid);
 			exit(1);
-- 
2.12.2.762.g0e3151a226-goog
