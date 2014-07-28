From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 0/4 v3] e2fsprogs journal fixes (UUID and 1k block size issue)
Date: Mon, 28 Jul 2014 11:43:21 +0400
Message-ID: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Cc: tytso@mit.edu, darrick.wong@oracle.com, adilger@dilger.ca,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60834 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaG1Hnw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:43:52 -0400
Received: by mail-lb0-f176.google.com with SMTP id u10so5384055lbd.7
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 00:43:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is patchset with some fixes for journal code in e2fsprogs.
I've removed first patch from previous version "lib: add EXT2_ prefix for
SUPERBLOCK_{OFFSET,SIZE}", and rebase other patches on top of the maint branch.

I've tested it using "make check" and commands from commits.
I do want to add tests for this cases, but they requires some extra
capabilities (CAP_SYS_ADMIN for mount(2)), while right now tests don't have
such cases, if somebody have proposal how to do this tests without extra
mount(2) I will be happy to hear (for more info about possible test cases see
"tune2fs: update journal super block when changing UUID for fs." and "tune2fs:
update journal users while updating fs UUID (with external journal)")

Thanks.
Azat.

Azat Khuzhin (4):
  journal: use consts instead of 1024 and add helper for journal with 1k
    blocksize
  tune2fs: remove_journal_device(): use the correct block to find jsb
  tune2fs: update journal super block when changing UUID for fs.
  tune2fs: update journal users while updating fs UUID (with external
    journal)

 e2fsck/journal.c        |   5 +-
 lib/ext2fs/ext2fs.h     |   3 +
 lib/ext2fs/kernel-jbd.h |   6 +-
 lib/ext2fs/mkjournal.c  |  28 ++++----
 misc/tune2fs.c          | 166 +++++++++++++++++++++++++++++++++++++++++-------
 misc/uuidd.c            |   3 +-
 6 files changed, 171 insertions(+), 40 deletions(-)

-- 
2.0.1

