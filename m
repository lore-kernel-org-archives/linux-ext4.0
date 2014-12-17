From: =?UTF-8?B?8J+RviBXYWRl?= <wadetregaskis@google.com>
Subject: Patch adding e2p_feature_to_string
Date: Wed, 17 Dec 2014 11:27:09 -0800
Message-ID: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42428 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaLQT1K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2014 14:27:10 -0500
Received: by mail-vc0-f178.google.com with SMTP id hq11so7521904vcb.9
        for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 11:27:09 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is needed to provide a version of e2p_feature2string that doesn't
use (and return a pointer to) an internal, static buffer.

diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 5fa41f4..53f0183 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -45,6 +45,8 @@ void print_fs_state (FILE * f, unsigned short state);
 int setflags (int fd, unsigned long flags);
 int setversion (int fd, unsigned long version);

+void e2p_feature_to_string(int compat, unsigned int mask, char *buf,
+                          size_t buf_len);
 const char *e2p_feature2string(int compat, unsigned int mask);
 const char *e2p_jrnl_feature2string(int compat, unsigned int mask);
 int e2p_string2feature(char *string, int *compat, unsigned int *mask);
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 6e53cfe..6dca315 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -117,17 +117,20 @@ static struct feature jrnl_feature_list[] = {
        {       0, 0, 0 },
 };

-const char *e2p_feature2string(int compat, unsigned int mask)
+void e2p_feature_to_string(int compat, unsigned int mask, char *buf,
+                           size_t buf_len)
 {
        struct feature  *f;
-       static char buf[20];
        char    fchar;
        int     fnum;

        for (f = feature_list; f->string; f++) {
                if ((compat == f->compat) &&
-                   (mask == f->mask))
-                       return f->string;
+                   (mask == f->mask)) {
+                       strncpy(buf, f->string, buf_len);
+                       buf[buf_len - 1] = 0;
+                       return;
+                }
        }
        switch (compat) {
        case  E2P_FEATURE_COMPAT:
@@ -144,7 +147,13 @@ const char *e2p_feature2string(int compat,
unsigned int mask)
                break;
        }
        for (fnum = 0; mask >>= 1; fnum++);
-       sprintf(buf, "FEATURE_%c%d", fchar, fnum);
+       snprintf(buf, buf_len, "FEATURE_%c%d", fchar, fnum);
+}
+
+const char *e2p_feature2string(int compat, unsigned int mask)
+{
+       static char buf[20];
+       e2p_feature_to_string(compat, mask, buf, sizeof(buf) / sizeof(buf[0]));
        return buf;
 }
