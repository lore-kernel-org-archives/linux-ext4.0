Return-Path: <SRS0=guV/=4Z=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0137BC18E5B
	for <linux-ext4@archiver.kernel.org>; Sun,  8 Mar 2020 04:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD5EA206D5
	for <linux-ext4@archiver.kernel.org>; Sun,  8 Mar 2020 04:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583642215;
	bh=+ov2E0CAUG0jm8hkNuA2ANELpXN4Z3WZr/tFb6gI+LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Tjb1IXkmrsaidYF9rmPBsx08JD9GMSMInXlhl7L1B5MnG3qogVcYV1ZxjJvHCTgsa
	 ZGOSEQzZgiaYAzJwSWzwdRxuobUQpus3TD7VaSjWPBKMTW3wWRE+i0FuRoi+uPCxVP
	 WEPRk3oS9GxC3SK+/mfpHk4PwsKi/m62qW4WaQrw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCHEgx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 7 Mar 2020 23:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgCHEgx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 7 Mar 2020 23:36:53 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCED3206D5;
        Sun,  8 Mar 2020 04:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583642212;
        bh=+ov2E0CAUG0jm8hkNuA2ANELpXN4Z3WZr/tFb6gI+LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqzTyJ6UuCdKk3EKIYyrl8OiuYuIwD3/QO38Jlo8WewLwBZk4O53pHeRvUZitr944
         pRZ75BVtV1RerwDe7KNMqmO8yBSItypQm6gmfNcmJXJX72eT+5nJ0iI8y4b3SI8upL
         C/mys+rI9Cd3IMcpSXutmLFivJmxzOirWCmzGQIs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: clear PF_MEMALLOC before exiting demultiplex thread
Date:   Sat,  7 Mar 2020 20:36:45 -0800
Message-Id: <20200308043645.1034870-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0000000000000e7156059f751d7b@google.com>
References: <0000000000000e7156059f751d7b@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Leaving PF_MEMALLOC set when exiting a kthread causes it to remain set
during do_exit().  That can confuse things.  For example, if BSD process
accounting is enabled, then it's possible for do_exit() to end up
calling ext4_write_inode().  That triggers the
WARN_ON_ONCE(current->flags & PF_MEMALLOC) there, as it assumes
(appropriately) that inodes aren't written when allocating memory.

This case was reported by syzbot at
https://lkml.kernel.org/r/0000000000000e7156059f751d7b@google.com.

Fix this in cifs_demultiplex_thread() by using the helper functions to
save and restore PF_MEMALLOC.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/cifs/connect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4804d1df8c1c..beab1dc2dc01 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1164,8 +1164,9 @@ cifs_demultiplex_thread(void *p)
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mids[MAX_COMPOUND];
 	char *bufs[MAX_COMPOUND];
+	unsigned int noreclaim_flag;
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
 
 	length = atomic_inc_return(&tcpSesAllocCount);
@@ -1320,6 +1321,7 @@ cifs_demultiplex_thread(void *p)
 		set_current_state(TASK_RUNNING);
 	}
 
+	memalloc_noreclaim_restore(noreclaim_flag);
 	module_put_and_exit(0);
 }
 
-- 
2.25.1

