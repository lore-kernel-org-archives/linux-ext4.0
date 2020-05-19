Return-Path: <SRS0=pS3D=7B=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F2DC433E0
	for <linux-ext4@archiver.kernel.org>; Tue, 19 May 2020 05:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25586206D4
	for <linux-ext4@archiver.kernel.org>; Tue, 19 May 2020 05:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgESFDx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 May 2020 01:03:53 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47094 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgESFDx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2020 01:03:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id A426E2A112D
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, kernel@collabora.com,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        =?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] unicode: Allow building kunit test suite as a module
Date:   Tue, 19 May 2020 01:03:46 -0400
Message-Id: <20200519050346.3983998-1-krisman@collabora.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Starting on commit c475c77d5b56 ("kunit: allow kunit tests to be loaded
as a module") kunit testsuites need to be buildable as modules, to
prevent the undefined references below, in case KUNIT itself was made a
module:

utf8-test.c:(.text+0x48): undefined reference to `kunit_ptr_not_err_assert_format'
>> sparc64-linux-ld: utf8-test.c:(.text+0x50): undefined reference to `kunit_ptr_not_err_assert_format'
>> sparc64-linux-ld: utf8-test.c:(.text+0xb4): undefined reference to `kunit_do_assertion'
>> sparc64-linux-ld: utf8-test.c:(.text+0xbc): undefined reference to
`kunit_binary_assert_format'

This was found by 0-day on linux-next and fixes the allmodconfig build

CC: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Fixes: d269543a1dcb ("unicode: implement utf8 unit tests as a KUnit test suite")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/unicode/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/unicode/Kconfig b/fs/unicode/Kconfig
index a8865891c3bd..eb30ef469567 100644
--- a/fs/unicode/Kconfig
+++ b/fs/unicode/Kconfig
@@ -9,7 +9,7 @@ config UNICODE
 	  support.
 
 config UNICODE_KUNIT_TESTS
-	bool "KUnit tests for Unicode normalization and casefolding support"
+	tristate "KUnit tests for Unicode normalization and casefolding support"
 	depends on UNICODE && KUNIT
 	default n
 	help
-- 
2.26.2

