Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBA0C433EF
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Mar 2022 01:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiCJBpi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 9 Mar 2022 20:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiCJBph (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Mar 2022 20:45:37 -0500
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E08562A35
        for <linux-ext4@vger.kernel.org>; Wed,  9 Mar 2022 17:44:34 -0800 (PST)
X-QQ-mid: bizesmtp81t1646876665t5i7v6m0
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 10 Mar 2022 09:44:19 +0800 (CST)
X-QQ-SSF: 01400000002000C0H000B00A0000000
X-QQ-FEAT: WaCs93CnLvMjEl/TeIJeGa6u8VgBO1Yh/h9JSMusAZ8mkYekJiGchdmrnv1Lo
        GgVzTej0YzmyhyoKwT2I+X3obM4KzcquSHppuFiPwZi2p7z6BU/RMqr+1uQGvPcMlu1o+3V
        a5w4FOfPzuu7UEHnt/h+wUZ421nJ860o2gIbkBCyXahyv41n69bpO2hB1N/3gBQgmYoN2T7
        AC+A7POv8VS8iMw0dm135X0s6WEhNJ7e2VN6vW88q9tgiFvka1XYgw/kSEC/C5Hnmq0wmIX
        gwEzfjUEE6n9vzyOOzWZvOL1Fw9FUzDEOSXuMWAn5Cu0AqnEFxhx6WMWbp8xiEbAh0wV4fo
        dE5bOlAPBcZ6qVhAgU=
X-QQ-GoodBg: 2
From:   lianzhi chang <changlianzhi@uniontech.com>
To:     linux-doc@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, corbet@lwn.net,
        adilger.kernel@dilger.ca, tytso@mit.edu,
        lianzhi chang <changlianzhi@uniontech.com>
Subject: [PATCH] doc: Fixed a bug in ext4 document
Date:   Thu, 10 Mar 2022 09:44:15 +0800
Message-Id: <20220310014415.29937-1-changlianzhi@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign5
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The unit of file system size should be TiB, not PiB

Signed-off-by: lianzhi chang <changlianzhi@uniontech.com>
---
 Documentation/filesystems/ext4/blocks.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/ext4/blocks.rst b/Documentation/filesystems/ext4/blocks.rst
index bd722ecd92d6..b0f80ea87c90 100644
--- a/Documentation/filesystems/ext4/blocks.rst
+++ b/Documentation/filesystems/ext4/blocks.rst
@@ -39,7 +39,7 @@ For 32-bit filesystems, limits are as follows:
      - 4TiB
      - 8TiB
      - 16TiB
-     - 256PiB
+     - 256TiB
    * - Blocks Per Block Group
      - 8,192
      - 16,384
-- 
2.20.1



