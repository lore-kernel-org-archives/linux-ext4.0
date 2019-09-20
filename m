Return-Path: <SRS0=rV8s=XP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51360C4CECE
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 21:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CDA22086A
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 21:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569015083;
	bh=mxcbvMl1GDdVaogVkLdFb9r/c6Cl4P3ePKpgjIVY704=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fzXPiEUSdP3LAoSwKo5YeLCazDUH1WURnYSIAVYTomyqxAbZX9PDRtTG1CFE/qFlH
	 t3MAt4j/2pFdxpoPNdjmx4Iwg1xc5hWyZaXqFze5cpTMqBwiYycMoamN7yHzmoFm2/
	 boJMEjaHUS6XgJBJzTSiZCuwn5g5PQZj1GIEyhl8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390860AbfITVbW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 20 Sep 2019 17:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbfITVbV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Sep 2019 17:31:21 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C79822080F
        for <linux-ext4@vger.kernel.org>; Fri, 20 Sep 2019 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569015080;
        bh=mxcbvMl1GDdVaogVkLdFb9r/c6Cl4P3ePKpgjIVY704=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bGnv8qGR348b4tZjasOsPIge7AK3/Y/jytiClGxdPWCvNPse7JJbTjas64Ux32yGH
         4m94yHQcOO0T2zZDRHM2a7UfR6JpWQHfI3sm0NeEzmcNm6ifO0fmfSK/AkeTX0orjH
         tJ2w6f37wgQI2Yqd1cfCaeo4kh47xYmf3ASGkw6A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH 4/6] ext4.5: tweak the documentation for the encrypt feature
Date:   Fri, 20 Sep 2019 14:29:52 -0700
Message-Id: <20190920212954.205789-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920212954.205789-1-ebiggers@kernel.org>
References: <20190920212954.205789-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Try to make it clearer that enabling 'encrypt' just enables *support*
for encryption; it doesn't actually encrypt anything by itself.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/ext4.5.in | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 627c0dad..1db61a5f 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -96,9 +96,9 @@ extended attributes per file.
 .TP
 .B encrypt
 .br
-This ext4 feature provides file-system level encryption of data blocks
-and file names.  The inode metadata (timestamps, file size, user/group
-ownership, etc.) is
+Enables support for file-system level encryption of data blocks and file
+names.  The inode metadata (timestamps, file size, user/group ownership,
+etc.) is
 .I not
 encrypted.
 .IP
-- 
2.23.0.351.gc4317032e6-goog

