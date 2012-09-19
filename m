From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ioengine: allow several external ioengines
Date: Wed, 19 Sep 2012 23:22:54 +0400
Message-ID: <1348082576-10528-3-git-send-email-dmonakhov@openvz.org>
References: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, fio@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61269 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2ISTXE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2012 15:23:04 -0400
In-Reply-To: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently only one external ioengine can be exported because
it use hardcoded 'ioengine' symbol, but if we allow external
modules to have ops symbol similar to it's name then several
extrnal engines become possible.

NOTE: Old linking layout preserved

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ioengines.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index b43374e..c2a64cb 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -104,7 +104,9 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	 * Unlike the included modules, external engines should have a
 	 * non-static ioengine structure that we can reference.
 	 */
-	ops = dlsym(dlhandle, "ioengine");
+	ops = dlsym(dlhandle, engine_lib);
+	if (!ops)
+		ops = dlsym(dlhandle, "ioengine");
 	if (!ops) {
 		td_vmsg(td, -1, dlerror(), "dlsym");
 		dlclose(dlhandle);
-- 
1.7.7.6

