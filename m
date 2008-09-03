From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] debugfs : Fix memory leaks in do_ncheck()
Date: Wed, 3 Sep 2008 11:23:53 +0530
Message-ID: <ea11fea30809022253x6b8a493bkf7c92032c1cf479c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:31834 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYICFxz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Sep 2008 01:53:55 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1569347tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 02 Sep 2008 22:53:53 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Below patch fixes memory leaks in do_ncheck(). Also use this
opportunity to fix the progname printed as "ncheck" instead of
"do_ncheck" since all other messages
in this file do so.


Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 debugfs/ncheck.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 3381dd9..22529c4 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -76,7 +76,7 @@ void do_ncheck(int argc, char **argv)

 	iw.iarray = malloc(sizeof(struct inode_info) * argc);
 	if (!iw.iarray) {
-		com_err("do_ncheck", ENOMEM,
+		com_err("ncheck", ENOMEM,
 			"while allocating inode info array");
 		return;
 	}
@@ -86,7 +86,7 @@ void do_ncheck(int argc, char **argv)
 		iw.iarray[i-1].ino = strtol(argv[i], &tmp, 0);
 		if (*tmp) {
 			com_err(argv[0], 0, "Bad inode - %s", argv[i]);
-			return;
+			goto error_out;
 		}
 	}

-- 
1.5.4.3


Thanks -
Manish
