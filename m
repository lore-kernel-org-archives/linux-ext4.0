Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbfAONmG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 15 Jan 2019 08:42:06 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EA3881DF3
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 13:42:06 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.205.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C3BB60606
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 13:42:05 +0000 (UTC)
From: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Subject: [PATCH 1/2] e2freefrag: fix memory leak in scan_online()
Date: Tue, 15 Jan 2019 14:42:02 +0100
Message-Id: <20190115134203.11448-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/e2freefrag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index f7fede54..935ae225 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -236,6 +236,7 @@ static int scan_online(ext2_filsys fs, struct chunk_info *info,
 		fsmap_advance(fsmap);
 	}
 
+	free(fsmap);
 	return 1;
 }
 #else
-- 
2.20.1
