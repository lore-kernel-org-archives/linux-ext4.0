Return-Path: <SRS0=0Mrb=TB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C13C04AA9
	for <linux-ext4@archiver.kernel.org>; Wed,  1 May 2019 22:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFD1E2075E
	for <linux-ext4@archiver.kernel.org>; Wed,  1 May 2019 22:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556750788;
	bh=oGYtn9WG6er+4eiwYl5cJh2irdpTYgDLIblN4GE18gE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=d2NkK9CYR+Q0RINpfoDtMZ8u7DC5cxkXda9NNXfFjZ0fm8ZMHd8ltKJ/xe42+myyD
	 Al1YzFglthGpz9CgAKbU9CqbMTT9eK7wnGA9p5JiIi4/f0oC4bL4+Mheojqnb1D/9X
	 pEix4thNB2PgiaQzD+9FCRopIHTJRnHfILZ+gcrY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfEAWqG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 1 May 2019 18:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfEAWqG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 1 May 2019 18:46:06 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA3792075E;
        Wed,  1 May 2019 22:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556750765;
        bh=oGYtn9WG6er+4eiwYl5cJh2irdpTYgDLIblN4GE18gE=;
        h=From:To:Cc:Subject:Date:From;
        b=fY4qq9BAopEMgbyNEunjj+aef9mfWckZY+TJ4tM2F9Yms7jKNXtspSCI4MTU8zXaG
         b7538Lqq4jiQWV0QrHpbaVi5BTg05KPbB0pix79PFbPT1Ve17AUnOmS6V4Qt4lmAqB
         G2UwnTy2ET1YrFL8yY0aMeRi7tzVGJLjHvgWyWxA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH 00/13] fscrypt, ext4: prepare for blocksize != PAGE_SIZE
Date:   Wed,  1 May 2019 15:45:02 -0700
Message-Id: <20190501224515.43059-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

This patch series prepares fs/crypto/, and partially ext4, for the
'blocksize != PAGE_SIZE' case.

This basically contains the encryption changes from Chandan Rajendra's
patch series "[V2,00/13] Consolidate FS read I/O callbacks code"
(https://patchwork.kernel.org/project/linux-fscrypt/list/?series=111039)
that don't require introducing the read_callbacks and don't depend on
fsverity stuff.  But they've been reworked to clean things up a lot.

I propose that to move things forward for ext4 encryption with
'blocksize != PAGE_SIZE', we apply this series (or something similar) to
the fscrypt tree for 5.3 on its own merits.  Then the read_callbacks
series on top of it will much smaller and easier to review.

AFAIK, after this series the only thing stopping ext4 encryption from
working with blocksize != PAGE_SIZE is the lack of encryption support in
block_read_full_page(), which the read_callbacks will address.

This series applies to the fscrypt tree, and it can also be retrieved
from git at https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
branch "fscrypt-subpage-blocks-prep".

Chandan Rajendra (3):
  ext4: clear BH_Uptodate flag on decryption error
  ext4: decrypt only the needed blocks in ext4_block_write_begin()
  ext4: decrypt only the needed block in __ext4_block_zero_page_range()

Eric Biggers (10):
  fscrypt: simplify bounce page handling
  fscrypt: remove the "write" part of struct fscrypt_ctx
  fscrypt: rename fscrypt_do_page_crypto() to fscrypt_crypt_block()
  fscrypt: clean up some BUG_ON()s in block encryption/decryption
  fscrypt: introduce fscrypt_encrypt_block_inplace()
  fscrypt: support encrypting multiple filesystem blocks per page
  fscrypt: handle blocksize < PAGE_SIZE in fscrypt_zeroout_range()
  fscrypt: introduce fscrypt_decrypt_block_inplace()
  fscrypt: support decrypting multiple filesystem blocks per page
  ext4: encrypt only up to last block in ext4_bio_write_page()

 fs/crypto/bio.c             |  73 +++------
 fs/crypto/crypto.c          | 299 ++++++++++++++++++++----------------
 fs/crypto/fscrypt_private.h |  14 +-
 fs/ext4/inode.c             |  35 +++--
 fs/ext4/page-io.c           |  44 +++---
 fs/f2fs/data.c              |  17 +-
 fs/ubifs/crypto.c           |  19 +--
 include/linux/fscrypt.h     |  96 ++++++++----
 8 files changed, 319 insertions(+), 278 deletions(-)

-- 
2.21.0.593.g511ec345e18-goog

