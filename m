Return-Path: <SRS0=bKTL=4L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA38C35670
	for <linux-ext4@archiver.kernel.org>; Sun, 23 Feb 2020 03:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C938F206D7
	for <linux-ext4@archiver.kernel.org>; Sun, 23 Feb 2020 03:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgBWDl7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 22 Feb 2020 22:41:59 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60312 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726965AbgBWDl7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Feb 2020 22:41:59 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01N3fquG031252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 22 Feb 2020 22:41:54 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 769B34211EF; Sat, 22 Feb 2020 22:41:52 -0500 (EST)
Date:   Sat, 22 Feb 2020 22:41:52 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     torvalds@linux-foundation.org
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 5.6-rc2
Message-ID: <20200223034152.GA1035793@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The following changes since commit 11a48a5a18c63fd7621bb050228cebf13566e4d8:

  Linux 5.6-rc2 (2020-02-16 13:16:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 9db176bceb5c5df4990486709da386edadc6bd1d:

  ext4: fix mount failure with quota configured as module (2020-02-21 19:32:07 -0500)

----------------------------------------------------------------
More miscellaneous ext4 bug fixes (all stable fodder)

----------------------------------------------------------------
Eric Biggers (2):
      ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
      ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

Jan Kara (1):
      ext4: fix mount failure with quota configured as module

Qian Cai (1):
      ext4: fix a data race in EXT4_I(inode)->i_disksize

Shijie Luo (1):
      ext4: add cond_resched() to __ext4_find_entry()

Suraj Jitindar Singh (2):
      ext4: fix potential race between s_group_info online resizing and access
      ext4: fix potential race between s_flex_groups online resizing and access

Theodore Ts'o (1):
      ext4: fix potential race between online resizing and write operations

wangyan (1):
      jbd2: fix ocfs2 corrupt when clearing block group bits

 fs/ext4/balloc.c      |  14 ++++++++--
 fs/ext4/ext4.h        |  39 ++++++++++++++++++++------
 fs/ext4/ialloc.c      |  23 +++++++++------
 fs/ext4/inode.c       |  16 +++++------
 fs/ext4/mballoc.c     |  61 +++++++++++++++++++++++++++-------------
 fs/ext4/migrate.c     |  27 ++++++++++++------
 fs/ext4/namei.c       |   1 +
 fs/ext4/resize.c      |  62 ++++++++++++++++++++++++++++++++---------
 fs/ext4/super.c       | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 fs/jbd2/transaction.c |   8 ++++--
 10 files changed, 256 insertions(+), 108 deletions(-)
