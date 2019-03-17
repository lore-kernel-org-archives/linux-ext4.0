Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22019C10F05
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30E921871
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552853235;
	bh=RFKQxI9t4mNy+XnhJS/exqAldMOtCTqbOtaw+MeWgvU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=O8qEIp93jWYLBMIpKvPVjVQ5uDQP1SfL7l3cWNVGlD1SMB2zwyusmHURHU/p66EDO
	 leOeYd/LXkaw9+wpzKj2YTI3uFRQIfZmfIVbsU2vX5rAwoTU5YyHRBzOSZwWVsV0m0
	 1LNuC56hUoEfghnb4o9y9QqP1tlRqBRX/NoArUrQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfCQUHN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 16:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbfCQUHN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Mar 2019 16:07:13 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B4EE20896;
        Sun, 17 Mar 2019 20:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552853232;
        bh=RFKQxI9t4mNy+XnhJS/exqAldMOtCTqbOtaw+MeWgvU=;
        h=From:To:Cc:Subject:Date:From;
        b=hPTmWATgDPoXkE3IkIQbrPsG9wTYN7583dYOqpl9HyGgMt1IuLtrRqcBOvn0TUjfJ
         9a/QZPPUylcNLz9gY42rxgbiUOrybK+nqE5jmydUxcSwVyDvnwZ1SaQmpH6pUS4sSJ
         TMfnFgRiQNKgkpBD4T4uJsm2PwFBm/TlWBfqgBmI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 0/5] fscrypt: d_revalidate fixes and cleanups
Date:   Sun, 17 Mar 2019 13:04:39 -0700
Message-Id: <20190317200444.5967-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

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

Eric Biggers (5):
  fscrypt: clean up and improve dentry revalidation
  fscrypt: fix race allowing rename() and link() of ciphertext dentries
  fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
  fscrypt: only set dentry_operations on ciphertext dentries
  fscrypt: fix race where ->lookup() marks plaintext dentry as
    ciphertext

 fs/crypto/crypto.c      | 54 ++++++++++++++---------------
 fs/crypto/fname.c       |  1 +
 fs/crypto/hooks.c       | 28 ++++++++++-----
 fs/dcache.c             | 15 ++++++++
 fs/ext4/ext4.h          | 62 +++++++++++++++++++++++++--------
 fs/ext4/namei.c         | 76 ++++++++++++++++++++++++++++-------------
 fs/f2fs/namei.c         | 17 +++++----
 fs/ubifs/dir.c          |  8 ++---
 include/linux/dcache.h  |  2 +-
 include/linux/fscrypt.h | 46 ++++++++++++++-----------
 10 files changed, 200 insertions(+), 109 deletions(-)

-- 
2.21.0

