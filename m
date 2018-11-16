Return-Path: <SRS0=OKzU=N3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38101 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389430AbeKPXCQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Nov 2018 18:02:16 -0500
Received: by mail-pl1-f194.google.com with SMTP id e5so1115208plb.5
        for <linux-ext4@vger.kernel.org>; Fri, 16 Nov 2018 04:50:01 -0800 (PST)
From: Eiichi Tsukata <devel@etsukata.com>
To: andi@firstfloor.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Eiichi Tsukata <devel@etsukata.com>
Subject: [RFC PATCH 0/1] fs: fix race between llseek SEEK_END and write
Date: Fri, 16 Nov 2018 17:37:36 +0900
Message-Id: <20181116083737.10596-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Some file systems (including ext4, xfs, ramfs ...) have the following
problem as I've described in the commit message of the sample patch
[PATCH 1/1] for ext4.

  The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
  removed almost all locks in llseek() including SEEK_END. It based on the
  idea that write() updates size atomically. But in fact, write() can be
  divided into two or more parts in generic_perform_write() when pos
  straddles over the PAGE_SIZE, which results in updating size multiple
  times in one write(). It means that llseek() can see the size being
  updated during write().

  This race changes behavior of some applications. 'tail' is one of those
  applications. It reads range [pos, pos_end] where pos_end is obtained
  via llseek() SEEK_END. Sometimes, a read line could be broken.

  reproducer:

    $ while true; do echo 123456 >> out; done
    $ while true; do tail out | grep -v 123456 ; done

  example output(take 30 secs):

    12345
    1
    1234
    1
    12
    1234

Note: Some file systems which indivisually implements llseek() and hold
      inode mutex lock in it are not affected. ex:) btrfs, ocfs2


I would like to ask you the following questions;

Q1. Do you consider this behavior as a bug in kernel?
    or userspace applications are responseible for it?

Q2. If it is a bug, how should we fix it?

Currently I'm planning to re-introduce generic_file_llseek_unlocked()
and inode lock in generic_file_llseek() for SEEK_END. Then replace
generic_file_llseek() with generic_file_llseek_unlocked() if it called
with inode lock in individual file systems. Please let me know if the
way is not appropreate or any other better way to fix it.

Thanks

Eiichi Tsukata (1):
  ext4: fix race between llseek SEEK_END and write

 fs/ext4/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
2.19.1
