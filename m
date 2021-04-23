Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BACBC433ED
	for <linux-ext4@archiver.kernel.org>; Fri, 23 Apr 2021 20:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4BD66144E
	for <linux-ext4@archiver.kernel.org>; Fri, 23 Apr 2021 20:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244044AbhDWUwo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 23 Apr 2021 16:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244029AbhDWUwl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Apr 2021 16:52:41 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D545C061574;
        Fri, 23 Apr 2021 13:52:04 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: shreeya)
        with ESMTPSA id 6C0AB1F431EE
From:   Shreeya Patel <shreeya.patel@collabora.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
        chao@kernel.org, krisman@collabora.com, ebiggers@google.com,
        drosen@google.com, ebiggers@kernel.org, yuchao0@huawei.com
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        andre.almeida@collabora.com
Subject: [PATCH v8 3/4] fs: unicode: Rename utf8-core file to unicode-core
Date:   Sat, 24 Apr 2021 02:21:35 +0530
Message-Id: <20210423205136.1015456-4-shreeya.patel@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423205136.1015456-1-shreeya.patel@collabora.com>
References: <20210423205136.1015456-1-shreeya.patel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

utf8data.h_shipped has a large database table which is an auto-generated
decodification trie for the unicode normalization functions and it is not
necessary to carry this large table in the kernel unless it is required by
the filesystem during boot time.

Goal is to make UTF-8 encoding loadable by converting it into a module
and adding a unicode subsystem layer between the filesystems and the
utf8 module.
This layer will then load the module whenever any filesystem that
needs unicode is mounted or utf8 can also be built into the kernel incase
it is required by the filesystem during boot time.

Currently, only UTF-8 encoding is supported but if any other encodings
are supported in future then the layer file would be responsible for
loading the desired encoding module.

Rename the file name from utf8-core to unicode-core for transformation of
utf8-core file into the unicode subsystem layer file and also for better
understanding.
Implementation for unicode-core file to act as layer will be added in the
future patches.

Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
---
Changes in v8
  - Improve the commit message to better describe about the built-in
    option usage.

 fs/unicode/Makefile                        | 2 +-
 fs/unicode/{utf8-core.c => unicode-core.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename fs/unicode/{utf8-core.c => unicode-core.c} (100%)

diff --git a/fs/unicode/Makefile b/fs/unicode/Makefile
index b88aecc86550..fbf9a629ed0d 100644
--- a/fs/unicode/Makefile
+++ b/fs/unicode/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_UNICODE) += unicode.o
 obj-$(CONFIG_UNICODE_NORMALIZATION_SELFTEST) += utf8-selftest.o
 
-unicode-y := utf8-norm.o utf8-core.o
+unicode-y := utf8-norm.o unicode-core.o
 
 $(obj)/utf8-norm.o: $(obj)/utf8data.h
 
diff --git a/fs/unicode/utf8-core.c b/fs/unicode/unicode-core.c
similarity index 100%
rename from fs/unicode/utf8-core.c
rename to fs/unicode/unicode-core.c
-- 
2.30.2

