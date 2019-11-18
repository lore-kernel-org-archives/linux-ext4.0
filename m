Return-Path: <SRS0=fzoK=ZK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D64CC43215
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Nov 2019 01:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67B23206D6
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Nov 2019 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574041818;
	bh=MrfqTzgBX+zlHzSzpgFhCiQAWcsWqcGoM8SF53EPfgw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=E57XzowCC9ObBAZb8M6AuIg3hIWLOf6jCHb+pS/kF8ws3t5EW2ViZwrC8jEQWHpZA
	 5BUVI7wKRDWLBoDi3dY8Um1Kkt0jiMbEQQXmU3Nn1oT/+MGpummkrEl/y01wWqjKkR
	 WXNDvpm5wCV3ItuKYqdJKHucmQ15tjP13f6nvcp0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfKRBuS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Nov 2019 20:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfKRBuR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Nov 2019 20:50:17 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD4FB206D6
        for <linux-ext4@vger.kernel.org>; Mon, 18 Nov 2019 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574041816;
        bh=MrfqTzgBX+zlHzSzpgFhCiQAWcsWqcGoM8SF53EPfgw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=c4fv5KmJ0RTbkhag4jY+W5CJxgX68nyqDKHkV9XhmP9YIixXQozI3ZAxgXuboVJMi
         2Hiot6UN5R7WQfGhlYDLsy9vP+erQqG4foQUt9Q5u4C6C+tvH7+sA4XlCBTp+IEWvo
         3IuQ/Guhsokd+S0DOfUnVRTkLlRu3vNhJUY0iNhc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH 4/6] chattr.1: fix some grammatical errors
Date:   Sun, 17 Nov 2019 17:48:50 -0800
Message-Id: <20191118014852.390686-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191118014852.390686-1-ebiggers@kernel.org>
References: <20191118014852.390686-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

- "can only be open" => "can only be opened"
- "is not candidate" => "is not a candidate"
- "written ... on the disk" => "written ... to the disk"

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/chattr.1.in | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 1baacf17..cc751fe8 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -79,9 +79,9 @@ Set the file's version/generation number.
 .BI \-p " project"
 Set the file's project number.
 .SH ATTRIBUTES
-A file with the 'a' attribute set can only be open in append mode for writing.
-Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
-capability can set or clear this attribute.
+A file with the 'a' attribute set can only be opened in append mode for
+writing.  Only the superuser or a process possessing the
+CAP_LINUX_IMMUTABLE capability can set or clear this attribute.
 .PP
 When a file with the 'A' attribute set is accessed, its atime record is
 not modified.  This avoids a certain amount of disk I/O for laptop
@@ -102,12 +102,12 @@ be fully stable.  If the 'C' flag is set on a directory, it will have no
 effect on the directory, but new files created in that directory will
 have the No_COW attribute set.)
 .PP
-A file with the 'd' attribute set is not candidate for backup when the
+A file with the 'd' attribute set is not a candidate for backup when the
 .BR dump (8)
 program is run.
 .PP
 When a directory with the 'D' attribute set is modified,
-the changes are written synchronously on the disk; this is equivalent to
+the changes are written synchronously to the disk; this is equivalent to
 the 'dirsync' mount option applied to a subset of the files.
 .PP
 The 'e' attribute indicates that the file is using extents for mapping
@@ -164,7 +164,7 @@ and written back to the disk.  Note: please make sure to read the bugs
 and limitations section at the end of this document.
 .PP
 When a file with the 'S' attribute set is modified,
-the changes are written synchronously on the disk; this is equivalent to
+the changes are written synchronously to the disk; this is equivalent to
 the 'sync' mount option applied to a subset of the files.
 .PP
 A file with the 't' attribute will not have a partial block fragment at
-- 
2.24.0

