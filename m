Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBC3C4338F
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Aug 2021 09:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F4360ED6
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Aug 2021 09:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbhHFJ6y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhHFJ6t (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2021 05:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628243914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1mxHwvV4s0WmY6mJwpU5NBAe57HY2UnEei7jangg1k=;
        b=aR+9s7WEqRcisHvl4gueHZs7RnxkUws9JHdy+Fhml5Vv+zaQf3rbiHrhY7bHDvfA24/tj4
        5Je4dZfNtDYYY7puUPKyr+dFiSE0K1IJRK/EXhQgikjekENejigmPwT8WnpopBrJooYE11
        HyjqNBNiVlJzr53TczFWxbHZ6SRklpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-YuBw2uo1NzO0pK_QSiR2hA-1; Fri, 06 Aug 2021 05:58:32 -0400
X-MC-Unique: YuBw2uo1NzO0pK_QSiR2hA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE2BA801AE7;
        Fri,  6 Aug 2021 09:58:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2009281F7D;
        Fri,  6 Aug 2021 09:58:30 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH 6/7] libss: Add missing error handling for fdopen()
Date:   Fri,  6 Aug 2021 11:58:19 +0200
Message-Id: <20210806095820.83731-6-lczerner@redhat.com>
In-Reply-To: <20210806095820.83731-1-lczerner@redhat.com>
References: <20210806095820.83731-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ss/list_rqs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/ss/list_rqs.c b/lib/ss/list_rqs.c
index 021a3835..89e37bb2 100644
--- a/lib/ss/list_rqs.c
+++ b/lib/ss/list_rqs.c
@@ -12,6 +12,9 @@
  */
 #include "config.h"
 #include "ss_internal.h"
+#ifdef HAVE_UNISTD_H
+#include <unistd.h>
+#endif
 #include <signal.h>
 #include <setjmp.h>
 #include <sys/wait.h>
@@ -46,6 +49,12 @@ void ss_list_requests(int argc __SS_ATTR((unused)),
         return;
     }
     output = fdopen(fd, "w");
+    if (!output) {
+        perror("fdopen");
+        close(fd);
+        (void) signal(SIGINT, func);
+        return;
+    }
     sigprocmask(SIG_SETMASK, &omask, (sigset_t *) 0);
 
     fprintf (output, "Available %s requests:\n\n",
-- 
2.31.1

