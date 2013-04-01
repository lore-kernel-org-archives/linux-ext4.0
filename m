From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/4] e2fsprogs: fix off-line resizing of small ext4 file systems
Date: Sun, 31 Mar 2013 20:43:59 -0400
Message-ID: <1364777043-20610-1-git-send-email-tytso@mit.edu>
References: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
Cc: john.jolly@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57582 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab3DAAoK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Mar 2013 20:44:10 -0400
In-Reply-To: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes the reported failure when resizing an ext4 file system which
started out a as a very small file system, which is then resizied to a
very big file system.  I've also added 5 more resize2fs tests to the
e2fsprogs regression test suite.

Theodore Ts'o (4):
  resize2fs: fix off-line resize of file systems with flex_bg &&
    !resize_inode
  mke2fs: don't display bigalloc/quota fs feature warnings in quiet
    mode
  tests: create crcsum progam to support resizing tests
  tests: add more tests for off-line resizing

 misc/mke2fs.c                      |   6 +-
 resize/resize2fs.c                 |  58 ++++++++++++----
 tests/progs/Makefile.in            |   6 +-
 tests/progs/crcsum.c               |  70 +++++++++++++++++++
 tests/r_1024_small_bg/script       |  27 +++++++
 tests/r_64bit_big_expand/script    |  27 +++++++
 tests/r_bigalloc_big_expand/script |  27 +++++++
 tests/r_ext4_big_expand/script     |  27 +++++++
 tests/r_ext4_small_bg/script       |  27 +++++++
 tests/scripts/resize_test          | 139 +++++++++++++++++++++++++++++++++++++
 tests/test_config                  |   1 +
 11 files changed, 399 insertions(+), 16 deletions(-)
 create mode 100644 tests/progs/crcsum.c
 create mode 100644 tests/r_1024_small_bg/script
 create mode 100644 tests/r_64bit_big_expand/script
 create mode 100644 tests/r_bigalloc_big_expand/script
 create mode 100644 tests/r_ext4_big_expand/script
 create mode 100644 tests/r_ext4_small_bg/script
 create mode 100755 tests/scripts/resize_test

-- 
1.7.12.rc0.22.gcdd159b

