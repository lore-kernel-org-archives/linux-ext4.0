From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/6] libext2: minor sparse endian checker fixup
Date: Thu, 23 Oct 2014 16:29:17 -0500
Message-ID: <5449732D.5010306@redhat.com>
References: <54497296.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaJWV3T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 17:29:19 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLTIrB013952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:29:19 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com [10.11.146.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLTHCO007008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:29:18 -0400
In-Reply-To: <54497296.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The sparse checker treats 0 assignments as special, but
doesn't catch a = b = 0; separate them to make it quieter.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/extent.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index c9ef701..ca5b78b 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1651,8 +1651,10 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 	} else {
 		eh = (struct ext3_extent_header *) path->buf;
 		eh->eh_entries = ext2fs_cpu_to_le16(path->entries);
-		if ((path->entries == 0) && (handle->level == 0))
-			eh->eh_depth = handle->max_depth = 0;
+		if ((path->entries == 0) && (handle->level == 0)) {
+			eh->eh_depth = 0;
+			handle->max_depth = 0;
+		}
 		retval = update_path(handle);
 	}
 	return retval;
-- 1.7.1

