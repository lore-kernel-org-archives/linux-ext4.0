From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: Adjust mineln with discard_granularity in FITRIM code
Date: Tue, 15 Feb 2011 18:06:25 +0100
Message-ID: <1297789585-5986-2-git-send-email-lczerner@redhat.com>
References: <1297789585-5986-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1BORGb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Feb 2011 12:06:31 -0500
In-Reply-To: <1297789585-5986-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Discard granularity tells us the minimum size of extent to be discarded.
Use that information to adjust minlen properly in FITRIM code. Smaller
extents will be ignored anyway, so we can optimize by not even trying to
discard them.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 25ba7c7..c052c9f 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -348,6 +348,8 @@ mext_out:
 		    sizeof(range)))
 			return -EFAULT;
 
+		range.minlen = max((unsigned int)range.minlen,
+				   q->limits.discard_granularity);
 		ret = ext4_trim_fs(sb, &range);
 		if (ret < 0)
 			return ret;
-- 
1.7.4

