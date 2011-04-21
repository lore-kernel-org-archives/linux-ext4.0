From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: protect bb_first_free in ext4_trim_all_free() with group lock
Date: Thu, 21 Apr 2011 12:26:36 +0200
Message-ID: <1303381596-13758-1-git-send-email-lczerner@redhat.com>
References: <alpine.LFD.2.00.1104211135540.4399@dhcp-27-109.brq.redhat.com>
Cc: tytso@mit.edu, amir73il@gmail.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1DUK0w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Apr 2011 06:26:52 -0400
In-Reply-To: <alpine.LFD.2.00.1104211135540.4399@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should protect reading bd_info->bb_first_free with the group lock
because otherwise we might miss some free blocks. This is not a big deal
at all, but the change to do right thing is really simple, so lets do
that.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 776d7a8..804232a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4775,11 +4775,11 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 				"information for %u", group);
 		return ret;
 	}
