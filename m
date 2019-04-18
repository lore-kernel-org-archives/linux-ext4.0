Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3285BC282DD
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB35217D7
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 23:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555630260;
	bh=jDLSY/OOLsG9Va5rtdxzZbQXYJoDj9HGpBLFE0rB7to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OpVwkgsBPC0t0THAHaHYs/M+QdMjIAfNTBpS3bUUnGvnwXRMO4Qc+aHCgeF18wEvI
	 A++BKaE8fAofOXraaxDhDkUs3IfCRj5hN8mR8PKoBVo5TnDg8EI4a27UTU7uq3lKMG
	 1RVV2ZdT7HVMCuUfuBde/91eIeE9BLDcx3ktyaL4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfDRXa6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 19:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfDRXa1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 19:30:27 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 216952183F;
        Thu, 18 Apr 2019 23:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555630226;
        bh=jDLSY/OOLsG9Va5rtdxzZbQXYJoDj9HGpBLFE0rB7to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmekEdFAwhCunnHUMrJIEVO+isdg6P1RbKu2iCaZWe1wkPqRAVcsiYW3pornO4XLm
         KFo7Xg6xWIBRwc0tHCyd/R4E8mrrIUq2fAdnBg2iRTsEZ6P8KXj/cB1k+enrupKpkn
         iSpMfDK+ZQPCk6F4/tIhqPefx9iyHP35m6cKSSlM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v5 04/16] fscrypt: add ->ci_inode to fscrypt_info
Date:   Thu, 18 Apr 2019 16:29:11 -0700
Message-Id: <20190418232923.250800-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190418232923.250800-1-ebiggers@kernel.org>
References: <20190418232923.250800-1-ebiggers@kernel.org>
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
index 16349894ef91d..ed253262b0195 100644
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
2.21.0.392.gf8f6787159e-goog

