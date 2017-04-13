From: Drew Davenport <ddavenport@google.com>
Subject: [PATCH v2] e2fsprogs: Make -U option consistent between tune2fs and
 mke2fs
Date: Thu, 13 Apr 2017 16:56:28 -0700
Message-ID: <20170413235628.GA133121@google.com>
References: <3501FCFF-B686-47DF-B530-802CB3A79FAB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:35818 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752635AbdDMX45 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Apr 2017 19:56:57 -0400
Received: by mail-pg0-f46.google.com with SMTP id 72so28654593pge.2
        for <linux-ext4@vger.kernel.org>; Thu, 13 Apr 2017 16:56:57 -0700 (PDT)
Received: from google.com ([2620:0:1000:1301:4dba:d534:8e36:9af8])
        by smtp.gmail.com with ESMTPSA id f6sm209266pfe.57.2017.04.13.16.56.55
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 13 Apr 2017 16:56:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <3501FCFF-B686-47DF-B530-802CB3A79FAB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow "null", "clear", "random", or "time" for the -U option for
mke2fs, which are already allowed options for tune2fs.

Signed-off-by: Drew Davenport <ddavenport@google.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/mke2fs.8.in | 20 +++++++++++++++++++-
 misc/mke2fs.c    |  9 ++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index ef56d9ea..1c8c20f2 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -738,7 +738,25 @@ will use the default filesystem type
 .IR default .
 .TP
 .BI \-U " UUID"
-Create the filesystem with the specified UUID.
+Set the universally unique identifier (UUID) of the filesystem to
+.IR UUID .
+The format of the UUID is a series of hex digits separated by hyphens, 
+like this: 
+"c1b9d5a2-f162-11cf-9ece-0020afc76f16".  
+The 
+.I UUID
+parameter may also be one of the following:
+.RS 1.2i
+.TP
+.I clear
+clear the filesystem UUID
+.TP
+.I random
+generate a new randomly-generated UUID
+.TP
+.I time
+generate a new time-based UUID
+.RE
 .TP
 .B \-v
 Verbose execution.
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
