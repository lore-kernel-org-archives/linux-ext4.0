From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] mke2fs.8.in: clarify the sign of a block-size constraint.
Date: Thu, 29 Jul 2010 11:59:42 -0500
Message-ID: <4C51B37E.4020404@redhat.com>
References: <20100724220124.GO4032@pooh.frostnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Frost <chris@frostnet.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab0G2Q7w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jul 2010 12:59:52 -0400
In-Reply-To: <20100724220124.GO4032@pooh.frostnet.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This bit of the mke2fs manpage is slightly confusing:

-b block-size
    Specify the size of blocks in bytes. <snip>
    If block-size is negative, then mke2fs will use heuristics 
    to determine the appropriate block size, with the constraint 
    that the block size will be at least block-size bytes.

because it sounds like the block size will be at least a negative
number.  Clarify just what the negative sign means.

Reported-by: Chris Frost <chris@frostnet.net>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 45a99f8..b46e7e2 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -173,7 +173,7 @@ the expected usage of the filesystem (see the
 .B \-T
 option).  If
 .I block-size
-is negative, then
+is preceded by a negative sign ('-'), then
 .B mke2fs
 will use heuristics to determine the
 appropriate block size, with the constraint that the block size will be


