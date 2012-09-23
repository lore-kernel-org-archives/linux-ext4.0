From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/6] xfstest: add configurable load factors
Date: Sun, 23 Sep 2012 23:24:32 +0400
Message-ID: <1348428276-13161-2-git-send-email-dmonakhov@openvz.org>
References: <a>
 <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com, hch@lst.de, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54528 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2IWTYn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Sep 2012 15:24:43 -0400
In-Reply-To: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Most stress test has probable behaviour, the longer test run the
larger corner cases will be cover. It is reasonable to allow
user to provide some sort of system load factor.
This patch introduce two global variables
LOAD_FACTOR: Usually means factor number of running tasks
TIME_FACTOR: Usually means factor of run time, or number of operations
If not speficied both variables defined to 1, so original behaviour
preserved.

TODO: Change all stress tests to use this variables

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common.config |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/common.config b/common.config
index 25cddb4..a24b915 100644
--- a/common.config
+++ b/common.config
@@ -255,5 +255,13 @@ if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
     exit 1
 fi
 
+if [ -z "$LOAD_FACTOR" ]; then
+    LOAD_FACTOR=1
+fi
+
+if [ -z "$TIME_FACTOR" ]; then
+    TIME_FACTOR=1
+fi
+
 # make sure this script returns success
 /bin/true
-- 
1.7.7.6

