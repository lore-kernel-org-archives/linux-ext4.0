Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA25C4321A
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C7C214AE
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556311543;
	bh=QBzsfd+MU5VtO+7hIbVdsXDNdbivvbWInMAeH9h0hHo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=i70f43UQ3l5MOzk1awmQpIUI0O4Ldr6z2UgT1KqSqQzAdVuV34zbiiq4ADZLB92NH
	 jv/p/F7Gt8g5YMClOCeog9Zwk4mcyv4tFelDfteWMAM/+dgbVGlXtTSmOsOFAhq8gS
	 Y+7+RiaMCb4zD+iZbhlLDIbxSqoYWVDT2t+3Bt4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfDZUpl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfDZUpl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 Apr 2019 16:45:41 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30C4D2084F;
        Fri, 26 Apr 2019 20:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556311539;
        bh=QBzsfd+MU5VtO+7hIbVdsXDNdbivvbWInMAeH9h0hHo=;
        h=From:To:Cc:Subject:Date:From;
        b=iNe0bkY5yOnxzpYoourHgxIUR4Db5Tzu1vlm5a2zsmJ4m8mFyuCdBA4H7y96+VSp2
         oAk/OcJXiUAqdxnHuL/ZQ0/5E42UGJ3tqOw80lzuhyA4v1uoiZiTLme+p1mYojKYWm
         xgDtT5E2ZcoT8+QXcp63C93yLN5SUXHeHgWkeCqQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [RFC PATCH 0/7] xfstests: verify fscrypt-encrypted contents and filenames
Date:   Fri, 26 Apr 2019 13:41:46 -0700
Message-Id: <20190426204153.101861-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

This series adds xfstests which verify that encrypted contents and
filenames on ext4 and f2fs are actually correct, i.e. that the
encryption uses the correct algorithms, keys, IVs, and padding amounts.
The new tests work by creating encrypted files, unmounting the
filesystem, reading the ciphertext from disk using dd and debugfs or
dump.f2fs, and then comparing it against ciphertext computed
independently by a new test program that implements the same algorithms.

These tests are important because:

- The whole point of file encryption is that the files are actually
  encrypted correctly on-disk.  Except for generic/399, current xfstests
  only tests the filesystem semantics, not the actual encryption.
  generic/399 only tests for incompressibility of encrypted file
  contents using one particular encryption setting, which isn't much.

- fscrypt now supports 4 main combinations of encryption settings,
  rather than 1 as it did originally.  This may be doubled to 8 soon
  (https://patchwork.kernel.org/patch/10908153/).  We should test all
  settings.  And without tests, even if the initial implementation is
  correct, breakage in one specific setting could go undetected.

- Though Linux's crypto API has self-tests, these only test the
  algorithms themselves, not how they are used, e.g. by fscrypt.

Patch 1 is a cleanup patch.  Patches 2-4 add the common helpers for
ciphertext verification tests.  Patches 5-7 add the actual tests.

These tests require e2fsprogs and f2fs-tools patches I recently sent out
to fix printing encrypted filenames.  So, this series might not be
suitable for merging into mainline xfstests until those patches are
applied.  Regardless, comments are appreciated.  The needed patches are:

	debugfs: avoid ambiguity when printing filenames (https://marc.info/?l=linux-ext4&m=155596495624232&w=2)
	f2fs-tools: improve filename printing (https://sourceforge.net/p/linux-f2fs/mailman/message/36648641/)

This series can also be retrieved from git at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
branch "ciphertext-verification".

I also have patches on top of this series which verify the ciphertext
produced from v2 encryption policies, which are proposed by my kernel
patch series "fscrypt: key management improvements"
(https://patchwork.kernel.org/cover/10908107/).  v2 encryption policies
will use a different key derivation function, and thus their ciphertext
will be different.  These additional patches can be found at branch
"fscrypt-key-mgmt-improvements" of my git repo above.  But I've arranged
things such that this shorter series can potentially be applied earlier,
to test what's in the kernel now.

Eric Biggers (7):
  common/encrypt: introduce helpers for set_encpolicy and get_encpolicy
  fscrypt-crypt-util: add utility for reproducing fscrypt encrypted data
  common/encrypt: support requiring other encryption settings
  common/encrypt: add helper for ciphertext verification tests
  generic: verify ciphertext of v1 encryption policies with AES-256
  generic: verify ciphertext of v1 encryption policies with AES-128
  generic: verify ciphertext of v1 encryption policies with Adiantum

 .gitignore               |    1 +
 common/encrypt           |  482 ++++++++++-
 src/Makefile             |    3 +-
 src/fscrypt-crypt-util.c | 1645 ++++++++++++++++++++++++++++++++++++++
 tests/ext4/024           |    3 +-
 tests/generic/395        |   28 +-
 tests/generic/395.out    |    2 +-
 tests/generic/396        |   15 +-
 tests/generic/397        |    3 +-
 tests/generic/398        |    5 +-
 tests/generic/399        |    3 +-
 tests/generic/419        |    3 +-
 tests/generic/421        |    3 +-
 tests/generic/429        |    3 +-
 tests/generic/435        |    3 +-
 tests/generic/440        |    5 +-
 tests/generic/700        |   41 +
 tests/generic/700.out    |    5 +
 tests/generic/701        |   41 +
 tests/generic/701.out    |    5 +
 tests/generic/702        |   43 +
 tests/generic/702.out    |   10 +
 tests/generic/group      |    3 +
 23 files changed, 2308 insertions(+), 47 deletions(-)
 create mode 100644 src/fscrypt-crypt-util.c
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out
 create mode 100755 tests/generic/701
 create mode 100644 tests/generic/701.out
 create mode 100755 tests/generic/702
 create mode 100644 tests/generic/702.out

-- 
2.21.0.593.g511ec345e18-goog

