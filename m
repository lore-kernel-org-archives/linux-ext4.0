From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer
Date: Tue, 07 Feb 2012 16:07:20 -0600
Message-ID: <4F31A098.4050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab2BGXHs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Feb 2012 18:07:48 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q17N7dj0027622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 7 Feb 2012 18:07:48 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q17M7Kgt001990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 7 Feb 2012 17:07:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

journal_unmap_buffer()'s zap_buffer: code clears a lot of buffer head
state ala discard_buffer(), but does not touch _Delay or _Unwritten
as discard_buffer() does.

This can be problematic in some areas of the ext4 code which assume
that if they have found a buffer marked unwritten or delay, then it's
a live one.  Perhaps those spots should check whether it is mapped
as well, but if jbd2 is going to tear down a buffer, let's really
tear it down completely.

Without this I get some fsx failures on sub-page-block filesystems
up until v3.2, at which point 4e96b2dbbf1d7e81f22047a50f862555a6cb87cb
and 189e868fa8fdca702eb9db9d8afc46b5cb9144c9 make the failures go
away, because buried within that large change is some more flag
clearing.  I still think it's worth doing in jbd2, since
->invalidatepage leads here directly, and it's the right place
to clear away these flags.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: stable@vger.kernel.org
---

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 35ae096..52653306 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1949,6 +1949,8 @@ zap_buffer_unlocked:
 	clear_buffer_mapped(bh);
 	clear_buffer_req(bh);
 	clear_buffer_new(bh);
+	clear_buffer_delay(bh);
+	clear_buffer_unwritten(bh);
 	bh->b_bdev = NULL;
 	return may_free;
 }


