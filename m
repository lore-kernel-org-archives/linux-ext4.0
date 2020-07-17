Return-Path: <SRS0=xKa7=A4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42DAC433DF
	for <linux-ext4@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B59420578
	for <linux-ext4@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ELjLl7Vq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGQBf0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbgGQBf0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2020 21:35:26 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDFCC08C5C0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2020 18:35:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id jx16so6664739pjb.6
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2020 18:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=h180B5pNtOzbYEBjxwcBboRvZXlnjHO7g27S8UvB6u4=;
        b=ELjLl7Vq6Wv4yY35k8D7laIay5mUyA/mDCmNF9Y1UHm5Y/76WtJYAx/iugkyBLF7xL
         GPzIpQBTNRdUkcwnTw16m3C/jktVdbDVOzDbrKhs0XGRaNER0yp5a66lsqLyTMmDIqFJ
         BPQipZO3XktDJp/JrC6s4XmrPO+gGjjHsu5KQjaejvnFaUEEX9Luv8ycJFfHJMftrANR
         6q5sXf1ZWpq/YRNvt4MytlDsV1dYyjoFmUbioMPgqjxclH836oYFThFc7cRj+fH9nAg1
         PAwPX4vN/DarheFPwZnuT8LeMWDFGCnK/ZoXfa6SN8C6eFmmecCMrY3h9ezuXyQG/P5I
         s7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=h180B5pNtOzbYEBjxwcBboRvZXlnjHO7g27S8UvB6u4=;
        b=oaLk4LvwiEf1Dn8dlK/R21QhtdqKnAzimCRVCeRvcrSAnw/o8Gh2l13gwDYGm4yeYw
         Rlm/2oAGJQ0ymUmdOTK00C9PCe5aGxAzzy8+m9zSM0bwzLBL6MdVZ7dCiOm3hMrmIgIh
         NJhVh6FROB36moespINnwHl/SBJFnr+FaZD5bjqdvCP/2zU6LaG3ajxz/0JIfyeSF2MJ
         oj/FJsQyq6Yr9OutaNeINr7W7MsCtcE6u8U9j386AbvXnvQ4XXTeSBy6WlH4zGzv7bhI
         1zFfhuGdc/ZUqlS0xKBkFQIhKB9IKS9s/u6VpBPVR1YwhIE84egHQv+1R38v5wKKvt1K
         HIsQ==
X-Gm-Message-State: AOAM533KB0kqhyuLbNZmISBSGq+H3ejOXNNJLLKITx27lhi0qbqnIJ9D
        enycTCYReJXWRXgXn37N2uCnKseGYYE=
X-Google-Smtp-Source: ABdhPJxIB5ldsSrG0e2vKUueYLSna2DbzwU3Sw4Yr1VE1efQAldkODOjxiuQVxlsg1tjNG5UT5PMRTz+qHE=
X-Received: by 2002:a17:902:c402:: with SMTP id k2mr5492580plk.185.1594949725585;
 Thu, 16 Jul 2020 18:35:25 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:35:11 +0000
Message-Id: <20200717013518.59219-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2 0/7] add support for direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patch series adds support for direct I/O with fscrypt using
blk-crypto. It has been rebased on fscrypt/master.

Patch 1 adds two functions to fscrypt that need to be called to determine
if direct I/O is supported for a request.

Patches 2 and 3 wire up direct-io and iomap respectively with the functions
introduced in Patch 1 and set bio crypt contexts on bios when appropriate
by calling into fscrypt.

Patches 4 and 5 allow ext4 and f2fs direct I/O to support fscrypt without
falling back to buffered I/O.

Patches 6 and 7 update the fscrypt documentation for inline encryption
support and direct I/O. The documentation now notes the required conditions
for inline encryption and direct I/O on encrypted files.

This patch series was tested by running xfstests with test_dummy_encryption
with and without the 'inlinecrypt' mount option, and there were no
meaningful regressions. One regression was for generic/587 on ext4,
but that test isn't compatible with test_dummy_encryption in the first
place, and the test "incorrectly" passes without the 'inlinecrypt' mount
option - a patch will be sent out to exclude that test when
test_dummy_encryption is turned on with ext4 (like the other quota related
tests that use user visible quota files). The other regression was for
generic/252 on ext4, which does direct I/O with a buffer aligned to the
block device's blocksize, but not necessarily aligned to the filesystem's
block size, which direct I/O with fscrypt requires.

Eric Biggers (5):
  fscrypt: Add functions for direct I/O support
  direct-io: add support for fscrypt using blk-crypto
  iomap: support direct I/O with fscrypt using blk-crypto
  ext4: support direct I/O with fscrypt using blk-crypto
  f2fs: support direct I/O with fscrypt using blk-crypto

Satya Tangirala (2):
  fscrypt: document inline encryption support
  fscrypt: update documentation for direct I/O support

 Documentation/filesystems/fscrypt.rst | 36 +++++++++++-
 fs/crypto/crypto.c                    |  8 +++
 fs/crypto/inline_crypt.c              | 80 +++++++++++++++++++++++++++
 fs/direct-io.c                        | 15 ++++-
 fs/ext4/file.c                        | 10 ++--
 fs/f2fs/f2fs.h                        |  6 +-
 fs/iomap/direct-io.c                  |  8 +++
 include/linux/fscrypt.h               | 19 +++++++
 8 files changed, 173 insertions(+), 9 deletions(-)

-- 
2.28.0.rc0.105.gf9edc3c819-goog

