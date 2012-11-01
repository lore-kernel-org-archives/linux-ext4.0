From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix awful goto: in ext4_mb_new_blocks()
Date: Thu, 01 Nov 2012 18:54:40 -0500
Message-ID: <50930BC0.6040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2KAXyl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2012 19:54:41 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA1NsfYS009770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2012 19:54:41 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qA1NseUt021744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Nov 2012 19:54:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think the whole function could be made prettier, but
that goto really took the cake for too-clever-by-half.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

NB: this is just by inspection; it compiles but TBH
I have not tested the actual error case handling, so
it could probably use more careful eyeballing.
I *think* this is equivalent.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 526e553..27f421c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4310,8 +4310,10 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 repeat:
 		/* allocate space in core */
 		*errp = ext4_mb_regular_allocator(ac);
-		if (*errp)
+		if (*errp) {
+			ext4_discard_allocated_blocks(ac);
 			goto errout;
+		}
 
 		/* as we've just preallocated more space than
 		 * user requested orinally, we store allocated
@@ -4333,10 +4335,10 @@ repeat:
 			ac->ac_b_ex.fe_len = 0;
 			ac->ac_status = AC_STATUS_CONTINUE;
 			goto repeat;
-		} else if (*errp)
-		errout:
+		} else if (*errp) {
 			ext4_discard_allocated_blocks(ac);
-		else {
+			goto errout;
+		} else {
 			block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
 			ar->len = ac->ac_b_ex.fe_len;
 		}
@@ -4347,6 +4349,7 @@ repeat:
 		*errp = -ENOSPC;
 	}
 
+errout:
 	if (*errp) {
 		ac->ac_b_ex.fe_len = 0;
 		ar->len = 0;

