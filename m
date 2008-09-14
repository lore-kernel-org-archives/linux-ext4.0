From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] resize2fs : Fix potential memory corruption in ext2fs_progress_init()
Date: Sun, 14 Sep 2008 20:02:12 +0530
Message-ID: <ea11fea30809140732i38680994na7d686835e2949cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:8749 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYINOcO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2008 10:32:14 -0400
Received: by ti-out-0910.google.com with SMTP id b6so912737tic.23
        for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 07:32:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since "prog" is not initialized with 0 , below check in
ext2fs_progress_init() is wrong and may lead to corruptions.


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

---
 resize/sim_progress.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/resize/sim_progress.c b/resize/sim_progress.c
index a575633..e7dba88 100644
--- a/resize/sim_progress.c
+++ b/resize/sim_progress.c
@@ -83,7 +83,7 @@ errcode_t ext2fs_progress_init(ext2_sim_progmeter *ret_prog,
        errcode_t               retval;

        retval = ext2fs_get_mem(sizeof(struct ext2_sim_progress), &prog);
-       if (!prog)
+       if (retval)
                return retval;
        memset(prog, 0, sizeof(struct ext2_sim_progress));

-- 
1.5.4.3


Thanks -
Manish
