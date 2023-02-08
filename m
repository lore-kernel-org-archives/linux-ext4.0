Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BC8C636D3
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Feb 2023 07:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjBHHBY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Feb 2023 02:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjBHHA5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Feb 2023 02:00:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E8045F43
        for <linux-ext4@vger.kernel.org>; Tue,  7 Feb 2023 22:59:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94450B81C3A
        for <linux-ext4@vger.kernel.org>; Wed,  8 Feb 2023 06:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C26BC433EF
        for <linux-ext4@vger.kernel.org>; Wed,  8 Feb 2023 06:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675839574;
        bh=uXcC4bQ8SgVMP7ZeQz46DXD4L+Rm8k+E7DqiGiOGR3A=;
        h=From:To:Subject:Date:From;
        b=SrwTjCJHjWAZLQ+tsd8JGSR2BJJrshqKG5qKYAJyXofu0Zk09gyJ/mWMkYhy8J7HD
         k/fHc5y1Fbw/OZlN02nuIenO0WFsEU/c+FZHiZHqk8lBpr4sqsb90dyeMjWDp2gWs5
         g6jrtluARaz463Uf2WsDRtj4DIAh120agCC5f9S9Y0LpJ/C7HtFNrzraJC0GXYxyNk
         A2+fEebhujP0wbmzliph1TclB4y6Lbkmg8qVoHZbXuWCJVaeFnjU/Zx88L5KG5owYq
         5XuC0l5AL9XuUiQAAdYGUhe4q56JkESkdw9o5UuSxEhKoDi3YQv2XNe/KcZLJREAZv
         mtqlsiRsWX11g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [e2fsprogs PATCH] ci.yml: store the config.h files as workflow artifacts
Date:   Tue,  7 Feb 2023 22:58:58 -0800
Message-Id: <20230208065858.227695-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Store the config.h file for each platform as a workflow artifact, so
that it will be possible to download them and compare them to
util/android_config.h.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .github/workflows/ci.yml | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 51b27c88d..6b0f91506 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -27,6 +27,10 @@ jobs:
     - run: make -j8 check V=1 CFLAGS_WARN="-Werror"
     - run: make -j8 install V=1 DESTDIR=$PWD/installdir
     - run: make -j8 uninstall V=1 DESTDIR=$PWD/installdir
+    - uses: actions/upload-artifact@v3
+      with:
+        name: ubuntu-config.h
+        path: lib/config.h
 
   i386-build-and-test:
     name: Build and test with gcc -m32
@@ -79,6 +83,10 @@ jobs:
     - run: make -j8 check V=1 CFLAGS_WARN="-Werror -Wno-error=deprecated-declarations"
     - run: make -j8 install DESTDIR=$PWD/installdir
     - run: make -j8 uninstall DESTDIR=$PWD/installdir
+    - uses: actions/upload-artifact@v3
+      with:
+        name: macOS-config.h
+        path: lib/config.h
 
   windows-msys2-build:
     name: Build mke2fs on Windows with ${{matrix.sys}}
@@ -114,3 +122,7 @@ jobs:
     - run: make -j8 -C misc/ mke2fs V=1 CFLAGS_WARN="-Werror"
     - run: touch image.ext4
     - run: misc/mke2fs.exe -T ext4 image.ext4 128M
+    - uses: actions/upload-artifact@v3
+      with:
+        name: windows-${{matrix.env}}-config.h
+        path: lib/config.h

base-commit: a06369183565bccbbba9a47b6c55622da8a1de85
-- 
2.39.1

