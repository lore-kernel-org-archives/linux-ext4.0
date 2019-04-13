Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D0AC10F11
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0886F20850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbfDMFnY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:24 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37474 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfDMFnY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:24 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 99525281C30
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 00/10] case-insensitive feature updates
Date:   Sat, 13 Apr 2019 01:43:07 -0400
Message-Id: <20190413054317.7388-1-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

The following patches fix a few bugs on the case-insensitive
implementation on e2fsprogs, update to unicode 12.0 and implement the
design decision of not normalizing file names on directories without the
Casefold attribute.

Gabriel Krisman Bertazi (10):
  e2p: encoding: Fix default flags lookup
  ext2fs: Always attempt to load nls table when loading the filesystem
  ext2fs: nls: Convert NFKD -> NFD
  ext2fs: nls: Fix potential null dereference in utf8nlookup
  ext2fs: nls: Merge sparse fixes from the kernel version
  ext2fs: nls: Update to unicode 12.0.0
  ext2fs: Don't normalize names on -F directories
  ext2fs: nls: Drop normalization code
  ext2fs: nls: Drop ascii NLS support
  ext4.5.in: Document design changes on the casefold attribute

 e2fsck/unix.c              |   12 +-
 lib/e2p/encoding.c         |   12 +-
 lib/ext2fs/Makefile.in     |    5 +-
 lib/ext2fs/dirhash.c       |    8 +-
 lib/ext2fs/ext2_fs.h       |    5 +-
 lib/ext2fs/initialize.c    |    4 +
 lib/ext2fs/nls.h           |   10 +-
 lib/ext2fs/nls_ascii.c     |   68 -
 lib/ext2fs/nls_utf8-norm.c |   26 +-
 lib/ext2fs/nls_utf8.c      |   37 +-
 lib/ext2fs/openfs.c        |    4 +
 lib/ext2fs/utf8data.h      | 8889 ++++++++++++++----------------------
 lib/ext2fs/utf8n.h         |   14 +-
 misc/ext4.5.in             |   10 +-
 14 files changed, 3508 insertions(+), 5596 deletions(-)
 delete mode 100644 lib/ext2fs/nls_ascii.c

-- 
2.20.1

