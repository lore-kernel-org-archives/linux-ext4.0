From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Fwd: [PATCH] resize2fs : Fix potential memory corruption in ext2fs_progress_init()
Date: Tue, 16 Sep 2008 12:52:55 +0530
Message-ID: <ea11fea30809160022i6ba31209p7e1e7c31c166c4a4@mail.gmail.com>
References: <ea11fea30809140732i38680994na7d686835e2949cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:52693 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYIPHW6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Sep 2008 03:22:58 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1385022tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 16 Sep 2008 00:22:56 -0700 (PDT)
In-Reply-To: <ea11fea30809140732i38680994na7d686835e2949cd@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---------- Forwarded message ----------
From: Manish Katiyar <mkatiyar@gmail.com>
Date: Sun, Sep 14, 2008 at 8:02 PM
Subject: [PATCH] resize2fs : Fix potential memory corruption in
ext2fs_progress_init()
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Cc: mkatiyar@gmail.com


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


Any ack/nack on this one ?? I also saw some utilities
(debugfs,resizefs) usage don't print the options specified in man
pages. Is it intentional ? Are they hidden options for developers ?

Thanks -
Manish


Thanks -
Manish
