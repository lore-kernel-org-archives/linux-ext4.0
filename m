From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: fix FITRIM in no journal mode
Date: Wed, 25 Sep 2013 11:46:25 +0200
Message-ID: <1380102385-10475-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab3IYJqa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Sep 2013 05:46:30 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8P9kTUD009667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Sep 2013 05:46:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When using FITRIM ioctl on a file system without journal it will
only trim the block group once, no matter how many times you invoke
=46ITRIM ioctl and how many block you release from the block group.

It is because we only clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT in journal
callback. Fix this by clearing the bit in no journal mode as well.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Jorge F=C3=A1bregas <jorge.fabregas@gmail.com>
---
 fs/ext4/mballoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a41e3ba..4d113ef 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4794,8 +4794,8 @@ do_more:
 					 " group:%d block:%d count:%lu failed"
 					 " with %d", block_group, bit, count,
 					 err);
-		}
