Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D45C10F0C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22DC12084C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554220148;
	bh=m6x57ZiDXqV2W7dMJhnPN12FN8cd+uR7GaniGWjkMyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vq7KwyzyWD9Wj4dvKuvv2huI22uX+SHT+en60LBquocIPapQSRtPDPNAztXwuU1p+
	 hdbxlCxAQeh7msABOWL5Qz1cWUd/QusIpO4B8vOwTN0cBLnKlqJnN5Tb2XyA1nUlyP
	 B7tq0Y1D0bAd49eCbWr7yqdscAmbbfcl4KDdqUUs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbfDBPsh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfDBPsd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 11:48:33 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 955792133D;
        Tue,  2 Apr 2019 15:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554220112;
        bh=m6x57ZiDXqV2W7dMJhnPN12FN8cd+uR7GaniGWjkMyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OU/3KKV5WZl8OtSW32Tx4N/NfbqtJROsulpDn25tSGPXxzLv01yTtYJs5yl3qljr
         0eYyYWl/B0D8Geo74s6U/bbSFYk0DZRlNZD6ar66b/mk8SL3ONcUstLmiQ8NEyT0U5
         acFIxhDxIPLlGU0/LiWBInTMBlNeMgr7I9OWFvdo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: [PATCH v4 04/17] fscrypt: add ->ci_inode to fscrypt_info
Date:   Tue,  2 Apr 2019 08:45:47 -0700
Message-Id: <20190402154600.32432-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190402154600.32432-1-ebiggers@kernel.org>
References: <20190402154600.32432-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add an inode back-pointer to 'struct fscrypt_info', such that
inode->i_crypt_info->ci_inode == inode.

This will be useful for:

1. Evicting the inodes when a fscrypt key is removed, since we'll track
   the inodes using a given key by linking their fscrypt_infos together,
   rather than the inodes directly.  This avoids bloating 'struct inode'
   with a new list_head.

2. Simplifying the per-file key setup, since the inode pointer won't
   have to be passed around everywhere just in case something goes wrong
   and it's needed for fscrypt_warn().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 3 +++
 fs/crypto/keyinfo.c         | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 52e09ef40bfa6..ac24edfc297f1 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -73,6 +73,9 @@ struct fscrypt_info {
 	 */
 	struct fscrypt_mode *ci_mode;
 
+	/* Back-pointer to the inode */
+	struct inode *ci_inode;
+
 	/*
 	 * If non-NULL, then this inode uses a master key directly rather than a
 	 * derived key, and ci_ctfm will equal ci_master_key->mk_ctfm.
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 058e2e0fda430..148a54fb556a6 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -542,6 +542,8 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	if (!crypt_info)
 		return -ENOMEM;
 
+	crypt_info->ci_inode = inode;
+
 	crypt_info->ci_flags = ctx.flags;
 	crypt_info->ci_data_mode = ctx.contents_encryption_mode;
 	crypt_info->ci_filename_mode = ctx.filenames_encryption_mode;
-- 
2.21.0

