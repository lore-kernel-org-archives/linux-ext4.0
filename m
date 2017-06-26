From: Marc Thomas <marc@dragonfly.plus.com>
Subject: [PATCH 1/2] filefrag: fix GCC7.x compiler warning
Date: Mon, 26 Jun 2017 16:39:47 +0100
Message-ID: <856ed7be-9cb4-eb8d-1ce5-3f07adf600b6@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:38113 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdFZPju (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 11:39:50 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by anvil.lan (8.15.2/8.15.2) with ESMTP id v5QFdl6t003862
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 16:39:47 +0100
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

../../misc/filefrag.c:591:33: warning: comparison between pointer and
zero character constant [-Wpointer-compare]
  for (cpp = argv + optind; *cpp != '\0'; cpp++) {

Signed-off-by: Marc Thomas <marc@dragonfly.plus.com>
---
 misc/filefrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 1a185124..9c57ab93 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -588,7 +588,7 @@ int main(int argc, char**argv)
 	if (optind == argc)
 		usage(argv[0]);
 -	for (cpp = argv + optind; *cpp != '\0'; cpp++) {
+	for (cpp = argv + optind; *cpp != NULL; cpp++) {
 		int rc2 = frag_report(*cpp);
  		if (rc2 < 0 && rc == 0)
-- 
2.13.0
