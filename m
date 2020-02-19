Return-Path: <SRS0=KVWg=4H=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185BBC34056
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Feb 2020 18:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E361124673
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Feb 2020 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582137098;
	bh=+9rV1rTbSqZbmZ/q4Acs7priEwLHNZ3sWI1yMh4pPv4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=UFUs2ch8TSrcl68pweaf76Cqh4MgYlHmvFsqVuuaT4adPTHF0csZXRTOMaH43ZOVW
	 300evBkMOeZPIULt79GUVKq360xnNJbUKfeNCG6s1BoL+cvxMFRcfyqikwFX7YgEqr
	 z6U4i7qKB63p3DQS8e3Lwx5Y2pzpNsnE4u+z0TIo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBSSbh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 19 Feb 2020 13:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgBSSbh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Feb 2020 13:31:37 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC30E20801;
        Wed, 19 Feb 2020 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582137096;
        bh=+9rV1rTbSqZbmZ/q4Acs7priEwLHNZ3sWI1yMh4pPv4=;
        h=From:To:Cc:Subject:Date:From;
        b=ZG4s6S4njne0k+Fym+OOgokdL6XuFV7Vi3IDSw8V01gCXGYNIDvAoyAjuj7kAjMK/
         F3oNzMpNkVnhcTd5QGvBGmsUC6lGj1F78ncu3b7Gabp1AjBUIVfA1HAN8W15oXlXen
         DXD7B7n8x4mtms4rNSjXqGfx116p4jdr3RcGzYAk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>
Subject: [PATCH v3 0/2] ext4: fix race between writepages and enabling EXT4_EXTENTS_FL
Date:   Wed, 19 Feb 2020 10:30:45 -0800
Message-Id: <20200219183047.47417-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This series fixes a race between writepages and enabling EXT4_EXTENTS_FL
that could cause a WARN_ON() in ext4_add_complete_io() to be hit.  Patch
1 is a trivial renaming in preparation for patch 2 which is the actual
fix.  See patch 2 for the full details.

Changed in v3:
    Do the renaming in a separate patch.

Changed in v2:
    Instead of making ext4_writepages() read EXT4_EXTENTS_FL only once,
    make it so that EXT4_EXTENTS_FL can't be changed while
    ext4_writepages() is running.

Eric Biggers (2):
  ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
  ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

 fs/ext4/ext4.h    |  7 +++++--
 fs/ext4/inode.c   | 14 +++++++-------
 fs/ext4/migrate.c | 27 +++++++++++++++++++--------
 fs/ext4/super.c   |  6 +++---
 4 files changed, 34 insertions(+), 20 deletions(-)


base-commit: c96dceeabf765d0b1b1f29c3bf50a5c01315b820
-- 
2.25.0

