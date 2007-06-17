From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: [patch] e2fsprogs time value is interpreted as signed
Date: Sun, 17 Jun 2007 13:47:40 +0400
Message-ID: <20070617094740.GG14349@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:20099 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760081AbXFQJqx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jun 2007 05:46:53 -0400
Received: from sw.ru ([192.168.3.106])
	by relay.sw.ru (8.13.4/8.13.4) with SMTP id l5H9kpvo018320
	for <linux-ext4@vger.kernel.org>; Sun, 17 Jun 2007 13:46:51 +0400 (MSD)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

after bug: http://bugzilla.kernel.org/show_bug.cgi?id=5079
was fixed by:
commit 4d7bf11d649c72621ca31b8ea12b9c94af380e63
Author: Markus Rechberger <Markus.Rechberger@amd.com>
Date:   Tue May 8 00:23:39 2007 -0700
__u32 time value becomes interpreat as signed value. This patch add
coresponding fix to debug fs routine.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
---
 debugfs/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/debugfs/util.c b/debugfs/util.c
index c6096ab..53a0813 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -187,7 +187,7 @@ int check_fs_bitmaps(char *name)
 char *time_to_string(__u32 cl)
 {
 	static int	do_gmt = -1;
-	time_t		t = (time_t) cl;
+	time_t		t = (time_t)(signed) cl;
 	char *		tz;
 
 	if (do_gmt == -1) {
-- 
1.5.2
