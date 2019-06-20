Return-Path: <SRS0=x6sY=UT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A7CC48BE4
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Jun 2019 20:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35CCE20652
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Jun 2019 20:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561064025;
	bh=bQ5txMhupdYzjdUj2yCJo0myxUrjvFMA4BkAw9xmbyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KGogC7dvhMkPC014scQ3o6O1cCmJHwMH8YNwHxiITNdSfzJAPEZgql3CtBJo4QGWk
	 JZ7jBoEb5xJVUPmZgAXTBh86abtpvSLPKB9Zz6XlRCRX2/kvDv1SY/wWKqgZkvkqJS
	 GjNht9+MEn9bMlQE8ALzDsUotUVt+kllNXCnbY/I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfFTUxo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 20 Jun 2019 16:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfFTUxn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Jun 2019 16:53:43 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C622085A;
        Thu, 20 Jun 2019 20:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561064022;
        bh=bQ5txMhupdYzjdUj2yCJo0myxUrjvFMA4BkAw9xmbyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9KrJAqo3QjtKru5Hccpf74O2EY5vqNHmPNKdG2GwbeAYtyUwZXptLCAp4366Hv1L
         jf7ckoyUM8KwIjpdApoNMYQtsclRIl+WmtSkFoyQuh3WoHQt6Mv/uDeeWCBmehNj2m
         UxqBthLiK1KDZuiWGGovAPnV9Ae+kt5M2a0BJo6Y=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v5 02/16] fs-verity: add MAINTAINERS file entry
Date:   Thu, 20 Jun 2019 13:50:29 -0700
Message-Id: <20190620205043.64350-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190620205043.64350-1-ebiggers@kernel.org>
References: <20190620205043.64350-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fs-verity will be jointly maintained by Eric Biggers and Theodore Ts'o.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a6954776a37e70..655065116f9228 100644
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
2.22.0.410.gd8fdbe21b5-goog

