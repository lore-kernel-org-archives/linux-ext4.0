From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/5] meta_bg online resize patches
Date: Sun,  2 Sep 2012 00:51:20 -0400
Message-ID: <1346561485-6413-1-git-send-email-tytso@mit.edu>
Cc: xiaoqiangnk@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48374 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2IBHgi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Sep 2012 03:36:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series is based on a set of patches from Yongqiang Yang, with
some bug fixes.  In particular, we have to grow certain arrays which are
allocated at mount time.  Originally, they were allocated to be big
enough to cover the largest possible size they could be given the number
of reserved gdt blocks.  This wasted memory and doesn't work in the
meta_bg scheme, since there is no limit imposed at mkfs time.

Theodore Ts'o (2):
  ext4: grow the s_flex_groups array as needed when resizing
  ext4: grow the s_group_info array as needed

Yongqiang Yang (3):
  ext4: when resizing, do not copy gdt blocks for groups that do not
    have them
  ext4: avoid duplicate writes of the backup bg descriptor blocks
  ext4: add online resizing support for meta_bg and bit64

 fs/ext4/ext4.h    |   6 ++
 fs/ext4/ioctl.c   |  15 ----
 fs/ext4/mballoc.c |  79 +++++++++--------
 fs/ext4/resize.c  | 249 ++++++++++++++++++++++++++++++++++++++++--------------
 fs/ext4/super.c   |  48 ++++++++---
 5 files changed, 267 insertions(+), 130 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

