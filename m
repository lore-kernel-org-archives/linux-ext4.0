From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix a couple implicit function declarations
Date: Sat, 29 Mar 2008 23:01:52 -0500
Message-ID: <47EF10B0.2070804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYC3ECF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2008 00:02:05 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2U41seT015911
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2008 00:01:54 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2U41rqp028242
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2008 00:01:53 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2U41qd9014497
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2008 00:01:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fedora seems to be gearing up to add 
-Werror-implicit-function-declaration
to the standard build flags, so I thought I'd get out ahead 
of this one...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 e2fsck/unix.c       |    1 +
 lib/ext2fs/bitops.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7b662e4..cadd025 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -47,6 +47,7 @@ extern int optind;
 #endif
 
 #include "et/com_err.h"
+#include "e2p/e2p.h"
 #include "e2fsck.h"
 #include "problem.h"
 #include "../version.h"
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index d83ce8e..00bc4ab 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -332,6 +332,7 @@ _INLINE_ __u32 ext2fs_swab32(__u32 val)
 #endif /* !_EXT2_HAVE_ASM_SWAB */
 
 #if !defined(_EXT2_HAVE_ASM_FINDBIT_)
+#include <strings.h>
 _INLINE_ int ext2fs_find_first_bit_set(void * addr, unsigned size)
 {
 	char	*cp = (char *) addr;
-- 1.5.4.1

