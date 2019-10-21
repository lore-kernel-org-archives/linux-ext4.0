Return-Path: <SRS0=b1z3=YO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B79CA9EB0
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 23:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF7852173B
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 23:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571699243;
	bh=Pe7Lis/ulx8/IwkmeLuv53LKYhthEU3xhU7qcvrWXZ8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=t1ePadhm8ONPHvf7SB3vlFTTGVZ0fY+KUTd7M2w4mUigOqftfC5NDADrIGojySr1n
	 JV8NIf/6UQ9eHJSh+wUFDfoUxUX17/hDi8HVzKsTRLNDQR2hEOFWkRUlvbeyqSUbTa
	 cmfYlOXjzQyHL/ip71IKErlJJy4WCGX95O06P40M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfJUXHX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Oct 2019 19:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbfJUXHX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Oct 2019 19:07:23 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C812F2086D;
        Mon, 21 Oct 2019 23:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571699242;
        bh=Pe7Lis/ulx8/IwkmeLuv53LKYhthEU3xhU7qcvrWXZ8=;
        h=From:To:Cc:Subject:Date:From;
        b=KFqCookuLvhUWmmwBtVb2etKPO0Oto0GcX9cwodQRQNs2/xlaPbje2qinGny1YdhG
         34Z6+AuL/AuHZ/lDvAKibQh0ft7asFQOQiIoMfRwwMVndg90X1oJg9z7TTsgGx/cQ9
         3FPe8cmn2ZRnZyEzQrXJ9OGqx45lrhuB5zRNyYLI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 0/3] fscrypt: support for inline-encryption-optimized policies
Date:   Mon, 21 Oct 2019 16:03:52 -0700
Message-Id: <20191021230355.23136-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

In preparation for adding inline encryption support to fscrypt, this
patchset adds a new fscrypt policy flag which modifies the encryption to
be optimized for inline encryption hardware compliant with the UFS
standard --- specifically, to use a smaller number of keys while still
using at most 64 IV bits.  This required adding the inode number to the
IVs.  For ext4, this precludes filesystem shrinking, so I've also added
a compat feature which will prevent the filesystem from being shrunk.

I've separated this from the full "Inline Encryption Support" patchset
(https://lkml.kernel.org/linux-fsdevel/20190821075714.65140-1-satyat@google.com/)
to avoid conflating an implementation (inline encryption) with a new
on-disk format (INLINE_CRYPT_OPTIMIZED).  This patchset purely adds
support for INLINE_CRYPT_OPTIMIZED policies to fscrypt, but implements
them using the existing filesystem layer crypto.

We're planning to make the *implementation* (filesystem layer or inline
crypto) be controlled by a mount option '-o inlinecrypt'.

This patchset applies to fscrypt.git#master and can also be retrieved from
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=inline-crypt-optimized-v1

A ciphertext verification test for INLINE_CRYPT_OPTIMIZED policies can
be found at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/log/?h=inline-encryption

Work-in-progress patches for the inline encryption implementation of
both INLINE_CRYPT_OPTIMIZED and regular policies can be found at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=inline-encryption-wip

Eric Biggers (3):
  fscrypt: add support for inline-encryption-optimized policies
  ext4: add support for INLINE_CRYPT_OPTIMIZED encryption policies
  f2fs: add support for INLINE_CRYPT_OPTIMIZED encryption policies

 Documentation/filesystems/fscrypt.rst | 53 +++++++++++++++++++--------
 fs/crypto/crypto.c                    | 11 +++++-
 fs/crypto/fscrypt_private.h           | 20 +++++++---
 fs/crypto/keyring.c                   |  6 ++-
 fs/crypto/keysetup.c                  | 47 +++++++++++++++++++-----
 fs/crypto/policy.c                    | 42 ++++++++++++++++++++-
 fs/ext4/ext4.h                        |  2 +
 fs/ext4/super.c                       | 14 +++++++
 fs/f2fs/super.c                       | 26 ++++++++++---
 include/linux/fscrypt.h               |  3 ++
 include/uapi/linux/fscrypt.h          | 15 ++++----
 11 files changed, 191 insertions(+), 48 deletions(-)

-- 
2.23.0.866.gb869b98d4c-goog

