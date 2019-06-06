Return-Path: <SRS0=wnCJ=UF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48CFC04AB5
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Jun 2019 15:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9550C208C0
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Jun 2019 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559836446;
	bh=uj7OhOWNAd4Pcxs6nLhO9mFRMaxtTmlWgngVbC8runE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ttQwsB4xv6itCWKWDpyZF68FrFIJptsvYkxDUTH7PZ1pp72E9ArQgDX566VPklQyY
	 WlafxssMNNFtVRurKZZZLrJeTNCA+XNdCm7x1Fep658SPgEAlNI+8vrM1MivBnNLXZ
	 tTePzSxAsITrov7I5C1AzmzO0MhssHUfk/icFwOE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbfFFPyF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Jun 2019 11:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbfFFPyE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Jun 2019 11:54:04 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B019F20868;
        Thu,  6 Jun 2019 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559836444;
        bh=uj7OhOWNAd4Pcxs6nLhO9mFRMaxtTmlWgngVbC8runE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXIPkzUfqDRKOSTk0dQNkKJOMbvMLZDYl9MBexWFxlr62YVXk9/stxK01xg9RS7bC
         OfNgfQWcb5PGe0C9F7MuL3U8kybF4ykAvcr4M08oybWgQu4MQip0PtkQXO5nvGJkkJ
         Aj8g+E/KT5cfZgrWNGUvcY/CqaT76HuXp6iZ2Uhw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v4 02/16] fs-verity: add MAINTAINERS file entry
Date:   Thu,  6 Jun 2019 08:51:51 -0700
Message-Id: <20190606155205.2872-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606155205.2872-1-ebiggers@kernel.org>
References: <20190606155205.2872-1-ebiggers@kernel.org>
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
index a6954776a37e..655065116f92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6505,6 +6505,18 @@ S:	Maintained
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

