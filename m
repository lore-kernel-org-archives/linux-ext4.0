From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] ext4: Use kstrtoul() instead of deprecated simple_strtoul()
Date: Fri,  8 Mar 2013 09:23:17 +0100
Message-ID: <1362730998-3263-2-git-send-email-lczerner@redhat.com>
References: <1362730998-3263-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab3CHIXY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 03:23:24 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r288NOXR014629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 8 Mar 2013 03:23:24 -0500
In-Reply-To: <1362730998-3263-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In parse_strtoul() we're still using deprecated simple_strtoul(). Change
that in favour of kstrtoul().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 620cf56..7bcdef1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2359,14 +2359,12 @@ struct ext4_attr {
 static int parse_strtoul(const char *buf,
 		unsigned long max, unsigned long *value)
 {
-	char *endp;
