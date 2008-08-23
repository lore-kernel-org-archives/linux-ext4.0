From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] ext2ed : Remove masix support.
Date: Sat, 23 Aug 2008 16:47:41 +0530
Message-ID: <ea11fea30808230417y2e08c121m5580da055c02b31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:34811 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYHWLRn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 07:17:43 -0400
Received: by ti-out-0910.google.com with SMTP id b6so503273tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 23 Aug 2008 04:17:42 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,
I was not sure if I should change it to EXT2_OBSO_OS_MASIX as it is
currently defined in ext2_fs.h. Let me know if you think
that is the correct way to fix it, will redo the patch.

Compilation of ext2ed fails with below error message since masix
support has been removed from lib/ext2fs.
super_com.c: In function 'type_ext2_super_block___show':
super_com.c:104: error: 'EXT2_OS_MASIX' undeclared (first use in this function)
super_com.c:104: error: (Each undeclared identifier is reported only once
super_com.c:104: error: for each function it appears in.)
make: *** [super_com.o] Error 1

Below patch removes support for masix from ext2ed.

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 ext2ed/super_com.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/ext2ed/super_com.c b/ext2ed/super_com.c
index 0541ff3..ec48351 100644
--- a/ext2ed/super_com.c
+++ b/ext2ed/super_com.c
@@ -101,10 +101,6 @@ void type_ext2_super_block___show (char *command_line)
                        wprintw (show_pad,"Hurd");
 			break;

-		case EXT2_OS_MASIX:
-			wprintw (show_pad,"Masix");
-			break;
