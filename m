Return-Path: <SRS0=Ikgj=TX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661D7C282E1
	for <linux-ext4@archiver.kernel.org>; Thu, 23 May 2019 16:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DA721872
	for <linux-ext4@archiver.kernel.org>; Thu, 23 May 2019 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558628437;
	bh=hzIYKypcpbtVxPutBENdTXvGlYraOt4l/gwPa4stsDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bikUzEoIG75S8oeV0vhKx8wWNo5h0Tg8XjYfml2nFtWDvGbFZjai/15CJFhYwaIcy
	 aLCs4AQtehM+rGR+MNxn8UkB5qvdM2kyAIxmI/FEFqlPSCKFA3W1tHAfc6vSErNDGq
	 Cew8tQ6qy2SUxhEOLykpdzsN5Unf/VB9Ck9cWeIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbfEWQUg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 May 2019 12:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730893AbfEWQUg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 23 May 2019 12:20:36 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE2B217D9;
        Thu, 23 May 2019 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558628435;
        bh=hzIYKypcpbtVxPutBENdTXvGlYraOt4l/gwPa4stsDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROmtIeDzJQ31Y+xvbqtasyM2iRxub1jmJIR7STxbH3poPEMwrkGMIKN+/fCzeL268
         A+KLdZJI/nOG+VfLOW7LERfUhTpoP/MSjMjzvObGTjxHoWZTlYIJZqqUz1HP9BNMTg
         yNdBQNQ72gSBc2v7I+PCo2eEPRe9zgCkllGQWZCU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-integrity@vger.kernel.org, linux-api@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH v3 02/15] fs-verity: add MAINTAINERS file entry
Date:   Thu, 23 May 2019 09:17:58 -0700
Message-Id: <20190523161811.6259-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523161811.6259-1-ebiggers@kernel.org>
References: <20190523161811.6259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fs-verity will be jointly maintained by Eric Biggers and Theodore Ts'o.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5cfbea4ce5750..869c836e9039f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6493,6 +6493,18 @@ S:	Maintained
 F:	fs/notify/
 F:	include/linux/fsnotify*.h
 
+FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PROTECTION
+M:	Eric Biggers <ebiggers@kernel.org>
+M:	Theodore Y. Ts'o <tytso@mit.edu>
+L:	linux-fscrypt@vger.kernel.org
+Q:	https://patchwork.kernel.org/project/linux-fscrypt/list/
+T:	git git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git fsverity
+S:	Supported
+F:	fs/verity/
+F:	include/linux/fsverity.h
+F:	include/uapi/linux/fsverity.h
+F:	Documentation/filesystems/fsverity.rst
+
 FUJITSU LAPTOP EXTRAS
 M:	Jonathan Woithe <jwoithe@just42.net>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.21.0

