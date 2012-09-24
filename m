From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ext4: online defrag is not supported for journaled files
Date: Mon, 24 Sep 2012 16:23:52 +0400
Message-ID: <1348489434-22778-3-git-send-email-dmonakhov@openvz.org>
References: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50631 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2IXMYD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 08:24:03 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6602143lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 05:24:02 -0700 (PDT)
In-Reply-To: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Proper block swap for inodes with full journaling enabled is
truly non obvious task. In order to be on a safe side let's
explicitly disable it for now.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 37c8497..0aa2ad7 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1142,7 +1142,12 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
