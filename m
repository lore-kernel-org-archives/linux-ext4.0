Return-Path: <SRS0=eYnO=RX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11261C10F05
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 18:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF3CF218A3
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553107216;
	bh=VLKOyjiTo4zNBcYy+Dh3fGC61v1rZeuQPK7QsXfa/kc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=SGHZLepMqHi4JX+CUHHcklPeWw3HTLqn2HUmPk/QhyF6b93KsPUUmYEltgoPZNnjw
	 bAMGYiC4ErVFCs/8CQKgfOmrlr+y7ybf1hnOVY/EAV4L7lV6RUcD7OhizE8RnIAM55
	 wKGoOML4Nc8AtB/K6p6KmWzb8TQ06W6hHRbFCGt4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfCTSkP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbfCTSkP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Mar 2019 14:40:15 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F812146E;
        Wed, 20 Mar 2019 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553107213;
        bh=VLKOyjiTo4zNBcYy+Dh3fGC61v1rZeuQPK7QsXfa/kc=;
        h=From:To:Cc:Subject:Date:From;
        b=kCLPwNsxKjBi1Cf0dZQ8mzosH4wpgpoPRGZIiZ+TJq67qp1EPXw1oJEkLwXC7Qy49
         o8DMUYha//gs3Z1TECuZ2GWGWH11EH2+btPL8IFsMzjiFOgFr+4sNO/3s6MQB+tZkg
         sTY06QYUuiNmrpsIfnD+6V52mI/AEtWWDfsTXja8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH v2 0/5] fscrypt: d_revalidate fixes and cleanups
Date:   Wed, 20 Mar 2019 11:39:08 -0700
Message-Id: <20190320183913.12686-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This patch series improves dentry revalidation in fscrypt.

To recap, fscrypt (aka ext4/f2fs/ubifs encryption) encrypts both file
contents and file names in individual directory trees.  A single
filesystem can contain many encrypted directory trees using many
different encryption keys.  Major users of fscrypt require the ability
to delete encrypted files when their encryption key is unavailable, e.g.
when the system needs to delete a removed user's home directory or free
up space from a logged-out user's cache directory.

Therefore fscrypt allows listing, looking up, and deleting files in
encrypted directories via encoded ciphertext names, but only before the
key is added.  After the key is added, the ciphertext names are
invalidated via ->d_revalidate() and plaintext names are shown instead.

fscrypt isn't a stacked filesystem, and it's explicitly for storage
encryption, not OS-level access control.  Thus, whether each directory
inode has its key or not is a global state, not per-process.  Also, the
inode keeps its key until it's evicted from the inode cache.  So,
plaintext names shouldn't ever get invalidated by ->d_revalidate().

This patch series makes the following improvements:

- Only assign ->d_revalidate() to ciphertext filenames, thus allowing
  overlayfs to use an fscrypt-encrypted upperdir in some cases.
  (Previous discussion: https://lkml.org/lkml/2019/3/13/255)

- Fix cases where plaintext filenames would wrongly be invalidated,
  including a real-world bug recently reported on Chromium OS.

- Fix cases where ciphertext filenames would wrongly not be invalidated.

- Allow rcu-walk lookups in encrypted directories with the key, which
  improves performance.
  (Previous attempt: https://patchwork.kernel.org/patch/10594133/)

- Fix cases where rename() and link() could succeed on ciphertext names.

Changed since v1:

- Fixed comment in fscrypt_d_revalidate() to explain that dget_parent()
  is actually still required.

- Moved clearing DCACHE_ENCRYPTED_NAME into fscrypt.h, to avoid an extra
  #ifdef and cluttering up dcache.c.

Eric Biggers (5):
  fscrypt: clean up and improve dentry revalidation
  fscrypt: fix race allowing rename() and link() of ciphertext dentries
  fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
  fscrypt: only set dentry_operations on ciphertext dentries
  fscrypt: fix race where ->lookup() marks plaintext dentry as
    ciphertext

 fs/crypto/crypto.c      | 58 ++++++++++++++++---------------
 fs/crypto/fname.c       |  1 +
 fs/crypto/hooks.c       | 28 ++++++++++-----
 fs/dcache.c             |  2 ++
 fs/ext4/ext4.h          | 62 +++++++++++++++++++++++++--------
 fs/ext4/namei.c         | 76 ++++++++++++++++++++++++++++-------------
 fs/f2fs/namei.c         | 17 +++++----
 fs/ubifs/dir.c          |  8 ++---
 include/linux/dcache.h  |  2 +-
 include/linux/fscrypt.h | 61 +++++++++++++++++++++++----------
 10 files changed, 208 insertions(+), 107 deletions(-)

-- 
2.21.0.225.g810b269d1ac-goog

