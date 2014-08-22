From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/5] ext4_zero_range: fix incorect journal credits reservation
Date: Fri, 22 Aug 2014 15:32:25 +0400
Message-ID: <1408707147-22482-4-git-send-email-dmonakhov@openvz.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
Cc: lczerner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:11051 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbaHVLcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 07:32:54 -0400
In-Reply-To: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we reserve only 4 blocks but in worst case scenario
ext4_zero_partial_blocks() may want to zeroout and convert two
non adjacent blocks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5bf718b..39fbcbb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4740,6 +4740,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	loff_t new_size = 0;
 	int ret = 0;
 	int flags;
+	int credits;
 	int partial;
 	loff_t start, end;
 	ext4_lblk_t lblk;
@@ -4839,8 +4840,10 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		if (ret)
 			goto out_dio;
 	}
