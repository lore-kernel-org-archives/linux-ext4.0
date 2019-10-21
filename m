Return-Path: <SRS0=b1z3=YO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E893BCA9EB9
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 23:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB132166E
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 23:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571699247;
	bh=FOZqGhYE8h24wrGESr8UoajZvJ4ZhQMu8xtIorR38Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bTdWqEVucq47eo0mCgFxgqMY2m3shFIh+uu2IEQgGd7E3QrIEsYyFwebMhvRtGgCx
	 AzsrwHpN5I/IoqgqoAFR94HxHarRrlyjdZUBqG9+xjoXgh8NqlcVfb1jpjWYE20ZXF
	 HLMHpuKJAORwwf02O8bp58Sbq5pOj/vOwPVfhFEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfJUXHZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Oct 2019 19:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbfJUXHY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Oct 2019 19:07:24 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FDC1214B2;
        Mon, 21 Oct 2019 23:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571699243;
        bh=FOZqGhYE8h24wrGESr8UoajZvJ4ZhQMu8xtIorR38Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugZlVU71CDPVEBBv+7mmMCXCOR/73fpd09Y3fz2dQKbpafoZNlX3Z/3sBct//NlFo
         d3wuK8xF+3fONl/cS+b6joBgZinmWacixf7sN2KKwKUFXJfHvc6Si8+Uo/RdmC6QX7
         bBScYAjOsBmiql1BpxMRy85tJPZtJxdr/65dcmxo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] f2fs: add support for INLINE_CRYPT_OPTIMIZED encryption policies
Date:   Mon, 21 Oct 2019 16:03:55 -0700
Message-Id: <20191021230355.23136-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191021230355.23136-1-ebiggers@kernel.org>
References: <20191021230355.23136-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

f2fs inode numbers are stable across filesystem resizing, and f2fs inode
and file logical block numbers are always 32-bit.  So f2fs can always
support INLINE_CRYPT_OPTIMIZED encryption policies.  Wire up the needed
fscrypt_operations to declare support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/super.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1443cee158633..851ac95229263 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2308,13 +2308,27 @@ static bool f2fs_dummy_context(struct inode *inode)
 	return DUMMY_ENCRYPTION_ENABLED(F2FS_I_SB(inode));
 }
 
+static bool f2fs_has_stable_inodes(struct super_block *sb)
+{
+	return true;
+}
+
+static void f2fs_get_ino_and_lblk_bits(struct super_block *sb,
+				       int *ino_bits_ret, int *lblk_bits_ret)
+{
+	*ino_bits_ret = 8 * sizeof(nid_t);
+	*lblk_bits_ret = 8 * sizeof(block_t);
+}
+
 static const struct fscrypt_operations f2fs_cryptops = {
-	.key_prefix	= "f2fs:",
-	.get_context	= f2fs_get_context,
-	.set_context	= f2fs_set_context,
-	.dummy_context	= f2fs_dummy_context,
-	.empty_dir	= f2fs_empty_dir,
-	.max_namelen	= F2FS_NAME_LEN,
+	.key_prefix		= "f2fs:",
+	.get_context		= f2fs_get_context,
+	.set_context		= f2fs_set_context,
+	.dummy_context		= f2fs_dummy_context,
+	.empty_dir		= f2fs_empty_dir,
+	.max_namelen		= F2FS_NAME_LEN,
+	.has_stable_inodes	= f2fs_has_stable_inodes,
+	.get_ino_and_lblk_bits	= f2fs_get_ino_and_lblk_bits,
 };
 #endif
 
-- 
2.23.0.866.gb869b98d4c-goog

