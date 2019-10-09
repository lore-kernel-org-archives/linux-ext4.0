Return-Path: <SRS0=VFUI=YC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E04BECE58C
	for <linux-ext4@archiver.kernel.org>; Wed,  9 Oct 2019 23:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72767218DE
	for <linux-ext4@archiver.kernel.org>; Wed,  9 Oct 2019 23:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570664846;
	bh=wV/V6DhT0TzJjctQ/covpkwmj5QjFM961Z0/BTrFR5E=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=h1vubcCZqfBmzim3x9Th/ICe92kIvOohgrkgdXeSfLQzcvnoTi49LFV7SHApw+MP8
	 20+Eai67wEyMU3W16z0uaHALuuIFHKtGeZ+98qHP3/t1DFSoBL7E+zFEiI6c+EP2BA
	 a7oFlaNGanlA9JH3s4re8Gp5fdpglGDnvYZ9rs3U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732340AbfJIXrZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 9 Oct 2019 19:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731103AbfJIXrZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Oct 2019 19:47:25 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF4E206BB;
        Wed,  9 Oct 2019 23:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570664845;
        bh=wV/V6DhT0TzJjctQ/covpkwmj5QjFM961Z0/BTrFR5E=;
        h=From:To:Cc:Subject:Date:From;
        b=WhSjfjHstDaamJAnmujsDC4/nz0uLTeh8/TLveamefQGBgi/lSL8EuYxN/EIzVVr9
         tsZ8/Z3e6oCl6a3TRyLojo9Y0MDsX806iF2xqa92qd2JGISQny2e10513j4+2Yf5vx
         +VWo/A62AuNyuQnTzVxy5zEwYqggPzuCnZJ6HmXo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] docs: ioctl-number: document fscrypt ioctl numbers
Date:   Wed,  9 Oct 2019 16:45:55 -0700
Message-Id: <20191009234555.226282-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The 'f' ioctls with numbers 19-26 decimal are currently used for fscrypt
(a.k.a. ext4/f2fs/ubifs encryption), and up to 39 decimal is reserved
for future fscrypt use, as per the comment in fs/ext4/ext4.h.  So the
reserved range is 13-27 hex.

Document this in ioctl-number.rst.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/ioctl/ioctl-number.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/ioctl/ioctl-number.rst b/Documentation/ioctl/ioctl-number.rst
index bef79cd4c6b4d..4ef86433bd677 100644
--- a/Documentation/ioctl/ioctl-number.rst
+++ b/Documentation/ioctl/ioctl-number.rst
@@ -233,6 +233,7 @@ Code  Seq#    Include File                                           Comments
 'f'   00-0F  fs/ext4/ext4.h                                          conflict!
 'f'   00-0F  linux/fs.h                                              conflict!
 'f'   00-0F  fs/ocfs2/ocfs2_fs.h                                     conflict!
+'f'   13-27  linux/fscrypt.h
 'f'   81-8F  linux/fsverity.h
 'g'   00-0F  linux/usb/gadgetfs.h
 'g'   20-2F  linux/usb/g_printer.h
-- 
2.23.0.581.g78d2f28ef7-goog

