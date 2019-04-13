Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BA8C282CE
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 19:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC9E12147A
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 19:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfDMTZk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 15:25:40 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39176 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfDMTZk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 15:25:40 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 7EF29260F25
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v7 00/10] Ext4 case-insensitive support
Date:   Sat, 13 Apr 2019 15:25:23 -0400
Message-Id: <20190413192533.2549-1-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ted,

This is the v7 of the case-insensitive support.  It includes the design
changes we discussed, unicode 12.0 support, and the Linus' request about
the way we store the utf8data.h file.

* We no longer generate utf8data.h during build time.  Instead, it is
added to the tree with instructions on how to generate it.

* Integrate your modifications to README.utf8data.

* Directories without the Casefold inode attribute are no longer
  normalized.

* Update to Unicode 12.0

* Fixes 0day/sparse issues reported against the last version.

* Remove sign-off from Olaf Weber on patch 01 modified by me.  I was
  thinking about this since the last series.  I cannot assume Olaf's
  signoff on patch 01/10, since it changed too much, so make sure he
  keeps the credit and copyright for the script, but drop his
  signoff on the certificate of origin.

* i didn't commented ou t the normalization bits because it is being
  tested by utf8-selftest, so I'm not sure if we should remove
  everything already.  Also, utf8data.h will not get much smaller
  without it.

I suspect the patches adding/modifying utf8data.h might bounce in the
mailing list.  If that is the case, you can find the series at:

  https://gitlab.collabora.com/krisman/linux.git -b ext4-ci-directory-no-nls_v7

You can also find the e2fsprogs latest fixes, that I am proposing on a
different thread, and which is required to support the current patchset at:

  https://gitlab.collabora.com/krisman/e2fsprogs.git -b casefold-feature

As usual, I am testing this with xfstests:

  https://gitlab.collabora.com/krisman/xfstests.git -b casefold-test

(generic/484 and generic/485 in that repository)

Please, let me know what you think.

Gabriel Krisman Bertazi (8):
  unicode: Introduce UTF-8 character database
  unicode: Implement higher level API for string handling
  unicode: Introduce test module for normalized utf8 implementation
  unicode: Update unicode database unicode version 12.0.0
  MAINTAINERS: Add Unicode subsystem entry
  ext4: Include encoding information in the superblock
  ext4: Support case-insensitive file name lookups
  docs: ext4.rst: Document case-insensitive directories

Olaf Weber (2):
  unicode: Introduce code for UTF-8 normalization
  unicode: reduce the size of utf8data[]

 Documentation/admin-guide/ext4.rst |   38 +
 MAINTAINERS                        |    6 +
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/ext4/dir.c                      |   48 +
 fs/ext4/ext4.h                     |   42 +-
 fs/ext4/hash.c                     |   34 +-
 fs/ext4/ialloc.c                   |    2 +-
 fs/ext4/inline.c                   |    2 +-
 fs/ext4/inode.c                    |    4 +-
 fs/ext4/ioctl.c                    |   18 +
 fs/ext4/namei.c                    |  107 +-
 fs/ext4/super.c                    |   91 +
 fs/unicode/Kconfig                 |   13 +
 fs/unicode/Makefile                |   19 +
 fs/unicode/README.utf8data         |   57 +
 fs/unicode/utf8-core.c             |  187 ++
 fs/unicode/utf8-norm.c             |  799 ++++++
 fs/unicode/utf8-selftest.c         |  320 +++
 fs/unicode/utf8data.h              | 4106 ++++++++++++++++++++++++++++
 fs/unicode/utf8n.h                 |  117 +
 include/linux/fs.h                 |    2 +
 include/linux/unicode.h            |   30 +
 scripts/Makefile                   |    1 +
 scripts/mkutf8data.c               | 3418 +++++++++++++++++++++++
 25 files changed, 9441 insertions(+), 22 deletions(-)
 create mode 100644 fs/unicode/Kconfig
 create mode 100644 fs/unicode/Makefile
 create mode 100644 fs/unicode/README.utf8data
 create mode 100644 fs/unicode/utf8-core.c
 create mode 100644 fs/unicode/utf8-norm.c
 create mode 100644 fs/unicode/utf8-selftest.c
 create mode 100644 fs/unicode/utf8data.h
 create mode 100644 fs/unicode/utf8n.h
 create mode 100644 include/linux/unicode.h
 create mode 100644 scripts/mkutf8data.c

-- 
2.20.1

