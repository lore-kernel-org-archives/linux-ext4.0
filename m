From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH] Remove VLAIS usage from JBD2 code
Date: Tue, 30 Oct 2012 14:40:04 -0400
Message-ID: <1351622404-18214-2-git-send-email-behanw@converseincode.com>
References: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
Cc: linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:41992 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab2J3Sju (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2012 14:39:50 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so410648iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 11:39:49 -0700 (PDT)
In-Reply-To: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mark Charlebois <charlebm@gmail.com>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). Since ctx is always a 32-bit CRC, hard coding a size of 4
bytes accomplishes the same thing without the use of VLAIS. This is the same
technique already employed in fs/ext4/ext4.h

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/linux/jbd2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3efc43f..efcbdfc 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1308,7 +1308,7 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(journal->j_chksum_driver)];
+		char ctx[4];
 	} desc;
 	int err;
 
-- 
1.7.9.5

